#![feature(lang_items, asm)]
#![no_std]

#[no_mangle]
pub extern fn boot_main() {
    let msg = "Hello from Rust";
    let color = 0x06;

    let mut buf = [color; 30];
    for (i, c) in msg.bytes().enumerate() {
        buf[i * 2] = c;
    }

    let ptr = 0xb8000 as *mut _;

    unsafe {
        *ptr = buf;
    }

    loop {}
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
