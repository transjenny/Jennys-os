[org 0x7fff]


_KernelEntry:

    mov bp, 0x7fff
    mov sp, bp
    
    

    mov si, bootmsg
    call PrintstringTOSERIAL
    
    call DisableBiosCursor
    call ClearScreen

    jmp CommandLine

    hlt
    jmp $
    bootmsg db '  Hello there, say hi to the Serial. Theres gonna be some debug info here.', 0x0A, 0
    bootmsgVGA db '  Hello there, say hi to the VGA. Theres gonna be some OS STUFF HERE', 0



    
PrintHelloworld:
    mov si, bootmsgVGA
    call PrintStringToScreen
    hlt


        

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





CommandLine:
    mov si, .bootmsg
    mov di, 0
    call PrintStringToScreen

    mov di, 160
    mov al, '$'
    call printChar
    inc di
    call EnablePS2
    call GrabInput


    hlt
    .bootmsg db '  Welcome to the comandline in jenny os!', 0
    %include "../drivers/ps2Driver.asm"