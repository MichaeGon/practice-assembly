
AS=/usr/local/bin/nasm
LD=$HOME/Documents/binutils/bin/i686-elf-ld

clean:
	rm *.bin

boot.bin: boot.asm setup.asm
	$(AS) -f bin -o boot.bin boot.asm
	$(AS) -f bin -o setup.bin setup.asm
	cat setup.bin >> boot.bin

.PHONY: clean
