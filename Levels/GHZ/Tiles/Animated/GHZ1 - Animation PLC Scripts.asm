; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The AnimateTiles_DoAniPLC subroutine uses these scripts to reload certain tiles,
; thus animating them. All the relevant art must be uncompressed, because
; otherwise the subroutine would spend so much time waiting for the art to be
; decompressed that the VBLANK window would close before all the animating was done.
;
; zoneanimplcdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
; -1						Global frame duration. If -1, then each frame will use its own duration, instead
;
; ArtUnc_Flowers1				Source address
; ArtTile_ArtUnc_Flowers1			Destination VRAM address
; 6						Number of frames
; 2						Number of tiles to load into VRAM for each frame
;
; dc.b 0,$7F					Start of the script proper
; 0						Tile ID of first tile in ArtUnc_Flowers1 to transfer
; $7F						Frame duration. Only here if global duration is -1
; ===========================================================================

AniPLC_GHZ: zoneanimstart

		; flower (Large)
		zoneanimplcdecl $12, ArtUnc_GHZFlower1, $35C, 2, 16
		dc.b 0
		dc.b 16
		even

		; flower (Small)
		zoneanimplcdecl -1, ArtUnc_GHZFlower2, $36C, 4, 12
		dc.b 0, $A2
		dc.b 12, $A
		dc.b 24, $A2
		dc.b 12, $A
		even

		; water
		zoneanimplcdecl 5, ArtUnc_GHZWater, $378, 2, 8
		dc.b 0
		dc.b 8
		even

		zoneanimend								; end marker
