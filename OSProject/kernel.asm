[org 0x7e00]
[bits 16]

call OpenFilesystem

mov di, 0x7fff ; where its puting the file
mov al, 0x7F ; tag its looking for
call LoadFileByTag

jmp 0x7fff


OpenFilesystem:
    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx
    xor si, si
    xor di, di

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
    .error:
        ;call reset_writePOS
        ;mov di, 0
        ;mov si, errormsg
        ;call print
        jmp $
BuildFileSystem:
    mov cx, 0
    mov si, 0x1c01
    
    .loopA:
        mov si, 0x1c01
        add cx, 3
        mov di, cx
        add si, di

        cmp [si], byte 0xBB
        je .done

        
        jmp .file

    .done:
        ;mov di, 0
        ;mov si, testmsg
        ;call print
        ret

    
    .file:
        inc si

        mov bx, [si] ; grab the folder id

        inc si
        

        mov al, [si] ; grab file id
        inc si
        mov dl, 0x00
        .findFile:
            inc si
            cmp [si], byte al
            je .exit
            inc si
            
            
           
            mov bx, [si]
            add bx, 1
            .addloop:
                inc si
                dec bx
                jnz .addloop

            ;add si, ah
            inc si
            jmp .loopA
            

        .error:
            jmp OpenFilesystem.error
        .exit:
            

            inc si
            inc si
            inc si
            
            jmp .loopA
        
        jmp $

    .extractString:
        
        .stringloop:
            mov al, [si]
            mov [di], al
            inc si
            
            inc di
            cmp [si], byte 0
            jne .stringloop
            ret


LoadFileByTag: ; di where to load it | al is tag, al will be set to 0 if fail
    mov si, 0x1c01
    .gettofiles:
        inc si
        cmp [si], byte 0xBB
        jne .gettofiles
        inc si
        mov cl, al
    .lookloop:
        
        cmp [si], cl
        je .found
        inc si
        xor ah, ah
        mov al, 255
        inc si
        mov bl, 2
        mul bl

        add ax, 3
        .addloop:
            inc si
            dec ax
            jnz .addloop
        

        cmp si, 0x4000
        jnl .notfound
        jmp .lookloop
    .found:
        inc si
        
        mov ax, [si]
        inc si
        mov bx, [si]
        mul bx

       
        inc si
        .copyloop:
            mov bl, [si]
            mov [di], bl
            inc si
            inc di
            dec ax
            cmp ax, 0
            jne .copyloop
            ret
    .notfound:
        mov ah, 00h
        mov al, 0x03
        int 10h
        mov ah, 0x0e
        mov al, 'E'
        int 10h
        jmp $
        ret
    



Kernelentry:
    times 512 db 0
KernelMain:
    times 512 db 0
db 'Kernal ended'
times 2048-($-$$) db 0 
