[org 0x1c00]
db 0xbd ; so the OS knows this is a file system and not a ramdom thing in the way
db 0x33, 0xdd, 0x7F
db 0x33, 0xdd, 0x10
db 0x33, 0xdd, 0x44
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

    
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov di, 0x00
        mov si, 0x00

        mov al, 0x10

        
        mov al, 0xCC
        mov di, CommandLineBuffer
        call Filesystem.LoadFileByTag
        ;cmp al, 0
        ;je ERROR

        jmp CommandLineBuffer

      

        jmp $
        ERROR:
            mov al, 'E'
            mov dx, 0x3F8
            out dx, al 
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
        Filesystem:
            %include "drivers/filesystem.asm" 

        ;GraphicsDrivers: times 500 db 0

        CommandLineBuffer: times 500 db 0
        
        bootmsg db 'hello world', 0

        %define fileend $$
        
        times 1240-size db 0
        db 0xAF ; end of file
        db 0xFA

Commandline:
    db 0xCC
    db 0xFD
             

    mov di, GraphicsDriversCMD
    mov al, 0x10
    call CMDFS.LoadFileByTag
    cmp al, 0
    je ERRORREAD


    mov [0x09FF], byte 1
    call GraphicsDriversCMD
    



    ERRORREAD:
        mov al, 'E'
        mov dx, 0x3F8  ; Transmit data
        out dx, al
        hlt

    mov [0x09ff], byte 0
    GraphicsDriversCMD: times 500 db 0
    CMDFS:
        %include "drivers/filesystemAPPS.asm"
    db 0xAF
    db 0xFA


VGAdriver:
    db 0x10; file tag
    db 0xFD

    ;call resetcpuresistors

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
        ;call resetcpuresistors
        call clearScreen
        ret
    .disablecursor:
        
        mov dx, 0x3D4     ; DX = VGA register port
        mov al, 0x0A      ; AL = Cursor Start Register
        out dx, al        ; Set index to Cursor Start Register

        mov dx, 0x3D5     ; DX = VGA data port
        in al, dx         ; Read current value
        or al, 0x20       ; Set bit 5 (bit 5 is usually the cursor disable bit)
        out dx, al        ; Write modified value back
        ret
    .writeCharToScreen:
        mov ah, 0x00
        mov al, byte [0x09fe]
        mov bh, 0x00
        mov bl, byte [0x09fd]
        mov di, bx
        call WriteChar
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