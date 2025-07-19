; ---------------------------------------------------------------------------
; Object 1F - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------

; Options
_CRABMEAT_SLOPE_		= 0	; if 1, enable slope animation

; Dynamic object variables
crab_timedelay			= objoff_30
crab_mode			= objoff_32

; =============== S U B R O U T I N E =======================================

Obj_Crabmeat:

		; init
		lea	ObjDat_Crabmeat(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#bytes_to_word(32/2,32/2),y_radius(a0)				; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		clr.w	y_vel(a0)
		move.l	#.waittofire,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Crab(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.waittofire
		subq.w	#1,crab_timedelay(a0)						; subtract 1 from time delay
		bpl.s	.dontmove
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.movecrab							; if not, branch
		bchg	#1,crab_mode(a0)
		bne.s	.fire

.movecrab
		move.l	#.walkonfloor,objoff_34(a0)
		move.w	#128-1,crab_timedelay(a0)					; set time delay to approx 2 seconds
		move.w	#$80,x_vel(a0)							; move Crabmeat to the right

	if _CRABMEAT_SLOPE_
		bsr.w	Crab_SetAni
		addq.b	#3,d0
		move.b	d0,anim(a0)
	else
		move.b	#3,anim(a0)
	endif

		bchg	#status.npc.x_flip,status(a0)
		bne.s	.noflip
		neg.w	x_vel(a0)							; change direction

.dontmove
.noflip
		rts
; ---------------------------------------------------------------------------

.fire
		move.w	#60-1,crab_timedelay(a0)
		move.b	#6,anim(a0)							; use firing animation

		; create
		sfx	sfx_Projectile
		lea	Child1_Crabmeat_Missile(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------

.walkonfloor
		subq.w	#1,crab_timedelay(a0)
		bmi.s	.chgdirection
		jsr	(MoveSprite2).w
		bchg	#0,crab_mode(a0)
		bne.s	.alt
		move.b	x_radius(a0),d3
		ext.w	d3
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		neg.w	d3

.notflipx
		add.w	x_pos(a0),d3
		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#-8,d1
		blt.s	.chgdirection
		cmpi.w	#12,d1
		bge.s	.chgdirection
		rts
; ---------------------------------------------------------------------------

.alt
		jsr	(ObjCheckFloorDist).w
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)

	if _CRABMEAT_SLOPE_
		bsr.s	Crab_SetAni
		addq.b	#3,d0
		move.b	d0,anim(a0)
	else
		move.b	#3,anim(a0)
	endif

		rts
; ---------------------------------------------------------------------------

.chgdirection
		move.l	#.waittofire,objoff_34(a0)
		move.w	#60-1,crab_timedelay(a0)
		clr.w	x_vel(a0)

	if _CRABMEAT_SLOPE_
		bsr.s	Crab_SetAni
		move.b	d0,anim(a0)
	else
		clr.b	anim(a0)
	endif

		rts

	if _CRABMEAT_SLOPE_

; ---------------------------------------------------------------------------
; Subroutine to set the correct animation for a Crabmeat
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Crab_SetAni:
		moveq	#0,d0
		move.b	angle(a0),d3
		bmi.s	.alt
		cmpi.b	#6,d3
		blo.s	.return
		moveq	#1,d0
		btst	#status.npc.x_flip,status(a0)
		bne.s	.return
		moveq	#2,d0

.return
		rts
; ---------------------------------------------------------------------------

.alt
		cmpi.b	#-6,d3
		bhi.s	.return2
		moveq	#2,d0
		btst	#status.npc.x_flip,status(a0)
		bne.s	.return2
		moveq	#1,d0

.return2
		rts

	endif

; ---------------------------------------------------------------------------
; Sub-object - missile that the Crabmeat throws
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Crabmeat_Missile:

		; init
		lea	ObjDat3_Crabmeat_Missile(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#shield_reaction.all_shields,shield_reaction(a0)		; bounce off all shields
		move.l	#.main,address(a0)
		move.l	#words_to_long(-$100,-$400),x_vel(a0)
		tst.b	subtype(a0)
		beq.s	.main
		neg.w	x_vel(a0)

.main
		jsr	(MoveSprite).w

		; animate
		moveq	#8,d0
		btst	#1,(V_int_run_count+3).w					; 0 or 2
		beq.s	.setframe
		addq.b	#1,d0

.setframe
		move.b	d0,mapping_frame(a0)
		jmp	(Sprite_CheckDeleteTouchXY).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Crabmeat:		subObjData Map_Crab, $3FC, 0, 0, 32, 48, 3, 0, 6|collision_flags.npc.touch
ObjDat3_Crabmeat_Missile:	subObjData FALSE, FALSE, 0, 0, 16, 16, 3, 0, 7|collision_flags.npc.hurt

Child1_Crabmeat_Missile:
		dc.w 2-1
		dc.l Obj_Crabmeat_Missile	; left
		dc.b -16, 0
		dc.l Obj_Crabmeat_Missile	; right
		dc.b 16, 0
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Crabmeat/Object Data/Anim - Crabmeat.asm"
		include "Objects/Enemies/Crabmeat/Object Data/Map - Crabmeat.asm"
