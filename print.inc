print:
    push eax

print_loop:
    mov al, [esi]
    or al, al
    jz print_end

    mov byte [es:edi], al
    inc esi
    inc edi
    mov byte [es:edi], 0x06
    inc edi

    jmp print_loop

print_end:
    pop eax
    ret
