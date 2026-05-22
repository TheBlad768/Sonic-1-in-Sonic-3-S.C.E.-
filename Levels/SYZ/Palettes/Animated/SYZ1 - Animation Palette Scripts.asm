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

AniPalette_SYZ: zoneanimstart

		; flashing light and text
		zoneanimpaldecl 5, Pal_SYZCyc1, Normal_palette_line_4+$E, 4, 4
		dc.b 0
		dc.b 4
		dc.b 8
		dc.b 12
		even

		; flashing light
		zoneanimpaldecl 5, Pal_SYZCyc2, Normal_palette_line_4+$16, 4, 1
		dc.b 0
		dc.b 2
		dc.b 4
		dc.b 6
		even

		; lamp
		zoneanimpaldecl 5, Pal_SYZCyc2, Normal_palette_line_4+$1A, 4, 1
		dc.b 1
		dc.b 3
		dc.b 5
		dc.b 7
		even

		zoneanimend								; end marker
