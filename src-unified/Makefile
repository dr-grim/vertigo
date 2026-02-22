BEEBASM		:=		../beebasm/beebasm

all: vertigo-master.ssd vertigo-bbc-b-disc.ssd vertigo-bbc-b-cassette.ssd vertigo-electron-cassette.ssd

vertigo-master.ssd: $(wildcard *.asm)
	$(BEEBASM) -w -vc -boot vertigo -do ../vertigo-master-unified.ssd -i main.asm -D BUILD_MASTER

vertigo-bbc-b-disc.ssd: $(wildcard *.asm)
	$(BEEBASM) -w -vc -boot vertigo -do ../vertigo-bbc-b-disc-unified.ssd -i main.asm -D BUILD_BBCB -D TARGET_DISC

vertigo-bbc-b-cassette.ssd: $(wildcard *.asm)
	$(BEEBASM) -w -vc -boot vertigo -do ../vertigo-bbc-b-cassette-unified.ssd -i main.asm -D BUILD_BBCB -D TARGET_CASSETTE

vertigo-electron-cassette.ssd: $(wildcard *.asm)
	$(BEEBASM) -w -vc -boot vertigo -do ../vertigo-electron-cassette-unified.ssd -i main.asm -D BUILD_ELECTRON -D TARGET_CASSETTE

clean:
	rm -f ../vertigo-master-unified.ssd ../vertigo-bbc-b-disc-unified.ssd ../vertigo-bbc-b-cassette-unified.ssd ../vertigo-electron-cassette-unified.ssd
