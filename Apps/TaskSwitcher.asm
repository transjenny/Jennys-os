__TaskSwitcherEntry:
    cmp [LastKeyPressedNotOnlyAscii], byte 0x0f
    je .SwitchTask
    ret

    .SwitchTask:
        mov [0xb8000], byte 'G'
        ret