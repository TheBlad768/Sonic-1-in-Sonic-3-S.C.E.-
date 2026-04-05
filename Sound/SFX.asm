; ---------------------------------------------------------------------------
; SFX metadata (pointers, priorities, flags)

; Priority of sound. New music or SFX must have a priority higher than or equal
; to what is stored in v_sndprio or it won't play. If bit 7 of new priority is
; set ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; Of course, this isn't the case anymore, as priorities no longer apply to
; special SFX or music.
; TODO Maybe I should make it apply to Special SFX, too.
; ---------------------------------------------------------------------------
SoundIndex:
ptr_snd01:		SMPS_SFX_METADATA	Sound01, $70, 0
ptr_snd02:		SMPS_SFX_METADATA	Sound02, $70, 0
ptr_snd03:		SMPS_SFX_METADATA	Sound03, $70, 0
ptr_snd04:		SMPS_SFX_METADATA	Sound04, $70, 0
ptr_snd05:		SMPS_SFX_METADATA	Sound05, $70, 0
ptr_snd06:		SMPS_SFX_METADATA	Sound06, $70, 0
ptr_snd07:		SMPS_SFX_METADATA	Sound07, $70, 0
ptr_snd08:		SMPS_SFX_METADATA	Sound08, $70, 0
ptr_snd09:		SMPS_SFX_METADATA	Sound09, $70, 0
ptr_snd0A:		SMPS_SFX_METADATA	Sound0A, $70, 0
ptr_snd0B:		SMPS_SFX_METADATA	Sound0B, $70, 0
ptr_snd0C:		SMPS_SFX_METADATA	Sound0C, $70, 0
ptr_snd0D:		SMPS_SFX_METADATA	Sound0D, $70, 0
ptr_snd0E:		SMPS_SFX_METADATA	Sound0E, $70, 0
ptr_snd0F:		SMPS_SFX_METADATA	Sound0F, $70, 0
ptr_snd10:		SMPS_SFX_METADATA	Sound10, $70, 0
ptr_snd11:		SMPS_SFX_METADATA	Sound11, $70, 0
ptr_snd12:		SMPS_SFX_METADATA	Sound12, $70, 0
ptr_snd13:		SMPS_SFX_METADATA	Sound13, $70, 0
ptr_snd14:		SMPS_SFX_METADATA	Sound14, $70, 0
ptr_snd15:		SMPS_SFX_METADATA	Sound15, $70, 0
ptr_snd16:		SMPS_SFX_METADATA	Sound16, $70, 0
ptr_snd17:		SMPS_SFX_METADATA	Sound17, $70, 0
ptr_snd18:		SMPS_SFX_METADATA	Sound18, $70, 0
ptr_snd19:		SMPS_SFX_METADATA	Sound19, $70, 0
ptr_snd1A:		SMPS_SFX_METADATA	Sound1A, $70, 0
ptr_snd1B:		SMPS_SFX_METADATA	Sound1B, $70, 0
ptr_snd1C:		SMPS_SFX_METADATA	Sound1C, $70, 0
ptr_snd1D:		SMPS_SFX_METADATA	Sound1D, $70, 0
ptr_snd1E:		SMPS_SFX_METADATA	Sound1E, $70, 0
ptr_snd1F:		SMPS_SFX_METADATA	Sound1F, $70, 0
ptr_snd20:		SMPS_SFX_METADATA	Sound20, $70, 0
ptr_snd21:		SMPS_SFX_METADATA	Sound21, $70, 0
ptr_snd22:		SMPS_SFX_METADATA	Sound22, $70, 0
ptr_snd23:		SMPS_SFX_METADATA	Sound23, $70, 0
ptr_snd24:		SMPS_SFX_METADATA	Sound24, $70, 0
ptr_snd25:		SMPS_SFX_METADATA	Sound25, $70, 0
ptr_snd26:		SMPS_SFX_METADATA	Sound26, $70, 0
ptr_snd27:		SMPS_SFX_METADATA	Sound27, $70, 0
ptr_snd28:		SMPS_SFX_METADATA	Sound28, $70, 0
ptr_snd29:		SMPS_SFX_METADATA	Sound29, $70, 0
ptr_snd2A:		SMPS_SFX_METADATA	Sound2A, $70, 0
ptr_snd2B:		SMPS_SFX_METADATA	Sound2B, $70, 0
ptr_snd2C:		SMPS_SFX_METADATA	Sound2C, $70, 0
ptr_snd2D:		SMPS_SFX_METADATA	Sound2D, $70, 0
ptr_snd2E:		SMPS_SFX_METADATA	Sound2E, $70, 0
ptr_snd2F:		SMPS_SFX_METADATA	Sound2F, $70, 0
ptr_snd30:		SMPS_SFX_METADATA	Sound30, $70, 0
ptr_snd31:		SMPS_SFX_METADATA	Sound31, $70, 0
ptr_snd32:		SMPS_SFX_METADATA	Sound32, $70, 0
ptr_snd33:		SMPS_SFX_METADATA	Sound33, $70, 0
ptr_snd34:		SMPS_SFX_METADATA	Sound34, $70, 0
ptr_snd35:		SMPS_SFX_METADATA	Sound35, $70, 0
ptr_snd36:		SMPS_SFX_METADATA	Sound36, $70, 0
ptr_snd37:		SMPS_SFX_METADATA	Sound37, $70, 0
ptr_snd38:		SMPS_SFX_METADATA	Sound38, $70, 0
ptr_snd39:		SMPS_SFX_METADATA	Sound39, $70, 0
ptr_snd3A:		SMPS_SFX_METADATA	Sound3A, $70, 0
ptr_snd3B:		SMPS_SFX_METADATA	Sound3B, $70, 0
ptr_snd3C:		SMPS_SFX_METADATA	Sound3C, $70, 0
ptr_snd3D:		SMPS_SFX_METADATA	Sound3D, $70, 0
ptr_snd3E:		SMPS_SFX_METADATA	Sound3E, $70, 0
ptr_snd3F:		SMPS_SFX_METADATA	Sound3F, $70, 0
ptr_snd40:		SMPS_SFX_METADATA	Sound40, $70, 0
ptr_snd41:		SMPS_SFX_METADATA	Sound41, $70, 0
ptr_snd42:		SMPS_SFX_METADATA	Sound42, $70, 0
ptr_snd43:		SMPS_SFX_METADATA	Sound43, $70, 0
ptr_snd44:		SMPS_SFX_METADATA	Sound44, $70, 0
ptr_snd45:		SMPS_SFX_METADATA	Sound45, $70, 0
ptr_snd46:		SMPS_SFX_METADATA	Sound46, $70, 0
ptr_snd47:		SMPS_SFX_METADATA	Sound47, $70, 0
ptr_snd48:		SMPS_SFX_METADATA	Sound48, $70, 0
ptr_snd49:		SMPS_SFX_METADATA	Sound49, $70, 0
ptr_snd4A:		SMPS_SFX_METADATA	Sound4A, $70, 0

; Continuous
ptr_sndC01:		SMPS_SFX_METADATA	SoundC01, $70, 0
ptr_sndC02:		SMPS_SFX_METADATA	SoundC02, $70, 0
ptr_sndC03:		SMPS_SFX_METADATA	SoundC03, $70, 0
ptr_sndC04:		SMPS_SFX_METADATA	SoundC04, $70, 0
ptr_sndC05:		SMPS_SFX_METADATA	SoundC05, $70, 0
ptr_sndC06:		SMPS_SFX_METADATA	SoundC06, $70, 0
ptr_sndC07:		SMPS_SFX_METADATA	SoundC07, $70, 0

ptr_sndend
; ---------------------------------------------------------------------------
; SFX data ($40-$EF)
; ---------------------------------------------------------------------------

Sound01:		include "Sound/SFX/Snd - Ring.asm"
	even
Sound02:		include "Sound/SFX/Snd - Ring Left Speaker.asm"
	even
Sound03:		include "Sound/SFX/Snd - Ring Loss.asm"
	even
Sound04:		include "Sound/SFX/Snd - Jump.asm"
	even
Sound05:		include "Sound/SFX/Snd - Roll.asm"
	even
Sound06:		include "Sound/SFX/Snd - Skid.asm"
	even
Sound07:		include "Sound/SFX/Snd - Death.asm"
	even
Sound08:		include "Sound/SFX/Snd - Spin Dash.asm"
	even
Sound09:		include "Sound/SFX/Snd - Splash.asm"
	even
Sound0A:		include "Sound/SFX/Snd - Blue Shield.asm"
	even
Sound0B:		include "Sound/SFX/Snd - Insta Attack.asm"
	even
Sound0C:		include "Sound/SFX/Snd - Fire Shield.asm"
	even
Sound0D:		include "Sound/SFX/Snd - Bubble Shield.asm"
	even
Sound0E:		include "Sound/SFX/Snd - Lightning Shield.asm"
	even
Sound0F:		include "Sound/SFX/Snd - Fire Attack.asm"
	even
Sound10:		include "Sound/SFX/Snd - Bubble Attack.asm"
	even
Sound11:		include "Sound/SFX/Snd - Electric Attack.asm"
	even
Sound12:		include "Sound/SFX/Snd - Spike Hit.asm"
	even
Sound13:		include "Sound/SFX/Snd - Spike Move.asm"
	even
Sound14:		include "Sound/SFX/Snd - Drown.asm"
	even
Sound15:		include "Sound/SFX/Snd - Star Post.asm"
	even
Sound16:		include "Sound/SFX/Snd - Spring.asm"
	even
Sound17:		include "Sound/SFX/Snd - Dash.asm"
	even
Sound18:		include "Sound/SFX/Snd - Break.asm"
	even
Sound19:		include "Sound/SFX/Snd - Boss Hit.asm"
	even
Sound1A:		include "Sound/SFX/Snd - Air Ding.asm"
	even
Sound1B:		include "Sound/SFX/Snd - Bubble.asm"
	even
Sound1C:		include "Sound/SFX/Snd - Explode.asm"
	even
Sound1D:		include "Sound/SFX/Snd - Signpost.asm"
	even
Sound1E:		include "Sound/SFX/Snd - Switch.asm"
	even
Sound1F:		include "Sound/SFX/Snd - Register.asm"
	even
Sound20:		include "Sound/SFX/Snd - Projectile.asm"
	even
Sound21:		include "Sound/SFX/Snd - Collapse.asm"
	even
Sound22:		include "Sound/SFX/Snd - Bridge Collapse.asm"
	even
Sound23:		include "Sound/SFX/Snd - Bumper.asm"
	even
Sound24:		include "Sound/SFX/Snd - Fireball.asm"
	even
Sound25:		include "Sound/SFX/Snd - Basaran Flap.asm"
	even
Sound26:		include "Sound/SFX/Snd - Burning.asm"
	even
Sound27:		include "Sound/SFX/Snd - Boss Magma.asm"
	even
Sound28:		include "Sound/SFX/Snd - Chain Rising.asm"
	even
Sound29:		include "Sound/SFX/Snd - Chain Stomp.asm"
	even
Sound2A:		include "Sound/SFX/Snd - Push Block.asm"
	even
Sound2B:		include "Sound/SFX/Snd - Boss Zoom.asm"
	even
Sound2C:		include "Sound/SFX/Snd - Grab.asm"
	even
Sound2D:		include "Sound/SFX/Snd - Flying.asm"
	even
Sound2E:		include "Sound/SFX/Snd - Flying (Tired).asm"
	even
Sound2F:		include "Sound/SFX/Snd - Glide Land.asm"
	even
Sound30:		include "Sound/SFX/Snd - Ground Slide.asm"
	even
Sound31:		include "Sound/SFX/Snd - Laser.asm"
	even
Sound32:		include "Sound/SFX/Snd - Continue.asm"
	even
Sound33:		include "Sound/SFX/Snd - Enter SS.asm"
	even
Sound34:		include "Sound/SFX/Snd - SS Glass.asm"
	even
Sound35:		include "Sound/SFX/Snd - SS Item.asm"
	even
Sound36:		include "Sound/SFX/Snd - SS Goal.asm"
	even
Sound37:		include "Sound/SFX/Snd - Perfect.asm"
	even
Sound38:		include "Sound/SFX/Snd - Boss Hit Floor.asm"
	even
Sound39:		include "Sound/SFX/Snd - Rumbling.asm"
	even
Sound3A:		include "Sound/SFX/Snd - Door.asm"
	even
Sound3B:		include "Sound/SFX/Snd - Missile Throw.asm"
	even
Sound3C:		include "Sound/SFX/Snd - Boss Projectile.asm"
	even
Sound3D:		include "Sound/SFX/Snd - Electric.asm"
	even
Sound3E:		include "Sound/SFX/Snd - Harpoon.asm"
	even
Sound3F:		include "Sound/SFX/Snd - Flamethrower.asm"
	even
Sound40:		include "Sound/SFX/Snd - Saw.asm"
	even
Sound41:		include "Sound/SFX/Snd - Super Emerald.asm"
	even
Sound42:		include "Sound/SFX/Snd - Super Transform.asm"
	even
Sound43:		include "Sound/SFX/Snd - Mecha Transform.asm"
	even
Sound44:		include "Sound/SFX/Snd - Signpost Rotation.asm"
	even
Sound45:		include "Sound/SFX/Snd - Hidden Bonus.asm"
	even
Sound46:		include "Sound/SFX/Snd - Big Ring.asm"
	even
Sound47:		include "Sound/SFX/Snd - Thump.asm"
	even
Sound48:		include "Sound/SFX/Snd - Crash.asm"
	even
Sound49:		include "Sound/SFX/Snd - Rumble 2.asm"
	even
Sound4A:		include "Sound/SFX/Snd - Chain Tick.asm"
	even

; Continuous
SoundC01:		include "Sound/SFX/Continuous/Snd - Robotnik Siren.asm"
	even
SoundC02:		include "Sound/SFX/Continuous/Snd - Waterfall.asm"
	even
SoundC03:		include "Sound/SFX/Continuous/Snd - Lava Fall.asm"
	even
SoundC04:		include "Sound/SFX/Continuous/Snd - Rising.asm"
	even
SoundC05:		include "Sound/SFX/Continuous/Snd - Wind Quiet.asm"
	even
SoundC06:		include "Sound/SFX/Continuous/Snd - Water Skid.asm"
	even
SoundC07:		include "Sound/SFX/Continuous/Snd - Rumble.asm"
	even
