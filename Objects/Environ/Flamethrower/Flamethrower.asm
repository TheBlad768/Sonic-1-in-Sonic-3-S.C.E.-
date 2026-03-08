; ---------------------------------------------------------------------------
; Object 6D - flame thrower (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

flamethrower.timer			ds.w 1						; (2 bytes)
flamethrower.delay			ds.w 1						; (2 bytes)
flamethrower.pause			ds.w 1						; (2 bytes)
flamethrower.frame			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Flamethrower:

		; flaming time
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d0								; read 1st digit of object type
		add.w	d0,d0								; multiply by 2
		move.w	d0,flamethrower.timer(a0)
		move.w	d0,flamethrower.delay(a0)					; set flaming time

		; pause time
		andi.w	#$F,d1								; read 2nd digit of object type
		lsl.w	#5,d1								; multiply by $20
		move.w	d1,flamethrower.pause(a0)					; set pause time

		; init
		lea	ObjDat_Flamethrower(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.l	#.action,address(a0)
		move.b	#10,flamethrower.frame(a0)

		; check
		btst	#status.npc.y_flip,status(a0)					; is flipy?
		beq.s	.action								; if not, branch
		move.b	#21,flamethrower.frame(a0)
		move.b	#2,anim(a0)

.action
		subq.w	#1,flamethrower.timer(a0)					; subtract 1 from time
		bpl.s	.animate							; if time remains, branch
		move.w	flamethrower.pause(a0),flamethrower.timer(a0)			; begin pause time
		bchg	#0,anim(a0)
		beq.s	.animate
		move.w	flamethrower.delay(a0),flamethrower.timer(a0)			; begin flaming time
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.animate							; if not, branch
		sfx	sfx_Flamethrower						; play flame sound

.animate
		lea	Ani_Flamethrower(pc),a1
		jsr	(Animate_Sprite).w

		; check
		move.b	flamethrower.frame(a0),d0
		cmp.b	mapping_frame(a0),d0
		beq.s	.col

		; draw
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.col
		jmp	(Sprite_OnScreen_Test_Collision).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Flamethrower:		subObjData Map_Flamethrower, $562, 0, TRUE, 40, 24, 1, 0, $23|collision_flags.npc.hurt
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Flamethrower/Object Data/Anim - Flamethrower.asm"
		include "Objects/Environ/Flamethrower/Object Data/Map - Flamethrower.asm"
