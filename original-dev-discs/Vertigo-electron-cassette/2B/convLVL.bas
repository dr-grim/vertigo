   10  *CLOSE
   20  MODE 7
   30  
   40  in%=OPENIN("levels")
   50  out%=OPENOUT("n.levels")
   60  
   70  FOR screen%=1 TO 53
   80  PRINTTAB(5,5);" Screen : ";screen%;
   90  
  100  FOR L%=1 TO 121
  110  BPUT #out%,BGET#in%
  120  NEXT
  130  
  140  colour%=BGET#in%
  150  
  160  BX%=BGET#in%+(256*BGET#in%)
  170  BY%=BGET#in%+(256*BGET#in%)
  180  BPUT#out%,BX%/4
  190  BPUT#out%,BY%/4
  200  BPUT#out%,BGET#in%
  210  
  220  JX%=BGET#in%+(256*BGET#in%)
  230  JY%=BGET#in%+(256*BGET#in%)
  240  BPUT#out%,JX%/4
  250  BPUT#out%,JY%/4
  260  
  270  block%=BGET#in%
  280  BPUT#out%,(colour%+(block%*32))
  290  
  300  NEXT
  310  
  320  CLOSE #out%
  330  CLOSE #in%
  340  
  350  PRINT'''" Finished."''
