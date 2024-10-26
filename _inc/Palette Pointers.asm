; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro desinationPaletteLine,sourceAddress
	dc.l sourceAddress
	dc.w v_palette+desinationPaletteLine*$10*2,(sourceAddress_end-sourceAddress)/4-1
	endm

PalPointers:

; palette address, RAM address, colours

ptr_Pal_Title:		palp	0,Pal_Title		; 0 - title screen
ptr_Pal_LevelSel:	palp	0,Pal_LevelSel		; 1 - level select
ptr_Pal_Sonic:		palp	0,Pal_Sonic		; 2 - Sonic
Pal_Levels:
ptr_Pal_GHZ:		palp	1,Pal_GHZ		; 3 - GHZ
ptr_Pal_LZ:		palp	1,Pal_LZ		; 4 - LZ
			even


palid_Title:		equ (ptr_Pal_Title-PalPointers)/8
palid_LevelSel:		equ (ptr_Pal_LevelSel-PalPointers)/8
palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_GHZ:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_LZ:		equ (ptr_Pal_LZ-PalPointers)/8