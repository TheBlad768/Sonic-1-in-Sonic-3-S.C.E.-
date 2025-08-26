; ===========================================================================
; Text (Title Card)
; ===========================================================================

TitleCardLetters_Index: offsetTable
		offsetTableEntry.w TitleCard_GHZ	; 0
		offsetTableEntry.w TitleCard_MZ		; 2
		offsetTableEntry.w TitleCard_SYZ	; 4
		offsetTableEntry.w TitleCard_LZ		; 6
		offsetTableEntry.w TitleCard_SLZ	; 8
		offsetTableEntry.w TitleCard_SBZ	; A

		zonewarning TitleCardLetters_Index,(1*2)

; find unique letters and load it to VRAM
TitleCard_GHZ:		titlecardLetters TRUE, "GREEN HILL"
TitleCard_MZ:		titlecardLetters TRUE, "MARBLE"
TitleCard_SYZ:		titlecardLetters TRUE, "SPRING YARD"
TitleCard_LZ:		titlecardLetters TRUE, "LABYRINTH"
TitleCard_SLZ:		titlecardLetters TRUE, "STAR LIGHT"
TitleCard_SBZ:		titlecardLetters TRUE, "SCRAP BRAIN"
TitleCard_FZ:		titlecardLetters TRUE, "FINAL"
	even