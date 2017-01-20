
AS=/usr/local/bin/nasm
LD=$(BINUTILSDIR)/$(TARGET)-ld
OBJCOPY=$(BINUTILSDIR)/$(TARGET)-objcopy

TARGET=x86_64-elf
BINUTILSDIR=$(HOME)/Documents/binutils/$(TARGET)/bin
ARC=x86_64-unknown-linux-gnu
RLIB=./target/$(ARC)/debug/libelf_test.a

.PHONY: clean

boot.img: boot.bin kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=100
	dd if=$< of=$@ conv=notrunc
	dd if=kernel.bin of=$@ seek=3 conv=notrunc

boot.bin: boot.asm setup.asm
	$(AS) -f bin -o $@ $<
	$(AS) -f bin -o setup.bin setup.asm
	cat setup.bin >> $@

kernel.bin: entry.o rust
	$(LD) -n -o kernel.o -Ttext 0x90064 -e start $< $(RLIB)
	$(OBJCOPY) -S -O binary -j .text kernel.o $@

rust:
	cargo build --target $(ARC)

entry.o: entry.asm
	$(AS) -f elf64 -o $@ $<


clean:
	rm *.bin
	rm *.img
