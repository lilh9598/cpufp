.globl cpu_fp32_cpi_kernel_aarch64
.globl cpu_fp16_cpi_kernel_aarch64
cpu_fp32_cpi_kernel_aarch64:
    mov   x1, #0x40000000
    mov   w0, #0
    dup  v0.4s, w0
    dup  v1.4s, w0
    dup  v2.4s, w0
    dup  v3.4s, w0
    dup  v4.4s, w0
    dup  v7.4s, w0
    dup  v6.4s, w0
    dup  v8.4s, w0
    dup  v9.4s, w0
.cpufp.aarch64.fp32.L1:
    fmla    v0.4s, v0.4s, v0.4s
    fmla    v1.4s, v1.4s, v1.4s
    fmla    v2.4s, v2.4s, v2.4s
    fmla    v3.4s, v3.4s, v3.4s
    fmla    v4.4s, v4.4s, v4.4s
    fmla    v5.4s, v5.4s, v5.4s
    fmla    v6.4s, v6.4s, v6.4s
    fmla    v7.4s, v7.4s, v7.4s
    fmla    v8.4s, v8.4s, v8.4s
    fmla    v9.4s, v9.4s, v9.4s
    sub     x1, x1, #1
    cbnz    x1, .cpufp.aarch64.fp32.L1
    ret


cpu_fp16_cpi_kernel_aarch64:
    mov   x1, #0x40000000
    mov   w0, #0
    dup  v0.4h, w0
    dup  v1.4h, w0
    dup  v2.4h, w0
    dup  v3.4h, w0
    dup  v4.4h, w0
    dup  v7.4h, w0
    dup  v6.4h, w0
    dup  v8.4h, w0
    dup  v9.4h, w0
.cpufp.aarch64.fp16.L1:
    fmla    v0.4h, v0.4h, v0.4h
    fmla    v1.4h, v1.4h, v1.4h
    fmla    v2.4h, v2.4h, v2.4h
    fmla    v3.4h, v3.4h, v3.4h
    fmla    v4.4h, v4.4h, v4.4h
    fmla    v5.4h, v5.4h, v5.4h
    fmla    v6.4h, v6.4h, v6.4h
    fmla    v7.4h, v7.4h, v7.4h
    fmla    v8.4h, v8.4h, v8.4h
    fmla    v9.4h, v9.4h, v9.4h
    sub     x1, x1, #1
    cbnz    x1, .cpufp.aarch64.fp16.L1
    ret
