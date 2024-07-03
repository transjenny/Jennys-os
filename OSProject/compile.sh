
rm -rf *.bin
nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin
nasm Filesystem/System.asm -f bin -o system.bin
nasm Filesystem/SystemConf.asm -f bin -o systemconf.bin
cat boot.bin kernel.bin systemconf.bin system.bin >> jennys_os.bin
qemu-system-x86_64 jennys_os.bin