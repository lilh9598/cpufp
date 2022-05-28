## cpufp
build:
sh build.sh

test:
./cpufp num_threads

clean:
sh clean.sh

Example on Ampere(armv8.2) 3GHz:

$ ./cpufp 1
Thread(s): 1 cpufreq(GHz) : 3.00
fmla fp32 perf: 47.9629 gflops. cpi : 0.5004. latency : 4.0031.
fmla fp16 perf: 95.9205 gflops. cpi : 0.5004. latency : 4.0028.