; ---------------------------------------------------------------------------
; Object scaling subroutine
; ---------------------------------------------------------------------------

; RAM
vScaling_buffer			= RAM_start+$2000	; $2000 bytes (128x128)
vScaling_buffer_end		= RAM_start+$4000	; $40 to $7F level chunks will be destroyed

; =============== S U B R O U T I N E =======================================

Perform_Art_Scaling:
		pea	(a0)								; save a0
		bsr.s	Init_ArtScaling
		movea.l	(sp)+,a0							; restore a0
		pea	(a0)								; save a0
		move.w	art_tile(a0),d0
		bsr.w	Process_ArtScaling
		movea.l	(sp)+,a0							; restore a0
		move.w	(Scalar_factor).w,d3
		lsl.w	#4,d3
		move.l	#dmaSource(vScaling_buffer),d1
		move.w	objoff_3A(a0),d2						; VRAM
		jmp	(Add_To_DMA_Queue).w

; =============== S U B R O U T I N E =======================================

Init_ArtScaling:
		moveq	#0,d1
		move.w	d1,(Scalar_factor).w

	irp	reg, a0,a1,a2,a3,a4,a5
		movea.w	d1,reg
	endr

		lea	(vScaling_buffer_end).l,a6
		moveq	#bytesToXcnt(vScaling_buffer_end-vScaling_buffer,256),d1

.clr

	rept 10										; clear $100 bytes
		movem.l	a0-a5,-(a6)							; clear $18 bytes
	endr

		movem.l	a0-a3,-(a6)							; clear $10 bytes
		dbf	d1,.clr
		rts
; ---------------------------------------------------------------------------

word_2464A:
		dc.w 256
		dc.w 252
		dcb.w 2, 144
		dcb.w 3, 64
		dcb.w 5, 60
		dcb.w 16, 16
		dcb.w 4, 12

; =============== S U B R O U T I N E =======================================

Process_ArtScaling:
		moveq	#0,d1
		move.b	objoff_40(a0),d1
		cmpi.b	#28,d1
		blo.s	loc_2469A
		moveq	#28,d1								; maximum 28 different "scales"

loc_2469A:
		move.b	d1,mapping_frame(a0)						; scale level correlates with mapping frame
		add.w	d1,d1
		move.w	word_2464A(pc,d1.w),d1
		move.w	(Scalar_factor).w,d2
		add.w	d1,d2
		cmpi.w	#128*2,d2							; image size (128x128 pixels)
		bhi.s	loc_246D2
		sub.w	d1,d2
		movem.l	d1/d5-a0/a2/a4,-(sp)
		lea	(vScaling_buffer).l,a2
		add.w	d2,d0
		move.w	d0,art_tile(a0)
		lsl.w	#5,d2
		adda.w	d2,a2
		bsr.s	sub_246DA
		movem.l	(sp)+,d1/d5-a0/a2/a4
		add.w	d1,(Scalar_factor).w
		rts
; ---------------------------------------------------------------------------

loc_246D2:
		bclr	#render_flags.on_screen,render_flags(a0)
		rts

; =============== S U B R O U T I N E =======================================

sub_246DA:
		moveq	#0,d0
		move.b	objoff_40(a0),d0						; scale factor
		moveq	#0,d1
		move.b	objoff_20(a0),d1						; next frame (address shift)
		movea.l	objoff_42(a0),a1						; scaled art address
		ror.w	#4,d1								; 1 to $1000 (max 16 frames?)
		adda.l	d1,a1
		lea	(a1),a0
		lea	$1000(a0),a0
		addq.w	#4,d0
		move.w	d0,d4
		lsr.w	#3,d4
		move.w	d0,d5
		ror.w	#3,d5
		andi.w	#$E000,d5
		move.w	#$F0,d6
		swap	d6
		move.w	#$F,d7
		swap	d7
		tst.w	d4
		beq.w	sub_249BA							; if modified scale factor smaller than 8, branch
		cmpi.w	#1,d4
		bne.s	loc_2472A							; if modified scale factor is not between 8-$10, branch
		tst.w	d5
		beq.w	sub_2493E							; if modified scale factor is 8, branch
		cmpi.w	#$2000,d5
		beq.w	sub_248B8							; if modified scale factor is 9, branch

loc_2472A:
		move.w	d4,d2								; all other instances. Scale factor/8 to d2
		swap	d2
		move.w	d5,d2
		lsr.l	#8,d2								; combine with other scale factor to create final result: Scale factor << 5
		move.l	#$400000,d0
		divu.w	d2,d0
		lsr.w	#8,d0
		lsr.w	#3,d0
		subq.w	#1,d0								; divide 400000 by modified scale factor << 5, subtract 1
		movea.w	d0,a5								; note the result in a5
		moveq	#0,d2
		moveq	#0,d3
		lea	sub_2479C(pc),a6

loc_2474A:
		move.w	#$1F,d7

loc_2474E:
		swap	d7
		swap	d3
		move.w	#0,d2
		move.w	#0,d3
		lea	(a2),a4
		move.w	a5,d6
		bmi.s	loc_24770

loc_24760:
		swap	d6
		jsr	(a6)
		swap	d6
		dbf	d6,loc_24760
		cmpi.w	#$40,d2
		bhs.s	loc_24778

loc_24770:
		swap	d6
		bsr.w	sub_24802
		swap	d6

loc_24778:
		swap	d3
		add.w	d5,d3
		bhs.s	loc_24782
		lea	$40(a1),a1

loc_24782:
		move.w	d4,d0
		lsl.w	#6,d0
		adda.w	d0,a1
		cmpa.l	a0,a1
		bhs.s	locret_2479A
		addq.w	#4,a2
		swap	d7
		dbf	d7,loc_2474E
		lea	$380(a2),a2
		bra.s	loc_2474A
; ---------------------------------------------------------------------------

locret_2479A:
		rts

; =============== S U B R O U T I N E =======================================

sub_2479C:

	rept 4
		move.b	(a1,d2.w),d0
		add.w	d5,d3
		addx.w	d4,d2
		move.b	(a1,d2.w),d1
		add.w	d5,d3
		addx.w	d4,d2
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
	endr

		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_24802:

	rept 4
		move.b	(a1,d2.w),d0
		add.w	d5,d3
		addx.w	d4,d2
		cmpi.w	#$40,d2
		blo.s	loc_24814
		moveq	#0,d0

loc_24814:
		move.b	(a1,d2.w),d1
		add.w	d5,d3
		addx.w	d4,d2
		cmpi.w	#$40,d2
		blo.s	loc_24826
		moveq	#0,d1

loc_24826:
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
	endr

		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_248B8:
		moveq	#0,d3
		lsl.w	#6,d4
		lea	sub_24906(pc),a6
		move.w	#1,d7

loc_248C4:
		swap	d7
		move.w	#$1F,d6

loc_248CA:
		swap	d6
		lea	(a1),a3
		lea	(a2),a4

	rept 7
		jsr	(a6)
	endr

		move.b	(a3)+,d0
		and.b	d6,d0
		move.b	d0,(a4)+
		add.w	d5,d3
		bhs.s	loc_248EC
		lea	$40(a1),a1

loc_248EC:
		adda.w	d4,a1
		cmpa.l	a0,a1
		bhs.s	locret_24904
		addq.w	#4,a2
		swap	d6
		dbf	d6,loc_248CA
		lea	$380(a2),a2
		swap	d7
		dbf	d7,loc_248C4

locret_24904:
		rts

; =============== S U B R O U T I N E =======================================

sub_24906:

	rept 3
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
	endr

		move.b	(a3)+,d0
		move.b	(a3)+,d1
		addq.w	#1,a3
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_2493E:
		moveq	#0,d3
		lsl.w	#6,d4
		lea	sub_24984(pc),a6
		move.w	#1,d7

loc_2494A:
		swap	d7
		move.w	#$1F,d6

loc_24950:
		swap	d6
		lea	(a1),a3
		lea	(a2),a4

	rept 8
		jsr	(a6)
	endr

		add.w	d5,d3
		bhs.s	loc_2496E
		lea	$40(a1),a1

loc_2496E:
		adda.w	d4,a1
		addq.w	#4,a2
		swap	d6
		dbf	d6,loc_24950
		lea	$380(a2),a2
		swap	d7
		dbf	d7,loc_2494A
		rts

; =============== S U B R O U T I N E =======================================

sub_24984:

	rept 4
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
	endr

		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_249BA:
		cmpi.w	#$E000,d5
		bne.s	sub_24A3C
		lea	sub_24A10(pc),a6
		moveq	#0,d3
		lsl.w	#6,d4
		move.w	#2,d7

loc_249CE:
		swap	d7
		move.w	#$1F,d6

loc_249D4:
		swap	d6
		lea	(a1),a3
		lea	(a2),a4

	rept 9
		jsr	(a6)
	endr

		move.b	(a3),(a4)
		add.w	d5,d3
		bhs.s	loc_249F6
		lea	$40(a1),a1

loc_249F6:
		adda.w	d4,a1
		cmpa.l	a0,a1
		bhs.s	locret_24A0E
		addq.w	#4,a2
		swap	d6
		dbf	d6,loc_249D4
		lea	$580(a2),a2
		swap	d7
		dbf	d7,loc_249CE

locret_24A0E:
		rts

; =============== S U B R O U T I N E =======================================

sub_24A10:
		move.b	(a3)+,(a4)+

	rept 3
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
	endr

		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_24A3C:
		cmpi.w	#$C000,d5
		bne.w	sub_24AC6
		moveq	#0,d3
		lsl.w	#6,d4
		lea	sub_24AA4(pc),a6
		move.w	#3,d7

loc_24A50:
		swap	d7
		move.w	#$1F,d6

loc_24A56:
		swap	d6
		lea	(a1),a3
		lea	(a2),a4

	rept 10
		jsr	(a6)
	endr

		move.b	(a3)+,(a4)+
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
		move.b	(a3),d0
		move.b	d0,(a4)
		add.w	d5,d3
		bhs.s	loc_24A8A
		lea	$40(a1),a1

loc_24A8A:
		adda.w	d4,a1
		cmpa.l	a0,a1
		bhs.s	locret_24AA2
		addq.w	#4,a2
		swap	d6
		dbf	d6,loc_24A56
		lea	$580(a2),a2
		swap	d7
		dbf	d7,loc_24A50

locret_24AA2:
		rts

; =============== S U B R O U T I N E =======================================

sub_24AA4:

	rept 2
		move.b	(a3)+,(a4)+
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
	endr

		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_24AC6:
		cmpi.w	#$A000,d5
		bne.w	sub_24B60
		moveq	#0,d3
		lsl.w	#6,d4
		lea	sub_24B4A(pc),a5
		lea	sub_24B32(pc),a6
		move.w	#3,d7

loc_24ADE:
		swap	d7
		move.w	#$1F,d6

loc_24AE4:
		swap	d6
		lea	(a1),a3
		lea	(a2),a4

	rept 6
		jsr	(a5)
		jsr	(a6)
	endr

		move.w	(a3)+,(a4)+
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
		add.w	d5,d3
		bhs.s	loc_24B18
		lea	$40(a1),a1

loc_24B18:
		adda.w	d4,a1
		cmpa.l	a0,a1
		bhs.s	locret_24B30
		addq.w	#4,a2
		swap	d6
		dbf	d6,loc_24AE4
		lea	$780(a2),a2
		swap	d7
		dbf	d7,loc_24ADE

locret_24B30:
		rts

; =============== S U B R O U T I N E =======================================

sub_24B32:
		move.b	(a3)+,(a4)+
		move.b	(a3)+,(a4)+
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
		move.b	(a3)+,(a4)+
		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_24B4A:
		move.w	(a3)+,(a4)+
		move.b	(a3)+,d0
		move.b	(a3)+,d1
		and.b	d6,d0
		and.b	d7,d1
		or.b	d1,d0
		move.b	d0,(a4)+
		move.b	(a3)+,(a4)+
		lea	$7C(a4),a4
		rts

; =============== S U B R O U T I N E =======================================

sub_24B60:
		moveq	#0,d3
		lsl.w	#6,d4
		moveq	#3,d7

loc_24B66:
		move.w	#$1F,d6

loc_24B6A:
		lea	(a1),a3
		lea	(a2),a4

	rept 16
		move.l	(a3)+,(a4)
		lea	$80(a4),a4
	endr

		add.w	d5,d3
		bhs.s	loc_24BD6
		lea	$40(a1),a1

loc_24BD6:
		adda.w	d4,a1
		addq.w	#4,a2
		dbf	d6,loc_24B6A
		lea	$780(a2),a2
		dbf	d7,loc_24B66
		rts
; ---------------------------------------------------------------------------

		include "Objects/Main/Scaling/Object Data/Map - Scaled Art.asm"
