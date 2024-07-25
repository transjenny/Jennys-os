[bits 16]
[org 0x7c00]


mov ah, 01h         ; Function 01h of INT 10h (video services)
mov ch, 20h         ; Upper scan line (start scan line)
mov cl, 1Fh         ; Lower scan line (end scan line)
int 10h




mov ah, 0x02
mov al, 50
mov ch, 0x00
mov cl, 2
mov dh, 0x00
mov bx, 0x7e0
mov es, bx
xor bx, bx

int 0x13
jc .Failed_boot


mov ah, 0x02
mov al, 50
mov ch, 0x00
mov cl, 52
mov dh, 0x00
mov bx, 0x900
mov es, bx
xor bx, bx

int 0x13
jc .Failed_boot


%include "boot/KernelBootStrapLoader.asm"





hlt
.Failed_boot:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x0e
    mov al, 'E'
    int 0x10


    jmp $
    hlt

KernelSpace equ 0x7e0
times 510-($-$$) db 0
dw 0xAA55