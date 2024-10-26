; ---------------------------------------------------------------------------
; Debug	mode item lists
; ---------------------------------------------------------------------------
DebugList:
	dc.w .GHZ-DebugList
	dc.w .LZ-DebugList

dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

.GHZ:
	dc.w (.GHZend-.GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	dbug	Map_Chop,	id_Chopper,	0,	0,	make_art_tile(ArtTile_Chopper,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Plat_GHZ,	id_BasicPlatform, 0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_PRock,	id_PurpleRock,	0,	0,	make_art_tile(ArtTile_GHZ_Purple_Rock,3,0)
	dbug	Map_Moto,	id_MotoBug,	0,	0,	make_art_tile(ArtTile_Moto_Bug,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Newt,	id_Newtron,	0,	0,	make_art_tile(ArtTile_Newtron,1,0)
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	make_art_tile(ArtTile_GHZ_Edge_Wall,2,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
	dbug	Map_GRing,	id_GiantRing,	0,	0,	make_art_tile(ArtTile_Giant_Ring,1,0)
.GHZend:

.LZ:
	dc.w (.LZend-.LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
.LZend:

	even