; ===========================================================================
; Level pattern load cues
; Load main graphics
; ===========================================================================

; ===========================================================================
; Pattern load cues - Sonic
; ===========================================================================

PLC1_Sonic: plrlistheader
		plreq ArtTile_StarPost, ArtKosPM_EnemyPtsStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPM_Ring_Sparks				; rings
		plreq ArtTile_HUD, ArtKosPM_HUD						; HUD
		plreq ArtTile_LifeIcon, ArtKosPM_SonicLifeIcon				; life icon
PLC1_Sonic_end

; ===========================================================================
; Pattern load cues - Miles
; ===========================================================================

PLC1_Miles: plrlistheader
		plreq ArtTile_StarPost, ArtKosPM_EnemyPtsStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPM_Ring_Sparks				; rings
		plreq ArtTile_HUD, ArtKosPM_HUD						; HUD
		plreq ArtTile_LifeIcon, ArtKosPM_MilesLifeIcon				; life icon
PLC1_Miles_end

; ===========================================================================
; Pattern load cues - Tails
; ===========================================================================

PLC1_Tails: plrlistheader
		plreq ArtTile_StarPost, ArtKosPM_EnemyPtsStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPM_Ring_Sparks				; rings
		plreq ArtTile_HUD, ArtKosPM_HUD						; HUD
		plreq ArtTile_LifeIcon, ArtKosPM_TailsLifeIcon				; life icon
PLC1_Tails_end

; ===========================================================================
; Pattern load cues - Knuckles
; ===========================================================================

PLC1_Knuckles: plrlistheader
		plreq ArtTile_StarPost, ArtKosPM_EnemyPtsStarPost			; starpost
		plreq ArtTile_Ring_Sparks, ArtKosPM_Ring_Sparks				; rings
		plreq ArtTile_HUD, ArtKosPM_HUD						; HUD
		plreq ArtTile_LifeIcon, ArtKosPM_KnucklesLifeIcon			; life icon
PLC1_Knuckles_end

; ===========================================================================
; Pattern load cues 2 - Sonic
; ===========================================================================

PLC2_Sonic: plrlistheader
		plreq ArtTile_SpikesSprings, ArtKosPM_SpikesSprings			; spikes and normal spring
		plreq ArtTile_Monitors, ArtKosPM_Monitors				; monitors
		plreq ArtTile_Explosion, ArtKosPM_Explosion				; explosion
PLC2_Sonic_end

; ===========================================================================
; Pattern load cues 2 - Knuckles
; ===========================================================================

PLC2_Knuckles: plrlistheader
		plreq ArtTile_SpikesSprings, ArtKosPM_SpikesSprings			; spikes and normal spring
		plreq ArtTile_Monitors, ArtKosPM_Monitors				; monitors
		plreq ArtTile_Monitors+$1C, ArtKosPM_MonitorsEggRobo			; monitors (Egg Robo)
		plreq ArtTile_Explosion, ArtKosPM_Explosion				; explosion
PLC2_Knuckles_end

; ===========================================================================
; Level pattern load cues
; Load graphics before and after Title Card
; ===========================================================================

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ1_Before: plrlistheader
		plreq $33E, ArtKosPM_Bridge						; bridge
		plreq $3A4, ArtKosPM_GHZEdgeWalls					; edge wall
		plreq $380, ArtKosPM_PplRock						; purple rock
PLC1_GHZ1_Before_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ1_After: plrlistheader
		plreq $3FC, ArtKosPM_Crabmeat						; crabmeat enemy
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $4EC, ArtKosPM_Chopper						; chopper enemy
		plreq $50C, ArtKosPM_Newtron						; newtron enemy
		plreq $561, ArtKosPM_Motobug						; motobug enemy
PLC2_GHZ1_After_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ2_Before: plrlistheader
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $3C2, ArtKosPM_Swing						; swinging platform
		plreq $33E, ArtKosPM_Bridge						; bridge
		plreq $398, ArtKosPM_GHZBreakableWall					; breakable wall
		plreq $3A4, ArtKosPM_GHZEdgeWalls					; edge wall
		plreq $380, ArtKosPM_PplRock						; purple rock
PLC1_GHZ2_Before_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ2_After: plrlistheader
		plreq $3FC, ArtKosPM_Crabmeat						; crabmeat enemy
		plreq $4EC, ArtKosPM_Chopper						; chopper enemy
		plreq $50C, ArtKosPM_Newtron						; newtron enemy
		plreq $561, ArtKosPM_Motobug						; motobug enemy
PLC2_GHZ2_After_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ3_Before: plrlistheader
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $3A4, ArtKosPM_GHZEdgeWalls					; edge wall
		plreq $3B0, ArtKosPM_SpikePole						; spike pole
		plreq $3C2, ArtKosPM_Swing						; swinging platform
		plreq $33E, ArtKosPM_Bridge						; bridge
		plreq $398, ArtKosPM_GHZBreakableWall					; breakable wall
		plreq $380, ArtKosPM_PplRock						; purple rock
PLC1_GHZ3_Before_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ3_After: plrlistheader
		plreq $3FC, ArtKosPM_Crabmeat						; crabmeat enemy
		plreq $4EC, ArtKosPM_Chopper						; chopper enemy
		plreq $50C, ArtKosPM_Newtron						; newtron enemy
		plreq $561, ArtKosPM_Motobug						; motobug enemy
PLC2_GHZ3_After_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (Before)
; ===========================================================================

PLC1_GHZ4_Before: plrlistheader
PLC1_GHZ4_Before_end

; ===========================================================================
; Pattern load cues - Green Hill Zone (After)
; ===========================================================================

PLC2_GHZ4_After: plrlistheader
PLC2_GHZ4_After_end

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ1_Before: plrlistheader
		plreq $298, ArtKosPM_Fireballs						; fireballs
		plreq $300, ArtKosPM_MZGlass						; glass block
		plreq $31A, ArtKosPM_Swing						; swinging platform
		plreq $328, ArtKosPM_MZMetal						; chain stomp
		plreq $47C, ArtKosPM_MZGrayButton					; button
PLC1_MZ1_Before_end

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ1_After: plrlistheader
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPM_Basaran						; basaran enemy
		plreq $552, ArtKosPM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPM_MZBlock						; block
PLC2_MZ1_After_end

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ2_Before: plrlistheader
		plreq $298, ArtKosPM_Fireballs						; fireballs
		plreq $300, ArtKosPM_MZGlass						; glass block
		plreq $31A, ArtKosPM_Swing						; swinging platform
		plreq $328, ArtKosPM_MZMetal						; chain stomp
		plreq $36D, ArtKosPM_LavaWall						; lava wall
		plreq $47C, ArtKosPM_MZGrayButton					; button
PLC1_MZ2_Before_end

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ2_After: plrlistheader
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPM_Basaran						; basaran enemy
		plreq $552, ArtKosPM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPM_MZBlock						; block
PLC2_MZ2_After_end

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ3_Before: plrlistheader
		plreq $298, ArtKosPM_Fireballs						; fireballs
		plreq $300, ArtKosPM_MZGlass						; glass block
		plreq $31A, ArtKosPM_Swing						; swinging platform
		plreq $328, ArtKosPM_MZMetal						; chain stomp
		plreq $36D, ArtKosPM_LavaWall						; lava wall
		plreq $47C, ArtKosPM_MZGrayButton					; button
PLC1_MZ3_Before_end

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ3_After: plrlistheader
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $529, ArtKosPM_Basaran						; basaran enemy
		plreq $552, ArtKosPM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPM_MZBlock						; block
PLC2_MZ3_After_end

; ===========================================================================
; Pattern load cues - Marble Zone (Before)
; ===========================================================================

PLC1_MZ4_Before: plrlistheader
PLC1_MZ4_Before_end

; ===========================================================================
; Pattern load cues - Marble Zone (After)
; ===========================================================================

PLC2_MZ4_After: plrlistheader
PLC2_MZ4_After_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ1_Before: plrlistheader
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_SYZ1_Before_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ1_After: plrlistheader
		plreq $372, ArtKosPM_Bumper						; bumper
		plreq $396, ArtKosPM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPM_Crabmeat						; crabmeat enemy
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPM_Roller						; roller enemy
PLC2_SYZ1_After_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ2_Before: plrlistheader
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_SYZ2_Before_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ2_After: plrlistheader
		plreq $372, ArtKosPM_Bumper						; bumper
		plreq $396, ArtKosPM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPM_Crabmeat						; crabmeat enemy
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPM_Roller						; roller enemy
PLC2_SYZ2_After_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ3_Before: plrlistheader
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_SYZ3_Before_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ3_After: plrlistheader
		plreq $372, ArtKosPM_Bumper						; bumper
		plreq $396, ArtKosPM_LargeSpikeball					; large spikeball
		plreq $3BA, ArtKosPM_SmallSpikeball					; small spikeball
		plreq $3BE, ArtKosPM_Yadrin						; yadrin enemy
		plreq $3FC, ArtKosPM_Crabmeat						; crabmeat enemy
		plreq $440, ArtKosPM_Buzz						; buzz bomber enemy
		plreq $4F0, ArtKosPM_Roller						; roller enemy
PLC2_SYZ3_After_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (Before)
; ===========================================================================

PLC1_SYZ4_Before: plrlistheader
PLC1_SYZ4_Before_end

; ===========================================================================
; Pattern load cues - Spring Yard Zone (After)
; ===========================================================================

PLC2_SYZ4_After: plrlistheader
PLC2_SYZ4_After_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ1_Before: plrlistheader
		plreq $300, ArtKosPM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPM_LZBlock1						; block1
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_LZ1_Before_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ1_After: plrlistheader
		plreq $259, ArtKosPM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPM_Gargoyle						; gargoyle
		plreq $310, ArtKosPM_SpikedBallandChain					; small spikeball
		plreq $328, ArtKosPM_FlappingDoor					; flapping door
		plreq $348, ArtKosPM_Bubbles						; bubbles
		plreq $3BC, ArtKosPM_LZBlock3						; block3
		plreq $3C4, ArtKosPM_LZDoor1						; door1
		plreq $3CC, ArtKosPM_Harpoon						; harpoon
		plreq $3DE, ArtKosPM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPM_LZDoor2						; door2
		plreq $406, ArtKosPM_LabyrinthConveyor					; conveyor (platform only)
		plreq $44F, ArtKosPM_LZPlatform						; platform
		plreq $467, ArtKosPM_Cork						; cork
		plreq $4F0, ArtKosPM_Jaws						; jaws enemy
		plreq $510, ArtKosPM_Burrobot						; burrobot enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_LZ1_After_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ2_Before: plrlistheader
		plreq $300, ArtKosPM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPM_LZBlock1						; block1
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_LZ2_Before_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ2_After: plrlistheader
		plreq $259, ArtKosPM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPM_Gargoyle						; gargoyle
		plreq $310, ArtKosPM_SpikedBallandChain					; small spikeball
		plreq $328, ArtKosPM_FlappingDoor					; flapping door
		plreq $348, ArtKosPM_Bubbles						; bubbles
		plreq $3BC, ArtKosPM_LZBlock3						; block3
		plreq $3C4, ArtKosPM_LZDoor1						; door1
		plreq $3CC, ArtKosPM_Harpoon						; harpoon
		plreq $3DE, ArtKosPM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPM_LZDoor2						; door2
		plreq $406, ArtKosPM_LabyrinthConveyor					; conveyor (platform only)
		plreq $44F, ArtKosPM_LZPlatform						; platform
		plreq $467, ArtKosPM_Cork						; cork
		plreq $4F0, ArtKosPM_Jaws						; jaws enemy
		plreq $510, ArtKosPM_Burrobot						; burrobot enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_LZ2_After_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ3_Before: plrlistheader
		plreq $300, ArtKosPM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPM_LZBlock1						; block1
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_LZ3_Before_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ3_After: plrlistheader
		plreq $259, ArtKosPM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPM_Gargoyle						; gargoyle
		plreq $310, ArtKosPM_SpikedBallandChain					; small spikeball
		plreq $328, ArtKosPM_FlappingDoor					; flapping door
		plreq $348, ArtKosPM_Bubbles						; bubbles
		plreq $3BC, ArtKosPM_LZBlock3						; block3
		plreq $3C4, ArtKosPM_LZDoor1						; door1
		plreq $3CC, ArtKosPM_Harpoon						; harpoon
		plreq $3DE, ArtKosPM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPM_LZDoor2						; door2
		plreq $406, ArtKosPM_LabyrinthConveyor					; conveyor (platform only)
		plreq $44F, ArtKosPM_LZPlatform						; platform
		plreq $467, ArtKosPM_Cork						; cork
		plreq $4F0, ArtKosPM_Jaws						; jaws enemy
		plreq $510, ArtKosPM_Burrobot						; burrobot enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_LZ3_After_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (Before)
; ===========================================================================

PLC1_LZ4_Before: plrlistheader
		plreq $478, ArtKosPM_GrayButton						; button
		plreq $300, ArtKosPM_WaveSplashLZ					; wave splash
		plreq $1E0, ArtKosPM_LZBlock1						; block1
		plreq $1F0, ArtKosPM_LZBlock2						; block2
PLC1_LZ4_Before_end

; ===========================================================================
; Pattern load cues - Labyrinth Zone (After)
; ===========================================================================

PLC2_LZ4_After: plrlistheader
		plreq $259, ArtKosPM_WaterSplashes					; water and splashes
		plreq $2E9, ArtKosPM_Gargoyle						; gargoyle
		plreq $310, ArtKosPM_SpikedBallandChain					; small spikeball
		plreq $328, ArtKosPM_FlappingDoor					; flapping door
		plreq $348, ArtKosPM_Bubbles						; bubbles
		plreq $3BC, ArtKosPM_LZBlock3						; block3
		plreq $3C4, ArtKosPM_LZDoor1						; door1
		plreq $3CC, ArtKosPM_Harpoon						; harpoon
		plreq $3DE, ArtKosPM_BreakablePole					; breakable pole
		plreq $3E6, ArtKosPM_LZDoor2						; door2
		plreq $44F, ArtKosPM_LZPlatform						; platform
		plreq $467, ArtKosPM_Cork						; cork
		plreq $4F0, ArtKosPM_Jaws						; jaws enemy
		plreq $510, ArtKosPM_Burrobot						; burrobot enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_LZ4_After_end

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ1_Before: plrlistheader
		plreq $36A, ArtKosPM_Pylon						; pylon
		plreq $414, ArtKosPM_SLZBreakableWall					; breakable wall
PLC1_SLZ1_Before_end

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ1_After: plrlistheader
		plreq $37A, ArtKosPM_Seesaw						; seesaw
		plreq $3E8, ArtKosPM_Fan						; fan
		plreq $41C, ArtKosPM_SLZBlock						; block
		plreq $42C, ArtKosPM_SLZCannon						; cannon
		plreq $434, ArtKosPM_Fireballs						; fireballs
		plreq $4EE, ArtKosPM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPM_Bomb						; bomb enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_SLZ1_After_end

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ2_Before: plrlistheader
		plreq $36A, ArtKosPM_Pylon						; pylon
		plreq $414, ArtKosPM_SLZBreakableWall					; breakable wall
PLC1_SLZ2_Before_end

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ2_After: plrlistheader
		plreq $37A, ArtKosPM_Seesaw						; seesaw
		plreq $3E8, ArtKosPM_Fan						; fan
		plreq $41C, ArtKosPM_SLZBlock						; block
		plreq $42C, ArtKosPM_SLZCannon						; cannon
		plreq $434, ArtKosPM_Fireballs						; fireballs
		plreq $4EE, ArtKosPM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPM_Bomb						; bomb enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_SLZ2_After_end

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ3_Before: plrlistheader
		plreq $36A, ArtKosPM_Pylon						; pylon
		plreq $414, ArtKosPM_SLZBreakableWall					; breakable wall
PLC1_SLZ3_Before_end

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ3_After: plrlistheader
		plreq $37A, ArtKosPM_Seesaw						; seesaw
		plreq $3A6, ArtKosPM_SLZSwing						; swinging platform
		plreq $3E8, ArtKosPM_Fan						; fan
		plreq $41C, ArtKosPM_SLZBlock						; block
		plreq $42C, ArtKosPM_SLZCannon						; cannon
		plreq $434, ArtKosPM_Fireballs						; fireballs
		plreq $4EE, ArtKosPM_LittleSpikeball					; little spikeball
		plreq $500, ArtKosPM_Bomb						; bomb enemy
		plreq $55B, ArtKosPM_Orbinaut						; orbinaut enemy
PLC2_SLZ3_After_end

; ===========================================================================
; Pattern load cues - Star Light Zone (Before)
; ===========================================================================

PLC1_SLZ4_Before: plrlistheader
PLC1_SLZ4_Before_end

; ===========================================================================
; Pattern load cues - Star Light Zone (After)
; ===========================================================================

PLC2_SLZ4_After: plrlistheader
PLC2_SLZ4_After_end

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Before)
; ===========================================================================

PLC1_SBZ1_Before: plrlistheader
		plreq $2AA, ArtKosPM_SBZFloor
		plreq $2B2, ArtKosPM_Stomper
		plreq $2DA, ArtKosPM_Girder
		plreq $31B, ArtKosPM_SBZWheel2
		plreq $364, ArtKosPM_SBZBlock
		plreq $380, ArtKosPM_SlideFloor
		plreq $38F, ArtKosPM_SBZDoor2
		plreq $3A4, ArtKosPM_Cutter
		plreq $3C8, ArtKosPM_SpinPform
		plreq $3F8, ArtKosPM_TrapDoor
		plreq $470, ArtKosPM_SBZDoor1
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_SBZ1_Before_end

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (After)
; ===========================================================================

PLC2_SBZ1_After: plrlistheader
		plreq $2EC, ArtKosPM_BallHog						; ball hog enemy
		plreq $429, ArtKosPM_Orbinaut						; orbinaut enemy
		plreq $500, ArtKosPM_Bomb						; bomb enemy
		plreq $529, ArtKosPM_Electric						; electrocution orbs
		plreq $552, ArtKosPM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPM_FlamePipe						; flame pipe
PLC2_SBZ1_After_end

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Before)
; ===========================================================================

PLC1_SBZ2_Before: plrlistheader
		plreq $2AA, ArtKosPM_SBZFloor
		plreq $2B2, ArtKosPM_Stomper
		plreq $364, ArtKosPM_SBZBlock
		plreq $380, ArtKosPM_SlideFloor
		plreq $38F, ArtKosPM_SBZDoor2
		plreq $3A0, ArtKosPM_SBZWheel1
		plreq $3A4, ArtKosPM_Cutter
		plreq $3C8, ArtKosPM_SpinPform
		plreq $3F8, ArtKosPM_TrapDoor
		plreq $448, ArtKosPM_LargeSpikeball
		plreq $470, ArtKosPM_SBZDoor1
		plreq $478, ArtKosPM_GrayButton						; button
PLC1_SBZ2_Before_end

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (After)
; ===========================================================================

PLC2_SBZ2_After: plrlistheader
		plreq $2EC, ArtKosPM_BallHog						; ball hog enemy
		plreq $429, ArtKosPM_Orbinaut						; orbinaut enemy
		plreq $500, ArtKosPM_Bomb						; bomb enemy
		plreq $529, ArtKosPM_Electric						; electrocution orbs
		plreq $552, ArtKosPM_Caterkiller					; caterkiller enemy
		plreq $562, ArtKosPM_FlamePipe						; flame pipe
PLC2_SBZ2_After_end

; ===========================================================================
; Pattern load cues - Scrap Brain Final Zone (Before)
; ===========================================================================

PLC1_SBZ3_Before: plrlistheader
		plreq $300, ArtKosPM_FZBoss						; final boss
		plreq $3A0, ArtKosPM_RobotnikShip1					; robotnik ship
		plreq $420, ArtKosPM_RobotnikShipStand					; robotnik ship stand
PLC1_SBZ3_Before_end

; ===========================================================================
; Pattern load cues - Scrap Brain Final Zone (After)
; ===========================================================================

PLC2_SBZ3_After: plrlistheader
		plreq $500, ArtKosPM_BossExplosion					; boss explosion
PLC2_SBZ3_After_end

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (Before)
; ===========================================================================

PLC1_SBZ4_Before: plrlistheader
PLC1_SBZ4_Before_end

; ===========================================================================
; Pattern load cues - Scrap Brain Zone (After)
; ===========================================================================

PLC2_SBZ4_After: plrlistheader
PLC2_SBZ4_After_end

; ===========================================================================
; Level pattern load cues
; Load animals graphics
; ===========================================================================

; ===========================================================================
; Pattern load cues - Animals (GHZ1)
; ===========================================================================

PLCAnimals_GHZ1: plrlistheader
		plreq $580, ArtKosPM_Rabbit
		plreq $592, ArtKosPM_BlueFlicky
PLCAnimals_GHZ1_end

; ===========================================================================
; Pattern load cues - Animals (MZ1)
; ===========================================================================

PLCAnimals_MZ1: plrlistheader
		plreq $580, ArtKosPM_Squirrel
		plreq $592, ArtKosPM_Seal
PLCAnimals_MZ1_end

; ===========================================================================
; Pattern load cues - Animals (SYZ1)
; ===========================================================================

PLCAnimals_SYZ1: plrlistheader
		plreq $580, ArtKosPM_Pig
		plreq $592, ArtKosPM_Chicken
PLCAnimals_SYZ1_end

; ===========================================================================
; Pattern load cues - Animals (LZ1)
; ===========================================================================

PLCAnimals_LZ1: plrlistheader
		plreq $580, ArtKosPM_Penguin
		plreq $592, ArtKosPM_Seal
PLCAnimals_LZ1_end

; ===========================================================================
; Pattern load cues - Animals (SLZ1)
; ===========================================================================

PLCAnimals_SLZ1: plrlistheader
		plreq $580, ArtKosPM_Pig
		plreq $592, ArtKosPM_BlueFlicky
PLCAnimals_SLZ1_end

; ===========================================================================
; Pattern load cues - Animals (SBZ1)
; ===========================================================================

PLCAnimals_SBZ1: plrlistheader
		plreq $580, ArtKosPM_Rabbit
		plreq $592, ArtKosPM_Chicken
PLCAnimals_SBZ1_end
