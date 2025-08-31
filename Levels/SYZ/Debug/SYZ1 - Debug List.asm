; ---------------------------------------------------------------------------
; SYZ debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_SYZ1: dbglistheader
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
	dbglistobj Obj_Roller, Map_Roll, 0, 0, $4F0, 0, FALSE
	dbglistobj Obj_StillSprite, Map_StillSprites, 2, 2, $11, 0, FALSE
	dbglistobj Obj_Bumper, Map_Bump, 0, 0, $372, 0, FALSE
	dbglistobj Obj_Crabmeat, Map_Crab, 0, 0, $3FC, 0, FALSE
	dbglistobj Obj_BuzzBomber, Map_Buzz, 0, 0, $440, 0, FALSE
	dbglistobj Obj_Yadrin, Map_Yad, 0, 0, $3BE, 1, FALSE
	dbglistobj Obj_Animal, Map_Animals1, 0, 2, $592, 0, FALSE
	dbglistobj Obj_FloatingPlatform, Map_Plat_SYZ, 0, 0, 0, 2, FALSE
	dbglistobj Obj_FloatingBlock, Map_FBlock, 0, 0, 0, 2, FALSE
	dbglistobj Obj_Button, Map_Button, 0, 0, $47C, 0, FALSE
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, $5EC, 0, FALSE
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
	dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
Debug_SYZ1_end
