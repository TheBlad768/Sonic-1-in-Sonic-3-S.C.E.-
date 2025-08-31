; ---------------------------------------------------------------------------
; SLZ debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_SLZ1: dbglistheader
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
	dbglistobj Obj_Elevator, Map_Elev, 0, 0, 0, 2, FALSE
	dbglistobj Obj_CollapseFloor, Map_CFlo, 0, 2, $41C, 2, FALSE
	dbglistobj Obj_FloatingPlatform, Map_Plat_SLZ, 0, 0, 0, 2, FALSE
	dbglistobj Obj_CirclingPlatform, Map_Circ, 0, 0, 0, 2, FALSE
	dbglistobj Obj_Staircase, Map_Offscreen, 0, 0, 0, 2, FALSE
	dbglistobj Obj_Fan, Map_Fan, 0, 0, $3E8, 2, FALSE
	dbglistobj Obj_Seesaw, Map_Seesaw, 0, 0, $37A, 0, FALSE
	dbglistobj Obj_LavaMaker, Map_Fire, 0, 0, $434, 0, FALSE
	dbglistobj Obj_StillSprite, Map_StillSprites, 3, 3, $42C, 2, FALSE
	dbglistobj Obj_BombBadnik, Map_Bomb, 0, 0, $500, 0, FALSE
	dbglistobj Obj_Orbinaut, Map_Orb, 2, 0, $55B, 1, FALSE
	dbglistobj Obj_Animal, Map_Animals1, 0, 2, $592, 0, FALSE
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, $5EC, 0, FALSE
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
	dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
Debug_SLZ1_end
