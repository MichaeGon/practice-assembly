%include "init.inc"

P4_Table equ 0x100000
P3_Table equ 0x101000
P2_Table equ 0x102000
P1_Table equ 0x103000

[org 0x90000]
bits 16

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

bits 32

PM_Start:
    mov bx, SysDataSelector
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx

    mov esp, PM_Start

    xor eax, eax
    mov ax, VideoSelector
    mov es, ax
    mov edi, 0xa0
    lea esi, [msgPMode]

    call print

    mov edi, P4_Table
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd

    mov dword [P4_Table], P3_Table + 0x03
    mov dword [P3_Table], P2_Table + 0x03
    mov dword [P2_Table], P1_Table + 0x03

    mov ebx, 0x3
    mov ecx, 512
    mov edi, P1_Table

map_p1:
    mov dword [edi], ebx
    add ebx, 0x1000
    add edi, 8
    loop map_p1

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xc0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    lgdt [gdt64r]

    jmp SysCodeSelector:LM_Start

msgPMode db "Protected Mode", 0


%include "print.inc"


; gdt
gdtr:
    dw gdt_end - gdt - 1 ; limit
    dd gdt

gdt:
    dq 0x0 ; dummy
    dd 0x0000ffff, 0x00cf9a00 ; SysCodeSelector
    dd 0x0000ffff, 0x00cf9200 ; SysDataSelector
    dd 0x8000ffff, 0x0040920b ; VideoSelector

gdt_end:

gdt64r:
    dw gdt64_end - gdt64r - 1
    dd gdt64

gdt64:
    dq 0x0
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
gdt64_end:

bits 64

LM_Start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    lea esi, [msgLMode]
    mov edi, 0xb8000 + 0xa0 * 2

paint:
    mov al, [esi]
    or al, al
    jz end
    mov byte [edi], al
    inc edi
    inc esi
    mov byte [edi], 0x06
    inc edi
    jmp paint

end:
    hlt

msgLMode db "Long Mode", 0

; end
    times 512 * 2 - ($ - $$) db 0
