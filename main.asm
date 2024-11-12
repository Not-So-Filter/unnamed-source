;  =========================================================================
; |           Sonic the Hedgehog Disassembly for Sega Mega Drive            |
;  =========================================================================
;
; Disassembly created by Hivebrain
; thanks to drx, Stealth and Esrael L.G. Neto

; ===========================================================================

	cpu 68000

EnableSRAM	  = 0	; change to 1 to enable SRAM
BackupSRAM	  = 1
AddressSRAM	  = 3	; 0 = odd+even; 2 = even only; 3 = odd only

ZoneCount	  = 6	; discrete zones are: GHZ, MZ, SYZ, LZ, SLZ, and SBZ

zeroOffsetOptimization = 1	; if 1, makes a handful of zero-offset instructions smaller

DebuggingMode = 1

	include "MacroSetup.asm"
	include	"Macros.asm"
	include "sound/Sonic-2-Clone-Driver-v2/Definitions.asm"
	include	"Constants.asm"
	include	"Variables.asm"
	include	"errorhandler/Debugger.asm"
; ===========================================================================

StartOfRom:
Vectors:	dc.l 0				; Initial stack pointer value
		dc.l EntryPoint			; Start of program
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error (4)
		dc.l IllegalInstr		; Illegal instruction
		dc.l ZeroDivide			; Division by zero
		dc.l ChkInstr			; CHK exception
		dc.l TrapvInstr			; TRAPV exception (8)
		dc.l PrivilegeViol		; Privilege violation
		dc.l Trace			; TRACE exception
		dc.l Line1010Emu		; Line-A emulator
		dc.l Line1111Emu		; Line-F emulator (12)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l CoProcessViol		; Co-processor protocol violation (14)
		dc.l FormatError		; Format error
		dc.l ErrorExcept		; Unused (reserved) (16)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (20)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (24)
		dc.l ErrorExcept		; Spurious exception
		dc.l ErrorTrap			; IRQ level 1
		dc.l ErrorTrap			; IRQ level 2
		dc.l ErrorTrap			; IRQ level 3 (28)
		dc.l HInt				; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap			; IRQ level 5
		dc.l VInt				; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap			; IRQ level 7 (32)
		dc.l ErrorTrap			; TRAP #00 exception
		dc.l ErrorTrap			; TRAP #01 exception
		dc.l ErrorTrap			; TRAP #02 exception
		dc.l ErrorTrap			; TRAP #03 exception (36)
		dc.l ErrorTrap			; TRAP #04 exception
		dc.l ErrorTrap			; TRAP #05 exception
		dc.l ErrorTrap			; TRAP #06 exception
		dc.l ErrorTrap			; TRAP #07 exception (40)
		dc.l ErrorTrap			; TRAP #08 exception
		dc.l ErrorTrap			; TRAP #09 exception
		dc.l ErrorTrap			; TRAP #10 exception
		dc.l ErrorTrap			; TRAP #11 exception (44)
		dc.l ErrorTrap			; TRAP #12 exception
		dc.l ErrorTrap			; TRAP #13 exception
		dc.l ErrorTrap			; TRAP #14 exception
		dc.l ErrorTrap			; TRAP #15 exception (48)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.b "SEGA MEGA DRIVE " ; Hardware system ID (Console name)
		dc.b "(C)SEGA 1991.APR" ; Copyright holder and release date (generally year)
		dc.b "SONIC THE               HEDGEHOG                " ; Domestic name
		dc.b "SONIC THE               HEDGEHOG                " ; International name
		dc.b "GM 00004049-01" ; Serial/version number
Checksum:	dc.w 0
		dc.b "J               " ; I/O support
		dc.l StartOfRom		; Start address of ROM
RomEndLoc:	dc.l EndOfRom-1		; End address of ROM
		dc.l v_ram_start	; Start address of RAM
		dc.l v_ram_end-1	; End address of RAM
		if EnableSRAM=1
		dc.b $52, $41, $A0+(BackupSRAM<<6)+(AddressSRAM<<3), $20 ; SRAM support
		else
		dc.l $20202020
		endif
		dc.l $20202020		; SRAM start ($200001)
		dc.l $20202020		; SRAM end ($20xxxx)
		dc.b "                                                    " ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
		dc.b "JUE             " ; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too

ErrorTrap:
		bra.s	ErrorTrap
; ===========================================================================
SetupValues:	dc.w $8000		; VDP register start number
		dc.w ((v_ram_end-1)-v_ram_start)/4	; size of RAM/4
		dc.w $100		; VDP register diff

		dc.l z80_ram		; start	of Z80 RAM
		dc.l z80_bus_request	; Z80 bus request
		dc.l z80_reset		; Z80 reset
		dc.l vdp_data_port	; VDP data
		dc.l vdp_control_port	; VDP control

		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b ($C000>>10)	; VDP $82 - foreground nametable address
		dc.b ($F000>>10)	; VDP $83 - window nametable address
		dc.b ($E000>>13)	; VDP $84 - background nametable address
		dc.b ($D800>>9)		; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - HInt register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b ($DC00>>10)	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
		dc.l $40000080		; VRAM address 0

	; Z80 instructions (not the sound driver; that gets loaded later)
    if (*)+$26 < $10000
    save
    CPU Z80 ; start assembling Z80 code
    phase 0 ; pretend we're at address 0
	xor	a	; clear a to 0
	ld	bc,((z80_ram_end-z80_ram)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
	ld	de,zStartupCodeEndLoc+1	; initial destination address
	ld	hl,zStartupCodeEndLoc	; initial source address
	ld	sp,hl	; set the address the stack starts at
	ld	(hl),a	; set first byte of the stack to 0
	ldir		; loop to fill the stack (entire remaining available Z80 RAM) with 0
	pop	ix	; clear ix
	pop	iy	; clear iy
	ld	i,a	; clear i
	ld	r,a	; clear r
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ex	af,af'	; swap af with af'
	exx		; swap bc/de/hl with their shadow registers too
	pop	bc	; clear bc
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ld	sp,hl	; clear sp
	di		; clear iff1 (for interrupt handler)
	im	1	; interrupt handling mode = 1
	ld	(hl),0E9h ; replace the first instruction with a jump to itself
	jp	(hl)	  ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
    dephase ; stop pretending
	restore
    padding off ; unfortunately our flags got reset so we have to set them again...
    else ; due to an address range limitation I could work around but don't think is worth doing so:
	message "Warning: using pre-assembled Z80 startup code."
	dc.w $AF01,$D91F,$1127,$0021,$2600,$F977,$EDB0,$DDE1,$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1,$D1E1,$F1F9,$F3ED,$5636,$E9E9
    endif

		dc.w $8104		; VDP display mode
		dc.w $8F02		; VDP increment
		dc.l $C0000000		; CRAM write mode
		dc.l $40000010		; VSRAM address 0

		dc.b $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================

EntryPoint:
		lea	(v_systemstack).w,sp
		tst.l	(z80_port_1_control-1).l ; test port A & B control registers
		bne.s	PortA_Ok
		tst.w	(z80_expansion_control).l ; test port C control register

PortA_Ok:
		bne.s	GameProgram ; Skip the VDP and Z80 setup code if port A, B or C is ok...?
		lea	SetupValues(pc),a5	; Load setup values array address.
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		moveq	#$F,d0
		and.b	-$10FF(a1),d0	; get hardware version (from $A10001)
		beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
		move.l	#'SEGA',$2F00(a1) ; move "SEGA" to TMSS register ($A14000)

SkipSecurity:
		move.w	(a4),d0	; clear write-pending flag in VDP to prevent issues if the 68k has been reset in the middle of writing a command long word to the VDP.
		moveq	#0,d0	; clear d0
		movea.l	d0,a6	; clear a6
		move.l	a6,usp	; set usp to $0

		moveq	#$18-1,d1
VDPInitLoop:
		move.b	(a5)+,d5	; add $8000 to value
		move.w	d5,(a4)		; move value to	VDP register
		add.w	d7,d5		; next register
		dbf	d1,VDPInitLoop

		move.l	(a5)+,(a4)
		move.w	d0,(a3)		; clear	the VRAM
		move.w	d7,(a1)		; stop the Z80
		move.w	d7,(a2)		; reset	the Z80

WaitForZ80:
		btst	d0,(a1)		; has the Z80 stopped?
		bne.s	WaitForZ80	; if not, branch

		moveq	#$26-1,d2
Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop

		move.w	d0,(a2)
		move.w	d0,(a1)		; start	the Z80
		move.w	d7,(a2)		; reset	the Z80

ClrRAMLoop:
		move.l	d0,-(a6)	; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
		move.l	(a5)+,(a4)	; set VDP display mode and increment mode
		move.l	(a5)+,(a4)	; set VDP to CRAM write

		moveq	#$20-1,d3	; set repeat times
ClrCRAMLoop:
		move.l	d0,(a3)	; clear 2 palettes
		dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
		move.l	(a5)+,(a4)	; set VDP to VSRAM write

		moveq	#$14-1,d4
ClrVSRAMLoop:
		move.l	d0,(a3)	; clear 4 bytes of VSRAM.
		dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
		moveq	#4-1,d5

PSGInitLoop:
		move.b	(a5)+,$11(a3)	; reset	the PSG
		dbf	d5,PSGInitLoop	; repeat for other channels
		move.w	d0,(a2)
		movem.l	(a6),d0-a6	; clear all registers
		disable_ints

GameProgram:
		tst.w	(vdp_control_port).l
		btst	#6,(z80_expansion_control+1).l
		beq.s	CheckSumCheck
		tst.b	(v_init).w ; has checksum routine already run?
		bne.s	GameInit	; if yes, branch

CheckSumCheck:
		lea	(v_crossresetram).w,a6
		moveq	#0,d7
		moveq	#bytesToLcnt(v_ram_end-v_crossresetram),d6
.clearRAM:
		move.l	d7,(a6)+
		dbf	d6,.clearRAM	; clear RAM ($FE00-$FFFF)

		move.b	(z80_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w ; get region setting
		st.b	(v_init).w ; set flag so checksum won't run again

GameInit:
		lea	(v_ram_start).l,a6
		moveq	#0,d7
		move.w	#bytesToLcnt(v_crossresetram-v_ram_start),d6
.clearRAM:
		move.l	d7,(a6)+
		dbf	d6,.clearRAM	; clear RAM ($0000-$FDFF)

		btst	#6,(v_megadrive).w
		sne.b	(f_palmode).w
		bsr.w	InitDMAQueue
		bsr.w	SoundDriverLoad
		bsr.w	VDPSetupGame
		lea	(z80_port_1_control).l,a0	; init port 1 (joypad 1)
		moveq	#$40,d0
		move.b	d0,(a0)	; init port 1 (joypad 1)
		move.b	d0,2(a0)	; init port 2 (joypad 2)
		move.b	d0,4(a0)	; init port 3 (expansion/extra)
		move.w	#GM_Sega,(v_gamemode).w ; set Game Mode to Sega Screen

MainGameLoop:
		movea.w	(v_gamemode).w,a0 ; load Game Mode
		jsr	(a0) ; jump to apt location in ROM
		bra.s	MainGameLoop	; loop indefinitely
; ===========================================================================

Art_Text:	binclude	"artunc/menutext.bin" ; text used in level select and debug mode
Art_Text_End:	even

; ===========================================================================
; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VInt:
		movem.l	d0-a6,-(sp)
		tst.b	(v_vbla_counter).w
		beq.s	VBla_00
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_vdp).w,(vdp_data_port).l ; send screen y-axis pos. to VSRAM
		st.b	(v_vbla_counter).w
		movea.w	(v_vbla_routine).w,a0
		jsr	(a0)

VBla_Exit:
		SMPS_UpdateSoundDriver
		movem.l	(sp)+,d0-a6
		rte
; ===========================================================================

VBla_00:
		tst.b	(v_prelevel).w
		beq.s	.islevel
		cmpi.w	#GM_Level,(v_gamemode).w ; is game on a level?
		bne.s	VBla_Exit	; if not, branch

.islevel:
		writeCRAM	v_palette,0
		SMPS_UpdateSoundDriver
		movem.l	(sp)+,d0-a6
		rte
; ===========================================================================

VBla_02:
		tst.w	(v_demolength).w
		beq.s	.end
		subq.w	#1,(v_demolength).w

.end:
		readjoypads
		writeCRAM	v_palette,0
		writeVRAMsrcdefined	v_spritetablebuffer,vram_sprites
		writeVRAMsrcdefined	v_hscrolltablebuffer,vram_hscroll
		rts
; ===========================================================================

VBla_0C:
		tst.w	(v_demolength).w
		beq.s	.end
		subq.w	#1,(v_demolength).w

.end:
		rts
; ===========================================================================

VBla_04:
		readjoypads
		writeCRAM	v_palette,0
		writeVRAMsrcdefined	v_spritetablebuffer,vram_sprites
		writeVRAMsrcdefined	v_hscrolltablebuffer,vram_hscroll
		tst.w	(v_demolength).w
		beq.w	LoadTilesAsYouMove_BGOnly
		subq.w	#1,(v_demolength).w
		bra.w	LoadTilesAsYouMove_BGOnly
; ===========================================================================

VBla_06:
		readjoypads
		writeCRAM	v_palette,0

		writeVRAMsrcdefined	v_hscrolltablebuffer,vram_hscroll
		writeVRAMsrcdefined	v_spritetablebuffer,vram_sprites
		bsr.w	ProcessDMAQueue
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		bsr.w	LoadTilesAsYouMove
		tst.w	(v_demolength).w ; is there time left on the demo?
		beq.s	.end		; if not, branch
		subq.w	#1,(v_demolength).w ; subtract 1 from time left

.end:
		jmp	(HUD_Update).l
; End of function Demo_Time

; ===========================================================================

VBla_08:
		readjoypads
		writeCRAM	v_palette,0
		writeVRAMsrcdefined	v_hscrolltablebuffer,vram_hscroll
		writeVRAMsrcdefined	v_spritetablebuffer,vram_sprites
		bsr.w	ProcessDMAQueue
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		bsr.w	LoadTilesAsYouMove
		jmp	(HUD_Update).l
; ===========================================================================

VBla_0A:
		readjoypads
		writeCRAM	v_palette,0
		writeVRAMsrcdefined	v_spritetablebuffer,vram_sprites
		writeVRAMsrcdefined	v_hscrolltablebuffer,vram_hscroll
		rts
; ===========================================================================

Vint_Menu:
		readjoypads
		writeCRAM	v_palette,0
		writeVRAMsrcdefined	v_spritetablebuffer,vram_sprites
		writeVRAMsrcdefined	v_hscrolltablebuffer,vram_hscroll
		tst.w	(v_demolength).w
		beq.w	ProcessDMAQueue
		subq.w	#1,(v_demolength).w
		bra.w	ProcessDMAQueue

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HInt:
		rte
; End of function HInt

; ===========================================================================
VDPSetupArray:	dc.w $8004		; 8-colour mode
		dc.w $8134		; enable V.interrupts, enable DMA
		dc.w $8200+(vram_fg>>10) ; set foreground nametable address
		dc.w $8300+($A000>>10)	; set window nametable address
		dc.w $8400+(vram_bg>>13) ; set background nametable address
		dc.w $8500+(vram_sprites>>9) ; set sprite table address
		dc.w $8600		; unused
		dc.w $8700		; set background colour (palette entry 0)
		dc.w $8800		; unused
		dc.w $8900		; unused
		dc.w $8A00		; default H.interrupt register
		dc.w $8B00		; full-screen vertical scrolling
		dc.w $8C81		; 40-cell display mode
		dc.w $8D00+(vram_hscroll>>10) ; set background hscroll address
		dc.w $8E00		; unused
		dc.w $8F02		; set VDP increment size
		dc.w $9001		; 64-cell hscroll size
		dc.w $9100		; window horizontal position
		dc.w $9200		; window vertical position
VDPSetupArray_End:

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


VDPSetupGame:
		lea	(vdp_data_port).l,a1
		lea	vdp_control_port-vdp_data_port(a1),a0
		lea	VDPSetupArray(pc),a2
	rept (VDPSetupArray_End-VDPSetupArray)/4
		move.l	(a2)+,(a0)
	endr
	; ensure last 2 bytes are not discarded.
		move.w	(a2)+,(a0)

		move.w	VDPSetupArray+2(pc),(v_vdp_buffer1).w
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l ; set VDP to CRAM write
	rept (v_palette_end-v_palette)/4
		move.l	d0,(a1)
	endr

		clr.l	(v_scrposy_vdp).w
		move.w	d1,-(sp)
		fillVRAM	0,0,$10000	; clear the entirety of VRAM
		move.w	(sp)+,d1
		rts
; End of function VDPSetupGame

; ---------------------------------------------------------------------------
; Subroutine to	clear the screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ClearScreen:
		fillVRAM	0, vram_fg, vram_fg+plane_size_64x32 ; clear foreground namespace
		fillVRAMsrcdefined	0, vram_bg, vram_bg+plane_size_64x32 ; clear background namespace

		move.w	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w ; reset the DMA Queue (to prevent potential bugs)

		moveq	#0,d0
		move.l	d0,(v_scrposy_vdp).w
		move.b	d0,(f_hud).w

		lea	(v_spritetablebuffer).w,a0
		moveq	#1,d1
		moveq	#$50-1,d7

.loop:
		move.w	d0,(a0)
		move.b	d1,3(a0)
		addq.w	#1,d1
		addq.w	#8,a0
		dbf	d7,.loop
		move.b	d0,-5(a0)

		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end

		rts
; End of function ClearScreen

		include "sound/Sonic-2-Clone-Driver-v2/engine/Functions.asm"
		include	"_inc/PauseGame.asm"

; ---------------------------------------------------------------------------
; Subroutine to	copy a tile map from RAM to VRAM namespace

; input:
;	a1 = tile map address
;	d0 = VRAM address
;	d1 = width (cells)
;	d2 = height (cells)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

Tilemap_Line:
		move.l	d0,vdp_control_port-vdp_data_port(a6)	; move d0 to VDP_control_port
		move.w	d1,d3

Tilemap_Cell:
		move.w	(a1)+,(a6)	; write value to namespace
		dbf	d3,Tilemap_Cell	; next tile
		add.l	d4,d0		; goto next line
		dbf	d2,Tilemap_Line	; next line
		rts
; End of function TilemapToVRAM

		include	"_inc/DMA-Queue.asm"

; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; LoadPLC:
AddPLC:
		lea	(ArtLoadCues).l,a6
		add.w	d0,d0
		move.w	(a6,d0.w),d0
		lea	(a6,d0.w),a6		; jump to relevant PLC
		move.w	(a6)+,d6	; get length of PLC
		bmi.s	.skip

.loop:
		movea.l	(a6)+,a1
		move.w	(a6)+,d2
		bsr.w	Queue_Kos_Module
		dbf	d6,.loop	; repeat for length of PLC

.skip:
		rts
; End of function AddPLC

; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; LoadPLC:
NewPLC:
		lea	(ArtLoadCues).l,a6
		add.w	d0,d0
		move.w	(a6,d0.w),d0
		lea	(a6,d0.w),a6		; jump to relevant PLC
		clearRAM Kos_decomp_stored_registers,Kos_module_end
		move.w	(a6)+,d6	; get length of PLC
		bmi.s	.skip

.loop:
		movea.l	(a6)+,a1
		move.w	(a6)+,d2
		bsr.w	Queue_Kos_Module
		dbf	d6,.loop	; repeat for length of PLC

.skip:
		rts
; End of function AddPLC

		include	"_inc/Enigma Decompression.asm"
		include	"_inc/KosinskiPlus.asm"
		include	"_inc/KosM.asm"

		include	"_inc/PaletteCycle.asm"

Pal_TitleCyc:	binclude	"palette/Cycle - Title Screen Water.bin"
Pal_GHZCyc:	binclude	"palette/Cycle - GHZ.bin"
Pal_LZCyc1:	binclude	"palette/Cycle - LZ Waterfall.bin"
Pal_LZCyc2:	binclude	"palette/Cycle - LZ Conveyor Belt.bin"
Pal_LZCyc3:	binclude	"palette/Cycle - LZ Conveyor Belt Underwater.bin"
; ---------------------------------------------------------------------------
; Subroutine to	fade in from black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteFadeIn:
		move.w	#($80/2)-1,(v_pfade_start).w ; set start position = 0; size = $80

PalFadeIn_Alt:				; start position and size are already set
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		moveq	#cBlack,d1
		move.b	(v_pfade_size).w,d0

.fill:
		move.w	d1,(a0)+
		dbf	d0,.fill 	; fill palette with black

		moveq	#$15,d4

.mainloop:
		move.w	#VBla_0A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	FadeIn_FromBlack
		dbf	d4,.mainloop
		rts
; End of function PaletteFadeIn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeIn_FromBlack:
		moveq	#0,d0
		lea	(v_palette).w,a0
		lea	(v_palette_fading).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

.addcolour:
		bsr.s	FadeIn_AddColour ; increase colour
		dbf	d0,.addcolour	; repeat for size of palette
		rts
; End of function FadeIn_FromBlack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeIn_AddColour:
.addblue:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3		; is colour already at threshold level?
		beq.s	.next		; if yes, branch
		move.w	d3,d1
		addi.w	#$200,d1	; increase blue	value
		cmp.w	d2,d1		; has blue reached threshold level?
		bhi.s	.addgreen	; if yes, branch
		move.w	d1,(a0)+	; update palette
		rts
; ===========================================================================

.addgreen:
		move.w	d3,d1
		addi.w	#$20,d1		; increase green value
		cmp.w	d2,d1
		bhi.s	.addred
		move.w	d1,(a0)+	; update palette
		rts
; ===========================================================================

.addred:
		addq.w	#2,(a0)+	; increase red value
		rts
; ===========================================================================

.next:
		addq.w	#2,a0		; next colour
		rts
; End of function FadeIn_AddColour


; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteFadeOut:
		move.w	#($80/2)-1,(v_pfade_start).w ; start position = 0; size = $40
		moveq	#$15,d4

.mainloop:
		move.w	#VBla_0A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	FadeOut_ToBlack
		dbf	d4,.mainloop
		rts
; End of function PaletteFadeOut


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

.decolour:
		bsr.s	FadeOut_DecColour ; decrease colour
		dbf	d0,.decolour	; repeat for size of palette
		rts
; End of function FadeOut_ToBlack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeOut_DecColour:
.dered:
		move.w	(a0),d2
		beq.s	.next
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	.degreen
		subq.w	#2,(a0)+	; decrease red value
		rts
; ===========================================================================

.degreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	.deblue
		subi.w	#$20,(a0)+	; decrease green value
		rts
; ===========================================================================

.deblue:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	.next
		subi.w	#$200,(a0)+	; decrease blue	value
		rts
; ===========================================================================

.next:
		addq.w	#2,a0
		rts
; End of function FadeOut_DecColour

; ---------------------------------------------------------------------------
; Subroutine to	fade in from white (Special Stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteWhiteIn:
		move.w	#($80/2)-1,(v_pfade_start).w ; start position = 0; size = $40
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.w	#cWhite,d1
		move.b	(v_pfade_size).w,d0

.fill:
		move.w	d1,(a0)+
		dbf	d0,.fill 	; fill palette with white

		moveq	#$15,d4

.mainloop:
		move.w	#VBla_0A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	WhiteIn_FromWhite
		dbf	d4,.mainloop
		rts
; End of function PaletteWhiteIn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteIn_FromWhite:
		moveq	#0,d0
		lea	(v_palette).w,a0
		lea	(v_palette_fading).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

.decolour:
		bsr.s	WhiteIn_DecColour ; decrease colour
		dbf	d0,.decolour	; repeat for size of palette
		rts
; End of function WhiteIn_FromWhite


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteIn_DecColour:
.deblue:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	.next
		move.w	d3,d1
		subi.w	#$200,d1	; decrease blue	value
		blo.s	.degreen
		cmp.w	d2,d1
		blo.s	.degreen
		move.w	d1,(a0)+
		rts
; ===========================================================================

.degreen:
		move.w	d3,d1
		subi.w	#$20,d1		; decrease green value
		blo.s	.dered
		cmp.w	d2,d1
		blo.s	.dered
		move.w	d1,(a0)+
		rts
; ===========================================================================

.dered:
		subq.w	#2,(a0)+	; decrease red value
		rts
; ===========================================================================

.next:
		addq.w	#2,a0
		rts
; End of function WhiteIn_DecColour

; ---------------------------------------------------------------------------
; Subroutine to fade to white (Special Stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteWhiteOut:
		move.w	#($80/2)-1,(v_pfade_start).w ; start position = 0; size = $40
		moveq	#$15,d4

.mainloop:
		move.w	#VBla_0A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	WhiteOut_ToWhite
		dbf	d4,.mainloop
		rts
; End of function PaletteWhiteOut


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteOut_ToWhite:
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

.addcolour:
		bsr.s	WhiteOut_AddColour
		dbf	d0,.addcolour
		rts
; End of function WhiteOut_ToWhite


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteOut_AddColour:
.addred:
		move.w	(a0),d2
		cmpi.w	#cWhite,d2
		beq.s	.next
		move.w	d2,d1
		andi.w	#$E,d1
		cmpi.w	#cRed,d1
		beq.s	.addgreen
		addq.w	#2,(a0)+	; increase red value
		rts
; ===========================================================================

.addgreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		cmpi.w	#cGreen,d1
		beq.s	.addblue
		addi.w	#$20,(a0)+	; increase green value
		rts
; ===========================================================================

.addblue:
		move.w	d2,d1
		andi.w	#$E00,d1
		cmpi.w	#cBlue,d1
		beq.s	.next
		addi.w	#$200,(a0)+	; increase blue	value
		rts
; ===========================================================================

.next:
		addq.w	#2,a0
		rts
; End of function WhiteOut_AddColour

; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Sega:
		tst.b	(v_pcyc_time+1).w
		bne.s	loc_206A
		lea	(v_palette+$20).w,a1
		lea	Pal_Sega1(pc),a0
		moveq	#5,d1
		move.w	(v_pcyc_num).w,d0

loc_2020:
		bpl.s	loc_202A
		addq.w	#2,a0
		subq.w	#1,d1
		addq.w	#2,d0
		bra.s	loc_2020
; ===========================================================================

loc_202A:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2034
		addq.w	#2,d0

loc_2034:
		cmpi.w	#$60,d0
		bhs.s	loc_203E
		move.w	(a0)+,(a1,d0.w)

loc_203E:
		addq.w	#2,d0
		dbf	d1,loc_202A

		move.w	(v_pcyc_num).w,d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2054
		addq.w	#2,d0

loc_2054:
		cmpi.w	#$64,d0
		blt.s	loc_2062
		move.w	#$401,(v_pcyc_time).w
		moveq	#-$C,d0

loc_2062:
		move.w	d0,(v_pcyc_num).w
		moveq	#1,d0
		rts
; ===========================================================================

loc_206A:
		subq.b	#1,(v_pcyc_time).w
		bpl.s	loc_20BC
		move.b	#4,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addi.w	#$C,d0
		cmpi.w	#$30,d0
		blo.s	loc_2088
		moveq	#0,d0
		rts
; ===========================================================================

loc_2088:
		move.w	d0,(v_pcyc_num).w
		lea	Pal_Sega2(pc,d0.w),a0
		lea	(v_palette+4).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)
		lea	(v_palette+$20).w,a1
		moveq	#0,d0
		moveq	#$2C,d1

loc_20A8:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_20B2
		addq.w	#2,d0

loc_20B2:
		move.w	(a0),(a1,d0.w)
		addq.w	#2,d0
		dbf	d1,loc_20A8

loc_20BC:
		moveq	#1,d0
		rts
; End of function PalCycle_Sega

; ===========================================================================

Pal_Sega1:	binclude	"palette/Sega1.bin"
Pal_Sega2:	binclude	"palette/Sega2.bin"

; ---------------------------------------------------------------------------
; Subroutines to load palettes

; input:
;	d0 = index number for palette
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalLoad_Fade:
		lea	PalPointers(pc),a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2	; get palette data address
		movea.w	(a1)+,a3	; get target RAM address
		lea	v_palette_fading-v_palette(a3),a3		; skip to "main" RAM address
		move.w	(a1)+,d7	; get length of palette data

.loop:
		move.l	(a2)+,(a3)+	; move data to RAM
		dbf	d7,.loop
		rts
; End of function PalLoad_Fade


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalLoad:
		lea	PalPointers(pc),a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2	; get palette data address
		movea.w	(a1)+,a3	; get target RAM address
		move.w	(a1)+,d7	; get length of palette

.loop:
		move.l	(a2)+,(a3)+	; move data to RAM
		dbf	d7,.loop
		rts
; End of function PalLoad

; ===========================================================================

		include	"_inc/Palette Pointers.asm"

; ---------------------------------------------------------------------------
; Palette data
; ---------------------------------------------------------------------------
bincludePalette macro path,{INTLABEL},{GLOBALSYMBOLS}
__LABEL__:	binclude	path
__LABEL___end:
	endm

Pal_Title:	bincludePalette	"palette/Title Screen.bin"
Pal_LevelSel:	bincludePalette	"palette/Menu.bin"
Pal_Sonic:	bincludePalette	"palette/Blaze.bin"
Pal_GHZ:	bincludePalette	"palette/Green Hill Zone.bin"
Pal_LZ:		bincludePalette	"palette/Labyrinth Zone.bin"

; ---------------------------------------------------------------------------
; Subroutine to	wait for VInt routines to complete
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WaitForVBla:
		lea	(v_vbla_counter).w,a0
		move.b	#1,(a0)
		enable_ints

.wait:
		tst.b	(a0) ; has VInt routine finished?
		bpl.s	.wait		; if not, branch
		clr.b	(a0)
		rts
; End of function WaitForVBla

		include	"_incObj/sub RandomNumber.asm"
		include	"_incObj/sub CalcSine.asm"
		include	"_incObj/sub CalcAngle.asm"

; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

GM_Sega:
		playsound bgm_Stop,music
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8700,(a6)	; set background colour (palette entry 0)
		move.w	#$8B00,(a6)	; full-screen vertical scrolling
		disable_ints
		clearRAM Kos_decomp_stored_registers, Kos_module_end
		displayOff
		bsr.w	ClearScreen
		lea	(KosP_SegaLogo).l,a0 ; load Sega	logo patterns
		lea	(v_128x128_end).w,a1
		bsr.w	KosPlusDec
		move.w	a1,d3
		lsr.w	#1,d3
		move.l	#dmaSource(v_128x128_end),d1
		moveq	#tiles_to_bytes(ArtTile_Level),d2
		bsr.w	QueueDMATransfer
		bsr.w	ProcessDMAQueue
		lea	(Eni_SegaLogo).l,a0 ; load Sega	logo mappings
		lea	(v_128x128_end).w,a1
		moveq	#make_art_tile(ArtTile_Sega_Tiles,0,FALSE),d0
		bsr.w	EniDec

		copyTilemap	v_128x128_end,vram_bg+$510,24,8
		copyTilemap	(v_128x128_end+24*8*2),vram_fg,40,28

		tst.b   (v_megadrive).w	; is console Japanese?
		bmi.s   .loadpal
		copyTilemap	(v_128x128_end+$A40),vram_fg+$53A,3,2 ; hide "TM" with a white rectangle

.loadpal:
		lea	(v_palette).w,a0
		move.l	#$0EEE0EEE,d0
	rept (v_palette_end-v_palette)/4
		move.l	d0,(a0)+	; move data to RAM
	endr
		move.w	#-$A,(v_pcyc_num).w
		moveq	#0,d0
		move.w	d0,(v_pcyc_time).w
		move.w	d0,(v_pal_buffer+$10).w
		displayOn

Sega_WaitPal:
		move.w	#VBla_02,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	PalCycle_Sega
		bne.s	Sega_WaitPal

		playsound sfx_Sega,music
		move.w	#VBla_0C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		move.w	#60/2,(v_demolength).w ; wait 30 frames (0.5 seconds)

Sega_WaitEnd:
		move.w	#VBla_02,(v_vbla_routine).w
		bsr.w	WaitForVBla
		tst.w	(v_demolength).w ; has demo length reached 0?
		beq.s	Sega_GotoTitle	; if so, go to the title screen
		tst.b	(v_jpadpress).w ; is Start button pressed?
		bpl.s	Sega_WaitEnd	; if not, branch

Sega_GotoTitle:
		move.w	#GM_Title,(v_gamemode).w ; go to title screen
		rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Title	screen
; ---------------------------------------------------------------------------

GM_Title:
		playsound bgm_Stop,music
		bsr.w	PaletteFadeOut
		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)	; 64-cell hscroll size
		move.w	#$9200,(a6)	; window vertical position
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)	; set background colour (palette line 2, entry 0)
		bsr.w	ClearScreen

		clearRAM Kos_decomp_stored_registers, Kos_module_end
		clearRAM v_objspace

		lea	(KosPM_JapNames).l,a1 ; load Japanese credits
		moveq	#tiles_to_bytes(ArtTile_Title_Japanese_Text),d2
		bsr.w	Queue_Kos_Module
		lea	(KosPM_CreditText).l,a1 ;	load alphabet
		move.w	#tiles_to_bytes(ArtTile_Sonic_Team_Font),d2
		bsr.w	Queue_Kos_Module
		lea	(Eni_JapNames).l,a0 ; load mappings for	Japanese credits
		lea	(v_128x128_end).w,a1
		moveq	#make_art_tile(ArtTile_Title_Japanese_Text,0,FALSE),d0
		bsr.w	EniDec

		copyTilemap	v_128x128_end,vram_fg,40,28

.waitplc:
		bsr.w	Process_Kos_Queue
		bsr.w	ProcessDMAQueue
		bsr.w	Process_Kos_Module_Queue
		tst.w	(Kos_modules_left).w ; are there any items in the pattern load cue?
		bne.s	.waitplc ; if yes, branch

		clearRAM v_palette_fading

		moveq	#palid_Sonic,d0	; load Sonic's palette
		bsr.w	PalLoad_Fade
		move.l	#CreditsText,(v_sonicteam).w ; load "SONIC TEAM PRESENTS" object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	PaletteFadeIn
		disable_ints
		lea	(KosPM_TitleFg).l,a1 ; load title	screen patterns
		move.w	#tiles_to_bytes(ArtTile_Title_Foreground),d2
		bsr.w	Queue_Kos_Module
		lea	(KosPM_TitleSonic).l,a1 ;	load Sonic title screen	patterns
		move.w	#tiles_to_bytes(ArtTile_Title_Sonic),d2
		bsr.w	Queue_Kos_Module
		lea	(KosPM_TitleTM).l,a1 ; load "TM" patterns
		move.w	#tiles_to_bytes(ArtTile_Title_Trademark),d2
		bsr.w	Queue_Kos_Module

.waitplc2:
		bsr.w	Process_Kos_Queue
		bsr.w	ProcessDMAQueue
		bsr.w	Process_Kos_Module_Queue
		tst.w	(Kos_modules_left).w ; are there any items in the pattern load cue?
		bne.s	.waitplc2 ; if yes, branch

		moveq	#0,d0
		move.b	d0,(v_lastlamp).w ; clear lamppost counter
	if DebuggingMode
		move.w	d0,(v_debuguse).w ; disable debug item placement mode
		move.b	d0,(f_debugmode).w ; disable debug mode
	endif
		move.w	d0,(f_demo).w	; disable debug mode
		move.w	d0,(v_zone).w	; set level to GHZ (00)
		move.w	d0,(v_pcyc_time).w ; disable palette cycling
		move.b	d0,(f_nobgscroll).w ; this fixes a bug in which the background won't scroll if you get a game over by drowning
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		move.l	#Blk16_GHZ,(v_16x16).w ; load	GHZ 16x16 mappings
		lea	(Blk128_GHZ).l,a0 ; load GHZ 128x128 mappings
		lea	(v_128x128).l,a1
		bsr.w	KosPlusDec
		bsr.w	LevelLayoutLoad
		bsr.w	PaletteFadeOut
		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_data_port).l,a6
		lea	vdp_control_port-vdp_data_port(a6),a5
		lea	(v_bgscreenposx).w,a3
		lea	(Level_layout_bg).w,a4
		move.w	#$6000,d2
		bsr.w	DrawChunks
		lea	(Eni_Title).l,a0 ; load	title screen mappings
		lea	(v_128x128_end).w,a1
		moveq	#0,d0
		bsr.w	EniDec

		copyTilemap	v_128x128_end,vram_fg+$208,34,22

		lea	(KosP_GHZ_1st).l,a0 ; load GHZ patterns
		lea	(v_128x128).l,a1
		bsr.w	KosPlusDec
		move.w	a1,d3
		lsr.w	#1,d3
		move.l	#dmaSource(v_128x128),d1
		moveq	#tiles_to_bytes(ArtTile_Level),d2
		bsr.w	QueueDMATransfer
		moveq	#palid_Title,d0	; load title screen palette
		bsr.w	PalLoad_Fade
		playsound bgm_Title,music

		clearRAM v_sonicteam,v_sonicteam+object_size

		move.l	#TitleSonic,(v_titlesonic).w ; load big Sonic object
		move.l	#PSBTM,(v_pressstart).w ; load "PRESS START BUTTON" object
		;clr.b	(v_pressstart+obRoutine).w ; The 'Mega Games 10' version of Sonic 1 added this line, to fix the 'PRESS START BUTTON' object not appearing

		tst.b	(v_megadrive).w	; is console Japanese?
		bpl.s	.isjap		; if yes, branch
		move.l	#PSBTM,(v_titletm).w ; load "TM" object
		move.b	#3,(v_titletm+obFrame).w
.isjap:
		move.l	#PSBTM,(v_ttlsonichide).w ; load object which hides part of Sonic
		move.b	#2,(v_ttlsonichide+obFrame).w
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		moveq	#plcid_Main,d0
		bsr.w	NewPLC

.waitplc3:
		bsr.w	Process_Kos_Queue
		bsr.w	ProcessDMAQueue
		bsr.w	Process_Kos_Module_Queue
		tst.w	(Kos_modules_left).w ; are there any items in the pattern load cue?
		bne.s	.waitplc3 ; if yes, branch
		clr.l	(v_title_dcount).w
		bsr.w	PaletteFadeIn

Tit_MainLoop:
		move.w	#VBla_04,(v_vbla_routine).w
		bsr.w	Process_Kos_Queue
		bsr.w	WaitForVBla
		bsr.w	ProcessDMAQueue
		bsr.w	Process_Kos_Module_Queue
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		bsr.w	PalCycle_Title
		addq.w	#2,(v_player+obX).w ; move Sonic to the right
		cmpi.w	#$1C00,(v_player+obX).w	; has Sonic object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion	; if not, branch

		move.w	#GM_Sega,(v_gamemode).w ; go to Sega screen
		rts
; ===========================================================================

Tit_ChkRegion:
		lea	LevSelCode_US(pc),a0 ; load US code

Tit_EnterCheat:
		move.w	(v_title_dcount).w,d0
		adda.w	d0,a0
		move.b	(v_jpadpress).w,d0 ; get button press
		andi.b	#btnDir,d0	; read only UDLR buttons
		cmp.b	(a0),d0		; does button press match the cheat code?
		bne.s	Tit_ResetCheat	; if not, branch
		addq.w	#1,(v_title_dcount).w ; next button press
		tst.b	d0
		bne.s	Tit_CountC
		lea	(f_levselcheat).w,a0
		move.w	(v_title_ccount).w,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.s	Tit_PlayRing
		tst.b	(v_megadrive).w
		bpl.s	Tit_PlayRing
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)	; cheat depends on how many times C is pressed

Tit_PlayRing:
		move.b	#1,(a0,d1.w)	; activate cheat
		playsound sfx_Ring,sfx
		bra.s	Tit_CountC
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0
		beq.s	Tit_CountC
		cmpi.w	#9,(v_title_dcount).w
		beq.s	Tit_CountC
		clr.w	(v_title_dcount).w ; reset UDLR counter

Tit_CountC:
		moveq	#btnC,d0	; is C button pressed?
		and.b	(v_jpadpress).w,d0
		beq.s	loc_3230	; if not, branch
		addq.w	#1,(v_title_ccount).w ; increment C counter

loc_3230:
		tst.b	(v_jpadpress).w ; check if Start is pressed
		bpl.w	Tit_MainLoop	; if not, branch

Tit_ChkLevSel:
		tst.b	(f_levselcheat).w ; check if level select code is on
		beq.w	PlayLevel	; if not, play level
		btst	#bitA,(v_jpadhold).w ; check if A is pressed
		beq.w	PlayLevel	; if not, play level
		move.w	#GM_MenuScreen,(v_gamemode).w ; go to title screen
		rts
; ---------------------------------------------------------------------------
; Level	select code
; ---------------------------------------------------------------------------
LevSelCode_US:	dc.b btnUp,btnDn,btnL,btnR,0,$FF
		even

		include	"_inc/Menus.asm"

MusicList:
		dc.b	bgm_GHZ	; Green Hill Zone Act 1
		dc.b	bgm_GHZ	; Green Hill Zone Act 2
		dc.b	bgm_LZ	; Labyrinth Zone Act 1
		dc.b	bgm_LZ	; Labyrinth Zone Act 2
		even
; ===========================================================================

; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

GM_Level:
		st.b	(v_prelevel).w ; enable pre level sequence flag
		playsound bgm_Fade,music
		clearRAM Kos_decomp_stored_registers, Kos_module_end
		bsr.w	PaletteFadeOut
		lea	(KosPM_TitleCard).l,a1 ; load title card patterns
		move.w	#tiles_to_bytes(ArtTile_Title_Card),d2
		bsr.w	Queue_Kos_Module
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#3,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		bsr.w	AddPLC		; load level patterns
		moveq	#plcid_Main2,d0
		bsr.w	AddPLC		; load standard	patterns

Level_ClrRam:
		clearRAM v_objspace
		clearRAM v_misc_variables
		clearRAM v_levelvariables
		clearRAM v_timingandscreenvariables

		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)

Level_LoadPal:
		enable_ints
		moveq	#palid_Sonic,d0
		bsr.w	PalLoad	; load Sonic's palette

Level_GetBgm:
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#7,d0
		lea	MusicList(pc),a0
		move.b	(a0,d0.w),(v_saved_music).w
		tst.w	(Clone_Driver_RAM+SMPS_RAM.variables.queue.v_playsnd1).w
		bne.s	+
		clr.b	(Clone_Driver_RAM+SMPS_RAM.variables.queue.v_playsnd1+0).w
		move.b	(v_saved_music).w,(Clone_Driver_RAM+SMPS_RAM.variables.queue.v_playsnd1+1).w
		bra.s	++

+
		clr.b	(Clone_Driver_RAM+SMPS_RAM.variables.queue.v_playsnd4+0).w
		move.b	(v_saved_music).w,(Clone_Driver_RAM+SMPS_RAM.variables.queue.v_playsnd4+1).w
+
		move.l	#TitleCard,(v_titlecard).w ; load title card object

Level_TtlCardLoop:
		move.w	#VBla_08,(v_vbla_routine).w
		bsr.w	Process_Kos_Queue
		bsr.w	WaitForVBla
		bsr.w	Process_Kos_Module_Queue
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	(v_ttlcardact+obX).w,d0
		cmp.w	(v_ttlcardact+card_mainX).w,d0 ; has title card sequence finished?
		bne.s	Level_TtlCardLoop ; if not, branch
		tst.w	(Kos_modules_left).w ; are there any items in the pattern load cue?
		bne.s	Level_TtlCardLoop ; if yes, branch
		jsr	(Hud_Base).l	; load basic HUD gfx
		moveq	#palid_Sonic,d0
		bsr.w	PalLoad_Fade	; load Sonic's palette
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bset	#2,(v_fg_scroll_flags).w
		bsr.w	LevelDataLoad ; load block mappings and palettes
		bsr.w	LoadTilesFromStart
		bsr.w	ColIndexLoad
		move.l	#SonicPlayer,(v_player).w ; load Sonic object
		moveq	#1,d0
		move.b	d0,(f_hud).w
		move.b	d0,(HUD_scroll_flag).w

Level_ChkDebug:
	if DebuggingMode
		tst.b	(f_debugcheat).w ; has debug cheat been entered?
		beq.s	Level_ChkWater	; if not, branch
		btst	#bitA,(v_jpadhold).w ; is A button held?
		sne.b	(f_debugmode).w ; if so, enable debug mode
	endif

Level_ChkWater:
		clr.l	(v_jpadhold_stored).w

Level_LoadObj:
		jsr	(ObjPosLoad).l
		jsr	(RingsManager).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(AnimateLevelGfx).l
		moveq	#0,d0
		tst.b	(v_lastlamp).w	; are you starting from	a lamppost?
		bne.s	Level_SkipClr	; if yes, branch
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.b	d0,(v_lifecount).w ; clear lives counter

Level_SkipClr:
		move.b	d0,(f_timeover).w
		move.b	d0,(v_shield).w	; clear shield
		move.b	d0,(v_invinc).w	; clear invincibility
		move.b	d0,(v_shoes).w	; clear speed shoes
	if DebuggingMode
		move.w	d0,(v_debuguse).w
	endif
		move.w	d0,(f_restart).w
		move.w	d0,(v_framecount).w
		bsr.w	OscillateNumInit
		moveq	#1,d0
		move.b	d0,(f_scorecount).w ; update score counter
		move.b	d0,(f_ringcount).w ; update rings counter
		move.b	d0,(f_timecount).w ; update time counter

Level_ChkWaterPal:

Level_Delay:
		move.w	#VBla_06,(v_vbla_routine).w
		bsr.w	WaitForVBla

		move.w	#$202F,(v_pfade_start).w ; fade in 2nd, 3rd & 4th palette lines
		bsr.w	PalFadeIn_Alt
		addq.b	#2,(v_ttlcardname+obRoutine).w ; make title card move
		moveq	#4,d0
		move.b	d0,(v_ttlcardzone+obRoutine).w
		move.b	d0,(v_ttlcardact+obRoutine).w
		move.b	d0,(v_ttlcardoval+obRoutine).w
		clr.b	(v_prelevel).w ; end pre-level stuff

; ---------------------------------------------------------------------------
; Main level loop (when	all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame
		move.w	#VBla_06,(v_vbla_routine).w
		bsr.w	Process_Kos_Queue
		bsr.w	WaitForVBla
		bsr.w	Process_Kos_Module_Queue
		addq.w	#1,(v_framecount).w ; add 1 to level timer
		jsr	(ExecuteObjects).l
		tst.w	(f_restart).w
		bne.w	GM_Level
	if DebuggingMode
		tst.w	(v_debuguse).w	; is debug mode being used?
		bne.s	Level_DoScroll	; if yes, branch
	endif
		cmpi.b	#6,(v_player+obRoutine).w ; has Sonic just died?
		bhs.s	Level_SkipScroll ; if yes, branch

Level_DoScroll:
		bsr.w	DeformLayers

Level_SkipScroll:
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		jsr	(RingsManager).l
		jsr	(AnimateLevelGfx).l
		bsr.w	PaletteCycle
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		bsr.w	SignpostArtLoad

		cmpi.w	#GM_Level,(v_gamemode).w
		beq.s	Level_MainLoop	; if mode is $C (level), branch
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Collision index pointer loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ColIndexLoad:
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#5,d0
		move.l	ColPointers_1(pc,d0.w),(v_colladdr1).w	; MJ: get first collision set
		move.l	ColPointers_2(pc,d0.w),(v_colladdr2).w	; MJ: get second collision set
		rts
; End of function ColIndexLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision index pointers
; ---------------------------------------------------------------------------
ColPointers_1:	dc.l Col_GHZ_1	; MJ: each zone now has two entries
		dc.l Col_GHZ_1
		dc.l Col_LZ_1
		dc.l Col_LZ_1

ColPointers_2:	dc.l Col_GHZ_2
		dc.l Col_GHZ_2
		dc.l Col_LZ_2
		dc.l Col_LZ_2

		include	"_inc/Oscillatory Routines.asm"

; ---------------------------------------------------------------------------
; Subroutine to	change synchronised animation variables (rings, giant rings)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SynchroAnimate:

; Used for GHZ spiked log
Sync1:
		subq.b	#1,(v_ani0_time).w ; has timer reached 0?
		bpl.s	Sync2		; if not, branch
		move.b	#$B,(v_ani0_time).w ; reset timer
		subq.b	#1,(v_ani0_frame).w ; next frame
		andi.b	#7,(v_ani0_frame).w ; max frame is 7

; Used for rings and giant rings
Sync2:
		subq.b	#1,(v_ani1_time).w
		bpl.s	Sync3
		move.b	#7,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#3,(v_ani1_frame).w

; Used for bouncing rings
Sync3:
		tst.b	(v_ani2_time).w
		beq.s	SyncEnd
		moveq	#0,d0
		move.b	(v_ani2_time).w,d0
		add.w	(v_ani2_buf).w,d0
		move.w	d0,(v_ani2_buf).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(v_ani2_frame).w
		subq.b	#1,(v_ani2_time).w

SyncEnd:
		rts
; End of function SynchroAnimate

; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SignpostArtLoad:
	if DebuggingMode
		tst.w	(v_debuguse).w	; is debug mode	being used?
		bne.s	.exit		; if yes, branch
	endif
		cmpi.b	#1,(v_act).w	; is act number 01 (act 2)?
		beq.s	.exit		; if yes, branch

		move.w	(v_screenposx).w,d0
		move.w	(v_limitright2).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0		; has Sonic reached the	edge of	the level?
		blt.s	.exit		; if not, branch
		tst.b	(f_timecount).w
		beq.s	.exit
		cmp.w	(v_limitleft2).w,d1
		beq.s	.exit
		move.w	d1,(v_limitleft2).w ; move left boundary to current screen position
		moveq	#plcid_Signpost,d0
		bra.w	NewPLC		; load signpost	patterns

.exit:
		rts
; End of function SignpostArtLoad

; ===========================================================================

		include	"_inc/LevelSizeLoad & BgScrollSpeed.asm"
		include	"_inc/DeformLayers.asm"

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6886:
LoadTilesAsYouMove_BGOnly:
		lea	(vdp_data_port).l,a6
		lea	vdp_control_port-vdp_data_port(a6),a5
		lea	(v_bg1_scroll_flags).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(Level_layout_bg).w,a4
		move.w	#$6000,d2
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags).w,a2
		lea	(v_bg2screenposx).w,a3
		bra.w	DrawBGScrollBlock2
; End of function sub_6886

; ---------------------------------------------------------------------------
; Subroutine to	display	correct	tiles as you move
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesAsYouMove:
		lea	(vdp_data_port).l,a6
		lea	vdp_control_port-vdp_data_port(a6),a5
		; First, update the background
		lea	(v_bg1_scroll_flags_dup).w,a2	; Scroll block 1 scroll flags
		lea	(v_bgscreenposx_dup).w,a3	; Scroll block 1 X coordinate
		lea	(Level_layout_bg).w,a4
		move.w	#$6000,d2			; VRAM thing for selecting Plane B
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags_dup).w,a2	; Scroll block 2 scroll flags
		lea	(v_bg2screenposx_dup).w,a3	; Scroll block 2 X coordinate
		bsr.w	DrawBGScrollBlock2
		lea	(v_bg3_scroll_flags_dup).w,a2	; Scroll block 3 scroll flags
		lea	(v_bg3screenposx_dup).w,a3	; Scroll block 3 X coordinate
		bsr.w	DrawBGScrollBlock3
		; Then, update the foreground
		lea	(v_fg_scroll_flags_dup).w,a2	; Foreground scroll flags
		lea	(v_screenposx_dup).w,a3		; Foreground X coordinate
		subq.w	#2,a4
		move.w	#$4000,d2			; VRAM thing for selecting Plane A
		; The FG's update function is inlined here
		tst.b	(a2)
		beq.s	locret_6952	; If there are no flags set, nothing needs updating
		bclr	#0,(a2)
		beq.s	loc_6908
		; Draw new tiles at the top
		moveq	#-16,d4	; Y coordinate. Note that 16 is the size of a block in pixels
		moveq	#-16,d5 ; X coordinate
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4 ; Y coordinate
		moveq	#-16,d5 ; X coordinate
		bsr.w	DrawBlocks_LR

loc_6908:
		bclr	#1,(a2)
		beq.s	loc_6922
		; Draw new tiles at the bottom
		move.w	#224,d4	; Start at bottom of the screen. Since this draws from top to bottom, we don't need 224+16
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_6922:
		bclr	#2,(a2)
		beq.s	loc_6938
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB

loc_6938:
		bclr	#3,(a2)
		beq.s	locret_6952
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bra.w	DrawBlocks_TB

locret_6952:
		rts
; End of function LoadTilesAsYouMove


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6954:
DrawBGScrollBlock1:
		tst.b	(a2)
		beq.s	locret_6952
		bclr	#0,(a2)
		beq.s	loc_6972
		; Draw new tiles at the top
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_6972:
		bclr	#1,(a2)
		beq.s	loc_698E
		; Draw new tiles at the top
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_698E:
		bclr	#2,(a2)
		beq.s	locj_6D56
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB
locj_6D56:

		bclr	#3,(a2)
		beq.s	locj_6D70
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawBlocks_TB
locj_6D70:

		bclr	#4,(a2)
		beq.s	locj_6D88
		; Draw entire row at the top
		moveq	#-16,d4
		moveq	#0,d5
		bsr.w	Calc_VRAM_Pos_2
		moveq	#-16,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_3
locj_6D88:

		bclr	#5,(a2)
		beq.s	locret_69F2
		; Draw entire row at the bottom
		move.w	#224,d4
		moveq	#0,d5
		bsr.w	Calc_VRAM_Pos_2
		move.w	#224,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bra.w	DrawBlocks_LR_3

locret_69F2:
		rts
; End of function DrawBGScrollBlock1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Essentially, this draws everything that isn't scroll block 1
; sub_69F4:
DrawBGScrollBlock2:
		tst.b	(a2)
		beq.s	locret_69F2
		bclr	#0,(a2)
		beq.s	locj_6DD2
		; Draw new tiles on the left
		move.w	#224/2,d4	; Draw the bottom half of the screen
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224/2,d4
		moveq	#-16,d5
		moveq	#3-1,d6		; Draw three rows... could this be a repurposed version of the above unused code?
		bsr.w	DrawBlocks_TB_2
locj_6DD2:
		bclr	#1,(a2)
		beq.s	locret_69F2
		; Draw new tiles on the right
		move.w	#224/2,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224/2,d4
		move.w	#320,d5
		moveq	#3-1,d6
		bra.w	DrawBlocks_TB_2
;===============================================================================


; locj_6EA4:
DrawBGScrollBlock3:
		tst.b	(a2)
		beq.s	locj_6EF0
		bclr	#0,(a2)
		beq.s	locj_6ED0
		; Draw new tiles on the left
		move.w	#$40,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#$40,d4
		moveq	#-16,d5
		moveq	#3-1,d6
		bsr.w	DrawBlocks_TB_2
locj_6ED0:
		bclr	#1,(a2)
		beq.s	locj_6EF0
		; Draw new tiles on the right
		move.w	#$40,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#$40,d4
		move.w	#320,d5
		moveq	#3-1,d6
		bra.w	DrawBlocks_TB_2
locj_6EF0:
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from left to right
; when the camera's moving up or down
; DrawTiles_LR:
DrawBlocks_LR:
		moveq	#((320+16+16)/16)-1,d6	; Draw the entire width of the screen + two extra columns
; DrawTiles_LR_2:
DrawBlocks_LR_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.s	DrawBlock
		addq.b	#4,d1		; Two tiles ahead
		andi.b	#$7F,d1		; Wrap around row
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		addi.w	#16,d5		; Move X coordinate one block ahead
		dbf	d6,.loop
		rts
; End of function DrawBlocks_LR

; DrawTiles_LR_3:
DrawBlocks_LR_3:
		move.l	#$800000,d7
		move.l	d0,d1

.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData_2
		move.l	d1,d0
		bsr.s	DrawBlock
		addq.b	#4,d1
		andi.b	#$7F,d1
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		addi.w	#16,d5
		dbf	d6,.loop
		rts
; End of function DrawBlocks_LR_3


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from top to bottom
; when the camera's moving left or right
; DrawTiles_TB:
DrawBlocks_TB:
		moveq	#((224+16+16)/16)-1,d6	; Draw the entire height of the screen + two extra rows
; DrawTiles_TB_2:
DrawBlocks_TB_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.s	DrawBlock
		addi.w	#$100,d1	; Two rows ahead
		andi.w	#$FFF,d1	; Wrap around plane
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		addi.w	#16,d4		; Move X coordinate one block ahead
		dbf	d6,.loop
		rts
; End of function DrawBlocks_TB_2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Draws a block's worth of tiles
; Parameters:
; a0 = Pointer to block metadata (block index and X/Y flip)
; a1 = Pointer to block
; a5 = Pointer to VDP command port
; a6 = Pointer to VDP data port
; d0 = VRAM command to access plane
; d2 = VRAM plane A/B specifier
; d7 = Plane row delta
; DrawTiles:
DrawBlock:
		or.w	d2,d0	; OR in that plane A/B specifier to the VRAM command
		swap	d0
		btst	#3,(a0)	; Check Y-flip bit
		bne.s	DrawFlipY
		btst	#2,(a0)	; Check X-flip bit
		bne.s	DrawFlipX
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write bottom two tiles
		rts
; ===========================================================================

DrawFlipX:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4	; Invert X-flip bits of each tile
		swap	d4		; Swap the tiles around
		move.l	d4,(a6)		; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)		; Write bottom two tiles
		rts
; ===========================================================================

DrawFlipY:
		btst	#2,(a0)
		bne.s	DrawFlipXY
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts
; ===========================================================================

DrawFlipXY:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts
; End of function DrawBlocks

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Gets address of block at a certain coordinate
; Parameters:
; a4 = Pointer to level layout
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns:
; a0 = Address of block metadata
; a1 = Address of block
; DrawBlocks:
GetBlockData:
		add.w	(a3),d5
GetBlockData_2:
		add.w	4(a3),d4
		; Set Y coordinate in level layout
		move.w	d4,d0		; MJ: copy Y position to d3
		asr.w	#5,d0
		andi.w	#$3C,d0
		movea.w	(a4,d0.w),a1
		; Set X coordinate in level layout
		lsr.w	#3,d5		; MJ: divide X position by 8
		move.w	d5,d0		; MJ: copy to d0
		lsr.w	#4,d0		; MJ: divide by 10 (Not 20)
		moveq	#-1,d3		; MJ: prepare FFFF in d3
		clr.w	d3
		; Turn chunk ID from level layout
		move.b  (a1,d0.w),d3
		lsl.w	#7,d3		; MJ: multiply by 80
		; Turn Y coordinate into index into chunk
		andi.w	#$70,d4		; MJ: keep Y pos within 80 pixels
		; Turn X coordinate into index into chunk
		andi.w	#$E,d5		; MJ: keep X pos within 10
		; Get chunk metadata
		add.w	d4,d3		; MJ: add calc'd Y pos to ror'd d3
		add.w	d5,d3		; MJ: add calc'd X pos to ror'd d3
		movea.l	d3,a0		; MJ: set address (Chunk to read)
		move.w	(a0),d3
		movea.l	(v_16x16).w,a1
		; Turn block ID into address
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_6C1E:
		rts
; End of function GetBlockData


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Produces a VRAM plane access command from coordinates
; Parameters:
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns VDP command in d0
Calc_VRAM_Pos:
		add.w	(a3),d5
Calc_VRAM_Pos_2:
		add.w	4(a3),d4
		; Floor the coordinates to the nearest pair of tiles (the size of a block).
		; Also note that this wraps the value to the size of the plane:
		; The plane is 64*8 wide, so wrap at $100, and it's 32*8 tall, so wrap at $200
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0	; Highest bits of plane VRAM address
		swap	d0
		move.w	d4,d0
		rts
; End of function Calc_VRAM_Pos

; ---------------------------------------------------------------------------
; Subroutine to	load tiles as soon as the level	appears
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(vdp_data_port).l,a6
		lea	vdp_control_port-vdp_data_port(a6),a5
		lea	(v_screenposx).w,a3
		lea	(Level_layout_main).w,a4
		move.w	#$4000,d2
		bsr.s	DrawChunks
		lea	(v_bgscreenposx).w,a3
		addq.w	#2,a4
		move.w	#$6000,d2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		beq.s	Draw_GHz_Bg
; End of function LoadTilesFromStart


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

DrawChunks:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6

.loop:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.s	Calc_VRAM_Pos
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,.loop
		rts
; End of function DrawChunks

Draw_GHz_Bg:
		moveq	#0,d4
		moveq	#((224+16+16)/16)-1,d6
locj_7224:
		movem.l	d4-d6,-(sp)
		lea	locj_724a(pc),a0
		move.w	(v_bgscreenposy).w,d0
		add.w	d4,d0
		andi.w	#$F0,d0
		bsr.w	locj_72Ba
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,locj_7224
		rts
locj_724a:
		dc.b $00,$00,$00,$00,$06,$06,$06,$04,$04,$04,$00,$00,$00,$00,$00,$00
		even
;-------------------------------------------------------------------------------
locj_72B2:
		dc.w v_bgscreenposx, v_bgscreenposx, v_bg2screenposx, v_bg3screenposx
locj_72Ba:
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	locj_72B2(pc,d0.w),a3
		beq.s	locj_72da
		moveq	#-16,d5
		movem.l	d4-d5,-(sp)
		bsr.w	Calc_VRAM_Pos
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		bra.w	DrawBlocks_LR
locj_72da:
		moveq	#0,d5
		movem.l	d4-d5,-(sp)
		bsr.w	Calc_VRAM_Pos_2
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		moveq	#(512/16)-1,d6
		bra.w	DrawBlocks_LR_3

; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelDataLoad:
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#3,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		movea.l	(a2)+,a0
		lea	(v_128x128).l,a1
		bsr.w	KosPlusDec
		move.w	a1,d3
		move.w	d3,d7
		andi.w	#$FFF,d3
		lsr.w	#1,d3
		rol.w	#4,d7
		andi.w	#$F,d7

.loop:		move.w	d7,d2
		moveq	#12,d0
		lsl.w	d0,d2
		move.l	#$FFFFFF,d1
		move.w	d2,d1
		lsr.l	#1,d1
		bsr.w	QueueDMATransfer
		move.w	d7,-(sp)
		move.w	#VBla_08,(v_vbla_routine).w
		bsr.w	WaitForVBla
		move.w	(sp)+,d7
		move.w	#$800,d3
		dbf	d7,.loop
		move.l	(a2)+,(v_16x16).w	; RAM address for 16x16 mappings
		movea.l	(a2)+,a0
		lea	(v_128x128).l,a1 ; RAM address for 128x128 mappings
		bsr.w	KosPlusDec
		bsr.s	LevelLayoutLoad
		move.b	(a2),d0
		bsr.w	PalLoad_Fade	; load palette (based on d0)
		movea.l	(sp)+,a2
		addq.w	#4,a2		; read number for 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0
		bra.w	AddPLC		; load pattern load cues
; End of function LevelDataLoad

; ---------------------------------------------------------------------------
; Level	layout loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad:
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#5,d0
		lea	(Level_Index).l,a0
		movea.l	(a0,d0.w),a0
		lea	(Level_layout_header).w,a1
	rept (Level_layout_main_end-Level_layout_header)/4
		move.l	(a0)+,(a1)+
	endr
		rts
; End of function LevelLayoutLoad

		include	"_inc/DynamicLevelEvents.asm"

		include	"_incObj/11 Bridge.asm"

; ---------------------------------------------------------------------------
; Platform subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

PlatformObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)	; is Sonic moving up/jumping?
		bmi.w	Plat_Exit	; if yes, branch

;		perform x-axis range check
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit

Plat_NoXCheck:
		move.w	obY(a0),d0
		subq.w	#8,d0

Platform3:
;		perform y-axis range check
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.s	Plat_Exit
		cmpi.w	#-$10,d0
		blo.s	Plat_Exit

		tst.b	(f_playerctrl).w
		bmi.s	Plat_Exit
		cmpi.b	#6,obRoutine(a1)
		bhs.s	Plat_Exit
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
		addq.b	#2,obRoutine(a0)

loc_74AE:
		btst	#3,obStatus(a1)
		beq.s	loc_74DC
		movea.w	standonobject(a1),a2
		bclr	#3,obStatus(a2)
		clr.b	ob2ndRout(a2)
		cmpi.b	#4,obRoutine(a2)
		bne.s	loc_74DC
		subq.b	#2,obRoutine(a2)

loc_74DC:
		move.w	a0,standonobject(a1)
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#1,obStatus(a1)
		beq.s	loc_7512
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_7512:
		bset	#3,obStatus(a1)
		bset	#3,obStatus(a0)

Plat_Exit:
		rts
; End of function PlatformObject

; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	SLZ seesaws)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SlopeObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.s	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	Plat_Exit
		btst	#0,obRender(a0)
		beq.s	loc_754A
		not.w	d0
		add.w	d1,d0

loc_754A:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Platform3


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swing_Solid:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Platform3
; End of function Obj15_Solid

; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk or jump off	a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ExitPlatform:
		move.w	d1,d2

ExitPlatform2:
		add.w	d2,d2
		lea	(v_player).w,a1
		btst	#1,obStatus(a1)
		bne.s	loc_75E0
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_75E0
		cmp.w	d2,d0
		blo.s	locret_75F2

loc_75E0:
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a0)
		bclr	#3,obStatus(a0)

locret_75F2:
		rts
; End of function ExitPlatform

Map_Bri:	include	"_maps/Bridge.asm"

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MvSonicOnPtfm:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		sub.w	d3,d0
		tst.b	(f_playerctrl).w
		bmi.s	.locret
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	.locret
	if DebuggingMode
		tst.w	(v_debuguse).w
		bne.s	.locret
	endif
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

.locret:
		rts
; End of function MvSonicOnPtfm

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MvSonicOnPtfm2:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		subq.w	#8,d0

MvSonic2:
		tst.b	(f_playerctrl).w
		bmi.s	locret_7B62
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	locret_7B62
	if DebuggingMode
		tst.w	(v_debuguse).w
		bne.s	locret_7B62
	endif
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_7B62:
		rts
; End of function MvSonicOnPtfm2

		include	"_incObj/17 Spiked Pole Helix.asm"
Map_Hel:	include	"_maps/Spiked Pole Helix.asm"
		include	"_incObj/18 Platforms.asm"
Map_Plat_GHZ:	include	"_maps/Platforms (GHZ).asm"
Map_GBall:	include	"_maps/GHZ Ball.asm"
		include	"_incObj/1A Collapsing Ledge (part 1).asm"
; ===========================================================================

Ledge_Fragment:
		clr.b	ledge_collapse_flag(a0)

loc_847A:
		lea	CFlo_Data1(pc),a4
		moveq	#$18,d1
		addq.b	#2,obFrame(a0)

loc_8486:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#2,a3
		bset	#5,obRender(a0)
		move.l	obID(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_84B2
; ===========================================================================

loc_84AA:
		lea	(v_lvlobjspace).w,a1 ; start address for object RAM
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0

.loop:
		lea	object_size(a1),a1
		tst.l	obID(a1)
		dbeq	d0,.loop
		bne.s	loc_84F2
		addq.w	#6,a3

loc_84B2:
		move.b	#6,obRoutine(a1)
		move.l	d4,obID(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.w	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		cmpa.l	a0,a1
		bhs.s	loc_84EE
		bsr.w	DisplaySprite1

loc_84EE:
		dbf	d1,loc_84AA

loc_84F2:
		playsound sfx_Collapse,sfx
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Disintegration data for collapsing ledges (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------
CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12,	$E, $A,	6, $18,	$14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C, 0
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12,	$A, 2
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E,	$A, 2

; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	MZ platforms)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SlopeObject2:
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	locret_856E
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,obRender(a0)
		beq.s	loc_854E
		not.w	d0
		add.w	d1,d0

loc_854E:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	obY(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_856E:
		rts
; End of function SlopeObject2

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for GHZ collapsing ledge
; ---------------------------------------------------------------------------
Ledge_SlopeData:
		binclude	"misc/GHZ Collapsing Ledge Heightmap.bin"
		even

Map_Ledge:	include	"_maps/Collapsing Ledge.asm"
Map_CFlo:	include	"_maps/Collapsing Floors.asm"

		include	"_incObj/1C Scenery.asm"
Map_Scen:	include	"_maps/Scenery.asm"

		include	"_incObj/24, 27 & 3F Explosions.asm"
		include	"_maps/Explosions.asm"

		include	"_incObj/28 Animals.asm"
		include	"_incObj/29 Points.asm"
Map_Animal1:	include	"_maps/Animals 1.asm"
Map_Animal2:	include	"_maps/Animals 2.asm"
Map_Animal3:	include	"_maps/Animals 3.asm"
Map_Poi:	include	"_maps/Points.asm"

		include	"_incObj/1F Crabmeat.asm"
		include	"_anim/Crabmeat.asm"
Map_Crab:	include	"_maps/Crabmeat.asm"
		include	"_incObj/22 Buzz Bomber.asm"
		include	"_incObj/23 Buzz Bomber Missile.asm"
		include	"_anim/Buzz Bomber.asm"
		include	"_anim/Buzz Bomber Missile.asm"
Map_Buzz:	include	"_maps/Buzz Bomber.asm"
Map_Missile:	include	"_maps/Buzz Bomber Missile.asm"

		include	"_incObj/25 & 37 Rings.asm"
		include	"_incObj/4B Giant Ring.asm"
		include	"_incObj/7C Ring Flash.asm"

		include	"_anim/Rings.asm"
Map_Ring:	include	"_maps/Rings.asm"
Map_GRing:	include	"_maps/Giant Ring.asm"
Map_Flash:	include	"_maps/Ring Flash.asm"
		include	"_incObj/26 Monitor.asm"
		include	"_incObj/2E Monitor Content Power-Up.asm"
		include	"_incObj/26 Monitor (SolidSides subroutine).asm"
		include	"_anim/Monitor.asm"
Map_Monitor:	include	"_maps/Monitor.asm"

		include	"_incObj/0E Title Screen Sonic.asm"
		include	"_incObj/0F Press Start and TM.asm"

		include	"_anim/Title Screen Sonic.asm"
		include	"_anim/Press Start and TM.asm"

		include	"_incObj/sub AnimateSprite.asm"

Map_PSB:	include	"_maps/Press Start and TM.asm"
Map_TSon:	include	"_maps/Title Screen Sonic.asm"

		include	"_incObj/2B Chopper.asm"
		include	"_anim/Chopper.asm"
Map_Chop:	include	"_maps/Chopper.asm"

		include	"_incObj/34 Title Cards.asm"
		include	"_incObj/39 Game Over.asm"
		include	"_incObj/3A Got Through Card.asm"

; ---------------------------------------------------------------------------
; Sprite mappings - zone title cards
; ---------------------------------------------------------------------------
Map_Card:	mappingsTable
	mappingsTableEntry.w	M_Card_GHZ
	mappingsTableEntry.w	M_Card_LZ
	mappingsTableEntry.w	M_Card_MZ
	mappingsTableEntry.w	M_Card_SLZ
	mappingsTableEntry.w	M_Card_SYZ
	mappingsTableEntry.w	M_Card_SBZ
	mappingsTableEntry.w	M_Card_Zone
	mappingsTableEntry.w	M_Card_Act1
	mappingsTableEntry.w	M_Card_Act2
	mappingsTableEntry.w	M_Card_Act3
	mappingsTableEntry.w	M_Card_Oval
	mappingsTableEntry.w	M_Card_FZ

M_Card_GHZ:	spriteHeader		; GREEN HILL
	spritePiece	-$4C, -8, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$3C, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	-$2C, -8, 2, 2, $10, 0, 0, 0, 0
	spritePiece	-$1C, -8, 2, 2, $10, 0, 0, 0, 0
	spritePiece	-$C, -8, 2, 2, $2E, 0, 0, 0, 0
	spritePiece	$14, -8, 2, 2, $1C, 0, 0, 0, 0
	spritePiece	$24, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	$2C, -8, 2, 2, $26, 0, 0, 0, 0
	spritePiece	$3C, -8, 2, 2, $26, 0, 0, 0, 0
M_Card_GHZ_End
	even

M_Card_LZ:	spriteHeader		; LABYRINTH
	spritePiece	-$44, -8, 2, 2, $26, 0, 0, 0, 0
	spritePiece	-$34, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$24, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$14, -8, 2, 2, $4A, 0, 0, 0, 0
	spritePiece	-4, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	$14, -8, 2, 2, $2E, 0, 0, 0, 0
	spritePiece	$24, -8, 2, 2, $42, 0, 0, 0, 0
	spritePiece	$34, -8, 2, 2, $1C, 0, 0, 0, 0
M_Card_LZ_End
	even

M_Card_MZ:	spriteHeader		; MARBLE
	spritePiece	-$31, -8, 2, 2, $2A, 0, 0, 0, 0
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	 0, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	 $10, -8, 2, 2, $26, 0, 0, 0, 0
	spritePiece	 $20, -8, 2, 2, $10, 0, 0, 0, 0
M_Card_MZ_End
	even

M_Card_SLZ:	spriteHeader		; STAR LIGHT
	spritePiece	-$4C, -8, 2, 2, $3E, 0, 0, 0, 0
	spritePiece	-$3C, -8, 2, 2, $42, 0, 0, 0, 0
	spritePiece	-$2C, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$1C, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	4, -8, 2, 2, $26, 0, 0, 0, 0
	spritePiece	$14, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	$1C, -8, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$2C, -8, 2, 2, $1C, 0, 0, 0, 0
	spritePiece	$3C, -8, 2, 2, $42, 0, 0, 0, 0
M_Card_SLZ_End
	even

M_Card_SYZ:	spriteHeader		; SPRING YARD
	spritePiece	-$54, -8, 2, 2, $3E, 0, 0, 0, 0
	spritePiece	-$44, -8, 2, 2, $36, 0, 0, 0, 0
	spritePiece	-$34, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	-$24, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-$1C, -8, 2, 2, $2E, 0, 0, 0, 0
	spritePiece	-$C, -8, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$14, -8, 2, 2, $4A, 0, 0, 0, 0
	spritePiece	$24, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$34, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	$44, -8, 2, 2, $C, 0, 0, 0, 0
M_Card_SYZ_End
	even

M_Card_SBZ:	spriteHeader		; SCRAP BRAIN
	spritePiece	-$54, -8, 2, 2, $3E, 0, 0, 0, 0
	spritePiece	-$44, -8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$34, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	-$24, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -8, 2, 2, $36, 0, 0, 0, 0
	spritePiece	$C, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	$1C, -8, 2, 2, $3A, 0, 0, 0, 0
	spritePiece	$2C, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$3C, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	$44, -8, 2, 2, $2E, 0, 0, 0, 0
M_Card_SBZ_End
	even

M_Card_Zone:	spriteHeader		; ZONE
	spritePiece	-$20, -8, 2, 2, $4E, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $32, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, $2E, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $10, 0, 0, 0, 0
M_Card_Zone_End
	even

M_Card_Act1:	spriteHeader		; ACT 1
	spritePiece	-$14, 4, 4, 1, $53, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $57, 0, 0, 0, 0
M_Card_Act1_End

M_Card_Act2:	spriteHeader		; ACT 2
	spritePiece	-$14, 4, 4, 1, $53, 0, 0, 0, 0
	spritePiece	8, -$C, 2, 3, $5A, 0, 0, 0, 0
M_Card_Act2_End

M_Card_Act3:	spriteHeader		; ACT 3
	spritePiece	-$14, 4, 4, 1, $53, 0, 0, 0, 0
	spritePiece	8, -$C, 2, 3, $60, 0, 0, 0, 0
M_Card_Act3_End

M_Card_Oval:	spriteHeader		; Oval
	spritePiece	-$C, -$1C, 4, 1, $70, 0, 0, 0, 0
	spritePiece	$14, -$1C, 1, 3, $74, 0, 0, 0, 0
	spritePiece	-$14, -$14, 2, 1, $77, 0, 0, 0, 0
	spritePiece	-$1C, -$C, 2, 2, $79, 0, 0, 0, 0
	spritePiece	-$14, $14, 4, 1, $70, 1, 1, 0, 0
	spritePiece	-$1C, 4, 1, 3, $74, 1, 1, 0, 0
	spritePiece	4, $C, 2, 1, $77, 1, 1, 0, 0
	spritePiece	$C, -4, 2, 2, $79, 1, 01, 0, 0
	spritePiece	-4, -$14, 3, 1, $7D, 0, 0, 0, 0
	spritePiece	-$C, -$C, 4, 1, $7C, 0, 0, 0, 0
	spritePiece	-$C, -4, 3, 1, $7C, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 1, $7C, 0, 0, 0, 0
	spritePiece	-$14, $C, 3, 1, $7C, 0, 0, 0, 0
M_Card_Oval_End
	even

M_Card_FZ:	spriteHeader		; FINAL
	spritePiece	-$24, -8, 2, 2, $14, 0, 0, 0, 0
	spritePiece	-$14, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-$C, -8, 2, 2, $2E, 0, 0, 0, 0
	spritePiece	4, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$14, -8, 2, 2, $26, 0, 0, 0, 0
M_Card_FZ_End
	even

Map_Over:	include	"_maps/Game Over.asm"

; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------
Map_Got:	mappingsTable
	mappingsTableEntry.w	M_Got_SonicHas
	mappingsTableEntry.w	M_Got_Passed
	mappingsTableEntry.w	M_Got_Score
	mappingsTableEntry.w	M_Got_TBonus
	mappingsTableEntry.w	M_Got_RBonus
	mappingsTableEntry.w	M_Card_Oval
	mappingsTableEntry.w	M_Card_Act1
	mappingsTableEntry.w	M_Card_Act2
	mappingsTableEntry.w	M_Card_Act3

M_Got_SonicHas:	spriteHeader		; SONIC HAS
	spritePiece	-$48, -8, 2, 2, $3E, 0, 0, 0, 0
	spritePiece	-$38, -8, 2, 2, $32, 0, 0, 0, 0
	spritePiece	-$28, -8, 2, 2, $2E, 0, 0, 0, 0
	spritePiece	-$18, -8, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $1C, 0, 0, 0, 0
	spritePiece	$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$30, -8, 2, 2, $3E, 0, 0, 0, 0
M_Got_SonicHas_End

M_Got_Passed:	spriteHeader		; PASSED
	spritePiece	-$30, -8, 2, 2, $36, 0, 0, 0, 0
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $3E, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, $3E, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $10, 0, 0, 0, 0
	spritePiece	$20, -8, 2, 2, $C, 0, 0, 0, 0
M_Got_Passed_End

M_Got_Score:	spriteHeader		; SCORE
	spritePiece	-$50, -8, 4, 2, $14A, 0, 0, 0, 0
	spritePiece	-$30, -8, 1, 2, $162, 0, 0, 0, 0
	spritePiece	$18, -8, 3, 2, $164, 0, 0, 0, 0
	spritePiece	$30, -8, 4, 2, $16A, 0, 0, 0, 0
	spritePiece	-$33, -9, 2, 1, $6E, 0, 0, 0, 0
	spritePiece	-$33, -1, 2, 1, $6E, 1, 1, 0, 0
M_Got_Score_End

M_Got_TBonus:	spriteHeader		; TIME BONUS
	spritePiece	-$50, -8, 4, 2, $15A, 0, 0, 0, 0
	spritePiece	-$27, -8, 4, 2, $66, 0, 0, 0, 0
	spritePiece	-7, -8, 1, 2, $14A, 0, 0, 0, 0
	spritePiece	-$A, -9, 2, 1, $6E, 0, 0, 0, 0
	spritePiece	-$A, -1, 2, 1, $6E, 1, 1, 0, 0
	spritePiece	$28, -8, 4, 2, -$10, 0, 0, 0, 0
	spritePiece	$48, -8, 1, 2, $170, 0, 0, 0, 0
M_Got_TBonus_End

M_Got_RBonus:	spriteHeader		; RING BONUS
	spritePiece	-$50, -8, 4, 2, $152, 0, 0, 0, 0
	spritePiece	-$27, -8, 4, 2, $66, 0, 0, 0, 0
	spritePiece	-7, -8, 1, 2, $14A, 0, 0, 0, 0
	spritePiece	-$A, -9, 2, 1, $6E, 0, 0, 0, 0
	spritePiece	-$A, -1, 2, 1, $6E, 1, 1, 0, 0
	spritePiece	$28, -8, 4, 2, -8, 0, 0, 0, 0
	spritePiece	$48, -8, 1, 2, $170, 0, 0, 0, 0
M_Got_RBonus_End
	even

		include	"_incObj/36 Spikes.asm"
Map_Spike:	include	"_maps/Spikes.asm"
		include	"_incObj/3B Purple Rock.asm"
		include	"_incObj/49 Waterfall Sound.asm"
Map_PRock:	include	"_maps/Purple Rock.asm"
		include	"_incObj/3C Smashable Wall.asm"

		include	"_incObj/sub SmashObject.asm"

; ===========================================================================
; Smashed block	fragment speeds
;
Smash_FragSpd1:	dc.w $400, -$500	; x-move speed,	y-move speed
		dc.w $600, -$100
		dc.w $600, $100
		dc.w $400, $500
		dc.w $600, -$600
		dc.w $800, -$200
		dc.w $800, $200
		dc.w $600, $600

Smash_FragSpd2:	dc.w -$600, -$600
		dc.w -$800, -$200
		dc.w -$800, $200
		dc.w -$600, $600
		dc.w -$400, -$500
		dc.w -$600, -$100
		dc.w -$600, $100
		dc.w -$400, $500

Map_Smash:	include	"_maps/Smashable Walls.asm"

; ---------------------------------------------------------------------------
; Object code execution subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ExecuteObjects:
		lea	(v_objspace).w,a0 ; set address for object RAM
		moveq	#(v_objspace_end-v_objspace)/object_size-1,d7
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	loc_D362

loc_D348:
		move.l	obID(a0),d0		; load object number from RAM
		beq.s	loc_D358
		movea.l	d0,a1
		jsr	(a1)		; run the object's code

loc_D358:
		lea	object_size(a0),a0	; next object
		dbf	d7,loc_D348
		rts
; ===========================================================================

loc_D362:
		moveq	#(v_lvlobjspace-v_objspace)/object_size-1,d7
		bsr.s	loc_D348
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d7

loc_D368:
		move.l	obID(a0),d0
		beq.s	loc_D378
		tst.b	obRender(a0)
		bpl.s	loc_D378
		bsr.w	DisplaySprite

loc_D378:
		lea	object_size(a0),a0
		dbf	d7,loc_D368
		rts
; End of function ExecuteObjects

; ===========================================================================
; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
Obj_Index:
		include	"_inc/Object Pointers.asm"

		include	"_incObj/sub ObjectFall.asm"
		include	"_incObj/sub SpeedToPos.asm"
		include	"_incObj/sub DisplaySprite.asm"
		include	"_incObj/sub DeleteObject.asm"
Map_HUD:	include	"_maps/HUD.asm"
		include	"_incObj/sub BuildHUD.asm"

; ---------------------------------------------------------------------------
; Subroutine to	convert	mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSprites:
		moveq	#$50-1,d7
		moveq	#0,d6
		lea	(v_spritetablebuffer).w,a6 ; set address for sprite table
		lea	(v_screenposx).w,a3
		lea	(v_spritequeue).w,a5
		tst.b	(f_hud).w
		beq.s	BuildPriorityLoop
		bsr.w	BuildHUD
		bsr.w	BuildRings

BuildPriorityLoop:
		tst.w	(a5)	; are there objects left to draw?
		beq.w	BuildNextPriority	; if not, branch
		lea	2(a5),a4

BuildObjectLoop:
		movea.w	(a4)+,a0	; load object ID
		andi.b	#$7F,obRender(a0)
		move.b	obRender(a0),d6
		move.w	obX(a0),d0
		move.w	obY(a0),d1
		btst	#6,d6		; is the multi-draw flag set?
		bne.w	Build_1AE58	; if it is, branch
		btst	#2,d6		; get drawing coordinates
		beq.s	BuildDrawScreenY	; branch if 0 (screen coordinates)
		moveq	#0,d2
		move.b	obActWid(a0),d2
		sub.w	(a3),d0
		move.w	d0,d3
		add.w	d2,d3
		bmi.s	BuildSprites_NextObj	; left edge out of bounds
		move.w	d0,d3
		sub.w	d2,d3
		cmpi.w	#320,d3
		bge.s	BuildSprites_NextObj	; right edge out of bounds
		addi.w	#128,d0		; VDP sprites start at 128px
		sub.w	4(a3),d1
		btst	#4,d6
		beq.s	BuildAssumeHeight
		move.b	obHeight(a0),d2
		add.w	d2,d1
		move.w	d2,d3
		add.w	d2,d2
		addi.w	#224,d2
		cmp.w	d2,d1
		bhs.s	BuildSprites_NextObj
		addi.w	#128,d1		; VDP sprites start at 128px
		sub.w	d3,d1
		bra.s	BuildDrawObject

BuildDrawScreenY:
		move.w	obScreenY(a0),d1
		bra.s	BuildDrawObject

BuildAssumeHeight:
		addi.w	#128,d1
		cmpi.w	#-32+128,d1
		blo.s	BuildSprites_NextObj
		cmpi.w	#32+128+224,d1
		bhs.s	BuildSprites_NextObj

BuildDrawObject:
		ori.b	#$80,obRender(a0)		; set object as visible
		tst.w	d7
		bmi.s	BuildSprites_NextObj
		movea.l	obMap(a0),a1
		moveq	#0,d4
		btst	#5,d6		; is static mappings flag on?
		bne.s	BuildDrawFrame	; if yes, branch
		move.b	obFrame(a0),d4
		add.w	d4,d4
		adda.w	(a1,d4.w),a1	; get mappings frame address
		move.w	(a1)+,d4	; number of sprite pieces
		subq.w	#1,d4
		bmi.s	BuildSprites_NextObj

BuildDrawFrame:
		move.w	obGfx(a0),d5
		bsr.w	BuildSpr_Draw	; write data from sprite pieces to buffer

BuildSprites_NextObj:
		subq.w	#2,(a5)		; number of objects left
		bne.w	BuildObjectLoop

BuildNextPriority:
		lea	$80(a5),a5
		cmpa.w	#v_spritequeue_end,a5
		blo.w	BuildPriorityLoop
		move.w	d7,d6
		bmi.s	loc_1AE18
		moveq	#0,d0

loc_1AE10:
		move.w	d0,(a6)
		addq.w	#8,a6
		dbf	d7,loc_1AE10

loc_1AE18:
		subi.w	#$50-1,d6
		neg.w	d6
		move.b	d6,(v_spritecount).w
		rts
; End of function BuildSprites

; ---------------------------------------------------------------------------

Build_1AE58:
		moveq	#0,d2
		move.b	mainspr_width(a0),d2
		sub.w	(a3),d0
		move.w	d0,d3
		add.w	d2,d3
		bmi.s	BuildSprites_NextObj
		move.w	d0,d3
		sub.w	d2,d3
		cmpi.w	#320,d3
		bge.s	BuildSprites_NextObj
		addi.w	#128,d0
		btst	#4,d6
		beq.s	.assumeheight
		sub.w	4(a3),d1
		move.b	mainspr_height(a0),d2
		add.w	d2,d1
		move.w	d2,d3
		add.w	d2,d2
		addi.w	#224,d2
		cmp.w	d2,d1
		bhs.s	BuildSprites_NextObj
		addi.w	#128,d1
		sub.w	d3,d1
		bra.s	Build_1AEE4

	.assumeheight:
		sub.w	4(a3),d1
		addi.w  #128,d1
		cmpi.w	#-32+128,d1
		blo.s	BuildSprites_NextObj
		cmpi.w	#32+128+224,d1
		bhs.s	BuildSprites_NextObj

Build_1AEE4:
		ori.b	#$80,obRender(a0)
		tst.w	d7
		bmi.w	BuildSprites_NextObj
		move.w	obGfx(a0),d5
		movea.l	obMap(a0),a2
		moveq	#0,d4
		move.b	mainspr_mapframe(a0),d4
		beq.s	Build_1AF1C
		add.w	d4,d4
		lea	(a2),a1
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	Build_1AF1C
		move.w	d6,d3
		bsr.w	sub_1B070
		move.w	d3,d6
		tst.w	d7
		bmi.w	BuildSprites_NextObj

Build_1AF1C:
		move.w	mainspr_childsprites(a0),d3
		subq.w	#1,d3
		bcs.w	BuildSprites_NextObj
		lea	sub2_x_pos(a0),a0

Build_1AF2A:
		move.w	(a0)+,d0
		move.w	(a0)+,d1
		btst	#2,d6
		beq.s	Build_1AF46
		sub.w	(a3),d0
		addi.w	#128,d0
		sub.w	4(a3),d1
		addi.w	#128,d1

Build_1AF46:
		addq.w	#1,a0
		moveq	#0,d4
		move.b	(a0)+,d4
		add.w	d4,d4
		lea	(a2),a1
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	Build_1AF62
		move.w	d6,-(sp)
		bsr.w	sub_1B070
		move.w	(sp)+,d6

Build_1AF62:
		tst.w	d7
		dbmi	d3,Build_1AF2A
		bra.w	BuildSprites_NextObj

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSpr_Draw:
		lsr.b	#1,d6
		bcs.s	BuildSpr_FlipX
		lsr.b	#1,d6
		bcs.w	BuildSpr_FlipY
; End of function BuildSpr_Draw


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSpr_Normal:
		move.b	(a1)+,d2	; get y-offset
		ext.w	d2
		add.w	d1,d2		; add y-position
		move.w	d2,(a6)+	; write to buffer
		move.b	(a1)+,(a6)+	; write sprite size
		addq.w	#1,a6		; increase sprite counter
		move.w	(a1)+,d2	; get art tile
		add.w	d5,d2		; add art tile offset
		move.w	d2,(a6)+	; write to buffer
		move.w	(a1)+,d2	; get x-offset
		add.w	d0,d2		; add x-position
		andi.w	#$1FF,d2	; keep within 512px
		bne.s	.writeX
		addq.w	#1,d2

	.writeX:
		move.w	d2,(a6)+	; write to buffer
		subq.w	#1,d7
		dbmi	d4,BuildSpr_Normal	; process next sprite piece
		rts
; End of function BuildSpr_Normal

; ===========================================================================

BuildSpr_FlipX:
		lsr.b	#1,d6		; is object also y-flipped?
		bcs.s	BuildSpr_FlipXY	; if yes, branch

	.loop:
		move.b	(a1)+,d2	; y position
		ext.w	d2
		add.w	d1,d2
		move.w	d2,(a6)+
		move.b	(a1)+,d6	; size
		move.b	d6,(a6)+
		addq.w	#1,a6		; link
		move.w	(a1)+,d2	; art tile
		add.w	d5,d2
		eori.w	#$800,d2	; toggle flip-x in VDP
		move.w	d2,(a6)+	; write to buffer
		move.w	(a1)+,d2	; get x-offset
		neg.w	d2		; negate it
		move.b	byte_D238(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		andi.w	#$1FF,d2	; keep within 512px
		bne.s	.writeX
		addq.w	#1,d2

	.writeX:
		move.w	d2,(a6)+	; write to buffer
		subq.w	#1,d7
		dbmi	d4,.loop		; process next sprite piece
		rts
; ---------------------------------------------------------------------------
byte_D238:	dc.b   8,  8,  8,  8
		dc.b $10,$10,$10,$10
		dc.b $18,$18,$18,$18
		dc.b $20,$20,$20,$20
; ===========================================================================

BuildSpr_FlipXY:
		move.b	(a1)+,d2	; get y-offset
		ext.w	d2
		neg.w	d2		; negate y-offset
		move.b	(a1),d6		; get size
		move.b	byte_D290(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2	; add y-position
		move.w	d2,(a6)+	; write to buffer
		move.b	(a1)+,d6	; size
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2	; art tile
		add.w	d5,d2
		eori.w	#$1800,d2	; toggle flip-y in VDP
		move.w	d2,(a6)+
		move.w	(a1)+,d2	; x-position
		neg.w	d2
		move.b	byte_D238(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		andi.w	#$1FF,d2
		bne.s	.writeX
		addq.w	#1,d2

	.writeX:
		move.w	d2,(a6)+	; write to buffer
		subq.w	#1,d7
		dbmi	d4,BuildSpr_FlipXY	; process next sprite piece
		rts
; ---------------------------------------------------------------------------
byte_D290:	dc.b   8,$10,$18,$20
		dc.b   8,$10,$18,$20
		dc.b   8,$10,$18,$20
		dc.b   8,$10,$18,$20
; ===========================================================================

BuildSpr_FlipY:
		move.b	(a1)+,d2	; calculated flipped y
		ext.w	d2
		neg.w	d2
		move.b	(a1)+,d6
		move.b	d6,2(a6)
		move.b	byte_D290(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		move.w	d2,(a6)+	; write to buffer
		addq.w	#2,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1000,d2	; toggle flip-y in VDP
		move.w	d2,(a6)+
		move.w	(a1)+,d2	; calculate flipped x
		add.w	d0,d2
		andi.w	#$1FF,d2
		bne.s	.writeX
		addq.w	#1,d2

	.writeX:
		move.w	d2,(a6)+	; write to buffer
		subq.w	#1,d7
		dbmi	d4,BuildSpr_FlipY	; process next sprite piece
		rts

; =============== S U B R O U T I N E =======================================


sub_1B070:
		lsr.b	#1,d6
		bcs.s	Build_1B0C2
		lsr.b	#1,d6
		bcs.w	Build_1B19C

Build_1B07A:
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B0BA
		cmpi.w	#$160,d2
		bhs.s	Build_1B0BA
		move.w	d2,(a6)+
		move.b	(a1)+,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B0B2
		cmpi.w	#$1C0,d2
		bhs.s	Build_1B0B2
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,Build_1B07A
		rts
; ---------------------------------------------------------------------------

Build_1B0B2:
		subq.w	#6,a6
		dbf	d4,Build_1B07A
		rts
; ---------------------------------------------------------------------------

Build_1B0BA:
		addq.w	#5,a1
		dbf	d4,Build_1B07A
		rts
; ---------------------------------------------------------------------------

Build_1B0C2:
		lsr.b	#1,d6
		bcs.s	Build_1B12C

Build_1B0C6:
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B114
		cmpi.w	#$160,d2
		bhs.s	Build_1B114
		move.w	d2,(a6)+
		move.b	(a1)+,d6
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$800,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		neg.w	d2
		move.b	byte_1B11C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B10C
		cmpi.w	#$1C0,d2
		bhs.s	Build_1B10C
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,Build_1B0C6
		rts
; ---------------------------------------------------------------------------

Build_1B10C:
		subq.w	#6,a6
		dbf	d4,Build_1B0C6
		rts
; ---------------------------------------------------------------------------

Build_1B114:
		addq.w	#5,a1
		dbf	d4,Build_1B0C6
		rts
; ---------------------------------------------------------------------------
byte_1B11C:	dc.b   8,  8,  8,  8
		dc.b $10,$10,$10,$10
		dc.b $18,$18,$18,$18
		dc.b $20,$20,$20,$20
; ---------------------------------------------------------------------------

Build_1B12C:
		move.b	(a1)+,d2
		ext.w	d2
		neg.w	d2
		move.b	(a1),d6
		move.b	byte_1B18C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B184
		cmpi.w	#$160,d2
		bhs.s	Build_1B184
		move.w	d2,(a6)+
		move.b	(a1)+,d6
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1800,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		neg.w	d2
		move.b	byte_1B11C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B17C
		cmpi.w	#$1C0,d2
		bhs.s	Build_1B17C
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,Build_1B12C
		rts
; ---------------------------------------------------------------------------

Build_1B17C:
		subq.w	#6,a6
		dbf	d4,Build_1B12C
		rts
; ---------------------------------------------------------------------------

Build_1B184:
		addq.w	#5,a1
		dbf	d4,Build_1B12C
		rts
; ---------------------------------------------------------------------------
byte_1B18C:	dc.b   8,$10,$18,$20
		dc.b   8,$10,$18,$20
		dc.b   8,$10,$18,$20
		dc.b   8,$10,$18,$20
; ---------------------------------------------------------------------------

Build_1B19C:
		move.b	(a1)+,d2
		ext.w	d2
		neg.w	d2
		move.b	(a1)+,d6
		move.b	d6,2(a6)
		move.b	byte_1B18C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B1EC
		cmpi.w	#$160,d2
		bhs.s	Build_1B1EC
		move.w	d2,(a6)+
		addq.w	#2,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1000,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	Build_1B1E4
		cmpi.w	#$1C0,d2
		bhs.s	Build_1B1E4
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,Build_1B19C
		rts
; ---------------------------------------------------------------------------

Build_1B1E4:
		subq.w	#6,a6
		dbf	d4,Build_1B19C
		rts
; ---------------------------------------------------------------------------

Build_1B1EC:
		addq.w	#4,a1
		dbf	d4,Build_1B19C
		rts
; End of function sub_1B070

		include	"_incObj/sub ChkObjectVisible.asm"
		include	"_inc/Rings Manager.asm"
		include	"_inc/Object Manager.asm"

		include	"_incObj/sub FindFreeObj.asm"
		include	"_incObj/41 Springs.asm"
		include	"_anim/Springs.asm"
Map_Spring:	include	"_maps/Springs.asm"

		include	"_incObj/42 Newtron.asm"
		include	"_anim/Newtron.asm"
Map_Newt:	include	"_maps/Newtron.asm"

		include	"_incObj/44 GHZ Edge Walls.asm"
Map_Edge:	include	"_maps/GHZ Edge Walls.asm"

		include	"_incObj/0D Signpost.asm" ; includes "GotThroughAct" subroutine
		include	"_anim/Signpost.asm"
Map_Sign:	include	"_maps/Signpost.asm"

		include	"_incObj/40 Moto Bug.asm" ; includes "_incObj/sub RememberState.asm"
		include	"_anim/Moto Bug.asm"
Map_Moto:	include	"_maps/Moto Bug.asm"

		include	"_incObj/sub SolidObject.asm"

		include	"_incObj/71 Invisible Barriers.asm"
Map_Invis:	include	"_maps/Invisible Barriers.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 01 - Sonic
; ---------------------------------------------------------------------------

SonicPlayer:
	if DebuggingMode
		tst.w	(v_debuguse).w	; is debug mode	being used?
		beq.s	Sonic_Normal	; if not, branch
		jmp	(DebugMode).l
	endif
; ===========================================================================

Sonic_Normal:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d1
		jmp	Sonic_Index(pc,d1.w)
; ===========================================================================
Sonic_Index:	dc.w Sonic_Main-Sonic_Index
		dc.w Sonic_Control-Sonic_Index
		dc.w Sonic_Hurt-Sonic_Index
		dc.w Sonic_Death-Sonic_Index
		dc.w Sonic_ResetLevel-Sonic_Index
; ===========================================================================

Sonic_Main:	; Routine 0
		move.b	#$C,(v_top_solid_bit).w	; MJ: set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w	; MJ: set collision to 2nd
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),obGfx(a0)
		move.w	#2*$80,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obRender(a0)
		move.w	#$600,(v_sonspeedmax).w ; Sonic's top speed
		move.w	#$C,(v_sonspeedacc).w ; Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; Sonic's deceleration

Sonic_Control:	; Routine 2
	if DebuggingMode
		tst.b	(f_debugmode).w	; is debug cheat enabled?
		beq.s	loc_12C58	; if not, branch
		btst	#bitB,(v_jpadpress).w ; is button B pressed?
		beq.s	loc_12C58	; if not, branch
		move.w	#1,(v_debuguse).w ; change Sonic into a ring/item
		clr.b	(f_lockctrl).w
		rts
	endif
; ===========================================================================

loc_12C58:
		tst.b	(f_lockctrl).w	; are controls locked?
		bne.s	loc_12C64	; if yes, branch
		move.w	(v_jpadhold).w,(v_jpadhold_stored).w ; enable joypad control

loc_12C64:
		tst.b	(f_playerctrl).w ; are controls locked?
		bmi.s	loc_12C7E	; if yes, branch
		moveq	#6,d0
		and.b	obStatus(a0),d0
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)

loc_12C7E:
		bsr.s	Sonic_Display
		bsr.w	Sonic_RecordPosition
		move.w	(v_anglebuffer).w,objoff_36(a0)
		tst.b	obAnim(a0)
		bne.s	loc_12CA6
		move.b	obPrevAni(a0),obAnim(a0)

loc_12CA6:
		bsr.w	Sonic_Animate
		tst.b	(f_playerctrl).w
		bmi.s	loc_12CB6
		jsr	(ReactToItem).l

loc_12CB6:
		bsr.w	Sonic_Loops
		bra.w	Sonic_LoadGfx
; ===========================================================================
Sonic_Modes:	dc.w Sonic_MdNormal-Sonic_Modes
		dc.w Sonic_MdJump-Sonic_Modes
		dc.w Sonic_MdRoll-Sonic_Modes
		dc.w Sonic_MdJump-Sonic_Modes

		include	"_incObj/Sonic Display.asm"
		include	"_incObj/Sonic RecordPosition.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Modes	for controlling	Sonic
; ---------------------------------------------------------------------------

Sonic_MdNormal:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		jsr	(SpeedToPos).l
		bsr.w	Sonic_AnglePos
		bra.w	Sonic_SlopeRepel
; ===========================================================================

Sonic_MdJump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	(ObjectFall).l
		bsr.w	Sonic_JumpAngle
		bra.w	Sonic_Floor
; ===========================================================================

Sonic_MdRoll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		jsr	(SpeedToPos).l
		bsr.w	Sonic_AnglePos
		bra.w	Sonic_SlopeRepel

		include	"_incObj/Sonic Move.asm"
		include	"_incObj/Sonic RollSpeed.asm"
		include	"_incObj/Sonic JumpDirection.asm"
		include	"_incObj/Sonic LevelBound.asm"
		include	"_incObj/Sonic Roll.asm"
		include	"_incObj/Sonic Jump.asm"
		include	"_incObj/Sonic JumpHeight.asm"
		include	"_incObj/Sonic SlopeResist.asm"
		include	"_incObj/Sonic RollRepel.asm"
		include	"_incObj/Sonic SlopeRepel.asm"
		include	"_incObj/Sonic JumpAngle.asm"
		include	"_incObj/Sonic Floor.asm"
		include	"_incObj/Sonic ResetOnFloor.asm"
		include	"_incObj/Sonic (part 2).asm"
		include	"_incObj/Sonic Loops.asm"
		include	"_incObj/Sonic Animate.asm"
		include	"_anim/Sonic.asm"
		include	"_incObj/Sonic LoadGfx.asm"
SonicDynPLC:	include	"_maps/Blaze - Dynamic Gfx Script.asm"

		include	"_incObj/38 Shield and Invincibility.asm"
		include	"_incObj/03 Collision Switcher.asm"
		include	"_anim/Shield and Invincibility.asm"
Map_Shield:	include	"_maps/Shield and Invincibility.asm"

		include	"_incObj/Sonic AnglePos.asm"

		include	"_incObj/sub FindNearestTile.asm"
		include	"_incObj/sub FindFloor.asm"
		include	"_incObj/sub FindWall.asm"

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkSpeed:
		move.l	(v_colladdr1).w,(v_collindex).w		; MJ: load first collision data location
		cmpi.b	#$C,(v_top_solid_bit).w		; MJ: is second collision set to be used?
		beq.s	.first				; MJ: if not, branch
		move.l	(v_colladdr2).w,(v_collindex).w		; MJ: load second collision data location
.first:
		move.b	(v_lrb_solid_bit).w,d5		; MJ: load L/R/B soldity bit
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.w	d0,(v_anglebuffer).w
		move.b	d0,d1
		addi.b	#$20,d0
		bpl.s	loc_14D1A
		move.b	d1,d0
		bpl.s	loc_14D14
		subq.b	#1,d0

loc_14D14:
		addi.b	#$20,d0
		bra.s	loc_14D24
; ===========================================================================

loc_14D1A:
		move.b	d1,d0
		bpl.s	loc_14D20
		addq.b	#1,d0

loc_14D20:
		addi.b	#$1F,d0

loc_14D24:
		andi.b	#$C0,d0
		beq.w	loc_14DF0
		cmpi.b	#$80,d0
		beq.w	loc_14F7C
		andi.b	#$38,d1
		bne.s	loc_14D3C
		addq.w	#8,d2
		btst	#2,obStatus(a0)	; Is Sonic rolling?
		beq.s	loc_14D3C	; If not, branch
		subq.w	#5,d2		; If so, move push sensor up a bit

loc_14D3C:
		cmpi.b	#$40,d0
		beq.w	loc_1504A
		bra.w	loc_14EBC

; End of function Sonic_WalkSpeed


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14D48:
		move.l	(v_colladdr1).w,(v_collindex).w		; MJ: load first collision data location
		cmpi.b	#$C,(v_top_solid_bit).w		; MJ: is second collision set to be used?
		beq.s	.first				; MJ: if not, branch
		move.l	(v_colladdr2).w,(v_collindex).w		; MJ: load second collision data location
.first:
		move.b	(v_lrb_solid_bit).w,d5		; MJ: load L/R/B soldity bit
		move.w	d0,(v_anglebuffer).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_14FD6
		cmpi.b	#$80,d0
		beq.w	Sonic_DontRunOnWalls
		cmpi.b	#$C0,d0
		beq.w	sub_14E50

; End of function sub_14D48

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic land	on the floor after jumping
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HitFloor:
		move.l	(v_colladdr1).w,(v_collindex).w		; MJ: load first collision data location
		cmpi.b	#$C,(v_top_solid_bit).w		; MJ: is second collision set to be used?
		beq.s	.first				; MJ: if not, branch
		move.l	(v_colladdr2).w,(v_collindex).w		; MJ: load second collision data location
.first:
		move.b	(v_top_solid_bit).w,d5		; MJ: load L/R/B soldity bit
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#0,d2

loc_14DD0:
		move.b	(v_anglebuffer2).w,d3
		cmp.w	d0,d1
		ble.s	loc_14DDE
		move.b	(v_anglebuffer).w,d3
		exg	d0,d1

loc_14DDE:
		btst	#0,d3
		beq.s	locret_14DE6
		move.b	d2,d3

locret_14DE6:
		rts

; End of function Sonic_HitFloor

; ===========================================================================

loc_14DF0:
		addi.w	#$A,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.b	#0,d2

loc_14E0A:
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14E16
		move.b	d2,d3

locret_14E16:
		rts

		include	"_incObj/sub ObjFloorDist.asm"


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14E50:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#-$40,d2
		bra.w	loc_14DD0

; End of function sub_14E50


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14EB4:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_14EBC:
		addi.w	#$A,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	loc_14E0A

; End of function sub_14EB4

; ---------------------------------------------------------------------------
; Subroutine to	detect when an object hits a wall to its right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitWallRight:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5		; MJ: set solid type to check
		bsr.w	FindWall	; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14F06
		move.b	#-$40,d3

locret_14F06:
		rts

; End of function ObjHitWallRight

; ---------------------------------------------------------------------------
; Subroutine preventing	Sonic from running on walls and	ceilings when he
; touches them
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_DontRunOnWalls:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.w	(sp)+,d0
		move.b	#-$80,d2
		bra.w	loc_14DD0
; End of function Sonic_DontRunOnWalls

; ===========================================================================

loc_14F7C:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.b	#-$80,d2
		bra.w	loc_14E0A

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		moveq	#$D,d5		; MJ: set solid type to check
		bsr.w	FindFloor	; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14FD4
		move.b	#-$80,d3

locret_14FD4:
		rts
; End of function ObjHitCeiling

; ===========================================================================

loc_14FD6:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_14DD0

; ---------------------------------------------------------------------------
; Subroutine to	stop Sonic when	he jumps at a wall
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HitWall:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_1504A:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.b	#$40,d2
		bra.w	loc_14E0A
; End of function Sonic_HitWall

; ---------------------------------------------------------------------------
; Subroutine to	detect when an object hits a wall to its left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitWallLeft:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		moveq	#$D,d5		; MJ: set solid type to check
		bsr.w	FindWall	; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_15098
		move.b	#$40,d3

locret_15098:
		rts
; End of function ObjHitWallLeft

; ===========================================================================

		include	"_incObj/79 Lamppost.asm"
Map_Lamp:	include	"_maps/Lamppost.asm"

		include	"_incObj/8A Credits.asm"
Map_Cred:	include	"_maps/Credits.asm"

		include	"_incObj/3E Prison Capsule.asm"
		include	"_anim/Prison Capsule.asm"
Map_Pri:	include	"_maps/Prison Capsule.asm"

		include	"_incObj/sub ReactToItem.asm"

		include	"_inc/AnimateLevelGfx.asm"

; ---------------------------------------------------------------------------
; Add points subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AddPoints:
		st.b	(f_scorecount).w ; set score counter to update

		lea     (v_score).w,a3
		add.l   d0,(a3)
		move.l  #999999,d1
		cmp.l   (a3),d1 ; is score below 999999?
		bhi.s   .belowmax ; if yes, branch
		move.l  d1,(a3) ; reset score to 999999
.belowmax:
		move.l  (a3),d0
		cmp.l   (v_scorelife).w,d0 ; has Sonic got 50000+ points?
		blo.s   .noextralife ; if not, branch

		addi.l  #5000,(v_scorelife).w ; increase requirement by 50000
		tst.b   (v_megadrive).w
		bmi.s   .noextralife ; branch if Mega Drive is Japanese
		addq.b  #1,(v_lives).w ; give extra life
		addq.b  #1,(f_lifecount).w
		playsound bgm_ExtraLife,music

.noextralife:
		rts
; End of function AddPoints

		include	"_inc/HUD_Update.asm"

; ===========================================================================

		include	"_inc/HUD (part 2).asm"

Art_Hud:	binclude	"artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	binclude	"artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
		even

	if DebuggingMode
		include	"_incObj/DebugMode.asm"
		include	"_inc/DebugList.asm"
	endif
		include	"_inc/LevelHeaders.asm"
		include	"_inc/Pattern Load Cues.asm"

KosP_SegaLogo:	binclude	"artkosp/Sega Logo.kosp" ; large Sega logo
		even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo.eni" ; large Sega logo (mappings)
		even
Eni_Title:	binclude	"tilemaps/Title Screen.eni" ; title screen foreground (mappings)
		even
KosPM_TitleFg:	binclude	"artkospm/Title Screen Foreground.kospm"
		even
KosPM_TitleSonic:	binclude	"artkospm/Title Screen Sonic.kospm"
		even
KosPM_TitleTM:	binclude	"artkospm/Title Screen TM.kospm"
		even
Eni_JapNames:	binclude	"tilemaps/Hidden Japanese Credits.eni" ; Japanese credits (mappings)
		even
KosPM_JapNames:	binclude	"artkospm/Hidden Japanese Credits.kospm"
		even
;---------------------------------------------------------------------------------------
; Menu Assets
;---------------------------------------------------------------------------------------
KosPM_FontStuff:	binclude	"artkospm/Standard font.kospm"
		even
Unc_MenuBack:	binclude	"artunc/Sonic and Miles animated background.bin"
		even
KosPM_MenuBox:	binclude	"artkospm/A menu box with a shadow.kospm"
		even
KosPM_LevelSelectPics:	binclude	"artkospm/Pictures in level preview box from level select.kospm"
		even

Map_Sonic:	include	"_maps/Blaze.asm"
; ---------------------------------------------------------------------------
; Uncompressed graphics	- Blaze
; ---------------------------------------------------------------------------

	align $8000
Art_Sonic:	binclude	"artunc/Blaze.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
KosPM_Shield:	binclude	"artkospm/Shield.kospm"
		even
KosPM_Stars:	binclude	"artkospm/Invincibility Stars.kospm"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
KosPM_Stalk:	binclude	"artkospm/GHZ Flower Stalk.kospm"
		even
KosPM_Swing:	binclude	"artkospm/GHZ Swinging Platform.kospm"
		even
KosPM_Bridge:	binclude	"artkospm/GHZ Bridge.kospm"
		even
KosPM_Ball:	binclude	"artkospm/GHZ Giant Ball.kospm"
		even
KosPM_Spikes:	binclude	"artkospm/Spikes.kospm"
		even
KosPM_SpikePole:	binclude	"artkospm/GHZ Spiked Log.kospm"
		even
KosPM_PplRock:	binclude	"artkospm/GHZ Purple Rock.kospm"
		even
KosPM_GhzWall1:	binclude	"artkospm/GHZ Breakable Wall.kospm"
		even
KosPM_GhzWall2:	binclude	"artkospm/GHZ Edge Wall.kospm"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
KosPM_Crabmeat:	binclude	"artkospm/Enemy Crabmeat.kospm"
		even
KosPM_Buzz:	binclude	"artkospm/Enemy Buzz Bomber.kospm"
		even
KosPM_Chopper:	binclude	"artkospm/Enemy Chopper.kospm"
		even
KosPM_Motobug:	binclude	"artkospm/Enemy Motobug.kospm"
		even
KosPM_Newtron:	binclude	"artkospm/Enemy Newtron.kospm"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
KosPM_TitleCard:	binclude	"artkospm/Title Cards.kospm"
		even
KosPM_Hud:	binclude	"artkospm/HUD.kospm"	; HUD (rings, time, score)
		even
KosPM_Lives:	binclude	"artkospm/HUD - Life Counter Icon.kospm"
		even
KosPM_Ring:	binclude	"artkospm/Rings.kospm"
		even
KosPM_Monitors:	binclude	"artkospm/Monitors.kospm"
		even
KosPM_Explode:	binclude	"artkospm/Explosion.kospm"
		even
KosPM_Points:	binclude	"artkospm/Points.kospm"	; points from destroyed enemy or object
		even
KosPM_GameOver:	binclude	"artkospm/Game Over.kospm"	; game over / time over
		even
KosPM_HSpring:	binclude	"artkospm/Spring Horizontal.kospm"
		even
KosPM_VSpring:	binclude	"artkospm/Spring Vertical.kospm"
		even
KosPM_SignPost:	binclude	"artkospm/Signpost.kospm"	; end of level signpost
		even
KosPM_Lamp:	binclude	"artkospm/Lamppost.kospm"
		even
KosPM_BigFlash:	binclude	"artkospm/Giant Ring Flash.kospm"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
KosPM_Rabbit:	binclude	"artkospm/Animal Rabbit.kospm"
		even
KosPM_Chicken:	binclude	"artkospm/Animal Chicken.kospm"
		even
KosPM_Penguin:	binclude	"artkospm/Animal Penguin.kospm"
		even
KosPM_Seal:	binclude	"artkospm/Animal Seal.kospm"
		even
KosPM_Pig:	binclude	"artkospm/Animal Pig.kospm"
		even
KosPM_Flicky:	binclude	"artkospm/Animal Flicky.kospm"
		even
KosPM_Squirrel:	binclude	"artkospm/Animal Squirrel.kospm"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	binclude	"map16/GHZ.unc"
		even
KosP_GHZ_1st:	binclude	"artkosp/8x8 - Title.kosp"	; GHZ primary patterns
		even
KosP_GHZ_2nd:	binclude	"artkosp/8x8 - GHZ.kosp"	; GHZ secondary patterns
		even
Blk128_GHZ:	binclude	"map128/GHZ.kosp"
		even
Blk16_LZ:	binclude	"map16/LZ.unc"
		even
KosP_LZ:	binclude	"artkosp/8x8 - LZ.kosp"	; LZ primary patterns
		even
Blk128_LZ:	binclude	"map128/LZ.kosp"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - bosses
; ---------------------------------------------------------------------------
KosPM_Eggman:	binclude	"artkospm/Boss - Main.kospm"
		even
KosPM_Weapons:	binclude	"artkospm/Boss - Weapons.kospm"
		even
KosPM_Prison:	binclude	"artkospm/Prison Capsule.kospm"
		even
KosPM_Exhaust:	binclude	"artkospm/Boss - Exhaust Flame.kospm"
		even
KosPM_CreditText:	binclude	"artkospm/Ending - Credits.kospm"
		even
; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------
AngleMap:	binclude	"collide/Angle Map.bin"
		even
CollArray1:	binclude	"collide/Collision Array (Normal).bin"
		even
CollArray2:	binclude	"collide/Collision Array (Rotated).bin"
		even
Col_GHZ_1:	binclude	"collide/GHZ1.bin"	; GHZ index 1
		even
Col_GHZ_2:	binclude	"collide/GHZ2.bin"	; GHZ index 2
		even
Col_LZ_1:	binclude	"collide/LZ1.bin"	; LZ index 1
		even
Col_LZ_2:	binclude	"collide/LZ2.bin"	; LZ index 2
		even
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
	align $8000
Art_GhzWater:	binclude	"artunc/GHZ Waterfall.bin"
		even
Art_GhzFlower1:	binclude	"artunc/GHZ Flower Large.bin"
		even
Art_GhzFlower2:	binclude	"artunc/GHZ Flower Small.bin"
		even

; ---------------------------------------------------------------------------
; Level	layout index
; ---------------------------------------------------------------------------
Level_Index:	dc.l Level_GHZ1	; MJ: unused data and BG data have been stripped out
		dc.l Level_GHZ2
		dc.l Level_LZ1
		dc.l Level_LZ2

Level_Null:

Level_GHZ1:	binclude	"levels/ghz1.bin"
		even
Level_GHZ2:	binclude	"levels/ghz2.bin"
		even

Level_LZ1:	binclude	"levels/lz1.bin"
		even
Level_LZ2:	binclude	"levels/lz2.bin"
		even


Art_BigRing:	binclude	"artunc/Giant Ring.bin"
		even

; ---------------------------------------------------------------------------
; Sprite locations index
; ---------------------------------------------------------------------------
ObjPos_Index:
		; GHZ
		dc.l ObjPos_GHZ1
		dc.l ObjPos_GHZ2
		; LZ
		dc.l ObjPos_LZ1
		dc.l ObjPos_LZ2
		dc.w $FFFF, 0, 0
ObjPos_GHZ1:	binclude	"objpos/ghz1.bin"
		even
ObjPos_GHZ2:	binclude	"objpos/ghz2.bin"
		even
ObjPos_LZ1:	binclude	"objpos/lz1.bin"
		even
ObjPos_LZ2:	binclude	"objpos/lz2.bin"
		even
ObjPos_Null:	dc.w $FFFF, 0, 0

RingPos_Index:
		; GHZ
		dc.l RingPos_GHZ1
		dc.l RingPos_GHZ2
		; LZ
		dc.l RingPos_LZ1
		dc.l RingPos_LZ2

RingPos_Null:	dc.w $FFFF, 0

RingPos_GHZ1:	binclude	"ringpos/ghz1_INDIVIDUAL.bin"
		even
RingPos_GHZ2:	binclude	"ringpos/ghz2_INDIVIDUAL.bin"
		even
RingPos_LZ1:	binclude	"ringpos/lz1_INDIVIDUAL.bin"
		even
RingPos_LZ2:	binclude	"ringpos/lz2_INDIVIDUAL.bin"
		even

		include "sound/Sonic-2-Clone-Driver-v2/engine/Sonic 2 Clone Driver v2.asm"
; ==============================================================
; --------------------------------------------------------------
; Debugging modules
; --------------------------------------------------------------

		even
		include	"errorhandler/ErrorHandler.asm"

; --------------------------------------------------------------
; WARNING!
;	DO NOT put any data from now on! DO NOT use ROM padding!
;	Symbol data should be appended here after ROM is compiled
;	by ConvSym utility, otherwise debugger modules won't be able
;	to resolve symbol names.
; --------------------------------------------------------------

; end of 'ROM'
EndOfRom:

		END
