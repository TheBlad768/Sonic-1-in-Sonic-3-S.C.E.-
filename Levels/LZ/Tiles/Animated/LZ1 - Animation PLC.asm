; ---------------------------------------------------------------------------
; Animated pattern routine - Labyrinth Zone (Wheel)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AnimateTiles_LZ:
		moveq	#3,d0
		and.w	(Level_frame_counter).w,d0
		bne.s	.return

		; anim
		moveq	#1,d0
		tst.b	(Convey_rev_flag).w
		beq.s	.skip
		neg.b	d0

.skip
		lea	(Anim_Counters).w,a1
		add.b	d0,(a1)
		andi.b	#3,(a1)

		; load art (wheel)
		move.l	#dmaSource(ArtUnc_LZConveyor),d1				; load art source
		move.b	(a1),-(sp)							; multiply by $100
		move.w	(sp)+,d0
		clr.b	d0								; clear garbage data
		add.l	d0,d1								; get frame
		move.w	#tiles_to_bytes($3F6),d2					; load art destination

		; size of art (in words) ; we only need one frame (32x32)
		move.w	#tiles_to_bytes( \
		dmaLength(16) \
		),d3

		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

.return
		rts