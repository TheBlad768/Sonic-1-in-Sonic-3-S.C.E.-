; ---------------------------------------------------------------------------
; SBZ1 level pointer data
; ---------------------------------------------------------------------------

		; Level init
		dc.l SBZ1_Resize							; Resize
		dc.l 0									; Water resize
		dc.l 0									; After boss

		; Animate palette
		dc.l AnPal_SBZ								; Animate palette main code
		dc.l 0									; Animate palette scripts

		; Level setup
		dc.l SBZ1_ScreenInit							; Screen init
		dc.l SBZ1_BackgroundInit						; Background init
		dc.l DrawTilesAsYouMove							; Screen event
		dc.l SBZ1_BackgroundEvent						; Background event

		; Animate tiles
		dc.l 0									; Animate tiles init
		dc.l AnimateTiles_DoAniPLC						; Animate tiles main code
		dc.l AniPLC_SBZ								; Animate tiles PLC scripts

		; Art 1st 8x8 data, 2nd 8x8 data
		; Blocks pointer, 1st 16x16 data, 2nd 16x16 data
		; Chunks pointer, 1st 128x128 data, 2nd 128x128 data
		; Layout pointer, 1st data, 2nd data
		; Solid pointer, 1st data, 2nd data
		; Objects pointer, 1st data, 2nd data
		; Rings pointer, 1st data, 2nd data
		; Palette, Water palette, Music, Water flag (disabled by default)
		levartptrs \
		SBZ_8x8_KosPM, \
		0, \
		SBZ_16x16_Unc, \
		0, \
		0, \
		Chunk_table, \
		SBZ_128x128_KosP, \
		0, \
		SBZ1_Layout_Unc, \
		0, \
		0, \
		SBZ_Solid_Unc, \
		0, \
		0, \
		SBZ1_Objects_Unc, \
		0, \
		0, \
		SBZ1_Rings_Unc, \
		0, \
		0, \
		PalID_SBZ1, \
		PalID_WaterSBZ3, \
		mus_SBZ

		; PLC
		dc.l PLC1_SBZ1_Before							; PLC1
		dc.l PLC2_SBZ1_After							; PLC2
		dc.l PLCAnimals_SBZ1							; PLC animals

		; Level size
		dc.w 0									; Level xstart
		dc.w $23C0								; Level xend
		dc.w 0									; Level ystart
		dc.w $720								; Level yend

		; Starting water height
		dc.w $1000

		; Players palette
		dc.b PalID_Sonic
		dc.b PalID_Knuckles

		; Players water palette
		dc.b PalID_WaterSonic
		dc.b PalID_WaterKnuckles

		; Players start location
		binclude "Levels/SBZ/Start Location/Sonic/1.bin"
		binclude "Levels/SBZ/Start Location/Knuckles/1.bin"

		; Debug Mode
	if (GameDebug)&&(~~GameDebugAlt)
		dc.l Debug_SBZ1								; Debug Mode
	else
		dc.l 0									; Unused
	endif
