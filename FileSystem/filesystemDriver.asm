

LoadFileByName:; esi contains string of file looking for, edi contains path name , rets edi(memory addr of file)
    pusha 
    mov ebx, 0x9000
    .Lookloop:
        mov al, [ebx]
        cmp [esi], byte al
        jne .notEQU
        
        inc ebx
        inc esi
        cmp [esi], byte 0
        je .CheckPath

        cmp [esi], byte ' ' ; check if the file just has args
        je .CheckPathArgs


        jmp .Lookloop

    .CheckPathArgs: 
        xor ecx,ecx
        .addloop2:
            inc ebx
            cmp [ebx], byte 0
            jne .addloop2
            inc ebx
        jmp .CheckPath

    .CheckPath:
        
        mov ecx, 0
        .addloop:
            inc ecx
            cmp [ebx+ecx], byte 0
            jne .addloop
            inc ecx

        mov al, [ebx+ecx] ; get path
        mov ah, [edi]
        cmp ah, al ; check paths
        jne .notEQU

        add ebx, ecx
        inc ebx
        
        cmp [ebx], byte 0
        jne .CheckPath
        jmp .Found

    
    
    .notEQU:
        .findNextFile:
            inc ebx
            cmp ebx, 0xFFFF
            jg .ErrorNotFound

            cmp [ebx], byte 0xAA
            jne .findNextFile
            cmp [ebx+1], byte 0xEE
            jne .findNextFile
            cmp [ebx+2], byte 0xFF
            jne .findNextFile
            add ebx, 3
            jmp .Lookloop
    .Found:
        inc ebx
        push ebx

        popa

        pop ebx

        
        ret
    .ErrorNotFound:
        
        popa 
        mov edi, 1
        ret

    
