__TaskSwitcherEntry:
    cmp [LastKeyPressedNotOnlyAscii], byte 0x0f
    je .SwitchTask
    ret
    .tmpindex dd 0
    .SwitchTask:
        
        mov [FoucusWindow], byte 4
        mov [CurrentAppID], byte 4
        mov edx, [VgaCommandBuffer]
        xor ebx, ebx
        xor eax, eax
        .LoopUpdate: ; inverts the buffer and screen

            mov bl, [edx+eax]
            mov [0xb8000+eax], byte bl
            add eax,2
            inc ecx
            cmp ecx, 2000
            jl .LoopUpdate

        ret
        