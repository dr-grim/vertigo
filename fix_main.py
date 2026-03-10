import sys

with open("src-unified/main.asm", "r") as f:
    text = f.read()

text = text.replace('INCLUDE "mc004.asm"\n\t\t\tINCLUDE "mc005_bbcb.asm"', 'INCLUDE "mc004.asm"\n\t\t\tINCLUDE "mc004b_bbcb.asm"\n\t\t\tINCLUDE "mc005_bbcb.asm"')

with open("src-unified/main.asm", "w") as f:
    f.write(text)
