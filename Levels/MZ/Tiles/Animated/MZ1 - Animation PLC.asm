; ---------------------------------------------------------------------------
; Animated pattern routine - Marble Zone (Lava)
; ---------------------------------------------------------------------------

; RAM
vLavaMZBuffer		= RAM_start+$7E00						; buffer size is $200 bytes

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

	if ((vLavaMZBuffer)&$8000)
		lea	(vLavaMZBuffer).w,a5
	else
		lea	(vLavaMZBuffer).l,a5
	endif

		moveq	#4-1,d2								; $80*4=$200

.loop
		lea	(a4),a1
		moveq	#$F,d0
		and.w	d3,d0
		add.w	d0,d0
		add.w	d0,d0
		moveq	#bytesToXcnt($80,4),d1						; size
		jsr	AniArt_MZextra(pc,d0.w)
		addq.w	#4,d3								; next
		dbf	d2,.loop

		; load art
		QueueStaticDMA vLavaMZBuffer,tiles_to_bytes($10),tiles_to_bytes($2D2)

.return
		rts

; =============== S U B R O U T I N E =======================================

AniArt_MZextra:
		bra.s	loc_1C3EE							; 0
		rts									; nop
		bra.s	loc_1C3FA							; 4
		rts									; nop
		bra.s	loc_1C410							; 8
		rts									; nop
		bra.s	loc_1C41E							; C
		rts									; nop
		bra.w	loc_1C434							; 10
		bra.w	loc_1C442							; 14
		bra.w	loc_1C458							; 18
		bra.w	loc_1C466							; 1C
		bra.w	loc_1C47C							; 20
		bra.w	loc_1C48A							; 24
		bra.w	loc_1C4A0							; 28
		bra.w	loc_1C4AE							; 2C
		bra.w	loc_1C4C4							; 30
		bra.w	loc_1C4D2							; 34
		bra.w	loc_1C4E8							; 38
; ---------------------------------------------------------------------------

loc_1C4FA:										; 3C
		move.l	(a1),d0
		move.b	$F(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C4FA
		rts
; ---------------------------------------------------------------------------

loc_1C3EE:
		move.l	(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C3EE
		rts
; ---------------------------------------------------------------------------

loc_1C3FA:
		move.l	2(a1),d0
		move.b	1(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C3FA
		rts
; ---------------------------------------------------------------------------

loc_1C410:
		move.l	2(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C410
		rts
; ---------------------------------------------------------------------------

loc_1C41E:
		move.l	4(a1),d0
		move.b	3(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C41E
		rts
; ---------------------------------------------------------------------------

loc_1C434:
		move.l	4(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C434
		rts
; ---------------------------------------------------------------------------

loc_1C442:
		move.l	6(a1),d0
		move.b	5(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C442
		rts
; ---------------------------------------------------------------------------

loc_1C458:
		move.l	6(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C458
		rts
; ---------------------------------------------------------------------------

loc_1C466:
		move.l	8(a1),d0
		move.b	7(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C466
		rts
; ---------------------------------------------------------------------------

loc_1C47C:
		move.l	8(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C47C
		rts
; ---------------------------------------------------------------------------

loc_1C48A:
		move.l	$A(a1),d0
		move.b	9(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C48A
		rts
; ---------------------------------------------------------------------------

loc_1C4A0:
		move.l	$A(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C4A0
		rts
; ---------------------------------------------------------------------------

loc_1C4AE:
		move.l	$C(a1),d0
		move.b	$B(a1),d0
		ror.l	#8,d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C4AE
		rts
; ---------------------------------------------------------------------------

loc_1C4C4:
		move.l	$C(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C4C4
		rts
; ---------------------------------------------------------------------------

loc_1C4D2:
		move.l	$C(a1),d0
		rol.l	#8,d0
		move.b	(a1),d0
		move.l	d0,(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C4D2
		rts
; ---------------------------------------------------------------------------

loc_1C4E8:
		move.w	$E(a1),(a5)+
		move.w	(a1),(a5)+
		lea	$10(a1),a1
		dbf	d1,loc_1C4E8
		rts
