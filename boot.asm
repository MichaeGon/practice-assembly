%include "init.inc"
[org 0x7c00]
[bits 16]

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov ax, word [msgBack]
    mov cx, 0x7ff

paint:
    mov word [es:di], ax
    add di, 2
    dec cx
    jnz paint

read:
    mov ax, 0x1000
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    int 0x13

    jc read

    mov dx, 0x3f2
    xor al, al
    out dx, al

    jmp 0x1000:0000

msgBack db '.', 0x67

times 510 - ($ - $$) db 0
dw 0xaa55
