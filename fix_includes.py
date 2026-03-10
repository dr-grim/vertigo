import sys
import re

with open("src-unified/main.asm", "r") as f:
    text = f.read()

# Replace all Master includes with merged names if possible
text = text.replace('INCLUDE "mc000b_master.asm"', 'INCLUDE "mc000b.asm"')
text = text.replace('INCLUDE "mc000d_master.asm"', 'INCLUDE "mc000d.asm"')
text = text.replace('INCLUDE "mc001b_master.asm"', 'INCLUDE "mc001b.asm"')
text = text.replace('INCLUDE "mc003b_master.asm"', 'INCLUDE "mc003b.asm"')
text = text.replace('INCLUDE "mc003c_master.asm"', 'INCLUDE "mc003c.asm"')
text = text.replace('INCLUDE "mc004b_master.asm"', 'INCLUDE "mc004b.asm"')
text = text.replace('INCLUDE "mc005a_master.asm"', 'INCLUDE "mc005a.asm"')
text = text.replace('INCLUDE "mc005b_master.asm"', 'INCLUDE "mc005b.asm"')
text = text.replace('INCLUDE "mc006a_master.asm"', 'INCLUDE "mc006a.asm"')
text = text.replace('INCLUDE "mc006b_master.asm"', 'INCLUDE "mc006b.asm"')
text = text.replace('INCLUDE "mc007_master.asm"', 'INCLUDE "mc007.asm"')
text = text.replace('INCLUDE "mc009b_master.asm"', 'INCLUDE "mc009b.asm"')
text = text.replace('INCLUDE "mc010_master.asm"', 'INCLUDE "mc010.asm"')
text = text.replace('INCLUDE "mc011_master.asm"', 'INCLUDE "mc011.asm"')
text = text.replace('INCLUDE "mc012_master.asm"', 'INCLUDE "mc012.asm"')
text = text.replace('INCLUDE "mctemp_master.asm"', 'INCLUDE "mctemp.asm"')
text = text.replace('INCLUDE "mctemp2_master.asm"', 'INCLUDE "mctemp2.asm"')

# Replace BBC B includes with merged names
text = text.replace('INCLUDE "mc002b_bbcb.asm"', 'INCLUDE "mc002b.asm"')
text = text.replace('INCLUDE "mc003b_bbcb.asm"', 'INCLUDE "mc003b.asm"')
text = text.replace('INCLUDE "mc003c_bbcb.asm"', 'INCLUDE "mc003c.asm"')
text = text.replace('INCLUDE "mc004b_bbcb.asm"', 'INCLUDE "mc004b.asm"')
text = text.replace('INCLUDE "mc005_bbcb.asm"', 'INCLUDE "mc005.asm"')
text = text.replace('INCLUDE "mc006_bbcb.asm"', 'INCLUDE "mc006.asm"')
text = text.replace('INCLUDE "mc009_bbcb.asm"', 'INCLUDE "mc009.asm"')
text = text.replace('INCLUDE "mc998_bbcb.asm"', 'INCLUDE "mc998.asm"')
text = text.replace('INCLUDE "mcmusic_bbcb.asm"', 'INCLUDE "mcmusic.asm"')
text = text.replace('INCLUDE "mcdata_bbcb.asm"', 'INCLUDE "mcdata.asm"')

with open("src-unified/main.asm", "w") as f:
    f.write(text)
