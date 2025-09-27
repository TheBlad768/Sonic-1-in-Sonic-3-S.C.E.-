; ===========================================================================
; Enigma compressed Main data
; ===========================================================================


; ===========================================================================
; Enigma compressed Sega screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

	if SegaVersion=0
		incfile.b	MapEni_Sega, "Screens/Sega/S3K/Enigma Map/Foreground.eni"
	elseif SegaVersion=1
		incfile.b	MapEni_Sega, "Screens/Sega/S1/Enigma Map/Foreground.eni"
	else
		incfile.b	MapEni_SegaProto, "Screens/Sega/Proto/Enigma Map/Foreground.eni"
	endif

; ===========================================================================
; Enigma compressed Title screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	MapEni_TitleFG, "Screens/Title/Enigma Map/Foreground.eni"
		incfile.b	MapEni_TitleCredits, "Screens/Title/Enigma Map/Hidden Credits.eni"

; ===========================================================================
; Enigma compressed Options screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	MapEni_OptionsBG, "Screens/Options/Enigma Map/Background.eni"

; ===========================================================================
; Enigma compressed Level Select RSDK screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	MapEni_LevelSelectRSDKBG, "Screens/Level Select/RSDK/Enigma Map/Background.eni"
		incfile.b	MapEni_LevelSelectRSDKIcons, "Screens/Level Select/RSDK/Enigma Map/Icon.eni"

; ===========================================================================
; Enigma compressed Special Stage screen data
; ===========================================================================

;		Attribute	| Filename	| Folder

		incfile.b	MapEni_SSBg1, "Screens/Special Stage/Enigma Map/Background 1.eni"
		incfile.b	MapEni_SSBg2, "Screens/Special Stage/Enigma Map/Background 2.eni"
