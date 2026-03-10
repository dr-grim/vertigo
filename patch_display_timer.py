import sys

with open("src-unified/mc000a.asm", "r") as f:
    text = f.read()

text = text.replace(".display_timer_old", "\tIF BUILD_MASTER=0\n.display_timer\n\tENDIF\n.display_timer_old")
text = text.replace("STA\t&5E10,X\n\t\tELSE\n\t\t\tSTA\t&5E10,X", "STA\t&5E10,X\n\t\tELSE\n\t\t\tSTA\t&5A10,X")

with open("src-unified/mc000a.asm", "w") as f:
    f.write(text)
