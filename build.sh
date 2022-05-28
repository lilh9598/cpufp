as -march=armv8.2-a+fp16 -o cpu_fp_cpi_kernel_aarch64.o cpu_fp_cpi_kernel_aarch64.s
as -march=armv8.2-a+fp16 -o cpu_fp_lat_kernel_aarch64.o cpu_fp_lat_kernel_aarch64.s
gcc -O3 -c cpufp_aarch64.c
gcc -O3 -c smtl.c
gcc -O3 -pthread -o cpufp cpufp_aarch64.o smtl.o cpu_fp_cpi_kernel_aarch64.o cpu_fp_lat_kernel_aarch64.o