[org [ORGHERE]]

_VGAENTRY:
    mov di, 0
    .ClearDisplay: ; enables the vga card from the new address
        mov dx, 0xb800
        mov es, dx
        mov al, ' '
        mov [es:di], byte al
        add di, 2
        cmp di, 2000
        jne .ClearDisplay    
    jmp $
    hlt