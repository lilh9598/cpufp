#define _GNU_SOURCE
#include "cpufp_kernel_aarch64.h"
#include "smtl.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

long long CPUFREQ = 3e9;

static double get_time(struct timespec *start,
	struct timespec *end)
{
	return end->tv_sec - start->tv_sec +
		(end->tv_nsec - start->tv_nsec) * 1e-9;
}

static long long get_freq(void) {
	FILE *fp = NULL;
	char buff[255];
	fp = fopen("/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq", "r");
	fgets(buff, 255, (FILE*)fp);
	unsigned long long ret = 1e3 * atoll(buff);
	fclose(fp);
	return ret;
}

#define FMLA_FP32_COMP (0x40000000L * 80)
static void thread_func_cpi_fmla_fp32(void *params)
{
	cpu_fp32_cpi_kernel_aarch64();
}
#define FMLA_FP16_COMP (0x40000000L * 160)
static void thread_func_cpi_fmla_fp16(void *params)
{
	cpu_fp16_cpi_kernel_aarch64();
}

static void thread_func_lat_fmla_fp32(void *params)
{
	cpu_fp32_lat_kernel_aarch64();
}

static void thread_func_lat_fmla_fp16(void *params)
{
	cpu_fp16_lat_kernel_aarch64();
}

double task_wrapper(smtl_handle *sh, int num_threads, task_func_t func) {
	struct timespec start, end;
	int i = 0;
	// warm up
	for (i = 0; i < num_threads; i++)
	{
		smtl_add_task(*sh, func, NULL);
	}
	smtl_begin_tasks(*sh);
	smtl_wait_tasks_finished(*sh);

	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
	for (i = 0; i < num_threads; i++)
	{
		smtl_add_task(*sh, func, NULL);
	}
	smtl_begin_tasks(*sh);
	smtl_wait_tasks_finished(*sh);
	clock_gettime(CLOCK_MONOTONIC_RAW, &end);

	return get_time(&start, &end);
}

void cpufp_aarch64_fmla(int num_threads)
{
	int i;
	double perf, cpi, time_used, latency;

	smtl_handle sh;
	smtl_init(&sh, num_threads);

	time_used = task_wrapper(&sh, num_threads, thread_func_cpi_fmla_fp32);
	perf = FMLA_FP32_COMP * num_threads / time_used * 1e-9;
	cpi = CPUFREQ * time_used / (FMLA_FP32_COMP * 1 / 8);
	time_used = task_wrapper(&sh, 1, thread_func_lat_fmla_fp32);
	latency = CPUFREQ * time_used / (FMLA_FP32_COMP * 1 / 8);
	printf("fmla fp32 perf: %.4lf gflops. cpi : %.4lf. latency : %.4lf.\n", perf, cpi, latency);

	time_used = task_wrapper(&sh, num_threads, thread_func_cpi_fmla_fp16);
	perf = FMLA_FP16_COMP * num_threads / time_used * 1e-9;
	cpi = CPUFREQ * time_used / (FMLA_FP16_COMP * 1 / 16);
	time_used = task_wrapper(&sh, 1, thread_func_lat_fmla_fp16);
	latency = CPUFREQ * time_used / (FMLA_FP16_COMP * 1 / 16);
	printf("fmla fp16 perf: %.4lf gflops. cpi : %.4lf. latency : %.4lf.\n", perf, cpi, latency);


	smtl_fini(sh);
}

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		fprintf(stderr, "Usage: %s num_threads.\n", argv[0]);
		exit(0);
	}

	// Determine if it is all numbers
	int num_threads = 1;
	if (strspn(argv[1], "0123456789") == strlen(argv[1]))
		num_threads = atoi(argv[1]);

	CPUFREQ = get_freq();
	double cpu_freq_d = CPUFREQ * 1e-9;
	printf("Thread(s): %d cpufreq(GHz) : %.2lf\n", num_threads, cpu_freq_d);
	cpufp_aarch64_fmla(num_threads);
	return 0;
}

