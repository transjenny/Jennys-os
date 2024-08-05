; WARNING THIS WAS PORTED TO WORK WITH THE NEW FILE FORMAT
; THERE MAY BE WEIRD ISSUES

__CommandLineEntry: ; this will looped though the CPU scheduler (Cant change edi) eax  0 on first run and 1 on every other run 
    push edi
    mov [.Processid], byte dh

    pusha
    cmp eax, 0
    je .AppletExit ; runs cmd setup
    popa

    mov eax, [AppletPtr-__CommandLineEntry+edi] ; Every var that changes from instance to instance( local vars) has this
    cmp eax, 0
    jne .AppletRunning

    cmp [FoucusWindow], dh ; skips the while process if not in foucs
    jne .NotInFoucs
    
    

    

    mov al, [LastKeyPressedNotOnlyAscii]
    cmp al, 0x0E ; backspace
    je .undoletter

    

    mov al, [LastKeyPressed]

    
    cmp al, 0x00 ; check if unknown key pressed
    je .unknownLetter
    


    push eax
    mov ecx, [.CommandLineBufferSpot-__CommandLineEntry+edi]
    mov [.CommandLineCommandBuffer-__CommandLineEntry+edi+ecx], byte al

    add [.CommandLineBufferSpot-__CommandLineEntry+edi], dword 1

    mov [VgaCommandBuffer], byte dh
    mov [VgaCommandBuffer+1], byte 3
    mov [VgaCommandBuffer+2], byte al
    mov eax, [.VideoMemoryPoint-__CommandLineEntry+edi]
    mov [VgaCommandBuffer+3], dword eax

    add [.VideoMemoryPoint-__CommandLineEntry+edi], dword 2

    call WriteToVgaBuffer

    pop eax
    cmp al, 0x0D
    je .endOfCommand

    .nothingTodo:

    pop edi
    mov eax, 1
    ret

    
    .undoletter:
        
        
        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte ' '
        
        

        cmp [.VideoMemoryPoint-__CommandLineEntry+edi], dword 162
        je .undoletter_start

        .RestOfUndo:
        sub [.VideoMemoryPoint-__CommandLineEntry+edi], dword 2
        mov eax, [.VideoMemoryPoint-__CommandLineEntry+edi]
        mov [VgaCommandBuffer+3], dword eax
        call WriteToVgaBuffer

        cmp [.CommandLineBufferSpot-__CommandLineEntry+edi], dword 1
        jne .nothingTodo
        sub [.CommandLineBufferSpot-__CommandLineEntry+edi], dword 1


        jmp .nothingTodo
        .undoletter_start:
            
            add [.VideoMemoryPoint-__CommandLineEntry+edi], dword 2
            jmp .RestOfUndo


    .unknownLetter:

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte ' '
        mov eax, 800
        mov [VgaCommandBuffer+3], dword eax
        call WriteToVgaBuffer ; writes to the vga driver to prevent weird errors 

        pop edi
        ret
    
    .endOfCommand:
        mov [.offset], edi
        sub [.VideoMemoryPoint-__CommandLineEntry+edi], dword 2
        mov dh, [.Processid]
        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3 ; fix up that vga driver bug
        mov [VgaCommandBuffer+2], byte ' '
        mov eax, [.VideoMemoryPoint-__CommandLineEntry+edi]
        
        mov [VgaCommandBuffer+3], dword eax

        call WriteToVgaBuffer

        mov edi, .RootPath
        mov esi, .CommandLineCommandBuffer
        sub esi, __CommandLineEntry
        add esi, [.offset]
        call  0x08:0x9018 ; call file system

        cmp edi, 1
        jne .AppFound
        mov ecx, edx
        
        pusha
        mov dh, [.Processid]
        mov [VgaCommandBuffer], byte dh; process id
        mov [VgaCommandBuffer+1], byte 2 ; print string
        mov [VgaCommandBuffer+2], dword 320
        mov [VgaCommandBuffer+6], dword .unknownMessagemsg
        mov [VgaCommandBuffer+14], word 0x88BB
        call WriteToVgaBuffer
        popa
        
        mov esi, Vgadrivername
        mov edi, .RootPath
        call 0x08:0x9018 ; call the file system

        call edi ; call the vga driver

        mov esi, EndOfCommandAppName
        mov edi, .RootPath
        call 0x08:0x9018
        call edi

        
        
        mov edi, [.offset]
        mov dh, [.Processid]
        call .OnStart
        mov [.VideoMemoryPoint-__CommandLineEntry+edi], dword 162

        mov [.CommandLineBufferSpot-__CommandLineEntry+edi], dword 0
        xor ecx, ecx
        .ClearCommandBuffer2:
            mov [.CommandLineCommandBuffer-__CommandLineEntry+edi+ecx], byte 0
            inc ecx
            cmp ecx, 400
            jne .ClearCommandBuffer2
        mov eax, 1
        ret
        .AppFound:
            mov esi, .CommandLineCommandBuffer ; add for app to use
            sub esi, __CommandLineEntry
            add esi, edx
            mov ecx, edx

            pusha
            mov dh, [.Processid]
            call edi
            cmp eax, 1
            je .AppletExit
            popa

            mov esi, [.offset]

            mov [AppletPtr-__CommandLineEntry+esi], dword edi

            mov edi, [.offset]
            xor ecx, ecx
            .ClearCommandBuffer:
                mov [.CommandLineCommandBuffer-__CommandLineEntry+edi+ecx], byte 0
                inc ecx
                cmp ecx, 400
                jne .ClearCommandBuffer

            
            mov eax,1
            ret

    .AppletRunning:
        
        mov esi, [AppletPtr-__CommandLineEntry+edi]
        
        call esi
        
        cmp eax, 1
        je .AppletExit
        
        ret

    .AppletExit:
        popa
        mov edi, [.offset]
        mov [AppletPtr-__CommandLineEntry+edi], dword 0



        xor ecx, ecx
        .ClearCommandBufferExit:
            mov [.CommandLineCommandBuffer-__CommandLineEntry+edi+ecx], byte 0
            inc ecx
            cmp ecx, 400
            jne .ClearCommandBufferExit

        

        call .OnStart
        mov edi, [.offset]
        mov [.VideoMemoryPoint-__CommandLineEntry+edi], dword 162
        mov [.CommandLineBufferSpot-__CommandLineEntry+edi], dword 0
        
        ret
        .appletexitontab:
                

                cmp [FoucusWindow], byte 0
                je .unknownLetter
                call 08h:VGADriverEntry

                mov ecx, 0xb8000
                xor eax, eax
                xor edx, edx
                .ShowStartText:
                    mov bl, [.startmsg+eax]
                    cmp bl, 0
                    je .exit
                    mov [ecx+edx], bl
                    inc eax
                    add edx, 2
                    jmp .ShowStartText
        
        
                .exit:
                    mov [0xb8000+160], byte '$'
        
                ret
                .startmsg db 'Welcome to Jennys os! (Tab:1)',0

    
    .CommandLineCommandBuffer: times 500 db 0 ; every seccond letter is input data (rest is bg data)
    .CommandLineBufferSpot dd 0 ; starts as one as a fix to the reset

    

    .FixedCommandBuffer: times 255 db 0
    .VgaDriverName  db 'VgaDrivers',0
    .Ps2DriverName db 'PS2Driver',0
    .RootPath db '~',0
    .bootmsg db 'Welcome To Jennys CommandLine!!', 0
    .unknownMessagemsg db 'You have typed an unknown command, maybe a typo? | press . to continue',0
    .VideoMemoryPoint dd 162
    .VgaDriverMemoryPoint dd 0
    .Ps2DriverMemoryPoint dd 0
    .offset dd 0
    .Processid db 0
    
    .NotInFoucs:

        jmp .unknownLetter

    .OnStart:

        cmp [.Processid], byte 0
        jne .appletexitontab

        mov [VgaCommandBuffer], byte dh ; process id
        mov [VgaCommandBuffer+1], byte 1; clear screen
        mov [VgaCommandBuffer+14], word 0x88BB

        call WriteToVgaBuffer


        mov [VgaCommandBuffer], byte dh; process id
        mov [VgaCommandBuffer+1], byte 2 ; print string
        mov [VgaCommandBuffer+2], dword 0
        mov [VgaCommandBuffer+6], dword .bootmsg
        mov [VgaCommandBuffer+14], word 0x88BB

        call WriteToVgaBuffer

        mov [VgaCommandBuffer], byte dh ; process id
        mov [VgaCommandBuffer+1], byte 3 ; print char command
        mov [VgaCommandBuffer+2], byte '$' ; char
        mov [VgaCommandBuffer+3], dword 160
        call WriteToVgaBuffer

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte 0x0F
        mov [VgaCommandBuffer+3], dword 161
        call WriteToVgaBuffer

        call 08h:VGADriverEntry
        
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte ' '
        mov [VgaCommandBuffer+3], dword 800

        

        ret
    WriteToVgaBuffer:
        xor ecx, ecx
        mov cl, [NumberCommands]
        mov eax, 16
        mul ecx
        mov ecx, eax

        mov eax, dword [VgaCommandBuffer]
        mov [CommandBuffer+ecx], eax

        add ecx, 4

        mov eax, dword [VgaCommandBuffer+4]
        mov [CommandBuffer+ecx], eax
        
        add ecx, 4

        mov eax, dword [VgaCommandBuffer+8]
        mov [CommandBuffer+ecx], eax

        add ecx, 4

        mov eax, dword [VgaCommandBuffer+12]
        mov [CommandBuffer+ecx], eax

        add [NumberCommands], byte 1
        ret
    IsCommandRunning db 0
    VgaCommandBuffer: times 4 dd 0
    AppletPtr dd 0