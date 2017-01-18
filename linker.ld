ENTRY(start)

SECTIONS {
    . = 0xc7000;
    .text :
    {
        *(.text)
    }
}
