; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GHZ1_Resize:

		; check camera
		lea	GHZ1_ResizeDat(pc),a1
		jsr	(Resize_MaxYFromX).w

		; check end level
		move.w	(Camera_max_X_pos).w,d0
		subi.w	#256,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.checkxpos,(Level_data_addr_RAM.Resize).w

		; load hidden bonus art
		QueueKosPlusModule	ArtKosPM_HiddenBonus, $460

		; create signpost
		jsr	(Create_New_Sprite).w
		bne.s	.checkxpos
		move.l	#Obj_EndSign,address(a1)
		move.w	(Camera_max_X_pos).w,d2
		addi.w	#320/2,d2
		move.w	d2,x_pos(a1)
		move.w	#$400+$A4,y_pos(a1)
		st	subtype(a1)												; flag for the standing signpost

.checkxpos

		; check xpos
		move.w	(Camera_max_X_pos).w,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.signpost,(Level_data_addr_RAM.Resize).w

.signpost
		move.w	(Signpost_addr).w,d0									; address is empty?
		beq.s	.return												; if it is, branch
		movea.w	d0,a1												; get signpost address

		; check signpost
		tst.b	objoff_39(a1)												; is signpost active?
		beq.s	.return												; if not, branch
		move.l	#.checksign,(Level_data_addr_RAM.Resize).w

		; set flags
		st	(Last_act_end_flag).w										; disable background event and Title Card
		st	(Level_results_flag).w										; end of level is in effect

		; clear flags
		moveq	#0,d0
		move.b	d0,(Update_HUD_timer).w								; stop timer
		move.b	d0,(End_of_level_flag).w
		move.b	d0,(Boss_flag).w

.return
		rts
; ---------------------------------------------------------------------------

.checksign
		tst.b	(End_of_level_flag).w
		beq.s	.return

		; next act
		move.b	#1,(Current_act).w									; set act 2
		move.w	(Current_zone_and_act).w,(Apparent_zone_and_act).w
		st	(Restart_level_flag).w
		clr.b	(Last_star_post_hit).w
		clr.b	(Special_bonus_entry_flag).w
		rts
; ---------------------------------------------------------------------------

GHZ1_ResizeDat:		; y-boundary, xcamera
		dc.w $300, $1980
		dc.w $400, -1
