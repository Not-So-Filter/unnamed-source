; ---------------------------------------------------------------------------
; Object 60 - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Orbinaut:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Orb_Index(pc,d0.w),d1
		jmp	Orb_Index(pc,d1.w)
; ===========================================================================
Orb_Index:	dc.w Orb_Main-Orb_Index
		dc.w Orb_ChkSonic-Orb_Index
		dc.w Orb_Display-Orb_Index
		dc.w Orb_MoveOrb-Orb_Index
		dc.w Orb_ChkDel2-Orb_Index

orb_parent = objoff_3C		; address of parent object
; ===========================================================================

Orb_Main:	; Routine 0
		move.l	#Map_Orb,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Orbinaut,0,0),obGfx(a0)	; SBZ specific code
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		beq.s	.isscrap
		move.w	#make_art_tile(ArtTile_SLZ_Orbinaut,1,0),obGfx(a0) ; SLZ specific code

.isscrap:
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	.notlabyrinth
		move.w	#make_art_tile(ArtTile_LZ_Orbinaut,0,0),obGfx(a0)	; LZ specific code

.notlabyrinth:
		ori.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$B,obColType(a0)
		move.b	#$C,obActWid(a0)
		moveq	#0,d2
		lea	objoff_37(a0),a2
		movea.l	a2,a3
		addq.w	#1,a2
		moveq	#3,d1

.makesatellites:
		bsr.w	FindNextFreeObj
		bne.s	.fail
		addq.b	#1,(a3)
		move.w	a1,d5
		subi.w	#v_objspace,d5
	if object_size=$40
		lsr.w	#object_size_bits,d5
	else
		divu.w	#object_size,d5
	endif
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.l	#Orbinaut,obID(a1)	; load spiked orb object
		move.b	#6,obRoutine(a1) ; use Orb_MoveOrb routine
		move.l	#Map_Orb,obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		ori.b	#4,obRender(a1)
		move.w	#4*$80,obPriority(a1)
		move.b	#8,obActWid(a1)
		move.b	#3,obFrame(a1)
		move.b	#$98,obColType(a1)
		move.b	d2,obAngle(a1)
		addi.b	#$40,d2
		move.l	a0,orb_parent(a1)
		dbf	d1,.makesatellites ; repeat sequence 3 more times

.fail:
		moveq	#1,d0
		btst	#0,obStatus(a0)	; is orbinaut facing left?
		beq.s	.noflip		; if not, branch
		neg.w	d0

.noflip:
		move.b	d0,objoff_36(a0)
		move.b	obSubtype(a0),obRoutine(a0) ; if type is 02, skip Orb_ChkSonic
		addq.b	#2,obRoutine(a0)
		move.w	#-$40,obVelX(a0) ; move orbinaut to the left
		btst	#0,obStatus(a0)	; is orbinaut facing left??
		beq.s	.noflip2	; if not, branch
		neg.w	obVelX(a0)	; move orbinaut	to the right

.noflip2:
		rts
; ===========================================================================

Orb_ChkSonic:	; Routine 2
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0	; is Sonic to the right of the orbinaut?
		bcc.s	.isright	; if yes, branch
		neg.w	d0

.isright:
		cmpi.w	#$A0,d0		; is Sonic within $A0 pixels of	orbinaut?
		bhs.s	.animate	; if not, branch
		move.w	(v_player+obY).w,d0
		sub.w	obY(a0),d0	; is Sonic above the orbinaut?
		bcc.s	.isabove	; if yes, branch
		neg.w	d0

.isabove:
		cmpi.w	#$50,d0		; is Sonic within $50 pixels of	orbinaut?
		bhs.s	.animate	; if not, branch
		tst.w	(v_debuguse).w	; is debug mode	on?
		bne.s	.animate	; if yes, branch
		move.b	#1,obAnim(a0)	; use "angry" animation

.animate:
		lea	Ani_Orb(pc),a1
		jsr	(AnimateSprite).l
		out_of_range.s	Orb_ChkDel.chkgone
		bra.w	DisplaySprite
; ===========================================================================

Orb_Display:	; Routine 4
		bsr.w	SpeedToPos

Orb_ChkDel:
		out_of_range.s	.chkgone
		bra.w	DisplaySprite

.chkgone:
		move.w	obRespawnNo(a0),d0
		beq.s	loc_11E34
		movea.w	d0,a2
		bclr	#7,(a2)

loc_11E34:
		lea	objoff_37(a0),a2
		moveq	#0,d2
		move.b	(a2)+,d2
		subq.w	#1,d2
		bcs.w	DeleteObject

loc_11E40:
		moveq	#0,d0
		move.b	(a2)+,d0
	if object_size=$40
		lsl.w	#object_size_bits,d0
	else
		mulu.w	#object_size,d0
	endif
		addi.l	#v_objspace,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,loc_11E40
		bra.w	DeleteObject
; ===========================================================================

Orb_MoveOrb:	; Routine 6
		movea.l	orb_parent(a0),a1
		cmpi.l	#Orbinaut,obID(a1) ; does parent object still exist?
		bne.w	DeleteObject	; if not, delete
		cmpi.b	#2,obFrame(a1)	; is orbinaut angry?
		bne.s	.circle		; if not, branch
		cmpi.b	#$40,obAngle(a0) ; is spikeorb directly under the orbinaut?
		bne.s	.circle		; if not, branch
		addq.b	#2,obRoutine(a0)
		subq.b	#1,objoff_37(a1)
		bne.s	.fire
		addq.b	#2,obRoutine(a1)

.fire:
		move.w	#-$200,obVelX(a0) ; move orb to the left (quickly)
		btst	#0,obStatus(a1)
		beq.w	DisplaySprite
		neg.w	obVelX(a0)
		bra.w	DisplaySprite
; ===========================================================================

.circle:
		move.b	obAngle(a0),d0
		jsr	(CalcSine).w
		asr.w	#4,d1
		add.w	obX(a1),d1
		move.w	d1,obX(a0)
		asr.w	#4,d0
		add.w	obY(a1),d0
		move.w	d0,obY(a0)
		move.b	objoff_36(a1),d0
		add.b	d0,obAngle(a0)
		bra.w	DisplaySprite
; ===========================================================================

Orb_ChkDel2:	; Routine 8
		bsr.w	SpeedToPos
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
