; ---------------------------------------------------------------------------
; GHZ1 level pointer data
; ---------------------------------------------------------------------------

		; Level init
		dc.l GHZ1_Resize							; Resize
		dc.l 0									; Water resize
		dc.l 0									; After boss

		; Animate palette
		dc.l AnPal_GHZ								; Animate palette main code
		dc.l 0									; Animate palette scripts

		; Level setup
		dc.l GHZ1_ScreenInit							; Screen init
		dc.l GHZ1_BackgroundInit						; Background init
		dc.l DrawTilesAsYouMove							; Screen event
		dc.l GHZ1_BackgroundEvent						; Background event

		; Animate tiles
		dc.l 0									; Animate tiles init
		dc.l AnimateTiles_DoAniPLC						; Animate tiles main code
		dc.l AniPLC_GHZ								; Animate tiles PLC scripts

		; Art 1st 8x8 data, 2nd 8x8 data
		; Blocks pointer, 1st 16x16 data, 2nd 16x16 data
		; Chunks pointer, 1st 128x128 data, 2nd 128x128 data
		; Layout pointer, 1st data, 2nd data
		; Solid pointer, 1st data, 2nd data
		; Objects pointer, 1st data, 2nd data
		; Rings pointer, 1st data, 2nd data
		; Palette, Water palette, Music, Water flag (disabled by default)
		levartptrs \
		GHZ_8x8_KosPM, \
		0, \
		GHZ_16x16_Unc, \
		0, \
		0, \
		Chunk_table, \
		GHZ1_128x128_KosP, \
		0, \
		GHZ1_Layout_Unc, \
		0, \
		0, \
		GHZ_Solid_Unc, \
		0, \
		0, \
		GHZ1_Objects_Unc, \
		0, \
		0, \
		GHZ1_Rings_Unc, \
		0, \
		0, \
		PalID_GHZ, \
		PalID_WaterGHZ, \
		mus_GHZ

		; PLC
		dc.l PLC1_GHZ1_Before							; PLC1
		dc.l PLC2_GHZ1_After							; PLC2
		dc.l PLCAnimals_GHZ1							; PLC animals

		; Level size
		dc.w $100								; Level xstart
		dc.w $26BF								; Level xend
		dc.w 0									; Level ystart
		dc.w $300								; Level yend

		; Starting water height
		dc.w $1000

		; Players palette
		dc.b PalID_Sonic
		dc.b PalID_Knuckles

		; Players water palette
		dc.b PalID_WaterSonic
		dc.b PalID_WaterKnuckles

		; Players start location
		binclude "Levels/GHZ/Start Location/Sonic/1.bin"
		binclude "Levels/GHZ/Start Location/Knuckles/1.bin"

		; Debug Mode
	if (GameDebug)&&(~~GameDebugAlt)
		dc.l Debug_GHZ1								; Debug Mode
	else
		dc.l 0									; Unused
	endif
