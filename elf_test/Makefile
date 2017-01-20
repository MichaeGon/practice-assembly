
AS=/usr/local/bin/nasm
LD=$(BINUTILSDIR)/$(TARGET)-ld
OBJCOPY=$(BINUTILSDIR)/$(TARGET)-objcopy

TARGET=x86_64-elf
BINUTILSDIR=$(HOME)/Documents/binutils/$(TARGET)/bin
ARC=x86_64-unknown-linux-gnu
RLIB=./target/$(ARC)/debug/libelf_test.a

.PHONY: clean

boot.img: boot.bin
	dd if=/dev/zero of=$@ bs=512 count=100
	dd if=$< of=$@ conv=notrunc

boot.bin: boot.asm setup.asm long_entry_asm.asm rust
	$(AS) -f bin -o $@ $<
	$(AS) -f bin -o setup.bin setup.asm
	$(AS) -f elf64 -o long_entry_asm.o long_entry_asm.asm
	$(LD) -n -o long_entry.o -Ttext 0x90064 -e start long_entry_asm.o $(RLIB)
	$(OBJCOPY) -S -O binary -j .text long_entry.o long_entry.bin
	cat setup.bin long_entry.bin >> $@

rust:
	cargo build --target $(ARC)

clean:
	rm *.bin
	rm *.img
	rm *.o
