[org 0x7c00]
[bits 16]

; dl == boot drive number here
start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov ax, 0xb800      ; color text video memory
    mov es, ax
    mov di, 0
    mov ax, word [msgBack]; ds:msgBack
    mov cx, 0x7ff       ; display size

paint:                  ; paint background
    mov word [es:di], ax
    add di, 2
    dec cx              ; if result == 0 then zero flag = true
    jnz paint           ; if zero flag != true then goto paint

read:                   ; read kernel
    mov ax, 0x1000
    mov es, ax
    mov bx, 0           ; es:bx == 0x1000:0000

    mov ah, 2           ; write to es:bx
    mov al, 1           ; number of sector to read
    mov ch, 0           ; at ch-th cylinder
    mov cl, 2           ; start read at cl-th sector
    mov dh, 0           ; head
    ;mov dl, 0           ; drive number
    int 0x13

    jc read

    jmp 0x1000:0000     ; goto kernel

msgBack db '.', 0x67

times 510 - ($-$$) db 0
dw 0xaa55               ; is MBR?
