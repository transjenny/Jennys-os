rm -rf *.bin
rm -rf build/os.bin
rm -rf *.o

cp FileSystem/filesystemDriver.asm FileSystem/AppFilesystemDriver.asm

nasm -f bin -o boot.bin boot/boot.asm
nasm -f bin -o Kernel.bin Kernel.asm
nasm -f bin -o System.bin FileSystem/System.asm


mkdir build

cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin
cat boot.bin Kernel.bin System.bin  >> build/os.bin



qemu-system-x86_64 build/os.bin -device isa-debug-exit

rm -rf *.bin


