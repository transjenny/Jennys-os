
.OpenFilesystem:

    mov ah, 0x02
    mov al, 1
    mov ch, 0x00
    mov cl, 6
    mov dh, 0x00
    mov dl, 0x80 ; assuming c drive
    mov bx, 0x9F0
    mov es, bx
    xor bx, bx
    int 13h
    jc .error

    
    cmp [0x9f00], byte 0xAA ; check for file system record
    jne .error    

    ;attempt to load the main file system 
    mov ah, 0x02
    mov al, byte [0x9f01]
    add cl, 1
    mov bx, 0x1c0
    mov es,bx
    xor bx, bx
    int 13h
    jc .error

    cmp [0x1c00], byte 0xbd ; check for main file system byte
    jne .error


    ret




.LoadFileByTag: ; di where to load it | al is tag, al will be set to 0 if fail
    mov si, 0x1c01
    ;jmp .notfound
    .gettofiles:
        inc si
        cmp [si], byte 0xBB
        jne .gettofiles
        inc si
    .lookloop:
        cmp [si], al
        je .foundfile
        
        .findnextfile:
            inc si

            cmp [si], byte 0xAF
            jne .findnextfile
            inc si
            cmp [si], byte 0xfa
            jne .findnextfile
            inc si 
            
            jmp .lookloop
        
        

    .foundfile:
        inc si 
        .copyloop:
            mov al, byte [si]
            cmp [si], byte 0xAF
            je .exit
            mov [di+bx],byte al
            inc si

            je .exit
            
            jmp .copyloop
        .exit:
            
            ret
        .error:
            
            
            ret
            



