check_sse:
    mov eax, 0x1
    cpuid
    test edx, 1 << 25
    jz no_sse

    mov eax, cr0
    and ax, 0xfffb
    or ax, 0x2
    mov cr0, eax
    mov eax, cr4
    or ax, 3 << 9
    mov cr4, eax

    ret

no_sse:
    lea esi, [msgNoSSE]
    jmp error

msgNoSSE db "SSE", 0
