; ===========================================================================
; Palette Main data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.bea	Pal_Sonic, "Objects/Players/Sonic/Palettes/Sonic.pal"
		incfile.bea	Pal_WaterSonic, "Objects/Players/Sonic/Palettes/Water Sonic.pal"
		incfile.bea	Pal_WaterSonicLZ, "Objects/Players/Sonic/Palettes/Water Sonic(LZ).pal"
		incfile.bea	Pal_WaterSonicSBZ, "Objects/Players/Sonic/Palettes/Water Sonic(SBZ).pal"
		incfile.bea	Pal_Knuckles, "Objects/Players/Knuckles/Palettes/Knuckles.pal"
		incfile.bea	Pal_WaterKnuckles, "Objects/Players/Knuckles/Palettes/Water Knuckles.pal"
		incfile.bea	Pal_WaterKnucklesLZ, "Objects/Players/Knuckles/Palettes/Water Knuckles(LZ).pal"
		incfile.bea	Pal_WaterKnucklesSBZ, "Objects/Players/Knuckles/Palettes/Water Knuckles(SBZ).pal"
		incfile.ba	Pal_Robotnik, "Objects/Bosses/Robotnik/Palettes/1.pal"
		incfile.ba	Pal_WaterRobotnik, "Objects/Bosses/Robotnik/Palettes/Water.pal"
		incfile.ba	Pal_WaterRobotnikLZ, "Objects/Bosses/Robotnik/Palettes/Water(LZ).pal"

; ===========================================================================
; Palette Sega screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

	if SegaVersion=1
		incfile.ba	Pal_AniSega2_1, "Screens/Sega/S1/Palettes/Animated/1.pal"
		incfile.ba	Pal_AniSega2_2, "Screens/Sega/S1/Palettes/Animated/2.pal"
	else
		incfile.ba	Pal_SegaProto, "Screens/Sega/Proto/Palettes/1.pal"
		incfile.ba	Pal_AniSegaProto, "Screens/Sega/Proto/Palettes/Animated/1.pal"
	endif

; ===========================================================================
; Palette Title screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.bea	Pal_Title, "Screens/Title/Palettes/1.pal"
		incfile.ba	Pal_TitleLevelSelect, "Screens/Title/Palettes/2.pal"

; ===========================================================================
; Palette Options screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_Options, "Screens/Options/Palettes/1.pal"

; ===========================================================================
; Palette Level Select screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_LevelSelect, "Screens/Level Select/SCE/Palettes/1.pal"

; ===========================================================================
; Palette Level Select RSDK screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_LevelSelectRSDK, "Screens/Level Select/RSDK/Palettes/1.pal"
		incfile.ba	Pal_LevelSelectRSDKIcons, "Screens/Level Select/RSDK/Palettes/Icons.pal"

; ===========================================================================
; Palette Level screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.bea	Pal_GHZ, "Levels/GHZ/Palettes/Green Hill Zone.pal"
		incfile.bea	Pal_WaterGHZ, "Levels/GHZ/Palettes/Water Green Hill Zone.pal"
		incfile.bea	Pal_MZ, "Levels/MZ/Palettes/Marble Zone.pal"
		incfile.bea	Pal_WaterMZ, "Levels/MZ/Palettes/Water Marble Zone.pal"
		incfile.bea	Pal_SYZ, "Levels/SYZ/Palettes/Spring Yard Zone.pal"
		incfile.bea	Pal_WaterSYZ, "Levels/SYZ/Palettes/Water Spring Yard Zone.pal"
		incfile.bea	Pal_LZ, "Levels/LZ/Palettes/Labyrinth Zone.pal"
		incfile.bea	Pal_WaterLZ, "Levels/LZ/Palettes/Water Labyrinth Zone.pal"
		incfile.bea	Pal_SLZ, "Levels/SLZ/Palettes/Star Light Zone.pal"
		incfile.bea	Pal_WaterSLZ, "Levels/SLZ/Palettes/Water Star Light Zone.pal"
		incfile.bea	Pal_SBZ1, "Levels/SBZ/Palettes/Scrap Brain Zone Act 1.pal"
		incfile.bea	Pal_SBZ2, "Levels/SBZ/Palettes/Scrap Brain Zone Act 2.pal"
		incfile.bea	Pal_WaterSBZ, "Levels/SBZ/Palettes/Water Scrap Brain Zone.pal"
		incfile.bea	Pal_SBZ3, "Levels/LZ/Palettes/Scrap Brain Zone Act 3.pal"
		incfile.bea	Pal_WaterSBZ3, "Levels/LZ/Palettes/Water Scrap Brain Zone Act 3.pal"
		incfile.bea	Pal_Ending, "Levels/GHZ/Palettes/Green Hill Zone Ending.pal"
		incfile.ba	Pal_Credits, "Screens/Credits/Palettes/1.pal"

; ===========================================================================
; Palette Continue screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_Continue, "Screens/Continue/Palettes/1.pal"

; ===========================================================================
; Palette Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_SpecialStageSonic, "Screens/Special Stage/Palettes/Sonic.pal"
		incfile.ba	Pal_SpecialStageKnuckles, "Screens/Special Stage/Palettes/Knuckles.pal"
		incfile.ba	Pal_SpecialStage, "Screens/Special Stage/Palettes/Special Stage.pal"
		incfile.ba	Pal_SpecialStageEmeralds, "Screens/Special Stage/Palettes/Special Stage Emeralds.pal"
		incfile.ba	Pal_SpecialStageResults, "Screens/Special Stage/Palettes/Special Stage Results.pal"

; ===========================================================================
; Animated palette player data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.bea	PalCycle_SuperSonic, "Objects/Players/Sonic/Palettes/Animated/Super.pal"
		incfile.bea	PalCycle_HyperSonic, "Objects/Players/Sonic/Palettes/Animated/Hyper.pal"
		incfile.ba	PalCycle_SuperSonicUnderwaterLZ, "Objects/Players/Sonic/Palettes/Animated/Underwater(LZ).pal"
		incfile.bea	PalCycle_SuperTails, "Objects/Players/Tails/Palettes/Animated/Super.pal"
		incfile.bea	PalCycle_SuperHyperKnuckles, "Objects/Players/Knuckles/Palettes/Animated/Super and Hyper.pal"
		incfile.ba	PalCycle_SuperHyperKnucklesRevert, "Objects/Players/Knuckles/Palettes/Animated/Revert.pal"

; ===========================================================================
; Animated palette Level screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_SYZCyc1, "Levels/SYZ/Palettes/Animated/Palettes/1.pal"
		incfile.ba	Pal_SYZCyc2, "Levels/SYZ/Palettes/Animated/Palettes/2.pal"
		incfile.ba	Pal_LZCyc1, "Levels/LZ/Palettes/Animated/Palettes/Waterfall.pal"
		incfile.ba	Pal_LZCyc2, "Levels/LZ/Palettes/Animated/Palettes/Conveyor Belt.pal"
		incfile.ba	Pal_LZCyc3, "Levels/LZ/Palettes/Animated/Palettes/Conveyor Belt Underwater.pal"
		incfile.ba	Pal_SLZCyc, "Levels/SLZ/Palettes/Animated/Palettes/1.pal"
		incfile.ba	Pal_SBZCyc1, "Levels/SBZ/Palettes/Animated/Palettes/1.pal"
		incfile.ba	Pal_SBZCyc2, "Levels/SBZ/Palettes/Animated/Palettes/2.pal"
		incfile.ba	Pal_SBZCyc3, "Levels/SBZ/Palettes/Animated/Palettes/3.pal"
		incfile.ba	Pal_SBZCyc4, "Levels/SBZ/Palettes/Animated/Palettes/4.pal"
		incfile.ba	Pal_SBZCyc5, "Levels/SBZ/Palettes/Animated/Palettes/5.pal"
		incfile.ba	Pal_SBZCyc6, "Levels/SBZ/Palettes/Animated/Palettes/6.pal"
		incfile.ba	Pal_SBZCyc7, "Levels/SBZ/Palettes/Animated/Palettes/7.pal"
		incfile.ba	Pal_SBZCyc8, "Levels/SBZ/Palettes/Animated/Palettes/8.pal"
		incfile.ba	Pal_SBZCyc9, "Levels/SBZ/Palettes/Animated/Palettes/9.pal"
		incfile.ba	Pal_SBZCyc10, "Levels/SBZ/Palettes/Animated/Palettes/10.pal"
		incfile.ba	Pal_SBZ3Cyc, "Levels/SBZ/Palettes/Animated/Palettes/Waterfall.pal"

; ===========================================================================
; Animated palette Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	Pal_SpecialStageCyc1, "Screens/Special Stage/Palettes/Animated/Palettes/1.pal"
		incfile.ba	Pal_SpecialStageCyc2, "Screens/Special Stage/Palettes/Animated/Palettes/2.pal"
