; ===========================================================================
; Demo Level screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.i	DemoDat_SonicTailsGHZ1, "Levels/GHZ/Demodata/GHZ1 - Sonic and Tails Demo.asm"
		incfile.i	DemoDat_SonicGHZ1, "Levels/GHZ/Demodata/GHZ1 - Sonic Demo.asm"
		incfile.i	DemoDat_TailsGHZ1, "Levels/GHZ/Demodata/GHZ1 - Tails Demo.asm"
		incfile.i	DemoDat_KnucklesGHZ1, "Levels/GHZ/Demodata/GHZ1 - Knuckles Demo.asm"
		incfile.i	DemoDat_KnucklesTailsGHZ1, "Levels/GHZ/Demodata/GHZ1 - Knuckles and Tails Demo.asm"
		incfile.i	DemoDat_SonicTailsMZ1, "Levels/MZ/Demodata/MZ1 - Sonic and Tails Demo.asm"
		incfile.i	DemoDat_SonicMZ1, "Levels/MZ/Demodata/MZ1 - Sonic Demo.asm"
		incfile.i	DemoDat_TailsMZ1, "Levels/MZ/Demodata/MZ1 - Tails Demo.asm"
		incfile.i	DemoDat_KnucklesMZ1, "Levels/MZ/Demodata/MZ1 - Knuckles Demo.asm"
		incfile.i	DemoDat_KnucklesTailsMZ1, "Levels/MZ/Demodata/MZ1 - Knuckles and Tails Demo.asm"
		incfile.i	DemoDat_SonicTailsSYZ1, "Levels/SYZ/Demodata/SYZ1 - Sonic and Tails Demo.asm"
		incfile.i	DemoDat_SonicSYZ1, "Levels/SYZ/Demodata/SYZ1 - Sonic Demo.asm"
		incfile.i	DemoDat_TailsSYZ1, "Levels/SYZ/Demodata/SYZ1 - Tails Demo.asm"
		incfile.i	DemoDat_KnucklesSYZ1, "Levels/SYZ/Demodata/SYZ1 - Knuckles Demo.asm"
		incfile.i	DemoDat_KnucklesTailsSYZ1, "Levels/SYZ/Demodata/SYZ1 - Knuckles and Tails Demo.asm"

; ===========================================================================
; Demo Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

	if ~~SpecialStageRotation
		incfile.i	DemoDat_SS, "Screens/Special Stage/Object Data/Demo/SS1 - Demo.asm"
	else
		incfile.i	DemoDat_SS, "Screens/Special Stage/Object Data/Demo/SS1 - Demo(Smooth).asm"
	endif