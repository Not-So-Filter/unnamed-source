; ---------------------------------------------------------------------------
; Level Headers
; ---------------------------------------------------------------------------

LevelHeaders:

lhead:	macro plc1,lvlgfx,plc2,sixteen,onetwoeight,pal,music
	dc.l (plc1<<24)|lvlgfx
	dc.l (plc2<<24)|sixteen
	dc.l onetwoeight
	dc.b pal,0,0,0
	endm

; 1st PLC, level gfx, 2nd PLC, 16x16 data, 128x128 data,
; palette

;		1st PLC		level gfx	2nd PLC		16x16 data	128x128 data    palette data

	lhead	plcid_GHZ,	KosP_GHZ_2nd,	plcid_GHZ2,	Blk16_GHZ,	Blk128_GHZ,	palid_GHZ	; Green Hill Act 1
	lhead	plcid_GHZ,	KosP_GHZ_2nd,	plcid_GHZ2,	Blk16_GHZ,	Blk128_GHZ,	palid_GHZ	; Green Hill Act 2
	lhead	plcid_LZ,	KosP_LZ,	plcid_LZ2,	Blk16_LZ,	Blk128_LZ,	palid_LZ	; Labyrinth Act 1
	lhead	plcid_LZ,	KosP_LZ,	plcid_LZ2,	Blk16_LZ,	Blk128_LZ,	palid_LZ	; Labyrinth Act 2
	even