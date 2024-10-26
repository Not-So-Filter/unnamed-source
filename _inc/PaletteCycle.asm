; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
		moveq	#0,d2
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#6,d0
		movea.w	PalCycle_Index(pc,d0.w),a0
		jmp	(a0) ; jump to relevant palette routine
; End of function PaletteCycle

; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routines
; ---------------------------------------------------------------------------
PalCycle_Index:
		dc.w PalCycle_GHZ	; Green Hill Zone Act 1
		dc.w PalCycle_GHZ	; Green Hill Zone Act 2
		dc.w PalCycle_LZ	; Labyrinth Zone Act 1
		dc.w PalCycle_LZ	; Labyrinth Zone Act 2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Title:
		lea	Pal_TitleCyc(pc),a0
		bra.s	PCycGHZ_Go
; ===========================================================================

PalCycle_GHZ:
		lea	Pal_GHZCyc(pc),a0

PCycGHZ_Go:
		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycGHZ_Skip	; if time remains, branch

		move.w	#5,(v_pcyc_time).w ; reset timer to 5 frames
		move.w	(v_pcyc_num).w,d0 ; get cycle number
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(v_palette+$50).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)	; copy palette data to RAM

PCycGHZ_Skip:
		rts
; End of function PalCycle_GHZ


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_LZ:
		rts
; End of function PalCycle_LZ