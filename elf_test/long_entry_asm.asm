[bits 64]

section .text

global start
start:
    extern rust_main
    call rust_main

    mov word [0xb8000], 0xf745

    jmp $
