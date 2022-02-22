   10  MODE 7
   20  HIMEM=&1200
   30  
   40  PROCcopy("vertigo",&1900,&1900,&54A)
   50  
   60  PROCcopy("title",&FFFFFFFF,&FFFFFFFF,&27FF)
   70  
   80  PROCcopy("panel",0,0,&15E0)
   90  
  100  PROCcopy("mcode",&1100,&574E,&46E8)
  101 
  102  PROCcopy("V.level1",&0000,&0000,&04F6)
  103  PROCcopy("V.level2",&0000,&0000,&04F6)
  104  PROCcopy("V.level3",&0000,&0000,&04F6)
  105  PROCcopy("V.level4",&0000,&0000,&04F6)
  106  PROCcopy("V.level5",&0000,&0000,&04F6)
  107  PROCcopy("V.level6",&0000,&0000,&04F6)
  108  PROCcopy("V.level7",&0000,&0000,&04F6)
  110  
  120  END
  140  
  150  DEF PROCcopy(f$,l%,e%,d%)
  160  
  170  PRINT'"Loading ";f$;" ..."
  180  *DISC
  190  OSCLI("LOAD "+f$+" 1200")
  200  
  210  PRINT "Saving ";f$;" ..."
  220  *TAPE
  230  *OPT 1,2
  240  *FX 138,0,13
  250  OSCLI("SAVE "+f$+" 1200+"+STR$~d%+" "+STR$~e%+" "+STR$~l%)
  260  
  270  ENDPROC
