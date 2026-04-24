; ===========================================================================
; Level pattern load cues
; Load main graphics
; ===========================================================================

; ===========================================================================
; Pattern load cues - Sonic
; ===========================================================================

PLC1_Sonic: plrlistheader
		plreq ArtTile_StarPost, ArtKosPlusM_EnemyScoreStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPlusM_Ring_Sparks			; rings
		plreq ArtTile_HUD, ArtKosPlusM_HUD					; HUD
		plreq ArtTile_LifeIcon, ArtKosPlusM_SonicLifeIcon			; life icon
		plrlistend

; ===========================================================================
; Pattern load cues - Miles
; ===========================================================================

PLC1_Miles: plrlistheader
		plreq ArtTile_StarPost, ArtKosPlusM_EnemyScoreStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPlusM_Ring_Sparks			; rings
		plreq ArtTile_HUD, ArtKosPlusM_HUD					; HUD
		plreq ArtTile_LifeIcon, ArtKosPlusM_MilesLifeIcon			; life icon
		plrlistend

; ===========================================================================
; Pattern load cues - Tails
; ===========================================================================

PLC1_Tails: plrlistheader
		plreq ArtTile_StarPost, ArtKosPlusM_EnemyScoreStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPlusM_Ring_Sparks			; rings
		plreq ArtTile_HUD, ArtKosPlusM_HUD					; HUD
		plreq ArtTile_LifeIcon, ArtKosPlusM_TailsLifeIcon			; life icon
		plrlistend

; ===========================================================================
; Pattern load cues - Knuckles
; ===========================================================================

PLC1_Knuckles: plrlistheader
		plreq ArtTile_StarPost, ArtKosPlusM_EnemyScoreStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPlusM_Ring_Sparks			; rings
		plreq ArtTile_HUD, ArtKosPlusM_HUD					; HUD
		plreq ArtTile_LifeIcon, ArtKosPlusM_KnucklesLifeIcon			; life icon
		plrlistend

; ===========================================================================
; Pattern load cues 2 - Sonic
; ===========================================================================

PLC2_Sonic: plrlistheader
		plreq ArtTile_SpikesSprings, ArtKosPlusM_SpikesSprings			; spikes and normal spring
		plreq ArtTile_Monitors, ArtKosPlusM_Monitors				; monitors
		plreq ArtTile_Explosion, ArtKosPlusM_Explosion				; explosion
		plrlistend

; ===========================================================================
; Pattern load cues 2 - Knuckles
; ===========================================================================

PLC2_Knuckles: plrlistheader
		plreq ArtTile_SpikesSprings, ArtKosPlusM_SpikesSprings			; spikes and normal spring
		plreq ArtTile_Monitors, ArtKosPlusM_Monitors				; monitors
		plreq ArtTile_Monitors+$1C, ArtKosPlusM_MonitorsEggRobo			; monitors (Egg Robo)
		plreq ArtTile_Explosion, ArtKosPlusM_Explosion				; explosion
		plrlistend

; ===========================================================================
; Level pattern load cues
; Load graphics before and after Title Card
; ===========================================================================

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ1_Before: plrlistheader
		plreq $33E, ArtKosPlusM_Bridge						; bridge
		plreq $3A4, ArtKosPlusM_GHZEdgeWalls					; edge wall
		plreq $380, ArtKosPlusM_PplRock						; purple rock
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ1_After: plrlistheader
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4EC, ArtKosPlusM_Chopper						; chopper enemy
		plreq $50C, ArtKosPlusM_Newtron						; newtron enemy
		plreq $561, ArtKosPlusM_Motobug						; motobug enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ2_Before: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $3C2, ArtKosPlusM_Swing						; swinging platform
		plreq $33E, ArtKosPlusM_Bridge						; bridge
		plreq $398, ArtKosPlusM_GHZBreakableWall				; breakable wall
		plreq $3A4, ArtKosPlusM_GHZEdgeWalls					; edge wall
		plreq $380, ArtKosPlusM_PplRock						; purple rock
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ2_After: plrlistheader
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $4EC, ArtKosPlusM_Chopper						; chopper enemy
		plreq $50C, ArtKosPlusM_Newtron						; newtron enemy
		plreq $561, ArtKosPlusM_Motobug						; motobug enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ3_Before: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $3A4, ArtKosPlusM_GHZEdgeWalls					; edge wall
		plreq $3B0, ArtKosPlusM_SpikePole					; spike pole
		plreq $3C2, ArtKosPlusM_Swing						; swinging platform
		plreq $33E, ArtKosPlusM_Bridge						; bridge
		plreq $398, ArtKosPlusM_GHZBreakableWall				; breakable wall
		plreq $380, ArtKosPlusM_PplRock						; purple rock
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ3_After: plrlistheader
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $4EC, ArtKosPlusM_Chopper						; chopper enemy
		plreq $50C, ArtKosPlusM_Newtron						; newtron enemy
		plreq $561, ArtKosPlusM_Motobug						; motobug enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ4_Before: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ4_After: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ1_Before: plrlistheader
		plreq $298, ArtKosPlusM_Fireballs					; fireballs
		plreq $300, ArtKosPlusM_MZGlass						; glass block
		plreq $31A, ArtKosPlusM_Swing						; swinging platform
		plreq $328, ArtKosPlusM_MZMetal						; chain stomp
		plreq $47C, ArtKosPlusM_MZGrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ1_After: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPlusM_Basaran						; basaran enemy
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_MZBlock						; block
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ2_Before: plrlistheader
		plreq $298, ArtKosPlusM_Fireballs					; fireballs
		plreq $300, ArtKosPlusM_MZGlass						; glass block
		plreq $31A, ArtKosPlusM_Swing						; swinging platform
		plreq $328, ArtKosPlusM_MZMetal						; chain stomp
		plreq $36D, ArtKosPlusM_LavaWall					; lava wall
		plreq $47C, ArtKosPlusM_MZGrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ2_After: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPlusM_Basaran						; basaran enemy
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_MZBlock						; block
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ3_Before: plrlistheader
		plreq $298, ArtKosPlusM_Fireballs					; fireballs
		plreq $300, ArtKosPlusM_MZGlass						; glass block
		plreq $31A, ArtKosPlusM_Swing						; swinging platform
		plreq $328, ArtKosPlusM_MZMetal						; chain stomp
		plreq $36D, ArtKosPlusM_LavaWall					; lava wall
		plreq $47C, ArtKosPlusM_MZGrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ3_After: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPlusM_Basaran						; basaran enemy
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_MZBlock						; block
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ4_Before: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ4_After: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ1_Before: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ1_After: plrlistheader
		plreq $372, ArtKosPlusM_Bumper						; bumper
		plreq $396, ArtKosPlusM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPlusM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPlusM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPlusM_Roller						; roller enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ2_Before: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ2_After: plrlistheader
		plreq $372, ArtKosPlusM_Bumper						; bumper
		plreq $396, ArtKosPlusM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPlusM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPlusM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPlusM_Roller						; roller enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ3_Before: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ3_After: plrlistheader
		plreq $372, ArtKosPlusM_Bumper						; bumper
		plreq $396, ArtKosPlusM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPlusM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPlusM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPlusM_Roller						; roller enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ4_Before: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ4_After: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ1_Before: plrlistheader
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ1_After: plrlistheader
		plreq $259, ArtKosPlusM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPlusM_Gargoyle					; gargoyle
		plreq $310, ArtKosPlusM_SpikeBallChain					; small spikeball
		plreq $328, ArtKosPlusM_FlappingDoor					; flapping door
		plreq $348, ArtKosPlusM_Bubbles						; bubbles
		plreq $3BC, ArtKosPlusM_LZBlock3					; block3
		plreq $3C4, ArtKosPlusM_LZDoor1						; door1
		plreq $3CC, ArtKosPlusM_Harpoon						; harpoon
		plreq $3DE, ArtKosPlusM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPlusM_LZDoor2						; door2
		plreq $406, ArtKosPlusM_LabyrinthConveyor				; conveyor (platform only)
		plreq $44F, ArtKosPlusM_LZPlatform					; platform
		plreq $467, ArtKosPlusM_Cork						; cork
		plreq $4F0, ArtKosPlusM_Jaws						; jaws enemy
		plreq $510, ArtKosPlusM_Burrobot					; burrobot enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ2_Before: plrlistheader
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ2_After: plrlistheader
		plreq $259, ArtKosPlusM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPlusM_Gargoyle					; gargoyle
		plreq $310, ArtKosPlusM_SpikeBallChain					; small spikeball
		plreq $328, ArtKosPlusM_FlappingDoor					; flapping door
		plreq $348, ArtKosPlusM_Bubbles						; bubbles
		plreq $3BC, ArtKosPlusM_LZBlock3					; block3
		plreq $3C4, ArtKosPlusM_LZDoor1						; door1
		plreq $3CC, ArtKosPlusM_Harpoon						; harpoon
		plreq $3DE, ArtKosPlusM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPlusM_LZDoor2						; door2
		plreq $406, ArtKosPlusM_LabyrinthConveyor				; conveyor (platform only)
		plreq $44F, ArtKosPlusM_LZPlatform					; platform
		plreq $467, ArtKosPlusM_Cork						; cork
		plreq $4F0, ArtKosPlusM_Jaws						; jaws enemy
		plreq $510, ArtKosPlusM_Burrobot					; burrobot enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ3_Before: plrlistheader
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ3_After: plrlistheader
		plreq $259, ArtKosPlusM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPlusM_Gargoyle					; gargoyle
		plreq $310, ArtKosPlusM_SpikeBallChain					; small spikeball
		plreq $328, ArtKosPlusM_FlappingDoor					; flapping door
		plreq $348, ArtKosPlusM_Bubbles						; bubbles
		plreq $3BC, ArtKosPlusM_LZBlock3					; block3
		plreq $3C4, ArtKosPlusM_LZDoor1						; door1
		plreq $3CC, ArtKosPlusM_Harpoon						; harpoon
		plreq $3DE, ArtKosPlusM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPlusM_LZDoor2						; door2
		plreq $406, ArtKosPlusM_LabyrinthConveyor				; conveyor (platform only)
		plreq $44F, ArtKosPlusM_LZPlatform					; platform
		plreq $467, ArtKosPlusM_Cork						; cork
		plreq $4F0, ArtKosPlusM_Jaws						; jaws enemy
		plreq $510, ArtKosPlusM_Burrobot					; burrobot enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ4_Before: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $1F0, ArtKosPlusM_LZBlock2					; block2
		plrlistend

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ4_After: plrlistheader
		plreq $259, ArtKosPlusM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPlusM_Gargoyle					; gargoyle
		plreq $310, ArtKosPlusM_SpikeBallChain					; small spikeball
		plreq $328, ArtKosPlusM_FlappingDoor					; flapping door
		plreq $348, ArtKosPlusM_Bubbles						; bubbles
		plreq $3BC, ArtKosPlusM_LZBlock3					; block3
		plreq $3C4, ArtKosPlusM_LZDoor1						; door1
		plreq $3CC, ArtKosPlusM_Harpoon						; harpoon
		plreq $3DE, ArtKosPlusM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPlusM_LZDoor2						; door2
		plreq $44F, ArtKosPlusM_LZPlatform					; platform
		plreq $467, ArtKosPlusM_Cork						; cork
		plreq $4F0, ArtKosPlusM_Jaws						; jaws enemy
		plreq $510, ArtKosPlusM_Burrobot					; burrobot enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ1_Before: plrlistheader
		plreq $36A, ArtKosPlusM_Pylon						; pylon
		plreq $414, ArtKosPlusM_SLZBreakableWall				; breakable wall
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ1_After: plrlistheader
		plreq $37A, ArtKosPlusM_Seesaw						; seesaw
		plreq $3E8, ArtKosPlusM_Fan						; fan
		plreq $41C, ArtKosPlusM_SLZBlock					; block
		plreq $42C, ArtKosPlusM_SLZCannon					; cannon
		plreq $434, ArtKosPlusM_Fireballs					; fireballs
		plreq $4EE, ArtKosPlusM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ2_Before: plrlistheader
		plreq $36A, ArtKosPlusM_Pylon						; pylon
		plreq $414, ArtKosPlusM_SLZBreakableWall				; breakable wall
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ2_After: plrlistheader
		plreq $37A, ArtKosPlusM_Seesaw						; seesaw
		plreq $3E8, ArtKosPlusM_Fan						; fan
		plreq $41C, ArtKosPlusM_SLZBlock					; block
		plreq $42C, ArtKosPlusM_SLZCannon					; cannon
		plreq $434, ArtKosPlusM_Fireballs					; fireballs
		plreq $4EE, ArtKosPlusM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ3_Before: plrlistheader
		plreq $36A, ArtKosPlusM_Pylon						; pylon
		plreq $414, ArtKosPlusM_SLZBreakableWall				; breakable wall
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ3_After: plrlistheader
		plreq $37A, ArtKosPlusM_Seesaw						; seesaw
		plreq $3A6, ArtKosPlusM_SLZSwing					; swinging platform
		plreq $3E8, ArtKosPlusM_Fan						; fan
		plreq $41C, ArtKosPlusM_SLZBlock					; block
		plreq $42C, ArtKosPlusM_SLZCannon					; cannon
		plreq $434, ArtKosPlusM_Fireballs					; fireballs
		plreq $4EE, ArtKosPlusM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ4_Before: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ4_After: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Before)
; ===========================================================================

PLC1_SBZ1_Before: plrlistheader
		plreq $2AA, ArtKosPlusM_SBZFloor
		plreq $2B2, ArtKosPlusM_Stomper
		plreq $2DA, ArtKosPlusM_Girder
		plreq $31B, ArtKosPlusM_SBZWheel2
		plreq $364, ArtKosPlusM_SBZBlock
		plreq $380, ArtKosPlusM_SlideFloor
		plreq $38F, ArtKosPlusM_SBZDoor2
		plreq $3A4, ArtKosPlusM_Cutter
		plreq $3C8, ArtKosPlusM_SpinPform
		plreq $3F8, ArtKosPlusM_TrapDoor
		plreq $470, ArtKosPlusM_SBZDoor1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (After)
; ===========================================================================

PLC2_SBZ1_After: plrlistheader
		plreq $2EC, ArtKosPlusM_BallHog						; ball hog enemy
		plreq $429, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $529, ArtKosPlusM_Electric					; electrocution orbs
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_FlamePipe					; flame pipe
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Before)
; ===========================================================================

PLC1_SBZ2_Before: plrlistheader
		plreq $2AA, ArtKosPlusM_SBZFloor
		plreq $2B2, ArtKosPlusM_Stomper
		plreq $364, ArtKosPlusM_SBZBlock
		plreq $380, ArtKosPlusM_SlideFloor
		plreq $38F, ArtKosPlusM_SBZDoor2
		plreq $3A0, ArtKosPlusM_SBZWheel1
		plreq $3A4, ArtKosPlusM_Cutter
		plreq $3C8, ArtKosPlusM_SpinPform
		plreq $3F8, ArtKosPlusM_TrapDoor
		plreq $448, ArtKosPlusM_LargeSpikeball
		plreq $470, ArtKosPlusM_SBZDoor1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (After)
; ===========================================================================

PLC2_SBZ2_After: plrlistheader
		plreq $2EC, ArtKosPlusM_BallHog						; ball hog enemy
		plreq $429, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $529, ArtKosPlusM_Electric					; electrocution orbs
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_FlamePipe					; flame pipe
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Final Zone (Before)
; ===========================================================================

PLC1_SBZ3_Before: plrlistheader
		plreq $300, ArtKosPlusM_FZBoss						; final boss
		plreq $3A0, ArtKosPlusM_RobotnikShip1					; robotnik ship
		plreq $420, ArtKosPlusM_RobotnikShipStand				; robotnik ship stand
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Final Zone (After)
; ===========================================================================

PLC2_SBZ3_After: plrlistheader
		plreq $500, ArtKosPlusM_BossExplosion					; boss explosion
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Before)
; ===========================================================================

PLC1_SBZ4_Before: plrlistheader
		plrlistend

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (After)
; ===========================================================================

PLC2_SBZ4_After: plrlistheader
		plrlistend

; ===========================================================================
; Level pattern load cues
; Load animals graphics
; ===========================================================================

; ===========================================================================
; Pattern load cues - Animals (GHZ1)
; ===========================================================================

PLCAnimals_GHZ1: plrlistheader
		plreq $580, ArtKosPlusM_Rabbit
		plreq $592, ArtKosPlusM_BlueFlicky
		plrlistend

; ===========================================================================
; Pattern load cues - Animals (MZ1)
; ===========================================================================

PLCAnimals_MZ1: plrlistheader
		plreq $580, ArtKosPlusM_Squirrel
		plreq $592, ArtKosPlusM_Seal
		plrlistend

; ===========================================================================
; Pattern load cues - Animals (SYZ1)
; ===========================================================================

PLCAnimals_SYZ1: plrlistheader
		plreq $580, ArtKosPlusM_Pig
		plreq $592, ArtKosPlusM_Chicken
		plrlistend

; ===========================================================================
; Pattern load cues - Animals (LZ1)
; ===========================================================================

PLCAnimals_LZ1: plrlistheader
		plreq $580, ArtKosPlusM_Penguin
		plreq $592, ArtKosPlusM_Seal
		plrlistend

; ===========================================================================
; Pattern load cues - Animals (SLZ1)
; ===========================================================================

PLCAnimals_SLZ1: plrlistheader
		plreq $580, ArtKosPlusM_Pig
		plreq $592, ArtKosPlusM_BlueFlicky
		plrlistend

; ===========================================================================
; Pattern load cues - Animals (SBZ1)
; ===========================================================================

PLCAnimals_SBZ1: plrlistheader
		plreq $580, ArtKosPlusM_Rabbit
		plreq $592, ArtKosPlusM_Chicken
		plrlistend
