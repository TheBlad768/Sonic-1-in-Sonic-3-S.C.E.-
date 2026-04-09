; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SLZ3_Resize:

		; check camera
		move.w	#$2070,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.w	.return
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$210,(Camera_target_max_Y_pos).w
		move.l	#.check_boss,(Level_data_addr_RAM.Resize).w

.check_boss

		; check xpos
		move.w	#$2200,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.w	.return
		move.w	d0,(Camera_min_X_pos).w

		; check ypos
		move.w	#$210,d0
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	.return
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

		; set fade
		music	mus_FadeOut
		move.w	#2*60,(Events_fg+2).w						; fade time
		move.l	#.fade_boss,(Level_data_addr_RAM.Resize).w

.fade_boss

		; wait
		subq.w	#1,(Events_fg+2).w						; subtract 1 from fade delay
		bne.s	.return								; if fade still remains, branch

		; load boss
		move.l	#.return,(Level_data_addr_RAM.Resize).w

		; remove pylon
		moveq	#1,d1								; current slot priority
		jsr	(DeleteSlot_ExtraRender).w

		; load boss art
		lea	(PLC_BossSpikeBall).l,a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load boss palette
		lea	(Pal_Robotnik).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line16).w

		; create boss
		music	mus_ZoneBoss
		move.b	d0,(Current_music+1).w						; save music
		jsr	(Create_New_Object).w
		bne.s	.return
		move.l	#Obj_BossSpikeBall,code_addr(a1)
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$188,d0
		move.w	d0,x_pos(a1)
		moveq	#$28,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

.after_boss
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$23D0,(Camera_X_pos).w
		bne.s	.check_end
		move.l	#.check_end,(Level_data_addr_RAM.Resize).w

.check_end

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return

		; next zone
		move.w	#bytes_to_word(LevelID_SBZ,ACT_1),d0
		jmp	(StartNewLevel).w
