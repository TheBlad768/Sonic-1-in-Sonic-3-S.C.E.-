; ---------------------------------------------------------------------------
; Animated palette routine - Green Hill Zone
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AnPal_GHZ:
		lea	(Palette_cycle_counters).w,a0

		; wait
		subq.w	#1,(a0)							; decrement timer
		bpl.s	.return							; if time remains, branch
		addq.w	#5+1,(a0)						; reset timer to 5+1 frames

		; cycle (by MarkeyJester)
		lea	(Normal_palette_line_3+$16).w,a2
		lea	(a2),a1
		move.w	(a2)+,d0
		move.w	-(a1),-(a2)
		move.l	-(a1),-(a2)
		move.w	d0,-(a2)

.return
		rts
