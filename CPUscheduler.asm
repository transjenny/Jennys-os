    


CPUschedulerStart:
    
    mov eax, 16
    mov ecx, [CpuCurrentTaskIndex]
    mul ecx
    
    pusha
    mov edi, [CPUTaskBuffer+eax]
    call CPUschedulerCycle
    
    popa

    

    add eax, 16
    cmp [CPUTaskBuffer+eax], dword 0 ; check for null dword
    je .ReachedEndOfList

    add [CpuCurrentTaskIndex], dword 1
    
    jmp CPUschedulerStart
    .ReachedEndOfList:
        mov [CpuCurrentTaskIndex], dword 0

        jmp CPUschedulerStart
CPUschedulerCycle:; edi is memory address of the func to load
    push edi
    mov eax, 16
    mov ecx, [CpuCurrentTaskIndex] ; grab the point in memory to run
    mul ecx

    
    
    
    mov edi, eax

    

    mov eax, [CpuResistorStore+edi]
    add edi, 4
    mov ebx, [CpuResistorStore+edi]
    add edi, 4
    mov ecx, [CpuResistorStore+edi]
    add edi, 4
    mov edx, [CpuResistorStore+edi]
    add edi, 4
    mov esi, [CpuResistorStore+edi]
    
    mov dh, byte [CpuCurrentTaskIndex]

    pop edi

    

    call edi

    

    mov eax, 16
    mov ecx, [CpuCurrentTaskIndex]
    mul ecx

    cmp edi, 1
    je AppExited

    mov edi, eax

    
    
    mov [CpuResistorStore+edi], dword 1
    add edi, 4
    mov [CpuResistorStore+edi], ebx
    add edi, 4
    mov [CpuResistorStore+edi], ecx
    add edi, 4
    mov [CpuResistorStore+edi], edx
    add edi, 4
    mov [CpuResistorStore+edi], esi
            
    
    

    ret
    

    AppExited:
        mov [CPUTaskBuffer+eax], dword 0 ; clear out the buffer 

        mov [CpuResistorStore+eax], dword 0 ; clear out the Resistor buffer
        add eax, 4
        mov [CpuResistorStore+eax], dword 0
        add eax, 4
        mov [CpuResistorStore+eax], dword 0
        add eax, 4
        mov [CpuResistorStore+edi], dword 0
        add eax, 4
        mov [CpuResistorStore+eax], dword 0
        ret

    .TmpTaskStore dd 0

    

CpuResistorStore: times 255 dd 0 ; cant have more then 15 tasks or the index gets overflown into

CpuCurrentTaskIndex dd 0



TasksFirstRun: times 255 dd 0

FirstStart dd 0