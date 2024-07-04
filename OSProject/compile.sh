cp drivers/filesystem.asm drivers/filesystemAPPS.asm
rm -rf *.bin
nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin

cd Filesystem
gcc -march=i386 -m16 -ffreestanding KernelEntry.c -c  -o kernel.o 
ld kernel.o -m elf_i386 -Ttext 0x1c00 -o Kernel.bin 
python BuildFilesystem.py
cp system.bin ../system.bin
cd ..

nasm Filesystem/SystemConf.asm -f bin -o systemconf.bin
cat boot.bin kernel.bin systemconf.bin system.bin >> jennys_os.bin
qemu-system-x86_64 jennys_os.bin