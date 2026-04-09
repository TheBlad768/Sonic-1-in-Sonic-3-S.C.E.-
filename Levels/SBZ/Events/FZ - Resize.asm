; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

FZ_Resize:

		; check xpos
		move.w	#$2500,d0
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.l	#.add_xcam,(Level_data_addr_RAM.Resize).w
		clr.b	(Disable_wall_grab).w						; enable Knuckles wall grab

		; create boss
		jsr	(Create_New_Object).w
		bne.s	.return
		move.l	#Obj_BossFinal,code_addr(a1)
		move.w	#$100,x_pos(a1)
		move.w	#$100,y_pos(a1)

.add_xcam

		; check xpos
		move.w	#$2650,d0
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.l	#.return,(Level_data_addr_RAM.Resize).w

.return
		rts
; ---------------------------------------------------------------------------

.after_boss

		; add xpos
		move.w	#$2900,d0
		addq.w	#2,(Camera_max_X_pos).w
		cmp.w	(Camera_max_X_pos).w,d0
		bhi.s	.after_boss_xcam
		move.w	d0,(Camera_max_X_pos).w
		move.l	#.after_boss_xcam,(Level_data_addr_RAM.Resize).w

.after_boss_xcam

		; check xpos
		move.w	#$2900,d0
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return2
		move.l	#.return2,(Level_data_addr_RAM.Resize).w

.return2
		rts
; ---------------------------------------------------------------------------

.end_boss
		addq.w	#4*2,sp								; exit from resize and current screen
		move.b	#GameModeID_EndingScreen,(Game_mode).w				; set screen mode to Ending
		clr.b	(Last_star_post_hit).w
		clr.b	(Special_bonus_entry_flag).w
		rts
