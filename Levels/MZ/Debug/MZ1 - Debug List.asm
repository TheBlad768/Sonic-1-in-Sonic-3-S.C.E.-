; ---------------------------------------------------------------------------
; MZ debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_MZ1: dbglistheader
	dbglistobj Obj_Ring, Map_Ring, 0, 0, ArtTile_Ring, 1, TRUE
	dbglistobj Obj_Monitor, Map_Monitor, 1, 2, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 2, 3, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 3, 4, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 4, 5, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 5, 6, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 6, 7, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 7, 8, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 8, 9, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, $A, $B, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_Monitor, Map_Monitor, 9, $A, ArtTile_Monitors, 0, FALSE
	dbglistobj Obj_PathSwap, Map_PathSwap, 9, 1, ArtTile_Ring, 1, FALSE
	dbglistobj Obj_PathSwap, Map_PathSwap, $D, 5, ArtTile_Ring, 1, FALSE
	dbglistobj Obj_Spring, Map_Spring, $81, 0, ArtTile_SpikesSprings+$10, 0, FALSE
	dbglistobj Obj_Spring, Map_Spring2, $82, 0, ArtTile_SpikesSprings+$10, 0, FALSE
	dbglistobj Obj_Spring, Map_Spring, $90, 3, ArtTile_SpikesSprings+$1C, 0, FALSE
	dbglistobj Obj_Spring, Map_Spring2, $92, 3, ArtTile_SpikesSprings+$1C, 0, FALSE
	dbglistobj Obj_Spring, Map_Spring, $A0, 6, ArtTile_SpikesSprings+$10, 0, FALSE
	dbglistobj Obj_Spring, Map_Spring2, $A2, 6, ArtTile_SpikesSprings+$10, 0, FALSE
	dbglistobj Obj_Spikes, Map_Spikes, 0, 0, ArtTile_SpikesSprings+8, 0, FALSE
	dbglistobj Obj_Spikes, Map_Spikes, $10, 1, ArtTile_SpikesSprings, 0, FALSE
	dbglistobj Obj_BuzzBomber, Map_Buzz, 0, 0, $440, 0, FALSE
	dbglistobj Obj_ChainStomp, Map_CStom, $13, $A, $328, 0, FALSE
	dbglistobj Obj_ChainStomp, Map_CStom, $23, $B, $328, 0, FALSE
	dbglistobj Obj_SideStomp, Map_SStom, 0, 0, $328, 0, FALSE
	dbglistobj Obj_GlassBlock, Map_Glass, 0, 0, $300, 2, TRUE
	dbglistobj Obj_LavaMaker, Map_Fire, 0, 0, $298, 0, FALSE
	dbglistobj Obj_MarbleBrick, Map_Offscreen, 0, 0, 0, 2, FALSE
	dbglistobj Obj_StillSprite, Map_StillSprites, 1, 1, 1, 2, FALSE
	dbglistobj Obj_GeyserMaker, Map_Geyser, 0, 0, $36D, 3, FALSE
	dbglistobj Obj_LavaWall, Map_LWall, 0, 0, $36D, 3, FALSE
	dbglistobj Obj_PushableBlock, Map_Push, 0, 0, $562, 2, FALSE
	dbglistobj Obj_SmashBlock, Map_Smab, 0, 0, $562, 2, FALSE
	dbglistobj Obj_MovingBlock, Map_MBlock, 0, 0, $562, 2, FALSE
	dbglistobj Obj_CollapseFloor, Map_CFlo, 0, 0, $562, 2, FALSE
	dbglistobj Obj_Invisible_LavaBlock, Map_InvisibleBlock, 0, 0, ArtTile_Monitors, 0, TRUE
	dbglistobj Obj_Basaran, Map_Bas, 0, 0, $529, 0, TRUE
	dbglistobj Obj_Caterkiller, Map_Cat, 0, 0, $552, 1, FALSE
	dbglistobj Obj_Animal, Map_Animals4, 0, 2, $592, 0, FALSE
	dbglistobj Obj_Button, Map_Button, 0, 0, $47C, 2, FALSE
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, $5EC, 0, FALSE
	dbglistobj Obj_BigRing, Map_BigRing, 1, 0, ArtTile_Explosion, 1, FALSE
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
	dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
Debug_MZ1_end
