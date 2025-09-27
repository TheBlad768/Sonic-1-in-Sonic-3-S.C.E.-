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

		incfile.b	GHZ_8x8_KosPM, "Levels/GHZ/Tiles/Primary.kospm"
		incfile.b	GHZ_16x16_Unc, "Levels/GHZ/Blocks/Primary.unc"
		incfile.b	GHZ1_128x128_KosP, "Levels/GHZ/Chunks/1.kosp"
		incfile.b	GHZ2_128x128_KosP, "Levels/GHZ/Chunks/2.kosp"
		incfile.b	GHZ3_128x128_KosP, "Levels/GHZ/Chunks/3.kosp"
		incfile.b	MZ_8x8_KosPM, "Levels/MZ/Tiles/Primary.kospm"
		incfile.b	MZ_16x16_Unc, "Levels/MZ/Blocks/Primary.unc"
		incfile.b	MZ1_128x128_KosP, "Levels/MZ/Chunks/1.kosp"
		incfile.b	MZ3_128x128_KosP, "Levels/MZ/Chunks/3.kosp"
		incfile.b	SYZ_8x8_KosPM, "Levels/SYZ/Tiles/Primary.kospm"
		incfile.b	SYZ_16x16_Unc, "Levels/SYZ/Blocks/Primary.unc"
		incfile.b	SYZ1_128x128_KosP, "Levels/SYZ/Chunks/1.kosp"
		incfile.b	SYZ2_128x128_KosP, "Levels/SYZ/Chunks/2.kosp"
		incfile.b	SYZ3_128x128_KosP, "Levels/SYZ/Chunks/3.kosp"
		incfile.b	LZ_8x8_KosPM, "Levels/LZ/Tiles/Primary.kospm"
		incfile.b	LZ_16x16_Unc, "Levels/LZ/Blocks/Primary.unc"
		incfile.b	LZ1_128x128_KosP, "Levels/LZ/Chunks/1.kosp"
		incfile.b	LZ2_128x128_KosP, "Levels/LZ/Chunks/2.kosp"
		incfile.b	LZ3_128x128_KosP, "Levels/LZ/Chunks/3.kosp"
		incfile.b	SBZ3_128x128_KosP, "Levels/LZ/Chunks/SBZ3.kosp"
		incfile.b	SLZ_8x8_KosPM, "Levels/SLZ/Tiles/Primary.kospm"
		incfile.b	SLZ_16x16_Unc, "Levels/SLZ/Blocks/Primary.unc"
		incfile.b	SLZ_128x128_KosP, "Levels/SLZ/Chunks/Primary.kosp"
		incfile.b	SBZ_8x8_KosPM, "Levels/SBZ/Tiles/Primary.kospm"
		incfile.b	SBZ_16x16_Unc, "Levels/SBZ/Blocks/Primary.unc"
		incfile.b	SBZ_128x128_KosP, "Levels/SBZ/Chunks/Primary.kosp"
		incfile.b	Ending_128x128_KosP, "Levels/GHZ/Chunks/Ending.kosp"

; ===========================================================================
; Collision data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	AngleArray, "Data/Misc/Floor/Angle Map.bin"
		incfile.b	HeightMaps, "Data/Misc/Floor/Height Maps.bin"
		incfile.b	HeightMapsRot, "Data/Misc/Floor/Height Maps Rotated.bin"

; ===========================================================================
; Level collision data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	GHZ_Solid_Unc, "Levels/GHZ/Collision/1.unc"
		incfile.b	MZ_Solid_Unc, "Levels/MZ/Collision/1.unc"
		incfile.b	SYZ_Solid_Unc, "Levels/SYZ/Collision/1.unc"
		incfile.b	LZ_Solid_Unc, "Levels/LZ/Collision/1.unc"
		incfile.b	SLZ_Solid_Unc, "Levels/SLZ/Collision/1.unc"
		incfile.b	SBZ_Solid_Unc, "Levels/SBZ/Collision/1.unc"

; ===========================================================================
; Level layout data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	GHZ1_Layout_Unc, "Levels/GHZ/Layout/1.unc"
		incfile.b	GHZ2_Layout_Unc, "Levels/GHZ/Layout/2.unc"
		incfile.b	GHZ3_Layout_Unc, "Levels/GHZ/Layout/3.unc"
		incfile.b	MZ1_Layout_Unc, "Levels/MZ/Layout/1.unc"
		incfile.b	MZ2_Layout_Unc, "Levels/MZ/Layout/2.unc"
		incfile.b	MZ3_Layout_Unc, "Levels/MZ/Layout/3.unc"
		incfile.b	SYZ1_Layout_Unc, "Levels/SYZ/Layout/1.unc"
		incfile.b	SYZ2_Layout_Unc, "Levels/SYZ/Layout/2.unc"
		incfile.b	SYZ3_Layout_Unc, "Levels/SYZ/Layout/3.unc"
		incfile.b	LZ1_Layout_Unc, "Levels/LZ/Layout/1.unc"
		incfile.b	LZ2_Layout_Unc, "Levels/LZ/Layout/2.unc"
		incfile.b	LZ3_Layout_Unc, "Levels/LZ/Layout/3.unc"
		incfile.b	SLZ1_Layout_Unc, "Levels/SLZ/Layout/1.unc"
		incfile.b	SLZ2_Layout_Unc, "Levels/SLZ/Layout/2.unc"
		incfile.b	SLZ3_Layout_Unc, "Levels/SLZ/Layout/3.unc"
		incfile.b	SBZ1_Layout_Unc, "Levels/SBZ/Layout/1.unc"
		incfile.b	SBZ2_Layout_Unc, "Levels/SBZ/Layout/2.unc"
		incfile.b	SBZ3_Layout_Unc, "Levels/LZ/Layout/SBZ3.unc"
		incfile.b	Ending_Layout_Unc, "Levels/GHZ/Layout/Ending.unc"

; ===========================================================================
; Level objects data
; ===========================================================================

		; ObjectTerminat
		ObjectLayoutBoundary

;		Attribute	| Filename	| Folder

		incfile.bo	GHZ1_Objects_Unc, "Levels/GHZ/Object Pos/1.unc"
		incfile.bo	GHZ2_Objects_Unc, "Levels/GHZ/Object Pos/2.unc"
		incfile.bo	GHZ3_Objects_Unc, "Levels/GHZ/Object Pos/3.unc"
		incfile.bo	MZ1_Objects_Unc, "Levels/MZ/Object Pos/1.unc"
		incfile.bo	MZ2_Objects_Unc, "Levels/MZ/Object Pos/2.unc"
		incfile.bo	MZ3_Objects_Unc, "Levels/MZ/Object Pos/3.unc"
		incfile.bo	SYZ1_Objects_Unc, "Levels/SYZ/Object Pos/1.unc"
		incfile.bo	SYZ2_Objects_Unc, "Levels/SYZ/Object Pos/2.unc"
		incfile.bo	SYZ3_Objects_Unc, "Levels/SYZ/Object Pos/3.unc"
		incfile.bo	LZ1_Objects_Unc, "Levels/LZ/Object Pos/1.unc"
		incfile.bo	LZ2_Objects_Unc, "Levels/LZ/Object Pos/2.unc"
		incfile.bo	LZ3_Objects_Unc, "Levels/LZ/Object Pos/3.unc"
		incfile.bo	SLZ1_Objects_Unc, "Levels/SLZ/Object Pos/1.unc"
		incfile.bo	SLZ2_Objects_Unc, "Levels/SLZ/Object Pos/2.unc"
		incfile.bo	SLZ3_Objects_Unc, "Levels/SLZ/Object Pos/3.unc"
		incfile.bo	SBZ1_Objects_Unc, "Levels/SBZ/Object Pos/1.unc"
		incfile.bo	SBZ2_Objects_Unc, "Levels/SBZ/Object Pos/2.unc"
		incfile.bo	SBZ3_Objects_Unc, "Levels/LZ/Object Pos/SBZ3.unc"
		incfile.bo	Final_Objects_Unc, "Levels/SBZ/Object Pos/Final.unc"
		incfile.bo	Ending_Objects_Unc, "Levels/GHZ/Object Pos/Ending.unc"

; ===========================================================================
; Level rings data
; ===========================================================================

		; RingTerminat
		RingLayoutBoundary

;		Attribute	| Filename	| Folder

		incfile.br	GHZ1_Rings_Unc, "Levels/GHZ/Ring Pos/1.unc"
		incfile.br	GHZ2_Rings_Unc, "Levels/GHZ/Ring Pos/2.unc"
		incfile.br	GHZ3_Rings_Unc, "Levels/GHZ/Ring Pos/3.unc"
		incfile.br	MZ1_Rings_Unc, "Levels/MZ/Ring Pos/1.unc"
		incfile.br	MZ2_Rings_Unc, "Levels/MZ/Ring Pos/2.unc"
		incfile.br	MZ3_Rings_Unc, "Levels/MZ/Ring Pos/3.unc"
		incfile.br	SYZ1_Rings_Unc, "Levels/SYZ/Ring Pos/1.unc"
		incfile.br	SYZ2_Rings_Unc, "Levels/SYZ/Ring Pos/2.unc"
		incfile.br	SYZ3_Rings_Unc, "Levels/SYZ/Ring Pos/3.unc"
		incfile.br	LZ1_Rings_Unc, "Levels/LZ/Ring Pos/1.unc"
		incfile.br	LZ2_Rings_Unc, "Levels/LZ/Ring Pos/2.unc"
		incfile.br	LZ3_Rings_Unc, "Levels/LZ/Ring Pos/3.unc"
		incfile.br	SLZ1_Rings_Unc, "Levels/SLZ/Ring Pos/1.unc"
		incfile.br	SLZ2_Rings_Unc, "Levels/SLZ/Ring Pos/2.unc"
		incfile.br	SLZ3_Rings_Unc, "Levels/SLZ/Ring Pos/3.unc"
		incfile.br	SBZ1_Rings_Unc, "Levels/SBZ/Ring Pos/1.unc"
		incfile.br	SBZ2_Rings_Unc, "Levels/SBZ/Ring Pos/2.unc"
		incfile.br	SBZ3_Rings_Unc, "Levels/LZ/Ring Pos/SBZ3.unc"

Final_Rings_Unc:	RingLayoutBoundary
	even
