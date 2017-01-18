[org 0]
[bits 16]

    jmp 0x07c0:start

%include "a20.inc"

start:
    mov ax, cs
    mov ds, ax

    mov ax, 0xb800
    mov es, ax

    mov edi, 0xa0
    lea esi, [msgRealMode]
    call printf

; read setup.asm
read:
    mov ax, 0x9000 ;es:bx == 0x9000:0x0000
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, 2 ;read 2 sectors
    mov ch, 0
    mov cl, 2 ;from 2nd sector
    mov dh, 0
    int 0x13

    jc read

    cli

    call a20_try_loop ; a20 on

    ; iwc1
    mov al, 0x11 ; init pic
    out 0x20, al
    dw 0x00eb, 0x00eb ; jmp $ + 2, jmp $ + 2
    out 0xa0, al
    dw 0x00eb, 0x00eb

    ; iwc2
    mov al, 0x20 ; start from 0x20 (master)
    out 0x21, al
    dw 0x00eb, 0x00eb
    mov al, 0x28 ; start from 0x28 (slave)
    out 0xa0, al
    dw 0x00eb, 0x00eb

    ; iwc3
    mov al, 0x04 ; master irq2 -> slave
    out 0x21, al
    dw 0x00eb, 0x00eb
    mov al, 0x02 ; slave -> master irq2
    out 0xa1, al
    dw 0x00eb, 0x00eb

    ; iwc4
    mov al, 0x01 ; use 8086
    out 0x21, al
    dw 0x00eb, 0x00eb
    out 0xa1, al
    dw 0x00eb, 0x00eb

    mov al, 0xff ; stop all interrupts of slave
    out 0xa1, al
    dw 0x00eb, 0x00eb
    mov al, 0xfb ; stop all interrupts of master except irq2
    out 0x21, al

    jmp 0x9000:0x0000 ; jump to setup.asm


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
