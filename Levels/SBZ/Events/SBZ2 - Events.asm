; ---------------------------------------------------------------------------
; SBZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SBZ2_ForegroundInit:

		; set
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.w	#$7F0,(Camera_Y_pos_mask).w
		move.w	#$3C,(Layout_row_index_mask).w					; set level y size: $7FF

		; update FG
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w

; =============== S U B R O U T I N E =======================================

SBZ2_ForegroundEvent:
		move.w	(Screen_shaking_offset).w,d0					; shake foreground
		add.w	d0,(Camera_Y_pos_copy).w

		; update FG
		jmp	(Draw_FGAsYouMove).w

; =============== S U B R O U T I N E =======================================

SBZ2_BackgroundInit:

		; set BG ypos
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		and.w	(Screen_Y_wrap_value).w,d0					; camera limit 50% ($800)
		asr.w	#3,d0								; get 12.5% ($200)
		andi.w	#$3FF,d0							; size limit 25% (BG = $400 pixels)
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 12.5%
		bsr.s	SBZ2_Deform

		; update BG
		jsr	(Reset_TileOffsetPositionEff).w
		jsr	(Refresh_PlaneFull).w

		; deform
		jmp	(PlainDeformation).w

; =============== S U B R O U T I N E =======================================

SBZ2_BackgroundEvent:
		tst.b	(Background_event_flag).w
		bne.s	SBZ2_Transition
		bsr.s	SBZ2_Deform

		; update BG
		jsr	(Draw_BGAsYouMove).w

		; deform
		jsr	(PlainDeformation).w
		jmp	(ShakeScreen_Setup).w
; ---------------------------------------------------------------------------

SBZ2_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

SBZ2_Deform:

		; yscroll (to-do: find another method?)
		move.w	(V_scroll_amount).w,d0						; 100% to d0 ($100)
		ext.l	d0
		asl.l	#5,d0								; get 3200% ($2000)
		add.l	d0,(Camera_Y_pos_BG_copy).w
		andi.w	#$3FF,(Camera_Y_pos_BG_copy).w					; size limit 25% (BG = $400 pixels)

		; xscroll
		move.w	(Camera_X_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	#2,d0								; get 25% ($400)
		move.w	d0,(Camera_X_pos_BG_copy).w					; save 25%
		rts
