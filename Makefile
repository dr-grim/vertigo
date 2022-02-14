BEEBASM		:=		beebasm/beebasm

all:	beebasm $(BEEBASM) vertigo.ssd

beebasm: 
	git clone https://github.com/stardot/beebasm

$(BEEBASM):
	$(MAKE) -C beebasm/src code

vertigo.ssd:	$(wildcard src/*.6502) src/panel1 src/panel2 src/title Makefile
	@# refer to https://github.com/stardot/beebasm#readme
	@# -w : require whitespace between opcode and parameter - reduces macro name clash
	@# -vc : Usual Visual C++ style error messages
	@# -boot vertigo : create a !BOOT file with "*RUN vertigo"
	cd src && ../$(BEEBASM) -w -vc -boot vertigo -do ../vertigo.ssd -i main.6502
	
clean:
	rm -rf beebasm
	rm vertigo.ssd
