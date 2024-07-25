

__CommandLineEntry: ; this will looped though the CPU scheduler (Cant change edi) eax  0 on first run and 1 on every other run 
    
    push edi
    cmp eax, 0
    je .OnStart ; runs cmd setup

    mov al, [LastKeyPressed]

    
    cmp al, 0x00 ; check if unknown key pressed
    je .nothingTodo
    


    push eax
    mov ecx, [.CommandLineBufferSpot]
    mov [.CommandLineCommandBuffer+ecx], byte al

    add [.CommandLineBufferSpot], dword 1

    mov [VgaCommandBuffer], byte dh
    mov [VgaCommandBuffer+1], byte 3
    mov [VgaCommandBuffer+2], byte al
    mov eax, [.VideoMemoryPoint]
    mov [VgaCommandBuffer+3], dword eax

    add [.VideoMemoryPoint], dword 1

    call WriteToVgaBuffer

    pop eax
    cmp al, 0x0D
    je .endOfCommand

    .nothingTodo:

    pop edi
    mov eax, 1
    ret

    


    .unknownLetter:
        pop edi
        ret
    
    .endOfCommand:
        
        

        mov [VgaCommandBuffer], byte dh
        mov [VgaCommandBuffer+1], byte 3 ; fix up that vga driver bug
        mov [VgaCommandBuffer+2], byte ' '
        mov eax, [.VideoMemoryPoint]
        sub eax, 1
        mov [VgaCommandBuffer+3], dword eax

        call WriteToVgaBuffer

        add [.VideoMemoryPoint], dword 1

        mov ecx, 1
        mov ebx, 0
        .fixloop:
            mov al, [.CommandLineCommandBuffer+ecx]
            mov [.FixedCommandBuffer+ebx], al
            add ecx, 2
            inc ebx
            cmp al, 0x0D
            jne .fixloop
        mov ecx, 0
        

        
        mov edi, .RootPath
        mov esi, .FixedCommandBuffer
        call 0x9018 ; call file system

        
        cmp edi, 1
        jne .AppFound

        mov al, [.FixedCommandBuffer]
        mov [0xb8000], byte al
        mov al, [.FixedCommandBuffer+1]
        mov [0xb8002], byte al
        mov al, [.FixedCommandBuffer+2]
        mov [0xb8004], byte al
        mov al, [.FixedCommandBuffer+3]
        mov [0xb8006], byte al
        mov al, [.FixedCommandBuffer+4]
        mov [0xb8008], byte al
        mov al, [.FixedCommandBuffer+5]
        mov [0xb800A], byte al

        pop edi
        mov eax, 1
        ret
        .AppFound:
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
    .CommandLineBufferSpot dd 1 ; starts as one as a fix to the reset

    .FixedCommandBuffer: times 255 db 0
    .VgaDriverName  db 'VgaDrivers',0
    .Ps2DriverName db 'PS2Driver',0
    .RootPath db '~',0
    .bootmsg db 'Welcome To Jennys CommandLine!!', 0
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
    
    
