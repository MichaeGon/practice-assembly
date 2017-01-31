#![feature(lang_items)]
#![feature(asm)]
#![no_std]

extern crate rlibc;

mod elf;
mod x86_64;

use elf::*;
use x86_64::*;

const SECT_SIZE: u64 = 512;
const KERNEL_SECTOR: u64 = 1;

#[no_mangle]
pub extern fn rust_main() {

    //let msg = [b'H', b'e', b'l', b'l', b'o', b' ', b'f', b'o', b'm', b' ', b'R', b'u', b's', b't'];
    let msg = b"Hello from Rust";
    let color = 0xf6;

    let mut buf = [color; 30];
    for (i, &x) in msg.into_iter().enumerate() {
        buf[i * 2] = x;
    }

    let ptr = 0xb8000 as *mut _;
    unsafe {
        *ptr = buf;
    }

    loop {}

    let ptr = 0x10000;
    read_seg(ptr, 0x1000, 0); // first page of disk

    let elf = ELF64Header::new(ptr);
    if !elf.is_elf() {
        return;
    }

    // load program
    let mut i = 0;
    while let Some(ph) = elf.progheader(i) {
        read_seg(ph.address, ph.file_size() as u32, ph.offset() as u32);

        if ph.memory_size() > ph.file_size() {
            stosb(ph.address + ph.file_size(), 0, (ph.memory_size() - ph.file_size()) as u32);
        }

        i += 1;
    }

    // call kernel
    elf.exec_from_entry();

    /*
    let msg = [b'H', b'e', b'l', b'l', b'o', b' ', b'f', b'o', b'm', b' ', b'R', b'u', b's', b't'];
    let color = 0xf6;

    let mut buf = [color; 28];
    for (i, &x) in msg.into_iter().enumerate() {
        buf[i * 2] = x;
    }

    let ptr = 0xb8000 as *mut _;
    unsafe {
        *ptr = buf;
    }

    loop {}
    */

}

// wait disk
fn wait_disk() {
    while (inb(0x1f7) & 0xc0) != 0x40 {}
}

/*
read 1 sector at offset into dst
*/
fn read_sect(dst: u64, offset: u32) {
    wait_disk();
    outb(0x1f2, 1); // read 1 sector
    outb(0x1f3, offset as u8);
    outb(0x1f4, (offset >> 8) as u8);
    outb(0x1f5, (offset >> 16) as u8);
    outb(0x1f6, ((offset >> 24) | 0xe0) as u8);
    outb(0x1f7, 0x20);

    // read
    wait_disk();
    insd(0x1f0, dst, (SECT_SIZE / 4) as u32);
}

fn read_seg(pa: u64, count: u32, offset: u32) {
    let epa = pa + count as u64;
    let pa = pa - offset as u64 % SECT_SIZE;
    let offset = (offset as u64 / SECT_SIZE) + KERNEL_SECTOR;

    let mut i = 0;
    while pa + i * SECT_SIZE < epa {
        read_sect(pa + i * SECT_SIZE, (offset + i) as u32);
        i += 1;
    }
}

#[lang = "eh_personality"]
extern fn eh_personality() {}

#[lang = "panic_fmt"]
#[no_mangle]
pub extern fn panic_fmt() -> ! {
    loop {}
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn _Unwind_Resume() -> ! {
    loop {}
}
