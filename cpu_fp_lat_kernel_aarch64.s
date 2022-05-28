.globl cpu_fp32_lat_kernel_aarch64
.globl cpu_fp16_lat_kernel_aarch64
cpu_fp32_lat_kernel_aarch64:
    mov   x1, #0x40000000
    mov   w0, #0
    dup  v0.4s, w0
.cpufp.aarch64.fp32.L1:
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v0.4s, v0.4s, v0.4s
    sub     x1, x1, #1
    cbnz    x1, .cpufp.aarch64.fp32.L1
    ret


cpu_fp16_lat_kernel_aarch64:
    mov   x1, #0x40000000
    mov   w0, #0
    dup  v0.4h, w0
.cpufp.aarch64.fp16.L1:
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v0.4h, v0.4h, v0.4h
    sub     x1, x1, #1
    cbnz    x1, .cpufp.aarch64.fp16.L1
    ret
