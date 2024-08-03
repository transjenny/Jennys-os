VGADriverEntry:
    
    mov eax, CommandBuffer
    .CommandRunLoop:
        

        mov [CurrentCommandMemoryPoint], dword eax

        mov dl, byte [CurrentAppID]
        cmp [eax], dl
        je .IsVgaShown
        jmp .IsNotVgaShown

        .endofloop:
        add [CurrentCommandIndex], dword 1

        mov eax, [CurrentCommandMemoryPoint]
        add eax, 16
        sub [NumberCommands], byte 1
        cmp [NumberCommands], byte 0
        jne .CommandRunLoop
        
        mov [NumberCommands], byte 0


        ret


    .IsVgaShown:
        inc eax

        cmp [eax], byte 1 ; clear screen
        je .ClearScreenShown
        cmp [eax], byte 2 ; print string
        je .PrintStringShown
        cmp [eax], byte 3 ; print char
        je .PrintCharShown


        jmp .endofloop
        ret
    .IsNotVgaShown:
        inc eax
        
        cmp [eax], byte 1
        je .ClearScreenNotShown
        
        cmp [eax], byte 2
        je .PrintStringNotShown
        
        cmp [eax], byte 3
        je .PrintCharNotShown

        jmp .endofloop

        jmp .endofloop
        ret

    .ClearScreenNotShown:
        
        cmp [VgaBufferSpot], dword 0 ; skip if no buffer has been set
        je .endofloop

        mov ecx, [VgaBufferSpot]
        xor eax, eax
        .CSNSloop:
            mov [ecx+eax], byte ' '
            inc eax
            
            cmp eax, 4000
            je .CSNSloop
        
        jmp .endofloop
    .PrintStringNotShown:
        
        mov ecx, [VgaBufferSpot]
        inc eax
        mov ebx, [eax]
        add eax, 4
        add ecx, ebx
        mov esi, [eax]
        .PrintLoopNS:
            mov dl, [esi]
            mov [ecx], byte dl
            inc ecx
            inc ecx
            inc esi
            cmp [esi], byte 0
            jne .PrintLoopNS
            
            jmp .endofloop
    .PrintCharNotShown:
        
        inc eax
        mov dl, byte [eax]
        inc eax
        mov esi, [eax]
        add esi, [VgaBufferSpot]
        mov [esi], dl
        
        jmp .endofloop

    .ClearScreenShown:
        pusha
        mov ecx, 0xb8000
        .CSLoop:
            mov [ecx], byte ' '
            add ecx, 2
            cmp ecx, 0xB8FA0
            jl .CSLoop
            popa
            
            jmp .endofloop
    .PrintStringShown:
        pusha
        mov ecx, 0xb8000
        inc eax
        mov ebx, [eax]
        add eax, 4
        add ecx, ebx
        mov esi, [eax]
        .PrintLoop:
            mov dl, [esi]
            mov [ecx], byte dl
            inc ecx
            inc ecx
            inc esi
            cmp [esi], byte 0
            jne .PrintLoop
            popa
            jmp .endofloop
    .PrintCharShown:
        pusha
        inc eax
        mov dl, byte [eax]
        inc eax
        mov esi, [eax]
        add esi, 0xb8000
        mov [esi], dl
        popa
        jmp .endofloop
    
        VgaBufferSpot dd 0

CurrentAppID db 0


CommandBuffer: times 40 dd 0 ; each command is 4 dwords

CurrentCommandIndex db 0

CurrentCommandMemoryPoint dd 0

NumberCommands db 0