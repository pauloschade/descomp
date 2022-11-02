from Assembler import Assembler

if __name__ == '__main__':
    dir = "code/"
    file = "_EXTRA"
    in_file = f"ASM/ASM{file}.txt"
    out_file = f"BIN/BIN{file}.txt"
    a =  Assembler(9, 3 ,dir + in_file, dir + out_file, '!')
    a.convert()
