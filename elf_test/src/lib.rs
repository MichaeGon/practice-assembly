#![feature(lang_items)]
#![no_std]

extern crate rlibc;

#[no_mangle]
pub extern fn rust_main() {

    let msg = [b'H', b'e', b'l', b'l', b'o', b' ', b'f', b'r', b'o', b'm', b' ', b'R', b'u', b's', b't'];
    //let msg = b"Hello from Rust";
    let color = 0x06u8;

    let mut buf = [color; 30];
    for (i, &x) in msg.into_iter().enumerate() {
        buf[i * 2] = x;
    }

    let ptr = 0xb8000 as *mut _;

    unsafe {
        *ptr = buf
    };

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
