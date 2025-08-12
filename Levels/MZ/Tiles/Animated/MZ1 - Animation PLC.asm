; ---------------------------------------------------------------------------
; Animated pattern routine - Marble Zone (Lava)
; ---------------------------------------------------------------------------

; RAM
vMZLavaBuffer		= RAM_start+$7E00						; buffer size is $200 bytes

; =============== S U B R O U T I N E =======================================

AnimateTiles_MZ:

		; lava 1
		jsr	(AnimateTiles_DoAniPLC).w

		; lava 2
		lea	(Anim_Counters+8).w,a1

		; wait
		subq.b	#1,(a1)								; decrement timer
		bpl.s	Load_GHZ3Boss.return						; if time remains, branch
		addq.b	#1+1,(a1)							; reset timer to 1 frames

		; load art
		lea	(ArtUnc_MZLava2).l,a4						; load lava patterns
		move.b	-7(a1),d0							; get surface lava frame number
		subq.b	#1,d0								; fix dbf
		andi.w	#3,d0								; maximum number
		add.w	d0,d0								; multiply by 2
		move.w	.frame(pc,d0.w),d0						; multiply frame number by $200
		adda.w	d0,a4								; jump to appropriate tile
		moveq	#0,d3								; we need to clear the register so that we can use the word values
		move.b	(Oscillating_Data+8).w,d3					; get oscillating value

		; load RAM buffer for DMA send
	if ((vMZLavaBuffer)&$8000)
		lea	(vMZLavaBuffer).w,a5
	else
		lea	(vMZLavaBuffer).l,a5
	endif

	rept 3
		bsr.s	.process							; "
		addq.w	#4,d3								; next
	endr

		; load art
		pea	.QueueStaticDMA(pc)						; do later

		; process current mode below (last)

; =============== S U B R O U T I N E =======================================

.process

		; get mode
		lea	(a4),a1								; copy lava patterns to a1
		moveq	#$F,d0								; maximum 16 modes
		and.w	d3,d0								; get current mode
		move.w	d0,d1								; copy RAM shift to d1
		add.w	d0,d0								; multiply by 2

		; get flag
		move.w	.script(pc,d0.w),d0						; get flag
		bmi.s	.load								; if RAM shift off flag, do nothing
		adda.w	d1,a1								; RAM shift

.load
		andi.w	#$7FFF,d0							; clear RAM shift off flag
		jmp	.script(pc,d0.w)
; ---------------------------------------------------------------------------

.frame
		dc.w 0, 1*$200, 2*$200, 3*$200
.script
		dc.w (.mode00-.script)|setBit(15)	; mode offset, RAM shift off flag
		dc.w (.mode01-.script)
		dc.w (.mode00-.script)
		dc.w (.mode01-.script)
		dc.w (.mode00-.script)
		dc.w (.mode01-.script)
		dc.w (.mode00-.script)
		dc.w (.mode01-.script)
		dc.w (.mode00-.script)
		dc.w (.mode01-.script)
		dc.w (.mode00-.script)
		dc.w (.mode01-.script)
		dc.w (.mode00-.script)
		dc.w (.mode02-.script)
		dc.w (.mode03-.script)|setBit(15)
		dc.w (.mode04-.script)|setBit(15)
; ---------------------------------------------------------------------------

.mode03

		set	.a,0

	rept $80/4									; 32
		move.w	.a+$E(a1),(a5)+							; send to DMA buffer
		move.w	.a(a1),(a5)+							; ^
		set	.a,.a + $10							; next
	endr

		rts
; ---------------------------------------------------------------------------

.mode00

		set	.a,0

	rept $80/4									; 32
		move.l	.a(a1),(a5)+							; send to DMA buffer
		set	.a,.a + $10							; next
	endr

		rts
; ---------------------------------------------------------------------------

.mode02

	rept bytesToXcnt($80,4)								; 32-1

		; AABBCCDD to BBCCDDAA
		rept 3
			move.b	(a1)+,(a5)+						; send to DMA buffer
		endr

		move.b	-($D+3)(a1),(a5)+						; send first byte to DMA buffer
		lea	$10-3(a1),a1							; next
	endr

	; AABBCCDD to BBCCDDAA (last)
	rept 3
		move.b	(a1)+,(a5)+							; send to DMA buffer
	endr

		move.b	-($D+3)(a1),(a5)+						; send first byte to DMA buffer
		rts
; ---------------------------------------------------------------------------

.mode01

	rept bytesToXcnt($80,4)								; 32-1

		; AABBCCDD to DDAABBCC
		rept 4
			move.b	(a1)+,(a5)+						; send to DMA buffer
		endr

		lea	$10-4(a1),a1							; next
	endr

	; AABBCCDD to DDAABBCC (last)
	rept 4
		move.b	(a1)+,(a5)+							; send to DMA buffer
	endr

		rts
; ---------------------------------------------------------------------------

.mode04

	rept bytesToXcnt($80,4)								; 32-1

		; AABBCCDD to DDAABBCC
		move.b	$F(a1),(a5)+							; send to DMA buffer

		rept 3
			move.b	(a1)+,(a5)+						; ^
		endr

		lea	$10-3(a1),a1							; next
	endr

		; AABBCCDD to DDAABBCC (last)
		move.b	$F(a1),(a5)+							; send to DMA buffer

	rept 3
		move.b	(a1)+,(a5)+							; ^
	endr

		rts

; =============== S U B R O U T I N E =======================================

.QueueStaticDMA

		; from RAM buffer to VRAM
		QueueStaticDMA vMZLavaBuffer,tiles_to_bytes($10),tiles_to_bytes($2D2)
		rts
