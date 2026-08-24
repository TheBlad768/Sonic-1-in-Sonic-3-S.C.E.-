; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MZ3_Resize:

		; check camera
		lea	MZ3_ResizeDat(pc),a1
		jsr	(Resize_MaxYFromX).w

		; check xpos
		move.w	#$1B00,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_saved_min_X_pos).w

		; check ypos
		move.w	#$200,d0
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	.return
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

		; load intro
		music	cmd_FadeOut
		move.l	#.return,(Level_data_addr_RAM.Resize).w

		; check intro flag

	if BossIntro
		tst.b	(Intro_flag).w
		bne.s	.skip_boss_intro
	else
		bra.s	.skip_boss_intro
	endif

		; stop update time counter
		clr.b	(Update_HUD_timer).w

		; create intro
		sfx	sfx_BossZoom
		jsr	(Create_New_Object).w
		bne.s	.return
		move.l	#Obj_BossFire_Scaled,code_addr(a1)
		moveq	#$40,d1
		move.w	(Camera_X_pos).w,d0
		sub.w	d1,d0
		move.w	d0,x_pos(a1)
		add.w	(Camera_max_Y_pos).w,d1
		move.w	d1,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

.skip_boss_intro
		move.w	#2*60,(Events_fg+2).w						; fade time
		move.l	#.fade_boss,(Level_data_addr_RAM.Resize).w

.fade_boss

		; wait
		subq.w	#1,(Events_fg+2).w						; subtract 1 from fade delay
		bne.s	.return								; if fade still remains, branch

.load_boss

		; set
		clr.l	(Level_data_addr_RAM.Resize).w					; set return for resize

		; set intro flag
		st	(Intro_flag).w

		; load art
		lea	(PLC_BossFire).l,a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load palette
		lea	(Pal_Robotnik).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line16).w

		; create boss
		music	mus_ZoneBoss
		move.b	d0,(Current_music+1).w						; save music
		jsr	(Create_New_Object).w
		bne.s	.return2
		move.l	#Obj_BossFire,code_addr(a1)
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$170,d0
		move.w	d0,x_pos(a1)
		moveq	#$30,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a1)

.return2
		rts
; ---------------------------------------------------------------------------

.after_boss
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$1C80,(Camera_X_pos).w
		bne.s	.check_end
		move.l	#.check_end,(Level_data_addr_RAM.Resize).w

.check_end

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return2

		; next zone
		move.w	#bytes_to_word(LevelID_SYZ,ACT_1),d0
		jmp	(StartNewLevel).w
; ---------------------------------------------------------------------------

MZ3_ResizeDat:	; y-boundary, xcamera
		dc.w $720, $1760
		dc.w $200, -1
