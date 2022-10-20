from Assembler import Assembler

if __name__ == '__main__':
    dir = "code/"
    in_file = "ASM.txt"
    out_file = "BIN2.txt"
    a =  Assembler(9, 3 ,dir + in_file, dir + out_file, '!')
    a.convert()
