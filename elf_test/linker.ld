ENTRY(start)
SECTIONS {
    . = 0x90064;
    .text :
    {
        *(.text*)
    }
    .rodata :
    {
        *(.rodata*)
    }
}
