;		TTL	mc001		; Initialises game,loads in data,etc

;****************************************
;****************************************

	IF BUILD_MASTER
.execute	LDA	#200	; clear memory on break, disable escape key
		LDX	#3
		JSR	osbyte

		LDA	#&4C	; store JMP &0287 at break vector to lock machine up! (!)
		STA	&287
		LDA	#&87
		STA	&288
		LDA	#&02
		STA	&289

		LDA	#229
		LDX	#1
		LDY	#0
		JSR	osbyte

		LDA	#4	; Disable copy editing, cursor keys return codes instead
		LDX	#1
		JSR	osbyte

;*		DEFINE	envelope3
;*		DEFINE	envelope4
;*		DEFINE	envelope5

		LDA	#LO(brk)
		STA	&202
		LDA	#HI(brk)
		STA	&203

;*		JSR	envelope_on

		JSR	define_font

		LDX	#0
.w_lp		STZ	&00,X
		INX
		CPX	#&90
		BNE	w_lp

	LDA	#3
	STA	music_volume
	STA	sound_volume

	JSR	music_onoff

		LDA	#LO(events_bit)
		STA	&220
		LDA	#HI(events_bit)
		STA	&221

		LDA	#14
		LDX	#4
		JSR	osbyte

		JSR	init_music

		BANK	4

		LDA	#%11000000	; menu status
		STA	menu_st
	ELSE
		IF BUILD_BBCB OR BUILD_ELECTRON
.exec2_lbl	LDA	#0
		STA	old_level2
		ENDIF

	JSR	def_env
	ENDIF

.iBM
	IF BUILD_MASTER
		LDA	#1		; screen
		STA	screen_number
		STZ	level_number	; level
		STZ	score		; score
		STZ	score+1
		STZ	score+2
		STZ	score+3
		STZ	score+4
		STZ	controller	; not demo
	ELSE
		LDX	#1
		STX	level_number
		DEX
		STX	screen_number

		STX	score		; score
		STX	score+1
		STX	score+2
		STX	score+3
		STX	score+4
		STX	controller	; not demo
	ENDIF

.start		JSR	demo

.st2		LDA	start_type
		BNE	not_1stlev

	IF BUILD_MASTER
		LDA	#1		; screen
		STA	screen_number
		STZ	level_number	; level
		JSR	level

		BRA	skip_n1l
	ELSE
		LDX	#1		; screen
		STX	screen_number
		STX	level_number	; level

		JMP	skip_n1l
	ENDIF

.not_1stlev	LDA	old_screen
		STA	screen_number
	IF BUILD_MASTER
		LDA	old_level
		DEA
		STA	level_number
		JSR	level
	ELSE
		LDX	old_level
		STX	level_number
	ENDIF

		LDA	screen_number
		CMP	#1
		BNE	cheaton
		LDA	level_number
		CMP	#1
		BNE	cheaton

	IF BUILD_MASTER
		BRA	skip_n1l
	ELSE
		BEQ	skip_n1l
	ENDIF

.cheaton	LDA	controller
		ORA	#2
		STA	controller

.skip_n1l	LDA	controller
		AND	#127
		STA	controller

		JSR	reset_status

.ds
	IF BUILD_MASTER=0
		LDA	#0
		STA	timer_frames
		STA	timer_frames+1
		STA	timer_frames+2

		STA	timer_status
	ENDIF

		JSR	venetian

		JSR	screen		; Draw screen

.n		LDA	lives
		STA	old_lives

		JSR	go

		DEC	lives
		LDA	lives
		CMP	#255
		BEQ	deceased

		LDA	lives
		CMP	old_lives
		BLT	not_ds

	IF BUILD_MASTER
		LDA	level_number
		DEA
		ASL	A
		TAY
		LDA	timer_speeds,Y
;*		CLC
		ADC	timer_digits
		STA	timer_digits

		LDA	timer_speeds+1,Y
		ADC	timer_digits+1
		STA	timer_digits+1
	ELSE
		LDY	level_number
		DEY
		TYA
		ASL	A
		TAY
		LDA	timer_speeds,Y
		ADC	timer_digits
		STA	timer_digits

		LDA	timer_speeds+1,Y
		ADC	timer_digits+1
		STA	timer_digits+1
	ENDIF


.test_dig0	LDA	timer_digits
		CMP	#4
		BLT	not_0ov

		LDA	#4
		STA	timer_digits

	IF BUILD_MASTER
		STZ	timer_digits+1
		STZ	timer_digits+2
		STZ	timer_frames
		STZ	timer_frames+1
		STZ	timer_frames+2

		STZ	timer_status

		BRA	ds
	ELSE
		LDA	#0
		STA	timer_digits+1
		STA	timer_digits+2
		BEQ	ds
	ENDIF

.not_0ov	LDA	timer_digits+1
		CMP	#10
		BLT	ds

		INC	timer_digits
	IF BUILD_MASTER
		STZ	timer_digits+1
		BRA	test_dig0
	ELSE
		LDA	#0
		STA	timer_digits+1
		BEQ	test_dig0
	ENDIF

.not_ds
	IF BUILD_MASTER
		STZ	timer_digits+2

		LDA	level_number
		DEA
		ASL	A
		TAY
		LDA	timer_speeds,Y
		STA	timer_digits
		LDA	timer_speeds+1,Y
		STA	timer_digits+1

		STZ	timer_frames
		STZ	timer_frames+1
		STZ	timer_frames+2

		STZ	timer_status
	ELSE
		LDA	#0
		STA	timer_digits+2

		LDX	level_number
		DEX
		TXA
		ASL	A
		TAY
		LDA	timer_speeds,Y
		STA	timer_digits
		LDA	timer_speeds+1,Y
		STA	timer_digits+1
	ENDIF

		JMP	n

.deceased	LDA	level_number
		STA	old_level
		LDA	screen_number
		STA	old_screen

		LDA	#14
		STA	workspace
		LDA	#4
	IF BUILD_MASTER
		STA	workspace+1
	ENDIF
		LDX	#9
		LDY	#1
		JSR	box

	IF BUILD_MASTER
		LDX	#LO(XXX2)
		LDY	#HI(XXX2)
		JSR	type_text
	ELSE
		LDX	#LO(XXX2)
		LDY	#HI(XXX2)
		JSR	print_text

		LDA	#6
		JSR	large_delay
	ENDIF

		LDY	#0
		JSR	compare_score
		BEQ not_new_hs_check

	IF BUILD_MASTER
		JSR	new_high_score
	ELSE
		JMP	new_high_score
	ENDIF

.not_new_hs_check
	IF BUILD_MASTER
		LDA	#8
		STA	workspace
		LDA	#10
		STA	workspace+1
		LDX	#21
		LDY	#12
		JSR	box

		LDX	#LO(hstable)
		LDY	#HI(hstable)
		JSR	print_text

		JSR	pthst
	ELSE
		JSR	do_hs
	ENDIF

		LDA	#20
		STA	workspace

.nnh_loop	LDA	#200
		JSR	key_delay

		JSR	test_start
		BCC	not_demo2

		JMP	st2

.not_demo2	DEC	workspace
		BNE	nnh_loop

		JMP	iBM

;****************************************

.new_high_score	LDA	#8
		STA	workspace
	IF BUILD_MASTER
		LDA	#8
		STA	workspace+1
	ENDIF
		LDX	#22
		LDY	#14
		JSR	box

		JSR	pthst

		LDX	#LO(XX3)
		LDY	#HI(XX3)
	IF BUILD_MASTER
		JSR	type_text
	ELSE
		JSR	print_text

		LDA	#6
		JSR	large_delay
	ENDIF

		LDX	#0
.which_hs	TXA			; Calculate HS(X) address
		STA	drmem
		ASL	A
		ASL	A
		ASL	A
		ASL	A
		ADC	drmem

		INX			; Waits until it finds a high score
		TAY			; bigger than your score, and puts
		JSR	compare_score	; it's number in X
		BNE	which_hs

		DEX
		DEX

		TXA
		STA	drmem+4

		STA	drmem
		ASL	A
		ASL	A
		ASL	A
		ASL	A
		ADC	drmem		; Find address of it

;*		CLC
		ADC	#16		; A=Address of end of name
		STA	drmem		; (max. add to be moved)

		LDY	#17		; Y=Address to move
		TAX

.mveloOp	LDA	XXXX,Y
		STA	XXXX-17,Y	; Move HS's below yours down

		INY
		CPY	drmem		; Until Y passes top
		BCC	mveloOp
		BEQ	mveloOp

		LDY	#12
		LDA	#32
.blanklp	STA	XXXX,X		; Fill your HS place with spaces
		DEX
		DEY
		BNE	blanklp

		LDA	score+4
		STA	XXXX,X		; Poke new Score
		LDA	score+3
		STA	XXXX-1,X
		LDA	score+2
		STA	XXXX-2,X
		LDA	score+1
		STA	XXXX-3,X
		LDA	score
		STA	XXXX-4,X

		INX
		STX	drmem+3		; Store name add for input routine

		JSR	pthst

		LDA	#11
		LDX	#0
		JSR	osbyte

		LDA	#21
		LDX	#0
	IF BUILD_MASTER=0
		STX	workspace
	ENDIF
		LDY	#0
		JSR	osbyte

		LDX	#17
		LDA	#13
		CLC
		ADC	drmem+4
		TAY
		JSR	move_cursor

	IF BUILD_MASTER
		STZ	workspace	; Type in name routine
	ENDIF
.all_ere
	IF BUILD_MASTER
		JSR	code		; Call Tune
	ENDIF
		LDX	#1
		LDY	#0
		LDA	#&81
		JSR	osbyte		; Read key(in X centiseconds)
		CPY	#&1B
		BNE	nscape		; Escape hit?(if not skip next lines)
		LDA	#&7E
		JSR	osbyte		; Acknowledge Escape
		JMP	all_ere		; Try 'gain
.nscape		CPY	#255
		BEQ	all_ere		; Time-Out...Try 'gain
		LDA	workspace
		CPX	#13		; RETURN?
		BEQ	name_fin
		CMP	#12
		BNE	skipabit	; End of name?
		CPX	#127		; DELETE?
		BEQ	skipabit
.notRET		JMP	all_ere
.skipabit	CPX	#32
		BCC	all_ere		; Is char<32
		CPX	#128
		BCS	all_ere		; or >127
		CPX	#127		; DELETE?
		BEQ	del_hit
		LDA	workspace
		CMP	#12
		BEQ	all_ere
;*		CLC
		ADC	drmem+3
		TAY
		TXA
		STA	XXXX,Y
		JSR	oswrch
		INC	workspace
		JMP	all_ere

.del_hit	LDA	workspace
		BEQ	all_ere
;*		CLC
		ADC	drmem+3		; WAS drmem
		TAY
		LDA	#32
		STA	XXXX-1,Y
		DEC	workspace
		LDA	#127
		JSR	oswrch
		JMP	all_ere

.name_fin	JSR	venetian
		JMP	iBM

;****************************************
;****************************************

.pthst		LDA	#13		; Y co-ord
		STA	workspace+5

		LDA	#LO(hi_scores)	; address of high score table
		STA	workspace+2
		LDA	#HI(hi_scores)
		STA	workspace+3

		LDA	#10		; number of entries in table
		STA	workspace+4

.ph_loop1	LDX	#10
		LDY	workspace+5
		JSR	move_cursor

		LDX	workspace+2
		LDY	workspace+3
		JSR	print_number

		LDX	#17
		LDY	workspace+5
		JSR	move_cursor

		LDY	#5
.ph_loop2	LDA	(workspace+2),Y
		JSR	oswrch
		INY
		CPY	#17
	IF BUILD_MASTER
		BLT	ph_loop2
	ELSE
		BCC	ph_loop2
	ENDIF

		LDA	workspace+2
	IF BUILD_MASTER
		CLC
		ADC	#17
	ELSE
		ADC	#16
	ENDIF
		STA	workspace+2
		LDA	workspace+3
	IF BUILD_MASTER
		ADC	#0
	ELSE
		BCC	ph_skip1
		INC	workspace+3
.ph_skip1
	ENDIF
		STA	workspace+3

		INC	workspace+5

		DEC	workspace+4
		BNE	ph_loop1

		RTS

;****************************************
;****************************************

	IF BUILD_MASTER
		EQUB	0
		EQUS	"VULCAN"		; Dummy !
	ENDIF

.hi_scores
.XXXX		EQUB	0,0,0,0,0
		EQUS	"  Stopped   "
		EQUB	0,0,1,0,0
		EQUS	"Snail's Pace"
		EQUB	0,0,2,0,0
		EQUS	"  Shameful  "
		EQUB	0,0,5,0,0
		EQUS	"    Slow    "
		EQUB	0,1,0,0,0
		EQUS	"  Subsonic  "
		EQUB	0,2,5,0,0
		EQUS	"   Speedy   "
		EQUB	0,5,0,0,0
		EQUS	" Supersonic "
		EQUB	1,0,0,0,0
		EQUS	"  Stylish   "
		EQUB	2,5,0,0,0
		EQUS	"   Superb   "
		EQUB	5,4,3,2,1
		EQUS	"  Superior  "

.XXX2		EQUB	31,15,5
	IF BUILD_MASTER
		EQUS	"Game Over", &0D
		EQUB	255
	ELSE
		EQUS	"Game Over"
		EQUB	0
	ENDIF

.XX3		EQUB	31,11,9
	IF BUILD_MASTER
		EQUS	"Congratulations !", &0D
		EQUB	31,14,10
		EQUS	"Hi-score!!!", &0D
		EQUB	31,11,11
		EQUS	"Type In Your Name:", &0D
		EQUB	255
	ELSE
		EQUS	"Congratulations !"
		EQUB	31,14,10
		EQUS	"Hi-score!!!"
		EQUB	31,11,11
		EQUS	"Type In Your Name:"
		EQUB	0
	ENDIF

;****************************************

	IF BUILD_MASTER
.level_number	SKIP	1
.screen_number	SKIP	1

.lives		SKIP	1

.score		SKIP	5

.frame_delay	SKIP	1
	ENDIF

.gravity	SKIP	1

;****************************************
;****************************************

;*cls2		JMP	venetian

;****************************************

.level		INC	level_number
		LDA	level_number
		CMP	#6
		BNE	not_l6

		LDA	#1
		STA	level_number

.not_l6		RTS

;****************************************

.brk		LDX	#LO(b_lets)
		LDY	#HI(b_lets)
	IF BUILD_MASTER
		JSR	type_text

		LDY	#0
.b_lp2		INY
		LDA	(&FD),Y
		JSR	oswrch
		BNE	b_lp2

		LDA	#21
		LDX	#0
		LDY	#0
		JSR	osbyte

		LDA	#129
		LDX	#0
		LDY	#3
		JSR	osbyte

		JMP	execute
	ELSE
		JSR	print_text

		JMP	brk
	ENDIF

.b_lets
	IF BUILD_MASTER
		EQUS	"Error ! "
		EQUB	255
	ELSE
		EQUS	"Err"
		EQUB	0
	ENDIF

;****************************************

.demo		LDA	controller
		AND	#254
		STA	controller

	IF BUILD_MASTER
		STZ	screen_number
		LDA	#1
		STA	level_number
	ELSE
		LDX	#0
		STX	screen_number
		LDX	old_level
		STX	level_number
	ENDIF

.s_lp1		INC	screen_number
		LDA	screen_number
		CMP	#11
		BEQ	end_of_demo

		JSR	venetian

		LDA	controller
		AND	#252
		ORA	#128
		STA	controller

		JSR	screen

		LDA	controller
		AND	#128
	IF BUILD_MASTER
		BEQ	ext_d1
	ELSE
		BEQ	ext_d12
	ENDIF

	IF BUILD_MASTER
.eTpd2		JSR	code

		LDA	#255
.d_loop1	STA	xy

		LDA	#19
		JSR	osbyte

		JSR	test_start
		BCS	ext_d1

		LDA	xy
		DEA
		BNE	d_loop1

		JMP	s_lp1

.ext_d1		CLC
		RTS
	ELSE
		JSR	do_demots
		BCS	ext_d12

		JMP	s_lp1

.ext_d12	RTS
	ENDIF

.end_of_demo	JSR	venetian

	IF BUILD_MASTER
		LDA	#8
		STA	workspace
		LDA	#10
		STA	workspace+1
		LDX	#21
		LDY	#12
		JSR	box

		LDX	#LO(hstable)
		LDY	#HI(hstable)
		JSR	print_text

		JSR	pthst

		LDA	#255
.d_loop2	STA	xy

		LDA	#19
		JSR	osbyte

		JSR	code

		JSR	test_start
		BCS	ext_d1

		LDA	xy
		DEA
		BNE	d_loop2

		JMP	demo
	ELSE
		JSR	do_hs

		JSR	do_demots
		BCS	ext_d12

		JMP	demo
	ENDIF

;****************************************

	IF BUILD_MASTER
.reset_status	STZ	score
		STZ	score+1
		STZ	score+2
		STZ	score+3
		STZ	score+4

		STZ	timer_digits+2

		LDA	level_number
		DEA
		ASL	A
		TAY
		LDA	timer_speeds,Y
		STA	timer_digits
		LDA	timer_speeds+1,Y
		STA	timer_digits+1

		STZ	timer_frames
		STZ	timer_frames+1
		STZ	timer_frames+2

		STZ	timer_status

		LDA	#3		; lives
		STA	lives

		JSR	animate_lives

		JSR	display_timer

		JSR	print_score

		RTS
	ELSE
.do_hs		LDA	#8
		STA	workspace
		LDA	#10
		LDX	#21
		LDY	#12
		JSR	box

		LDX	#LO(hstable)
		LDY	#HI(hstable)
		JSR	print_text

		JMP	pthst

.do_demots	LDX	#255
.d_loop1	STX	xy

		JSR	fx19

		JSR	test_start
		BCS	ext_d12

		LDX	xy
		DEX
		BNE	d_loop1
		RTS

.reset_status	LDA	#0
		STA	score
		STA	score+1
		STA	score+2
		STA	score+3
		STA	score+4

		STA	timer_digits+2

		LDX	level_number
		DEX
		TXA
		ASL	A
		TAY
		LDA	timer_speeds,Y
		STA	timer_digits
		LDA	timer_speeds+1,Y
		STA	timer_digits+1

		LDA	#3		; lives
		STA	lives

		JSR	animate_lives

		JSR	display_timer

		JMP	print_score
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER
.old_level	EQUB	1
.old_screen	EQUB	1

.start_type	SKIP	1
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER
.type_text	STX	workspace	; address ( MOD 256 )
		STY	workspace+1	; address ( DIV 256 )

.tt_loop	LDA	#19
		JSR	osbyte

		LDA	(workspace)
		CMP	#255
		BEQ	exit_tt

		JSR	oswrch

		LDA	workspace
		CLC
		ADC	#1
		STA	workspace
		LDA	workspace+1
		ADC	#0
		STA	workspace+1

		LDA	#50
		JSR	key_delay

		BRA	tt_loop

.exit_tt	RTS
	ENDIF

;****************************************
;****************************************

		EQUS	"This message will self-destruct."

.compare_score	LDA	score
		CMP	hi_scores,Y
		BMI not_newh
		BNE	is_newh

		LDA	score+1
		CMP	hi_scores+1,Y
		BMI not_newh
		BNE	is_newh

		LDA	score+2
		CMP	hi_scores+2,Y
		BMI not_newh
		BNE	is_newh

		LDA	score+3
		CMP	hi_scores+3,Y
		BMI not_newh
		BNE	is_newh

		LDA	score+4
		CMP	hi_scores+4,Y
		BMI not_newh
		BNE	is_newh


.not_newh	LDA	#0
		RTS

.is_newh	LDA	#255
		RTS

;****************************************
;****************************************

.hstable	EQUB	31,14,11
		EQUS	"Hi-scores :"
		EQUB	0

;****************************************
;****************************************

	IF BUILD_MASTER=0
.test_start	JSR	check_optkeys

		LDA	controller
		AND	#128
		BEQ	ts4

		INKEY	-99		; = <SPACE>
		BEQ	ts1

		LDA	menu_st
		AND	#%11111100
		STA	menu_st

		LDA	#1
		BNE	ts5

.ts1		INKEY	-49	AND &FF	; = "1"
		BEQ	ts2

		LDA	#0
		BEQ	ts5

.ts2		LDA	#128		; = HI(FIRELO())
		LDX	#0
		JSR	osbyte
		TXA
		BEQ	ts4

		LDA	menu_st
		AND	#%11111100
		ORA	#%00000001
		STA	menu_st

		LDA	#1
		BNE	ts5

.ts4		JSR	testP
		BEQ	ts6

		JSR	ts7
		BEQ	ts6

		LDA	screen_number
		STA	old_screen
		LDA	level_number
		STA	old_level

		LDA	#1
		BNE	ts5

.ts6		CLC
		RTS

.ts5		STA	start_type

		SEC
		RTS

;****************************************
;****************************************

.ts7		INKEY	-129
		BEQ	ts7

		JSR	password

		CMP	#0
		RTS

;****************************************
;****************************************

.testP		INKEY	-56	AND &FF		; = "P"
		RTS
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER
		; INCLUDE "mc001b_master.asm"
	ELSE
		INCLUDE "mc002a.asm"
	ENDIF
