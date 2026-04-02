; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SLZ3_Resize:
		move.w	#$2070,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.w	.return
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$210,(Camera_target_max_Y_pos).w
		move.l	#.boss,(Level_data_addr_RAM.Resize).w

.boss

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
		move.l	#.fade,(Level_data_addr_RAM.Resize).w

.fade
		subq.w	#1,(Events_fg+2).w
		bne.s	.return

		; load boss
		move.l	#.return,(Level_data_addr_RAM.Resize).w

		; remove pylon
		moveq	#1,d1								; current slot priority
		jsr	(DeleteSlot_ExtraRender).w

		; load art
		lea	(PLC_BossSpikeBall).l,a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load palette
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

End_SLZ3Boss:
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$23D0,(Camera_X_pos).w
		bne.s	.check
		move.l	#.check,(Level_data_addr_RAM.Resize).w

.check
		tst.b	(End_of_level_flag).w
		beq.s	SLZ3_Resize.return

		; next zone
		move.w	#bytes_to_word(LevelID_SBZ,0),d0
		jmp	(StartNewLevel).w
