; ---------------------------------------------------------------------------
; SBZ debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_SBZ1: dbglistheader
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
	dbglistobj Obj_BombBadnik, Map_Bomb, 0, 0, $500, 0, FALSE
	dbglistobj Obj_Orbinaut, Map_Orb, 0, 0, $429, 0, FALSE
	dbglistobj Obj_Caterkiller, Map_Cat, 0, 0, $552, 1, FALSE
	dbglistobj Obj_SwingingPlatform, Map_Swing_SBZ, 7, 0, $448, 0, FALSE
	dbglistobj Obj_RunningDisc, Map_Offscreen, 0, 0, $3A0, 2, TRUE
	dbglistobj Obj_MovingBlock, Map_MBlock, $28, 2, $2B2, 1, FALSE
	dbglistobj Obj_SpinPlatform, Map_Trap, 3, 0, $3F8, 2, FALSE
	dbglistobj Obj_SpinPlatform, Map_Spin, $83, 0, $3C8, 0, FALSE
	dbglistobj Obj_Saws, Map_Saw, 2, 0, $3A4, 2, FALSE
	dbglistobj Obj_CollapseFloor, Map_CFlo, 0, 0, $2AA, 2, FALSE
	dbglistobj Obj_MovingBlock, Map_MBlock, $39, 3, $380, 2, FALSE
	dbglistobj Obj_ScrapStomp, Map_Stomp, 0, 0, $2B2, 1, FALSE
	dbglistobj Obj_AutoDoor, Map_ADoor, 0, 0, $470, 2, FALSE
	dbglistobj Obj_ScrapStomp, Map_Stomp, $13, 1, $2B2, 1, FALSE
	dbglistobj Obj_Saws, Map_Saw, 1, 0, $3A4, 2, FALSE
	dbglistobj Obj_ScrapStomp, Map_Stomp, $24, 1, $2B2, 1, FALSE
	dbglistobj Obj_Saws, Map_Saw, 4, 2, $3A4, 2, FALSE
	dbglistobj Obj_ScrapStomp, Map_Stomp, $34, 1, $2B2, 1, FALSE
	dbglistobj Obj_VanishPlatform, Map_VanP, 0, 0, $364, 2, FALSE
	dbglistobj Obj_Flamethrower, Map_Flame, $64, 0, $562, 0, TRUE
	dbglistobj Obj_Flamethrower, Map_Flame, $64, $B, $562, 0, TRUE
	dbglistobj Obj_Electro, Map_Elec, 4, 0, $529, 0, FALSE
	dbglistobj Obj_Girder, Map_Gird, 4, 0, $2DA, 2, FALSE
	dbglistobj Obj_Invisible_SolidBlock, Map_InvisibleBlock, 0, 0, ArtTile_Monitors, 0, TRUE
	dbglistobj Obj_BallHog, Map_Hog, 0, 0, $2EC, 1, FALSE
	dbglistobj Obj_Animal, Map_Animals1, 0, 2, $592, 0, FALSE
	dbglistobj Obj_Button, Map_Button, 0, 0, $47C, 0, FALSE
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, ArtTile_StarPost, 0, FALSE
	dbglistobj Obj_BigRing, Map_BigRing, 1, 0, ArtTile_Explosion, 1, FALSE
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
	dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
Debug_SBZ1_end
