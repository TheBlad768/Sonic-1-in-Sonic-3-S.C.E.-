; ===========================================================================
; Palette pointers
; ===========================================================================

PalPointers:							; palette address, RAM address

		; main
		palptr Pal_Sonic, 0				; 0 - Sonic
		palptr Pal_WaterSonic, 0			; 1 - Water Sonic
		palptr Pal_WaterSonicLZ, 0			; 2 - Water Sonic LZ
		palptr Pal_WaterSonicSBZ, 0			; 3 - Water Sonic SBZ
		palptr Pal_Knuckles, 0				; 4 - Knuckles
		palptr Pal_WaterKnuckles, 0			; 5 - Water Knuckles
		palptr Pal_WaterKnucklesLZ, 0			; 6 - Water Knuckles LZ
		palptr Pal_WaterKnucklesSBZ, 0			; 7 - Water Knuckles SBZ

		; levels
		palptr Pal_GHZ, 1				; 8 - GHZ
		palptr Pal_WaterGHZ, 1				; 9 - Water GHZ
		palptr Pal_MZ, 1				; A - GHZ
		palptr Pal_WaterMZ, 1				; B - Water GHZ
		palptr Pal_SYZ, 1				; C - SYZ
		palptr Pal_WaterSYZ, 1				; D - Water SYZ
		palptr Pal_LZ, 1				; E - LZ
		palptr Pal_WaterLZ, 1				; F - Water LZ
		palptr Pal_SLZ, 1				; 10 - SLZ
		palptr Pal_WaterSLZ, 1				; 11 - Water SLZ
		palptr Pal_SBZ1, 1				; 12 - SBZ1
		palptr Pal_SBZ2, 1				; 13 - SBZ2
		palptr Pal_SBZ3, 1				; 14 - SBZ3
		palptr Pal_WaterSBZ3, 1				; 15 - Water SBZ3

		; misc
		palptr Pal_Title, 0				; 16 - Title
		palptr Pal_Ending, 1				; 17 - Ending
