__TaskSwitcherEntry:
    cmp [LastKeyPressedNotOnlyAscii], byte 0x0f
    je .SwitchTask4
    ret
    ;.tmpindex dd 0
    .SwitchTask4:


        
        
        mov [FoucusWindow], byte 4
        mov [CurrentAppID], byte 4

        mov edx, [VgaBufferSpot]
        xor ebx, ebx
        xor eax, eax
        xor ecx, ecx

        .LoopUpdate: ; inverts the buffer and screen

            mov bl, [edx+eax]
            mov bh, [0xb8000+eax]
            mov [0xb8000+eax], byte bl
            mov [edx+eax], byte bh
            add eax,2
            inc ecx
            cmp ecx, 2000
            jl .LoopUpdate

        call .printontabs

        ret
        .startmsg db 'Welcome to Jennys os! (Tab:1)',0

    .printontabs:
        
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
        

        