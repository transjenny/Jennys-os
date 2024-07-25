EndOfCommandApp: ; will never enter the Cpu shdulder so not setup to
    mov esi, .Ps2DriverName
    mov edi, .RootPath
    call 0x9018 ; file system

    .waitloop:
        call edi ; call the ps2 driver
        cmp [LastKeyPressedNotOnlyAscii], byte 0x34 ; check the last key
        jne .waitloop
    call edi ; make sure to wait for the key relece


    call __CommandLineEntry.OnStart ; reset the commandline
    mov [__CommandLineEntry.VideoMemoryPoint], dword 162
    mov [__CommandLineEntry.CommandLineBufferSpot], dword 0
    ret
    .Ps2DriverName db 'PS2Driver',0
    .RootPath db '~',0