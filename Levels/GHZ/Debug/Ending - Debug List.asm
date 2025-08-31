; ---------------------------------------------------------------------------
; Ending debug mode item lists
; ---------------------------------------------------------------------------

				; object, mappings, subtype, frame, VRAM, palette, priority
Debug_Ending: dbglistheader
	dbglistobj Obj_Ring, Map_Ring, 0, 0, ArtTile_Ring, 1, TRUE
	dbglistobj Obj_Animal_Ending, Map_Animals1, 0, 0, $5A5, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals1, 1, 0, $5A5, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals1, 2, 0, $5A5, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals5, 3, 0, $553, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals5, 4, 0, $553, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals5, 5, 0, $573, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals5, 6, 0, $573, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals4, 7, 0, $585, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals3, 8, 0, $593, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals1, 9, 0, $565, 0, FALSE
	dbglistobj Obj_Animal_Ending, Map_Animals2, $A, 0, $5B3, 0, FALSE
Debug_Ending_end