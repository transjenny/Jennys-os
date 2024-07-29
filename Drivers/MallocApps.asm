db 'Malloc',0
db 'APPS',0
db '~',0

Malloc:; inputs eax(bytes to alloc) outputs eax(memory addr) ebx(index(used for free command))
    pusha
    push eax
    mov ebx, [.SpaceAfterKernel]
    mov eax, MemoryPointsAllacted
    .lookloop: ; attempt to find next point free WARNING: WILL HANG IF BUFFER FULL
        add eax, 4
        cmp [eax], dword 0
        jne .lookloop
    sub eax, 4

    add ebx, [eax] ; the memory addr in the array will be sub by [.SpaceAfterKernel] var because if not it will fail on first one
    inc ebx

    mov esi, eax
    pop eax
    mov ecx, ebx
    add ecx, eax 

    ; now esi is *MemoryPointsAllacted[currentindex] | ecx is end of area to clear | ebx is start of area to clear

    xor edx, edx
    
    .clearloop:
        mov [ebx+edx], byte 0
        inc edx

        mov edi, edx
        add edi, ebx ; if only x86 had more registors (its calcuating where it put the dword to test if its the last bit or not)
        cmp edi, ecx
        jne .clearloop ; IF ITS HANGING CHECK HERE
    
    push ebx
    push ecx ; add to the stack as i need these for the ret 

    sub ebx, [.SpaceAfterKernel]
    sub ecx, [.SpaceAfterKernel]

    mov [esi], ebx 
    mov [esi+4], ecx
    
    pop ebx
    pop ecx
    

    


    mov eax, ebx 
    push eax

    sub ebx, [.SpaceAfterKernel]
    push ebx ; stack magic

    popa

    pop eax
    pop ebx

    ret ; output eax(mem addr) ebx(index num) >> input into free command to free from malloc for other apps to use

    .SpaceAfterKernel dd 0x14600 ; caluated by 0x7e00(kernel space) + 100(kenrel size + system size) * 512(converting from sectors to bytes)

    

    .ArrayIndex: ; attempts to find the index of a var in a array (inputs eax) (outputs ebx (1 if not found))
        pusha 
        mov ebx, MemoryPointsAllacted
        xor ecx, ecx
        .findloop:
            add ecx,4
            cmp [ebx+ecx-4], dword 0xAABBCCDD
            je .notfound
            cmp [ebx+ecx-4], eax ; has -4 to offset the add for the first run otherwise it doesnt madder
            jne .findloop
        sub eax, 4

        push ecx

        popa

        pop ebx

        ret

        .notfound:
            popa
            mov ebx, 1
            ret

    MemoryPointsAllacted: times 500 dd 0 ; WARNING 255 LIMIT OF NUMBER MALLOCS 
    dd 0xAABBCCDD ; end dword to look for
    ; odd dwords are starting memoryaddr
    ; even dwords are ending memoryaddr


db 0xAA
db 0xEE
db 0xFF



db 'mallocfree',0
db 'Apps',0
db '~',0

MallocFree: ; inputs malloc table index (eax)

    call Malloc.ArrayIndex 
    cmp ebx, 1
    je .ERRNotFound

    add ebx, MemoryPointsAllacted
    mov [ebx], dword 0 
    mov [ebx+4], dword 0 

    ret


    .ERRNotFound:
        mov eax, 1
        ret


db 0xAA
db 0xEE
db 0xFF

db 'OpenApp',0 
db 'Apps',0
db '~',0

OpenApp: ; inputs file(eax)
    push eax

    xor ecx, ecx
    .incloop:
        inc ecx
        cmp [eax+ecx], byte 0xAA
        jne .incloop
        cmp [eax+ecx+1], byte 0xEE
        jne .incloop
        cmp [eax+ecx+2], byte 0xFF
        jne .incloop

    mov eax, ecx
    call Malloc
    
    pop ebx
    push eax

    .copyloop:
        mov dl, [ebx]
        mov [eax], dl
        inc ebx
        inc eax
        cmp [ebx], byte 0xAA
        jne .copyloop
        cmp [ebx+1], byte 0xEE
        jne .copyloop
        cmp [ebx+2], byte 0xFF
        jne .copyloop
        
    
    pop eax
    call eax
    jmp $

    .file dd 0


db 0xAA
db 0xEE
db 0xFF


db 'TestOpenApp',0
db 'App',0
db '~',0
SomeTestAPP:
    
    mov bl, [var-SomeTestAPP+eax]
    mov [0xb8000], bl
    ret
    
    var db 'B'


    .offset dd 0

db 0xAA
db 0xEE
db 0xFF

db 'tf', 0x0D,0
db 'app',0
db '~',0

OpenAppTest:
    

    mov eax, SomeTestAPP
    call OpenApp
    jmp $
    .filename db 'TestOpenApp',0
    .root db '~',0

    .FailRead:
        mov [0xb8000], byte 'E'
        jmp $
        hlt
    

db 0xAA
db 0xEE
db 0xFF