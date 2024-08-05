[bits 32]
[org 0x9000]

;file system goes 
;Null termanaed string(name) | add 0x0d before the null if a runnable command
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
VGADriver: 
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

commmandlinename db 'CommandLine',0
db 'APP',0
db '~',0
CMD: 
    %include "Apps/CommandLine.asm"

db 0xAA
db 0xEE
db 0xFF


db 'help', 0x0D,0
db 'APP',0
db '~',0

%include "Apps/help.asm"

db 0xAA
db 0xEE
db 0xFF

EndOfCommandAppName db 'EndOfCommandApp',0
db 'APP',0
db '~',0

%include "Apps/EndOfApp.asm"

db 0xAA
db 0xEE
db 0xFF

db 'shutdown', 0x0D, 0
db 'APP',0
db '~',0

%include "Drivers/shutdown.asm"

db 0xAA
db 0xEE
db 0xFF


%include "Drivers/MallocApps.asm"

db 'createtab', 0x0D,0
db 'App',0
db '~',0

CreateTab:
    
    mov eax, 4000
    call 08h:Malloc
    mov [VgaBufferSpot], dword eax

    mov eax, __CommandLineEntry ; starting app
    call 08h:OpenApp ; mallocs the room for the app then copys the app into the malloc
    xor ecx, ecx
    
    add [0x7e05], byte 16
    mov cl, [0x7e05]
    mov [0x7e06+ecx], dword eax ; stuff for cpu scheduler

    call 08h:EndOfCommandApp

    mov eax, 1
    ret
    

db 0xAA
db 0xEE
db 0xFF

db 'reboot', 0x0D, 0
db 'APPS', 0
db '~',0

Reboot:
    jmp 0xFFFF:0 ; cause a error, this forces the computer to reboot as theres no error handling set up atm

db 0xAA,0xEE,0xFF


times 25600-($-$$) db 0