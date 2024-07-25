HelpCommand:
    pusha
    mov [VgaCommandBuffer], byte dh; process id
    mov [VgaCommandBuffer+1], byte 2 ; print string
    mov [VgaCommandBuffer+2], dword 320
    mov [VgaCommandBuffer+6], dword .helpcommandstr
    mov [VgaCommandBuffer+14], word 0x88BB

    call WriteToVgaBuffer

    mov [IsCommandRunning], byte 1
    

    mov esi, Vgadrivername
    mov edi, .RootPath
    call 0x9018 ; file system

    call edi ; run the VGA driver

    mov esi, EndOfCommandAppName
    mov edi, .RootPath
    call 0x9018 ; file system

    call edi ; call the end of command app

    mov [__CommandLineEntry.VideoMemoryPoint], dword 162
    
    popa
    ret
    .Ps2DriverName db 'PS2Driver',0
    .RootPath db '~',0

    .helpcommandstr db 'This is a command list built into Jennys Os Using the name "help" help(this),   thats it | press . to continue',0 
