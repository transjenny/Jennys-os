[org [ORGHERE]]


_DriverEntry:
    xor ax, ax
    call GrabInput
    mov [0x09ff], byte al

    ret



%include "../drivers/ps2Driver.asm"