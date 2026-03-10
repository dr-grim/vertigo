;		TTL	mc000c		; All sprite/screen routines that poke
					; directly to the shadow screen memory
;****************************************
;****************************************

	IF BUILD_MASTER
top		=	&3140
	ELSE
top		=	&58A0
	ENDIF

pntr1		=	workspace
pntr2		=	workspace+2
max_width	=	workspace+4
counter	=	workspace+5
lines		=	workspace+6
v_frame	=	workspace+7
	IF BUILD_MASTER
temp_offset	=	workspace+8
	ELSE
v_count	=	workspace+9
	ENDIF

;* * * * * * * * * * * * * * * * * * * *

.clocked1	INC	pntr1+1
		LDA	counter
		ORA	#128
		STA	counter
		IF BUILD_MASTER
			BRA	not_clocked1
		ELSE
			BNE	not_clocked1
		ENDIF

;* * * * * * * * * * * * * * * * * * * *

.clocked2	DEC	pntr2+1
		LDA	counter
		ORA	#64
		STA	counter
		IF BUILD_MASTER
			BRA	not_clocked2
		ELSE
			BNE	not_clocked2
		ENDIF

;****************************************

.venetian
	IF BUILD_MASTER
		STZ	v_frame

		SHADOW	ON,IN

.vml		JSR	delay_19

		LDA	#LO(top)
		CLC
		ADC	v_frame
		STA	pntr1
		LDA	#HI(top)
		ADC	#0
		STA	pntr1+1
		LDA	#LO(top-&100)
		CLC
		ADC	v_frame
		STA	pntr2
		LDA	#HI(top-&100)
		ADC	#0
		STA	pntr2+1

		LDA	v_frame
		CMP	#7
		BCC	not_7

		LDA	#4
		BRA	add_tmw

.not_7		CMP	#4
		BCC	not_4

		LDA	#3
		BRA	add_tmw

.not_4		CMP	#1
		BCC	not_1

		LDA	#2
		BRA	add_tmw

.not_1		LDA	#1

.add_tmw	CLC
		ADC	#3
		STA	max_width
		STA	temp_offset

		STZ	counter
		STZ	lines
	ELSE
		LDA	#0
		STA	v_frame

.vml		JSR	fx193

		LDA	#10
		STA	v_count

		LDA	#LO(top)
		CLC
		ADC	v_frame
		STA	pntr1
		LDA	#HI(top)
		ADC	#0
		STA	pntr1+1

		LDA	#LO((top-&100))
		ADC	v_frame
		STA	pntr2
		LDA	#HI((top-&100))
		ADC	#0
		STA	pntr2+1

		LDA	#5
		STA	max_width

		LDA	#0
		STA	counter
		STA	lines
	ENDIF

;* * * * * * * * * * * * * * * * * * * *

.vouter_loop	LDY	#0
		LDX	max_width

	IF BUILD_MASTER=0
		CLC
	ENDIF
.vloop1		LDA	#0
		STA	(pntr1),Y
		TYA
		CLC
		ADC	#8
		TAY
		BCS	clocked1
.not_clocked1	DEX
		BNE	vloop1

;* * * * * * * * * * * * * * * * * * * *

		LDY	#248
		LDX	max_width

	IF BUILD_MASTER=0
		SEC
	ENDIF
.vloop2		LDA	#0
		STA	(pntr2),Y
		TYA
		SEC
		SBC	#8
		TAY
		BCC	clocked2
.not_clocked2	DEX
		BNE	vloop2

;* * * * * * * * * * * * * * * * * * * *

		LDA	counter
		AND	#128
		BEQ	no_add21

		LDA	counter
		AND	#1+2+4+8+16+32+64+000
		STA	counter
		DEC	pntr1+1

.no_add21	LDA	pntr1
		CLC
		IF BUILD_MASTER
			ADC	#LO(&280)
		ELSE
			ADC	#LO(&140)
		ENDIF
		STA	pntr1
		LDA	pntr1+1
		IF BUILD_MASTER
			ADC	#HI(&280)
		ELSE
			ADC	#HI(&140)
		ENDIF
		STA	pntr1+1

;* * * * * * * * * * * * * * * * * * * *

		LDA	counter
		AND	#64
		BEQ	no_add22

		LDA	counter
		AND	#1+2+4+8+16+32+00+128
		STA	counter
		INC	pntr2+1

.no_add22	LDA	pntr2
		CLC
		IF BUILD_MASTER
			ADC	#LO(&280)
		ELSE
			ADC	#LO(&140)
		ENDIF
		STA	pntr2
		LDA	pntr2+1
		IF BUILD_MASTER
			ADC	#HI(&280)
		ELSE
			ADC	#HI(&140)
		ENDIF
		STA	pntr2+1

;* * * * * * * * * * * * * * * * * * * *

.no_extra2	LDA	counter
		AND	#48
		BNE	not_top
		INC	counter

;* * * * * * * * * * * * * * * * * * * *

	IF BUILD_MASTER
		LDA	max_width
		CLC
		ADC	#3
		STA	max_width

		LDA	max_width
		CMP	#40
		BCS	nol_1
		JMP	vouter_loop

.nol_1		LDA	counter
		AND	#1+2+4+8+00+00+64+128
		ORA	#16
		STA	counter
		LDA	#40
		STA	max_width
		STZ	lines
		BRA	no_extra2
	ELSE
		DEC	v_count

		LDX	v_count
		BMI	nol_1
		LDA	widths,X
		STA	max_width

		JMP	vouter_loop

.nol_1		LDA	counter
		AND	#1+2+4+8+00+00+64+128
		ORA	#16
		STA	counter
		LDA	#20
		STA	max_width
		LDA	#0
		STA	lines
		BEQ	no_extra2
	ENDIF

;* * * * * * * * * * * * * * * * * * * *

.not_top	CMP	#16
		BNE	not_middle
		INC	lines
		LDA	lines
	IF BUILD_MASTER
		CMP	#9
	ELSE
		CMP	#11
	ENDIF
		BEQ	nol_2

		JMP	vouter_loop

.nol_2		LDA	counter
		AND	#0+0+0+8+00+00+64+128
		ORA	#32
		STA	counter
	IF BUILD_MASTER
		LDA	temp_offset
		CMP	#7
		BNE	not_sec7

		LDA	#4
		STA	temp_offset

.not_sec7	LDA	#46
		SEC
		SBC	temp_offset
		STA	max_width
		BRA	no_extra2
	ELSE
		LDA	#255
		STA	v_count

		BNE	no_extra2
	ENDIF

;* * * * * * * * * * * * * * * * * * * *

.not_middle	INC	counter

	IF BUILD_MASTER
		LDA	max_width
		SEC
		SBC	#3
		STA	max_width

		LDA	pntr1+1
		CMP	#&7F
		BCS	nol_3
	ELSE
		INC	v_count
		LDX	v_count
		LDA	widths,X
		STA	max_width

		LDA	pntr1+1
		BMI	nol_3
	ENDIF

		JMP	vouter_loop

.nol_3		INC	v_frame
		LDA	v_frame
		CMP	#8
		BEQ	exit

		JMP	vml

.exit
	IF BUILD_MASTER
		SHADOW	ON,OUT
	ENDIF
		RTS

;****************************************
;****************************************

	IF BUILD_MASTER
.delay_19	LDA	#19
		JSR	osbyte
		JSR	osbyte
		JSR	osbyte

		SHADOW	ON,OUT
		JSR	code
		SHADOW	ON,IN

		RTS
	ELSE
.widths		EQUB	20,16,15,13,12,10,8,7,5,5,5
	ENDIF

;****************************************
;****************************************

b_or_screen	=	workspace
b_or_width	=	workspace+2
b_or_height	=	workspace+3

b_screen	=	workspace+4
b_width	=	workspace+6
b_height	=	workspace+7
	IF BUILD_MASTER
.b_chk	SKIP	1
	ENDIF

;****************************************

.box
	IF BUILD_MASTER
		STX	b_or_width
		STY	b_or_height

		STZ	b_chk

		LDA	b_or_screen	; byte X = char X * 2
		ASL	A
		TAX
	ELSE
		STA	workspace+1
		STX	b_or_width
		STY	b_or_height

		LDA	b_or_screen
		TAX
	ENDIF

.box2		LDA	b_or_screen+1	; byte Y - char Y * 8
		ASL	A
		ASL	A
		ASL	A
		TAY

		JSR	calculate_byte

		LDA	b_or_screen
		STA	b_screen
		LDA	b_or_screen+1
		STA	b_screen+1
		LDA	b_or_width
		STA	b_width
	IF BUILD_MASTER
		STZ	b_height

		SHADOW	ON,IN

		LDY	#15
	ELSE
		LDA	#0
		STA	b_height

		LDY	#7
	ENDIF

.b_loop1	LDA	(b_screen),Y
	IF BUILD_MASTER
		AND	bs_tl_mask,Y
		ORA	bs_top_left,Y
	ELSE
		AND	bs_tl_mask,X
		ORA	bs_top_left,X
	ENDIF
		STA	(b_screen),Y
	IF BUILD_MASTER
		DEY
		BPL	b_loop1

		LDA	b_screen
		CLC
		ADC	#16
		STA	b_screen
		LDA	b_screen+1
		ADC	#0
		STA	b_screen+1
	ELSE
		INX
		DEY
		BPL	b_loop1

		JSR	addtbscrn
	ENDIF

	IF BUILD_MASTER
.b_loop2out	LDY	#15
	ELSE
.b_loop2out	LDY	#7
	ENDIF
.b_loop2	LDA	bs_horiz,Y
		STA	(b_screen),Y
		DEY
		BPL	b_loop2

	IF BUILD_MASTER
		LDA	b_screen
		CLC
		ADC	#16
		STA	b_screen
		LDA	b_screen+1
		ADC	#0
		STA	b_screen+1
	ELSE
		JSR	addtbscrn
	ENDIF

		DEC	b_width
		BNE	b_loop2out

	IF BUILD_MASTER
		LDA	b_chk
		BEQ	b_n1

		LDA	b_screen
		SEC
		SBC	#8
		STA	b_screen
		LDA	b_screen+1
		SBC	#0
		STA	b_screen+1
	ENDIF

.b_n1
	IF BUILD_MASTER
		LDY	#15
.b_loop3	LDA	(b_screen),Y
		AND	bs_tr_mask,Y
		ORA	bs_top_right,Y
		STA	(b_screen),Y
		DEY
		BPL	b_loop3
	ELSE
		LDY	#7
		LDX	#0
.b_loop3	LDA	(b_screen),Y
		AND	bs_tr_mask,X
		ORA	bs_top_right,X
		STA	(b_screen),Y
		INX
		DEY
		BPL	b_loop3
	ENDIF

		LDA	b_or_screen
		CLC
		IF BUILD_MASTER
			ADC	#LO(&280)
		ELSE
			ADC	#LO(&140)
		ENDIF
		STA	b_screen
		LDA	b_or_screen+1
		IF BUILD_MASTER
			ADC	#HI(&280)
		ELSE
			ADC	#HI(&140)
		ENDIF
		STA	b_screen+1

;* * * * * * * * * * * * * * * * * * * *

.b_ml		LDA	b_or_width
		STA	b_width

	IF BUILD_MASTER
		LDY	#15

.b_mloop1	LDA	bs_verti,Y
		STA	(b_screen),Y
		DEY
		BPL	b_mloop1

		LDA	b_screen
		CLC
		ADC	#16
		STA	b_screen
		LDA	b_screen+1
		ADC	#0
		STA	b_screen+1
	ELSE
		LDY	#7
.b_mloop1	LDA	bs_verti,Y
		STA	(b_screen),Y
		DEY
		BPL	b_mloop1

		JSR	addtbscrn
	ENDIF

	IF BUILD_MASTER
.b_mloop2out	LDY	#15
.b_col		LDA	#0
.b_mloop2	STA	(b_screen),Y
		DEY
		BPL	b_mloop2

		LDA	b_screen
		CLC
		ADC	#16
		STA	b_screen
		LDA	b_screen+1
		ADC	#0
		STA	b_screen+1
	ELSE
.b_mloop2out	LDY	#7
;*b_col
		LDA	#0
.b_mloop2	STA	(b_screen),Y
		DEY
		BPL	b_mloop2

		JSR	addtbscrn
	ENDIF

		DEC	b_width
		BNE	b_mloop2out

	IF BUILD_MASTER
		LDA	b_chk
		BEQ	b_n2

		LDA	b_screen
		SEC
		SBC	#8
		STA	b_screen
		LDA	b_screen+1
		SBC	#0
		STA	b_screen+1
	ENDIF

.b_n2
	IF BUILD_MASTER
		LDY	#15
.b_mloop3	LDA	bs_verti,Y
		STA	(b_screen),Y
		DEY
		BPL	b_mloop3
	ELSE
		LDY	#7
.b_mloop3	LDA	bs_verti,Y
		STA	(b_screen),Y
		DEY
		BPL	b_mloop3
	ENDIF

		INC	b_height

		LDA	b_or_screen
		STA	b_screen
		LDA	b_or_screen+1
		STA	b_screen+1

		LDX	b_height

.b_add_loop	LDA	b_screen
		CLC
		IF BUILD_MASTER
			ADC	#LO(&280)
		ELSE
			ADC	#LO(&140)
		ENDIF
		STA	b_screen
		LDA	b_screen+1
		IF BUILD_MASTER
			ADC	#HI(&280)
		ELSE
			ADC	#HI(&140)
		ENDIF
		STA	b_screen+1
		DEX
		BPL	b_add_loop

		LDA	b_height
		CMP	b_or_height
		BEQ	b_do_bottom

	IF BUILD_MASTER=0
		DEC	b_width
		BNE	b_mloop3
	ENDIF

		JMP	b_ml

;* * * * * * * * * * * * * * * * * * * *

.b_do_bottom	LDA	b_or_width
		STA	b_width

	IF BUILD_MASTER
		LDY	#15

.b_bloop1	LDA	(b_screen),Y
		AND	bs_bl_mask,Y
		ORA	bs_bttm_left,Y
		STA	(b_screen),Y
		DEY
		BPL	b_bloop1

		LDA	b_screen
		CLC
		ADC	#16
		STA	b_screen
		LDA	b_screen+1
		ADC	#0
		STA	b_screen+1
	ELSE
		LDY	#7
		LDX	#0
.b_bloop1	LDA	(b_screen),Y
		AND	bs_tl_mask,X
		ORA	bs_top_left,X
		STA	(b_screen),Y
		INX
		DEY
		BPL	b_bloop1

		JSR	addtbscrn
	ENDIF

	IF BUILD_MASTER
.b_bloop2out	LDY	#15
	ELSE
.b_bloop2out	LDY	#7
	ENDIF
.b_bloop2	LDA	bs_horiz,Y
		STA	(b_screen),Y
		DEY
		BPL	b_bloop2

	IF BUILD_MASTER
		LDA	b_screen
		CLC
		ADC	#16
		STA	b_screen
		LDA	b_screen+1
		ADC	#0
		STA	b_screen+1
	ELSE
		JSR	addtbscrn
	ENDIF

		DEC	b_width
		BNE	b_bloop2out

	IF BUILD_MASTER
		LDA	b_chk
		BEQ	b_n3

		LDA	b_screen
		SEC
		SBC	#8
		STA	b_screen
		LDA	b_screen+1
		SBC	#0
		STA	b_screen+1
	ENDIF

.b_n3
	IF BUILD_MASTER
		LDY	#15
.b_bloop3	LDA	(b_screen),Y
		AND	bs_br_mask,Y
		ORA	bs_bttm_right,Y
		STA	(b_screen),Y
		DEY
		BPL	b_bloop3
	ELSE
		LDY	#7
		LDX	#0
.b_bloop3	LDA	(b_screen),Y
		AND	bs_tr_mask,X
		ORA	bs_top_right,X
		STA	(b_screen),Y
		INX
		DEY
		BPL	b_bloop3
	ENDIF

.exit_box
	IF BUILD_MASTER
		SHADOW	ON,OUT
	ENDIF
		RTS

;****************************************
;****************************************

.bs_top_left	EQUB	%00000000
		EQUB	%00000001
		EQUB	%00010010
		EQUB	%00110100
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101

	IF BUILD_MASTER
		EQUB	%00000000
		EQUB	%00001111
		EQUB	%11110000
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111100
		EQUB	%11101001
		EQUB	%11001010
	ENDIF

.bs_tl_mask	EQUB	%11101110
		EQUB	%11001100
		EQUB	%10001000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000

	IF BUILD_MASTER
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
	ENDIF

.bs_horiz	EQUB	%00000000
		EQUB	%00001111
		EQUB	%11110000
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11110000
		EQUB	%00001111
		EQUB	%00000000

	IF BUILD_MASTER
		EQUB	%00000000
		EQUB	%00001111
		EQUB	%11110000
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11110000
		EQUB	%00001111
		EQUB	%00000000
	ENDIF

.bs_top_right	EQUB	%00000000
		EQUB	%00001111
		EQUB	%11110000
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11110011
		EQUB	%01111001
		EQUB	%00110101

	IF BUILD_MASTER
		EQUB	%00000000
		EQUB	%00001000
		EQUB	%10000100
		EQUB	%11000010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
	ENDIF

.bs_tr_mask	EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000

	IF BUILD_MASTER
		EQUB	%01110111
		EQUB	%00110011
		EQUB	%00010001
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
	ENDIF


.bs_verti	EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101

	IF BUILD_MASTER
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
	ENDIF

	IF BUILD_MASTER
.bs_bttm_left	EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110101
		EQUB	%00110100
		EQUB	%00010010
		EQUB	%00000001
		EQUB	%00000000

		EQUB	%11001010
		EQUB	%11101001
		EQUB	%11111100
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11110000
		EQUB	%00001111
		EQUB	%00000000

.bs_bl_mask	EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%10001000
		EQUB	%11001100
		EQUB	%11101110

		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000


.bs_bttm_right	EQUB	%00110101
		EQUB	%01111001
		EQUB	%11110011
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11110000
		EQUB	%00001111
		EQUB	%00000000

		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11001010
		EQUB	%11000010
		EQUB	%10000100
		EQUB	%00001000
		EQUB	%00000000

.bs_br_mask	EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000

		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00010001
		EQUB	%00110011
		EQUB	%01110111
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER=0
.fx193		JSR	fx19
		JSR	osbyte
		JMP	osbyte

;****************************************
;****************************************

.fx194		JSR	fx19
		JMP	fx193

;****************************************
;****************************************

.addtbscrn	LDA	b_screen
		CLC
		ADC	#8
		STA	b_screen
		BCC	xit_atbs

		INC	b_screen+1

.xit_atbs	RTS

;****************************************
;****************************************

sb_pointer	=	workspace
barsize	=	workspace+2

;****************************************

.draw_sbars	LDX	#LO(&7D38)
		LDY	#HI(&7D38)
		LDA	x_bar
		JSR	do_bar

		LDX	#LO(&7D38+8)
		LDY	#HI(&7D38+8)
		LDA	y_bar
		JSR	do_bar

		LDX	#LO(&7D38+16)
		LDY	#HI(&7D38+16)
		LDA	h_bar
;*		JMP	do_bar

;****************************************
;****************************************

.do_bar		AND	#15
		STA	barsize

		STX	sb_pointer
		STY	sb_pointer+1

		LDX	barsize
		BEQ	exit_bar2

.sb_loop1	LDY	#7

.sb_loop2 	LDA	(sb_pointer),Y
		AND	#%11110001
		ORA	#%00001110
		STA	(sb_pointer),Y

		DEX
		BEQ	exit_bar1

		DEY
		BPL	sb_loop2

		JSR	sb_upaline

		BNE	sb_loop1

.exit_bar1	DEY
		BPL	exit_bar3

		JSR	sb_upaline

.exit_bar2	LDY	#7

.exit_bar3	LDA	#15
		SEC
		SBC	barsize
		TAX
		BEQ	exit_bar

.sb_loop22	LDA	(sb_pointer),Y
		AND	#%11110001
		STA	(sb_pointer),Y

		DEX
		BEQ	exit_bar

		DEY
		BPL	sb_loop22

		JSR	sb_upaline

		LDY	#7

		BNE	sb_loop22

.exit_bar	RTS

;****************************************
;****************************************

.sb_upaline	LDA	sb_pointer
		SEC
		SBC	#LO(&140)
		STA	sb_pointer
		LDA	sb_pointer+1
		SBC	#HI(&140)
		STA	sb_pointer+1

		RTS

;****************************************
;****************************************

.nasty_dshad	LDA	n_bhi
		BEQ	exit_nds

		LDX	ny_oldX
		LDY	ny_oldY
		JSR	calculate_byte

		LDY	#0
		LDA	ny_shstore
		STA	(workspace),Y

.exit_nds	RTS

;****************************************
;****************************************

.nasty_spshad	LDA	n_bhi
		BNE	not_on_holen

		RTS

.not_on_holen	LDX	old_EX

		LDA	enemy_z
		CMP	ny_oldY
		BCC	nss_sk1

		LDA	#0
		CLC
		ADC	enemy_z
		SEC
		SBC	ny_oldY
		LSR	A
		LSR	A
		CLC
		ADC	old_EY
		BNE	nss_sk2

.nss_sk1	LDA	old_EY

.nss_sk2	ADC	#8
		STA	ny_oldY
		TAY

		LDA	ny_pixoffset
		AND	#4
		BEQ	under42

		INX
		LDA	#%01111111
		BNE	skip_u42

.under42	LDA	#%11110111

.skip_u42	PHA
		STX	ny_oldX
		JSR	calculate_byte

		LDY	#0
		LDA	(workspace),Y
		STA	ny_shstore

		LDA	ny_pixoffset
		AND	#3
		TAX

		PLA

		CPX	#0
		BEQ	sp_no_lsr2

		SEC
.sp_loop2	ROR	A
		DEX
		BNE	sp_loop2

.sp_no_lsr2	STA	sp_and2+1

		LDA	(workspace),Y
.sp_and2	AND	#&FF
		STA	(workspace),Y

		RTS
	ENDIF

;****************************************
;****************************************

;	IF BUILD_MASTER
;		; INCLUDE "mc000d.asm" via main
;	ELSE
;		INCLUDE	"mc001.asm"
;	ENDIF
