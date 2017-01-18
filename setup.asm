[bits 16]

    hlt
    
; end
    times 512 * 2 - ($ - $$) db 0
