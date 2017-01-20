
AS=/usr/local/bin/nasm
LD=$HOME/Documents/binutils/bin/i686-elf-ld

clean:
	rm *.bin
	rm *.img

boot.img: boot.bin
	dd if=/dev/zero of=boot.img bs=512 count=100
	dd if=boot.bin of=boot.img conv=notrunc

boot.bin: boot.asm setup.asm
	$(AS) -f bin -o boot.bin boot.asm
	$(AS) -f bin -o setup.bin setup.asm
	cat setup.bin >> boot.bin

.PHONY: clean
