; ===========================================================================
; ║                                                                         ║
; ║                             SONIC&K SOUND DRIVER                        ║
; ║                         Modified SMPS Z80 Type 2 DAC                    ║
; ║                                                                         ║
; ===========================================================================
; Disassembled by MarkeyJester
; Routines, pointers and stuff by Linncaki
; Thoroughly commented and improved (including optional bugfixes) by Flamewing
; ===========================================================================
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
; ===========================================================================
; Sound Bank
; ===========================================================================
SndBank:			startBank

; ===========================================================================
; SFX Pointers
; ===========================================================================
		Snd_Master_Table
; ---------------------------------------------------------------------------
SEGA_PCM:	binclude "Sound/Sega PCM.pcm"
SEGA_PCM_End
		even

; Normal
Sound_RingRight:			include "Sound/SFX/Snd - Ring (Right).asm"
Sound_RingLeft:				include "Sound/SFX/Snd - Ring (Left).asm"
Sound_RingLoss:				include "Sound/SFX/Snd - Ring Loss.asm"
Sound_Jump:			    	include "Sound/SFX/Snd - Jump.asm"
Sound_Roll:			    	include "Sound/SFX/Snd - Roll.asm"
Sound_Skid:			    	include "Sound/SFX/Snd - Skid.asm"
Sound_Death:				include "Sound/SFX/Snd - Death.asm"
Sound_Spindash:				include "Sound/SFX/Snd - Spin Dash.asm"
Sound_Splash:				include "Sound/SFX/Snd - Splash.asm"
Sound_BlueShield:			include "Sound/SFX/Snd - Blue Shield.asm"
Sound_InstaAttack:			include "Sound/SFX/Snd - Insta Attack.asm"
Sound_FireShield:			include "Sound/SFX/Snd - Fire Shield.asm"
Sound_BubbleShield:			include "Sound/SFX/Snd - Bubble Shield.asm"
Sound_LightningShield:		include "Sound/SFX/Snd - Lightning Shield.asm"
Sound_FireAttack:			include "Sound/SFX/Snd - Fire Attack.asm"
Sound_BubbleAttack:			include "Sound/SFX/Snd - Bubble Attack.asm"
Sound_ElectricAttack:		include "Sound/SFX/Snd - Electric Attack.asm"
Sound_SpikeHit:				include "Sound/SFX/Snd - Spike Hit.asm"
Sound_SpikeMove:			include "Sound/SFX/Snd - Spike Move.asm"
Sound_Drown:				include "Sound/SFX/Snd - Drown.asm"
Sound_StarPost:				include "Sound/SFX/Snd - Star Post.asm"
Sound_Spring:				include "Sound/SFX/Snd - Spring.asm"
Sound_Dash:				    include "Sound/SFX/Snd - Dash.asm"
Sound_Break:				include "Sound/SFX/Snd - Break.asm"
Sound_BossHit:				include "Sound/SFX/Snd - Boss Hit.asm"
Sound_AirDing:				include "Sound/SFX/Snd - Air Ding.asm"
Sound_Bubble:				include "Sound/SFX/Snd - Bubble.asm"
Sound_Explode:				include "Sound/SFX/Snd - Explode.asm"
Sound_Signpost:				include "Sound/SFX/Snd - Signpost.asm"
Sound_Switch:				include "Sound/SFX/Snd - Switch.asm"
Sound_Register:				include "Sound/SFX/Snd - Register.asm"
Sound_Projectile:			include "Sound/SFX/Snd - Projectile.asm"
Sound_Collapse:				include "Sound/SFX/Snd - Collapse.asm"
Sound_BridgeCollapse:		include "Sound/SFX/Snd - Bridge Collapse.asm"
Sound_Bumper:				include "Sound/SFX/Snd - Bumper.asm"
Sound_Fireball:				include "Sound/SFX/Snd - Fireball.asm"
Sound_Basaran:				include "Sound/SFX/Snd - Basaran Flap.asm"
Sound_Burning:				include "Sound/SFX/Snd - Burning.asm"
Sound_BossMagma:			include "Sound/SFX/Snd - Boss Magma.asm"
Sound_ChainRise:			include "Sound/SFX/Snd - Chain Rising.asm"
Sound_ChainStomp:			include "Sound/SFX/Snd - Chain Stomp.asm"
Sound_PushBlock:			include "Sound/SFX/Snd - Push Block.asm"
Sound_BossZoom:				include "Sound/SFX/Snd - Boss Zoom.asm"
Sound_Grab:			    	include "Sound/SFX/Snd - Grab.asm"
Sound_Flying:				include "Sound/SFX/Snd - Flying.asm"
Sound_FlyTired:				include "Sound/SFX/Snd - Flying (Tired).asm"
Sound_GlideLand:			include "Sound/SFX/Snd - Glide Land.asm"
Sound_GroundSlide:			include "Sound/SFX/Snd - Ground Slide.asm"
Sound_Laser:				include "Sound/SFX/Snd - Laser.asm"
Sound_Continue:				include "Sound/SFX/Snd - Continue.asm"
Sound_EnterSS:				include "Sound/SFX/Snd - Enter SS.asm"
Sound_SSGlass:				include "Sound/SFX/Snd - SS Glass.asm"
Sound_SSItem:				include "Sound/SFX/Snd - SS Item.asm"
Sound_SSGoal:				include "Sound/SFX/Snd - SS Goal.asm"
Sound_Perfect:				include "Sound/SFX/Snd - Perfect.asm"
Sound_BossHitFloor:			include "Sound/SFX/Snd - Boss Hit Floor.asm"
Sound_Rumbling:				include "Sound/SFX/Snd - Rumbling.asm"
Sound_Door:			    	include "Sound/SFX/Snd - Door.asm"
Sound_MissileThrow:			include "Sound/SFX/Snd - Missile Throw.asm"
Sound_BossProjectile:		include "Sound/SFX/Snd - Boss Projectile.asm"
Sound_Electric:				include "Sound/SFX/Snd - Electric.asm"
Sound_Harpoon:				include "Sound/SFX/Snd - Harpoon.asm"
Sound_Flamethrower:			include "Sound/SFX/Snd - Flamethrower.asm"
Sound_Saw:			    	include "Sound/SFX/Snd - Saw.asm"
Sound_SuperEmerald:			include "Sound/SFX/Snd - Super Emerald.asm"
Sound_SuperTransform:		include "Sound/SFX/Snd - Super Transform.asm"
Sound_MechaTransform:		include "Sound/SFX/Snd - Mecha Transform.asm"
Sound_SignpostRotation:		include "Sound/SFX/Snd - Signpost Rotation.asm"
Sound_HiddenBonus:			include "Sound/SFX/Snd - Hidden Bonus.asm"
Sound_BigRing:				include "Sound/SFX/Snd - Big Ring.asm"
Sound_Thump:				include "Sound/SFX/Snd - Thump.asm"
Sound_Crash:				include "Sound/SFX/Snd - Crash.asm"
Sound_Rumble2:				include "Sound/SFX/Snd - Rumble 2.asm"
Sound_ChainTick:			include "Sound/SFX/Snd - Chain Tick.asm"

; Continuous
Sound_RobotnikSiren:		include "Sound/SFX/Continuous/Snd - Robotnik Siren.asm"
Sound_Waterfall:			include "Sound/SFX/Continuous/Snd - Waterfall.asm"
Sound_LavaFall:				include "Sound/SFX/Continuous/Snd - Lava Fall.asm"
Sound_Rising:				include "Sound/SFX/Continuous/Snd - Rising.asm"
Sound_WindQuiet:			include "Sound/SFX/Continuous/Snd - Wind Quiet.asm"
Sound_WaterSkid:			include "Sound/SFX/Continuous/Snd - Water Skid.asm"
Sound_Rumble:				include "Sound/SFX/Continuous/Snd - Rumble.asm"

	finishBank
; ---------------------------------------------------------------------------
