[org 0x9c00]
db 0xAA ; File system symbol(thing the os looks for to make sure this is the file system)
db 40 ; number of sectors this file system is

times 512-($-$$) db 0
