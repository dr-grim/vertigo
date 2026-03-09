import sys

with open("src-unified/mc004.asm", "r") as f:
    text = f.read()

# Add def_env at the end of the file if not present
if "def_env" not in text:
    text += """
	IF BUILD_MASTER=0

.envelope8	EQUB	8,1,0,0,0,0,0,0,126,-10,-5,-10,126,66
	EQUB	126,66
.envelope9	EQUB	9,1,0,0,0,0,0,0,110,-20,-10,-20,110,50
	EQUB	110,50
.envelope10	EQUB	10,1,0,0,0,0,0,0,60,-1,0,-1,60,30
	EQUB	60,30

;****************************************
;****************************************

.def_env
	LDX	#0
	STX	workspace

.de_loop_env
	LDX	workspace

	LDA	current_slev
	BNE	not_zilch

	LDA	#0			; 0 volume
	STA	envelope6+8,X
	STA	envelope6+12,X
	STA	envelope6+13,X
	JMP	skip_de

.not_zilch
	CMP	#1
	BNE	not_slev1

	LDA	envelope6+14,X		; 25% volume
	LSR	A
	LSR	A
	STA	envelope6+8,X
	STA	envelope6+12,X
	LDA	envelope6+15,X
	LSR	A
	LSR	A
	STA	envelope6+13,X
	JMP	skip_de

.not_slev1
	CMP	#2
	BNE	not_slev2

	LDA	envelope6+14,X		; 50% volume
	LSR	A
	STA	envelope6+8,X
	STA	envelope6+12,X
	LDA	envelope6+15,X
	LSR	A
	STA	envelope6+13,X
	JMP	skip_de

.not_slev2
	CMP	#3
	BNE	not_slev3

	LDA	envelope6+14,X		; 75% volume
	LSR	A
	STA	envelope6+8,X
	STA	envelope6+12,X
	LDA	envelope6+15,X
	LSR	A
	STA	envelope6+13,X

	LDA	envelope6+14,X
	LSR	A
	LSR	A
	CLC
	ADC	envelope6+8,X
	STA	envelope6+8,X
	STA	envelope6+12,X

	LDA	envelope6+15,X
	LSR	A
	LSR	A
	CLC
	ADC	envelope6+13,X
	STA	envelope6+13,X

	JMP	skip_de

.not_slev3
	LDA	envelope6+14,X		; 100% volume
	STA	envelope6+8,X
	STA	envelope6+12,X

	LDA	envelope6+15,X
	STA	envelope6+13,X

.skip_de	LDA	workspace
	CLC
	ADC	#16
	STA	workspace

	CMP	#80
	BEQ	done_de

	JMP	de_loop_env

.done_de
	LDA	#152			; Define envelopes
	LDX	#LO(envelope6)
	LDY	#HI(envelope6)
	JSR	osword
	LDA	#152
	LDX	#LO(envelope7)
	LDY	#HI(envelope7)
	JSR	osword
	LDA	#152
	LDX	#LO(envelope8)
	LDY	#HI(envelope8)
	JSR	osword
	LDA	#152
	LDX	#LO(envelope9)
	LDY	#HI(envelope9)
	JSR	osword
	LDA	#152
	LDX	#LO(envelope10)
	LDY	#HI(envelope10)
	JSR	osword

	RTS

;****************************************
;****************************************

	ENDIF
"""

with open("src-unified/mc004.asm", "w") as f:
    f.write(text)
