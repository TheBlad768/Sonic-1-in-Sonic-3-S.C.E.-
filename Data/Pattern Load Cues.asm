; ===========================================================================
; Level pattern load cues
; Load main graphics
; ===========================================================================

; ===========================================================================
; Pattern load cues - Main (Primary)
; ===========================================================================

PLC_Main_Primary: plrlistheader
		plreq ArtTile_StarPost, ArtKosPlusM_EnemyScoreStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPlusM_Ring_Sparks			; rings
		plreq ArtTile_HUD, ArtKosPlusM_HUD					; HUD
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Main (Secondary)
; ===========================================================================

PLC_Main_Secondary: plrlistheader
		plreq ArtTile_SpikesSprings, ArtKosPlusM_SpikesSprings			; spikes and normal spring
		plreq ArtTile_Monitors, ArtKosPlusM_Monitors				; monitors
		plreq ArtTile_Explosion, ArtKosPlusM_Explosion				; explosion
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Main Knuckles (Secondary)
; ===========================================================================

PLC_Main_Knux_Secondary: plrlistheader
		plreq ArtTile_SpikesSprings, ArtKosPlusM_SpikesSprings			; spikes and normal spring
		plreq ArtTile_Monitors, ArtKosPlusM_Monitors				; monitors
		plreq ArtTile_Monitors+$1C, ArtKosPlusM_MonitorsEggRobo			; monitors (Egg Robo)
		plreq ArtTile_Explosion, ArtKosPlusM_Explosion				; explosion
		plrlistend								; end marker

; ===========================================================================
; Level pattern load cues
; Load graphics before and after Title Card
; ===========================================================================

; ===========================================================================
; Pattern load cues - Green Hill Zone (Primary)
; ===========================================================================

PLC_GHZ1_Primary: plrlistheader
		plreq $33E, ArtKosPlusM_Bridge						; bridge
		plreq $3A4, ArtKosPlusM_GHZEdgeWalls					; edge wall
		plreq $380, ArtKosPlusM_PplRock						; purple rock
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Secondary)
; ===========================================================================

PLC_GHZ1_Secondary: plrlistheader
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4EC, ArtKosPlusM_Chopper						; chopper enemy
		plreq $50C, ArtKosPlusM_Newtron						; newtron enemy
		plreq $561, ArtKosPlusM_Motobug						; motobug enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Primary)
; ===========================================================================

PLC_GHZ2_Primary: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $3C2, ArtKosPlusM_Swing						; swinging platform
		plreq $33E, ArtKosPlusM_Bridge						; bridge
		plreq $398, ArtKosPlusM_GHZBreakableWall				; breakable wall
		plreq $3A4, ArtKosPlusM_GHZEdgeWalls					; edge wall
		plreq $380, ArtKosPlusM_PplRock						; purple rock
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Secondary)
; ===========================================================================

PLC_GHZ2_Secondary: plrlistheader
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $4EC, ArtKosPlusM_Chopper						; chopper enemy
		plreq $50C, ArtKosPlusM_Newtron						; newtron enemy
		plreq $561, ArtKosPlusM_Motobug						; motobug enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Primary)
; ===========================================================================

PLC_GHZ3_Primary: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $3A4, ArtKosPlusM_GHZEdgeWalls					; edge wall
		plreq $3B0, ArtKosPlusM_SpikePole					; spike pole
		plreq $3C2, ArtKosPlusM_Swing						; swinging platform
		plreq $33E, ArtKosPlusM_Bridge						; bridge
		plreq $398, ArtKosPlusM_GHZBreakableWall				; breakable wall
		plreq $380, ArtKosPlusM_PplRock						; purple rock
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Secondary)
; ===========================================================================

PLC_GHZ3_Secondary: plrlistheader
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $4EC, ArtKosPlusM_Chopper						; chopper enemy
		plreq $50C, ArtKosPlusM_Newtron						; newtron enemy
		plreq $561, ArtKosPlusM_Motobug						; motobug enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Primary)
; ===========================================================================

PLC_GHZ4_Primary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Green Hill Zone (Secondary)
; ===========================================================================

PLC_GHZ4_Secondary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Primary)
; ===========================================================================

PLC_MZ1_Primary: plrlistheader
		plreq $298, ArtKosPlusM_Fireballs					; fireballs
		plreq $300, ArtKosPlusM_MZGlass						; glass block
		plreq $31A, ArtKosPlusM_Swing						; swinging platform
		plreq $328, ArtKosPlusM_MZMetal						; chain stomp
		plreq $47C, ArtKosPlusM_MZGrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Secondary)
; ===========================================================================

PLC_MZ1_Secondary: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPlusM_Basaran						; basaran enemy
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_MZBlock						; block
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Primary)
; ===========================================================================

PLC_MZ2_Primary: plrlistheader
		plreq $298, ArtKosPlusM_Fireballs					; fireballs
		plreq $300, ArtKosPlusM_MZGlass						; glass block
		plreq $31A, ArtKosPlusM_Swing						; swinging platform
		plreq $328, ArtKosPlusM_MZMetal						; chain stomp
		plreq $36D, ArtKosPlusM_LavaWall					; lava wall
		plreq $47C, ArtKosPlusM_MZGrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Secondary)
; ===========================================================================

PLC_MZ2_Secondary: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPlusM_Basaran						; basaran enemy
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_MZBlock						; block
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Primary)
; ===========================================================================

PLC_MZ3_Primary: plrlistheader
		plreq $298, ArtKosPlusM_Fireballs					; fireballs
		plreq $300, ArtKosPlusM_MZGlass						; glass block
		plreq $31A, ArtKosPlusM_Swing						; swinging platform
		plreq $328, ArtKosPlusM_MZMetal						; chain stomp
		plreq $36D, ArtKosPlusM_LavaWall					; lava wall
		plreq $47C, ArtKosPlusM_MZGrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Secondary)
; ===========================================================================

PLC_MZ3_Secondary: plrlistheader
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPlusM_Basaran						; basaran enemy
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_MZBlock						; block
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Primary)
; ===========================================================================

PLC_MZ4_Primary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Marble Zone (Secondary)
; ===========================================================================

PLC_MZ4_Secondary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Primary)
; ===========================================================================

PLC_SYZ1_Primary: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Secondary)
; ===========================================================================

PLC_SYZ1_Secondary: plrlistheader
		plreq $372, ArtKosPlusM_Bumper						; bumper
		plreq $396, ArtKosPlusM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPlusM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPlusM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPlusM_Roller						; roller enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Primary)
; ===========================================================================

PLC_SYZ2_Primary: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Secondary)
; ===========================================================================

PLC_SYZ2_Secondary: plrlistheader
		plreq $372, ArtKosPlusM_Bumper						; bumper
		plreq $396, ArtKosPlusM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPlusM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPlusM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPlusM_Roller						; roller enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Primary)
; ===========================================================================

PLC_SYZ3_Primary: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Secondary)
; ===========================================================================

PLC_SYZ3_Secondary: plrlistheader
		plreq $372, ArtKosPlusM_Bumper						; bumper
		plreq $396, ArtKosPlusM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPlusM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPlusM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPlusM_Crabmeat					; crabmeat enemy
		plreq $440, ArtKosPlusM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPlusM_Roller						; roller enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Primary)
; ===========================================================================

PLC_SYZ4_Primary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Secondary)
; ===========================================================================

PLC_SYZ4_Secondary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Primary)
; ===========================================================================

PLC_LZ1_Primary: plrlistheader
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Secondary)
; ===========================================================================

PLC_LZ1_Secondary: plrlistheader
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
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Primary)
; ===========================================================================

PLC_LZ2_Primary: plrlistheader
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Secondary)
; ===========================================================================

PLC_LZ2_Secondary: plrlistheader
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
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Primary)
; ===========================================================================

PLC_LZ3_Primary: plrlistheader
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Secondary)
; ===========================================================================

PLC_LZ3_Secondary: plrlistheader
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
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Primary)
; ===========================================================================

PLC_LZ4_Primary: plrlistheader
		plreq $478, ArtKosPlusM_GrayButton					; button
		plreq $300, ArtKosPlusM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPlusM_LZBlock1					; block1
		plreq $1F0, ArtKosPlusM_LZBlock2					; block2
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Secondary)
; ===========================================================================

PLC_LZ4_Secondary: plrlistheader
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
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Primary)
; ===========================================================================

PLC_SLZ1_Primary: plrlistheader
		plreq $36A, ArtKosPlusM_Pylon						; pylon
		plreq $414, ArtKosPlusM_SLZBreakableWall				; breakable wall
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Secondary)
; ===========================================================================

PLC_SLZ1_Secondary: plrlistheader
		plreq $37A, ArtKosPlusM_Seesaw						; seesaw
		plreq $3E8, ArtKosPlusM_Fan						; fan
		plreq $41C, ArtKosPlusM_SLZBlock					; block
		plreq $42C, ArtKosPlusM_SLZCannon					; cannon
		plreq $434, ArtKosPlusM_Fireballs					; fireballs
		plreq $4EE, ArtKosPlusM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Primary)
; ===========================================================================

PLC_SLZ2_Primary: plrlistheader
		plreq $36A, ArtKosPlusM_Pylon						; pylon
		plreq $414, ArtKosPlusM_SLZBreakableWall				; breakable wall
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Secondary)
; ===========================================================================

PLC_SLZ2_Secondary: plrlistheader
		plreq $37A, ArtKosPlusM_Seesaw						; seesaw
		plreq $3E8, ArtKosPlusM_Fan						; fan
		plreq $41C, ArtKosPlusM_SLZBlock					; block
		plreq $42C, ArtKosPlusM_SLZCannon					; cannon
		plreq $434, ArtKosPlusM_Fireballs					; fireballs
		plreq $4EE, ArtKosPlusM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Primary)
; ===========================================================================

PLC_SLZ3_Primary: plrlistheader
		plreq $36A, ArtKosPlusM_Pylon						; pylon
		plreq $414, ArtKosPlusM_SLZBreakableWall				; breakable wall
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Secondary)
; ===========================================================================

PLC_SLZ3_Secondary: plrlistheader
		plreq $37A, ArtKosPlusM_Seesaw						; seesaw
		plreq $3A6, ArtKosPlusM_SLZSwing					; swinging platform
		plreq $3E8, ArtKosPlusM_Fan						; fan
		plreq $41C, ArtKosPlusM_SLZBlock					; block
		plreq $42C, ArtKosPlusM_SLZCannon					; cannon
		plreq $434, ArtKosPlusM_Fireballs					; fireballs
		plreq $4EE, ArtKosPlusM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $55B, ArtKosPlusM_Orbinaut					; orbinaut enemy
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Primary)
; ===========================================================================

PLC_SLZ4_Primary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Star Light Zone (Secondary)
; ===========================================================================

PLC_SLZ4_Secondary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Primary)
; ===========================================================================

PLC_SBZ1_Primary: plrlistheader
		plreq $2AA, ArtKosPlusM_SBZFloor					; floor
		plreq $2B2, ArtKosPlusM_Stomper						; stomper
		plreq $2DA, ArtKosPlusM_Girder						; girder
		plreq $31B, ArtKosPlusM_SBZWheel2					; wheel 2
		plreq $364, ArtKosPlusM_SBZBlock					; block
		plreq $380, ArtKosPlusM_SlideFloor					; slide floor
		plreq $38F, ArtKosPlusM_SBZDoor2					; door 2
		plreq $3A4, ArtKosPlusM_Cutter						; saw (cutter)
		plreq $3C8, ArtKosPlusM_SpinPlatform					; spinning platform
		plreq $3F8, ArtKosPlusM_TrapDoor					; trap door
		plreq $470, ArtKosPlusM_SBZDoor1					; door
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Secondary)
; ===========================================================================

PLC_SBZ1_Secondary: plrlistheader
		plreq $2EC, ArtKosPlusM_BallHog						; ball hog enemy
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $529, ArtKosPlusM_Electric					; electrocution orbs
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_FlamePipe					; flame pipe
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Primary)
; ===========================================================================

PLC_SBZ2_Primary: plrlistheader
		plreq $2AA, ArtKosPlusM_SBZFloor					; floor
		plreq $2B2, ArtKosPlusM_Stomper						; stomper
		plreq $364, ArtKosPlusM_SBZBlock					; block
		plreq $380, ArtKosPlusM_SlideFloor					; slide floor
		plreq $38F, ArtKosPlusM_SBZDoor2					; door 2
		plreq $3A0, ArtKosPlusM_SBZWheel1					; wheel 1
		plreq $3A4, ArtKosPlusM_Cutter						; saw (cutter)
		plreq $3C8, ArtKosPlusM_SpinPlatform					; spinning platform
		plreq $3F8, ArtKosPlusM_TrapDoor					; trap door
		plreq $448, ArtKosPlusM_LargeSpikeball					; large spike ball
		plreq $470, ArtKosPlusM_SBZDoor1					; door
		plreq $478, ArtKosPlusM_GrayButton					; button
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Secondary)
; ===========================================================================

PLC_SBZ2_Secondary: plrlistheader
		plreq $2EC, ArtKosPlusM_BallHog						; ball hog enemy
		plreq $500, ArtKosPlusM_Bomb						; bomb enemy
		plreq $529, ArtKosPlusM_Electric					; electrocution orbs
		plreq $552, ArtKosPlusM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPlusM_FlamePipe					; flame pipe
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Final Zone (Primary)
; ===========================================================================

PLC_SBZ3_Primary: plrlistheader
		plreq $300, ArtKosPlusM_FZBoss						; final boss
		plreq $3A0, ArtKosPlusM_RobotnikShip1					; robotnik ship
		plreq $420, ArtKosPlusM_RobotnikShipStand				; robotnik ship stand
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Final Zone (Secondary)
; ===========================================================================

PLC_SBZ3_Secondary: plrlistheader
		plreq $500, ArtKosPlusM_BossExplosion					; boss explosion
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Primary)
; ===========================================================================

PLC_SBZ4_Primary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Secondary)
; ===========================================================================

PLC_SBZ4_Secondary: plrlistheader
		plrlistend								; end marker

; ===========================================================================
; Level pattern load cues
; Load animals graphics
; ===========================================================================

; ===========================================================================
; Pattern load cues - Animals (GHZ1)
; ===========================================================================

PLC_Animals_GHZ1: plrlistheader
		plreq $580, ArtKosPlusM_Rabbit						; rabbit animal
		plreq $592, ArtKosPlusM_BlueFlicky					; blue flicky animal
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Animals (MZ1)
; ===========================================================================

PLC_Animals_MZ1: plrlistheader
		plreq $580, ArtKosPlusM_Squirrel					; squirrel animal
		plreq $592, ArtKosPlusM_Seal						; seal animal
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Animals (SYZ1)
; ===========================================================================

PLC_Animals_SYZ1: plrlistheader
		plreq $580, ArtKosPlusM_Pig						; pig animal
		plreq $592, ArtKosPlusM_Chicken						; chicken animal
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Animals (LZ1)
; ===========================================================================

PLC_Animals_LZ1: plrlistheader
		plreq $580, ArtKosPlusM_Penguin						; penguin animal
		plreq $592, ArtKosPlusM_Seal						; seal animal
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Animals (SLZ1)
; ===========================================================================

PLC_Animals_SLZ1: plrlistheader
		plreq $580, ArtKosPlusM_Pig						; pig animal
		plreq $592, ArtKosPlusM_BlueFlicky					; blue flicky animal
		plrlistend								; end marker

; ===========================================================================
; Pattern load cues - Animals (SBZ1)
; ===========================================================================

PLC_Animals_SBZ1: plrlistheader
		plreq $580, ArtKosPlusM_Rabbit						; rabbit animal
		plreq $592, ArtKosPlusM_Chicken						; chicken animal
		plrlistend								; end marker
