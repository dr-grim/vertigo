		MACRO DEFINE address
		LDA	#8
		LDX	#LO(address)
		LDY	#HI(address)
		JSR	osword
		ENDMACRO

		MACRO	ENEMYSTART px,py
		EQUW	px, py
		ENDMACRO

		MACRO 	ENEMYMOVE a,b,c
		EQUB	a+(b*8)+c
		ENDMACRO

		MACRO 	WAIT
{
.w1		INKEY	-99
		BNE	w1
.w2		INKEY	-99
		BEQ	w2
}
		ENDMACRO

		MACRO INKEY x
		LDA	#&81
		LDX	#LO(x) ; was >x
		LDY	#&FF
		JSR	osbyte
		TYA
		ENDMACRO

		MACRO LOOKUP start, step, number
{
		FOR n, 0, number-1
		EQUW start + (n*step)
		NEXT
}
		ENDMACRO

		MACRO BLOCK  size, bytePattern
		FOR n, 0, size-1
		EQUB	bytePattern
		NEXT
		ENDMACRO

		MACRO BGE  address
		BCS	address
		ENDMACRO

		MACRO BLT  address
		BCC	address
		ENDMACRO

; Target specific macros

		MACRO SHADOW onoff, inout
		IF BUILD_MASTER
			LDA	#onoff + inout
			STA	accreg
		ENDIF
		ENDMACRO

		MACRO BANK bankNum
		IF BUILD_MASTER
			LDA	#bankNum
			STA	romevn
			STA	romsel
		ENDIF
		ENDMACRO

		MACRO OSCLI oscliString
		LDX	#LO(oscliString)
		LDY	#HI(oscliString)
		JSR	oscli
		ENDMACRO
