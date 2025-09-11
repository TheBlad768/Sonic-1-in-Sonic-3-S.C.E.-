; ---------------------------------------------------------------------------
; MZ2 level pointer data
; ---------------------------------------------------------------------------

		; Level init
		dc.l MZ2_Resize								; Resize
		dc.l 0										; Water resize
		dc.l 0										; After boss

		; Animate palette
		dc.l 0										; Animate palette main code
		dc.l 0										; Animate palette scripts

		; Level setup
		dc.l MZ1_ScreenInit							; Screen init
		dc.l MZ1_BackgroundInit						; Background init
		dc.l DrawTilesAsYouMove						; Screen event
		dc.l MZ1_BackgroundEvent						; Background event

		; Animate tiles
		dc.l 0										; Animate tiles init
		dc.l AnimateTiles_MZ							; Animate tiles main code
		dc.l AniPLC_MZ								; Animate tiles PLC scripts

		; Art 1st 8x8 data, 2nd 8x8 data
		; Blocks pointer, 1st 16x16 data, 2nd 16x16 data
		; Chunks pointer, 1st 128x128 data, 2nd 128x128 data
		; Layout pointer, 1st data, 2nd data
		; Solid pointer, 1st data, 2nd data
		; Objects pointer, 1st data, 2nd data
		; Rings pointer, 1st data, 2nd data
		; Palette, Water palette, Music, Water flag (disabled by default)
		levartptrs \
		MZ_8x8_KosPM, \
		0, \
		MZ_16x16_Unc, \
		0, \
		0, \
		Chunk_table, \
		MZ1_128x128_KosP, \
		0, \
		MZ2_Layout_Unc, \
		0, \
		0, \
		MZ_Solid_Unc, \
		0, \
		0, \
		MZ2_Objects_Unc, \
		0, \
		0, \
		MZ2_Rings_Unc, \
		0, \
		0, \
		PalID_MZ, \
		PalID_WaterMZ, \
		mus_MZ

		; PLC
		dc.l PLC1_MZ2_Before							; PLC1
		dc.l PLC2_MZ2_After							; PLC2
		dc.l PLCAnimals_MZ1							; PLC animals

		; Level size
		dc.w 0										; Level xstart
		dc.w $19BF									; Level xend
		dc.w 0										; Level ystart
		dc.w $520									; Level yend

		; Starting water height
		dc.w $1000

		; Players palette
		dc.b PalID_Sonic
		dc.b PalID_Knuckles

		; Players water palette
		dc.b PalID_WaterSonic
		dc.b PalID_WaterKnuckles

		; Players start location
		binclude "Levels/MZ/Start Location/Sonic/2.bin"
		binclude "Levels/MZ/Start Location/Knuckles/2.bin"

		; Debug Mode
	if (GameDebug)&&(~~GameDebugAlt)
		dc.l Debug_MZ1								; Debug Mode
	else
		dc.l 0										; Unused
	endif
