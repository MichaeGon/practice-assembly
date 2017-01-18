%include "init.inc"

[org 0x90000]
[bits 16]

start:
    cld
    mov ax, cs
    mov ds, ax
    xor ax, ax
    mov ss, ax

    cli

    lgdt [gdtr]

    ; to protected mode

    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp $ + 2
    nop
    nop

    jmp dword SysCodeSelector:PM_Start

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
    mov edi, 0xa0
    lea esi, [ds:msgPMode]

    call print
    hlt

msgPMode db "Protected Mode", 0

%include "print.inc"


; gdt
gdtr:
    dw gdt_end - gdt - 1 ; limit
    dd gdt

gdt:
; dummy
    dw 0 ; limit  0-15 bit
    dw 0 ; base address 0-1bit
    db 0 ; base address 16-23 bit
    db 0 ; type
    db 0 ; limit limit 16-19 bit, flag
    db 0 ; base address 24-31 bit

    dd 0x0000ffff, 0x00cf9a00 ; SysCodeSelector
    dd 0x0000ffff, 0x00cf9200 ; SysDataSelector
    dd 0x8000ffff, 0x0040920b ; VideoSelector

gdt_end:


; end
    times 512 * 2 - ($ - $$) db 0
