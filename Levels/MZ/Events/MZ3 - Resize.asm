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
		music	mus_FadeOut
		move.l	#.return,(Level_data_addr_RAM.Resize).w

		; check intro flag

	if BossIntro
		tst.b	(Intro_flag).w
		bne.s	Load_MZ3Boss_Skip
	else
		bra.s	Load_MZ3Boss_Skip
	endif

		; stop update time counter
		clr.b	(Update_HUD_timer).w

		; create intro
		sfx	sfx_BossZoom
		jsr	(Create_New_Object).w
		bne.s	.return
		move.l	#Obj_BossFire_Scaled,address(a1)
		moveq	#$40,d1
		move.w	(Camera_X_pos).w,d0
		sub.w	d1,d0
		move.w	d0,x_pos(a1)
		add.w	(Camera_max_Y_pos).w,d1
		move.w	d1,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

Load_MZ3Boss_Skip:
		move.w	#2*60,(Events_fg+2).w						; fade time
		move.l	#Load_MZ3Boss_Wait,(Level_data_addr_RAM.Resize).w

Load_MZ3Boss_Wait:
		subq.w	#1,(Events_fg+2).w
		bne.s	MZ3_Resize.return

Load_MZ3Boss:

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
		bne.s	.return
		move.l	#Obj_BossFire,address(a1)
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$170,d0
		move.w	d0,x_pos(a1)
		moveq	#$30,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

End_MZ3Boss:
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$1C80,(Camera_X_pos).w
		bne.s	.check
		move.l	#.check,(Level_data_addr_RAM.Resize).w

.check
		tst.b	(End_of_level_flag).w
		beq.s	Load_MZ3Boss.return

		; next zone
		move.w	#bytes_to_word(LevelID_SYZ,0),d0
		jmp	(StartNewLevel).w
; ---------------------------------------------------------------------------

MZ3_ResizeDat:	; y-boundary, xcamera
		dc.w $720, $1760
		dc.w $200, -1
