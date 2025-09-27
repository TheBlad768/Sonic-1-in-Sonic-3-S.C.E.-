; ===========================================================================
; Palette Main data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.be	Pal_Sonic, "Objects/Players/Sonic/Palettes/Sonic.pal"
		incfile.be	Pal_WaterSonic, "Objects/Players/Sonic/Palettes/Water Sonic.pal"
		incfile.be	Pal_WaterSonicLZ, "Objects/Players/Sonic/Palettes/Water Sonic(LZ).pal"
		incfile.be	Pal_WaterSonicSBZ, "Objects/Players/Sonic/Palettes/Water Sonic(SBZ).pal"
		incfile.be	Pal_Knuckles, "Objects/Players/Knuckles/Palettes/Knuckles.pal"
		incfile.be	Pal_WaterKnuckles, "Objects/Players/Knuckles/Palettes/Water Knuckles.pal"
		incfile.be	Pal_WaterKnucklesLZ, "Objects/Players/Knuckles/Palettes/Water Knuckles(LZ).pal"
		incfile.be	Pal_WaterKnucklesSBZ, "Objects/Players/Knuckles/Palettes/Water Knuckles(SBZ).pal"
		incfile.b	Pal_Robotnik, "Objects/Bosses/Robotnik/Palettes/1.pal"
		incfile.b	Pal_WaterRobotnik, "Objects/Bosses/Robotnik/Palettes/Water.pal"
		incfile.b	Pal_WaterRobotnikLZ, "Objects/Bosses/Robotnik/Palettes/Water(LZ).pal"

; ===========================================================================
; Palette Sega screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

	if SegaVersion=1
		incfile.b	Pal_AniSega2_1, "Screens/Sega/S1/Palettes/Animated/1.pal"
		incfile.b	Pal_AniSega2_2, "Screens/Sega/S1/Palettes/Animated/2.pal"
	else
		incfile.b	Pal_SegaProto, "Screens/Sega/Proto/Palettes/1.pal"
		incfile.b	Pal_AniSegaProto, "Screens/Sega/Proto/Palettes/Animated/1.pal"
	endif

; ===========================================================================
; Palette Title screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.be	Pal_Title, "Screens/Title/Palettes/1.pal"
		incfile.b	Pal_TitleLevelSelect, "Screens/Title/Palettes/2.pal"

; ===========================================================================
; Palette Options screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_Options, "Screens/Options/Palettes/1.pal"

; ===========================================================================
; Palette Level Select screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_LevelSelect, "Screens/Level Select/SCE/Palettes/1.pal"

; ===========================================================================
; Palette Level Select RSDK screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_LevelSelectRSDK, "Screens/Level Select/RSDK/Palettes/1.pal"
		incfile.b	Pal_LevelSelectRSDKIcons, "Screens/Level Select/RSDK/Palettes/Icons.pal"

; ===========================================================================
; Palette Level screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.be	Pal_GHZ, "Levels/GHZ/Palettes/Green Hill Zone.pal"
		incfile.be	Pal_WaterGHZ, "Levels/GHZ/Palettes/Water Green Hill Zone.pal"
		incfile.be	Pal_MZ, "Levels/MZ/Palettes/Marble Zone.pal"
		incfile.be	Pal_WaterMZ, "Levels/MZ/Palettes/Water Marble Zone.pal"
		incfile.be	Pal_SYZ, "Levels/SYZ/Palettes/Spring Yard Zone.pal"
		incfile.be	Pal_WaterSYZ, "Levels/SYZ/Palettes/Water Spring Yard Zone.pal"
		incfile.be	Pal_LZ, "Levels/LZ/Palettes/Labyrinth Zone.pal"
		incfile.be	Pal_WaterLZ, "Levels/LZ/Palettes/Water Labyrinth Zone.pal"
		incfile.be	Pal_SLZ, "Levels/SLZ/Palettes/Star Light Zone.pal"
		incfile.be	Pal_WaterSLZ, "Levels/SLZ/Palettes/Water Star Light Zone.pal"
		incfile.be	Pal_SBZ1, "Levels/SBZ/Palettes/Scrap Brain Zone Act 1.pal"
		incfile.be	Pal_SBZ2, "Levels/SBZ/Palettes/Scrap Brain Zone Act 2.pal"
		incfile.be	Pal_WaterSBZ, "Levels/SBZ/Palettes/Water Scrap Brain Zone.pal"
		incfile.be	Pal_SBZ3, "Levels/LZ/Palettes/Scrap Brain Zone Act 3.pal"
		incfile.be	Pal_WaterSBZ3, "Levels/LZ/Palettes/Water Scrap Brain Zone Act 3.pal"
		incfile.be	Pal_Ending, "Levels/GHZ/Palettes/Green Hill Zone Ending.pal"
		incfile.b	Pal_Credits, "Screens/Credits/Palettes/1.pal"

; ===========================================================================
; Palette Continue screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_Continue, "Screens/Continue/Palettes/1.pal"

; ===========================================================================
; Palette Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_SSSonic, "Screens/Special Stage/Palettes/Sonic.pal"
		incfile.b	Pal_SSKnuckles, "Screens/Special Stage/Palettes/Knuckles.pal"
		incfile.b	Pal_SpecialStage, "Screens/Special Stage/Palettes/Special Stage.pal"
		incfile.b	Pal_SpecialStageEmeralds, "Screens/Special Stage/Palettes/Special Stage Emeralds.pal"
		incfile.b	Pal_SpecialStageResults, "Screens/Special Stage/Palettes/Special Stage Results.pal"

; ===========================================================================
; Animated palette player data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.be	PalCycle_SuperSonic, "Objects/Players/Sonic/Palettes/Animated/Super.pal"
		incfile.be	PalCycle_HyperSonic, "Objects/Players/Sonic/Palettes/Animated/Hyper.pal"
		incfile.b	PalCycle_SuperSonicUnderwaterLZ, "Objects/Players/Sonic/Palettes/Animated/Underwater(LZ).pal"
		incfile.be	PalCycle_SuperTails, "Objects/Players/Tails/Palettes/Animated/Super.pal"
		incfile.be	PalCycle_SuperHyperKnuckles, "Objects/Players/Knuckles/Palettes/Animated/Super and Hyper.pal"
		incfile.b	PalCycle_SuperHyperKnucklesRevert, "Objects/Players/Knuckles/Palettes/Animated/Revert.pal"

; ===========================================================================
; Animated palette Level screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_SYZCyc1, "Levels/SYZ/Palettes/Animated/Palettes/1.pal"
		incfile.b	Pal_SYZCyc2, "Levels/SYZ/Palettes/Animated/Palettes/2.pal"
		incfile.b	Pal_LZCyc1, "Levels/LZ/Palettes/Animated/Palettes/Waterfall.pal"
		incfile.b	Pal_LZCyc2, "Levels/LZ/Palettes/Animated/Palettes/Conveyor Belt.pal"
		incfile.b	Pal_LZCyc3, "Levels/LZ/Palettes/Animated/Palettes/Conveyor Belt Underwater.pal"
		incfile.b	Pal_SLZCyc, "Levels/SLZ/Palettes/Animated/Palettes/1.pal"
		incfile.b	Pal_SBZCyc1, "Levels/SBZ/Palettes/Animated/Palettes/1.pal"
		incfile.b	Pal_SBZCyc2, "Levels/SBZ/Palettes/Animated/Palettes/2.pal"
		incfile.b	Pal_SBZCyc3, "Levels/SBZ/Palettes/Animated/Palettes/3.pal"
		incfile.b	Pal_SBZCyc4, "Levels/SBZ/Palettes/Animated/Palettes/4.pal"
		incfile.b	Pal_SBZCyc5, "Levels/SBZ/Palettes/Animated/Palettes/5.pal"
		incfile.b	Pal_SBZCyc6, "Levels/SBZ/Palettes/Animated/Palettes/6.pal"
		incfile.b	Pal_SBZCyc7, "Levels/SBZ/Palettes/Animated/Palettes/7.pal"
		incfile.b	Pal_SBZCyc8, "Levels/SBZ/Palettes/Animated/Palettes/8.pal"
		incfile.b	Pal_SBZCyc9, "Levels/SBZ/Palettes/Animated/Palettes/9.pal"
		incfile.b	Pal_SBZCyc10, "Levels/SBZ/Palettes/Animated/Palettes/10.pal"
		incfile.b	Pal_SBZ3Cyc, "Levels/SBZ/Palettes/Animated/Palettes/Waterfall.pal"

; ===========================================================================
; Animated palette Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	Pal_SSCyc1, "Screens/Special Stage/Palettes/Animated/Palettes/1.pal"
		incfile.b	Pal_SSCyc2, "Screens/Special Stage/Palettes/Animated/Palettes/2.pal"
