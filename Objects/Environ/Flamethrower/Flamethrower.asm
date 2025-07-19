; ---------------------------------------------------------------------------
; Object 6D - flame thrower (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
flame_time			= objoff_30	; .w
flame_savetime			= objoff_32	; .w
flame_pausetime			= objoff_34	; .w
flame_frame			= objoff_36	; .b

; =============== S U B R O U T I N E =======================================

Obj_Flamethrower:

		; flaming time
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d0								; read 1st digit of object type
		add.w	d0,d0								; multiply by 2
		move.w	d0,flame_time(a0)
		move.w	d0,flame_savetime(a0)						; set flaming time

		; pause time
		andi.w	#$F,d1								; read 2nd digit of object type
		lsl.w	#5,d1								; multiply by $20
		move.w	d1,flame_pausetime(a0)						; set pause time

		; init
		lea	ObjDat_Flamethrower(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.l	#.action,address(a0)
		move.b	#10,flame_frame(a0)
		btst	#status.npc.y_flip,status(a0)					; is flipy?
		beq.s	.action								; if not, branch
		move.b	#21,flame_frame(a0)
		move.b	#2,anim(a0)

.action
		subq.w	#1,flame_time(a0)						; subtract 1 from time
		bpl.s	.animate							; if time remains, branch
		move.w	flame_pausetime(a0),flame_time(a0)				; begin pause time
		bchg	#0,anim(a0)
		beq.s	.animate
		move.w	flame_savetime(a0),flame_time(a0)				; begin flaming time
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.animate							; if not, branch
		sfx	sfx_Flamethrower						; play flame sound

.animate
		lea	Ani_Flame(pc),a1
		jsr	(Animate_Sprite).w
		move.b	flame_frame(a0),d0
		cmp.b	mapping_frame(a0),d0
		beq.s	.col

		; draw
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.col
		jmp	(Sprite_OnScreen_Test_Collision).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Flamethrower:		subObjData Map_Flame, $562, 0, 1, 40, 24, 1, 0, $23|collision_flags.npc.hurt
; ---------------------------------------------------------------------------

		include "Objects/Environ/Flamethrower/Object Data/Anim - Flamethrower.asm"
		include "Objects/Environ/Flamethrower/Object Data/Map - Flamethrower.asm"
