; ---------------------------------------------------------------------------
; Title pointer data
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelLoadPointer_Title:

		; Level init
		dc.l 0									; Resize
		dc.l 0									; Water resize
		dc.l 0									; After boss

		; Animate palette
		dc.l AnPal_GHZ								; Animate palette main code
		dc.l 0									; Animate palette scripts

		; Level setup
		dc.l 0									; Screen init
		dc.l Title_BackgroundInit						; Background init
		dc.l 0									; Screen event
		dc.l Title_BackgroundEvent						; Background event

		; Animate tiles
		dc.l 0									; Animate tiles init
		dc.l 0									; Animate tiles main code
		dc.l 0									; Animate tiles PLC scripts

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
		0, \
		0, \
		0, \
		0, \
		0, \
		0, \
		0, \
		0, \
		0, \
		PalID_Title, \
		PalID_WaterGHZ, \
		mus_Title

		; PLC
		dc.l -1									; PLC1
		dc.l -1									; PLC2
		dc.l -1									; PLC animals

		; Level size
		dc.w 0									; Level xstart
		dc.w $26BF								; Level xend
		dc.w 0									; Level ystart
		dc.w 0									; Level yend

		; Starting water height
		dc.w $1000

		; Players palette
		dc.b PalID_Sonic
		dc.b PalID_Knuckles

		; Players water palette
		dc.b PalID_WaterSonic
		dc.b PalID_WaterKnuckles

		; Players start location
		dc.w $50								; xpos
		dc.w 0									; ypos
		dc.w $50								; xpos
		dc.w 0									; ypos

		; Debug Mode
		dc.l 0									; Unused

LevelLoadPointer_Title_end

	if (LevelLoadPointer_Title_end-LevelLoadPointer_Title)<>(Level_data_addr_RAM_end-Level_data_addr_RAM)
		fatal "Warning! The buffer size is different!"
	endif
