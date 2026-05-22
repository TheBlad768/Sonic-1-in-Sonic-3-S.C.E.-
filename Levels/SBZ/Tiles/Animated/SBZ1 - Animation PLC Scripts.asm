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

AniPLC_SBZ: zoneanimstart

		; background smoke 1
		zoneanimplcdecl -1, ArtUnc_SBZSmoke, $448, 8, 12
		dc.b 12, 7
		dc.b 24, 7
		dc.b 36, 7
		dc.b 48, 7
		dc.b 60, 7
		dc.b 72, 7
		dc.b 84, 7
		dc.b 0, (3*60)	; wait
		even

		; background smoke 2
		zoneanimplcdecl -1, ArtUnc_SBZSmoke, $454, 8, 12
		dc.b 12, 7
		dc.b 24, 7
		dc.b 36, 7
		dc.b 48, 7
		dc.b 60, 7
		dc.b 72, 7
		dc.b 84, 7
		dc.b 0, (2*60)	; wait
		even

		zoneanimend								; end marker
