

LoadFileByName:; esi contains string of file looking for, edi contains path name , rets edi(memory addr of file)
    mov ebx, 0x9000
    mov ecx, 0xb8000
    .Lookloop:
        mov al, [ebx]
        cmp [esi], byte al
        jne .notEQU
        
        inc ebx
        inc esi
        cmp [esi], byte 0
        je .CheckPath

        


        jmp .Lookloop

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
            cmp ebx, 0xF400
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
        mov edi, ebx
        
        ret
    .ErrorNotFound:
        mov edi, 1
        ret

    
