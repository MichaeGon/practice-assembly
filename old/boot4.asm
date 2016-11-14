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
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0

    int 0x13

    jc read

    mov dx, 0x3f2       ; floppy
    xor al, al          ; off
    out dx, al

    cli
    mov al, 0xff
    out 0xa1, al

    lgdt [gdtr]

    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp $+2

    nop
    nop

    mov bx, SysDataSelector
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx

    jmp dword SysCodeSelector:0x10000

msgBack db '.', 0x67

gdtr:
    dw gdt_end - gdt - 1
    dd gdt

gdt:
    dd 0, 0
    dd 0x0000ffff, 0x00cf9a00
    dd 0x0000ffff, 0x00cf9200
    dd 0x8000ffff, 0x0040920b

gdt_end:

times 510 - ($ - $$) db 0
dw 0xaa55
