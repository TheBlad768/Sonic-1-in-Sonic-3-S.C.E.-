; ---------------------------------------------------------------------------
; GHZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GHZ1_ScreenInit:

		; update FG
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w

; =============== S U B R O U T I N E =======================================

GHZ1_BackgroundInit:
		bsr.s	GHZ1_Deform

		; update BG
		jsr	(Reset_TileOffsetPositionEff).w
		lea	GHZ1_BGDrawArray(pc),a4
		lea	(H_scroll_table+$100).w,a5
		clr.l	(a5)								; update clouds (draw the starting position)
		moveq	#-16,d3								; set align (16 pixels)
		move.w	-$FA(a5),d4
		move.w	d4,4(a5)							; update mountains 1
		and.w	d3,d4								; align
		move.w	d4,6(a5)							; update mountains 1 (copy for Draw_TileColumn)
		move.w	-$F8(a5),d4
		move.w	d4,8(a5)							; update mountains 2
		and.w	d3,d4								; align
		move.w	d4,$A(a5)							; update mountains 2 (copy for Draw_TileColumn)
		clr.l	$C(a5)								; update water (draw the starting position)
		jsr	(Refresh_PlaneTileDeform).w

		; deform
		lea	GHZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w

; =============== S U B R O U T I N E =======================================

GHZ1_BackgroundEvent:
		tst.b	(Background_event_flag).w
		bne.s	GHZ1_Transition
		bsr.s	GHZ1_Deform

		; update BG
		lea	GHZ1_BGDrawArray(pc),a4
		lea	(H_scroll_table+$100).w,a6
		clr.w	(a6)								; clouds (not update)
		move.w	-$FA(a6),4(a6)							; update mountains 1
		move.w	-$F8(a6),8(a6)							; update mountains 2
		clr.w	$C(a6)								; water (not update)
		moveq	#0,d6								; Camera_Y_pos_rounded
		moveq	#(GHZ1_BGDrawArray_end-GHZ1_BGDrawArray)/2,d5
		jsr	(Draw_BGNoVert).w

		; deform
		lea	GHZ1_BGDeformArray(pc),a4
		lea	(H_scroll_table).w,a5
		jmp	(ApplyDeformation).w
; ---------------------------------------------------------------------------

GHZ1_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

GHZ1_Deform:

.setBGy	= 1	; original or alt

		; yscroll

	if .setBGy
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	#6,d0								; get 1.5625% ($40)
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 1.5625%
	else
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		andi.w	#$7FF,d0							; camera limit 50% ($800)
		lsr.w	#5,d0								; get 3.125% ($40)
		neg.w	d0
		addi.w	#32,d0
		bpl.s	.limity
		moveq	#0,d0

.limity
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 3.125%
	endif

.xscroll

		; xscroll
		lea	(H_scroll_table).w,a1

		; calc clouds speed
		move.l	(Camera_X_pos_copy).w,d0					; 100% to d0 ($10000)
		move.l	d0,d4								; copy 100% to d4 ($10000)
		asr.l	#3,d4								; get 12.5% ($2000)
		move.l	d4,d1								; copy 12.5% to d1 ($2000)
		add.l	d1,d1								; calc 25% ($4000)
		add.l	d1,d4								; add 25% to d4 ($6000) ; v_bg3screenposx

		; cloud 1
		move.l	(Level_frame_counter).w,d2					; 100% to d2 ($10000)
		move.l	d2,d1								; copy 100% to d1 ($10000)
		add.l	d4,d1								; add 37.5% to d1 ($6000) ; v_bg3screenposx
		swap	d1
		move.w	d1,(a1)+							; save 137.5%

		; cloud 2
		move.l	d2,d1								; 100% to d1 ($10000)
		asr.l	#2,d1								; get 25% ($4000)
		move.l	d1,d3								; copy 25% to d3 ($4000)
		add.l	d3,d3								; calc 50% ($8000)
		add.l	d3,d1								; add 50% to d1 ($C000)
		add.l	d4,d1								; add 37.5% to d1 ($6000) ; v_bg3screenposx
		swap	d1
		move.w	d1,(a1)+							; save 112.5%

		; cloud 3
		asr.l	d2								; get 50% ($8000)
		add.l	d4,d2								; add 37.5% to d2 ($6000) ; v_bg3screenposx
		swap	d2
		move.w	d2,(a1)+							; save 87.5%

		; mountains
		move.l	d0,d1								; 100% to d1 ($10000)
		asr.l	#3,d1								; get 12.5% ($2000)
		move.l	d1,d2								; copy 12.5% to d2 ($2000)
		add.l	d2,d2								; calc 25% ($4000)
		add.l	d2,d1								; add 25% to d1 ($6000)
		swap	d1
		move.w	d1,(a1)+							; save 37.5%

		; mountains 2
		asr.l	d0								; get 50% ($8000)
		swap	d0
		move.w	d0,(a1)+							; save 50%

		; water
		swap	d0
		move.l	d0,d1								; 50% to d1 ($8000)
		asr.l	#7,d1								; get 0.78125% ($100)
		moveq	#bytesToXcnt(104,8),d3

.loop

	rept 8
		swap	d0
		move.w	d0,(a1)+							; save 50% + 0.78125%
		swap	d0
		add.l	d1,d0								; add 0.78125% to d0 ($100)
	endr

		dbf	d3,.loop
		rts
; ---------------------------------------------------------------------------

GHZ1_BGDrawArray:
		dc.w 64			; cloud 1+2+3
		dcb.w 2, 48		; mountains 1 and 2
		dc.w $7FFF		; water
GHZ1_BGDrawArray_end

GHZ1_BGDeformArray:
		dc.w 32			; cloud 1
		dcb.w 2, 16		; cloud 2 and 3
		dc.w 48			; mountains
		dc.w 40			; mountains 2
		dc.w 104+$8000		; water
		dc.w $7FFF
