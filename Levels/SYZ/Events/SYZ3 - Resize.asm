; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SYZ3_Resize:

		; check camera
		move.w	#$2D00,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.w	.return
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$4B0,(Camera_target_max_Y_pos).w
		move.l	#.check_boss,(Level_data_addr_RAM.Resize).w

.check_boss

		; check xpos
		move.w	#$2E00,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.w	.return
		move.w	d0,(Camera_min_X_pos).w

		; check ypos
		move.w	#$4B0,d0
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	.return
		move.w	d0,(Camera_min_Y_pos).w

		; set fade
		music	cmd_FadeOut
		move.w	#2*60,(Events_fg+2).w						; fade time
		move.l	#.fade,(Level_data_addr_RAM.Resize).w
		clr.l	(Level_data_addr_RAM.AnimateTiles).w				; disable animate tiles

.fade

		; wait
		subq.w	#1,(Events_fg+2).w						; subtract 1 from fade delay
		bne.s	.return								; if fade still remains, branch

		; load boss
		clr.l	(Level_data_addr_RAM.Resize).w					; set return for resize
		move.l	#SYZ3_ForegroundEvent,(Level_data_addr_RAM.ScreenEvent).w

		; load boss art
		lea	(PLC_BossBlock).l,a5
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
		move.l	#Obj_BossBlock,code_addr(a1)
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$1B0,d0
		move.w	d0,x_pos(a1)
		moveq	#$28,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

.after_boss
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$3000,(Camera_X_pos).w
		bne.s	.check_end
		move.l	#.check_end,(Level_data_addr_RAM.Resize).w

.check_end

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return

		; next zone
		move.w	#bytes_to_word(LevelID_LZ,ACT_1),d0
		jmp	(StartNewLevel).w
