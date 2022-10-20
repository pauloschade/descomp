from Assembler import Assembler

if __name__ == '__main__':
    dir_ASM = "ASM/"
    dir_BIN = "BIN/"
    dir = "code/"

    file_ASM = "ASM_LIMIT.txt"
    file_BIN = "BIN_LIMIT.txt"
    in_file = dir + dir_ASM + file_ASM
    out_file = dir + dir_BIN + file_BIN
    a =  Assembler(9, 3 ,in_file, out_file, '!')
    a.convert()
