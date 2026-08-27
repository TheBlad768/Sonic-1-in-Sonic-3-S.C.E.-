; ---------------------------------------------------------------------------
; MZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MZ1_ForegroundInit:

		; update FG
		jsr	(Reset_FGTileOffsetPositionHScroll).w
		jmp	(Refresh_PlaneFullHScroll).w

; =============== S U B R O U T I N E =======================================

MZ1_BackgroundInit:
		bsr.w	MZ1_Deform

		; update BG
		jsr	(Reset_BGTileOffsetPositionHScroll).w
		lea	MZ1_BGDrawArray(pc),a4
		lea	(H_scroll_table+$100).w,a5
		clr.l	(a5)								; sky, clouds (draw the starting position)
		moveq	#-block_width,d3						; set align (16 pixels)
		move.w	-$EA(a5),d4
		move.w	d4,4(a5)							; update mountains
		and.w	d3,d4								; align
		move.w	d4,6(a5)							; mountains (copy for Draw_TileColumn)
		move.w	-$E8(a5),d4
		move.w	d4,8(a5)							; bushes
		and.w	d3,d4								; align
		move.w	d4,$A(a5)							; bushes (copy for Draw_TileColumn)
		move.w	-$E6(a5),d4
		move.w	d4,$C(a5)							; wall
		and.w	d3,d4								; align
		move.w	d4,$E(a5)							; wall (copy for Draw_TileColumn)
		jsr	(Refresh_PlaneTileDeformHScroll).w

		; deform
		lea	MZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyBGDeformation).w

; =============== S U B R O U T I N E =======================================

MZ1_BackgroundEvent:
		tst.b	(Background_event_flag).w
		bne.s	MZ1_Transition
		bsr.s	MZ1_Deform

		; update BG
		lea	MZ1_BGDrawArray(pc),a4
		lea	(H_scroll_table+$100).w,a5
		clr.w	(a5)								; sky, clouds (not update)
		move.w	-$EA(a5),4(a5)							; update mountains
		move.w	-$E8(a5),8(a5)							; update bushes
		move.w	-$E6(a5),$C(a5)							; update wall
		moveq	#gameplay_plane_width/block_width,d6
		moveq	#(MZ1_BGDrawArray_end-MZ1_BGDrawArray)/2,d5
		jsr	(Draw_BGHDeform).w

		; deform
		lea	MZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyBGDeformation).w
; ---------------------------------------------------------------------------

MZ1_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

MZ1_Deform:

.setBG =	1									; original or alt

		; yscroll
		move.w	#512,d0								; start with 512px, ignoring 4 chunks
		move.w	(Camera_Y_pos_copy).w,d1
		subi.w	#512-56,d1							; 0% scrolling when y <= 56px
		blo.s	.noYscroll
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0

.noYscroll
		move.w	d0,(Camera_Y_pos_BG_copy).w

		; xscroll
		lea	(H_scroll_table).w,a1
		move.l	(Camera_X_pos_copy).w,d0					; 100% to d0 ($10000)

		; sky
		clr.w	(a1)+								; save 0%

		; clouds
		move.l	d0,d1								; copy 100% to d1 ($10000)
		asr.l	d1								; get 50% ($8000)
		move.l	d1,d2								; copy 50% to d2 ($8000)

	if .setBG
		asr.l	#4,d2								; get 3.125% ($800)
	else
		asr.l	#3,d2								; get 6.25% ($1000)
	endif

		move.l	d2,d3								; copy 3.125% to d3 ($800/$1000)
		asr.l	#4,d3								; get 0.1953125% ($80/$100)
		add.l	d3,d2								; add 0.1953125% to d2 ($880/$1100)
		add.l	d3,d2								; add 0.1953125% to d2 ($900/$1200)
		add.l	d3,d2								; add 0.1953125% to d2 ($980/$1300)

	if .setBG

		rept 9
			swap	d1
			move.w	d1,(a1)+						; save 50% - 3.7109375%
			swap	d1
			sub.l	d2,d1							; sub 3.7109375% to d1 ($980)
		endr

	else

		rept 4
			swap	d1
			move.w	d1,(a1)+						; save 50% - 7.421875%
			swap	d1
			sub.l	d2,d1							; sub 7.421875% to d1 ($1300)
		endr

	endif

		; last cloud
		swap	d1
		move.w	d1,(a1)+							; save 50% - 3.7109375%

		; mountains
		move.l	d0,d1								; copy 100% to d1 ($10000)
		asr.l	#2,d1								; get 25% ($4000)
		swap	d1
		move.w	d1,(a1)+							; save 25%

		; bushes
		asr.l	d0								; get 50% ($8000)
		swap	d0
		move.w	d0,(a1)+							; save 50%

		; wall
		swap	d0								; get 50% ($8000)
		move.l	d0,d1								; 50% to d1 ($8000)
		asr.l	d1								; get 25% ($4000)
		add.l	d1,d0								; add 25% to d0 ($C000)
		swap	d0
		move.w	d0,(a1)+							; save 75%
		rts
; ---------------------------------------------------------------------------

MZ1_BGDrawArray:
		dc.w 512+80	; sky, clouds size
		dc.w 32		; mountains size
		dc.w 144	; bushes size
		dc.w $7FFF	; wall size ; end marker
MZ1_BGDrawArray_end

MZ1_BGDeformArray:
		dc.w 512	; sky size

	if MZ1_Deform.setBG
		dcb.w 10, 8	; clouds size
	else
		dcb.w 5, 16	; clouds size
	endif

		dc.w 32		; mountains size
		dc.w 144	; bushes size
		dc.w $7FFF	; wall size ; end marker
