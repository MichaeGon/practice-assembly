[bits 16]
;[org 0]
;    jmp 0x7c0:start
[org 0x7c00]

start:
    mov ax, cs              ; if org 0, jmp 0x7c0:start then 0x7c0 else 0
    mov ds, ax
    mov es, ax

    mov ax, 0xb800          ; color text video memory
    mov es, ax
    mov di, 0
    mov ax, word [msgBack]  ; mov from ds:msgBack
    mov cx, 0x7ff

paint:
    mov word [es:di], ax,
    add di, 2
    dec cx
    jnz paint

read:
    mov ax, 0x1000
    mov es, ax
    mov bx, 0
    mov ah, 2               ; write to es:bx
    mov al, 1               ; number of sectors to read
    mov ch, 0               ; ch-th cylinder
    mov cl, 2               ; read from cl-th sector
    mov dh, 0               ; head
    ;mov d, 0               ; boot drive number
    int 0x13

    jc read

    jmp 0x1000:0000         ; goto kernel

msgBack db '.', 0x67

times 510 - ($ - $$) db 0
dw 0xaa55                   ; is MBR?
