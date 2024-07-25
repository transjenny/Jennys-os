

__CommandLineEntry: ; this will looped though the CPU scheduler (Cant change edi) eax  0 on first run and 1 on every other run 
    
    push edi
    cmp eax, 0
    je .OnStart ; runs cmd setup

    mov al, [LastKeyPressedNotOnlyAscii]
    cmp al, 0x0E ; backspace
    je .undoletter

    mov al, [LastKeyPressed]

    
    cmp al, 0x00 ; check if unknown key pressed
    je .unknownLetter
    


    push eax
    mov ecx, [.CommandLineBufferSpot]
    mov [.CommandLineCommandBuffer+ecx], byte al

    add [.CommandLineBufferSpot], dword 1

    mov [VgaCommandBuffer], byte dh
    mov [VgaCommandBuffer+1], byte 3
    mov [VgaCommandBuffer+2], byte al
    mov eax, [.VideoMemoryPoint]
    mov [VgaCommandBuffer+3], dword eax

    add [.VideoMemoryPoint], dword 2

    call WriteToVgaBuffer

    pop eax
    cmp al, 0x0D
    je .endOfCommand

    .nothingTodo:

    pop edi
    mov eax, 1
    ret

    
    .undoletter:
        sub [.VideoMemoryPoint], dword 2
        sub [.CommandLineBufferSpot], dword 1
        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte ' '
        mov eax, [.VideoMemoryPoint]
        mov [VgaCommandBuffer+3], dword eax
        call WriteToVgaBuffer
        jmp .nothingTodo



    .unknownLetter:

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte ''
        mov eax, 800
        mov [VgaCommandBuffer+3], dword eax
        call WriteToVgaBuffer

        pop edi
        ret
    
    .endOfCommand:
        
        sub [.VideoMemoryPoint], dword 2

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3 ; fix up that vga driver bug
        mov [VgaCommandBuffer+2], byte ' '
        mov eax, [.VideoMemoryPoint]
        
        mov [VgaCommandBuffer+3], dword eax

        call WriteToVgaBuffer

        mov edi, .RootPath
        mov esi, .CommandLineCommandBuffer
        call 0x9018 ; call file system

        

        cmp edi, 1
        jne .AppFound
        
        mov [VgaCommandBuffer], byte dh; process id
        mov [VgaCommandBuffer+1], byte 2 ; print string
        mov [VgaCommandBuffer+2], dword 320
        mov [VgaCommandBuffer+6], dword .unknownMessagemsg
        mov [VgaCommandBuffer+14], word 0x88BB
        call WriteToVgaBuffer

        mov esi, Vgadrivername
        mov edi, .RootPath
        call 0x9018 ; call the file system

        call edi ; call the vga driver

        call EndOfCommandApp
        
        mov [.CommandLineBufferSpot], dword 0

        pop edi
        xor ecx, ecx
        .ClearCommandBuffer2:
            mov [.CommandLineCommandBuffer+ecx], byte 0
            inc ecx
            cmp ecx, 400
            jne .ClearCommandBuffer2
        mov eax, 1
        ret
        .AppFound:
            mov esi, .CommandLineCommandBuffer ; add for app to use
            call edi
            xor ecx, ecx
            .ClearCommandBuffer:
                mov [.CommandLineCommandBuffer+ecx], byte 0
                inc ecx
                cmp ecx, 400
                jne .ClearCommandBuffer

            
            mov eax,1
            ret

    
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
    

    .OnStart:
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

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte '$'
        mov [VgaCommandBuffer+3], dword 160
        call WriteToVgaBuffer

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3
        mov [VgaCommandBuffer+2], byte 0x0F
        mov [VgaCommandBuffer+3], dword 161
        call WriteToVgaBuffer
        
        mov [.VideoMemoryPoint], dword 162
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
    
    
