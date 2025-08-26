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
		offsetTableEntry.w TitleCard_FZ		; C

; find unique letters and load it to VRAM
TitleCard_GHZ:		titlecardLetters "GREEN HILL"
TitleCard_MZ:		titlecardLetters "MARBLE"
TitleCard_SYZ:		titlecardLetters "SPRING YARD"
TitleCard_LZ:		titlecardLetters "LABYRINTH"
TitleCard_SLZ:		titlecardLetters "STAR LIGHT"
TitleCard_SBZ:		titlecardLetters "SCRAP BRAIN"
TitleCard_FZ:		titlecardLetters "FINAL"
	even