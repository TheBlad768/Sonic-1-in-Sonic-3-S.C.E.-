; ---------------------------------------------------------------------------
; Animated palette routine - Labyrinth Zone
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AnPal_LZ:
		lea	(Palette_cycle_counters).w,a0

		; waterfalls
		subq.w	#1,(a0)								; decrement timer
		bpl.s	.skip1								; if time remains, branch
		addq.w	#2+1,(a0)							; reset timer to 2 frames

		; cycle
		moveq	#$18,d0								; if cycle > 3, reset to 0
		and.w	2(a0),d0
		addq.w	#8,2(a0)							; increment cycle number

		; check
		lea	(Pal_LZCyc1).l,a1
		cmpi.b	#3,(Current_act).w						; check if level is SBZ3
		bne.s	.notsbz3							; if not, branch

.palSBZ3	:= Pal_SBZ3Cyc-Pal_LZCyc1						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.palSBZ3)(a1),a1						; load SBZ3 palette instead

.notsbz3
		adda.w	d0,a1
		move.l	(a1)+,d0
		move.l	(a1),d1
		lea	(Normal_palette_line_3+$16).w,a2
		move.l	d0,(a2)+
		move.l	d1,(a2)
		lea	(Water_palette_line_3+$16).w,a2
		move.l	d0,(a2)+
		move.l	d1,(a2)

.skip1

		; conveyor belts
		moveq	#7,d0
		and.w	(Level_frame_counter).w,d0
		move.b	PCycLZ_Seq(pc,d0.w),d0						; get byte from palette sequence
		beq.s	.return								; if byte is 0, branch
		moveq	#1,d1
		tst.b	(Convey_rev_flag).w						; have conveyor belts been reversed?
		beq.s	.norev								; if not, branch
		neg.w	d1

.norev
		moveq	#3,d0
		and.w	4(a0),d0
		add.w	d1,d0
		cmpi.w	#3,d0
		blo.s	.loc_1A0A
		move.w	d0,d1
		moveq	#0,d0
		tst.w	d1
		bpl.s	.loc_1A0A
		moveq	#2,d0

.loc_1A0A
		move.w	d0,4(a0)
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0

		; cycle
		lea	(Pal_LZCyc2).l,a1
		adda.w	d0,a1
		lea	(Normal_palette_line_4+$16).w,a2
		move.l	(a1)+,(a2)+
		move.w	(a1),(a2)
		lea	(Pal_LZCyc3).l,a1
		adda.w	d0,a1
		lea	(Water_palette_line_4+$16).w,a2
		move.l	(a1)+,(a2)+
		move.w	(a1),(a2)

.return
		rts
; ---------------------------------------------------------------------------

PCycLZ_Seq:	dc.b 1, 0, 0, 1, 0, 0, 1, 0
	even
