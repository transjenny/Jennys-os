[org [ORGHERE]]

xor di, di

_VGAENTRY:
    mov al, [0x09ff] ; grab the VGA command byte(i made that)
    cmp al, 0
    je .FUNC_CS
    cmp al, 1
    je .FUNC_PS

    ret
    .FUNC_CS:
        mov di, 0
        .CLEARSCREEN:
            mov dx, 0xb800
            mov es, dx
            mov al, ' '
            mov [es:di], byte al
            add di, 2
            cmp di, 2000
            jne .CLEARSCREEN
            ret
    .FUNC_PS:
        mov di, [0x09fe]
        sub di, 256 ; IDFK WHY THIS IS OFFSET BUT NOTHING ELSE IS
        mov al, [0x09fd]
        mov dx, 0xb800
        mov es, dx
        mov [es:di], byte al
        ret
    