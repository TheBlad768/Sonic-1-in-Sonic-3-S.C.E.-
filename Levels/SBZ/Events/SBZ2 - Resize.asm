; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SBZ2_Resize:

		; check camera
		lea	SBZ2_ResizeDat(pc),a1
		jsr	(Resize_MaxYFromX).w

		; check end level
		move.w	(Camera_max_X_pos).w,d0
		subi.w	#256,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.load_boss,(Level_data_addr_RAM.Resize).w

		; create signpost
		jsr	(Create_New_Object).w
		bne.s	.load_boss
		move.l	#Obj_Signpost,code_addr(a1)
		move.w	(Camera_max_X_pos).w,d2
		addi.w	#screen_width/2,d2
		move.w	d2,x_pos(a1)
		move.w	#$510+$90,y_pos(a1)
		st	subtype.byte(a1)						; flag for the standing signpost

.load_boss

		; check xpos
		move.w	#$2040,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.signpost,(Level_data_addr_RAM.Resize).w

.signpost
		move.w	(Signpost_addr).w,d0						; address is empty?
		beq.s	.return								; if it is, branch
		movea.w	d0,a1								; get signpost address

		; check signpost
		btst	#1,state_flags(a1)						; is signpost active?
		beq.s	.return								; if not, branch
		move.l	#.check_signpost,(Level_data_addr_RAM.Resize).w

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

.check_signpost

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return

		; restore control
		clr.w	(Ctrl_1_locked).w						; unlock control 1 and control 2
		jsr	(Restore_PlayerControl).w
		lea	(Player_2).w,a1							; a1=character
		jsr	(Restore_PlayerControl2).w

		; next
		music	mus_MidBoss
		move.l	#.add_xcam,(Level_data_addr_RAM.Resize).w
		move.w	(Camera_max_Y_pos).w,(Camera_min_Y_pos).w
		st	(Disable_wall_grab).w						; disable Knuckles wall grab
		st	(Disable_death_plane).w

		; load art
		lea	(PLC_SE_ControlDesk).l,a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load SBZ2 Eggman intro object
		jsr	(Create_New_Object).w
		bne.s	.add_xcam
		move.l	#Obj_ScrapEggman,code_addr(a1)
		move.w	#$2340,x_pos(a1)
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$94,d0
		move.w	d0,y_pos(a1)

.add_xcam

		; add xpos
		move.w	#$2250,d0
		addq.w	#2,(Camera_max_X_pos).w
		cmp.w	(Camera_max_X_pos).w,d0
		bhi.s	.check_xcam
		move.w	d0,(Camera_max_X_pos).w
		move.l	#.check_xcam,(Level_data_addr_RAM.Resize).w

.check_xcam

		; add xpos
		move.w	#$2250,d0
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.check_ypos
		move.w	d0,(Camera_min_X_pos).w
		move.l	#.check_ypos,(Level_data_addr_RAM.Resize).w

.check_ypos

		; check player 2
		move.w	(Camera_min_Y_pos).w,d0
		addi.w	#256,d0
		cmp.w	(Player_2+y_pos).w,d0
		bhs.s	.not_p2
		move.b	#$83,(Player_2+object_control).w				; lock controls and physics
		move.w	#$A,(Tails_CPU_routine).w					; disable CPU

.not_p2

		; check player 1
		cmp.w	(Player_1+y_pos).w,d0
		bhs.w	.return
		move.b	#$83,(Player_1+object_control).w				; lock controls and physics

		; save player status
		move.b	(Player_1+status).w,(SBZ2_player_roll).w

		; next zone
		move.w	#bytes_to_word(LevelID_LZ,ACT_4),d0
		jmp	(StartNewLevel).w
; ---------------------------------------------------------------------------

SBZ2_ResizeDat:		; y-boundary, xcamera
		dc.w $800, $1A00
		dc.w $510, -1
