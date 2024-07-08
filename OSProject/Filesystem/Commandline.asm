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
        
        jmp .unknownCommand
    .helpcommand:
        mov di, 320
        
        
        mov si, helpcommandprintstr
        call PrintStringToScreen

        call GrabInput
        mov di, 0
        jmp .ClearDisplay

        jmp $
    .runcommand:
        inc si
        call ConvertStringToNumber
        call FindFileByTag
        add di, 3 ; unknown why its 3 bytes off but i can offset it here

        push bp
        mov bp, sp ; give the app its own stack
        sub bp, 16

        call di

        mov sp, bp ; ret to kernel stack
        pop bp


        call GrabInput ; wait for input to skip to next command input
        mov di, 0
        jmp .ClearDisplay
    .unknownCommand:
        mov si, unknownCommandstr
        mov di, 320
        call PrintStringToScreen

        call GrabInput
        mov di, 0
        jmp .ClearDisplay


    jmp $
    hlt
    ret
    CommandBuffer: 
        times 20 db 0
    cmdbootmsg db 'Welcome to Jennys Commandline!', 0
    helpcommandstr db 'help', 0
    helpcommandprintstr db 'This is a list of all commands in Jennys os(WIP), help | press anykey to start  next command', 0
    unknownCommandstr db 'You typed an unknown command maybe a typo? | press anykey to start next command', 0
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

ConvertStringToNumber:  ; si has the string number in it

    mov bl, [si]
    sub bl, 0x30
    
    mov ax, 10
    mul bl

    inc si
    mov bl, [si]
    sub bl, 0x30

    add al, bl

    ret










