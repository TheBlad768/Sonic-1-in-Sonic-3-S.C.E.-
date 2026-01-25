; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MZ1_Resize:
		move.w	#$1D0,d0
		cmpi.w	#$900,(Camera_X_pos).w
		blo.s	.set
		move.w	#$220,d0
		cmpi.w	#$F00,(Camera_X_pos).w
		blo.s	.set
		move.w	#$340,d0
		cmpi.w	#$340,(Camera_Y_pos).w
		blo.s	.set
		move.l	#.loc_6FEA,(Level_data_addr_RAM.Resize).w

.set
		move.w	d0,(Camera_target_max_Y_pos).w

		; check end level
		bra.w	.checkend
; ---------------------------------------------------------------------------

.loc_6FEA
		cmpi.w	#$340,(Camera_Y_pos).w
		bhs.s	.loc_6FF8
		move.w	(Camera_max_Y_pos).w,d0						; fix S1 bug...
		cmp.w	(Camera_target_max_Y_pos).w,d0
		blt.s	.loc_6FF8
		move.l	#MZ1_Resize,(Level_data_addr_RAM.Resize).w
		rts
; ---------------------------------------------------------------------------

.loc_6FF8
		clr.w	(Camera_min_Y_pos).w
		cmpi.w	#$1000,(Camera_X_pos).w
		bhs.s	.locret_702C
		move.w	#$340,(Camera_min_Y_pos).w
		move.w	#$340,(Camera_target_max_Y_pos).w
		cmpi.w	#$C90,(Camera_X_pos).w
		bhs.s	.locret_702C
		move.w	#$500,(Camera_target_max_Y_pos).w
		cmpi.w	#$370,(Camera_Y_pos).w
		blo.s	.locret_702C
		move.l	#.loc_702E,(Level_data_addr_RAM.Resize).w

.locret_702C
		rts
; ---------------------------------------------------------------------------

.loc_702E
		cmpi.w	#$370,(Camera_Y_pos).w
		bhs.s	.loc_703C
		move.l	#.loc_6FEA,(Level_data_addr_RAM.Resize).w
		rts
; ---------------------------------------------------------------------------

.loc_703C
		cmpi.w	#$500,(Camera_Y_pos).w
		blo.s	.locret_704E
		cmpi.w	#$D80,(Camera_X_pos).w
		blo.s	.locret_704E
		move.w	#$500,(Camera_min_Y_pos).w
		move.l	#.loc_7050,(Level_data_addr_RAM.Resize).w

.locret_704E
		rts
; ---------------------------------------------------------------------------

.loc_7050
		cmpi.w	#$D80,(Camera_X_pos).w
		bhs.s	.locj_76B8
		cmpi.w	#$340,(Camera_min_Y_pos).w
		beq.s	.checkend
		subq.w	#2,(Camera_min_Y_pos).w

.locret_76B6
		rts
; ---------------------------------------------------------------------------

.locj_76B8
		cmpi.w	#$500,(Camera_min_Y_pos).w
		beq.s	.locj_76CE
		cmpi.w	#$500,(Camera_Y_pos).w
		blo.s	.checkend
		move.w	#$500,(Camera_min_Y_pos).w

.locj_76CE
		cmpi.w	#$1070,(Camera_X_pos).w
		blo.s	.checkend
		clr.w	(Camera_min_Y_pos).w
		move.w	#$500,(Camera_target_max_Y_pos).w
		cmpi.w	#$1630,(Camera_X_pos).w
		blo.s	.checkend
		move.w	#$210,(Camera_target_max_Y_pos).w

.checkend

		; check end level
		move.w	(Camera_max_X_pos).w,d0
		subi.w	#256,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.locret_76B6
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$210,(Camera_target_max_Y_pos).w
		move.l	#.checkxpos,(Level_data_addr_RAM.Resize).w

		; load hidden bonus art
		QueueKosPlusModule	ArtKosPM_HiddenBonus, $460

		; create signpost
		jsr	(Create_New_Object).w
		bne.s	.checkxpos
		move.l	#Obj_EndSign,address(a1)
		move.w	(Camera_max_X_pos).w,d2
		addi.w	#screen_width/2,d2
		move.w	d2,x_pos(a1)
		move.w	#$210+$82,y_pos(a1)
		st	subtype(a1)							; flag for the standing signpost

.checkxpos

		; check xpos
		move.w	(Camera_max_X_pos).w,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.signpost,(Level_data_addr_RAM.Resize).w

.signpost
		move.w	(Signpost_addr).w,d0						; address is empty?
		beq.s	.return								; if it is, branch
		movea.w	d0,a1								; get signpost address

		; check signpost
		tst.b	objoff_39(a1)							; is signpost active?
		beq.s	.return								; if not, branch
		move.l	#.checksign,(Level_data_addr_RAM.Resize).w

		; set flags
		st	(Last_act_end_flag).w						; disable background event and Title Card
		st	(Level_results_flag).w						; end of level is in effect

		; clear flags
		moveq	#0,d0
		move.b	d0,(Update_HUD_timer).w						; stop timer
		move.b	d0,(End_of_level_flag).w
		move.b	d0,(Boss_flag).w

.return
		rts
; ---------------------------------------------------------------------------

.checksign
		tst.b	(End_of_level_flag).w
		beq.s	.return

		; next act
		move.b	#1,(Current_act).w						; set act 2
		move.w	(Current_zone_and_act).w,(Apparent_zone_and_act).w
		st	(Restart_level_flag).w
		clr.b	(Last_star_post_hit).w
		clr.b	(Special_bonus_entry_flag).w
		rts
