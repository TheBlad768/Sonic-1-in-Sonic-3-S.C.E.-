; ---------------------------------------------------------------------------
; Special Stage walls VRAM pointers
; ---------------------------------------------------------------------------

SpecialStage_WallsVRAMSet:

		; 1, 2, 3, 4, 5, 6, 7, 8 (0, 2, 4, 6, 8, $A, $C, $E)
		dc.w make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE)	; 1
		dc.w make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE)	; 2

		dc.w make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE)	; 3
		dc.w make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,0,FALSE)	; 4

		dc.w make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE)	; 5
		dc.w make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,1,FALSE)	; 6

		dc.w make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE)	; 7
		dc.w make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,3,FALSE), make_art_tile(ArtTile_SpecialStage_Wall,2,FALSE)	; 8
