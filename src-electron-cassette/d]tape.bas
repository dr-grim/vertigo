   10  MODE 7
   20  HIMEM=&1100
   30  
   40  PROCcopy("vertigo",&1900,&1900,&3AB)
   50  
   60  PROCcopy("title",&FFFFFFFF,&FFFFFFFF,&27FF)
   70  
   80  PROCcopy("panel",0,0,&15E0)
   90  
  100  PROCcopy("mcode",&1100,&6502,&54D6)
  110  
  120  END
  140  
  150  DEF PROCcopy(f$,l%,e%,d%)
  160  
  170  PRINT'"Loading ";f$;" ..."
  180  *DISC
  190  OSCLI("LOAD "+f$+" 1100")
  200  
  210  PRINT "Saving ";f$;" ..."
  220  *TAPE
  230  *OPT 1,2
  240  *FX 138,0,13
  250  OSCLI("SAVE "+f$+" 1100+"+STR$~d%+" "+STR$~e%+" "+STR$~l%)
  260  
  270  ENDPROC
