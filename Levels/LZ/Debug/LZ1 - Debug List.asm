; ---------------------------------------------------------------------------
; LZ debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_LZ1: dbglistheader
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
	dbglistobj Obj_Jaws, Map_Jaws, 8, 0, $4F0, 1, FALSE
	dbglistobj Obj_Burrobot, Map_Burro, 0, 2, $510, 0, FALSE
	dbglistobj Obj_Animal, Map_Animals4, 0, 2, $592, 0, FALSE
	dbglistobj Obj_Harpoon, Map_Harp, 0, 0, $3CC, 0, FALSE
	dbglistobj Obj_Harpoon, Map_Harp, 2, 3, $3CC, 0, FALSE
	dbglistobj Obj_PushableBlock, Map_Push, 0, 0, $3DE, 2, FALSE
	dbglistobj Obj_MovingBlock, Map_Offscreen, 0, 0, $3BC, 2, FALSE
	dbglistobj Obj_LabyrinthBlock, Map_LBlock, 1, 0, $3E6, 2, FALSE
	dbglistobj Obj_LabyrinthBlock, Map_LBlock, $13, 1, $3E6, 2, FALSE
	dbglistobj Obj_LabyrinthBlock, Map_LBlock, 5, 0, $3E6, 2, FALSE
	dbglistobj Obj_Gargoyle, Map_Gar, 0, 0, $2E9, 2, FALSE
	dbglistobj Obj_LabyrinthBlock, Map_LBlock, $27, 2, $3E6, 2, FALSE
	dbglistobj Obj_LabyrinthBlock, Map_LBlock, $30, 3, $3E6, 2, FALSE
	dbglistobj Obj_LabyrinthConvey, Map_Offscreen, $7F, 0, $3F6, 0, FALSE
	dbglistobj Obj_Orbinaut, Map_Orb, 0, 0, $55B, 0, FALSE
	dbglistobj Obj_Bubbler, Map_Bubbler, $84, $13, $348, 0, TRUE
	dbglistobj Obj_Waterfall, Map_WFall, 2, 2, $259, 2, FALSE
	dbglistobj Obj_Waterfall, Map_WFall, 9, 9, $259, 2, FALSE
	dbglistobj Obj_Pole, Map_Pole, 0, 0, $3DE, 2, FALSE
	dbglistobj Obj_FlapDoor, Map_Flap, 2, 0, $328, 2, FALSE
	dbglistobj Obj_Button, Map_Button, 0, 0, $47C, 0, FALSE
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, $5EC, 0, FALSE
	dbglistobj Obj_BigRing, Map_BigRing, 1, 0, ArtTile_Explosion, 1, FALSE
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, $494, 0, FALSE
	dbglistobj Obj_EggCapsule_Flying, Map_EggCapsule, 1, 0, $494, 0, FALSE
Debug_LZ1_end
