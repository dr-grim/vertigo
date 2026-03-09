;		TTL	mc002		; Draws screen

;****************************************
;****************************************

	IF BUILD_MASTER=0
.file_level	EQUS	"L.V.levelX 1100", &0D

		IF TARGET_DISC=0
.window		EQUB	28,5,20,34,11,30,10,0

.ff_tape	EQUS	"Fast Forward tape slightly,", &0D
		EQUB	10
		EQUS	"then p"
		EQUB	0

.r_tape		EQUS	"Rewind tape slightly, then", &0D
		EQUB	10
		EQUS	"p"
		EQUB	0

.press_play	EQUS	"Press play on tape ...", &0D
		EQUB	10,6,6,6
		EQUS	"Looking for V.level"
		EQUB	0

.loaded_text	EQUB	10,13
		EQUS	"Load complete.", &0D
		EQUB	26,0
		ENDIF
	ENDIF

	IF BUILD_MASTER
.screen
		BANK	5

		STZ	hit_esc

		JSR	venetian

		LDA	controller
		AND	#128
		BEQ	ntxtdTA

		LDX	#LO(demo_text)
		LDY	#HI(demo_text)
		JSR	print_pwtxt

.ntxtdTA	LDA	screen_number
		CMP	#11
		BNE	ocean
		LDA	#1
		STA	screen_number

		JSR	level

.ocean		JSR	print_score

		LDX	#2
		LDY	#26
		JSR	move_cursor

		LDA	level_number
		LDX	#0
.lingR		CMP	#10
		BCC	njR
		INX
;*		SEC
		SBC	#10
		BRA	lingR
.njR		TAY
		TXA
		BEQ	pcv
;*		CLC
		ADC	#48
		JSR	oswrch
.pcv		TYA
		CLC
		ADC	#48
		JSR	oswrch

		LDX	#2
		LDY	#29
		JSR	move_cursor

		LDA	screen_number
		CMP	#10
		BEQ	dix
;*		CLC
		ADC	#48
		JSR	oswrch
		BRA	rest

.dix		LDA	#128
		JSR	oswrch

.rest		LDA	controller
		AND	#128
		BNE	is_demo

		JSR	print_password

.is_demo	JSR	init_screen

		LDX	#0
.loop1		LDY	#9
.loop2		STX	workspace+&10
		STY	workspace+&11
		LDX	#11
		JSR	mult
		CLC
		ADC	workspace+&10
		TAY
		LDA	(pointer),Y
		AND	#1
		BEQ	miss
		LDX	workspace+&10
		LDY	workspace+&11

		; JSR	bloc ; Defined in mc002a.asm for non-master (this file is used for both but bloc is Master specific? No, bloc is below)
		; Wait, bloc IS defined in mc002.asm at line 249.
		; And it IS defined in mc002a.asm at line 200.
		; Since for non-Master we use mc002a.asm AND mc002.asm (which now has duplicate code in ELSE block), we have a problem.
		; I should remove the ELSE block content from mc002.asm and rely on mc002a.asm, OR remove mc002a.asm inclusion and put everything in mc002.asm.
		; The user advice was "mc002a.asm IS included instead of mc002.asm for non-Master".
		; But I made main.asm include mc002.asm for non-Master (via ELSE block removal? No, I added it back?).

		; Let's check main.asm again.
		; main.asm includes mc002.asm for Master.
		; main.asm includes mc002a.asm (renamed/copied) for non-Master?
		; No, main.asm currently includes mc002b.asm for non-Master, but NOT mc002a.asm (it was removed).
		; AND it includes mc002.asm via the ELSE block of IF BUILD_MASTER? No.
		; Let's look at main.asm.

		JSR	bloc

.miss		JSR	code

;*		LDA	controller
;*		AND	#128
;*		BEQ	not_demo

		JSR	test_start
		BCC	not_demo

		LDA	controller
		AND	#128
		BEQ	not_demo999

		LDA	controller
		AND	#127
		STA	controller
		RTS
;*		JMP	exit_screen

.not_demo999	JMP	screen

.not_demo

;*		INKEY	-120
;*		BEQ	not_copy
;*
;*		JSR	draw_menu
;*
;*not_copy	JSR	check_optkeys

		LDX	workspace+&10
		LDY	workspace+&11
		DEY
		CPY	#&FF
		BNE	loop2

		INX

		LDA	level_number
		CMP	#6
		BNE	nots3l6

		LDA	screen_number
		CMP	#3
		BNE	nots3l6

		CPX	#6
		BNE	loop1

		BRA	exit_screen

.nots3l6	CPX	#10
		BNE	loop1

.exit_screen	JSR	init_screen2

		RTS
	ELSE
; .screen - defined in mc002a.asm for non-Master
		; Duplicate code from mc002a.asm removed
	ENDIF

;****************************************

.bloc		STX	workspace+&12
		STY	workspace+&13
		LDX	#11
		JSR	mult
		CLC
		ADC	workspace+&12
		TAY

		LDA	(pointer),Y
		STA	workspace
		AND	#2
		BEQ	nflt

		LDA	workspace
		LSR	A
		LSR	A
		CLC
		ADC	#10
		STA	height_1
		STA	height_4
;*		CLC
		ADC	#10
		STA	height_3
		SEC
		SBC	#20
		STA	height_2
	IF BUILD_MASTER
		BRA	flt
	ELSE
		JMP	flt
	ENDIF

.nflt		LDA	(pointer),Y
		LSR	A
		LSR	A
		CLC
		ADC	#10
		STA	height_1

		INY
		LDA	(pointer),Y
		LSR	A
		LSR	A
		STA	height_2

		TYA
		CLC
		ADC	#11
		TAY
		LDA	(pointer),Y
		LSR	A
		LSR	A
		CLC
		ADC	#10
		STA	height_4

		DEY
		LDA	(pointer),Y
		LSR	A
		LSR	A
		CLC
		ADC	#20
		STA	height_3

.flt		LDA	height_1
		STA	block_sh

		LDA	height_2
		CMP	block_sh
		BLT	bs_2

		STA	block_sh

.bs_2		LDA	height_3
		CMP	block_sh
		BLT	bs_3

		STA	block_sh

.bs_3		LDA	height_4
		CMP	block_sh
		BLT	bs_4

		STA	block_sh

.bs_4		LDA	#71
		SEC
		SBC	block_sh
		STA	block_sh

	IF BUILD_MASTER
		BANK	4

		LDA	screen_number
		DEA
		LDX	level_number
		DEX
		BEQ	skip_addlev

		CLC
.addlev_loop	ADC	#10
		DEX
		BNE	addlev_loop

.skip_addlev	ASL	A
		TAX
		LDA	block_table,X
		STA	cb_loop2+1
		LDA	block_table+1,X
		STA	cb_loop2+2

		LDA	#LO(block_data2)
		STA	cbl_bd+1
		LDA	#HI(block_data2)
		STA	cbl_bd+2

		LDA	#LO(block_mask2)
		STA	cml_bm+1
		LDA	#HI(block_mask2)
		STA	cml_bm+2

		LDY	#8
.cb_loop1	LDX	block_sh

.cb_loop2	LDA	&FFFF,X
.cbl_bd		STA	&FFFF,X
.cml_bm		STZ	&FFFF,X
		INX
		CPX	#72
		BLT	cb_loop2

		LDA	cb_loop2+1
		CLC
		ADC	#72
		STA	cb_loop2+1
		BCC	cblp2_cc
		CLC
		INC	cb_loop2+2

;*		LDA	cb_loop2+2
;*		ADC	#0
;*		STA	cb_loop2+2

.cblp2_cc	LDA	cbl_bd+1
		ADC	#72
		STA	cbl_bd+1
		BCC	cblbd_cc

		CLC
		INC	cbl_bd+2

;*		LDA	cbl_bd+2
;*		ADC	#0
;*		STA	cbl_bd+2

.cblbd_cc	LDA	cml_bm+1
;*		CLC
		ADC	#72
		STA	cml_bm+1
		BCC	cmlbm_cc

		CLC
		INC	cml_bm+2

;*		LDA	cml_bm+2
;*		ADC	#0
;*		STA	cml_bm+2

.cmlbm_cc	DEY
		BNE	cb_loop1

; * * * * * * * * * * * * * * * * * * * *

		JSR	code

; * * * * * * * * * * * * * * * * * * * *

		STZ	pixel_X

.block_loop1	LDA	pixel_X
		AND	#3
		BNE	pm_jmp1

		LDA	#%10001000
		BRA	pm_jmp2

.pm_jmp1	TAX
		LDA	#%10001000
.pm_loop1	LSR	A
		DEX
		BNE	pm_loop1

.pm_jmp2	EOR	#%11111111
		STA	pixel_mask

		EOR	#%11111111
		AND	#%00001111
		STA	pixel_actual

		LDA	pixel_X
		AND	#252
		LSR	A
		LSR	A
		CLC
		ADC	#4
		TAX

		LDA	#LO(block_data2)
		STA	pointer2
		LDA	#HI(block_data2)
		STA	pointer2+1

		LDA	#LO(block_mask2)
		STA	pointer3
		LDA	#HI(block_mask2)
		STA	pointer3+1

		TXA
		BEQ	bo_jmp1

		CLC

.bo_loop1	LDA	pointer2
;*		CLC
		ADC	#72
		STA	pointer2
		BCC	p2_cc

		CLC
		INC	pointer2+1

;*		LDA	pointer2+1
;*		ADC	#0
;*		STA	pointer2+1

.p2_cc		LDA	pointer3
;*		CLC
		ADC	#72
		STA	pointer3
		BCC	p3_cc

		CLC
		INC	pointer3+1

;*		LDA	pointer3+1
;*		ADC	#0
;*		STA	pointer3+1

.p3_cc		DEX
		BNE	bo_loop1

.bo_jmp1	LDA	height_2
		STA	workspace+5
		LDA	height_4
		STA	workspace+6

		JSR	calc_height
		STA	workspace

		LDA	#72
		SEC
		SBC	workspace
		TAY

		LDA	height_3
		STA	workspace+5
		LDA	height_4
		STA	workspace+6

		JSR	calc_height
		STA	workspace

		LDA	#72
		SEC
		SBC	workspace
		STA	workspace

		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

		CPY	workspace
		BCC	ndbl1

.db_loop1	LDA	(pointer2),Y	; poke block up
		AND	pixel_mask
		ORA	pixel_actual
		STA	(pointer2),Y
		DEY
		CPY	workspace
		BCS	db_loop1

.ndbl1		LDA	pixel_mask
		EOR	#255
		STA	workspace

		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

.db_loop2	LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y

		LDA	(pointer3),Y
		ORA	workspace
		STA	(pointer3),Y

		DEY
		CPY	block_sh
		BGE	db_loop2

		INC	pixel_X
		LDA	pixel_X
		CMP	#16
		BEQ	end_of_block1

		JMP	block_loop1

.end_of_block1	STZ	pixel_X

.block_loop2	LDA	pixel_X
		AND	#3
		BNE	pm_jmp12

		LDA	#%10001000
		BRA	pm_jmp22

.pm_jmp12	TAX
		LDA	#%10001000
.pm_loop12	LSR	A
		DEX
		BNE	pm_loop12

.pm_jmp22	EOR	#%11111111
		STA	pixel_mask

		EOR	#%11111111
		AND	#%00001111
		STA	pixel_actual

		LDA	pixel_X
		LSR	A
		LSR	A
		TAX

		LDA	#LO(block_data2)
		STA	pointer2
		LDA	#HI(block_data2)
		STA	pointer2+1

		LDA	#LO(block_mask2)
		STA	pointer3
		LDA	#HI(block_mask2)
		STA	pointer3+1

		TXA
		BEQ	bo_jmp12

		CLC

.bo_loop12	LDA	pointer2
;*		CLC
		ADC	#72
		STA	pointer2
		BCC	p22_cc

		CLC
		INC	pointer2+1

;*		LDA	pointer2+1
;*		ADC	#0
;*		STA	pointer2+1

.p22_cc		LDA	pointer3
;*		CLC
		ADC	#72
		STA	pointer3
		BCC	p32_cc

		CLC
		INC	pointer3+1

;*		LDA	pointer3+1
;*		ADC	#0
;*		STA	pointer3+1

.p32_cc		DEX
		BNE	bo_loop12

.bo_jmp12	LDA	height_1
		STA	workspace+5
		LDA	height_2
		STA	workspace+6

		JSR	calc_height
		STA	workspace

		LDA	#72
		SEC
		SBC	workspace
		TAY

		LDA	height_1
		STA	workspace+5
		LDA	height_3
		STA	workspace+6

		JSR	calc_height
		STA	workspace

		LDA	#72
		SEC
		SBC	workspace
		STA	workspace

		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

		CPY	workspace
		BCC	Ndblp12

		LDA	pixel_X
		BEQ	Ndblp12

.db_loop12	LDA	(pointer2),Y	; poke block up
		AND	pixel_mask
		ORA	pixel_actual
		STA	(pointer2),Y
		DEY
		CPY	workspace
		BCS	db_loop12

.Ndblp12	LDA	pixel_mask
		EOR	#255
		STA	workspace

		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

.db_loop22	LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y

		LDA	(pointer3),Y
		ORA	workspace
		STA	(pointer3),Y

		DEY
		CPY	block_sh
		BGE	db_loop22

		INC	pixel_X
		LDA	pixel_X
		CMP	#16
		BEQ	end_of_block2

		JMP	block_loop2

.end_of_block2	LDA	#LO(block_data2)
		STA	b_sprite+1
		LDA	#HI(block_data2)
		STA	b_sprite+2

		LDA	#LO(block_mask2)
		STA	b_mask+1
		LDA	#HI(block_mask2)
		STA	b_mask+2

		LDA	workspace+&12
		CLC
		ADC	workspace+&13
		ASL	A
		ASL	A
		STA	drmem

		LDA	workspace+&13
		SEC
		SBC	workspace+&12
		STA	drmem+1
		LDX	#9
.add_loop	CLC
		ADC	drmem+1
		DEX
		BNE	add_loop

		EOR	#255
		CLC
		ADC	#94

		TAY
		LDX	drmem
		JSR	blck_spr

		BANK	5

		RTS
	ELSE
		LDY	#126
		LDA	(pointer),Y
		AND	#32+64+128
		TAX

		LDA	#8
		STA	workspace+2

		LDA	#1
		STA	workspace
		LDA	#0
		STA	pixel_X

		LDY	#144
.cb_loop3	STA	block_mask2-1,Y
		STA	block_mask2+144-1,Y
		DEY
		BNE	cb_loop3

.cb_loop2	LDA	block1,X
		STA	block_data2,Y
		STA	block_data2+8,Y
		STA	block_data2+16,Y
		STA	block_data2+24,Y
		STA	block_data2+32,Y
		STA	block_data2+40,Y
		STA	block_data2+48,Y
		STA	block_data2+56,Y
		STA	block_data2+64,Y
		INY
		INX
		CPY	workspace+2
		BCC	cb_loop2

		LDY	#72

		LDA	#80
		STA	workspace+2

		DEC	workspace
		BPL	cb_loop2


		LDA	#8
		STA	workspace+2

		LDY	#1
		STY	workspace
		DEY

.cb_loop21	LDA	block1,X
		STA	block_data2+144,Y
		STA	block_data2+8+144,Y
		STA	block_data2+16+144,Y
		STA	block_data2+24+144,Y
		STA	block_data2+32+144,Y
		STA	block_data2+40+144,Y
		STA	block_data2+48+144,Y
		STA	block_data2+56+144,Y
		STA	block_data2+64+144,Y
		INY
		INX
		CPY	workspace+2
		BCC	cb_loop21

		LDY	#72

		LDA	#80
		STA	workspace+2

		DEC	workspace
		BPL	cb_loop21


		LDX	#8
.cb_loop4	LDA	block_mask,X
		AND	block_data2+63,X
		STA	block_data2+63,X

		LDA	block_mask+9,X
		AND	block_data2+63+72,X
		STA	block_data2+63+72,X

		LDA	block_mask+(2*9),X
		AND	block_data2+63+(72*2),X
		STA	block_data2+63+(72*2),X

		LDA	block_mask+(3*9),X
		AND	block_data2+63+(72*3),X
		STA	block_data2+63+(72*3),X

		DEX
		BPL	cb_loop4


.block_loop1	JSR	db_part2

		INX
		INX

		JSR	db_part3

		LDX	height_2
		LDY	height_4
		JSR	calc_height
		PHA

		LDX	height_3
		LDY	height_4
		JSR	calc_height
		STA	workspace

		PLA
		TAY
		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

		CPY	workspace
		BCC	ndbl1

		JSR	db_loop1

.ndbl1		JSR	db_part
		BNE	block_loop1

		LDA	#0
		STA	pixel_X

.block_loop2	JSR	db_part2

		JSR	db_part3

		LDX	height_1
		LDY	height_2
		JSR	calc_height
		PHA

		LDX	height_1
		LDY	height_3
		JSR	calc_height
		STA	workspace

		PLA
		TAY
		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

		CPY	workspace
		BCC	Ndblp12

		LDA	pixel_X
		BEQ	Ndblp12

		JSR	db_loop1

.Ndblp12	JSR	db_part
		BNE	block_loop2

		LDA	#LO(block_data2)
		STA	b_sprite+1
		LDA	#HI(block_data2)
		STA	b_sprite+2

		LDA	#LO(block_mask2)
		STA	b_mask+1
		LDA	#HI(block_mask2)
		STA	b_mask+2

		LDA	workspace+&12
		CLC
		ADC	workspace+&13
		ASL	A
		STA	drmem

		LDA	workspace+&13
		SEC
		SBC	workspace+&12
		STA	drmem+1
		LDX	#9
.add_loop	CLC
		ADC	drmem+1
		DEX
		BNE	add_loop

		EOR	#255
		CLC
		ADC	#94

		TAY
		LDX	drmem
		JMP	blck_spr
	ENDIF

;****************************************
;****************************************

.hit_esc	SKIP	1

;*****************************************
;*****************************************

.init_screen	LDA	#LO(level_data)
		STA	pointer
		LDA	#HI(level_data)
		STA	pointer+1

	IF BUILD_MASTER
		LDA	screen_number	; screen =
		LDX	level_number	; (level-1)*10
		CLC			; +screen-1

.llpXX		DEX
		BEQ	e_clp
		ADC	#10
		BRA	llpXX

.e_clp		STA	flippy

		TAX
		DEX
		LDY	#132
		JSR	mult

		LDA	workspace+&8
		CLC
		ADC	pointer
		STA	pointer
		LDA	workspace+&9
		ADC	pointer+1
		STA	pointer+1


		LDA	flippy
		ASL	A
		CLC
		ADC	flippy
		TAX

		LDA	#1
		LDY	colsch-3,X
		JSR	vdu19

		LDA	#2
		LDY	colsch-2,X
		JSR	vdu19

		LDA	#3
		LDY	colsch-1,X
		JSR	vdu19

		LDY	#131
		LDA	(pointer),Y
		STA	gravity

		RTS
	ELSE
		LDX	screen_number
		DEX
		LDY	#127
		JSR	mult

		LDA	workspace+&8
		CLC
		ADC	pointer
		STA	pointer
		LDA	workspace+&9
		ADC	pointer+1
		STA	pointer+1

		LDY	#126			; THIS ENSURES THAT ALL
		LDA	(pointer),Y		; SCREENS ARE WHITE
		AND	#1+2+4
		JSR	vdu19

		RTS
	ENDIF

;*****************************************

.init_screen2
	IF BUILD_MASTER
		BANK	5

		LDY	#127
		LDA	(pointer),Y
		STA	j
		INY
		LDA	(pointer),Y
		STA	j+1
		INY
		LDA	(pointer),Y
		STA	j+2
		INY
		LDA	(pointer),Y
		STA	j+3
		LDX	#3
.dngdo		LDA	j,X
		STA	workspace+&B,X
		STA	mem,X
		DEX
		BPL	dngdo
		JSR	hi
		LDA	workspace+&F
		STA	j+4

		LDY	#122
		LDA	(pointer),Y
		STA	xy
		INY
		LDA	(pointer),Y
		STA	xy+1
		INY
		LDA	(pointer),Y
		STA	xy+2
		INY
		LDA	(pointer),Y
		STA	xy+3
		INY
		LDA	(pointer),Y
		STA	xy+4

		STZ	ab
		STZ	ab+1
		STZ	ab+2
		STZ	ab+3
		STZ	ab+4

		JSR	setup_ball

		LDA	j
		CLC
		ADC	j+1
		ADC	j+2
		ADC	j+3
		BEQ	no_jewel

		BANK	4
		JSR	print_jewel
		BANK	5

.no_jewel	RTS
	ELSE
		LDY	#124
		LDA	#0
		STA	j+1
		STA	j+3
		STA	xy+1
		STA	xy+3
		STA	ab
		STA	ab+1
		STA	ab+2
		STA	ab+3
		STA	ab+4

		LDA	(pointer),Y
		ASL	A
		ROL	j+1
		ASL	A
		ROL	j+1
		STA	j

		INY
		LDA	(pointer),Y
		ASL	A
		ROL	j+3
		ASL	A
		ROL	j+3
		STA	j+2

		LDX	#3
.dngdo		LDA	j,X
		STA	workspace+&B,X
		STA	mem,X
		DEX
		BPL	dngdo

		JSR	hi
		STA	j+4

		LDY	#121
		LDA	(pointer),Y
		ASL	A
		ROL	xy+1
		ASL	A
		ROL	xy+1
		STA	xy

		INY
		LDA	(pointer),Y
		ASL	A
		ROL	xy+3
		ASL	A
		ROL	xy+3
		STA	xy+2

		INY
		LDA	(pointer),Y
		STA	xy+4

		JSR	setup_ball

		LDA	j
		CLC
		ADC	j+1
		ADC	j+2
		ADC	j+3
		BEQ	no_jewel

		JSR	print_jewel

.no_jewel	RTS
	ENDIF

;*****************************************

	IF BUILD_MASTER
.flippy		EQUB	0
	ENDIF

;*****************************************
;*****************************************

.move_cursor	LDA	#31
		JSR	oswrch
		TXA
		JSR	oswrch
		TYA
		JMP	oswrch

;*****************************************
;*****************************************

.print_number	STX	workspace
		STY	workspace+1

		LDY	#0

.pn_loop	LDA	(workspace),Y
		CLC
		ADC	#48
		JSR	oswrch

		INY
		CPY	#5
		BNE	pn_loop

		RTS

;*****************************************
;*****************************************

.vdu19
	IF BUILD_MASTER
		PHA
		LDA	#19
		JSR	oswrch
		PLA
		JSR	oswrch
		TYA
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JMP	oswrch
	ELSE
		TAY
		LDA	#19
		JSR	oswrch
		LDA	#1
		JSR	oswrch
		TYA
		JSR	oswrch
		LDA	#0
		JSR	oswrch
		JSR	oswrch
		JMP	oswrch
	ENDIF

;*****************************************
;*****************************************

.print_score	LDX	#2
		LDY	#4
		JSR	move_cursor

		LDX	#LO(score)
		LDY	#HI(score)
		JMP	print_number

;*****************************************
;*****************************************

	IF BUILD_MASTER=0
.db_loop1	LDA	(pointer2),Y	; poke block up
		AND	pixel_mask
		ORA	pixel_actual
		STA	(pointer2),Y
		DEY
		CPY	workspace
		BCS	db_loop1

		RTS

.db_part	LDA	pixel_mask
		EOR	#255
		STA	workspace

		LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y
		DEY

.db_loop2	LDA	(pointer2),Y
		AND	pixel_mask
		STA	(pointer2),Y

		LDA	(pointer3),Y
		ORA	workspace
		STA	(pointer3),Y

		DEY
		CPY	block_sh
		BGE	db_loop2


		INC	pixel_X
		LDA	pixel_X
		CMP	#16

		RTS

.db_part2	LDA	pixel_X
		AND	#7
		BNE	pm_jmp1

		LDA	#%10000000
		BNE	pm_jmp2

.pm_jmp1	TAX
		LDA	#%10000000
.pm_loop1	LSR	A
		DEX
		BNE	pm_loop1

.pm_jmp2	STA	pixel_actual

		EOR	#255
		STA	pixel_mask

		LDA	pixel_X
		LSR	A
		LSR	A
		LSR	A
		TAX

		LDA	#LO(block_data2)
		STA	pointer2
		LDA	#HI(block_data2)
		STA	pointer2+1

		LDA	#LO(block_mask2)
		STA	pointer3
		LDA	#HI(block_mask2)
		STA	pointer3+1

		RTS

	EQUS	&0D
	EQUS	"Hi from Shades ... try entering", &0D
	EQUS	"'Shades' as a password ...", &0D
	EQUS    &0D
	EQUS	"But only if you leave me a messy", &0D
	EQUS	"on Bradford'S UNaXcess !!!", &0D
	EQUS    &0D

.db_part3	TXA
		BEQ	bo_jmp1

		CLC

.bo_loop1	LDA	pointer2
		ADC	#72
		STA	pointer2
		BCC	p2_cc

		CLC
		INC	pointer2+1

.p2_cc		LDA	pointer3
		ADC	#72
		STA	pointer3
		BCC	p3_cc

		CLC
		INC	pointer3+1

.p3_cc		DEX
		BNE	bo_loop1

.bo_jmp1	RTS

.screen10	LDY	#7
.stl		LDA	no10,Y
		STA	&7C50,Y
		DEY
		BPL	stl

		RTS

.no10		EQUB	%00100110
		EQUB	%01101001
		EQUB	%00101001
		EQUB	%00101001
		EQUB	%00101001
		EQUB	%00101001
		EQUB	%01110110
		EQUB	%00000000

; mc002b content (BBCB only)
.block_mask	EQUB	%00111111	; height = 9, width = 4
		EQUB	%00001111
		EQUB	%00000111
		EQUB	%00000001
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000

		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%00111111
		EQUB	%00011111
		EQUB	%00000111
		EQUB	%00000011

		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111111
		EQUB	%11111110
		EQUB	%11111100
		EQUB	%11110000
		EQUB	%11100000

		EQUB	%11111110
		EQUB	%11111000
		EQUB	%11110000
		EQUB	%11000000
		EQUB	%10000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000000

.block1		EQUB	%10110111
		EQUB	%10111001
		EQUB	%10111100
		EQUB	%11001101
		EQUB	%11110101
		EQUB	%11110001
		EQUB	%10110110
		EQUB	%10000111

		EQUB	%11011110
		EQUB	%11100110
		EQUB	%11110010
		EQUB	%00110100
		EQUB	%11010111
		EQUB	%11000111
		EQUB	%11011011
		EQUB	%00011100

		EQUB	%11110101
		EQUB	%11110001
		EQUB	%11101101
		EQUB	%10011100
		EQUB	%10111101
		EQUB	%10110011
		EQUB	%10100111
		EQUB	%10010110

		EQUB	%11010111
		EQUB	%11000111
		EQUB	%10110110
		EQUB	%01110000
		EQUB	%11110110
		EQUB	%11001110
		EQUB	%10011110
		EQUB	%01011001

.block2		EQUB	%01000111
		EQUB	%01011001
		EQUB	%00011000
		EQUB	%00011000
		EQUB	%01011011
		EQUB	%01100001
		EQUB	%00111000
		EQUB	%00001100

		EQUB	%00011100
		EQUB	%10000110
		EQUB	%11011011
		EQUB	%00011000
		EQUB	%00011000
		EQUB	%10011010
		EQUB	%11101011
		EQUB	%00110000

		EQUB	%00011100
		EQUB	%00110000
		EQUB	%01101101
		EQUB	%00001100
		EQUB	%00001100
		EQUB	%00101100
		EQUB	%01101011
		EQUB	%00000110

		EQUB	%01110001
		EQUB	%11001101
		EQUB	%10001100
		EQUB	%00001100
		EQUB	%01101101
		EQUB	%11000011
		EQUB	%10001110
		EQUB	%00011000

.block3		EQUB	%00010000
		EQUB	%00100001
		EQUB	%01000010
		EQUB	%00000100
		EQUB	%00001001
		EQUB	%00010010
		EQUB	%00100100
		EQUB	%01001000

		EQUB	%10010000
		EQUB	%00100001
		EQUB	%01000010
		EQUB	%10000100
		EQUB	%00001001
		EQUB	%00010010
		EQUB	%00100100
		EQUB	%01001000

		EQUB	%01111011
		EQUB	%00111101
		EQUB	%01011110
		EQUB	%01101111
		EQUB	%00110111
		EQUB	%01011011
		EQUB	%01101101
		EQUB	%01110110

		EQUB	%01111011
		EQUB	%10111101
		EQUB	%11011110
		EQUB	%01101111
		EQUB	%10110111
		EQUB	%11011011
		EQUB	%11101101
		EQUB	%11110110

.block4		EQUB	%00101000
		EQUB	%00000100
		EQUB	%00000010
		EQUB	%01010001
		EQUB	%00101000
		EQUB	%00000100
		EQUB	%00000010
		EQUB	%01010001

		EQUB	%10100010
		EQUB	%00010000
		EQUB	%00001000
		EQUB	%01000105
		EQUB	%10100010
		EQUB	%00010000
		EQUB	%00001000
		EQUB	%01000105

		EQUB	%01101011
		EQUB	%01011111
		EQUB	%00111110
		EQUB	%01110101
		EQUB	%01101011
		EQUB	%01011111
		EQUB	%00111110
		EQUB	%01110101

		EQUB	%10101110
		EQUB	%01111101
		EQUB	%11111011
		EQUB	%11010111
		EQUB	%10101110
		EQUB	%01111101
		EQUB	%11111011
		EQUB	%11010111

.block5		EQUB	%00111000
		EQUB	%01111101
		EQUB	%00111000
		EQUB	%01111101
		EQUB	%00111000
		EQUB	%01111101
		EQUB	%00111000
		EQUB	%01111101

		EQUB	%10001110
		EQUB	%11011111
		EQUB	%10001110
		EQUB	%11011111
		EQUB	%10001110
		EQUB	%11011111
		EQUB	%10001110
		EQUB	%11011111

		EQUB	%00111000
		EQUB	%01111101
		EQUB	%00111000
		EQUB	%01111101
		EQUB	%00111000
		EQUB	%01111101
		EQUB	%00111000
		EQUB	%01111101

		EQUB	%10001110
		EQUB	%11011111
		EQUB	%10001110
		EQUB	%11011111
		EQUB	%10001110
		EQUB	%11011111
		EQUB	%10001110
		EQUB	%11011111

.block6		EQUB	%01010000
		EQUB	%01001100
		EQUB	%01000011
		EQUB	%00100000
		EQUB	%01010000
		EQUB	%01001100
		EQUB	%01000011
		EQUB	%00100000

		EQUB	%00000000
		EQUB	%00000000
		EQUB	%11000000
		EQUB	%00111111
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%11000000
		EQUB	%00111111

		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000001
		EQUB	%01111110
		EQUB	%00000000
		EQUB	%00000000
		EQUB	%00000001
		EQUB	%01111110

		EQUB	%00000101
		EQUB	%00011001
		EQUB	%11100001
		EQUB	%00000010
		EQUB	%00000101
		EQUB	%00011001
		EQUB	%11100001
		EQUB	%00000010

.block7		EQUB	%01001001
		EQUB	%00011100
		EQUB	%00111010
		EQUB	%01111001
		EQUB	%00100110
		EQUB	%00010100
		EQUB	%01001001
		EQUB	%01100011

		EQUB	%11001001
		EQUB	%10011100
		EQUB	%00111010
		EQUB	%01111001
		EQUB	%00100110
		EQUB	%10010100
		EQUB	%11001001
		EQUB	%11100011

		EQUB	%01001001
		EQUB	%00011100
		EQUB	%00111010
		EQUB	%01111001
		EQUB	%00100110
		EQUB	%00010100
		EQUB	%01001001
		EQUB	%01100011

		EQUB	%11001001
		EQUB	%10011100
		EQUB	%00111010
		EQUB	%01111001
		EQUB	%00100110
		EQUB	%10010100
		EQUB	%11001001
		EQUB	%11100011
	ENDIF

;****************************************
;****************************************

	IF BUILD_MASTER
		; INCLUDE "mc003a.asm"
	ELSE
		; INCLUDE "mc003a.asm"
	ENDIF
