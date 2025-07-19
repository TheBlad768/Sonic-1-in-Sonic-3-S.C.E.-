; ---------------------------------------------------------------------------
; Object 2B - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
chop_origY			= objoff_32

; =============== S U B R O U T I N E =======================================

Obj_Chopper:

		; init
		lea	ObjDat_Chopper(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#-$700,y_vel(a0)						; set vertical speed
		move.w	y_pos(a0),chop_origY(a0)					; save original position
		move.l	#.chgspeed,address(a0)

.chgspeed
		move.w	chop_origY(a0),d0
		cmp.w	y_pos(a0),d0							; has Chopper returned to its original position?
		bhs.s	.chganimation							; if not, branch
		move.w	d0,y_pos(a0)
		move.w	#-$700,y_vel(a0)						; set vertical speed

.chganimation
		moveq	#1,d1								; use fast animation
		subi.w	#$C0,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.setframe
		moveq	#0,d1								; use slow animation
		tst.w	y_vel(a0)							; is Chopper at its highest point?
		bmi.s	.setframe							; if not, branch
		addq.b	#2,d1								; use stationary animation

.setframe
		move.b	d1,anim(a0)
		MoveSpriteYOnly a0, $18							; reduce speed
		lea	Ani_Chop(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Chopper:		subObjData Map_Chop, $4EC, 0, 0, 32, 32, 4, 0, 9|collision_flags.npc.touch
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Chopper/Object Data/Anim - Chopper.asm"
		include "Objects/Enemies/Chopper/Object Data/Map - Chopper.asm"
