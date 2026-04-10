; ---------------------------------------------------------------------------
; Object XX - sound scenery
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

soundstillsprite.play			ds.b 1						; (1 byte)
soundstillsprite.frame			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SoundStillSprite:

		; get
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0								; multiply by 2
		move.w	.index(pc,d0.w),soundstillsprite.play(a0)			; set play and wait
		move.l	#.main,code_addr(a0)

.main

		; play sound
		move.b	soundstillsprite.play(a0),d0					; Play_SFX
		move.b	soundstillsprite.frame(a0),d1					; V_int_run_count
		jsr	(Play_SFX_Continuous.main).w

		; check delete
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.index

		; GHZ (Waterfall)							; 0
		dc.b sfx_Waterfall, $F							; play water sound every 16th frame
