; ===========================================================================
; Enigma compressed Main data
; ===========================================================================


; ===========================================================================
; Enigma compressed Sega screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

	if SegaVersion=0
		incfile.ba	MapEni_Sega, "Screens/Sega/S3K/Enigma Map/Foreground.eni"
	elseif SegaVersion=1
		incfile.ba	MapEni_Sega, "Screens/Sega/S1/Enigma Map/Foreground.eni"
	else
		incfile.ba	MapEni_SegaProto, "Screens/Sega/Proto/Enigma Map/Foreground.eni"
	endif

; ===========================================================================
; Enigma compressed Title screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	MapEni_TitleFG, "Screens/Title/Enigma Map/Foreground.eni"
		incfile.ba	MapEni_TitleCredits, "Screens/Title/Enigma Map/Hidden Credits.eni"

; ===========================================================================
; Enigma compressed Options screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	MapEni_OptionsBG, "Screens/Options/Enigma Map/Background.eni"

; ===========================================================================
; Enigma compressed Level Select RSDK screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	MapEni_LevelSelectRSDKBG, "Screens/Level Select/RSDK/Enigma Map/Background.eni"
		incfile.ba	MapEni_LevelSelectRSDKIcons, "Screens/Level Select/RSDK/Enigma Map/Icon.eni"

; ===========================================================================
; Enigma compressed Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.ba	MapEni_SpecialStageBGBirdsFish, "Screens/Special Stage/Enigma Map/Background Birds and Fish.eni"
		incfile.ba	MapEni_SpecialStageBGClouds, "Screens/Special Stage/Enigma Map/Background Clouds.eni"
