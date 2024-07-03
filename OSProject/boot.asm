[org 0x7c00]
[bits 16]


cli

;Initialize the stack.
mov bp, 0x7c00
mov sp, bp


;Clear all the segment registers.
xor ax, ax
mov ds, ax
mov ss, ax
sti



jmp openKernel



print:
    mov ah, 0x0e
    mov al, [si]
    int 0x10
    inc si
    cmp [si], byte 0
    jne print
    ret
openKernel:
    mov ah, 02h
    mov al, 4
    mov cl, 2
    mov ch, 0x00
    mov bx, 0x7e0
    mov es, bx
    xor bx,bx
    int 13h
    jc .error
    jmp 0x7e0:0x0000
    
    .error:
        mov si, ondiskerror
        call print
        hlt
ondiskerror db 'there was an error reading into kernel space, jenny the what shit did you do', 0
times 510-($-$$) db 0
dw 0xaa55