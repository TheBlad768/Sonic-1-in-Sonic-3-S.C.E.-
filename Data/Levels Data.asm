; ===========================================================================
; Levels pointer data
; ===========================================================================

LevelLoadPointer:

		; GHZ
		include "Levels/GHZ/Pointers/GHZ1 - Pointers.asm"
		include "Levels/GHZ/Pointers/GHZ2 - Pointers.asm"
		include "Levels/GHZ/Pointers/GHZ3 - Pointers.asm"
		include "Levels/GHZ/Pointers/GHZ1 - Pointers.asm"	; unused

		; MZ
		include "Levels/MZ/Pointers/MZ1 - Pointers.asm"
		include "Levels/MZ/Pointers/MZ2 - Pointers.asm"
		include "Levels/MZ/Pointers/MZ3 - Pointers.asm"
		include "Levels/MZ/Pointers/MZ1 - Pointers.asm"		; unused

		; SYZ
		include "Levels/SYZ/Pointers/SYZ1 - Pointers.asm"
		include "Levels/SYZ/Pointers/SYZ2 - Pointers.asm"
		include "Levels/SYZ/Pointers/SYZ3 - Pointers.asm"
		include "Levels/SYZ/Pointers/SYZ1 - Pointers.asm"	; unused

		; LZ
		include "Levels/LZ/Pointers/LZ1 - Pointers.asm"
		include "Levels/LZ/Pointers/LZ2 - Pointers.asm"
		include "Levels/LZ/Pointers/LZ3 - Pointers.asm"
		include "Levels/LZ/Pointers/SBZ3 - Pointers.asm"

		; SLZ
		include "Levels/SLZ/Pointers/SLZ1 - Pointers.asm"
		include "Levels/SLZ/Pointers/SLZ2 - Pointers.asm"
		include "Levels/SLZ/Pointers/SLZ3 - Pointers.asm"
		include "Levels/SLZ/Pointers/SLZ1 - Pointers.asm"	; unused

		; SBZ
		include "Levels/SBZ/Pointers/SBZ1 - Pointers.asm"
		include "Levels/SBZ/Pointers/SBZ2 - Pointers.asm"
		include "Levels/SBZ/Pointers/Final - Pointers.asm"
		include "Levels/SBZ/Pointers/SBZ1 - Pointers.asm"	; unused

		zonewarning LevelLoadPointer,((Level_data_addr_RAM_end-Level_data_addr_RAM)*4)

; ===========================================================================
; Compressed level graphics - tile, primary patterns and block mappings
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	GHZ_8x8_KosPM, "Levels/GHZ/Tiles/Primary.kospm"
		incfile.ba	GHZ_16x16_Unc, "Levels/GHZ/Blocks/Primary.unc"
		incfile.ba	GHZ_128x128_KosP, "Levels/GHZ/Chunks/Primary.kosp"
		incfile.ba	GHZ1_128x128_KosP, "Levels/GHZ/Chunks/Act 1 Secondary.kosp"
		incfile.ba	GHZ2_128x128_KosP, "Levels/GHZ/Chunks/Act 2 Secondary.kosp"
		incfile.ba	GHZ3_128x128_KosP, "Levels/GHZ/Chunks/Act 3 Secondary.kosp"
		incfile.ba	MZ_8x8_KosPM, "Levels/MZ/Tiles/Primary.kospm"
		incfile.ba	MZ_16x16_Unc, "Levels/MZ/Blocks/Primary.unc"
		incfile.ba	MZ_128x128_KosP, "Levels/MZ/Chunks/Primary.kosp"
		incfile.ba	MZ1_128x128_KosP, "Levels/MZ/Chunks/Act 1 Secondary.kosp"
		incfile.ba	MZ3_128x128_KosP, "Levels/MZ/Chunks/Act 3 Secondary.kosp"
		incfile.ba	SYZ_8x8_KosPM, "Levels/SYZ/Tiles/Primary.kospm"
		incfile.ba	SYZ_16x16_Unc, "Levels/SYZ/Blocks/Primary.unc"
		incfile.ba	SYZ_128x128_KosP, "Levels/SYZ/Chunks/Primary.kosp"
		incfile.ba	SYZ1_128x128_KosP, "Levels/SYZ/Chunks/Act 1 Secondary.kosp"
		incfile.ba	SYZ2_128x128_KosP, "Levels/SYZ/Chunks/Act 2 Secondary.kosp"
		incfile.ba	SYZ3_128x128_KosP, "Levels/SYZ/Chunks/Act 3 Secondary.kosp"
		incfile.ba	LZ_8x8_KosPM, "Levels/LZ/Tiles/Primary.kospm"
		incfile.ba	LZ_16x16_Unc, "Levels/LZ/Blocks/Primary.unc"
		incfile.ba	LZ_128x128_KosP, "Levels/LZ/Chunks/Primary.kosp"
		incfile.ba	LZ1_128x128_KosP, "Levels/LZ/Chunks/Act 1 Secondary.kosp"
		incfile.ba	LZ2_128x128_KosP, "Levels/LZ/Chunks/Act 2 Secondary.kosp"
		incfile.ba	LZ3_128x128_KosP, "Levels/LZ/Chunks/Act 3 Secondary.kosp"
		incfile.ba	SBZ3_128x128_KosP, "Levels/LZ/Chunks/SBZ3 Secondary.kosp"
		incfile.ba	SLZ_8x8_KosPM, "Levels/SLZ/Tiles/Primary.kospm"
		incfile.ba	SLZ_16x16_Unc, "Levels/SLZ/Blocks/Primary.unc"
		incfile.ba	SLZ_128x128_KosP, "Levels/SLZ/Chunks/Primary.kosp"
		incfile.ba	SBZ_8x8_KosPM, "Levels/SBZ/Tiles/Primary.kospm"
		incfile.ba	SBZ_16x16_Unc, "Levels/SBZ/Blocks/Primary.unc"
		incfile.ba	SBZ_128x128_KosP, "Levels/SBZ/Chunks/Primary.kosp"
		incfile.ba	Ending_128x128_KosP, "Levels/GHZ/Chunks/Ending.kosp"

; ===========================================================================
; Collision data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	AngleArray, "Data/Misc/Floor/Angle Map.bin"
		incfile.ba	HeightMaps, "Data/Misc/Floor/Height Maps.bin"
		incfile.ba	HeightMapsRot, "Data/Misc/Floor/Height Maps Rotated.bin"

; ===========================================================================
; Level collision data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	GHZ_Solid_Unc, "Levels/GHZ/Collision/1.unc"
		incfile.ba	MZ_Solid_Unc, "Levels/MZ/Collision/1.unc"
		incfile.ba	SYZ_Solid_Unc, "Levels/SYZ/Collision/1.unc"
		incfile.ba	LZ_Solid_Unc, "Levels/LZ/Collision/1.unc"
		incfile.ba	SLZ_Solid_Unc, "Levels/SLZ/Collision/1.unc"
		incfile.ba	SBZ_Solid_Unc, "Levels/SBZ/Collision/1.unc"

; ===========================================================================
; Level layout data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	GHZ1_Layout_Unc, "Levels/GHZ/Layout/1.unc"
		incfile.ba	GHZ2_Layout_Unc, "Levels/GHZ/Layout/2.unc"
		incfile.ba	GHZ3_Layout_Unc, "Levels/GHZ/Layout/3.unc"
		incfile.ba	MZ1_Layout_Unc, "Levels/MZ/Layout/1.unc"
		incfile.ba	MZ2_Layout_Unc, "Levels/MZ/Layout/2.unc"
		incfile.ba	MZ3_Layout_Unc, "Levels/MZ/Layout/3.unc"
		incfile.ba	SYZ1_Layout_Unc, "Levels/SYZ/Layout/1.unc"
		incfile.ba	SYZ2_Layout_Unc, "Levels/SYZ/Layout/2.unc"
		incfile.ba	SYZ3_Layout_Unc, "Levels/SYZ/Layout/3.unc"
		incfile.ba	LZ1_Layout_Unc, "Levels/LZ/Layout/1.unc"
		incfile.ba	LZ2_Layout_Unc, "Levels/LZ/Layout/2.unc"
		incfile.ba	LZ3_Layout_Unc, "Levels/LZ/Layout/3.unc"
		incfile.ba	SLZ1_Layout_Unc, "Levels/SLZ/Layout/1.unc"
		incfile.ba	SLZ2_Layout_Unc, "Levels/SLZ/Layout/2.unc"
		incfile.ba	SLZ3_Layout_Unc, "Levels/SLZ/Layout/3.unc"
		incfile.ba	SBZ1_Layout_Unc, "Levels/SBZ/Layout/1.unc"
		incfile.ba	SBZ2_Layout_Unc, "Levels/SBZ/Layout/2.unc"
		incfile.ba	SBZ3_Layout_Unc, "Levels/LZ/Layout/SBZ3.unc"
		incfile.ba	Ending_Layout_Unc, "Levels/GHZ/Layout/Ending.unc"

; ===========================================================================
; Level objects data
; ===========================================================================

		; ObjectTerminat
		ObjectLayoutBoundary

;		Attribute	| Filename	| Folder

		incfile.boa	GHZ1_Objects_Unc, "Levels/GHZ/Object Pos/1.unc"
		incfile.boa	GHZ2_Objects_Unc, "Levels/GHZ/Object Pos/2.unc"
		incfile.boa	GHZ3_Objects_Unc, "Levels/GHZ/Object Pos/3.unc"
		incfile.boa	MZ1_Objects_Unc, "Levels/MZ/Object Pos/1.unc"
		incfile.boa	MZ2_Objects_Unc, "Levels/MZ/Object Pos/2.unc"
		incfile.boa	MZ3_Objects_Unc, "Levels/MZ/Object Pos/3.unc"
		incfile.boa	SYZ1_Objects_Unc, "Levels/SYZ/Object Pos/1.unc"
		incfile.boa	SYZ2_Objects_Unc, "Levels/SYZ/Object Pos/2.unc"
		incfile.boa	SYZ3_Objects_Unc, "Levels/SYZ/Object Pos/3.unc"
		incfile.boa	LZ1_Objects_Unc, "Levels/LZ/Object Pos/1.unc"
		incfile.boa	LZ2_Objects_Unc, "Levels/LZ/Object Pos/2.unc"
		incfile.boa	LZ3_Objects_Unc, "Levels/LZ/Object Pos/3.unc"
		incfile.boa	SLZ1_Objects_Unc, "Levels/SLZ/Object Pos/1.unc"
		incfile.boa	SLZ2_Objects_Unc, "Levels/SLZ/Object Pos/2.unc"
		incfile.boa	SLZ3_Objects_Unc, "Levels/SLZ/Object Pos/3.unc"
		incfile.boa	SBZ1_Objects_Unc, "Levels/SBZ/Object Pos/1.unc"
		incfile.boa	SBZ2_Objects_Unc, "Levels/SBZ/Object Pos/2.unc"
		incfile.boa	SBZ3_Objects_Unc, "Levels/LZ/Object Pos/SBZ3.unc"
		incfile.boa	Final_Objects_Unc, "Levels/SBZ/Object Pos/Final.unc"
		incfile.boa	Ending_Objects_Unc, "Levels/GHZ/Object Pos/Ending.unc"

; ===========================================================================
; Level rings data
; ===========================================================================

		; RingTerminat
		RingLayoutBoundary

;		Attribute	| Filename	| Folder

		incfile.bra	GHZ1_Rings_Unc, "Levels/GHZ/Ring Pos/1.unc"
		incfile.bra	GHZ2_Rings_Unc, "Levels/GHZ/Ring Pos/2.unc"
		incfile.bra	GHZ3_Rings_Unc, "Levels/GHZ/Ring Pos/3.unc"
		incfile.bra	MZ1_Rings_Unc, "Levels/MZ/Ring Pos/1.unc"
		incfile.bra	MZ2_Rings_Unc, "Levels/MZ/Ring Pos/2.unc"
		incfile.bra	MZ3_Rings_Unc, "Levels/MZ/Ring Pos/3.unc"
		incfile.bra	SYZ1_Rings_Unc, "Levels/SYZ/Ring Pos/1.unc"
		incfile.bra	SYZ2_Rings_Unc, "Levels/SYZ/Ring Pos/2.unc"
		incfile.bra	SYZ3_Rings_Unc, "Levels/SYZ/Ring Pos/3.unc"
		incfile.bra	LZ1_Rings_Unc, "Levels/LZ/Ring Pos/1.unc"
		incfile.bra	LZ2_Rings_Unc, "Levels/LZ/Ring Pos/2.unc"
		incfile.bra	LZ3_Rings_Unc, "Levels/LZ/Ring Pos/3.unc"
		incfile.bra	SLZ1_Rings_Unc, "Levels/SLZ/Ring Pos/1.unc"
		incfile.bra	SLZ2_Rings_Unc, "Levels/SLZ/Ring Pos/2.unc"
		incfile.bra	SLZ3_Rings_Unc, "Levels/SLZ/Ring Pos/3.unc"
		incfile.bra	SBZ1_Rings_Unc, "Levels/SBZ/Ring Pos/1.unc"
		incfile.bra	SBZ2_Rings_Unc, "Levels/SBZ/Ring Pos/2.unc"
		incfile.bra	SBZ3_Rings_Unc, "Levels/LZ/Ring Pos/SBZ3.unc"

Final_Rings_Unc:	RingLayoutBoundary
	even
