WriteChar:
    mov bx, 0xb800
    mov es, bx
    mov byte [es:di], al
    
    ret
clearScreen:
    .forLoop:
        mov al, ' '
        call WriteChar
        inc di
        inc di
        cmp di, 2000
        jl .forLoop
        
        ret

DisableBiosCursor:
    mov dx, 0x3D4     ; DX = VGA register port
    mov al, 0x0A      ; AL = Cursor Start Register
    out dx, al        ; Set index to Cursor Start Register

    mov dx, 0x3D5     ; DX = VGA data port
    in al, dx         ; Read current value
    or al, 0x20       ; Set bit 5 (bit 5 is usually the cursor disable bit)
    out dx, al        ; Write modified value back
    ret



addToWritePOS:
    mov di, [WritePOS]
    mov ax, 2
    mul si
    mov si, ax
    add di, si
    mov [WritePOS], di
    ret
reset_writePOS:
    xor ax, ax
    mov [WritePOS], ax
    ret

FindEndOfScreenFromOffSet: ; offset in si
    mov ax, 80
    sub ax, si
    mov si, ax
    ret


print:
    .forloop:
        
        mov al, [si]
        call WriteChar
        add di, 2
        inc si
        cmp [si], byte 0
        jne .forloop
        ret

WritePOS db 0