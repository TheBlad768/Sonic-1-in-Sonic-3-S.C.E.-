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
		bpl.s	.return								; if time remains, branch
		addq.b	#1+1,(a1)							; reset timer to 1 frames

		; load art
		lea	(ArtUnc_MZLava2).l,a4						; load lava patterns
		move.b	-7(a1),d0							; get surface lava frame number
		subq.b	#1,d0								; fix dbf
		andi.w	#3,d0								; max number
		ror.w	#7,d0								; multiply frame num by $200
		adda.w	d0,a4								; jump to appropriate tile
		moveq	#0,d3
		move.b	(Oscillating_Data+8).w,d3					; get oscillating value

	if ((vMZLavaBuffer)&$8000)
		lea	(vMZLavaBuffer).w,a5
	else
		lea	(vMZLavaBuffer).l,a5
	endif

		moveq	#4-1,d2								; $80*4=$200

.loop
		lea	(a4),a1
		moveq	#$F,d0
		and.w	d3,d0
		add.w	d0,d0
		moveq	#bytesToXcnt($80,4),d1						; size
		bsr.s	.process
		addq.w	#4,d3								; next
		dbf	d2,.loop

		; load art
		QueueStaticDMA vMZLavaBuffer,tiles_to_bytes($10),tiles_to_bytes($2D2)

.return
		rts

; =============== S U B R O U T I N E =======================================

.process

		; check flag
		move.b	.script+1(pc,d0.w),d4						; get flag
		bpl.s	.normal

.copy
		move.w	$E(a1),(a5)+
		move.w	(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,.copy
		rts
; ---------------------------------------------------------------------------

.normal
		moveq	#0,d5
		move.b	.script(pc,d0.w),d5						; get RAM shift

.find
		move.l	(a1,d5.w),d0

		; check flag
		tst.b	d4
		beq.s	.set

		; check flag
		cmpi.b	#2,d4
		bne.s	.check
		rol.l	#8,d0
		move.b	(a1),d0
		bra.s	.set
; ---------------------------------------------------------------------------

.check
		move.b	-1(a1,d5.w),d0							; normal
		cmpi.b	#3,d4
		bne.s	.rol
		move.b	$F(a1,d5.w),d0							; last

.rol
		ror.l	#8,d0

.set
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,.find
		rts
; ---------------------------------------------------------------------------

.script
		dc.b 0, 0	; RAM shift, flag
		dc.b 2, 1
		dc.b 2, 0
		dc.b 4, 1
		dc.b 4, 0
		dc.b 6, 1
		dc.b 6, 0
		dc.b 8, 1
		dc.b 8, 0
		dc.b $A, 1
		dc.b $A, 0
		dc.b $C, 1
		dc.b $C, 0
		dc.b $C, 2
		dc.b $E, -1
		dc.b 0, 3
