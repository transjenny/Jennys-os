[org 0x7e00]
[bits 32]
jmp _KernelEntry
CpuTaskNumber db 0

CPUTaskBuffer: times 255 dd 0







TestAPP2:        
    mov ebx, 80
    mov esi, AppTest2
    call PrintString
    ret
TestAPP3:        
    mov ebx, 80
    mov esi, AppTest3
    call PrintString
    ret


PrintString: ; string in esi current offset in ebx
    push eax
    push ebx
    push esi ; add resistors im touching to the stack

    mov eax, 2
    mul ebx

    mov ebx, eax

    add ebx, 0xb8000
    .printloop:
        mov al, [esi]
        mov byte [ebx], al
        add ebx, 2
        inc esi
        cmp [esi], byte 0
        jne .printloop

        pop esi ; restore the resistors from the stack 
        pop ebx
        pop eax
        ret






%include "Filesystem/filesystemDriver.asm"

%include "CPUscheduler.asm"

_KernelEntry:
    mov ebx, 0
    mov esi, bootmsg
    call PrintString


    mov esi, StartAPP
    mov edi, RootPath
    call LoadFileByName

    mov [CPUTaskBuffer], dword edi

    mov esi, TaskSwitcherName
    mov edi, RootPath
    call LoadFileByName

    mov [CPUTaskBuffer+16], dword edi


    mov esi, VgaDriversName
    mov edi, RootPath
    call LoadFileByName

    mov [CPUTaskBuffer+32], dword edi

    mov esi, Ps2DriverName
    mov edi, RootPath
    call LoadFileByName

    mov [CPUTaskBuffer+48], dword edi
    mov [CpuTaskNumber], byte 4
    jmp CPUschedulerStart
    
    

    

    jmp $

AppTest2 db 'this is a App2 test, lets see how this works!', 0
AppTest3 db 'This is 100% a 3rd app thats 100% doing smth!',0
bootmsg db 'This is a hello world from a 32 bit os!!', 0

StartAPP db 'CommandLine',0

TaskSwitcherName db 'TaskSwitcher',0


VgaDriversName db 'VgaDrivers', 0
RootPath db '~', 0
Ps2DriverName db 'PS2Driver',0

CPUschedulerName db 'CPUscheduler'

TestThing dd 0



times 25600-($-$$) db 0