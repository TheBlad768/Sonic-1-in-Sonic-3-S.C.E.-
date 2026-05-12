; ---------------------------------------------------------------------------
; Object 22 - Buzz Bomber enemy
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

buzzbomber.timer			ds.w 1						; (2 bytes)
buzzbomber.state_flags			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_BuzzBomber:

		; wait
;		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_BuzzBomber(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.move,wait_addr(a0)
		move.l	#.action,code_addr(a0)

.action

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)
		lea	Ani_BuzzBomber(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.move
		subq.w	#1,buzzbomber.timer(a0)						; subtract 1 from time delay
		bpl.s	.noflip								; if time remains, branch
		btst	#1,buzzbomber.state_flags(a0)					; is Buzz Bomber near Sonic?
		bne.s	.fire								; if yes, branch
		move.l	#.chknearsonic,wait_addr(a0)
		move.w	#128-1,buzzbomber.timer(a0)					; set time delay to just over 2 seconds
		move.w	#$400,x_vel(a0)							; move Buzz Bomber to the right
		move.b	#1,anim(a0)							; use "flying" animation
		btst	#status.npc.x_flip,status(a0)					; is Buzz Bomber facing	left?
		bne.s	.noflip								; if not, branch
		neg.w	x_vel(a0)							; move Buzz Bomber to the left

.noflip
		rts
; ---------------------------------------------------------------------------

.fire
		jsr	(Create_New_Object_3).w
		bne.s	.fail
		move.l	#Obj_Missile,code_addr(a1)					; load missile object
		moveq	#28,d0
		add.w	y_pos(a0),d0
		move.w	d0,y_pos(a1)
		move.l	#words_to_long($200,$200),x_vel(a1)				; move missile to the right, downwards
		moveq	#20,d0
		btst	#status.npc.x_flip,status(a0)					; is Buzz Bomber facing	left?
		bne.s	.noflip2							; if not, branch
		neg.w	d0
		neg.w	x_vel(a1)							; move missile to the left

.noflip2
		add.w	x_pos(a0),d0
		move.w	d0,x_pos(a1)
		move.b	status(a0),status(a1)
		move.w	#14,buzzbomber.timer(a1)
		move.w	a0,parent3(a1)
		move.b	#1,buzzbomber.state_flags(a0)					; set to "already fired" to prevent refiring
		move.w	#60-1,buzzbomber.timer(a0)
		move.b	#2,anim(a0)							; use "firing" animation

.fail
		rts
; ---------------------------------------------------------------------------

.chknearsonic
		subq.w	#1,buzzbomber.timer(a0)						; subtract 1 from time delay
		bmi.s	.chgdirection
		MoveSpriteXOnly
		tst.b	buzzbomber.state_flags(a0)
		bne.s	.keepgoing
		jsr	(Find_SonicTails).w
		cmpi.w	#96,d2								; is Buzz Bomber within $60 pixels of Sonic?
		bhs.s	.keepgoing							; if not, branch
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.keepgoing							; if not, branch
		move.b	#2,buzzbomber.state_flags(a0)					; set Buzz Bomber to "near Sonic"
		move.w	#30-1,buzzbomber.timer(a0)					; set time delay to half a second
		bra.s	.stop
; ---------------------------------------------------------------------------

.chgdirection
		clr.b	buzzbomber.state_flags(a0)					; set Buzz Bomber to "normal"
		bchg	#status.npc.x_flip,status(a0)					; change direction
		move.w	#60-1,buzzbomber.timer(a0)

.stop
		move.l	#.move,wait_addr(a0)
		clr.w	x_vel(a0)							; stop Buzz Bomber moving
		clr.b	anim(a0)							; use "hovering" animation

.keepgoing
		rts

; ---------------------------------------------------------------------------
; Object 23 - missile that Buzz Bomber and Newtron throws
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_Missile:

		; init
		lea	ObjDat_BuzzBomber_Missile(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		bset	#shield_reaction.all_shields,shield_reaction(a0)		; bounce off all shields

		andi.b	#( \
			setBit(status.npc.x_flip) | \
			setBit(status.npc.y_flip) \
		),status(a0)

		move.l	#.wait,code_addr(a0)

.wait
		subq.w	#1,buzzbomber.timer(a0)						; subtract 1 from time delay
		bpl.s	.notdraw
		move.l	#.frombuzz,code_addr(a0)

		; check
		tst.b	subtype.byte(a0)						; was object created by	a Newtron?
		beq.s	.animatebuzz							; if not, branch

	if EnemyProjectileSFX
		sfx	sfx_Projectile
	endif

		move.b	#1,anim(a0)
		move.l	#.move,code_addr(a0)
		bra.s	.move
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.frombuzz
		tst.b	routine(a0)							; changed by Animate_Sprite
		beq.s	.animatebuzz_child
		clr.b	routine(a0)

	if EnemyProjectileSFX
		sfx	sfx_Projectile
	endif

		move.b	#1,anim(a0)
		move.l	#.move,code_addr(a0)
		bra.s	.animatebuzz
; ---------------------------------------------------------------------------

.move
		jsr	(MoveSprite2).w

.animatebuzz
		lea	Ani_Missile(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

.animatebuzz_child
		lea	Ani_Missile(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_BuzzBomber:		subObjData Map_BuzzBomber, $440, 0, FALSE, 48, 48, 3, 0, collision_type.npc.touch, 24, 48
ObjDat_BuzzBomber_Missile:	subObjData Map_Missile, $440, 1, FALSE, 16, 16, 3, 0, collision_type.npc.hurt, 12, 12
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Enemies/Buzz Bomber/Object Data/Anim - Buzz Bomber.asm"
		include "Objects/Enemies/Buzz Bomber/Object Data/Anim - Missile.asm"
		include "Objects/Enemies/Buzz Bomber/Object Data/Map - Buzz Bomber.asm"
		include "Objects/Enemies/Buzz Bomber/Object Data/Map - Missile.asm"
