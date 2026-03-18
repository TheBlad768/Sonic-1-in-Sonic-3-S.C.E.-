; ---------------------------------------------------------------------------
; Title events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Title_BackgroundInit:
		bsr.w	Title_Deform

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
		lea	(H_scroll_buffer+2).w,a1
		move.w	(Camera_Y_pos_BG_copy).w,d0
		jmp	(ApplyCustomDeformation).w

; =============== S U B R O U T I N E =======================================

Title_BackgroundEvent:
		bsr.s	Title_Deform

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
		lea	(H_scroll_buffer+2).w,a1
		move.w	(Camera_Y_pos_BG_copy).w,d0
		jmp	(ApplyCustomDeformation).w

; =============== S U B R O U T I N E =======================================

Title_Deform:

		; yscroll
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	#6,d0								; get 1.5625% ($40)
;		addq.w	#8,d0								; fix pos (S1)
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 1.5625%

		; xscroll
		bra.w	GHZ1_Deform.xscroll
