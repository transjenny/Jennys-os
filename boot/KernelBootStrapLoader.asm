


_start:

mov ah, 0x0e
mov al, 'S'
int 0x10



cli



in al, 0x92
or al, 2
out 0x92, al

mov eax, cr0
or eax,1 
mov cr0, eax

lgdt [gdt_ptr]


jmp 08h:ProtectedModeEntry



gdt_ptr:
    dw gdt_end - gdt_start - 1  ; Limit (Size of GDT - 1)
    dd gdt_start                ; Base address of GDT

gdt_start:
    ; Null descriptor
    dq 0x0000000000000000

    ; Code segment descriptor
    dw 0xFFFF             ; Limit (low 16 bits)
    dw 0x0000             ; Base (low 16 bits)
    db 0x00               ; Base (middle 8 bits)
    db 10011010b          ; Access byte: present, ring 0, code segment, execute/read
    db 11001111b          ; Granularity byte: 4K granularity, 32-bit protected mode
    db 0x00               ; Base (high 8 bits)

    ; Data segment descriptor
    dw 0xFFFF             ; Limit (low 16 bits)
    dw 0x0000             ; Base (low 16 bits)
    db 0x00               ; Base (middle 8 bits)
    db 10010010b          ; Access byte: present, ring 0, data segment, read/write
    db 11001111b          ; Granularity byte: 4K granularity, 32-bit protected mode
    db 0x00               ; Base (high 8 bits)

gdt_end:




[bits 32]


ProtectedModeEntry:
    mov ax, 0x10
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov esp, 0x9000

    
    mov ebx, 0xb8000
    .clearScreen: ; clear the screen before handing down to the kernel
        
        mov [ebx], byte ' '
        add ebx, 2

        cmp ebx, 0xB8FA0
        jne .clearScreen
    jmp 0x7e00
    

