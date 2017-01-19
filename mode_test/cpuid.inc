check_cpuid:
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
    ret

no_cpuid:
    mov ax, 0xb800
    mov es, ax
    mov edi, 0x00
    lea esi, [msgNoCPUID]
    call print
    hlt

msgNoCPUID db "no CPUID", 0
