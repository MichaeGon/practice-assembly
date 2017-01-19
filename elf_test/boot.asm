%include "init.inc"

[bits 16]
    jmp 0x07c0:start

start:
    mov ax, cs
    mov ds, ax

; read_setup.asm
read_setup:
    mov ax, 0x9000 ; es:bx == 0x9000:0x0000
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, NumSetupSector ; read NumSetupSector sectors
    mov ch, 0
    mov cl, 2 ; from 2nd sector
    mov dh, 0
    int 0x13

    jc read_setup

    call a20_try_loop
    call check_long_mode

    ; jump to setup.asm
    jmp 0x9000:0x0000


%include "a20.inc"
%include "long.inc"
%include "print.inc"

    times 510 - ($ - $$) db 0
    db 0x55
    db 0xaa
