; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MZ1_Resize:

		; check camera
		move.w	#$1D0,d0
		cmpi.w	#$900,(Camera_X_pos).w
		blo.s	.set
		move.w	#$220,d0
		cmpi.w	#$F00,(Camera_X_pos).w
		blo.s	.set
		move.w	#$340,d0
		cmpi.w	#$340,(Camera_Y_pos).w
		blo.s	.set
		move.l	#.check_back,(Level_data_addr_RAM.Resize).w

.set
		move.w	d0,(Camera_target_max_Y_pos).w

		; check end level
		bra.w	.check_end
; ---------------------------------------------------------------------------

.check_back
		cmpi.w	#$340,(Camera_Y_pos).w
		bhs.s	.check_next

		; wait camera
		move.w	(Camera_max_Y_pos).w,d0						; fix Sonic 1 camera bug...
		cmp.w	(Camera_target_max_Y_pos).w,d0
		blt.s	.check_next

		; back
		move.l	#MZ1_Resize,(Level_data_addr_RAM.Resize).w
		rts
; ---------------------------------------------------------------------------

.check_next
		clr.w	(Camera_min_Y_pos).w
		cmpi.w	#$1000,(Camera_X_pos).w
		bhs.s	.return
		move.w	#$340,(Camera_min_Y_pos).w
		move.w	#$340,(Camera_target_max_Y_pos).w
		cmpi.w	#$C90,(Camera_X_pos).w
		bhs.s	.return
		move.w	#$500,(Camera_target_max_Y_pos).w
		cmpi.w	#$370,(Camera_Y_pos).w
		blo.s	.return
		move.l	#.check_back2,(Level_data_addr_RAM.Resize).w

.return
		rts
; ---------------------------------------------------------------------------

.check_back2
		cmpi.w	#$370,(Camera_Y_pos).w
		bhs.s	.check_next2

		; back
		move.l	#.check_back,(Level_data_addr_RAM.Resize).w
		rts
; ---------------------------------------------------------------------------

.check_next2
		cmpi.w	#$500,(Camera_Y_pos).w
		blo.s	.return2
		cmpi.w	#$D80,(Camera_X_pos).w
		blo.s	.return2

		; next
		move.w	#$500,(Camera_min_Y_pos).w
		move.l	#.check_next3,(Level_data_addr_RAM.Resize).w

.return2
		rts
; ---------------------------------------------------------------------------

.check_next3
		cmpi.w	#$D80,(Camera_X_pos).w
		bhs.s	.check_next4
		cmpi.w	#$340,(Camera_min_Y_pos).w
		beq.s	.check_end
		subq.w	#2,(Camera_min_Y_pos).w

.return3
		rts
; ---------------------------------------------------------------------------

.check_next4
		cmpi.w	#$500,(Camera_min_Y_pos).w
		beq.s	.skip_ypos
		cmpi.w	#$500,(Camera_Y_pos).w
		blo.s	.check_end
		move.w	#$500,(Camera_min_Y_pos).w

.skip_ypos
		cmpi.w	#$1070,(Camera_X_pos).w
		blo.s	.check_end
		clr.w	(Camera_min_Y_pos).w
		move.w	#$500,(Camera_target_max_Y_pos).w
		cmpi.w	#$1630,(Camera_X_pos).w
		blo.s	.check_end
		move.w	#$210,(Camera_target_max_Y_pos).w

.check_end

		; check end level
		move.w	(Camera_max_X_pos).w,d0
		subi.w	#256,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return3
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$210,(Camera_target_max_Y_pos).w
		move.l	#.check_xpos,(Level_data_addr_RAM.Resize).w

		; load hidden bonus art
		QueueKosPlusModule	ArtKosPlusM_HiddenBonus, $460

		; create signpost
		jsr	(Create_New_Object).w
		bne.s	.check_xpos
		move.l	#Obj_Signpost,code_addr(a1)
		move.w	(Camera_max_X_pos).w,d2
		addi.w	#screen_width/2,d2
		move.w	d2,x_pos(a1)
		move.w	#$210+$82,y_pos(a1)
		st	subtype.byte(a1)						; flag for the standing signpost

.check_xpos

		; check xpos
		move.w	(Camera_max_X_pos).w,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return4
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.signpost,(Level_data_addr_RAM.Resize).w

.signpost
		move.w	(Signpost_addr).w,d0						; address is empty?
		beq.s	.return4							; if it is, branch
		movea.w	d0,a1								; get signpost address

		; check signpost
		btst	#1,state_flags(a1)						; is signpost active?
		beq.s	.return4							; if not, branch
		move.l	#.check_signpost,(Level_data_addr_RAM.Resize).w

		; set flags
		st	(Last_act_end_flag).w						; disable background event and Title Card
		st	(Level_results_flag).w						; end of level is in effect

		; clear flags
		moveq	#0,d0
		move.b	d0,(Update_HUD_timer).w						; stop timer
		move.b	d0,(End_of_level_flag).w
		move.b	d0,(Boss_flag).w

.return4
		rts
; ---------------------------------------------------------------------------

.check_signpost

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return4

		; next act
		move.b	#ACT_2,(Current_act).w						; set act 2
		move.w	(Current_zone_and_act).w,(Apparent_zone_and_act).w
		st	(Restart_level_flag).w
		clr.b	(Last_star_post_hit).w
		clr.b	(Special_bonus_entry_flag).w
		rts
