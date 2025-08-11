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
		lea	(a4),a1								; copy lava patterns to a1
		moveq	#$F,d0								; maximum 16 modes
		and.w	d3,d0								; get current mode
		add.w	d0,d0								; multiply by 4
		add.w	d0,d0								; "
		bsr.s	.process							; "
		addq.w	#4,d3								; next
	endr

		; load art
		pea	.QueueStaticDMA(pc)						; do later

		; last
		lea	(a4),a1								; copy lava patterns to a1
		moveq	#$F,d0								; maximum 16 modes
		and.w	d3,d0								; get current mode
		add.w	d0,d0								; multiply by 4
		add.w	d0,d0								; "

		; process current mode below

; =============== S U B R O U T I N E =======================================

.process

		; get flag
		move.w	.script+2(pc,d0.w),d4						; get flag
		bmi.s	.minus

		adda.w	.script(pc,d0.w),a1						; RAM shift

		; check flags
		jmp	.script(pc,d4.w)
; ---------------------------------------------------------------------------

.frame
		dc.w 0, 1*$200, 2*$200, 3*$200
.script
		dc.w 0, (.mode00-.script)	; RAM shift, mode offset
		dc.w 1, (.mode01-.script)
		dc.w 2, (.mode00-.script)
		dc.w 3, (.mode01-.script)
		dc.w 4, (.mode00-.script)
		dc.w 5, (.mode01-.script)
		dc.w 6, (.mode00-.script)
		dc.w 7, (.mode01-.script)
		dc.w 8, (.mode00-.script)
		dc.w 9, (.mode01-.script)
		dc.w $A, (.mode00-.script)
		dc.w $B, (.mode01-.script)
		dc.w $C, (.mode00-.script)
		dc.w $D, (.mode02-.script)
		dc.w $E, -1
		dc.w 0, (.mode03-.script)
; ---------------------------------------------------------------------------

.minus

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

	; last
	rept 3
		; AABBCCDD to BBCCDDAA
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

	; last
	rept 4
		; AABBCCDD to DDAABBCC
		move.b	(a1)+,(a5)+							; send to DMA buffer
	endr

		rts
; ---------------------------------------------------------------------------

.mode03

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
