; ---------------------------------------------------------------------------
; Object 7D - hidden points at the end of a level
; ---------------------------------------------------------------------------

; Dynamic object variables
bonus_timelen		= objoff_2E ; length of time to display bonus sprites

; =============== S U B R O U T I N E =======================================

Obj_HiddenBonus:

		; check
		tst.b	(Level_results_flag).w						; is the end of level flag set?
		beq.s	.chkdel								; if not, branch
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.chkdel								; if yes, branch

		; check xypos
		lea	(Player_1).w,a1							; a1=character
		lea	.range(pc),a2
		jsr	(Check_InMyRange).w
		beq.s	.chkdel								; if the player is out of range, branch

		; init
		lea	ObjDat_HiddenBonus(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.draw,address(a0)
		move.b	subtype(a0),mapping_frame(a0)
		move.w	#(2*60)-1,bonus_timelen(a0)					; set display time to 2 seconds
		sfx	sfx_HiddenBonus							; play bonus sound

		; add score
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	.points(pc,d0.w),d0						; load bonus points array
		jsr	(HUD_AddToScore).w

.chkdel

		; delete the object and create it again
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.range
		dc.w -16, 32	; xpos (16x16)
		dc.w -16, 32	; ypos (16x16)
.points

		; bonus points array
		dc.w 0, 1000, 100, 10
; ---------------------------------------------------------------------------

.draw
		subq.w	#1,bonus_timelen(a0)						; decrement display time
		bmi.s	.delete								; if time is zero, branch

		; delete the object and do not create it again
		out_of_xrange.s	.delete
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_HiddenBonus:	subObjData Map_HiddenBonus, $460, 0, TRUE, 32, 32, 1, 0, 0
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Main/Hidden Bonus/Object Data/Map - Hidden Bonus.asm"
