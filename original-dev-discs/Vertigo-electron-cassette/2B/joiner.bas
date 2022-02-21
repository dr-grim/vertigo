   10  *CLOSE
   20  MODE 7
   30  
   40  PRINT " Join :"'
   50  PRINT "1) Levels"
   60  PRINT "2) Sprites + speech ( bank4 )"
   70  INPUT '" Enter your choice : "C
   80  CLS
   90  ON C GOTO 110,240
  100  
  110  PRINT''" Joining level files ..."'
  120  X%=OPENOUT("levels")
  130  total%=0
  140  PROCjoin("LEVEL1")
  150  PROCjoin("LEVEL2")
  160  PROCjoin("LEVEL3")
  170  PROCjoin("LEVEL4")
  180  PROCjoin("LEVEL5")
  190  PROCjoin2("LEVEL6",3*132)
  200  PRINT ''" JOINED : levels &";~total%''
  210  CLOSE #X%
  220  END
  230  
  240  PRINT''" Joining sprite files ..."'
  250  X%=OPENOUT("bank4")
  260  total%=0
  270  PRINT'"bank4"'
  280  PROCjoin("ball")
  290  PROCjoin("jewel")
  300  PROCjoin("nasty")
  310  PROCjoin("wipeout")
  320  PROCjoin("final")
  330  PROCjoin("eolevel")
  340  PROCjoin("largeBa")
  350  PROCjoin("ball.sp")
  360  PROCjoin("mums.sp")
  370  PROCjoin("n.levels")
  380  CLOSE #X%
  390  PRINT ''"JOINED : bank4 &";~total%''
  400  END
  410  
  420  DEF PROCjoin(file$)
  430  Y%=OPENIN(file$)
  440  PRINT "File : ";file$;" &";~EXT#Y%
  450  total%=total%+EXT#Y%
  460  REPEAT
  470  BPUT #X%,BGET#Y%
  480  UNTIL EOF #Y%
  490  CLOSE #Y%
  500  ENDPROC
  510  
  520  DEF PROCjoin2(file$,len%)
  530  Y%=OPENIN(file$)
  540  PRINT "File : ";file$;" &";~len%
  550  total%=total%+len%
  560  FOR C%=1 TO len%
  570  BPUT #X%,BGET#Y%
  580  NEXT
  590  CLOSE #Y%
  600  ENDPROC
