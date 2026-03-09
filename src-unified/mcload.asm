;		TTL	mcload		; Loading machine code

;****************************************

;		EXEC	execute

;****************************************
;****************************************

	MACRO EFFECT a,b

	FOR loop, 1, b
	VDU19	a,loop
	JSR	waitq
	NEXT

	ENDMACRO


;****************************************
;****************************************

		MACRO VDU19 a, b
		LDA	#19
		JSR	oswrch
		LDA	#a
		JSR	oswrch
		LDA	#b
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		ENDMACRO

;****************************************
;****************************************

;		MACRO DEFINE address
;		LDA	#8
;		LDX	#LO(address)
;		LDY	#HI(address)
;		JSR	osword
;		ENDMACRO

;****************************************
;****************************************

	IF TARGET_DISC=0
		MACRO	LOAD oscliStrAddress			; LOAD <string_location>
					; ( Does OSCLI <string> )
		LDX	#LO(oscliStrAddress)
		LDY	#HI(oscliStrAddress)
		JSR	oscli

		ENDMACRO
	ENDIF

;****************************************
;****************************************

	IF TARGET_DISC
		MACRO	RUN			; RUN <string_location>
					; ( Does OSCLI <string> )
		LDX	#LO(@1)
		LDY	#HI(@1)
		JMP	oscli

		ENDMACRO
	ELSE
		MACRO	RUN	oscliStrAddress		; RUN <string_location>
					; ( Does OSCLI <string> )
		LDX	#LO(oscliStrAddress)
		LDY	#HI(oscliStrAddress)
		JMP	oscli

		ENDMACRO
	ENDIF

;****************************************
;****************************************

;.CHANGE		MACRO
;
;		LDA	#19
;		JSR	oswrch
;		LDA	#@1
;		JSR	oswrch
;		LDA	#@2
;		JSR	oswrch
;		LDA	#0
;		JSR	oswrch
;		JSR	oswrch
;		JSR	oswrch
;
;		ENDMACRO

;****************************************
;****************************************

;OFF		=	0
;ON		=	1+2
;OUT		=	0
;IN		=	4

;****************************************

;oswrch		=	&FFEE
;osbyte		=	&FFF4
;oscli		=	&FFF7
;osword		=	&FFF1

;romsel		=	&FE30
;romevn		=	&F4
;accreg		=	&FE34

;****************************************
;****************************************

	IF BUILD_MASTER
load_workspace	=	&70
		ORG	&400
	ELSE
		ORG	&1900
	ENDIF

.loader_code_start
.loader_code_execute

{
	IF BUILD_MASTER=0
;		DSECT
		ORG	&00

.bass_offset	SKIP	1
.bb_num		SKIP	1
.bass_pointer	SKIP	2

.main_offset	SKIP	1
.mb_num		SKIP	1
.main_pointer	SKIP	2

;		DEND
	ENDIF

;****************************************
;****************************************


		ORG loader_code_start

.execute	LDA	#229
		LDX	#1
		LDY	#0
		JSR	osbyte

		LDA	#22
		JSR	oswrch
	IF BUILD_MASTER
		LDA	#129
	ELIF TARGET_DISC
		LDA	#1
	ELSE
		LDA	#5
	ENDIF
		JSR	oswrch

		LDA	#23
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		LDA	#10
		JSR	oswrch
		LDA	#32
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

	IF BUILD_MASTER
		; Set all colours to black
		; CHANGE	1,0
		; CHANGE	2,0
		; CHANGE	3,0
		LDA	#19
		JSR	oswrch
		LDA	#1
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		LDA	#19
		JSR	oswrch
		LDA	#2
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		LDA	#19
		JSR	oswrch
		LDA	#3
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		SHADOW	ON,IN
		OSCLI	load_title_page
		SHADOW	ON,OUT

		; Colours set to red, yellow and white
		; CHANGE	1,1
		; CHANGE	2,3
		; CHANGE	3,7
		LDA	#19
		JSR	oswrch
		LDA	#1
		JSR	oswrch
		LDA	#1
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		LDA	#19
		JSR	oswrch
		LDA	#2
		JSR	oswrch
		LDA	#3
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		LDA	#19
		JSR	oswrch
		LDA	#3
		JSR	oswrch
		LDA	#7
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		OSCLI	load_bank4

		OSCLI	load_bank5

		OSCLI	load_title_page
		SHADOW	OFF,OUT

		SHADOW	OFF,IN
		OSCLI	load_panel1

		LDA	#LO(&4B80)
		STA	load_workspace
		LDA	#HI(&4B80)
		STA	load_workspace+1

		LDY	#0

.cls_loop1	LDA	#0
.cls_loop2	STA	(load_workspace),Y
		INY
		BNE	cls_loop2

		INC	load_workspace+1
		LDA	load_workspace+1
		CMP	#&65
		BLT	cls_loop1

		OSCLI	load_panel2
		SHADOW	ON,OUT

		; Swap so we can use JMP not JSR
		; OSCLI	run_main_game

		LDX	#LO(run_main_game)
		LDY	#HI(run_main_game)
		JMP	oscli
	ELSE
		DEFINE	envelope3
		DEFINE	envelope4
;*		DEFINE	envelope5

;*		DEFINE	envelope6
;*		DEFINE	envelope7
;*		DEFINE	envelope8
;*		DEFINE	envelope9
;*		DEFINE	envelope10

		LDA	#15
		LDX	#0
		JSR	osbyte

	VDU19	0,0
	VDU19	1,0
	VDU19	2,0
	VDU19	3,0

	IF TARGET_DISC
		OSCLI	title_page
	ELSE
		LOAD	title_page
	ENDIF

	EFFECT	1,7
		EFFECT	1,1
	EFFECT	2,7
		EFFECT	2,3
	EFFECT	3,7
		EFFECT	3,7

		LDA	#&81
		LDX	#0
		LDY	#20
		JSR	osbyte


		LDA	#12
		JSR	oswrch

		LDA	#22
		JSR	oswrch
		LDA	#4
		JSR	oswrch

		LDA	#23
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		LDA	#10
		JSR	oswrch
		LDA	#32
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch
		JSR	oswrch

		LDA	#28
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		LDA	#13
		JSR	oswrch
		LDA	#39
		JSR	oswrch
		LDA	#11
		JSR	oswrch


; * * * * * * * * * * * * * * * * * * * *

		LDX	#0
		TXA
.w_lp		STA	&00,X
		INX
		CPX	#&90
		BNE	w_lp

		LDA	#229
		LDX	#1
		LDY	#0
		JSR	osbyte

		LDA	#15
		LDX	#0
		JSR	osbyte

		LDA	#4
		LDX	#1
		JSR	osbyte


		LDA	#235
		JSR	osbyte

; * * * * * * * * * * * * * * * * * * * *

	IF TARGET_DISC
		OSCLI	panel

		;RUN	main_game
		LDX	#LO(main_game)
		LDY	#HI(main_game)
		JMP	oscli
	ELSE
		LOAD	panel

		RUN	main_game
	ENDIF
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER=0
.waitq		LDA	#19
		JSR	osbyte
		JSR	osbyte
		JSR	osbyte
		JSR	osbyte
		JSR	osbyte
		JMP	osbyte
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER
.load_title_page	EQUS	"LOAD title 3000", &0D

.load_bank4		EQUS	"SRLOAD bank4 8000 4 Q", &0D
.load_bank5		EQUS	"SRLOAD bank5 8000 5 Q", &0D

.load_panel1		EQUS	"LOAD panel1 3000", &0D
.load_panel2		EQUS	"LOAD panel2 6480", &0D

.run_main_game	EQUS	"RUN mcode", &0D
	ELSE
	IF TARGET_DISC
.title_page	EQUS	"LOAD title 3000", &0D
	ELSE
.title_page	EQUS	"LOAD title 5800", &0D
	ENDIF

.panel		EQUS	"LOAD panel 6A20", &0D

.main_game	EQUS	"RUN mcode", &0D
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER=0
.envelope3	EQUB	3,129,-1,2,0,2,30,0,120,-10,-5,-3,120,120
.envelope4	EQUB	4,1,0,0,0,0,0,0,120,-3,-2,-1,120,120
;*envelope5	EQUB	5,0,0,0,0,0,0,0,100,-10,-3,-1,100,30

;*envelope6	EQUB	6,1,0,0,0,0,0,0,100,-5,-3,-4,100,60
;*envelope7	EQUB	7,1,0,0,0,0,0,0,100,-4,-1,-1,100,80
;*envelope8	EQUB	8,1,0,0,0,0,0,0,126,-10,-5,-10,126,66
;*envelope9	EQUB	9,1,0,0,0,0,0,0,110,-20,-10,-20,110,50
;*envelope10	EQUB	10,1,0,0,0,0,0,0,60,-1,0,-1,60,30
	ENDIF

;****************************************
;****************************************
}

.loader_code_end
