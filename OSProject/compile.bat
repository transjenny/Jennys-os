@ECHO off
del *.bin


C:\Users\trans\AppData\Local\bin\NASM\nasm boot.asm -f bin -o boot.bin
C:\Users\trans\AppData\Local\bin\NASM\nasm kernel.asm -f bin -o kernel.bin

cd filesystem
C:\Users\trans\AppData\Local\bin\NASM\nasm SystemConf.asm -f bin -o systemConf.bin
C:\Users\trans\AppData\Local\bin\NASM\nasm KernelEntry.asm -f bin -o Kernel.bin
python BuildFilesystem.py
copy system.bin "../system.bin"
copy systemConf.bin "../systemconf.bin"
cd ..

copy /b boot.bin + kernel.bin + "filesystem/systemconf.bin" + "filesystem/system.bin" jennysOS.bin

"C:\Program Files\qemu\qemu-system-x86_64.exe" jennysOS.bin

