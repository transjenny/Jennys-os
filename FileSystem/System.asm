[org 0x9000]
[bits 32]

;file system goes 
;Nulltermanaedstring(name)
;NullTermanaedstring(type)
;NullTermanaedstring(path)

; DATA

; end of file header
;0xAA
;0xEE
;0xFF


db 'FileSystemDrivers',0 ; must stay first file in system
db 'APP',0
db '~',0

%include "FileSystem/AppFilesystemDriver.asm"

db 0xAA
db 0xEE
db 0xFF


Vgadrivername db 'VgaDrivers',0
db 'FileType',0
rootpath db '~', 0 ; ~ means root in the file system
VGADriver: ; 
    %include "Drivers/VgaDriver.asm"
    


db 0xAA
db 0xEE
db 0xFF

db 'TaskSwitcher',0
db 'APP',0
db '~',0

%include "Apps/TaskSwitcher.asm"

db 0xAA
db 0xEE
db 0xFF

db 'PS2Driver',0
db 'APP',0
db '~',0

PS2Driver:
    %include "Drivers/ps2Driver.asm"
db 0xAA
db 0xEE
db 0xFF

db 'CommandLine',0
db 'APP',0
db '~',0
CMD: 
    %include "Apps/CommandLine.asm"

db 0xAA
db 0xEE
db 0xFF

db 'CPUADDToTimer',0
db 'APP',0
db '~',0

CPUADDTIMER:; esi is memory addr of app
    pusha
    mov eax, 0x7e05
    xor ebx, ebx
    mov bl, byte [eax]
    add eax, 1
    mov [eax+ebx], dword esi
    popa
    ret
    

db 0xAA
db 0xEE
db 0xFF

db 'help', 0x0D,0
db 'APP',0
db '~',0

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


    mov esi, .Ps2DriverName
    mov edi, .RootPath
    call 0x9018 ; file system

    .waitloop:
        call edi ; call the ps2 driver
        cmp [LastKeyPressedNotOnlyAscii], byte 0x34 ; check the last key
        jne .waitloop
    call edi ; make sure to wait for the key relece


    call __CommandLineEntry.OnStart ; reset the commandline
    sub [__CommandLineEntry.VideoMemoryPoint], dword 1
    mov [__CommandLineEntry.CommandLineBufferSpot], dword 0
    popa
    ret
    .Ps2DriverName db 'PS2Driver',0
    .RootPath db '~',0

    .helpcommandstr db 'This is a command list built into Jennys Os Using the name "help" | press any key to continue',0 

db 0xAA
db 0xEE
db 0xFF



times 25600-($-$$) db 0