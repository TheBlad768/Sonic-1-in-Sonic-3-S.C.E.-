; ---------------------------------------------------------------------------
; SLZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SLZ1_ForegroundInit:

		; update FG
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w

; =============== S U B R O U T I N E =======================================

SLZ1_BackgroundInit:
		bsr.s	SLZ1_Deform

		; update BG
		jsr	(Reset_TileOffsetPositionEff).w
		moveq	#0,d1								; Camera_X_pos_BG_copy
		jsr	(Refresh_PlaneFull).w

		; deform
		lea	SLZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w

; =============== S U B R O U T I N E =======================================

SLZ1_BackgroundEvent:
		tst.b	(Background_event_flag).w
		bne.s	SLZ1_Transition
		bsr.s	SLZ1_Deform

		; update BG
		lea	(Camera_Y_pos_BG_copy).w,a6
		lea	(Camera_Y_pos_BG_rounded).w,a5
		moveq	#0,d1								; Camera_X_pos_BG_copy
		moveq	#gameplay_plane_width/block_width,d6
		jsr	(Draw_TileRow).w

		; deform
		lea	SLZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w
; ---------------------------------------------------------------------------

SLZ1_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

SLZ1_Deform:

		; yscroll
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	d0								; get 50% ($800)
		addi.w	#192,d0								; fix pos
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 54.6875%

		; xscroll
		lea	(H_scroll_table).w,a1
		move.l	(Camera_X_pos_copy).w,d0					; 100% to d0 ($10000)

		; unused
		clr.w	(a1)+								; save 0%

		; stars
		move.l	d0,d1								; copy 100% to d1 ($10000)
		move.l	d0,d2								; copy 100% to d2 ($10000)
		asr.l	#5,d2								; get 3.125% ($800)

	rept 27
		swap	d1
		move.w	d1,(a1)+							; save 100% - 3.125%
		swap	d1
		sub.l	d2,d1								; sub 3.125% from d1 ($800)
	endr

		; last star
		swap	d1
		move.w	d1,(a1)+							; save 100% - 3.125%

		; distant black buildings
		move.l	d0,d1								; copy 100% to d1 ($10000)
		asr.l	#4,d1								; get 6.25% ($1000)
		move.l	d1,d2								; copy 6.25% to d2 ($1000)
		add.l	d1,d2								; add 6.25% to d2 ($2000)
		add.l	d1,d2								; add 6.25% to d2 ($3000)
		swap	d2
		move.w	d2,(a1)+							; save 18.75% ($3000)

		; closer buildings
		asr.l	d0								; get 50% ($8000)
		move.l	d0,d1								; copy 50% to d1 ($8000)
		asr.l	d0								; get 25% ($4000)
		swap	d0
		move.w	d0,(a1)+							; save 25%

		; bottom part of background
		swap	d1
		move.w	d1,(a1)+							; save 50%
		rts
; ---------------------------------------------------------------------------

SLZ1_BGDeformArray:
		dc.w 192	; unused size
		dcb.w 28, 16	; stars size
		dcb.w 2, 80	; distant black buildings and closer buildings size
		dc.w $7FFF	; bottom part of background size ; end marker
