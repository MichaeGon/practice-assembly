
AS=/usr/local/bin/nasm
LD=$(BINUTILSDIR)/$(TARGET)-ld
OBJCOPY=$(BINUTILSDIR)/$(TARGET)-objcopy

TARGET=x86_64-elf
BINUTILSDIR=$(HOME)/Documents/binutils/$(TARGET)/bin
ARC=x86_64-unknown-linux-gnu
RLIB=./target/$(ARC)/debug/libboot.a

SRCDIR=./src
BUILDDIR=./build

LDSCRIPT=./linker.ld
HSSCRIPT=./edit_length.hs

QEMU=qemu-system-x86_64

.PHONY: clean emulate build

boot.img: boot.bin
	dd if=/dev/zero of=$(BUILDDIR)/$@ bs=512 count=100
	dd if=$(BUILDDIR)/$< of=$(BUILDDIR)/$@ conv=notrunc

boot.bin: build rust $(SRCDIR)/boot.asm $(SRCDIR)/setup.asm $(SRCDIR)/long_entry.asm
	$(AS) -f elf64 -o $(BUILDDIR)/long_entry_asm.o -I$(SRCDIR)/ $(SRCDIR)/long_entry.asm
	$(LD) -n --gc-sections -o $(BUILDDIR)/long_entry.o -T $(LDSCRIPT) $(BUILDDIR)/long_entry_asm.o $(RLIB)
	$(OBJCOPY) -S -O binary -j .text -j .rodata $(BUILDDIR)/long_entry.o $(BUILDDIR)/long_entry.bin
	chmod 755 $(HSSCRIPT)
	$(HSSCRIPT)
	$(AS) -f bin -o $(BUILDDIR)/$@ -I$(SRCDIR)/ $(SRCDIR)/boot.asm
	$(AS) -f bin -o $(BUILDDIR)/setup.bin -I$(SRCDIR)/ $(SRCDIR)/setup.asm
	cat $(BUILDDIR)/setup.bin $(BUILDDIR)/long_entry.bin >> $(BUILDDIR)/$@

build:
	mkdir -p $(BUILDDIR)

rust:
	cargo build --target $(ARC)

emulate: boot.img
	$(QEMU) $(BUILDDIR)/$< -monitor stdio -k ja

clean:
	cargo clean
	rm -rf build
