
clean:
	rm *.bin

boot.bin: boot.asm setup.asm
	nasm -f bin -o boot.bin boot.asm
	nasm -f bin -o setup.bin setup.asm
	cat setup.bin >> boot.bin
	
.PHONY: clean
