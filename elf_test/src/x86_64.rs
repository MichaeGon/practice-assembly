/*
x86_64.rs

wrapper functions
*/

#[cfg(any(target_arch = "x86_64"))]
pub fn inb(port: u16) -> u8 {
    let data;
    unsafe {
        asm!("in $0, $1"
            : "={al}"(data)
            : "{dx}"(port)
            :
            : "intel", "volatile"
        );
    }

    data
}

#[cfg(any(target_arch = "x86_64"))]
pub fn insd(port: u32, addr: u64, count: u32) {
    let mut count = count;
    unsafe {
        asm!("cld; rep insd"
            : "={edi}"(addr as *mut u8), "={ecx}"(count)
            : "{edx}"(port), "0"(addr as *mut u8), "1"(count)
            : "memory", "cc"
            : "intel", "volatile"
        );
    }
}

#[cfg(any(target_arch = "x86_64"))]
pub fn outb(port: u16, data: u8) {
    unsafe {
        asm!("out $1, $0"
            :
            : "{al}"(data), "{dx}"(port)
            :
            : "intel", "volatile"
        );
    }
}
