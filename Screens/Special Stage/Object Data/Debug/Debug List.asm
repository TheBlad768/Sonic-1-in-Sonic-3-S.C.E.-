; ---------------------------------------------------------------------------
; Special Stage debug mode item lists
; ---------------------------------------------------------------------------

Debug_SpecialStage: dbglistheader

		; object, mappings, subtype, frame, VRAM, palette, priority
		dbglistobj Obj_Ring, Map_Ring, 0, 0, ArtTile_SpecialStage_Ring, 1, TRUE
		dbglistend								; end marker
