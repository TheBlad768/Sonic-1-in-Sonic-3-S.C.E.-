; ---------------------------------------------------------------------------
; SLZ debug mode item lists
; ---------------------------------------------------------------------------

Debug_SLZ1: dbglistheader

		; object, mappings, subtype, frame, VRAM, palette, priority
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
		dbglistobj Obj_Spring, Map_Spring, 1, 0, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring, $81, 0, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring2, 2, 0, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring2, $82, 0, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring, $10, 3, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring, $90, 3, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring2, $12, 3, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring2, $92, 3, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring, $20, 6, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring, $A0, 6, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring2, $22, 6, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spring, Map_Spring2, $A2, 6, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spikes, Map_Spikes, 0, 0, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Spikes, Map_Spikes, $10, 1, ArtTile_SpikesSprings, 0, FALSE
		dbglistobj Obj_Elevator, Map_Elevator, 0, 0, 0, 2, FALSE
		dbglistobj Obj_CollapseFloor, Map_CollapseFloor, 0, 2, $41C, 2, FALSE
		dbglistobj Obj_FloatingPlatform, Map_FloatingPlatform_SLZ, 0, 0, 0, 2, FALSE
		dbglistobj Obj_CirclingPlatform, Map_CirclingPlatform, 0, 0, 0, 2, FALSE
		dbglistobj Obj_Staircase, Map_Offscreen, 0, 0, 0, 2, FALSE
		dbglistobj Obj_Fan, Map_Fan, 0, 0, $3E8, 2, FALSE
		dbglistobj Obj_Seesaw, Map_Seesaw, 0, 0, $37A, 0, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 1, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 2, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 3, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 4, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 5, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 6, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 7, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 8, 0, $3A6, 2, FALSE
		dbglistobj Obj_SwingingPlatform, Map_SwingingPlatform_SLZ, 9, 0, $3A6, 2, FALSE
		dbglistobj Obj_LavaMaker, Map_LavaBall, 0, 0, $434, 0, FALSE
		dbglistobj Obj_StillSprite, Map_StillSprites, 4, 4, $42C, 2, FALSE
		dbglistobj Obj_Bomb, Map_Bomb, 0, 0, $500, 0, FALSE
		dbglistobj Obj_Orbinaut, Map_Orbinaut, 2, 0, $55B, 1, FALSE
		dbglistobj Obj_Animal, Map_Animals1, 0, 2, $592, 0, FALSE
		dbglistobj Obj_StarPost, Map_StarPost, 1, 0, ArtTile_StarPost, 0, FALSE
		dbglistobj Obj_BigRing, Map_BigRing, 1, 0, ArtTile_Explosion, 1, FALSE
		dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
		dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
		dbglistend								; end marker
