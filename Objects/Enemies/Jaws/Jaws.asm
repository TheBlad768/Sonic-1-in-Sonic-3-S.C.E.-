; ---------------------------------------------------------------------------
; Object 2C - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

; Options
_JAWSWATER_FIX_			= 1	; hide jaws if it is above water

; Dynamic object variables
jaws_timecount			= objoff_3A
jaws_timedelay			= objoff_3C

; =============== S U B R O U T I N E =======================================

Obj_Jaws:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_Jaws(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.turn,address(a0)

		; set
		moveq	#0,d0
		move.b	subtype(a0),d0							; load object subtype number
		lsl.w	#6,d0								; multiply d0 by 64
		subq.w	#1,d0
		move.w	d0,jaws_timecount(a0)						; set turn delay time
		move.w	d0,jaws_timedelay(a0)
		move.w	#-$40,x_vel(a0)							; move Jaws to the left
		btst	#render_flags.x_flip,render_flags(a0)				; is Jaws facing left?
		beq.s	.turn								; if yes, branch
		neg.w	x_vel(a0)							; move Jaws to the right

.turn
		subq.w	#1,jaws_timecount(a0)						; subtract 1 from turn delay time
		bpl.s	.animate							; if time remains, branch
		move.w	jaws_timedelay(a0),jaws_timecount(a0)				; reset turn delay time
		neg.w	x_vel(a0)							; change speed direction
		bchg	#render_flags.x_flip,render_flags(a0)				; change Jaws facing direction

.animate

	if _JAWSWATER_FIX_
		move.w	(Water_level).w,d0
		cmp.w	y_pos(a0),d0							; is Jaws above the water?
		bge.s	.delete								; if yes, branch
	endif

		MoveSpriteXOnly a0

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.draw								; if time remains, branch
		addq.b	#7+1,anim_frame_timer(a0)					; reset timer to 7 frames

		; next frame
		addq.b	#1,mapping_frame(a0)
		andi.b	#3,mapping_frame(a0)

.draw
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

	if _JAWSWATER_FIX_
.delete
		jmp	(Sprite_CheckDelete.offscreen).w
	endif

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Jaws:	subObjData Map_Jaws, $4F0, 1, 0, 32, 64, 4, 0, $A|collision_flags.npc.touch
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Jaws/Object Data/Map - Jaws.asm"
