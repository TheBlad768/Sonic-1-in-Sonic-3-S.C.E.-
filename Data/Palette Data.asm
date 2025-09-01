; ===========================================================================
; Palette Main data
; ===========================================================================

Pal_Sonic:					bincludeEntry "Objects/Players/Sonic/Palettes/Sonic.pal"
	even
Pal_WaterSonic:					bincludeEntry "Objects/Players/Sonic/Palettes/Water Sonic.pal"
	even
Pal_WaterSonicLZ:				bincludeEntry "Objects/Players/Sonic/Palettes/Water Sonic(LZ).pal"
	even
Pal_WaterSonicSBZ:				bincludeEntry "Objects/Players/Sonic/Palettes/Water Sonic(SBZ).pal"
	even
Pal_Knuckles:					bincludeEntry "Objects/Players/Knuckles/Palettes/Knuckles.pal"
	even
Pal_WaterKnuckles:				bincludeEntry "Objects/Players/Knuckles/Palettes/Water Knuckles.pal"
	even
Pal_WaterKnucklesLZ:				bincludeEntry "Objects/Players/Knuckles/Palettes/Water Knuckles(LZ).pal"
	even
Pal_WaterKnucklesSBZ:				bincludeEntry "Objects/Players/Knuckles/Palettes/Water Knuckles(SBZ).pal"
	even
Pal_Robotnik:					bincludeEntry "Objects/Bosses/Robotnik/Palettes/1.pal"
	even
Pal_WaterRobotnik:				bincludeEntry "Objects/Bosses/Robotnik/Palettes/Water.pal"
	even
Pal_WaterRobotnikLZ:				bincludeEntry "Objects/Bosses/Robotnik/Palettes/Water(LZ).pal"
	even

; ===========================================================================
; Palette Sega screen data
; ===========================================================================

	if SegaVersion=1
Pal_AniSega2_1:					bincludeEntry "Screens/Sega/S1/Palettes/Animated/1.pal"
	even
Pal_AniSega2_2:					bincludeEntry "Screens/Sega/S1/Palettes/Animated/2.pal"
	even
	else
Pal_SegaProto:					bincludeEntry "Screens/Sega/Proto/Palettes/1.pal"
	even
Pal_AniSegaProto:				bincludeEntry "Screens/Sega/Proto/Palettes/Animated/1.pal"
	even
	endif

; ===========================================================================
; Palette Title screen data
; ===========================================================================

Pal_Title:					bincludeEntry "Screens/Title/Palettes/1.pal"
	even
Pal_TitleLevelSelect:				bincludeEntry "Screens/Title/Palettes/2.pal"
	even

; ===========================================================================
; Palette Options screen data
; ===========================================================================

Pal_Options:					bincludeEntry "Screens/Options/Palettes/1.pal"
	even

; ===========================================================================
; Palette Level Select screen data
; ===========================================================================

Pal_LevelSelect:				bincludeEntry "Screens/Level Select/SCE/Palettes/1.pal"
	even

; ===========================================================================
; Palette Level Select RSDK screen data
; ===========================================================================

Pal_LevelSelectRSDK:				bincludeEntry "Screens/Level Select/RSDK/Palettes/1.pal"
	even
Pal_LevelSelectRSDKIcons:			bincludeEntry "Screens/Level Select/RSDK/Palettes/Icons.pal"
	even

; ===========================================================================
; Palette Level screen data
; ===========================================================================

Pal_GHZ:					bincludeEntry "Levels/GHZ/Palettes/Green Hill Zone.pal"
	even
Pal_WaterGHZ:					bincludeEntry "Levels/GHZ/Palettes/Water Green Hill Zone.pal"
	even
Pal_MZ:						bincludeEntry "Levels/MZ/Palettes/Marble Zone.pal"
	even
Pal_WaterMZ:					bincludeEntry "Levels/MZ/Palettes/Water Marble Zone.pal"
	even
Pal_SYZ:					bincludeEntry "Levels/SYZ/Palettes/Spring Yard Zone.pal"
	even
Pal_WaterSYZ:					bincludeEntry "Levels/SYZ/Palettes/Water Spring Yard Zone.pal"
	even
Pal_LZ:						bincludeEntry "Levels/LZ/Palettes/Labyrinth Zone.pal"
	even
Pal_WaterLZ:					bincludeEntry "Levels/LZ/Palettes/Water Labyrinth Zone.pal"
	even
Pal_SLZ:					bincludeEntry "Levels/SLZ/Palettes/Star Light Zone.pal"
	even
Pal_WaterSLZ:					bincludeEntry "Levels/SLZ/Palettes/Water Star Light Zone.pal"
	even
Pal_SBZ1:					bincludeEntry "Levels/SBZ/Palettes/Scrap Brain Zone Act 1.pal"
	even
Pal_SBZ2:					bincludeEntry "Levels/SBZ/Palettes/Scrap Brain Zone Act 2.pal"
	even
Pal_WaterSBZ:					bincludeEntry "Levels/SBZ/Palettes/Water Scrap Brain Zone.pal"
	even
Pal_SBZ3:					bincludeEntry "Levels/LZ/Palettes/Scrap Brain Zone Act 3.pal"
	even
Pal_WaterSBZ3:					bincludeEntry "Levels/LZ/Palettes/Water Scrap Brain Zone Act 3.pal"
	even
Pal_Ending:					bincludeEntry "Levels/GHZ/Palettes/Green Hill Zone Ending.pal"
	even
Pal_Credits:					bincludeEntry "Screens/Credits/Palettes/1.pal"
	even

; ===========================================================================
; Palette Continue screen data
; ===========================================================================

Pal_Continue:					bincludeEntry "Screens/Continue/Palettes/1.pal"
	even

; ===========================================================================
; Palette Special Stage screen data
; ===========================================================================

Pal_SSSonic:					bincludeEntry "Screens/Special Stage/Palettes/Sonic.pal"
	even
Pal_SSKnuckles:					bincludeEntry "Screens/Special Stage/Palettes/Knuckles.pal"
	even
Pal_SpecialStage:				bincludeEntry "Screens/Special Stage/Palettes/Special Stage.pal"
	even
Pal_SpecialStageEmeralds:			bincludeEntry "Screens/Special Stage/Palettes/Special Stage Emeralds.pal"
	even
Pal_SpecialStageResults:			bincludeEntry "Screens/Special Stage/Palettes/Special Stage Results.pal"
	even

; ===========================================================================
; Animated palette player data
; ===========================================================================

PalCycle_SuperSonic:				bincludeEntry "Objects/Players/Sonic/Palettes/Animated/Super.pal"
	even
PalCycle_HyperSonic:				bincludeEntry "Objects/Players/Sonic/Palettes/Animated/Hyper.pal"
	even
PalCycle_SuperSonicUnderwaterLZ:		bincludeEntry "Objects/Players/Sonic/Palettes/Animated/Underwater(LZ).pal"
	even
PalCycle_SuperTails:				bincludeEntry "Objects/Players/Tails/Palettes/Animated/Super.pal"
	even
PalCycle_SuperHyperKnuckles:			bincludeEntry "Objects/Players/Knuckles/Palettes/Animated/Super and Hyper.pal"
	even
PalCycle_SuperHyperKnucklesRevert:		bincludeEntry "Objects/Players/Knuckles/Palettes/Animated/Revert.pal"
	even

; ===========================================================================
; Animated palette Level screen data
; ===========================================================================

Pal_SYZCyc1:					bincludeEntry "Levels/SYZ/Palettes/Animated/Palettes/1.pal"
	even
Pal_SYZCyc2:					bincludeEntry "Levels/SYZ/Palettes/Animated/Palettes/2.pal"
	even
Pal_LZCyc1:					bincludeEntry "Levels/LZ/Palettes/Animated/Palettes/Waterfall.pal"
	even
Pal_LZCyc2:					bincludeEntry "Levels/LZ/Palettes/Animated/Palettes/Conveyor Belt.pal"
	even
Pal_LZCyc3:					bincludeEntry "Levels/LZ/Palettes/Animated/Palettes/Conveyor Belt Underwater.pal"
	even
Pal_SLZCyc:					bincludeEntry "Levels/SLZ/Palettes/Animated/Palettes/1.pal"
	even
Pal_SBZCyc1:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/1.pal"
	even
Pal_SBZCyc2:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/2.pal"
	even
Pal_SBZCyc3:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/3.pal"
	even
Pal_SBZCyc4:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/4.pal"
	even
Pal_SBZCyc5:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/5.pal"
	even
Pal_SBZCyc6:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/6.pal"
	even
Pal_SBZCyc7:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/7.pal"
	even
Pal_SBZCyc8:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/8.pal"
	even
Pal_SBZCyc9:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/9.pal"
	even
Pal_SBZCyc10:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/10.pal"
	even
Pal_SBZ3Cyc:					bincludeEntry "Levels/SBZ/Palettes/Animated/Palettes/Waterfall.pal"
	even

; ===========================================================================
; Animated palette Special Stage screen data
; ===========================================================================

Pal_SSCyc1:					bincludeEntry "Screens/Special Stage/Palettes/Animated/Palettes/1.pal"
	even
Pal_SSCyc2:					bincludeEntry "Screens/Special Stage/Palettes/Animated/Palettes/2.pal"
	even
