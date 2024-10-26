; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
ptr_Obj00:		dc.l DeleteObject
ptr_SonicPlayer:	dc.l SonicPlayer	; $01
ptr_Obj02:		dc.l DeleteObject
ptr_Obj03:		dc.l PathSwapper
ptr_Obj04:		dc.l DeleteObject
ptr_Obj05:		dc.l DeleteObject
ptr_Obj06:		dc.l DeleteObject
ptr_Obj07:		dc.l DeleteObject
ptr_Splash:		dc.l DeleteObject		; $08
ptr_SonicSpecial:	dc.l DeleteObject
ptr_DrownCount:		dc.l DeleteObject
ptr_Pole:		dc.l DeleteObject
ptr_FlapDoor:		dc.l DeleteObject
ptr_Signpost:		dc.l Signpost
ptr_TitleSonic:		dc.l TitleSonic
ptr_PSBTM:		dc.l PSBTM
ptr_Obj10:		dc.l DeleteObject		; $10
ptr_Bridge:		dc.l Bridge
ptr_SpinningLight:	dc.l DeleteObject
ptr_LavaMaker:		dc.l DeleteObject
ptr_LavaBall:		dc.l DeleteObject
ptr_SwingingPlatform:	dc.l DeleteObject
ptr_Harpoon:		dc.l DeleteObject
ptr_Helix:		dc.l Helix
ptr_BasicPlatform:	dc.l BasicPlatform	; $18
ptr_Obj19:		dc.l DeleteObject
ptr_CollapseLedge:	dc.l CollapseLedge
ptr_WaterSurface:	dc.l DeleteObject
ptr_Scenery:		dc.l Scenery
ptr_MagicSwitch:	dc.l DeleteObject
ptr_BallHog:		dc.l DeleteObject
ptr_Crabmeat:		dc.l Crabmeat
ptr_Cannonball:		dc.l DeleteObject		; $20
ptr_HUD:		dc.l DeleteObject
ptr_BuzzBomber:		dc.l BuzzBomber
ptr_Missile:		dc.l Missile
ptr_MissileDissolve:	dc.l DeleteObject
ptr_Rings:		dc.l Rings
ptr_Monitor:		dc.l Monitor
ptr_ExplosionItem:	dc.l ExplosionItem
ptr_Animals:		dc.l Animals		; $28
ptr_Points:		dc.l Points
ptr_AutoDoor:		dc.l DeleteObject
ptr_Chopper:		dc.l Chopper
ptr_Jaws:		dc.l DeleteObject
ptr_Burrobot:		dc.l DeleteObject
ptr_PowerUp:		dc.l PowerUp
ptr_LargeGrass:		dc.l DeleteObject
ptr_GlassBlock:		dc.l DeleteObject		; $30
ptr_ChainStomp:		dc.l DeleteObject
ptr_Button:		dc.l DeleteObject
ptr_PushBlock:		dc.l DeleteObject
ptr_TitleCard:		dc.l TitleCard
ptr_GrassFire:		dc.l DeleteObject
ptr_Spikes:		dc.l Spikes
ptr_RingLoss:		dc.l RingLoss
ptr_ShieldItem:		dc.l ShieldItem		; $38
ptr_GameOverCard:	dc.l GameOverCard
ptr_GotThroughCard:	dc.l GotThroughCard
ptr_PurpleRock:		dc.l PurpleRock
ptr_SmashWall:		dc.l SmashWall
ptr_BossGreenHill:	dc.l DeleteObject
ptr_Prison:		dc.l Prison
ptr_ExplosionBomb:	dc.l ExplosionBomb
ptr_MotoBug:		dc.l MotoBug		; $40
ptr_Springs:		dc.l Springs
ptr_Newtron:		dc.l Newtron
ptr_Roller:		dc.l DeleteObject
ptr_EdgeWalls:		dc.l EdgeWalls
ptr_SideStomp:		dc.l DeleteObject
ptr_MarbleBrick:	dc.l DeleteObject
ptr_Bumper:		dc.l DeleteObject
ptr_BossBall:		dc.l DeleteObject		; $48
ptr_WaterSound:		dc.l WaterSound
ptr_VanishSonic:	dc.l DeleteObject
ptr_GiantRing:		dc.l GiantRing
ptr_GeyserMaker:	dc.l DeleteObject
ptr_LavaGeyser:		dc.l DeleteObject
ptr_LavaWall:		dc.l DeleteObject
ptr_Obj4F:		dc.l DeleteObject
ptr_Yadrin:		dc.l DeleteObject		; $50
ptr_SmashBlock:		dc.l DeleteObject
ptr_MovingBlock:	dc.l DeleteObject
ptr_CollapseFloor:	dc.l DeleteObject
ptr_LavaTag:		dc.l DeleteObject
ptr_Basaran:		dc.l DeleteObject
ptr_FloatingBlock:	dc.l DeleteObject
ptr_SpikeBall:		dc.l DeleteObject
ptr_BigSpikeBall:	dc.l DeleteObject	; $58
ptr_Elevator:		dc.l DeleteObject
ptr_CirclingPlatform:	dc.l DeleteObject
ptr_Staircase:		dc.l DeleteObject
ptr_Pylon:		dc.l DeleteObject
ptr_Fan:		dc.l DeleteObject
ptr_Seesaw:		dc.l DeleteObject
ptr_Bomb:		dc.l DeleteObject
ptr_Orbinaut:		dc.l DeleteObject		; $60
ptr_LabyrinthBlock:	dc.l DeleteObject
ptr_Gargoyle:		dc.l DeleteObject
ptr_LabyrinthConvey:	dc.l DeleteObject
ptr_Bubble:		dc.l DeleteObject
ptr_Waterfall:		dc.l DeleteObject
ptr_Junction:		dc.l DeleteObject
ptr_RunningDisc:	dc.l DeleteObject
ptr_Conveyor:		dc.l DeleteObject		; $68
ptr_SpinPlatform:	dc.l DeleteObject
ptr_Saws:		dc.l DeleteObject
ptr_ScrapStomp:		dc.l DeleteObject
ptr_VanishPlatform:	dc.l DeleteObject
ptr_Flamethrower:	dc.l DeleteObject
ptr_Electro:		dc.l DeleteObject
ptr_SpinConvey:		dc.l DeleteObject
ptr_Girder:		dc.l DeleteObject		; $70
ptr_Invisibarrier:	dc.l Invisibarrier
ptr_Teleport:		dc.l DeleteObject
ptr_BossMarble:		dc.l DeleteObject
ptr_BossFire:		dc.l DeleteObject
ptr_BossSpringYard:	dc.l DeleteObject
ptr_BossBlock:		dc.l DeleteObject
ptr_BossLabyrinth:	dc.l DeleteObject
ptr_Caterkiller:	dc.l DeleteObject	; $78
ptr_Lamppost:		dc.l Lamppost
ptr_BossStarLight:	dc.l DeleteObject
ptr_BossSpikeball:	dc.l DeleteObject
ptr_RingFlash:		dc.l RingFlash
ptr_HiddenBonus:	dc.l DeleteObject
ptr_SSResult:		dc.l DeleteObject
ptr_SSRChaos:		dc.l DeleteObject
ptr_ContScrItem:	dc.l DeleteObject	; $80
ptr_ContSonic:		dc.l DeleteObject
ptr_ScrapEggman:	dc.l DeleteObject
ptr_FalseFloor:		dc.l DeleteObject
ptr_EggmanCylinder:	dc.l DeleteObject
ptr_BossFinal:		dc.l DeleteObject
ptr_BossPlasma:		dc.l DeleteObject
ptr_EndSonic:		dc.l DeleteObject
ptr_EndChaos:		dc.l DeleteObject		; $88
ptr_EndSTH:		dc.l DeleteObject
ptr_CreditsText:	dc.l CreditsText
ptr_EndEggman:		dc.l DeleteObject
ptr_TryChaos:		dc.l DeleteObject

id_SonicPlayer:		equ ((ptr_SonicPlayer-Obj_Index)/4)+1		; $01
id_Obj02:		equ ((ptr_Obj02-Obj_Index)/4)+1
id_Obj03:		equ ((ptr_Obj03-Obj_Index)/4)+1
id_Obj04:		equ ((ptr_Obj04-Obj_Index)/4)+1
id_Obj05:		equ ((ptr_Obj05-Obj_Index)/4)+1
id_Obj06:		equ ((ptr_Obj06-Obj_Index)/4)+1
id_Obj07:		equ ((ptr_Obj07-Obj_Index)/4)+1
id_Splash:		equ ((ptr_Splash-Obj_Index)/4)+1		; $08
id_SonicSpecial:	equ ((ptr_SonicSpecial-Obj_Index)/4)+1
id_DrownCount:		equ ((ptr_DrownCount-Obj_Index)/4)+1
id_Pole:		equ ((ptr_Pole-Obj_Index)/4)+1
id_FlapDoor:		equ ((ptr_FlapDoor-Obj_Index)/4)+1
id_Signpost:		equ ((ptr_Signpost-Obj_Index)/4)+1
id_TitleSonic:		equ ((ptr_TitleSonic-Obj_Index)/4)+1
id_PSBTM:		equ ((ptr_PSBTM-Obj_Index)/4)+1
id_Obj10:		equ ((ptr_Obj10-Obj_Index)/4)+1			; $10
id_Bridge:		equ ((ptr_Bridge-Obj_Index)/4)+1
id_SpinningLight:	equ ((ptr_SpinningLight-Obj_Index)/4)+1
id_LavaMaker:		equ ((ptr_LavaMaker-Obj_Index)/4)+1
id_LavaBall:		equ ((ptr_LavaBall-Obj_Index)/4)+1
id_SwingingPlatform:	equ ((ptr_SwingingPlatform-Obj_Index)/4)+1
id_Harpoon:		equ ((ptr_Harpoon-Obj_Index)/4)+1
id_Helix:		equ ((ptr_Helix-Obj_Index)/4)+1
id_BasicPlatform:	equ ((ptr_BasicPlatform-Obj_Index)/4)+1		; $18
id_Obj19:		equ ((ptr_Obj19-Obj_Index)/4)+1
id_CollapseLedge:	equ ((ptr_CollapseLedge-Obj_Index)/4)+1
id_WaterSurface:	equ ((ptr_WaterSurface-Obj_Index)/4)+1
id_Scenery:		equ ((ptr_Scenery-Obj_Index)/4)+1
id_MagicSwitch:		equ ((ptr_MagicSwitch-Obj_Index)/4)+1
id_BallHog:		equ ((ptr_BallHog-Obj_Index)/4)+1
id_Crabmeat:		equ ((ptr_Crabmeat-Obj_Index)/4)+1
id_Cannonball:		equ ((ptr_Cannonball-Obj_Index)/4)+1		; $20
id_HUD:			equ ((ptr_HUD-Obj_Index)/4)+1
id_BuzzBomber:		equ ((ptr_BuzzBomber-Obj_Index)/4)+1
id_Missile:		equ ((ptr_Missile-Obj_Index)/4)+1
id_MissileDissolve:	equ ((ptr_MissileDissolve-Obj_Index)/4)+1
id_Rings:		equ ((ptr_Rings-Obj_Index)/4)+1
id_Monitor:		equ ((ptr_Monitor-Obj_Index)/4)+1
id_ExplosionItem:	equ ((ptr_ExplosionItem-Obj_Index)/4)+1
id_Animals:		equ ((ptr_Animals-Obj_Index)/4)+1		; $28
id_Points:		equ ((ptr_Points-Obj_Index)/4)+1
id_AutoDoor:		equ ((ptr_AutoDoor-Obj_Index)/4)+1
id_Chopper:		equ ((ptr_Chopper-Obj_Index)/4)+1
id_Jaws:		equ ((ptr_Jaws-Obj_Index)/4)+1
id_Burrobot:		equ ((ptr_Burrobot-Obj_Index)/4)+1
id_PowerUp:		equ ((ptr_PowerUp-Obj_Index)/4)+1
id_LargeGrass:		equ ((ptr_LargeGrass-Obj_Index)/4)+1
id_GlassBlock:		equ ((ptr_GlassBlock-Obj_Index)/4)+1		; $30
id_ChainStomp:		equ ((ptr_ChainStomp-Obj_Index)/4)+1
id_Button:		equ ((ptr_Button-Obj_Index)/4)+1
id_PushBlock:		equ ((ptr_PushBlock-Obj_Index)/4)+1
id_TitleCard:		equ ((ptr_TitleCard-Obj_Index)/4)+1
id_GrassFire:		equ ((ptr_GrassFire-Obj_Index)/4)+1
id_Spikes:		equ ((ptr_Spikes-Obj_Index)/4)+1
id_RingLoss:		equ ((ptr_RingLoss-Obj_Index)/4)+1
id_ShieldItem:		equ ((ptr_ShieldItem-Obj_Index)/4)+1		; $38
id_GameOverCard:	equ ((ptr_GameOverCard-Obj_Index)/4)+1
id_GotThroughCard:	equ ((ptr_GotThroughCard-Obj_Index)/4)+1
id_PurpleRock:		equ ((ptr_PurpleRock-Obj_Index)/4)+1
id_SmashWall:		equ ((ptr_SmashWall-Obj_Index)/4)+1
id_BossGreenHill:	equ ((ptr_BossGreenHill-Obj_Index)/4)+1
id_Prison:		equ ((ptr_Prison-Obj_Index)/4)+1
id_ExplosionBomb:	equ ((ptr_ExplosionBomb-Obj_Index)/4)+1
id_MotoBug:		equ ((ptr_MotoBug-Obj_Index)/4)+1		; $40
id_Springs:		equ ((ptr_Springs-Obj_Index)/4)+1
id_Newtron:		equ ((ptr_Newtron-Obj_Index)/4)+1
id_Roller:		equ ((ptr_Roller-Obj_Index)/4)+1
id_EdgeWalls:		equ ((ptr_EdgeWalls-Obj_Index)/4)+1
id_SideStomp:		equ ((ptr_SideStomp-Obj_Index)/4)+1
id_MarbleBrick:		equ ((ptr_MarbleBrick-Obj_Index)/4)+1
id_Bumper:		equ ((ptr_Bumper-Obj_Index)/4)+1
id_BossBall:		equ ((ptr_BossBall-Obj_Index)/4)+1		; $48
id_WaterSound:		equ ((ptr_WaterSound-Obj_Index)/4)+1
id_VanishSonic:		equ ((ptr_VanishSonic-Obj_Index)/4)+1
id_GiantRing:		equ ((ptr_GiantRing-Obj_Index)/4)+1
id_GeyserMaker:		equ ((ptr_GeyserMaker-Obj_Index)/4)+1
id_LavaGeyser:		equ ((ptr_LavaGeyser-Obj_Index)/4)+1
id_LavaWall:		equ ((ptr_LavaWall-Obj_Index)/4)+1
id_Obj4F:		equ ((ptr_Obj4F-Obj_Index)/4)+1
id_Yadrin:		equ ((ptr_Yadrin-Obj_Index)/4)+1		; $50
id_SmashBlock:		equ ((ptr_SmashBlock-Obj_Index)/4)+1
id_MovingBlock:		equ ((ptr_MovingBlock-Obj_Index)/4)+1
id_CollapseFloor:	equ ((ptr_CollapseFloor-Obj_Index)/4)+1
id_LavaTag:		equ ((ptr_LavaTag-Obj_Index)/4)+1
id_Basaran:		equ ((ptr_Basaran-Obj_Index)/4)+1
id_FloatingBlock:	equ ((ptr_FloatingBlock-Obj_Index)/4)+1
id_SpikeBall:		equ ((ptr_SpikeBall-Obj_Index)/4)+1
id_BigSpikeBall:	equ ((ptr_BigSpikeBall-Obj_Index)/4)+1		; $58
id_Elevator:		equ ((ptr_Elevator-Obj_Index)/4)+1
id_CirclingPlatform:	equ ((ptr_CirclingPlatform-Obj_Index)/4)+1
id_Staircase:		equ ((ptr_Staircase-Obj_Index)/4)+1
id_Pylon:		equ ((ptr_Pylon-Obj_Index)/4)+1
id_Fan:			equ ((ptr_Fan-Obj_Index)/4)+1
id_Seesaw:		equ ((ptr_Seesaw-Obj_Index)/4)+1
id_Bomb:		equ ((ptr_Bomb-Obj_Index)/4)+1
id_Orbinaut:		equ ((ptr_Orbinaut-Obj_Index)/4)+1		; $60
id_LabyrinthBlock:	equ ((ptr_LabyrinthBlock-Obj_Index)/4)+1
id_Gargoyle:		equ ((ptr_Gargoyle-Obj_Index)/4)+1
id_LabyrinthConvey:	equ ((ptr_LabyrinthConvey-Obj_Index)/4)+1
id_Bubble:		equ ((ptr_Bubble-Obj_Index)/4)+1
id_Waterfall:		equ ((ptr_Waterfall-Obj_Index)/4)+1
id_Junction:		equ ((ptr_Junction-Obj_Index)/4)+1
id_RunningDisc:		equ ((ptr_RunningDisc-Obj_Index)/4)+1
id_Conveyor:		equ ((ptr_Conveyor-Obj_Index)/4)+1		; $68
id_SpinPlatform:	equ ((ptr_SpinPlatform-Obj_Index)/4)+1
id_Saws:		equ ((ptr_Saws-Obj_Index)/4)+1
id_ScrapStomp:		equ ((ptr_ScrapStomp-Obj_Index)/4)+1
id_VanishPlatform:	equ ((ptr_VanishPlatform-Obj_Index)/4)+1
id_Flamethrower:	equ ((ptr_Flamethrower-Obj_Index)/4)+1
id_Electro:		equ ((ptr_Electro-Obj_Index)/4)+1
id_SpinConvey:		equ ((ptr_SpinConvey-Obj_Index)/4)+1
id_Girder:		equ ((ptr_Girder-Obj_Index)/4)+1		; $70
id_Invisibarrier:	equ ((ptr_Invisibarrier-Obj_Index)/4)+1
id_Teleport:		equ ((ptr_Teleport-Obj_Index)/4)+1
id_BossMarble:		equ ((ptr_BossMarble-Obj_Index)/4)+1
id_BossFire:		equ ((ptr_BossFire-Obj_Index)/4)+1
id_BossSpringYard:	equ ((ptr_BossSpringYard-Obj_Index)/4)+1
id_BossBlock:		equ ((ptr_BossBlock-Obj_Index)/4)+1
id_BossLabyrinth:	equ ((ptr_BossLabyrinth-Obj_Index)/4)+1
id_Caterkiller:		equ ((ptr_Caterkiller-Obj_Index)/4)+1		; $78
id_Lamppost:		equ ((ptr_Lamppost-Obj_Index)/4)+1
id_BossStarLight:	equ ((ptr_BossStarLight-Obj_Index)/4)+1
id_BossSpikeball:	equ ((ptr_BossSpikeball-Obj_Index)/4)+1
id_RingFlash:		equ ((ptr_RingFlash-Obj_Index)/4)+1
id_HiddenBonus:		equ ((ptr_HiddenBonus-Obj_Index)/4)+1
id_SSResult:		equ ((ptr_SSResult-Obj_Index)/4)+1
id_SSRChaos:		equ ((ptr_SSRChaos-Obj_Index)/4)+1
id_ContScrItem:		equ ((ptr_ContScrItem-Obj_Index)/4)+1		; $80
id_ContSonic:		equ ((ptr_ContSonic-Obj_Index)/4)+1
id_ScrapEggman:		equ ((ptr_ScrapEggman-Obj_Index)/4)+1
id_FalseFloor:		equ ((ptr_FalseFloor-Obj_Index)/4)+1
id_EggmanCylinder:	equ ((ptr_EggmanCylinder-Obj_Index)/4)+1
id_BossFinal:		equ ((ptr_BossFinal-Obj_Index)/4)+1
id_BossPlasma:		equ ((ptr_BossPlasma-Obj_Index)/4)+1
id_EndSonic:		equ ((ptr_EndSonic-Obj_Index)/4)+1
id_EndChaos:		equ ((ptr_EndChaos-Obj_Index)/4)+1		; $88
id_EndSTH:		equ ((ptr_EndSTH-Obj_Index)/4)+1
id_CreditsText:		equ ((ptr_CreditsText-Obj_Index)/4)+1
id_EndEggman:		equ ((ptr_EndEggman-Obj_Index)/4)+1
id_TryChaos:		equ ((ptr_TryChaos-Obj_Index)/4)+1