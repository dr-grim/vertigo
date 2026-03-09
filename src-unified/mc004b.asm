;		TTL	mc004b		; Various subroutines & miscallaneous
					; routines
;****************************************
;****************************************

.calculate_X	LDA	workspace+&B
		CLC
		ADC	workspace+&D
		STA	workspace+&4
		LDA	workspace+&C
		ADC	workspace+&E
		STA	workspace+&5

		RTS

;****************************************

.calculate_Y	; LDA	#-128
		LDA #-128 AND &FF
		CLC
		ADC	workspace+&D
		STA	workspace+&4
		LDA	#2
		ADC	workspace+&E
		STA	workspace+&5
		LDA	workspace+&4
		SEC
		SBC	workspace+&B
		STA	workspace+&4
		LDA	workspace+&5
		SBC	workspace+&C
		LSR	A
		ROR	workspace+&4
		LSR	A
		ROR	workspace+&4
		LSR	A
		ROR	workspace+&4
		LDY	workspace+&4
		STY	workspace+&8
		TAY
		STY	workspace+&9

		LDX	#4
.loop		LDA	workspace+&8
		CLC
		ADC	workspace+&4
		STA	workspace+&8
		TYA
		ADC	workspace+&9
		STA	workspace+&9
		DEX
;*		TXA
		BNE	loop

		LDA	workspace+&8
		STA	workspace+&4
		LDA	workspace+&9
		STA	workspace+&5
		LDA	workspace+&4
		CLC
		ADC	workspace+&F
		STA	workspace+&4

		BCC	exit_cY

		INC	workspace+&5

;*		LDA	workspace+&5
;*		ADC	#0
;*		STA	workspace+&5

.exit_cY	RTS

;*****************************************
;*****************************************

	IF BUILD_MASTER
.check_optkeys	INKEY	-21
		BEQ	not_keys

		LDA	menu_st
		AND	#%11111100
		STA	menu_st

.not_keys	INKEY	-117
		BEQ	not_stick

		LDA	menu_st
		AND	#%11111100
		ORA	#%00000001
		STA	menu_st

.not_stick	LDA	volume_delay
		BEQ	vok

		DEC	volume_delay
		RTS

.vok		LDA	#20
		STA	volume_delay

		INKEY	-116
		BEQ	not_musicon

;*		LDA	menu_st
;*		ORA	#%10000000
;*		STA	menu_st

	LDA	music_volume
	CMP	#4
	BEQ	not_musicon

	INC	music_volume
	JSR	music_onoff

.not_musicon	INKEY	-115
		BEQ	not_musicoff

;*		LDA	menu_st
;*		AND	#%01111111
;*		STA	menu_st

	LDA	music_volume
	BEQ	not_musicoff

	DEC	music_volume
	JSR	music_onoff

.not_musicoff	INKEY	-114
		BEQ	not_soundon

;*		LDA	menu_st
;*		ORA	#%01000000
;*		STA	menu_st

	LDA	sound_volume
	CMP	#4
	BEQ	not_soundon

	INC	sound_volume
	JSR	music_onoff

.not_soundon	INKEY	-33
		BEQ	not_soundoff

;*		LDA	menu_st
;*		AND	#%10111111
;*		STA	menu_st

	LDA	sound_volume
	BEQ	not_soundoff

	DEC	sound_volume
	JSR	music_onoff

.not_soundoff	RTS

;*****************************************
;*****************************************

.setup_ball	LDA	#8
		STA	ra_height+1
		STA	ms_height+1
		LDA	#3
		STA	ra_width+1
		STA	ms_width+1

		LDA	#LO(actual_mask)
		STA	ms_mask+1
		LDA	#HI(actual_mask)
		STA	ms_mask+2

		LDA	#LO(actual_ball)
		STA	ms_sprite+1
		LDA	#HI(actual_ball)
		STA	ms_sprite+2

		LDA	#LO(screen_store)
		STA	restore+1
		LDA	#HI(screen_store)
		STA	restore+2

		RTS
	ELSE

.check_optkeys	JSR	music_onoff

		INKEY	-21
		BEQ	not_keys

		LDA	menu_st
		AND	#%11111100
		STA	menu_st

.not_keys	INKEY	-117
		BEQ	not_stick

		LDA	menu_st
		AND	#%11111100
		ORA	#%00000001
		STA	menu_st

.not_stick
	LDA	sound_count
	BNE	not_sounddown

	LDA	current_slev
	BEQ	skip_musicd

	INKEY	-115
	BEQ	skip_musicd

	DEC	current_slev
	BPL	do_su

.skip_musicd
	LDA	current_slev
	CMP	#4
	BEQ	skip_musicu

	INKEY	-116
	BEQ	skip_musicu

	INC	current_slev

.do_su	JSR	def_env

	JMP	do_sw


.skip_musicu	INKEY	-114
		BEQ	not_soundup

	LDA	&8E7
	CMP	#120
	BEQ	not_soundup
	CLC
	ADC	#20
	JMP	sd_cont

.not_soundup	INKEY	-33
		BEQ	not_sounddown2

	LDA	&8E7
	BEQ	not_sounddown
	SEC
	SBC	#20
.sd_cont
	STA	&8E7
	STA	&8EB
	STA	&8F7
	STA	&8FB

	STA	&8EC
	STA	&8FC

.do_sw	LDA	#10
	STA	sound_count
	RTS

.not_sounddown
	DEC	sound_count

.not_sounddown2
		RTS

;*****************************************
;*****************************************


.current_slev	EQUB	4

;*****************************************
;*****************************************


.setup_ball	LDA	#8
		STA	ra_height+1
		STA	ms_height+1

.setupb3	LDA	#LO(actual_mask)
		STA	ms_mask+1
		LDA	#HI(actual_mask)
		STA	ms_mask+2

		LDA	#LO(actual_ball)
		STA	ms_sprite+1
		LDA	#HI(actual_ball)
		STA	ms_sprite+2

.setupb2	LDA	#LO(screen_store)
		STA	restore+1
		STA	save+1
		LDA	#HI(screen_store)
		STA	restore+2
		STA	save+2

		RTS

	ENDIF

;*****************************************
;*****************************************

;		CHN	mc005a
