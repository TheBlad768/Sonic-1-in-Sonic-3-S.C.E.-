; ---------------------------------------------------------------------------
; Retracting Spring (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

sub_23A3C:
		move.l	#loc_23A42,address(a0)

loc_23A42:
		bsr.w	RetractingSpring_Delay
		moveq	#0,d0
		move.b	objoff_36(a0),d0
		add.w	objoff_34(a0),d0
		move.w	d0,y_pos(a0)
		bra.w	Obj_Spring_Down

; =============== S U B R O U T I N E =======================================

Obj_RetractingSpring:

		; init
		bsr.w	Obj_Spring

		; next
		move.b	subtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	sub_23A04							; 0
		bra.s	sub_23A20							; 2
		bra.s	sub_23A3C							; 4
		bra.s	sub_23A58							; 6
; ---------------------------------------------------------------------------

											; 8
		move.l	#loc_23A8E,address(a0)

loc_23A8E:
		bsr.w	RetractingSpring_Delay
		moveq	#0,d0
		move.b	objoff_36(a0),d0
		move.w	d0,d1
		btst	#status.npc.x_flip,status(a0)
		beq.s	loc_23AA4
		neg.w	d0

loc_23AA4:
		add.w	objoff_32(a0),d0
		move.w	d0,x_pos(a0)
		add.w	objoff_34(a0),d1
		move.w	d1,y_pos(a0)
		bra.w	Obj_Spring_DownDiag
; ---------------------------------------------------------------------------

sub_23A04:
		move.l	#loc_23A0A,address(a0)

loc_23A0A:
		bsr.s	RetractingSpring_Delay
		moveq	#0,d0
		move.b	objoff_36(a0),d0
		add.w	objoff_34(a0),d0
		move.w	d0,y_pos(a0)
		bra.w	Obj_Spring_Up
; ---------------------------------------------------------------------------

sub_23A58:
		move.l	#loc_23A5E,address(a0)

loc_23A5E:
		bsr.s	RetractingSpring_Delay
		moveq	#0,d0
		move.b	objoff_36(a0),d0
		move.w	d0,d1
		btst	#status.npc.x_flip,status(a0)
		bne.s	loc_23A74
		neg.w	d0

loc_23A74:
		add.w	objoff_32(a0),d0
		move.w	d0,x_pos(a0)
		add.w	objoff_34(a0),d1
		move.w	d1,y_pos(a0)
		bra.w	Obj_Spring_UpDiag
; ---------------------------------------------------------------------------

sub_23A20:
		move.l	#loc_23A26,address(a0)

loc_23A26:
		bsr.s	RetractingSpring_Delay
		moveq	#0,d0
		move.b	objoff_36(a0),d0
		add.w	objoff_32(a0),d0
		move.w	d0,x_pos(a0)
		bra.w	Obj_Spring_Horizontal

; =============== S U B R O U T I N E =======================================

RetractingSpring_Delay:
		tst.w	objoff_3A(a0)							; is it time for spring to move again?
		beq.s	.chkdir								; if yes, branch
		subq.w	#1,objoff_3A(a0)						; else, decrement timer
		bne.s	.return								; branch, if timer didn't reach 0
		tst.b	render_flags(a0)						; are spring on screen?
		bpl.s	.return								; if not, branch
		sfx	sfx_SpikeMove,1							; play spike movement sount
; ---------------------------------------------------------------------------

.chkdir
		tst.w	objoff_38(a0)							; do spring need to move away from initial position?
		beq.s	.retract							; if yes, branch
		subi.w	#$800,objoff_36(a0)						; subtract 8 pixels from offset
		bhs.s	.return								; branch, if offset is not yet 0
		clr.l	objoff_36(a0)							; switch state
		move.w	#60,objoff_3A(a0)						; reset timer
		rts
; ---------------------------------------------------------------------------

.retract
		addi.w	#$800,objoff_36(a0)						; add 8 pixels to offset
		cmpi.w	#$2000,objoff_36(a0)						; is offset the width of one spring block (32 pixels)?
		blo.s	.return								; if not, branch
		move.w	#$2000,objoff_36(a0)
		move.w	#1,objoff_38(a0)						; switch state
		move.w	#60,objoff_3A(a0)						; reset timer

.return
		rts
