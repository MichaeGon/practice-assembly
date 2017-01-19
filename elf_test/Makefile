AS=/usr/local/bin/nasm
LD=$HOME/Documents/binutils/bin/i686-elf-ld

.PHONY: clean

boot.img: boot.bin setup.bin
	cat boot.bin setup.bin > boot.img

boot.bin: setup.bin
	$(AS) -f bin -o boot.bin boot.asm

setup.bin: setup.asm
	$(AS) -f bin -o setup.bin setup.asm


clean:
	rm *.bin
	rm *.img
