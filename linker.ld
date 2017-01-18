ENTRY(start)

SECTIONS {
    .boot :
    {
        *(.boot)
    }
    .text :
    {
        *(.text)
    }
}
