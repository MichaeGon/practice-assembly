[org 0]
[bits 16]

    jmp 0x07c0:start

%include "a20.inc"

start:
    mov ax, cs
    mov ds, ax

    call a20_try_loop

    mov ax, 0xb800
    mov es, ax

    mov edi, 0xa0
    lea esi, [msgRealMode]
    call printf
    hlt

printf:
    push eax

printf_loop:
    mov al, [esi]
    or al, al
    jz printf_end

    mov byte [es:edi], al
    inc esi
    inc edi
    mov byte [es:edi], 0x06
    inc edi

    jmp printf_loop

printf_end:
    pop eax
    ret

msgRealMode db "Real Mode", 0

; end
    times 510 - ($ - $$) db 0
    db 0x55
    db 0xaa
