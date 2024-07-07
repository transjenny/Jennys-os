import os
filesToLoad = ["Commandline.asm", "../drivers/VgaAPPDriver.asm"]
filetoLoadTAG = [0x10, 0x11]
LastFileLoadedLastBit = 0
if True:
    f = open("system.bin", 'wb')
    f1 = open("Kernel.bin", 'rb')
    


    kernelheader = bytes([0xbd,0x33, 0xdd, 0x7f, 0xbb, 0x7f]) # show end of index and define 


    EndoffileHEADER = bytes([0xAF, 0xFA]) # end of kernel header

    kernel = f1.read()

    


    

    filesystem = kernelheader  + kernel + EndoffileHEADER  
    LastFileLoadedLastBit = filesystem[len(filesystem)-3]
    for i in range(len(filesToLoad)):
        TestHeader = bytes([filetoLoadTAG[i]])
        cmdasm = open(filesToLoad[i], 'r+')
        cmdasmstr = cmdasm.read()
        cmdasm.close()
        cmdasm = open(filesToLoad[i], 'w')
        cmd_org = 0x1c01 + len(filesystem)
        print(filesToLoad[i] + " has org " + str(hex(cmd_org)))
        cmdasm.write(cmdasmstr.replace("[ORGHERE]", str(hex(cmd_org))))
        cmdasm.close()
        os.system('nasm ' + filesToLoad[i] + ' -f bin -o ' + filesToLoad[i].replace('asm', 'bin'))
        cmdasm = open(filesToLoad[i], 'w').write(cmdasmstr)
        Commandline = open(filesToLoad[i].replace('asm','bin'), 'rb').read()
        filesystem += TestHeader +  Commandline + EndoffileHEADER # addemble the file
        LastFileLoadedLastBit = filesystem[len(filesystem)-3]

    
    



    padding = b'\x00' * (20480-len(filesystem))
    filesystem+=padding

    f2 = open("system.bin", 'wb')
    f2.write(filesystem)

    f.close()
    f1.close()
    f2.close()
    print("Built system file system" )
