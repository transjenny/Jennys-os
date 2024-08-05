__Ps2Entry:
    cmp [Wait_input], byte 0
    je .InputWithWait
    jmp .InputWithOutWait
    

    .GetInput:
        in al, 0x60
        call .ConvertText
        mov [LastKeyPressed], byte al
        mov [KeyJustPressed], byte 1
        ret

    .NoInput:
        mov [KeyJustPressed], byte 0
        mov [LastKeyPressed], byte 0
        ret

    .InputWithWait:
        in al, 0x64
        test al, 1
        jz .InputWithWait
        jmp .GetInput
    .InputWithOutWait: ; basicly disables the input
        in al, 0x64
        test al, 1
        jz .NoInput
        jmp .GetInput

    .ConvertText: ; dont wonna hear it
        mov ecx, 0x00

        cmp al, [.ConvertTableScanCode]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found
        inc ecx
        cmp al, [.ConvertTableScanCode+ecx]
        je .Found

        mov [LastKeyPressedNotOnlyAscii], al
        mov al, 0x00
        
        ret

        .IncludeOnlyAscii:
            mov al, 0x00
            ret

        .IncludeNonAscii:
            ret


        .Found:
            
            mov al, [.ConverTableAscii+ecx]
            ret

    .ConverTableAscii db 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', ' ', 0x0D
    .ConvertTableScanCode db 0x1e, 0x30, 0x2e, 0x20, 0x12,0x21,0x22,0x23,0x17,0x24,0x25,0x26,0x32,0x31,0x18,0x19,0x10,0x13,0x1f,0x14,0x16,0x2f,0x11,0x2d,0x15,0x2c, 0x39, 0x1C, 0xFF ; TODO ADD MORE


IncludeOnlyAscii db 1
Wait_input db 1
FoucusWindow db 0
LastKeyPressed db 0, 0, 0, 0 ; formated like this as its an array
LastKeyPressedNotOnlyAscii db 0,0,0,0
KeyJustPressed db 0