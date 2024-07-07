import os
if True:
    f = open("system.bin", 'wb')
    f1 = open("Kernel.bin", 'rb')
    cmdasm = open("Commandline.asm", 'r+')
    cmdasmstr = cmdasm.read()
    cmdasm.close()
    cmdasm = open("Commandline.asm", 'w')


    kernelheader = bytes([0xbd,0x33, 0xdd, 0x7f, 0xbb, 0x7f]) # show end of index and define 


    EndoffileHEADER = bytes([0xAF, 0xFA]) # end of kernel header

    kernel = f1.read()

    

    TestHeader = bytes([0x10])

    filesystem = kernelheader  + kernel + EndoffileHEADER + TestHeader 

    cmd_org = 0x1c00 + filesystem.find(bytes([0xAF, 0xFA, 0x10]))
    cmdasm.write(cmdasmstr.replace("[ORGHERE]", str(hex(cmd_org+3))))
    cmdasm.close()

    os.system('nasm Commandline.asm -f bin -o cmd.bin')
    cmdasm = open('Commandline.asm', 'w').write(cmdasmstr)
    Commandline = open('cmd.bin', 'rb').read()
    filesystem += Commandline + EndoffileHEADER



    padding = b'\x00' * (20480-len(filesystem))
    filesystem+=padding

    f2 = open("system.bin", 'wb')
    f2.write(filesystem)

    f.close()
    f1.close()
    f2.close()
    print("Built system file system" )
