
AS=/usr/local/bin/nasm
LD=$HOME/Documents/binutils/bin/i686-elf-ld

boot.img: boot.bin
	dd if=/dev/zero of=$@ bs=512 count=100
	dd if=$< of=$@ conv=notrunc

boot.bin: boot.asm setup.asm
	$(AS) -f bin -o $@ $<
	$(AS) -f bin -o setup.bin setup.asm
	cat setup.bin >> $@

.PHONY: clean

clean:
	rm *.bin
	rm *.img
