; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The AnimatePalette_DoAniPal subroutine uses these scripts to update certain colors.
;
; zoneanimplcdecl -1, Pal_SLZCyc, Normal_palette_line_3, 6, 1
; -1						Global frame duration. If -1, then each frame will use its own duration, instead
;
; Pal_SLZCyc					Source address of palette
; Normal_palette_line_3	Palette RAM address
; 6						Number of frames
; 1						Number of colors for each frame
;
; dc.b 0,$7F					Start of the script proper
; 0						Color ID of first color in Pal_SLZCyc to transfer
; $7F						Frame duration. Only here if global duration is -1
; ===========================================================================

AniPalette_SLZ: zoneanimstart

		; wall
		zoneanimpaldecl 7, Pal_SLZCyc, Normal_palette_line_3+$16, 6, 1
		dc.b 0
		dc.b 3
		dc.b 6
		dc.b 9
		dc.b 12
		dc.b 15
		even

		; floor and lamppost
		zoneanimpaldecl 7, Pal_SLZCyc, Normal_palette_line_3+$1A, 6, 2
		dc.b 1
		dc.b 4
		dc.b 7
		dc.b 10
		dc.b 13
		dc.b 16
		even

		zoneanimend								; end marker
