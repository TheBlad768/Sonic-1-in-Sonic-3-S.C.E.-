; ---------------------------------------------------------------------------
; SYZ2 level pointer data
; ---------------------------------------------------------------------------

		; Level init
		dc.l SYZ2_Resize							; Resize
		dc.l 0									; Water resize
		dc.l 0									; After boss

		; Animate palette
		dc.l AnimatePalette_DoAniPal						; Animate palette main code
		dc.l AniPalette_SYZ							; Animate palette scripts

		; Level setup
		dc.l SYZ1_ScreenInit							; Screen init
		dc.l SYZ1_BackgroundInit						; Background init
		dc.l DrawTilesAsYouMove							; Screen event
		dc.l SYZ1_BackgroundEvent						; Background event

		; Animate tiles
		dc.l 0									; Animate tiles init
		dc.l AnimateTiles_DoAniPLC						; Animate tiles main code
		dc.l AniPLC_SYZ								; Animate tiles PLC scripts

		; Art 1st 8x8 data, 2nd 8x8 data
		; Blocks pointer, 1st 16x16 data, 2nd 16x16 data
		; Chunks pointer, 1st 128x128 data, 2nd 128x128 data
		; Layout pointer, 1st data, 2nd data
		; Solid pointer, 1st data, 2nd data
		; Objects pointer, 1st data, 2nd data
		; Rings pointer, 1st data, 2nd data
		; Palette, Water palette, Music, Water flag (disabled by default)
		levartptrs \
		SYZ_8x8_KosPM, \
		0, \
		SYZ_16x16_Unc, \
		0, \
		0, \
		Chunk_table, \
		SYZ2_128x128_KosP, \
		0, \
		SYZ2_Layout_Unc, \
		0, \
		0, \
		SYZ_Solid_Unc, \
		0, \
		0, \
		SYZ2_Objects_Unc, \
		0, \
		0, \
		SYZ2_Rings_Unc, \
		0, \
		0, \
		PalID_SYZ, \
		PalID_WaterSYZ, \
		mus_SYZ

		; PLC
		dc.l PLC1_SYZ2_Before							; PLC1
		dc.l PLC2_SYZ2_After							; PLC2
		dc.l PLCAnimals_SYZ1							; PLC animals

		; Level size
		dc.w 0									; Level xstart
		dc.w $2AC0								; Level xend
		dc.w 0									; Level ystart
		dc.w $520								; Level yend

		; Starting water height
		dc.w $1000

		; Players palette
		dc.b PalID_Sonic
		dc.b PalID_Knuckles

		; Players water palette
		dc.b PalID_WaterSonic
		dc.b PalID_WaterKnuckles

		; Players start location
		binclude "Levels/SYZ/Start Location/Sonic/2.bin"
		binclude "Levels/SYZ/Start Location/Knuckles/2.bin"

		; Debug Mode
	if (GameDebug)&&(~~GameDebugAlt)
		dc.l Debug_SYZ1								; Debug Mode
	else
		dc.l 0									; Unused
	endif
