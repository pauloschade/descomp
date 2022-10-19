from helpers import addr

class Assembler:
    def __init__(self, bits_size, regs_n, path_in, path_out, label_tag):
        self.bits_size = bits_size
        self.regs_n = regs_n
        self.path_in = path_in
        self.path_out = path_out
        self.label_tag = label_tag
        self.chars = ['@', '$', 'R']
    
    def convert(self):
        lines = self._get_lines()
        lines = self._clear(lines)
        lines_r = lines.copy()
        lines_r = self._replace_labels(lines_r)
        with open(self.path_out, "w") as fout:
            for i in range(len(lines_r)):
                line = lines_r[i].strip('\n')
                bin = self._convert_value(line)
                txt = 'tmp(' + str(i) + ') := ' + bin + ';' + ' -- ' + lines[i] + '\n'
                fout.write(txt)

    def _convert_value(self, line):
        elements = line.split(" ")
        if len(elements) == 1:
            return self._format_output(elements[0], 0, 0)

        for i in self.chars:
            if i in elements[1]:
                el_1 = elements[1].strip(i)
        if len(elements) == 2:
            print(el_1)
            return self._format_output(elements[0], 0, el_1)
        
        for i in self.chars:
            if i in elements[2]:
                el_2 = elements[2].strip(i)
        return self._format_output(elements[0], el_1, el_2)

        # if not (any(x in line for x in self.chars)):
        #     return self._format_output(line, 0)
        # for i in self.chars:
        #     if i in line:
        #         vals = line.split(i)
        # return self._format_output(vals[0], vals[1])

    def _format_output(self, mne, reg, val):
        if type(val) == str:
            val = val.strip('\n')
            if val in addr.keys():
                val = addr[val]
        return mne + ' & ' + self._format_bin(reg, self.regs_n) + ' & ' + self._format_bin(val, self.bits_size)

    def _replace_labels(self, arr):
        label_dict, arr = self._find_labels(arr)
        for i in range(len(arr)):
            if arr[i][0] == 'J':
                for label in label_dict:
                    if label in arr[i]:
                        print(label)
                        arr[i] = arr[i].replace(label, label_dict[label])

        return arr

    def _format_bin(self, val, size):
        return  '"'+ bin(int(val))[2:].zfill(size) + '"'
                    

    def _find_labels(self, arr):
        dict_ = {}
        for i in range(len(arr)):
            if arr[i][0] == self.label_tag:
                label = (arr[i].split(self.label_tag)[1]).strip('\n')
                dict_[label] = '@' + str(i+1)
                arr[i] = 'NOP'
        return dict_, arr
                
    def _clear(self, arr):
        return list(filter(('\n').__ne__, arr))

    def _get_lines(self):
        with open(self.path_in, "r") as fin: #Abre o arquivo ASM
            return fin.readlines()

# a = Assembler(9, "ASM.txt", "out2.txt", '!')
# a.convert()

        
