%include "init.inc"

[bits 16]
    jmp 0x07c0:start

%include "a20.inc"
%include "long.inc"
%include "sse.inc"

start:
    mov ax, cs
    mov ds, ax

; read_setup.asm
read_setup:
    mov ax, 0x9000 ; es:bx == 0x9000:0x0000
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, NumSetupSector + NumEntrySector ; read NumSetupSector sectors
    mov ch, 0
    mov cl, 2 ; from 2nd sector
    mov dh, 0
    int 0x13

    jc read_setup


    call a20_try_loop
    call check_long_mode
    call check_sse

    ; jump to setup.asm
    jmp 0x9000:0x0000

error:
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov al, byte [esi]
    or al, al
    jz die

    mov byte [es:di], al
    inc di,
    inc esi
    mov byte [es:di], 0xf6
    inc di
    jmp error

die:
    jmp $

    times 510 - ($ - $$) db 0
    db 0x55
    db 0xaa
