[bits 64]

section .text

global start
start:
    extern rust_main
    call rust_main

    lea esi, [msgReturned]
    mov edi, 0xb8000
error:
    mov al, byte [esi]
    or al, al
    jz die
    mov byte [edi], al
    inc edi
    inc esi
    mov byte [edi], 0xf6
    inc edi
    jmp error

die:
    jmp $

msgReturned db "returned from Rust", 0
