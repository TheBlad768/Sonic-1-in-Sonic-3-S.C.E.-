; ---------------------------------------------------------------------------
; Ending events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Ending_BackgroundInit:
		bsr.s	Ending_Deform
		bra.w	GHZ1_BackgroundInit.update

; =============== S U B R O U T I N E =======================================

Ending_BackgroundEvent:
		bsr.s	Ending_Deform
		bra.w	GHZ1_BackgroundEvent.update

; =============== S U B R O U T I N E =======================================

Ending_Deform:

		; yscroll
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	#6,d0								; get 1.5625% ($40)
		addi.w	#20,d0								; fix pos (S1)
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 2.05078125%

		; xscroll
		bra.w	GHZ1_Deform.xscroll