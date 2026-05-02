; ===========================================================================
; Settings
; ===========================================================================

; system options
ChecksumCheck =						0				; if 1, enable checksum checking
OptimiseStopZ80 =					2				; if 1, remove stopZ80 and startZ80, if 2, use only for controllers (no effect on sound driver)
MSUMode =						0				; if 1, enable MSU

; screen options
SegaVersion =						0				; if 0, enable Sonic 3 & Knuckles version, if 1, enable Sonic 1 version, if 2, enable Sonic 1 prototype version
SegaScreenFade =					1				; if 0, the SEGA screen shows immediately and doesn't fade in
TitleScreenMenu =					1				; if 0, disable menu options and PSB text, if 1, enable menu options and PSB text, if 2, disable menu options but enable PSB text
LevelSelectVersion =					0				; if 0, enable Level Select screen RSDK version
LevelSelectCheat =					1				; if 1, enable level select cheat check
GameDebugCheat =					1				; if 1, enable debug mode cheat check
SpecialStageRotation =					1				; if 1, enable smooth rotation for Special Stage

; player options
GameDebug =						1				; if 1, enable debug mode for player
GameDebugAlt =						0				; if 1, enable alt debug mode for player
RollInAir =						1				; if 1, enable roll in air for players
WaterSkimming =						0				; if 1, enable player water skimming
PlayerMoveLock =					0				; if 1, lock control during the fall animation (Android, Mania, Origins style)
PlayerFallAnim =					1				; if 1, enable fall animation triggers for falling platforms
PlayerBWAnim =						0				; if 1, enable black and white hurt/death animation
KnuxBreakableWall =					0				; if 1, change the animation of Knuckles after breaking the wall
SonKnuxTransform =					1				; if 1, enable Super/Hyper transformation
CheckChaosEmerald =					1				; if 1, check the number of emeralds to transformation
SuperHyperSonKnux =					1				; if 1, enable Hyper transformation
ExtendedCamera =					0				; if 1, enable extended camera
LevelBoundCheckTop =					1				; if 1, enable check up boundary
OriginalMode =						0				; if 1, disable Spin Dash and Insta Shield (Sonic 1 style)

; level main options
ZoneCount =						6				; set discrete zones are: GHZ, MZ, SYZ, LZ, SLZ, SBZ
HUDScroll =						1				; if 1, enable HUD scrolling movement on level start/finish
HUDCentiseconds =					1				; if 1, enable centiseconds in the HUD

; level misc options
MonitorFall =						0				; if 1, monitor will fall after being hit from below
EnemyProjectileSFX =					1				; if 1, enable additional projectile sound effects added to badniks (Sonic 3 style)
CrabmeatSlope =						0				; if 1, enable crabmeat slope animation (GHZ)
SwingingPlatformChain =					0				; if 1, enable alternate swinging platform chain position (Android, Mania, Origins style)
GlassBlockReflect =					1				; if 1, fix glass block reflect movement (MZ)
JawsWater =						1				; if 1, hide jaws if it is above water (LZ)
CirclingPlatformVersion =				0				; if 1, enable S2/S3K version of circling platform (SLZ)

; level boss options
BossDebug =						0				; if 1, set one hit on all bosses
BossIntro =						1				; if 1, enable boss intro (GHZ, MZ)
BossBallCollision =					1				; if 1, enable GHZ boss collision as in the original game

; SRAM options
EnableSRAM =						0				; if 1, enable SRAM
BackupSRAM =						0				; if 1, enable Backup SRAM
AddressSRAM =						0				; 0 = odd+even, 2 = even only, 3 = odd only

; assembly options
DEBUG_PassCheck =					1				; if 1, check the number of assembly passes
DEBUG_PassError =					1				; if 1, raise an error if there are more than max assembly passes here
DEBUG_PassMax =						2				; set the maximum number of assembly passes for a pass error

; error handler debugging options (only available in DEBUG builds)
DEBUG_ALL =						1				; if 1, enable all debugging checks
DEBUG_DMA =						0|DEBUG_ALL			; if 1, check DMA buffer overflow
DEBUG_DrawLevel =					0|DEBUG_ALL			; if 1, check plane buffer overflow
DEBUG_KosinskiPlus =					0|DEBUG_ALL			; if 1, check kosinki plus buffer overflow
DEBUG_KosinskiPlusModule =				0|DEBUG_ALL			; if 1, check kosinki plus module buffer overflow
DEBUG_LoadObjects =					0|DEBUG_ALL			; if 1, check object respawn table overflow
DEBUG_LoadRings =					0|DEBUG_ALL			; if 1, check ring status table overflow
DEBUG_RingTouchResponse =				0|DEBUG_ALL			; if 1, check ring xy wrap position
DEBUG_RingTouchResponse_Consume =			0|DEBUG_ALL			; if 1, check ring consumption list overflow
DEBUG_RenderSprites =					0|DEBUG_ALL			; if 1, check object and mappings address are valid
