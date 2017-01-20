%include "init.inc"

[org 0x90000]
[bits 16]

start16:
    mov ax, cs
    mov ds, ax
    xor ax, ax
    mov ss, ax

    cli

    lgdt [GDT.pointer]

    ; switch to protected mode
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp $ + 2
    nop
    nop

    ; jmp to protected mode
    jmp dword GDT.code:start32

[bits 32]

start32:
    mov ax, GDT.data
    mov ds, ax
    mov es, ax
    mov ss, ax
    xor ax, ax
    mov fs, ax
    mov gs, ax

    mov esp, start16

    ; setting up paging
    xor eax, eax
    mov ecx, 4096
    rep stosd

    mov dword [PML4T], PDPT + 0x3 ; r/w and present
    mov dword [PDPT], PDT + 0x3
    mov dword [PDT], PT + 0x3

    mov ebx, 0x3
    mov ecx, 512 ; number of table entry
    mov edi, PT
set_entry_loop:
    mov dword [edi], ebx
    add ebx, 0x1000
    add edi, 8
    loop set_entry_loop

    mov edi, PML4T
    mov cr3, edi

    mov eax, cr4
    or eax, 1 << 5 ; set PAE bit
    mov cr4, eax


    ; switch to long mode
    mov ecx, 0xc0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31 ; enable paging
    mov cr0, eax

    lgdt [GDT64.pointer]

    ; jump to long mode
    jmp GDT64.code:start64


; bootstrap GDT
GDT:
    dq 0
.code: equ $ - GDT
    dd 0x0000ffff, 0x00cf9a00
.data: equ $ - GDT
    dd 0x0000ffff, 0x00cf9200
.pointer:
    dw $ - GDT - 1
    dd GDT

[bits 64]

start64:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; jump to kernel
    jmp 0x90000 + 512 * NumSetupSector

    hlt

; 64bit GDT
GDT64:
    dq 0
.code: equ $ - GDT64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.pointer:
    dw $ - GDT64 - 1
    dq GDT64

    times 512 * NumSetupSector - ($ - $$) db 0
