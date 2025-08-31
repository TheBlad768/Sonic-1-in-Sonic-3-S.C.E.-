; ---------------------------------------------------------------------------
; GHZ debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_GHZ1: dbglistheader
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
	dbglistobj Obj_Crabmeat, Map_Crab, 0, 0, $3FC, 0, FALSE
	dbglistobj Obj_BuzzBomber, Map_Buzz, 0, 0, $440, 0, FALSE
	dbglistobj Obj_Chopper, Map_Chop, 0, 0, $4EC, 0, FALSE
	dbglistobj Obj_FloatingPlatform, Map_Plat_GHZ, 0, 0, 0, 2, FALSE
	dbglistobj Obj_CollapsingPlatform, Map_CollapsingPlatform, 0, 0, 0, 2, FALSE
	dbglistobj Obj_PurpleRock, Map_PRock, 0, 0, $380, 3, FALSE
	dbglistobj Obj_MotoBug, Map_Moto, 0, 0, $561, 0, FALSE
	dbglistobj Obj_Newtron, Map_Newt, 0, 0, $50C, 0, FALSE
	dbglistobj Obj_Newtron, Map_Newt, 1, 0, $50C, 1, FALSE
	dbglistobj Obj_Animal, Map_Animals1, 0, 2, $592, 0, FALSE
	dbglistobj Obj_StillSprite, Map_StillSprites, 0, 0, $342, 2, FALSE
	dbglistobj Obj_TensionBridge, Map_TensionBridge, $C, 0, $33E, 2, FALSE
	dbglistobj Obj_EdgeWalls, Map_EdgeWalls, 0, 0, $3A4, 2, FALSE
	dbglistobj Obj_SwingingPlatform, Map_Swing_GHZ, 7, 0, $3C2, 0, FALSE
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, $5EC, 0, FALSE
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
	dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
Debug_GHZ1_end
