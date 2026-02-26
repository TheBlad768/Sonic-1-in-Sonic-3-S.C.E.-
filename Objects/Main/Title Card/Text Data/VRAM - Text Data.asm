; ===========================================================================
; Text VRAM (Title Card)
; ===========================================================================

TitleCardVRAMLetters_Index: offsetTable
		offsetTableEntry.w VRAM_TitleCard_GHZ	; 0
		offsetTableEntry.w VRAM_TitleCard_MZ	; 2
		offsetTableEntry.w VRAM_TitleCard_SYZ	; 4
		offsetTableEntry.w VRAM_TitleCard_LZ	; 6
		offsetTableEntry.w VRAM_TitleCard_SLZ	; 8
		offsetTableEntry.w VRAM_TitleCard_SBZ	; A

		zonewarning TitleCardVRAMLetters_Index,(1*2)

; find unique letters and load it to VRAM
VRAM_TitleCard_ZONE:	titlecardVRAMLetters FALSE, TRUE, TitleCardName_ZONE
VRAM_TitleCard_GHZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_GHZ
VRAM_TitleCard_MZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_MZ
VRAM_TitleCard_SYZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_SYZ
VRAM_TitleCard_LZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_LZ
VRAM_TitleCard_SLZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_SLZ
VRAM_TitleCard_SBZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_SBZ
VRAM_TitleCard_FZ:	titlecardVRAMLetters TRUE, FALSE, TitleCardName_FZ
	even
