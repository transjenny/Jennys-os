[org [ORGHERE] ] ; added when the filesystem is built



_commandLineEntry:
    

    mov di,0

    .ClearDisplay: ; enables the vga card from the new address
        mov dx, 0xb800
        mov es, dx
        mov al, ' '
        mov [es:di], byte al
        add di, 2
        cmp di, 2000
        jne .ClearDisplay    

    mov si, cmdbootmsg
    mov di, 0
    call PrintStringToScreen
    add di, 100
  
    

    mov al, '$'
    call printChar
    mov si, CommandBuffer
    .inputloop:
        call GrabInput
        cmp al, 0x0D
        je .CommandTyped
        mov [si], byte al
        add di, 2
        inc si
        call printChar
        jmp .inputloop
    .CommandTyped:
        mov [si], byte 0
        mov di, helpcommandstr
        call compair_strings
        cmp al, 1
        je .helpcommand
        mov di, runcommandstr
        call compair_strings
        cmp al, 1
        je .runcommand
        
        jmp $
    .helpcommand:
        mov di, 320
        
        
        mov si, helpcommandprintstr
        call PrintStringToScreen

        call GrabInput
        mov di, 0
        call .ClearDisplay

        jmp $
    .runcommand:
        mov al, 0x11
        call FindFileByTag
        add di, 3 ; unknown why its 3 bytes off but i can offset it here
        mov [0x09fe], byte 2
        mov [0x09ff], byte 1
        mov [0x01ff], byte 'H'
        mov [0x0200], byte 'I'
        mov [0x0201], byte 0
        call di
        call GrabInput
        mov di, 0
        call .ClearDisplay
        jmp $

    jmp $
    hlt
    ret
    CommandBuffer: 
        times 20 db 0
    cmdbootmsg db 'Welcome to Jennys Commandline!', 0
    helpcommandstr db 'help', 0
    helpcommandprintstr db 'This is a list of all commands in Jennys os(WIP), help | press anykey to start  next command', 0
    runcommandstr db 'run', 0
    %include "../drivers/ps2Driver.asm"
    jmp $
compair_strings:
    mov si, CommandBuffer
    .Lookloop:
        mov al, [si]
        cmp [di], byte al
        jne .notequ
        inc si
        inc di
        cmp [di], byte 0
        je .equto
        jmp .Lookloop
    .notequ:
        mov al, 0
        ret
    .equto:
        mov al, 1
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