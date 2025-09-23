; ===========================================================================
; Uncompressed player graphics
; ===========================================================================

	align $20000	; for DMA...

ArtUnc_Sonic:					binclude "Objects/Players/Sonic/Uncompressed Art/Sonic.unc"
	even

	align $20000	; for DMA...

ArtUnc_Tails:					binclude "Objects/Players/Tails/Uncompressed Art/Tails.unc"
	even
ArtUnc_Tails_Extra:				binclude "Objects/Players/Tails/Uncompressed Art/Tails Extra.unc"
	even
ArtUnc_Tails_Tail:				binclude "Objects/Players/Tails/Uncompressed Art/Tails tails.unc"
	even

	align $20000	; for DMA...

ArtUnc_Knuckles:				binclude "Objects/Players/Knuckles/Uncompressed Art/Knuckles.unc"
	even
ArtUnc_DashDust:				binclude "Objects/Players/Spin Dust/Uncompressed Art/Dash Dust.unc"
	even
ArtUnc_SplashDrown:				binclude "Objects/Players/Spin Dust/Uncompressed Art/Splash Drown.unc"
	even
ArtUnc_Invincibility:				bincludeEntry "Objects/Players/Shields/Uncompressed Art/Invincibility.unc"
	even
ArtUnc_InstaShield:				binclude "Objects/Players/Shields/Uncompressed Art/Insta-Shield.unc"
	even
ArtUnc_FireShield:				binclude "Objects/Players/Shields/Uncompressed Art/Fire Shield.unc"
	even
ArtUnc_LightningShield:				binclude "Objects/Players/Shields/Uncompressed Art/Lightning Shield.unc"
	even
ArtUnc_LightningShield_Sparks:			bincludeEntry "Objects/Players/Shields/Uncompressed Art/Sparks.unc"
	even
ArtUnc_BubbleShield:				binclude "Objects/Players/Shields/Uncompressed Art/Bubble Shield.unc"
	even
ArtUnc_BlueShield:				binclude "Objects/Players/Shields/Uncompressed Art/Blue Shield.unc"
	even
ArtUnc_SuperSonic_Stars:			bincludeEntry "Objects/Players/Transform/Uncompressed Art/Super Sonic Stars.unc"
	even
ArtUnc_HyperSonicStars:				bincludeEntry "Objects/Players/Transform/Uncompressed Art/Hyper Sonic Stars.unc"
	even
ArtUnc_SuperTailsBirds:				bincludeEntry "Objects/Players/Transform/Uncompressed Art/Super Tails birds.unc"
	even
