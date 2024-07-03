StartCMD:
    call DisableBiosCursor

    call clearScreen
    mov si, Bootmsg
    call print

    mov si, 8
    call addToWritePOS

    mov al, '$'
    call WriteChar
    
    mov bx, 0x00
    mov si, command_buffer
    .typecommand:
        add bx , 1
        

        call GrabInput
        cmp al, 0x0D
        je .command_typed
        mov [si], al
        inc si
        jmp .typecommand
        .command_typed:
            mov di, help_command
            call .compair_command
            cmp ax, 1
            je .help


            jmp .unknown_command_func

            jmp .typecommand
            
        
        .compair_command: ; input si and di(commands) ; output ax, 1 for same 0 for not
            mov si, command_buffer 
            mov dx, 0x00
            call .GrabStringSize
            .forloop:
                

                mov al, [si]
                mov bl, [di]

                cmp al, bl
                jne .notSame 

                
                
                inc si
                inc di
                
                
                dec cx
                cmp cx, 0
                jne .forloop

                mov ax, 1
                ret
            .notSame:
                xor ax, ax
                ret
            .GrabStringSize: ; input di rets cx(size)
                mov cx, 0x00
                push si
                mov si, di
                .stringloop:
                    inc si
                    inc cx
                    cmp [si], byte 0
                    je .exit
                    jmp .stringloop

                .exit:
                    pop si
                    ret



                    
            


        .help:
            
            mov di, help_command
            call .GrabStringSize
            mov si, cx
            add si ,1
            call FindEndOfScreenFromOffSet

            call addToWritePOS
            mov si, help_output
            call print
            mov di, help_output
            call .GrabStringSize
            mov si, cx
            
            call FindEndOfScreenFromOffSet
            call addToWritePOS
            mov al, '$'
            call WriteChar
            jmp .endofcommand
        .unknown_command_func:
            mov di, command_buffer
            call .GrabStringSize
            mov si, cx
            add si, 1
            call FindEndOfScreenFromOffSet
            call addToWritePOS
            mov si, unknown_command
            call print
            mov di, unknown_command
            call .GrabStringSize
            mov si, cx
            call FindEndOfScreenFromOffSet
            call addToWritePOS
            mov al, '$'
            call WriteChar

            xor cx, cx
            xor ax, ax
            xor si, si
            xor di, di

            jmp .endofcommand

        .endofcommand:
            mov cx, 0x00
            mov si, command_buffer
            
            .bufloop:

                mov [si], byte 0
                inc cx
                inc si
                inc di
                cmp cx, 40
                jne .bufloop
                
                mov si, command_buffer
                jmp .typecommand




    jmp $
command_buffer resb 40
help_command db 'help',0
help_output db 'Jennys os command list, not much as in a WIP', 0
unknown_command db 'Unknown command, or the string parser is broken idk', 0
