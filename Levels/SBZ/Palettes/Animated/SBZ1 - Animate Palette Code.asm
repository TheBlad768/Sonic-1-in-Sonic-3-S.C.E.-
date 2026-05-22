; ---------------------------------------------------------------------------
; Animated palette routine - Scrap Brain Zone
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AnPal_SBZ:

		; check
		lea	Pal_SBZCycList1(pc),a2
		tst.b	(Current_act).w							; is act number 1?
		beq.s	loc_1ADA							; if yes, branch
		lea	Pal_SBZCycList2(pc),a2

loc_1ADA:
		lea	(Palette_cycle_counters+$10).w,a1
		move.w	(a2)+,d1

loc_1AE0:
		subq.b	#1,(a1)
		bmi.s	loc_1AEA
		addq.w	#2,a1
		addq.w	#8,a2
		bra.s	loc_1B06
; ---------------------------------------------------------------------------

loc_1AEA:
		move.b	(a2)+,(a1)+
		move.b	(a1),d0
		addq.b	#1,d0
		cmp.b	(a2)+,d0
		blo.s	loc_1AF6
		moveq	#0,d0

loc_1AF6:
		move.b	d0,(a1)+
		andi.w	#$F,d0
		add.w	d0,d0
		movea.l	(a2)+,a0							; palette address
		movea.w	(a2)+,a3							; RAM address
		move.w	(a0,d0.w),(a3)

loc_1B06:
		dbf	d1,loc_1AE0

		; next
		lea	(Palette_cycle_counters).w,a0

		; wait
		subq.w	#1,(a0)								; decrement timer
		bpl.s	locret_1B64							; if time remains, branch
		addq.w	#1+1,(a0)							; reset timer to 1 frames

		; check
		lea	(Pal_SBZCyc4).l,a1
		tst.b	(Current_act).w							; is act number 1?
		beq.s	loc_1B2E							; if yes, branch

		; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times
		; so we will use :=/set

.palSBZ		:= Pal_SBZCyc10-Pal_SBZCyc4

		lea	(.palSBZ)(a1),a1
		clr.w	(a0)

loc_1B2E:
		moveq	#-1,d1
		tst.b	(Conveyor_reverse_flag).w
		beq.s	loc_1B38
		neg.w	d1

loc_1B38:
		moveq	#3,d0
		and.w	2(a0),d0
		add.w	d1,d0
		cmpi.w	#3,d0
		blo.s	loc_1B52
		move.w	d0,d1
		moveq	#0,d0
		tst.w	d1
		bpl.s	loc_1B52
		moveq	#2,d0

loc_1B52:
		move.w	d0,2(a0)
		add.w	d0,d0
		adda.w	d0,a1

		; cycle
		lea	(Normal_palette_line_3+$18).w,a2
		move.l	(a1)+,(a2)+
		move.w	(a1),(a2)

locret_1B64:
		rts

; ---------------------------------------------------------------------------
; Scrap Brain Zone palette cycling script
; ---------------------------------------------------------------------------

; duration in frames, number of colors, palette address, RAM address

Pal_SBZCycList1: mSBZh
	mSBZp 7, 8, Pal_SBZCyc1, Normal_palette_line_3+$10
	mSBZp $D ,8, Pal_SBZCyc2, Normal_palette_line_3+$12
	mSBZp $E, 8, Pal_SBZCyc3, Normal_palette_line_4+$E
	mSBZp $B, 8, Pal_SBZCyc5, Normal_palette_line_4+$10
	mSBZp 7, 8, Pal_SBZCyc6, Normal_palette_line_4+$12
	mSBZp $1C, $10, Pal_SBZCyc7, Normal_palette_line_4+$1E
	mSBZp 3, 3, Pal_SBZCyc8, Normal_palette_line_4+$18
	mSBZp 3, 3, Pal_SBZCyc8+2, Normal_palette_line_4+$1A
	mSBZp 3, 3, Pal_SBZCyc8+4, Normal_palette_line_4+$1C
	mSBZe										; end marker

Pal_SBZCycList2: mSBZh
	mSBZp 7, 8, Pal_SBZCyc1, Normal_palette_line_3+$10
	mSBZp $D, 8, Pal_SBZCyc2, Normal_palette_line_3+$12
	mSBZp 9, 8, Pal_SBZCyc9, Normal_palette_line_4+$10
	mSBZp 7, 8, Pal_SBZCyc6, Normal_palette_line_4+$12
	mSBZp 3, 3, Pal_SBZCyc8, Normal_palette_line_4+$18
	mSBZp 3, 3, Pal_SBZCyc8+2, Normal_palette_line_4+$1A
	mSBZp 3, 3, Pal_SBZCyc8+4, Normal_palette_line_4+$1C
	mSBZe										; end marker
