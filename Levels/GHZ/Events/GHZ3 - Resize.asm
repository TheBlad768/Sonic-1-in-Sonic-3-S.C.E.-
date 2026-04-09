; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GHZ3_Resize:

		; check camera
		move.w	#$300,(Camera_target_max_Y_pos).w
		cmpi.w	#$580,(Camera_X_pos).w
		blo.s	.return
		move.w	#$310,(Camera_target_max_Y_pos).w
		cmpi.w	#$B60,(Camera_X_pos).w
		blo.s	.return
		cmpi.w	#$280,(Camera_Y_pos).w
		blo.s	.back
		move.w	#$400,(Camera_target_max_Y_pos).w
		cmpi.w	#$1580,(Camera_X_pos).w
		bhs.s	.check

		; set
		move.w	#$4C0,d0
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

.check
		cmpi.w	#$1960,(Camera_X_pos).w
		bhs.s	.back

.return
		rts
; ---------------------------------------------------------------------------

.back
		move.w	#$300,(Camera_target_max_Y_pos).w
		move.l	#.check_boss_intro,(Level_data_addr_RAM.Resize).w
		rts
; ---------------------------------------------------------------------------

.check_boss_intro
		cmpi.w	#$1960,(Camera_X_pos).w
		bhs.s	.check_boss_intro_xcamera

		; back
		move.l	#GHZ3_Resize,(Level_data_addr_RAM.Resize).w

.check_boss_intro_xcamera

		; check xpos
		move.w	#$2B60,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.s	.return
		move.w	d0,(Camera_min_X_pos).w

		; check ypos
		move.w	#$300,d0
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	.return
;		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

		; load intro
		music	mus_FadeOut							; fade out music
		move.w	#2*60,(Events_fg+2).w						; fade time

		; set
		moveq	#0,d0
		move.l	d0,(Level_data_addr_RAM.Resize).w
		move.l	d0,(Level_data_addr_RAM.AnimateTiles).w				; disable animate tiles

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
		jsr	(Create_New_Object).w
		bne.s	.return
		move.l	#Obj_BossBall_Scaled,code_addr(a1)
		moveq	#-$20,d0
		add.w	(Camera_X_pos).w,d0
		move.w	d0,x_pos(a1)
		moveq	#-$40,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a1)

.return2
		rts
; ---------------------------------------------------------------------------

.skip_boss_intro
		move.l	#.fade_boss,(Level_data_addr_RAM.Resize).w

.fade_boss
		subq.w	#1,(Events_fg+2).w						; subtract 1 from fade delay
		bne.s	.return2							; if fade still remains, branch

.load_boss

		; set
		move.l	#.return2,(Level_data_addr_RAM.Resize).w

		; set boss intro flag
		st	(Intro_flag).w							; don't show boss intro again

		; load boss art
		lea	(PLC_BossBall).l,a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load boss palette
		lea	(Pal_Robotnik).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line16).w

		; create boss
		music	mus_ZoneBoss
		move.b	d0,(Current_music+1).w						; save music
		jsr	(Create_New_Object).w
		bne.s	.return3
		move.l	#Obj_BossBall,code_addr(a1)
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$110,d0
		move.w	d0,x_pos(a1)
		moveq	#-$80,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a1)

.return3
		rts
; ---------------------------------------------------------------------------

.after_boss
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$2D0C,(Camera_X_pos).w
		bne.s	.check_end
		move.l	#.check_end,(Level_data_addr_RAM.Resize).w

.check_end

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return3

		; next zone
		move.w	#bytes_to_word(LevelID_MZ,ACT_1),d0
		jmp	(StartNewLevel).w
