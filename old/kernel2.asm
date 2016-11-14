[org 0]
[bits 16]

start:
    mov ax, cs                      ; cs == 0x1000
    mov ds, ax
    xor ax, ax
    mov ss, ax

    cli

    lgdt [gdtr]

    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp $+2

    nop
    nop

    ; jmp dword SysCodeSelector:PM_Start
    db 0x66                         ; operand prefix
    db 0x67                         ; address prefix
    db 0xea
    dd PM_Start
    dw SysCodeSelector

; -- protected mode --
[bits 32]

PM_Start:
    mov bx, SysDataSelector
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx

    xor eax, eax
    mov ax, VideoSelector
    mov es, ax
    mov edi, 80*2*10+2*10
    lea esi, [ds:msgPMode]
    call printf

    jmp $

printf:
    push eax

printf_loop:
    or al, al
    jz printf_end
    mov al, byte [esi]
    mov byte [es:edi], al
    inc edi
    mov byte [es:edi], 0x06
    inc esi
    inc edi
    jmp printf_loop

printf_end:
    pop eax
    ret

msgPMode db "We are in Protected Mode", 0

; GDT Table
gdtr:
    dw gdt_end - gdt - 1            ; GDT limit
    dd gdt + 0x10000                ; GDT base adress

gdt:                                ; null
    dw 0
    dw 0
    db 0
    db 0
    db 0
    db 0

SysCodeSelector equ 0x08            ; code
    dw 0xffff                       ; limit
    dw 0x0000                       ; base 0..15bit
    db 0x01                         ; base 16..23bit
    db 0x9a                         ; P:1, DPL:0, Code, non-conforming, readable
    db 0xcf                         ; G:1, D:1, limit 16..19bit
    db 0x00                         ; base 24..32bit

SysDataSelector equ 0x10            ; data
    dw 0xffff
    dw 0x0000
    db 0x01
    db 0x92                         ; P:1, DPL:0, data, expand-up, writable
    db 0xcf                         ; G:1, D:1, limit 16..19bit
    db 0x00

VideoSelector equ 0x18              ; video
    dw 0xffff
    dw 0x8000
    db 0x0b
    db 0x92                         ; P:1, DPL:0, data, expand-up, writable
    db 0x40                         ; G:0, D:1, limit 16..19bit
    db 0x00

gdt_end:
