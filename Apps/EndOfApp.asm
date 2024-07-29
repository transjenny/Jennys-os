EndOfCommandApp: ; will never enter the Cpu shdulder so not setup to
    mov esi, .Ps2DriverName
    mov edi, .RootPath
    call 0x9018 ; file system

    .waitloop:
        call edi ; call the ps2 driver
        cmp [LastKeyPressedNotOnlyAscii], byte 0x34 ; check the last key
        jne .waitloop
    call edi ; make sure to wait for the key relece

    mov [VgaCommandBuffer], byte dh ; process id
    mov [VgaCommandBuffer+1], byte 1; clear screen
    mov [VgaCommandBuffer+14], word 0x88BB

    call WriteToVgaBuffer

    ret
    .Ps2DriverName db 'PS2Driver',0
    .RootPath db '~',0