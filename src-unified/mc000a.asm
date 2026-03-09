;		TTL	mc000		; All sprite/screen routines that poke
						; directly to the shadow screen memory
;****************************************
;****************************************

	IF BUILD_MASTER=0
.screen_store	SKIP	&10
.screen_store2	SKIP	&10
.ball_data	SKIP	&40
.level_data	SKIP	&4F6
	ELSE
.screen_store	SKIP	24
.screen_store2	SKIP	24
	ENDIF

.blck_spr	TYA
		CLC
		ADC	block_sh
		TAY
		JSR	calculate_byte

		SHADOW	ON,IN

		LDA	#4		; width of sprite in bytes
		IF BUILD_MASTER
			LDA	#8
		ENDIF
		STA	workspace+4

.bml		LDX	block_sh

		LDA	workspace
		PHA
		AND	#&F8
		STA	workspace+5	; copy of screen address MOD,
		LDA	workspace+1
		STA	workspace+6	; and DIV.
		PLA
		AND	#7
		TAY

.bdc		LDA	(workspace+5),Y	; LDA screen

.b_mask		AND	&FFFF,X		; AND mask

.b_sprite	ORA	&FFFF,X		; OR sprite

		STA	(workspace+5),Y	; STA screen

		INX			; X will never clock as data = 24 bytes

.bch		INY
		CPX	#72
		BEQ	beoc

		CPY	#8
		BNE	bdc

		LDA	workspace+5
		ADC	#&3F
		IF BUILD_MASTER
			ADC	#&40 ; &3F + &40 = &7F
		ENDIF
		STA	workspace+5
		LDA	workspace+6
		ADC	#1
		IF BUILD_MASTER
			ADC	#1 ; 1 + 1 = 2
		ENDIF
		STA	workspace+6

		LDY	#0
		IF BUILD_MASTER
			BRA	bdc
		ELSE
			BEQ	bdc
		ENDIF

.beoc		LDA	workspace
;*		CLC
		ADC	#7		; WAS 8
		IF BUILD_MASTER
			ADC	#1 ; 7+1=8
		ENDIF
		STA	workspace
		BCC	bcc

		CLC
		INC	workspace+1

.bcc		LDA	b_mask+1
		ADC	#72
		STA	b_mask+1
		BCC	bm_cc

		INC	b_mask+2
		CLC

.bm_cc		LDA	b_sprite+1
		ADC	#72
		STA	b_sprite+1
		BCC	bs_cc

		INC	b_sprite+2

.bs_cc		DEC	workspace+4
		BNE	bml

		SHADOW	ON,OUT
		RTS

;****************************************
;****************************************

	IF BUILD_MASTER
.eor_sprite	JSR	calculate_byte

		SHADOW	ON,IN

.es_height	LDA	#&FF		; height of sprite in bytes
		STA	es_adc+1
		STA	workspace+3

.es_width	LDA	#&FF		; width of sprite in bytes
		STA	workspace+4

		LDX	#0
.ml		LDA	workspace
		PHA
		AND	#&F8
		STA	workspace+5	; copy of screen address MOD,
		LDA	workspace+1
		STA	workspace+6	; and DIV.
		PLA
		AND	#7
		TAY

.dc		LDA	(workspace+5),Y	; LDA screen

.sprite		EOR	&FFFF,X		; EOR sprite

		STA	(workspace+5),Y	; STA screen

		INX
		BEQ	dh

.ck		INY
		CPX	workspace+3	; end_of_col
		BEQ	eoc

		CPY	#8
		BNE	dc

		LDA	workspace+5
		ADC	#&7F
		STA	workspace+5
		LDA	workspace+6
		ADC	#2
		STA	workspace+6

		LDY	#0
		BRA	dc

.dh		INC	sprite+2
		BRA	ck

.eoc		LDA	workspace
		CLC
		ADC	#8
		STA	workspace
		BCC	cc

		CLC
		INC	workspace+1

.cc		LDA	workspace+3
.es_adc		ADC	#&FF
		STA	workspace+3

		DEC	workspace+4
		BNE	ml

		SHADOW	ON,OUT

		RTS
	ENDIF

;****************************************
;****************************************

.mask_sprite
	IF BUILD_MASTER=0
		STA	workspace+4
	ENDIF

		JSR	calculate_byte

		SHADOW	ON,IN

.ms_height	LDA	#&FF		; height of sprite in bytes
		IF BUILD_MASTER
			STA	workspace+2
		ENDIF
		STA	workspace+3

	IF BUILD_MASTER
.ms_width	LDA	#&FF		; width of sprite in bytes
		STA	workspace+4
	ENDIF

		LDX	#0
.ml1		LDA	workspace
		PHA
		AND	#&F8
		STA	workspace+5	; copy of screen address MOD,
		LDA	workspace+1
		STA	workspace+6	; and DIV.
		PLA
		AND	#7
		TAY

.dc1		LDA	(workspace+5),Y	; LDA screen

	IF BUILD_MASTER=0
.save		STA	screen_store,X	; STA area
    ELSE
	ENDIF

.ms_mask	AND	&FFFF,X		; AND mask

.ms_sprite	ORA	&FFFF,X		; OR sprite

		STA	(workspace+5),Y	; STA screen

		INX			; X will never clock as data = 24 bytes
		BEQ	dh1

.ck1		INY
		CPX	workspace+3
		BEQ	eoc1

		CPY	#8
		BNE	dc1

		LDA	workspace+5
		ADC	#&3F
		IF BUILD_MASTER
			ADC	#&40
		ENDIF
		STA	workspace+5
		LDA	workspace+6
		ADC	#1
		IF BUILD_MASTER
			ADC	#1
		ENDIF
		STA	workspace+6

		LDY	#0
		IF BUILD_MASTER
			BRA	dc1
		ELSE
			BEQ	dc1
		ENDIF

.dh1		INC	ms_mask+2
		INC	ms_sprite+2
		IF BUILD_MASTER
			BRA	ck1
		ELSE
			BNE	ck1
		ENDIF

.eoc1		LDA	workspace
;*		CLC
		ADC	#7		; WAS 8
		IF BUILD_MASTER
			ADC	#1
		ENDIF
		STA	workspace
		BCC	cc1

		CLC
		INC	workspace+1

.cc1		LDA	workspace+3
		ADC	workspace+2
		STA	workspace+3

		DEC	workspace+4
		BNE	ml1

		SHADOW	ON,OUT
		RTS

;****************************************
;****************************************

	IF BUILD_MASTER
.save_area	SHADOW	ON,IN

		JSR	calculate_byte

.sa_height	LDA	#8		; height of sprite in bytes
		STA	sa_adc+1
		STA	workspace+3

.sa_width	LDA	#3		; width of sprite in bytes
		STA	workspace+4

		LDX	#0

.ml2		LDA	workspace
		PHA
		AND	#&F8
		STA	workspace+5	; copy of screen address MOD,
		LDA	workspace+1
		STA	workspace+6	; and DIV.
		PLA
		AND	#7
		TAY

.dc2		LDA	(workspace+5),Y	; LDA screen

.save		STA	screen_store,X	; STA area

		INX
		BEQ	dh2

.chk2		INY
		CPX	workspace+3
		BEQ	eoc2

		CPY	#8
		BNE	dc2

		LDA	workspace+5
		ADC	#&7F
		STA	workspace+5
		LDA	workspace+6
		ADC	#2
		STA	workspace+6

		LDY	#0
		BRA	dc2

.dh2		INC	save+2
		BRA	chk2

.eoc2		LDA	workspace
		CLC
		ADC	#8
		STA	workspace
		BCC	cc2

		CLC
		INC	workspace+1

.cc2		LDA	workspace+3
.sa_adc		ADC	#8
		STA	workspace+3

		DEC	workspace+4
		BNE	ml2

		SHADOW	ON,OUT
		RTS
	ENDIF

;****************************************
;****************************************

.restore_area
	IF BUILD_MASTER=0
		STA	workspace+4
	ENDIF

		SHADOW	ON,IN

		JSR	calculate_byte

.ra_height	LDA	#&FF		; height of sprite in bytes
		STA	ra_adc+1
		STA	workspace+3

	IF BUILD_MASTER
.ra_width	LDA	#&FF		; width of sprite in bytes
		STA	workspace+4
	ENDIF

		LDX	#0

.ml3		LDA	workspace
		AND	#&F8
		STA	workspace+5	; copy of screen address MOD,
		LDA	workspace+1
		STA	workspace+6	; and DIV.
		LDA	workspace
		AND	#7
		TAY

.restore	LDA	&FFFF,X		; restore area

		STA	(workspace+5),Y	; to screen

		INX			; X will never clock as data = 24 bytes
		BEQ	dh3

.chk3		INY
		CPX	workspace+3
		BEQ	eoc3

		CPY	#8
		BNE	restore

		LDA	workspace+5
		ADC	#&3F
		IF BUILD_MASTER
			ADC	#&40
		ENDIF
		STA	workspace+5
		LDA	workspace+6
		ADC	#1
		IF BUILD_MASTER
			ADC	#1
		ENDIF
		STA	workspace+6

		LDY	#0
		IF BUILD_MASTER
			BRA	restore
		ELSE
			BEQ	restore
		ENDIF

.dh3		INC	restore+2
		IF BUILD_MASTER
			BRA	chk3
		ELSE
			BNE	chk3
		ENDIF

.eoc3		LDA	workspace
;*		CLC
		ADC	#7		; WAS 8
		IF BUILD_MASTER
			ADC	#1
		ENDIF
		STA	workspace
		BCC	cc3

		CLC
		INC	workspace+1

.cc3		LDA	workspace+3
.ra_adc		ADC	#8
		STA	workspace+3

		DEC	workspace+4
		BNE	ml3

		SHADOW	ON,OUT
		RTS

;****************************************
;****************************************

.calculate_byte
	IF BUILD_MASTER
		STZ	workspace+1
	ELSE
		LDA	#0
		STA	workspace+1
	ENDIF
		TYA
		AND	#7
		STA	workspace
		TYA
		LSR	A
		LSR	A
		AND	#%11111110
		TAY
		TXA
		ASL	A
		ROL	workspace+1
		ASL	A
		ROL	workspace+1
		ASL	A
		ROL	workspace+1
		ADC	workspace
		ADC	calc_table,Y
		STA	workspace
		LDA	calc_table+1,Y
		ADC	workspace+1
		STA	workspace+1

		RTS

;****************************************
;*	Table for sprite routine	*
;*					*
	IF BUILD_MASTER
.calc_table	LOOKUP	&3000,&280,32
	ELSE
.calc_table	LOOKUP	&5800,&140,32
	ENDIF
					; Forms a table of &280 multiplication
					; starting at <screen>, with 18 entries.
;*					*
;****************************************
;****************************************

.d_shadow
	IF BUILD_MASTER
		LDX	old_X		; will be same X,
		INX
		LDY	old_Y2		; but different Y
		JSR	calculate_byte

		SHADOW	ON,IN

		LDA	shadow_store	; deletes old shadow dot
		STA	(workspace)

		SHADOW	ON,OUT
	ELSE
		LDX	old_X2
		LDY	old_Y2
		JSR	calculate_byte

		LDY	#0
		LDA	shadow_store	; deletes old shadow dot
		STA	(workspace),Y
	ENDIF

		RTS

;****************************************

.sp_shadow
	IF BUILD_MASTER
		LDX	old_X
		INX
		LDY	old_Y2
		JSR	calculate_byte

		SHADOW	ON,IN

		LDA	(workspace)
		STA	shadow_store

		LDA	#%10001000
		LDY	pixel_offset
		BEQ	sp_no_lsr

.sp_loop1	LSR	A
		DEY
		BNE	sp_loop1

.sp_no_lsr	ORA	(workspace)
		STA	(workspace)

		SHADOW	ON,OUT
	ELSE
		LDX	old_X
		LDA	pixel_offset
		AND	#4
		BEQ	under4

		INX
		LDA	#%01111111
		BNE	skip_u4

.under4		LDA	#%11110111

.skip_u4	PHA
		STX	old_X2
		LDY	old_Y2
		JSR	calculate_byte

		LDY	#0
		LDA	(workspace),Y
		STA	shadow_store

		LDA	pixel_offset
		AND	#3
		TAX

		PLA

		CPX	#0
		BEQ	sp_no_lsr

		SEC
.sp_loop	ROR	A
		DEX
		BNE	sp_loop

.sp_no_lsr	STA	sp_and+1

		LDA	(workspace),Y
.sp_and		AND	#&FF
		STA	(workspace),Y
	ENDIF

		RTS

;****************************************

.animate_lives
	IF BUILD_MASTER
		SHADOW	ON,IN

		BANK	4

		LDA	#LO(&3550)
		STA	workspace+2
		LDA	#HI(&3550)
		STA	workspace+3

		LDA	lives
		BEQ	exit_al
		CMP	#5
		BCC	not_b_5
		LDA	#5

.not_b_5	STA	workspace

		LDA	yts
		STA	workspace+1

.al_loop1	LDA	workspace+1
		EOR	#frames-1
		STA	workspace+1
		ASL	A
		ASL	A
		ASL	A
		ASL	A
		TAX

		LDY	#0
.al_loop2	LDA	ball_data,X
		STA	(workspace+2),Y
		INY
		INX
		CPY	#16
		BNE	al_loop2

		CLC
		LDA	workspace+2
		ADC	#16
		STA	workspace+2

		BCC	al_nc1

		INC	workspace+3

.al_nc1		DEC	workspace
		BNE	al_loop1


.exit_al

		LDA	lives
		CMP	#5
		BEQ	exit_al2

		LDA	#5
		SEC
		SBC	lives
		STA	workspace

.al_loop3	LDY	#15
		LDA	#0

.al_loop4	STA	(workspace+2),Y
		DEY
		BPL	al_loop4

		CLC
		LDA	workspace+2
		ADC	#16
		STA	workspace+2

		BCC	al_nc2

		INC	workspace+3

.al_nc2		DEC	workspace
		BNE	al_loop3

.exit_al2	SHADOW	ON,OUT

		BANK	5
	ELSE
		LDA	#LO(&5AA8)
		STA	workspace+2
		LDA	#HI(&5AA8)
		STA	workspace+3

		LDA	lives
		BEQ	exit_al

		CMP	#5
		BCC	not_b_5

		LDA	#5

.not_b_5	STA	workspace

		LDA	frame		; WAS yts
		STA	workspace+1

.al_loop1	LDA	workspace+1
		EOR	#frames-1
		STA	workspace+1
		ASL	A
		ASL	A
		ASL	A
		TAX

		LDY	#7
.al_loop2	LDA	ball_data,X
		STA	(workspace+2),Y
		INX
		DEY
		BPL	al_loop2

		CLC
		LDA	workspace+2
		ADC	#8
		STA	workspace+2

		DEC	workspace
		BNE	al_loop1


.exit_al	LDA	#5
		SEC
		SBC	lives
		STA	workspace
		BEQ	exit_al2

.al_loop3	LDY	#7
		LDA	#0
.al_loop4	STA	(workspace+2),Y
		DEY
		BPL	al_loop4

		CLC
		LDA	workspace+2
		ADC	#8
		STA	workspace+2

		DEC	workspace
		BNE	al_loop3

.exit_al2
	ENDIF
		RTS

;****************************************
;****************************************

	IF BUILD_MASTER=0
.ball_mask	EQUB	60,126,255,255,255,255,126,60
	ENDIF

;*screen_store2	SKIP	16		; = 2 * columns of 8
;*screen_store	SKIP	16		; = 2 * columns of 8
;*
;*actual_ball	SKIP	16		; = 2 * columns of 8
;*actual_mask	SKIP	16		; = 2 * columns of 8

;****************************************
;****************************************

	IF BUILD_MASTER=0
.display_timer
	ENDIF
.display_timer_old	LDA	timer_digits
		ASL	A
		ASL	A
		ASL	A
		ADC	timer_frames
		TAY

		LDX	#0
.dt_loop1_old	LDA	timer_chars_old,Y
		IF BUILD_MASTER
			STA	&5E10,X
		ELSE
			STA	&5A10,X
		ENDIF
		INX
		INY
		CPX	#8
		BNE dt_loop1_old

;* * * * * * * * * * * * * * * * * * * *

		LDA	timer_digits+1
		ASL	A
		ASL	A
		ASL	A
		ADC	timer_frames+1
		TAY

		LDX	#0
.dt_loop2_old	LDA	timer_chars_old,Y
		STA	&5E10+8,X
		INX
		INY
		CPX	#8
		BNE dt_loop2_old

;* * * * * * * * * * * * * * * * * * * *

		LDA	timer_digits+2
		ASL	A
		ASL	A
		ASL	A
		ADC	timer_frames+2
		TAY

		LDX	#0
.dt_loop3_old	LDA	timer_chars_old,Y
		EOR	#255
		STA	&5E10+16,X
		INX
		INY
		CPX	#8
		BNE dt_loop3_old

;****************************************

		LDX	timer_frames+2
		DEX
		BPL	not_eoc4_old

		DEC	timer_digits+2

		LDA	timer_digits+2
		BPL	not_eoc4_old1_old

		LDA	#9
		STA	timer_digits+2

.not_eoc4_old1_old	LDX	#7
.not_eoc4_old	STX	timer_frames+2

;* * * * * * * * * * * * * * * * * * * *

		LDA	timer_digits+2
		CMP	#9
		BNE	not_eoc3_old

		LDA	timer_status
		ORA	#%00000100
		STA	timer_status

		LDX	timer_frames+1
		DEX
		BPL	not_eoc3_old1

		DEC	timer_digits+1
		LDA	timer_digits+1
		BPL	not_eoc3_old2

		LDA	#9
		STA	timer_digits+1

.not_eoc3_old2	LDX	#7
.not_eoc3_old1	STX	timer_frames+1
		BNE	not_eoc3_old4

;* * * * * * * * * * * * * * * * * * * *

.not_eoc3_old	LDA	timer_status
		AND	#%11111011
		STA	timer_status

.not_eoc3_old4	LDA	timer_digits+1
		CMP	#9
		BNE	not_eoc2_old

		LDA	timer_status
		AND	#%00000100
		BEQ	not_eoc2_old

		LDA	timer_status
		ORA	#%000000010
		STA	timer_status

		LDX	timer_frames
		DEX
		BPL	not_eoc2_old1

		DEC	timer_digits

		LDX	#6
.not_eoc2_old1	STX	timer_frames

		BNE	not_eoc2_old4

;* * * * * * * * * * * * * * * * * * * *

.not_eoc2_old	LDA	timer_status
		AND	#%11111101
		STA	timer_status

.not_eoc2_old4	JSR	draw_sbars

		RTS

;****************************************
;****************************************

.timer_chars_old	EQUB	%01111110	; 0
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00100100
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00000000

		EQUB	%01111110	; 1
		EQUB	%00000000
		EQUB	%00001000
		EQUB	%00011000
		EQUB	%00001000
		EQUB	%00001000
		EQUB	%00011100
		EQUB	%00000000


		EQUB	%01111110	; 2
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00001000
		EQUB	%00010000
		EQUB	%00111100
		EQUB	%00000000

		EQUB	%01111110	; 3
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00001000
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00000000

		EQUB	%01111110	; 4
		EQUB	%00000000
		EQUB	%00100000
		EQUB	%00100000
		EQUB	%00101000
		EQUB	%00111100
		EQUB	%00001000
		EQUB	%00000000

		EQUB	%01111110	; 5
		EQUB	%00000000
		EQUB	%00111100
		EQUB	%00100000
		EQUB	%00111000
		EQUB	%00000100
		EQUB	%00011000
		EQUB	%00000000

		EQUB	%01111110	; 6
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100000
		EQUB	%00111000
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00000000

		EQUB	%01111110	; 7
		EQUB	%00000000
		EQUB	%00111100
		EQUB	%00001000
		EQUB	%00010000
		EQUB	%00100000
		EQUB	%00100000
		EQUB	%00000000

		EQUB	%01111110	; 8
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00000000

		EQUB	%01111110	; 9
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00010000
		EQUB	%00100000
		EQUB	%00000000

		EQUB	%01111110	; 0
		EQUB	%00000000
		EQUB	%00011000
		EQUB	%00100100
		EQUB	%00100100
		EQUB	%00100100
		EQUB	%00011000
		EQUB	%00000000

;****************************************
;****************************************
