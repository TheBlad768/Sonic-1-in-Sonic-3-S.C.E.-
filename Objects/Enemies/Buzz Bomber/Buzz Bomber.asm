; ---------------------------------------------------------------------------
; Object 22 - Buzz Bomber enemy
; ---------------------------------------------------------------------------

; Dynamic object variables
buzz_timedelay			= objoff_32	; .w
buzz_buzzstatus			= objoff_38	; .b

; =============== S U B R O U T I N E =======================================

Obj_BuzzBomber:

		; wait
;		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_BuzzBomber(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.move,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Buzz(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.move
		subq.w	#1,buzz_timedelay(a0)						; subtract 1 from time delay
		bpl.s	.noflip								; if time remains, branch
		btst	#1,buzz_buzzstatus(a0)						; is Buzz Bomber near Sonic?
		bne.s	.fire								; if yes, branch
		move.l	#.chknearsonic,objoff_34(a0)
		move.w	#128-1,buzz_timedelay(a0)					; set time delay to just over 2 seconds
		move.w	#$400,x_vel(a0)							; move Buzz Bomber to the right
		move.b	#1,anim(a0)							; use "flying" animation
		btst	#status.npc.x_flip,status(a0)					; is Buzz Bomber facing	left?
		bne.s	.noflip								; if not, branch
		neg.w	x_vel(a0)							; move Buzz Bomber to the left

.noflip
		rts
; ---------------------------------------------------------------------------

.fire
		jsr	(Create_New_Sprite3).w
		bne.s	.fail
		move.l	#Obj_Missile,address(a1)					; load missile object
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
		move.w	#14,buzz_timedelay(a1)
		move.w	a0,parent3(a1)
		move.b	#1,buzz_buzzstatus(a0)						; set to "already fired" to prevent refiring
		move.w	#60-1,buzz_timedelay(a0)
		move.b	#2,anim(a0)							; use "firing" animation

.fail
		rts
; ---------------------------------------------------------------------------

.chknearsonic
		subq.w	#1,buzz_timedelay(a0)						; subtract 1 from time delay
		bmi.s	.chgdirection
		jsr	(MoveSprite2).w
		tst.b	buzz_buzzstatus(a0)
		bne.s	.keepgoing
		jsr	(Find_SonicTails).w
		cmpi.w	#96,d2								; is Buzz Bomber within $60 pixels of Sonic?
		bhs.s	.keepgoing							; if not, branch
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.keepgoing							; if not, branch
		move.b	#2,buzz_buzzstatus(a0)						; set Buzz Bomber to "near Sonic"
		move.w	#30-1,buzz_timedelay(a0)					; set time delay to half a second
		bra.s	.stop
; ---------------------------------------------------------------------------

.chgdirection
		clr.b	buzz_buzzstatus(a0)						; set Buzz Bomber to "normal"
		bchg	#status.npc.x_flip,status(a0)					; change direction
		move.w	#60-1,buzz_timedelay(a0)

.stop
		move.l	#.move,objoff_34(a0)
		clr.w	x_vel(a0)							; stop Buzz Bomber moving
		clr.b	anim(a0)							; use "hovering" animation

.keepgoing
		rts

; ---------------------------------------------------------------------------
; Object 23 - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------

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

		move.l	#.wait,address(a0)

.wait
		subq.w	#1,buzz_timedelay(a0)						; subtract 1 from time delay
		bpl.s	.notdraw
		move.b	#7|collision_flags.npc.hurt,collision_flags(a0)
		move.l	#.frombuzz,address(a0)
		tst.b	subtype(a0)							; was object created by	a Newtron?
		beq.s	.animatebuzz							; if not, branch
		sfx	sfx_Projectile
		move.b	#1,anim(a0)
		move.l	#.move,address(a0)
		bra.s	.move
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.frombuzz
		tst.b	routine(a0)
		beq.s	.animatebuzz_child
		clr.b	routine(a0)
		sfx	sfx_Projectile
		move.b	#1,anim(a0)
		move.l	#.move,address(a0)
		bra.s	.animatebuzz
; ---------------------------------------------------------------------------

.move
		jsr	(MoveSprite2).w

.animatebuzz
		lea	Ani_Missile(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

.animatebuzz_child
		lea	Ani_Missile(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BuzzBomber:		subObjData Map_Buzz, $440, 0, 0, 48, 48, 3, 0, 8|collision_flags.npc.touch
ObjDat_BuzzBomber_Missile:	subObjData Map_Missile, $440, 1, 0, 16, 16, 3, 0, 0
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Buzz Bomber/Object Data/Anim - Buzz Bomber.asm"
		include "Objects/Enemies/Buzz Bomber/Object Data/Anim - Buzz Bomber Missile.asm"
		include "Objects/Enemies/Buzz Bomber/Object Data/Map - Buzz Bomber.asm"
		include "Objects/Enemies/Buzz Bomber/Object Data/Map - Buzz Bomber Missile.asm"
