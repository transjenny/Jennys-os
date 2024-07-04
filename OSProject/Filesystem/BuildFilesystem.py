
f = open("system.bin", 'wb')
f1 = open("Kernel.bin", 'rb')


kernelheader = bytes([0xbd,0x33, 0xdd, 0x7f, 0xbb, 0x7f]) # show end of index and define 


EndoffileHEADER = bytes([0xAF, 0xFA]) # end of kernel header

kernel = f1.read()


filesystem = kernelheader  + kernel + EndoffileHEADER

padding = b'\x00' * (20480-len(filesystem))
filesystem+=padding

f2 = open("system.bin", 'wb')
f2.write(filesystem)

f.close()
f1.close()
f2.close()
print("Built system file system" )