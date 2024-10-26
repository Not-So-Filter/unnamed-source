; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_Main:		dc.w PLC_Main-ArtLoadCues
ptr_PLC_Main2:		dc.w PLC_Main2-ArtLoadCues
ptr_PLC_Explode:	dc.w PLC_Explode-ArtLoadCues
ptr_PLC_GameOver:	dc.w PLC_GameOver-ArtLoadCues
PLC_Levels:
ptr_PLC_GHZ:		dc.w PLC_GHZ-ArtLoadCues
ptr_PLC_GHZ2:		dc.w PLC_GHZ2-ArtLoadCues
ptr_PLC_LZ:		dc.w PLC_LZ-ArtLoadCues
ptr_PLC_LZ2:		dc.w PLC_LZ2-ArtLoadCues
ptr_PLC_TitleCard:	dc.w PLC_TitleCard-ArtLoadCues
ptr_PLC_Boss:		dc.w PLC_Boss-ArtLoadCues
ptr_PLC_Signpost:	dc.w PLC_Signpost-ArtLoadCues
PLC_Animals:
ptr_PLC_GHZAnimals:	dc.w PLC_GHZAnimals-ArtLoadCues
ptr_PLC_LZAnimals:	dc.w PLC_LZAnimals-ArtLoadCues

plcm:	macro gfx,vram
	dc.l gfx
	dc.w tiles_to_bytes(vram)
	endm

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	dc.w ((PLC_Mainend-PLC_Main)/6)-1
		plcm	KosPM_Lamp,   ArtTile_Lamppost      ; lamppost
		plcm	KosPM_Hud,    ArtTile_HUD           ; HUD
		plcm	KosPM_Lives,  ArtTile_Lives_Counter ; lives counter
		plcm	KosPM_Ring,   ArtTile_Ring          ; rings
		plcm	KosPM_Points, ArtTile_Points        ; points from enemy
PLC_Mainend:
; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	dc.w ((PLC_Main2end-PLC_Main2)/6)-1
		plcm	KosPM_Monitors, ArtTile_Monitor       ; monitors
		plcm	KosPM_Shield,   ArtTile_Shield        ; shield
		plcm	KosPM_Stars,    ArtTile_Invincibility ; invincibility stars
PLC_Main2end:
; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	dc.w ((PLC_Explodeend-PLC_Explode)/6)-1
		plcm	KosPM_Explode, ArtTile_Explosion ; explosion
PLC_Explodeend:
; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	dc.w ((PLC_GameOverend-PLC_GameOver)/6)-1
		plcm	KosPM_GameOver, ArtTile_Game_Over ; game/time over
PLC_GameOverend:
; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	dc.w ((PLC_GHZ2-PLC_GHZ)/6)-1
		plcm	KosPM_Stalk,     ArtTile_GHZ_Flower_Stalk       ; flower stalk
		plcm	KosPM_PplRock,   ArtTile_GHZ_Purple_Rock        ; purple rock
		plcm	KosPM_Crabmeat,  ArtTile_Crabmeat               ; crabmeat enemy
		plcm	KosPM_Buzz,      ArtTile_Buzz_Bomber            ; buzz bomber enemy
		plcm	KosPM_Chopper,   ArtTile_Chopper                ; chopper enemy
		plcm	KosPM_Newtron,   ArtTile_Newtron                ; newtron enemy
		plcm	KosPM_Motobug,   ArtTile_Moto_Bug               ; motobug enemy
		plcm	KosPM_Spikes,    ArtTile_Spikes                 ; spikes
		plcm	KosPM_HSpring,   ArtTile_Spring_Horizontal      ; horizontal spring
		plcm	KosPM_VSpring,   ArtTile_Spring_Vertical        ; vertical spring

PLC_GHZ2:	dc.w ((PLC_GHZ2end-PLC_GHZ2)/6)-1
		plcm	KosPM_Swing,     ArtTile_GHZ_MZ_Swing           ; swinging platform
		plcm	KosPM_Bridge,    ArtTile_GHZ_Bridge             ; bridge
		plcm	KosPM_SpikePole, ArtTile_GHZ_Spike_Pole         ; spiked pole
		plcm	KosPM_Ball,      ArtTile_GHZ_Giant_Ball         ; giant ball
		plcm	KosPM_GhzWall1,  ArtTile_GHZ_SLZ_Smashable_Wall ; breakable wall
		plcm	KosPM_GhzWall2,  ArtTile_GHZ_Edge_Wall          ; normal wall
PLC_GHZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		dc.w ((PLC_LZ2-PLC_LZ)/6)-1
PLC_LZ2:	dc.w ((PLC_LZ2end-PLC_LZ2)/6)-1
		plcm	KosPM_Spikes,      ArtTile_Spikes             ; spikes
		plcm	KosPM_HSpring,     ArtTile_Spring_Horizontal  ; horizontal spring
		plcm	KosPM_VSpring,     ArtTile_Spring_Vertical    ; vertical spring
PLC_LZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	dc.w ((PLC_TitleCardend-PLC_TitleCard)/6)-1
		plcm	KosPM_TitleCard, ArtTile_Title_Card
PLC_TitleCardend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	dc.w ((PLC_Bossend-PLC_Boss)/6)-1
		plcm	KosPM_Eggman,   ArtTile_Eggman           ; Eggman main patterns
		plcm	KosPM_Weapons,  ArtTile_Eggman_Weapons   ; Eggman's weapons
		plcm	KosPM_Prison,   ArtTile_Prison_Capsule   ; prison capsule
		plcm	KosPM_Exhaust,  ArtTile_Eggman_Exhaust   ; exhaust flame
PLC_Bossend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	dc.w ((PLC_Signpostend-PLC_Signpost)/6)-1
		plcm	KosPM_SignPost, ArtTile_Signpost         ; signpost
		plcm	KosPM_BigFlash, ArtTile_Giant_Ring_Flash ; giant ring flash effect
PLC_Signpostend:
; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	dc.w ((PLC_GHZAnimalsend-PLC_GHZAnimals)/6)-1
		plcm	KosPM_Rabbit, ArtTile_Animal_1 ; rabbit
		plcm	KosPM_Flicky, ArtTile_Animal_2 ; flicky
PLC_GHZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	dc.w ((PLC_LZAnimalsend-PLC_LZAnimals)/6)-1
		plcm	KosPM_Penguin, ArtTile_Animal_1 ; penguin
		plcm	KosPM_Seal,    ArtTile_Animal_2 ; seal
PLC_LZAnimalsend:

; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		equ (ptr_PLC_Main-ArtLoadCues)/2	; 0
plcid_Main2:		equ (ptr_PLC_Main2-ArtLoadCues)/2	; 1
plcid_Explode:		equ (ptr_PLC_Explode-ArtLoadCues)/2	; 2
plcid_GameOver:		equ (ptr_PLC_GameOver-ArtLoadCues)/2	; 3
plcid_GHZ:		equ (ptr_PLC_GHZ-ArtLoadCues)/2		; 4
plcid_GHZ2:		equ (ptr_PLC_GHZ2-ArtLoadCues)/2	; 5
plcid_LZ:		equ (ptr_PLC_LZ-ArtLoadCues)/2		; 6
plcid_LZ2:		equ (ptr_PLC_LZ2-ArtLoadCues)/2		; 7
plcid_TitleCard:	equ (ptr_PLC_TitleCard-ArtLoadCues)/2	; $10
plcid_Boss:		equ (ptr_PLC_Boss-ArtLoadCues)/2	; $11
plcid_Signpost:		equ (ptr_PLC_Signpost-ArtLoadCues)/2	; $12
plcid_GHZAnimals:	equ (ptr_PLC_GHZAnimals-ArtLoadCues)/2	; $13
plcid_LZAnimals:	equ (ptr_PLC_LZAnimals-ArtLoadCues)/2	; $14
