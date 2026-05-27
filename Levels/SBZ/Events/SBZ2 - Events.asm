; ---------------------------------------------------------------------------
; SBZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SBZ3_ForegroundInit:
		st	(Disable_wall_grab).w						; disable Knuckles wall grab

; =============== S U B R O U T I N E =======================================

SBZ2_ForegroundInit:

		; set
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.w	#$7F0,(Camera_Y_pos_mask).w
		move.w	#$3C,(Layout_row_index_mask).w					; set layout y size: $7FF

		; update FG
		jsr	(Reset_FGTileOffsetPositionHScroll).w
		jmp	(Refresh_PlaneFullHScroll).w

; =============== S U B R O U T I N E =======================================

SBZ2_ForegroundEvent:
		move.w	(Screen_shaking_offset).w,d0					; shake foreground
		add.w	d0,(Camera_Y_pos_copy).w

		; update FG
		jmp	(Draw_FGAsYouMove).w

; =============== S U B R O U T I N E =======================================

SBZ2_BackgroundInit:

		; set BG ypos
		move.w	(Camera_Y_pos_copy).w,d0
		move.w	d0,(Events_bg).w
		move.w	d0,(Events_bg+2).w
		bsr.s	SBZ2_Deform

		; update BG
		jsr	(Reset_BGTileOffsetPositionHScroll).w
		jsr	(Refresh_PlaneFullHScroll).w

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

		; yscroll
		lea	(Events_bg).w,a1
		move.w	(Camera_Y_pos_copy).w,d0
		move.w	(Screen_Y_wrap_value).w,d3
		addq.w	#1,d3								; wrap size
		move.w	d3,d2
		lsr.w	d2								; wrap half size
		jsr	(Adjust_BGDuringLoop).w
		move.w	-(a1),d0							; 100% to d0 ($1000) ; Events_bg+2
		move.w	(Screen_shaking_offset).w,d1					; shake data to d1
		sub.w	d1,d0
		asr.w	#3,d0								; get 12.5% ($200)
		add.w	d1,d0
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 12.5%

		; xscroll
		move.w	(Camera_X_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	#2,d0								; get 25% ($400)
		move.w	d0,(Camera_X_pos_BG_copy).w					; save 25%
		rts
