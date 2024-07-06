EnablePS2:
    mov al, 0xAE
    mov dx, 0x64
    out dx, al
    ret


GrabInput:
    in al, 0x64
    test al, 0x01
    jz GrabInput
    
    in al, 0x60



    call convert_ascii
    mov di, 0
    call printChar
    cmp al, 0x00
    je .no_input
    cmp al, 0x0D
    je .NotLetter
    
    

    ret
    .no_input:
        jmp GrabInput
    .NotLetter:
        ret


convert_ascii:
        cmp al, 0x02
        je .one_pressed
        cmp al, 0x03
        je .two_pressed
        cmp al, 0x04
        je .3_pressed
        cmp al, 0x05
        je .4_pressed
        cmp al, 0x06
        je .5_pressed
        cmp al, 0x07
        je .6_pressed
        cmp al, 0x08
        je .7_pressed
        cmp al, 0x09
        je .8_pressed
        cmp al, 0x0A
        je .9_pressed
        cmp al, 0x0C
        je .sub_pressed
        cmp al, 0x0D
        je .equ_pressed
        cmp al, 0x0E
        je .backspace_pressed
        cmp al, 0x0F
        je .tab_pressed
        cmp al, 0x10
        je .q_pressed
        cmp al, 0x11
        je .w_pressed
        cmp al, 0x12
        je .e_pressed
        cmp al, 0x13
        je .r_pressed
        cmp al, 0x14
        je .t_pressed
        cmp al, 0x15
        je .y_pressed
        cmp al, 0x16
        je .u_pressed
        cmp al, 0x17
        je .i_pressed
        cmp al, 0x18
        je .o_pressed
        cmp al, 0x19
        je .p_pressed


        ;need to add [ and ]

        cmp al, 0x1C
        je .enter_pressed
        cmp al, 0x1D
        je .Lctrl_pressed
        cmp al, 0x1e
        je .a_pressed
        cmp al, 0x1F
        je .s_pressed
        cmp al, 0x20
        je .d_pressed
        cmp al, 0x21
        je .f_pressed
        cmp al, 0x22
        je .g_pressed
        cmp al, 0x23
        je .h_pressed
        cmp al, 0x24
        je .j_pressed
        cmp al, 0x25
        je .k_pressed
        cmp al, 0x26
        je .l_pressed
        cmp al, 0x27
        je .Semicolon_pressed
        cmp al, 0x28
        je .mini_quote_pressed
        cmp al, 0x29
        je .backquote_pressed
        cmp al, 0x2A
        je .leftShift_pressed
        cmp al, 0x2B
        je .backslash_pressed
        cmp al, 0x2C
        je .z_pressed
        cmp al, 0x2D
        je .x_pressed
        cmp al, 0x2E
        je .c_pressed
        cmp al, 0x2F
        je .v_pressed
        cmp al, 0x30
        je .b_pressed
        cmp al, 0x31
        je .n_pressed
        cmp al, 0x32
        je .m_pressed

        mov al, 0x00
        ret
        .one_pressed:
            mov al, '1'
            ret
        .two_pressed:
            mov al, '2'
            ret
        .3_pressed:
            mov al, '3'
            ret
        .4_pressed:
            mov al, '4'
            ret
        .5_pressed:
            mov al, '5'
            ret
        .6_pressed:
            mov al, '6'
            ret
        .7_pressed:
            mov al, '7'
            ret
        .8_pressed:
            mov al, '8'
            ret
        .9_pressed:
            mov al, '9'
            ret
        .sub_pressed:
            mov al, '-'
            ret
        .equ_pressed:
            mov al, '='
            ret
        .backspace_pressed:
            mov al, 0x08
            ret
        .tab_pressed:
            mov al, 0x09
            ret
        .q_pressed:
            mov al, 'q'
            ret
        .w_pressed:
            mov al, 'w'
            ret
        .e_pressed:
            mov al, 'e'
            ret
        .r_pressed:
            mov al, 'r'
            ret
        .t_pressed:
            mov al, 't'
            ret
        .y_pressed:
            mov al, 'y'
            ret
        .u_pressed:
            mov al, 'u'
            ret
        .i_pressed:
            mov al, 'i'
            ret
        .o_pressed:
            mov al, 'o'
            ret
        .p_pressed:
            mov al, 'p'
            ret
        .enter_pressed:
            mov al, 0x0D
            ret
        .Lctrl_pressed:
            mov al, 128
            ret
        .a_pressed:
            mov al, 'a'
            ret
        .s_pressed:
            mov al, 's'
            ret
        .d_pressed:
            mov al, 'd'
            ret
        .f_pressed:
            mov al, 'f'
            ret
        .g_pressed:
            mov al, 'g'
            ret
        .h_pressed:
            mov al, 'h'
            ret
        .j_pressed:
            mov al, 'j'
            ret
        .k_pressed:
            mov al, 'k'
            ret
        .l_pressed:
            mov al, 'l'
            ret
        .Semicolon_pressed:
            mov al, ';'
            ret
        .mini_quote_pressed:
            mov al, "'"
            ret
        .backquote_pressed:
            mov al, "`"
            ret
        .leftShift_pressed:
            mov al, 129
            ret
        .backslash_pressed:
            mov al, 0x5c
            ret
        .z_pressed:
            mov al, 'z'
            ret
        .x_pressed:
            mov al, 'x'
            ret
        .c_pressed:
            mov al, 'c'
            ret
        .v_pressed:
            mov al, 'v'
            ret
        .b_pressed:
            mov al, 'b'
            ret
        .n_pressed:
            mov al, 'n'
            ret
        .m_pressed:
            mov al, 'm'
            ret
        .comma_pressed:
            mov al, ','
            ret
        .fullstop_Pressed:
            mov al, '.'
            ret
        
        