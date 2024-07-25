shutdown:

    mov ax, 0x2000
    mov dx,  0x604
    out word dx, ax ; a qemu shutdown
    
    .hang:

        mov [VgaCommandBuffer], byte dh; process id
        mov [VgaCommandBuffer+1], byte 2 ; print string
        mov [VgaCommandBuffer+2], dword 320
        mov [VgaCommandBuffer+6], dword .error
        mov [VgaCommandBuffer+14], word 0x88BB

        mov esi, Vgadrivername
        mov edi, rootpath        
        call 0x9018 ; file system

        call edi

        hlt
        jmp .hang
    .error db 'there was an error during the shutdown!',0
