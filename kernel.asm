%include "init.inc"

    hlt

    times 512 * NumKernelSector - ($ - $$) db 0
