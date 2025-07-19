; ---------------------------------------------------------------------------
; Object 1E - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
hog_launchflag			= objoff_32	; 0 to launch a cannonball

; =============== S U B R O U T I N E =======================================

Obj_BallHog:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_BallHog(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w						; find floor
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		move.l	#.action,address(a0)

.action
		lea	AniRaw_Hog(pc),a1
		jsr	(Animate_RawNoSST).w

		; action
		cmpi.b	#1,mapping_frame(a0)						; is final frame (01) displayed?
		bne.s	.setlaunchflag							; if not, branch
		tst.b	hog_launchflag(a0)						; is it set to launch cannonball?
		beq.s	.makeball							; if yes, branch
		bra.s	.remember
; ---------------------------------------------------------------------------

.setlaunchflag
		clr.b	hog_launchflag(a0)						; set to launch	cannonball

.remember
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w
; ---------------------------------------------------------------------------

.makeball
		st	hog_launchflag(a0)

		; create ball
		lea	Child6_BallHog_Cannonball(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail
		move.l	#words_to_long(-$100,0),x_vel(a1)				; cannonball bounces to the left
		moveq	#-4,d0
		btst	#render_flags.x_flip,render_flags(a0)				; is Ball Hog facing right?
		beq.s	.noflip								; if not, branch
		neg.w	d0
		neg.w	x_vel(a1)							; cannonball bounces to the right

.noflip
		add.w	d0,x_pos(a1)
		addi.w	#12,y_pos(a1)
		move.b	subtype(a0),subtype(a1)						; copy object type from Ball Hog

.fail
		bra.s	.remember

; ---------------------------------------------------------------------------
; Object 20 - cannonball that Ball Hog throws (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
cbal_time		= objoff_30 ; time until the cannonball explodes (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_BallHog_Cannonball:

		; set
		moveq	#0,d0
		move.b	subtype(a0),d0							; move subtype to d0
		add.w	d0,d0								; multiply by 60 frames (1 second)
		add.w	d0,d0
		move.w	d0,d1
		lsl.w	#4,d0
		sub.w	d1,d0
		move.w	d0,cbal_time(a0)						; set explosion time

		; init
		lea	ObjDat3_BallHog_Cannonball(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.bounce,address(a0)

.bounce
		jsr	(MoveSprite).w
		tst.w	y_vel(a0)
		bmi.s	.chkexplode
		jsr	(ObjCheckFloorDist).w						; find floor
		tst.w	d1								; has ball hit the floor?
		bpl.s	.chkexplode							; if not, branch
		add.w	d1,y_pos(a0)
		move.w	#-$300,y_vel(a0)						; bounce
		tst.b	d3								; Primary_Angle
		beq.s	.chkexplode
		bmi.s	.loc_8CA4
		tst.w	x_vel(a0)
		bpl.s	.chkexplode
		neg.w	x_vel(a0)
		bra.s	.chkexplode
; ---------------------------------------------------------------------------

.loc_8CA4
		tst.w	x_vel(a0)
		bmi.s	.chkexplode
		neg.w	x_vel(a0)

.chkexplode
		subq.w	#1,cbal_time(a0)						; subtract 1 from explosion time
		bpl.s	.animate							; if time is > 0, branch

		; remove
		bset	#status.npc.defeated,status(a0)
		move.l	#Obj_Explosion.skipanimal,address(a0)				; change object to explosion
		rts
; ---------------------------------------------------------------------------

.animate
		subq.b	#1,anim_frame_timer(a0)						; subtract 1 from frame duration
		bpl.s	.display
		addq.b	#5+1,anim_frame_timer(a0)					; set frame duration to 5 frames
		bchg	#0,mapping_frame(a0)						; change frame

.display
		jmp	(Sprite_CheckDeleteTouchXY).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BallHog:			subObjData Map_Hog, $2EC, 1, 0, 38, 16, 4, 0, 5|collision_flags.npc.touch
ObjDat3_BallHog_Cannonball:	subObjData FALSE, FALSE, 0, 0, 16, 16, 3, 4, 7|collision_flags.npc.hurt

Child6_BallHog_Cannonball:
		dc.w 1-1
		dc.l Obj_BallHog_Cannonball

AniRaw_Hog:	dc.b 9, 0, 0, 2, 2, 3, 2, 0, 0, 2, 2, 3, 2, 0, 0, 2, 2, 3, 2, 0, 0, 1, arfEnd
	even
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Ball Hog/Object Data/Map - Ball Hog.asm"
