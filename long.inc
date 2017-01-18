check_long_mode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb no_long

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz no_long
    ret

no_long:
    mov ax, 0xb800
    mov es, ax
    mov edi, 0
    lea esi, [msgNoLong]
    call print
    hlt

msgNoLong db "No long mode", 0
