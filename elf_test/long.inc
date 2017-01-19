check_long_mode:

    pushfd
    pop eax ; copy flags

    mov ecx, eax
    xor eax, 1 << 21 ; flip id bit

    push eax
    popfd ; copy flags

    pushfd
    pop eax ; copy flags back

    push ecx
    popfd ; copy old flags

    cmp eax, ecx ; check cpuid
    je no_cpuid

    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb no_long

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz no_long
    ret

no_cpuid:
    mov ax, 0xb800
    mov es, ax
    mov edi, 0x00
    lea esi, [msgNoCPUID]
    call print
    hlt

no_long:
    mov ax, 0xb800
    mov es, ax
    mov edi, 0
    lea esi, [msgNoLong]
    call print
    hlt

msgNoCPUID db "no CPUID", 0
msgNoLong db "No long mode", 0
