
const ELF_MAGIC: u32 = 0x464c457f; // ELF\x7f

/*
ELF64 header for Rust
*/
pub struct ELF64Header {
    pub address: u64,
    ptr: *mut ELF64Ehdr,
}

impl ELF64Header {
    pub fn new(address: u64) -> ELF64Header {
        ELF64Header {
            address: address,
            ptr: address as *mut _,
        }
    }

    pub fn is_elf(&self) -> bool {
        let res;
        unsafe {
            res = (*self.ptr).e_magic == ELF_MAGIC;
        }

        res
    }

    // iter?
}

/*
raw ELF64 header
*/
#[repr(C)]
struct ELF64Ehdr {
    e_magic: u32,
    e_ident: [u8; 12], // 16 - sizeof(e_magic)
    e_type: u16,
    e_machine: u16,
    e_version: u32,
    e_entry: u64,
    e_phoff: u64,
    e_shoff: u64,
    e_flags: u32,
    e_ehsize: u16,
    e_phentsize: u16,
    e_phnum: u16,
    e_shentsize: u16,
    e_shnum: u16,
    e_shstrndx: u16,
}

/*
ELF64 program header for Rust
*/
pub struct ELF64ProgHeader {
    pub address: u64,
    ptr: *mut ELF64Phdr,
}

impl ELF64ProgHeader {
    pub fn new(address: u64) -> ELF64ProgHeader {
        ELF64ProgHeader {
            address: address,
            ptr: address as *mut _,
        }
    }
}

/*
raw ELF64 program header
*/
#[repr(C)]
struct ELF64Phdr {
    p_type: u32,
    p_flags: u32,
    p_offset: u64,
    p_vaddr: u64,
    p_paddr: u64,
    p_filesz: u64,
    p_memsz: u64,
    p_align: u64,
}
