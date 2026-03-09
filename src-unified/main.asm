; Unified main.asm for Vertigo

; Define target based on flags passed to beebasm (BUILD_MASTER, BUILD_BBCB, BUILD_ELECTRON)

		CPU	1	; 65C02

		INCLUDE "macros.asm"

OFF		=	0
ON		=	1+2
OUT		=	0
IN		=	4

nvwrch		=	&FFC8
nvrdch		=	&FFCB
osfind		=	&FFCE
osbgpb		=	&FFD1
osbput		=	&FFD4
osbget		=	&FFD7
osargs		=	&FFDA
osfile		=	&FFDD
osrdch		=	&FFE0
osasci		=	&FFE3
osnewl		=	&FFE7
oswrch		=	&FFEE
osword		=	&FFF1
osbyte		=	&FFF4
oscli		=	&FFF7

romsel		=	&FE30
romevn		=	&F4
accreg		=	&FE34

; * * * * * * * * * * * * * * * * * * * *

		ORG	&0000

.evframe_num	SKIP	1
.evworkspace	SKIP	7
.timer1		SKIP	1
.timer2		SKIP	1

; * * * * * * * * * * * * * * * * * * * *

	IF BUILD_MASTER
		SKIP	4

.bass_offset	SKIP	1
.bb_num		SKIP	1
.bass_pointer	SKIP	2

.arpeg_offset	SKIP	1
.arpeg_pointer	SKIP	2

.main_offset	SKIP	1
.mb_num		SKIP	1
.main_pointer	SKIP	2

.drmem		SKIP	10
.xy		SKIP	5
.yts		SKIP	1
.yts2		SKIP	1
.ab		SKIP	10
.oxy		SKIP	6
.hites		SKIP	7
.j		SKIP	5
.mem		SKIP	5
.u		SKIP	1
.VC		SKIP	1
.h		SKIP	1
.old_h		SKIP	1

.c		SKIP	11

.workspace	SKIP	&14

.indicator	SKIP	1

.frame		SKIP	1

.old_X		SKIP	1
.old_Y		SKIP	1
.old_Y2		SKIP	1

.pixel_offset	SKIP	1

.old_height	SKIP	1

.pointer	SKIP	2

.controller	SKIP	1

.height_1	SKIP	1
.height_2	SKIP	1
.height_3	SKIP	1
.height_4	SKIP	1

.pixel_X	SKIP	1
.pixel_mask	SKIP	1
.pixel_actual	SKIP	1

.pointer2	SKIP	2
.pointer3	SKIP	2

.menu_st	SKIP	1

.enemy_x	SKIP	2
.enemy_y	SKIP	2
.enemy_z	SKIP	1
.enemy_zm	SKIP	1
.e_point	SKIP	1
.e_count	SKIP	1
.e_frame	SKIP	1
.pointer4	SKIP	2

.old_lives	SKIP	1

; These variables are defined in mc001.asm for Master
; .lives		SKIP	1
; .score		SKIP	5
; .frame_delay	SKIP	1

.arrows_X	SKIP	1
.arrows_Y	SKIP	1
.arrows_frame	SKIP	1
.last_selected	SKIP	1

.block_sh	SKIP	1

.music_volume	SKIP	1
.sound_volume	SKIP	1

.volume_delay	SKIP	1

	ELSE
; BBC B / Electron Memory Layout
.drmem		SKIP	10
.xy		SKIP	5
.ab		SKIP	10
.oxy		SKIP	6
.hites		SKIP	7
.j		SKIP	5
.mem		SKIP	5
.u		SKIP	1
.VC		SKIP	1
.h		SKIP	1
.old_h		SKIP	1

.c		SKIP	11

.workspace	SKIP	&12		; WAS &14 in Master

.indicator	SKIP	1

.frame		SKIP	1

.old_X		SKIP	1
.old_X2		SKIP	1
.old_Y		SKIP	1
.old_Y2		SKIP	1

.pixel_offset	SKIP	1

.old_height	SKIP	1

.pointer	SKIP	2

.controller	SKIP	1

.height_1	SKIP	1
.height_2	SKIP	1
.height_3	SKIP	1
.height_4	SKIP	1

.pixel_X	SKIP	1
.pixel_mask	SKIP	1
.pixel_actual	SKIP	1

.pointer2	SKIP	2
.pointer3	SKIP	2

.menu_st	SKIP	1

.enemy_x	SKIP	2
.enemy_y	SKIP	2
.enemy_z	SKIP	1
.enemy_zm	SKIP	1
.e_point	SKIP	1
.e_count	SKIP	1
.e_frame	SKIP	1

.pointer4	SKIP	2

.old_lives	SKIP	1

.block_sh	SKIP	1

.level_number	SKIP	1
.screen_number	SKIP	1

.old_level2	SKIP	1

; defined in mc001.asm for non-Master as well?
; No, original code has them here for BBC B
.lives		SKIP	1
.score		SKIP	5
.frame_delay	SKIP	1

.old_level	SKIP	1
.old_screen	SKIP	1
.start_type	SKIP	1

.old_v_sp	SKIP	1

.e_speed	SKIP	1
.e_blocks	SKIP	1
.e_direction	SKIP	1
.e_sp_c		SKIP	1
.e_moves	SKIP	1
.old_EX		SKIP	1
.old_EY		SKIP	1
.js		SKIP	1

.shadow_store	SKIP	1

.main_offset	SKIP	1
.mb_num		SKIP	1
.main_pointer	SKIP	2

.bass_offset	SKIP	1
.bb_num		SKIP	1
.bass_pointer	SKIP	2

.ny_oldX	SKIP	1
.ny_oldY	SKIP	1
.ny_shstore	SKIP	1
.ny_pixoffset	SKIP	1
.n_bhi		SKIP	1

.x_bar		SKIP	1
.y_bar		SKIP	1
.h_bar		SKIP	1

.sound_count	SKIP	1

.timer_digits	SKIP	3
.timer_frames	SKIP	3
.timer_status	SKIP	1

.yo_ctr	SKIP	1 ; defined in bbcb/electron main but not master main

.zpage
	ENDIF

;****************************************
;****************************************

delay		=	4

;****************************************

frames		=	8

;****************************************

NW		=	0
NE		=	64
SW		=	128
SE		=	192

;****************************************
;****************************************

	IF BUILD_MASTER
		ORG	&8000

.ball_data	SKIP	&80		; BANK 4
.jewel_data	SKIP	&A0
.jewel_masks	SKIP	&A0
.menu_data	SKIP	&1D30
.ptr_spr	SKIP	&B0
.ptr_msk	SKIP	&B0
.nty_dta	SKIP	&A0
.nty_msk	SKIP	&10
.wipeout_s	SKIP	&E0
.wipeout_m	SKIP	&E0
.final		SKIP	&410
.lb_sprt	SKIP	&400
.lb_mask	SKIP	&40
.block1		SKIP	&240
.block2		SKIP	&240
.block3		SKIP	&240
.block4		SKIP	&240
.block5		SKIP	&240
.block6		SKIP	&240
.block7		SKIP	&240
.block_mask2	SKIP	&240
.block_data2	SKIP	&240
.ptr_sve	SKIP	&2C

		CLEAR &8000, &C000
		ORG	&8000		; BANK 5

.level_data	SKIP	&1B54
.tv_frames	SKIP	&17A0
.bsp1		SKIP	&AF
.bsp2		SKIP	&AF
.bsp3		SKIP	&AF
.bsp4		SKIP	&AF
.bsp5		SKIP	&AF
.lbsp1		SKIP	&129
.lbsp2		SKIP	&129
.lbsp3		SKIP	&129

		CLEAR &8000, &C000
		ORG	&8000		; BANK 7

.menu_save	SKIP	&11D0
.credits_save	SKIP	&9A0

		ORG	&E00		; Code start for Master

	ELIF BUILD_BBCB OR BUILD_ELECTRON
		IF BUILD_ELECTRON
			codestart = &900
		ELSE
			codestart = &1100
		ENDIF

		ORG	codestart
	ENDIF

.code_start

	IF BUILD_MASTER
		INCLUDE "mc000a.asm"
		INCLUDE "mc000b.asm"
		INCLUDE "mc000c.asm"
		INCLUDE "mc000d.asm"
		INCLUDE "mc001.asm"
		INCLUDE "mc001b.asm"
		INCLUDE "mc002.asm"
		INCLUDE "mc003a.asm"
		INCLUDE "mc003b.asm"
		INCLUDE "mc003c.asm"
		INCLUDE "mc004.asm"
		INCLUDE "mc004b.asm"
		INCLUDE "mc005a.asm"
		INCLUDE "mc005b.asm"
		INCLUDE "mc006a.asm"
		INCLUDE "mc006b.asm"
		INCLUDE "mc007.asm"
		INCLUDE "mc008.asm"
		INCLUDE "mc009a.asm"
		INCLUDE "mc009b.asm"
		INCLUDE "mc010.asm"
		INCLUDE "mc011.asm"
		INCLUDE "mc012.asm"
		INCLUDE "mc999.asm"
		INCLUDE "mctemp.asm"
		INCLUDE "mctemp2.asm"
	ELSE
		; BBC B / Electron Includes
		INCLUDE "mc000a.asm"
		INCLUDE "mc000c.asm"
		INCLUDE "mc001.asm"
		; INCLUDE "mc002.asm"
		INCLUDE "mc002b.asm"
		INCLUDE "mc003a.asm"
		INCLUDE "mc003b.asm"
		INCLUDE "mc003c.asm"
		INCLUDE "mc004.asm"
		INCLUDE "mc004b.asm"
		INCLUDE "mc005.asm"
		INCLUDE "mc006.asm"
		; mc007 is Master only
		INCLUDE "mc008.asm"
		INCLUDE "mc009.asm"
		; mc010, mc011, mc012 are Master only
		INCLUDE "mc998.asm"
		INCLUDE "mc999.asm"
		INCLUDE "mcmusic.asm"
		INCLUDE "mcdata.asm"
	ENDIF

.code_end

	IF BUILD_MASTER
		SAVE "Mcode", code_start, code_end, execute
	ELIF BUILD_BBCB
		SAVE "Mcode", code_start, code_end, execute, &1100
	ELIF BUILD_ELECTRON
		SAVE "Mcode", code_start, code_end, execute, &1100
	ENDIF

;****************************************

	CLEAR &0000, &FFFF

	INCLUDE "mcload.asm"

	SAVE "vertigo", loader_code_start, loader_code_end, loader_code_execute

;****************************************
; Extra files
	IF BUILD_MASTER
		PUTFILE "data/panel1", "panel1", &00003000, &00003000
		PUTFILE "data/panel2", "panel2", &00006480, &00006480
		PUTFILE "data/title-master", "title", &00003B08, &00002820
		PUTFILE "data/bank4", "bank4", &00000000
		PUTFILE "data/bank5", "bank5", &00000000
	ELSE
		PUTFILE "data/panel", "panel", &00000000, &00000000
		PUTFILE "data/title", "title", &00003B08, &00002820

		IF BUILD_BBCB
			PUTFILE "data/V.level1", "V.level1", &00000000, &00000000
			PUTFILE "data/V.level2", "V.level2", &00000000, &00000000
			PUTFILE "data/V.level3", "V.level3", &00000000, &00000000
			PUTFILE "data/V.level4", "V.level4", &00000000, &00000000
			PUTFILE "data/V.level5", "V.level5", &00000000, &00000000
			PUTFILE "data/V.level6", "V.level6", &00000000, &00000000
		ENDIF

		PUTBASIC "data/d]tape.bas", "d]tape"

		; Level 7 for BBCB/Electron
		CLEAR &0000, &FFFF
		INCLUDE "mclvl7a_bbcb.asm"
		INCLUDE "mclvl7b_bbcb.asm"
		SAVE "V.level7", start_of_level7, end_of_level7, &0000, &0000
	ENDIF
