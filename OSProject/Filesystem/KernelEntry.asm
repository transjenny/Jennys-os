[org 0x7fff]


_KernelEntry: ; i was ment to reset the stack here but that broke stuff no now im not

    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor di, di
    xor si, si

    mov si, bootmsg
    call PrintstringTOSERIAL
    
    call DisableBiosCursor
    call ClearScreen

    call PrintHelloworld
    jmp TESTLOADFILE

    hlt
    jmp $
    bootmsg db '  Hello there, say hi to the Serial. Theres gonna be some debug info here.', 0x0A, 0
    bootmsgVGA db '  Hello there, say hi to the VGA. Theres gonna be some OS STUFF HERE', 0



    
PrintHelloworld:
    mov si, bootmsgVGA
    mov di, 0
    call PrintStringToScreen
    ret


printCharTOSerial:
    mov dx, 0x3f8
    out dx, al
    ret

PrintstringTOSERIAL:
    mov dx, 0x3f8
    mov al, [si]
    out dx, al
    inc si
    cmp [si], byte 0
    jne PrintstringTOSERIAL
    ret

PrintStringToScreen:
    .writeloop:
        mov al, [si]
        call printChar
        add di, 2
        inc si
        cmp [si], byte 0
        jne .writeloop
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

ClearScreen:
    mov di, 0
    .writeloop:
        mov al, ' '
        call printChar
        add di, 2
        cmp di, 2000
        jne .writeloop
        ret



printChar:
    mov dx, 0xb800
    mov es, dx
    mov [es:di], byte al
    ret





FindFileByTag:; tag in al output di(place in memory)
    mov di, 0x1c00
    .findfiles:
        inc di
        cmp [di], byte 0xBB
        jne .findfiles
        inc di
    .lookloop:
        cmp [di], byte al
        je .found
        .findnextfile:
            inc di
            cmp [di], byte 0xAF
            jne .findnextfile
            inc di
            cmp [di], byte 0xFA
            jne .findnextfile
            inc di
        jmp .lookloop
    .found:
        ret



TESTLOADFILE:
    mov al, 0x10
    call FindFileByTag ; stores addr into di

    jmp di


    jmp $
    hlt
    
