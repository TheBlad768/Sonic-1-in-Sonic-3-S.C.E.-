; ---------------------------------------------------------------------------
; Sound commands list
; ---------------------------------------------------------------------------

	phase $E1
mus__FirstCmd =				*		; ID of the first sound command
mus_Fade =				*		; $E1 - fade out music
mus_FadeOut				ds.b 1		; $E1 - fade out music
mus_Stop				ds.b 1		; $E2 - stop music and sound effects
mus_MutePSG				ds.b 1		; $E3 - mute all PSG channels
mus_StopSFX				ds.b 1		; $E4 - stop all sound effects
mus_FadeOut2				ds.b 1		; $E5 - fade out music (duplicate)
mus__EndCmd =				*		; next ID after last sound command

mus_FA =				$FA		; $FA - ???
mus_StopSEGA =				$FE		; $FE - Stop SEGA sound
mus_SEGA =				$FF		; $FF - Play SEGA sound

	dephase

; ---------------------------------------------------------------------------
; Music ID's list. These do not affect the sound driver, be careful
; ---------------------------------------------------------------------------

	phase $01
mus__First =				*		; ID of the first music

; Levels
mus_GHZ					ds.b 1		; $01
mus_MZ					ds.b 1		; $02
mus_SYZ					ds.b 1		; $03
mus_LZ					ds.b 1		; $04
mus_SLZ					ds.b 1		; $05
mus_SBZ					ds.b 1		; $06

; Main
mus_Invincible				ds.b 1		; $07
mus_ExtraLife				ds.b 1		; $08
mus_SpecialStage			ds.b 1		; $09
mus_Title				ds.b 1		; $0A
mus_Menu				ds.b 1		; $0B
mus_Ending				ds.b 1		; $0C

; Bosses
mus_S1Boss				ds.b 1		; $0D
mus_FZ					ds.b 1		; $0E
mus_MidBoss				ds.b 1		; $0F
mus_ZoneBoss				ds.b 1		; $10
mus_FinalBoss				ds.b 1		; $11

; End
mus_GotThrough				ds.b 1		; $12
mus_GameOver				ds.b 1		; $13
mus_Continue				ds.b 1		; $14
mus_S3Credits				ds.b 1		; $15
mus_Drowning				ds.b 1		; $16
mus_Emerald				ds.b 1		; $17

mus__End =				*		; next ID after last music

	dephase

; ---------------------------------------------------------------------------
; Sound effect ID's list. These do not affect the sound driver, be careful
; ---------------------------------------------------------------------------

	phase $01
sfx__First =				*		; ID of the first sound effect

sfx_RingRight				ds.b 1		; $01
sfx_RingLeft				ds.b 1		; $02
sfx_RingLoss				ds.b 1		; $03
sfx_Jump				ds.b 1		; $04
sfx_Roll				ds.b 1		; $05
sfx_Skid				ds.b 1		; $06
sfx_Death				ds.b 1		; $07
sfx_SpinDash				ds.b 1		; $08
sfx_Splash				ds.b 1		; $09
sfx_BlueShield				ds.b 1		; $0A
sfx_InstaAttack				ds.b 1		; $0B
sfx_FireShield				ds.b 1		; $0C
sfx_BubbleShield			ds.b 1		; $0D
sfx_LightningShield			ds.b 1		; $0E
sfx_FireAttack				ds.b 1		; $0F
sfx_BubbleAttack			ds.b 1		; $10
sfx_ElectricAttack			ds.b 1		; $11
sfx_SpikeHit				ds.b 1		; $12
sfx_SpikeMove				ds.b 1		; $13
sfx_Drown				ds.b 1		; $14
sfx_StarPost				ds.b 1		; $15
sfx_Spring				ds.b 1		; $16
sfx_Dash				ds.b 1		; $17
sfx_Break				ds.b 1		; $18
sfx_BossHit				ds.b 1		; $19
sfx_AirDing				ds.b 1		; $1A
sfx_Bubble				ds.b 1		; $1B
sfx_Explode				ds.b 1		; $1C
sfx_Signpost				ds.b 1		; $1D
sfx_Switch				ds.b 1		; $1E
sfx_Register				ds.b 1		; $1F
sfx_Projectile				ds.b 1		; $20
sfx_Collapse				ds.b 1		; $21
sfx_BridgeCollapse			ds.b 1		; $22
sfx_Bumper				ds.b 1		; $23
sfx_Fireball				ds.b 1		; $24
sfx_Basaran				ds.b 1		; $25
sfx_Burning				ds.b 1		; $26
sfx_BossMagma				ds.b 1		; $27
sfx_ChainRise				ds.b 1		; $28
sfx_ChainStomp				ds.b 1		; $29
sfx_PushBlock				ds.b 1		; $2A
sfx_BossZoom				ds.b 1		; $2B
sfx_Grab				ds.b 1		; $2C
sfx_Flying				ds.b 1		; $2D
sfx_FlyTired				ds.b 1		; $2E
sfx_GlideLand				ds.b 1		; $2F
sfx_GroundSlide				ds.b 1		; $30
sfx_Laser				ds.b 1		; $31
sfx_Continue				ds.b 1		; $32
sfx_EnterSS				ds.b 1		; $33
sfx_SSGlass				ds.b 1		; $34
sfx_SSItem				ds.b 1		; $35
sfx_SSGoal				ds.b 1		; $36
sfx_Perfect				ds.b 1		; $37
sfx_BossHitFloor			ds.b 1		; $38
sfx_Rumbling				ds.b 1		; $39
sfx_Door				ds.b 1		; $3A
sfx_MissileThrow			ds.b 1		; $3B
sfx_BossProjectile			ds.b 1		; $3C
sfx_Electric				ds.b 1		; $3D
sfx_Harpoon				ds.b 1		; $3E
sfx_Flamethrower			ds.b 1		; $3F
sfx_Saw					ds.b 1		; $40
sfx_SuperEmerald			ds.b 1		; $41
sfx_SuperTransform			ds.b 1		; $42
sfx_MechaTransform			ds.b 1		; $43
sfx_SignpostRotation			ds.b 1		; $44
sfx_HiddenBonus				ds.b 1		; $45
sfx_BigRing				ds.b 1		; $46
sfx_Thump				ds.b 1		; $47
sfx_Crash				ds.b 1		; $48
sfx_Rumble2				ds.b 1		; $49
sfx_ChainTick				ds.b 1		; $4A

; Continuous
sfx__FirstContinuous =			*		; ID of the first continuous sound effect
sfx_RobotnikSiren			ds.b 1		; $01
sfx_Waterfall				ds.b 1		; $02
sfx_LavaFall				ds.b 1		; $03
sfx_Rising				ds.b 1		; $04
sfx_WindQuiet				ds.b 1		; $05
sfx_WaterSkid				ds.b 1		; $06
sfx_Rumble				ds.b 1		; $07

sfx__End =				*		; next ID after the last sound effect

	dephase
	!org 0						; make sure we reset the ROM position to 0
