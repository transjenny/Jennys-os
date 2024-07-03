[org 0x1c00]
db 0xbd ; so the OS knows this is a file system and not a ramdom thing in the way
db 0x33, 0xdd, 0x7F
db 0x33, 0xdd, 0x10

db 0xBB ; start of files and folders


;testFolder:
;    db 0xdd ; folder ID
;    db 0 ; Size of the bits needed to make folder






KernalEntry:
        %define size (fileend-filestart)
        db 0x7F
        db 255
        db 4
        %define filestart $$

        
        
        cli
        ;cli
        ;mov ax, 0xD000
        ;mov ss, ax
        ;mov sp, 0xDfff
        ;sti

        xor ax, ax
        xor bx,bx
        xor cx, cx
        xor si, si
        xor di, di
        xor dx, dx
        

        mov al, 0x10

        mov di, GraphicsDrivers
        call LoadFileByTag

        mov di, GraphicsDrivers
        mov [0x09ff], byte 0
        
        call GraphicsDrivers
    
        mov [0x09ff], byte 1
        call GraphicsDrivers
        
        mov [0x09ff], byte 3
        mov si, bootmsg
        call WriteStringToGraphicsBuffer
        mov [0x09fd], byte 4
        call GraphicsDrivers

        jmp $
        
        WriteStringToGraphicsBuffer: ;string in si
            mov di, 0x0800
            .writeloop:
                mov al, [si]
                mov [di], al
                inc si
                inc di
                cmp [si], byte 0
                jne .writeloop
                ret
    
        %include "drivers/filesystem.asm" 

        GraphicsDrivers: times 1000 db 0
        
        bootmsg db 'hello world', 0

        %define fileend $$
        
        times 1240-size db 0
        db 0xAF ; end of file
        db 0xFA
VGAdriver:
    db 0x10; file tag

    call resetcpuresistors

    cmp [0x09ff], byte 0
    je .clearscreenfunc
    cmp [0x09ff], byte 1
    je .disablecursor
    cmp [0x09ff], byte 2 
    je .writeCharToScreen
    cmp [0x09ff], byte 3
    je .WriteStringToScreen
    ret

    .clearscreenfunc:
        call resetcpuresistors
        call clearScreen
        ret
    .disablecursor:
        
        call DisableBiosCursor
        ret
    .writeCharToScreen:
        mov al, byte [0x09fe]

        mov bl, byte [0x09fd]
        mov di, bx
        call WriteChar
        mov [0x09ff], byte 0xff
        ret
    .WriteStringToScreen:
        mov si, 0x0800
        mov di, [0x09fd]
        .writeloop:
            mov al, [si]
            add di, 2
            call WriteChar
            inc si
            cmp [si], byte 0
            jne .writeloop
            ret
            
            
    
    resetcpuresistors:
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor di, di
        xor si, si
        ret
    
    ;stringbuffer: times 100 db 0
    %include "drivers/VgaDriver.asm"
    db 'end of driver'
    db 0xAF ; end of file
    db 0xfa



times 20480-($-$$) db 0

;folders have not been added

;Folders are decladed using 0x22 then there name and path(use ~ for root)
;Files are declared using 0x33 then name and path(use ~ for root), then file ID