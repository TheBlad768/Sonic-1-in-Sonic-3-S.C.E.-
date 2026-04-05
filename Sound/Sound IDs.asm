; ---------------------------------------------------------------------------
; Sound IDs
; ---------------------------------------------------------------------------
; Background music
offset :=	MusicIndex
ptrsize :=	4
idstart :=	1
; $00 is reserved for silence

mus__First = idstart

; Levels
mus_GHZ =			SMPS_id(ptr_mus01)
mus_MZ =			SMPS_id(ptr_mus02)
mus_SYZ =			SMPS_id(ptr_mus03)
mus_LZ =			SMPS_id(ptr_mus04)
mus_SLZ =			SMPS_id(ptr_mus05)
mus_SBZ =			SMPS_id(ptr_mus06)

; Main
mus_Invincible =		SMPS_id(ptr_mus07)
mus_ExtraLife =			SMPS_id(ptr_mus08)
mus_SpecialStage =		SMPS_id(ptr_mus09)
mus_Title =			SMPS_id(ptr_mus0A)
mus_Menu =			SMPS_id(ptr_mus0B)
mus_Ending =			SMPS_id(ptr_mus0C)

; Bosses
mus_S1Boss =			SMPS_id(ptr_mus0D)
mus_FZ =			SMPS_id(ptr_mus0E)
mus_MidBoss =			SMPS_id(ptr_mus0F)
mus_ZoneBoss =			SMPS_id(ptr_mus10)
mus_FinalBoss =			SMPS_id(ptr_mus11)

; End
mus_GotThrough =		SMPS_id(ptr_mus12)
mus_GameOver =			SMPS_id(ptr_mus13)
mus_Continue =			SMPS_id(ptr_mus14)
mus_S3Credits =			SMPS_id(ptr_mus15)
mus_Drowning =			SMPS_id(ptr_mus16)
mus_Emerald =			SMPS_id(ptr_mus17)

mus__Last =			SMPS_id(ptr_musend)-1

; Sound effects
offset :=	SoundIndex
ptrsize :=	4
idstart :=	$40

sfx__First = idstart
sfx_RingRight =			SMPS_id(ptr_snd01)
sfx_RingLeft =			SMPS_id(ptr_snd02)
sfx_RingLoss =			SMPS_id(ptr_snd03)
sfx_Jump =			SMPS_id(ptr_snd04)
sfx_Roll =			SMPS_id(ptr_snd05)
sfx_Skid =			SMPS_id(ptr_snd06)
sfx_Death =			SMPS_id(ptr_snd07)
sfx_SpinDash =			SMPS_id(ptr_snd08)
sfx_Splash =			SMPS_id(ptr_snd09)
sfx_BlueShield =		SMPS_id(ptr_snd0A)
sfx_InstaAttack =		SMPS_id(ptr_snd0B)
sfx_FireShield =		SMPS_id(ptr_snd0C)
sfx_BubbleShield =		SMPS_id(ptr_snd0D)
sfx_LightningShield =		SMPS_id(ptr_snd0E)
sfx_FireAttack =		SMPS_id(ptr_snd0F)
sfx_BubbleAttack =		SMPS_id(ptr_snd10)
sfx_ElectricAttack =		SMPS_id(ptr_snd11)
sfx_SpikeHit =			SMPS_id(ptr_snd12)
sfx_SpikeMove =			SMPS_id(ptr_snd13)
sfx_Drown =			SMPS_id(ptr_snd14)
sfx_StarPost =			SMPS_id(ptr_snd15)
sfx_Spring =			SMPS_id(ptr_snd16)
sfx_Dash =			SMPS_id(ptr_snd17)
sfx_Break =			SMPS_id(ptr_snd18)
sfx_BossHit =			SMPS_id(ptr_snd19)
sfx_AirDing =			SMPS_id(ptr_snd1A)
sfx_Bubble =			SMPS_id(ptr_snd1B)
sfx_Explode =			SMPS_id(ptr_snd1C)
sfx_Signpost =			SMPS_id(ptr_snd1D)
sfx_Switch =			SMPS_id(ptr_snd1E)
sfx_Register =			SMPS_id(ptr_snd1F)
sfx_Projectile =		SMPS_id(ptr_snd20)
sfx_Collapse =			SMPS_id(ptr_snd21)
sfx_BridgeCollapse =		SMPS_id(ptr_snd22)
sfx_Bumper =			SMPS_id(ptr_snd23)
sfx_Fireball =			SMPS_id(ptr_snd24)
sfx_Basaran =			SMPS_id(ptr_snd25)
sfx_Burning =			SMPS_id(ptr_snd26)
sfx_BossMagma =			SMPS_id(ptr_snd27)
sfx_ChainRise =			SMPS_id(ptr_snd28)
sfx_ChainStomp =		SMPS_id(ptr_snd29)
sfx_PushBlock =			SMPS_id(ptr_snd2A)
sfx_BossZoom =			SMPS_id(ptr_snd2B)
sfx_Grab =			SMPS_id(ptr_snd2C)
sfx_Flying =			SMPS_id(ptr_snd2D)
sfx_FlyTired =			SMPS_id(ptr_snd2E)
sfx_GlideLand =			SMPS_id(ptr_snd2F)
sfx_GroundSlide =		SMPS_id(ptr_snd30)
sfx_Laser =			SMPS_id(ptr_snd31)
sfx_Continue =			SMPS_id(ptr_snd32)
sfx_EnterSS =			SMPS_id(ptr_snd33)
sfx_SSGlass =			SMPS_id(ptr_snd34)
sfx_SSItem =			SMPS_id(ptr_snd35)
sfx_SSGoal =			SMPS_id(ptr_snd36)
sfx_Perfect =			SMPS_id(ptr_snd37)
sfx_BossHitFloor =		SMPS_id(ptr_snd38)
sfx_Rumbling =			SMPS_id(ptr_snd39)
sfx_Door =			SMPS_id(ptr_snd3A)
sfx_MissileThrow =		SMPS_id(ptr_snd3B)
sfx_BossProjectile =		SMPS_id(ptr_snd3C)
sfx_Electric =			SMPS_id(ptr_snd3D)
sfx_Harpoon =			SMPS_id(ptr_snd3E)
sfx_Flamethrower =		SMPS_id(ptr_snd3F)
sfx_Saw =			SMPS_id(ptr_snd40)
sfx_SuperEmerald =		SMPS_id(ptr_snd41)
sfx_SuperTransform =		SMPS_id(ptr_snd42)
sfx_MechaTransform =		SMPS_id(ptr_snd43)
sfx_SignpostRotation =		SMPS_id(ptr_snd44)
sfx_HiddenBonus =		SMPS_id(ptr_snd45)
sfx_BigRing =			SMPS_id(ptr_snd46)
sfx_Thump =			SMPS_id(ptr_snd47)
sfx_Crash =			SMPS_id(ptr_snd48)
sfx_Rumble2 =			SMPS_id(ptr_snd49)
sfx_ChainTick =			SMPS_id(ptr_snd4A)

; Continuous
sfx_RobotnikSiren =		SMPS_id(ptr_sndC01)
sfx_Waterfall =			SMPS_id(ptr_sndC02)
sfx_LavaFall =			SMPS_id(ptr_sndC03)
sfx_Rising =			SMPS_id(ptr_sndC04)
sfx_WindQuiet =			SMPS_id(ptr_sndC05)
sfx_WaterSkid =			SMPS_id(ptr_sndC06)
sfx_Rumble =			SMPS_id(ptr_sndC07)

sfx__Last =			SMPS_id(ptr_sndend)-1

; Sound commands
offset :=	Sound_ExIndex
ptrsize :=	2
idstart :=	$F9

flg__First = idstart
specsfx_Stop =			SMPS_id(ptr_flgF9)
sfx_Stop =			SMPS_id(ptr_flgFA)
mus_Fade =			SMPS_id(ptr_flgFB)
sfx_Sega =			SMPS_id(ptr_flgFC)
mus_Speedup =			SMPS_id(ptr_flgFD)
mus_Slowdown =			SMPS_id(ptr_flgFE)
mus_Stop =			SMPS_id(ptr_flgFF)
flg__Last =			SMPS_id(ptr_flgend)-1
