import sys

with open("src-unified/main.asm", "r") as f:
    text = f.read()

# Make sure main includes mc004b.asm instead of the removed ones
text = text.replace('INCLUDE "mc004b_master.asm"', 'INCLUDE "mc004b.asm"')
text = text.replace('INCLUDE "mc004b_bbcb.asm"', 'INCLUDE "mc004b.asm"')

with open("src-unified/main.asm", "w") as f:
    f.write(text)
