cp drivers/filesystem.asm drivers/filesystemAPPS.asm
rm -rf *.bin
rm -rf Filesystem/*.bin
rm -rf Filesystem/*.o

nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin

cd Filesystem
nasm KernelEntry.asm -f bin -o Kernel.bin
python BuildFilesystem.py
cp system.bin ../system.bin
cd ..

nasm Filesystem/SystemConf.asm -f bin -o systemconf.bin
cat boot.bin kernel.bin systemconf.bin system.bin >> jennys_os.bin
qemu-system-x86_64 jennys_os.bin