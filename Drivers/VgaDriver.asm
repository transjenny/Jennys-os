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

        ;mov ecx, 0
        ;.clearloop:
        ;    mov eax, 16
        ;    mul ecx
        ;    mov [CommandBuffer+eax], dword 0
        ;    inc ecx
        ;    cmp ecx, 40
        ;    jne .clearloop

        ;jmp $
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
        jmp .endofloop
        ret


    .ClearScreenShown:
        pusha
        mov ecx, 0xb8000
        .CSLoop:
            mov [ecx], byte ' '
            inc ecx
            inc ecx
            cmp ecx, 0xB8FA0
            jne .CSLoop
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
        ;jmp $
        jmp .endofloop
    
    .VgaBufferSpot: times 5000 db 0; we need to buffer 80 kb here, so we cant do that on disk.
    
CurrentAppID db 0


CommandBuffer: times 40 dd 0 ; each command is 4 dwords

CurrentCommandIndex db 0

CurrentCommandMemoryPoint dd 0

NumberCommands db 0