%include "init.inc"

[org 0x10000]
[bits 16]

start:
    cld
    mov ax, cs
    mov ds, ax
    xor ax, ax
    mov ss, ax

    xor eax, eax
    lea eax, [tss]
    add eax, 0x10000
    mov [descriptor4 + 2], ax
    shr eax, 16
    mov [descriptor4 + 4], al
    mov [descriptor4 + 7], ah

    xor eax, eax
    lea eax, [printf]
    add eax, 0x10000
    mov [descriptor7], ax
    shr eax, 16
    mov [descriptor7 + 6], al
    mov [descriptor7 + 7], ah

    cli

    lgdt [gdtr]

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

    lea esp, [PM_Start]

    mov ax, TSSSelector
    ltr ax

    mov [tss_esp0], esp             ; level 0 stack
    lea eax, [PM_Start - 256]
    mov [tss_esp], eax              ; level 3 stack

    ; act as user mode
    mov ax, UserDataSelector        ; set to user data, ss auto asgn
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    lea esp, [PM_Start - 256]

    push dword UserDataSelector     ; ss (user mode)
    push esp
    push dword 0x200                ; eflags (user mpde), IF=1 accept interrupt
    push dword UserCodeSelector     ; cs (user mode)
    lea eax, [user_process]
    push eax                        ; eip (use mode)
    iretd                           ; jump to user mode

printf:
    mov ebp, esp
    push es
    push eax
    mov ax, VideoSelector
    mov es, ax
    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

printf_loop:
    mov al, byte [esi]
    mov byte [es:edi], al
    inc edi
    mov byte [es:edi], 0x06
    inc edi
    inc esi
    or al, al
    jz printf_end
    jmp printf_loop

printf_end:
    pop eax
    pop es
    ret

user_process:
    mov edi, 80*2*7
    push edi
    lea eax, [msg_user_parameter]
    push eax
    call 0x38:0                     ; call gate, printf
    jmp $

msg_user_parameter db "This is User Parameter1", 0

gdtr:
    dw gdt_end - gdt - 1
    dd gdt
gdt:
    dd 0, 0
    dd 0x0000ffff, 0x00cf9a00
    dd 0x0000ffff, 0x00cf9200
    dd 0x8000ffff, 0x0040920b

descriptor4:
    dw 104
    dw 0
    db 0
    db 0x89
    db 0
    db 0

    dd 0x0000ffff, 0x00fcfa00       ; user code segment
    dd 0x0000ffff, 0x00fcf200       ; user data segment

descriptor7:                        ; call gate desc, equ 0x38
    dw 0
    dw SysCodeSelector
    db 0x02
    db 0xec
    db 0
    db 0

gdt_end:

tss:
    dw 0, 0
tss_esp0:
    dd 0
    dw SysDataSelector, 0
    dd 0
    dw 0, 0
    dd 0
    dw 0, 0
    dd 0
tss_eip:
    dd 0, 0
    dd 0, 0, 0, 0
tss_esp:
    dd 0, 0, 0, 0
    dw 0, 0
    dw 0, 0
    dw UserDataSelector, 0
    dw 0, 0
    dw 0, 0
    dw 0, 0
    dw 0, 0
    dw 0, 0

times 1024 - ($ - $$) db 0
