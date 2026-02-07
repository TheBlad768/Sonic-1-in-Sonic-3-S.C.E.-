; ---------------------------------------------------------------------------
; SYZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SYZ1_ScreenInit:

		; update FG
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w

; =============== S U B R O U T I N E =======================================

SYZ3_ScreenEvent:
		tst.b	(Screen_event_flag).w
		beq.s	.draw

		; redraw boss block
		move.w	(Camera_X_pos_copy).w,d1
		move.w	(Camera_Y_pos_copy).w,d2
		jsr	(Draw_PlaneVertSingleBottomUp).w
		bpl.s	.draw
		clr.b	(Screen_event_flag).w						; clear redraw flag

.draw

		; update FG
		jmp	(Draw_FGAsYouMove).w

; =============== S U B R O U T I N E =======================================

SYZ1_BackgroundInit:
		bsr.s	SYZ1_Deform

		; update BG
		jsr	(Reset_TileOffsetPositionEff).w
		moveq	#0,d1								; Camera_X_pos_BG_copy
		jsr	(Refresh_PlaneFull).w

		; deform
		lea	SYZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w

; =============== S U B R O U T I N E =======================================

SYZ1_BackgroundEvent:
		tst.b	(Background_event_flag).w
		bne.s	SYZ1_Transition
		bsr.s	SYZ1_Deform

		; update BG
		lea	(Camera_Y_pos_BG_copy).w,a6
		lea	(Camera_Y_pos_BG_rounded).w,a5
		moveq	#0,d1								; Camera_X_pos_BG_copy
		moveq	#gameplay_plane_width/block_width,d6
		jsr	(Draw_TileRow).w

		; deform
		lea	SYZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w
; ---------------------------------------------------------------------------

SYZ1_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

SYZ1_Deform:

		; yscroll
		move.l	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($10000)
		asr.l	#3,d0								; get 12.5% ($2000)
		move.l	d0,d1								; copy 12.5% to d1 ($2000)
		asr.l	d1								; get 6.25% ($1000)
		add.l	d1,d0								; add 6.25% to d0 ($3000)
		swap	d0
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 18.75% ($3000)

		; xscroll
		lea	(H_scroll_table).w,a1
		move.l	(Camera_X_pos_copy).w,d0					; 100% to d0 ($10000)

		; clouds
		move.l	d0,d1								; copy 100% to d1 ($10000)
		asr.l	d1								; get 50% ($8000)
		move.l	d1,d2								; copy 50% to d2 ($8000)
		asr.l	#4,d2								; get 3.125% ($800)
		move.l	d2,d3								; copy 3.125% to d3 ($800)
		asr.l	#2,d3								; get 0.78125% ($200)
		add.l	d3,d2								; add 3.125% to d2 ($A00)
		add.l	d3,d3								; calc 1.5625% ($400)
		add.l	d3,d2								; add 5.46875% to d2 ($E00)

	rept 7
		swap	d1
		move.w	d1,(a1)+							; save 50% - 5.46875%
		swap	d1
		sub.l	d2,d1								; sub 5.46875% to d1 ($E00)
	endr

		; last cloud
		swap	d1
		move.w	d1,(a1)+							; save 50% - 5.46875%

		; mountains
		move.l	d0,d1								; copy 100% to d1 ($10000)
		asr.l	#3,d1								; get 12.5% ($2000)
		swap	d1
		move.w	d1,(a1)+							; save 12.5%

		; buildings
		move.l	d0,d1								; copy 100% to d1 ($10000)
		asr.l	#2,d1								; get 25% ($4000)
		swap	d1
		move.w	d1,(a1)+							; save 25%

		; bushes
		asr.l	d0								; get 50% ($8000)
		move.l	d0,d1								; copy 50% to d1 ($8000)
		asr.l	#4,d1								; get 3.125% ($800)
		move.l	d1,d2								; copy 3.125% to d2 ($800)
		asr.l	#3,d2								; get 0.390625% ($100)
		add.l	d2,d1								; add 3.515625% to d2 ($900)

	rept 13
		swap	d0
		move.w	d0,(a1)+							; save 50% - 3.515625%
		swap	d0
		add.l	d1,d0								; add 3.515625% to d0 ($900)
	endr

		; last bushes
		swap	d0
		move.w	d0,(a1)+							; save 50% - 3.515625%
		rts
; ---------------------------------------------------------------------------

SYZ1_BGDeformArray:
		dcb.w 8, 16	; clouds
		dc.w 80		; mountains
		dc.w 96		; buildings
		dcb.w 14, 16	; bushes
		dc.w $7FFF
