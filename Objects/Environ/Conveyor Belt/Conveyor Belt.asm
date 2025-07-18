; ---------------------------------------------------------------------------
; Object 68 - conveyor belts (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
conv_width				= objoff_39	; (1 byte)
conv_speed				= objoff_40	; (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_Conveyor:

		; init
		move.l	#.action,address(a0)
		move.b	#128,conv_width(a0)						; set width to 128 pixels
		move.b	subtype(a0),d0							; get object type
		move.b	d0,d1								; save object type
		andi.b	#$F,d0								; read only the 2nd digit
		beq.s	.typeis0							; if zero, branch
		move.b	#56,conv_width(a0)						; set width to 56 pixels

.typeis0
		andi.b	#$F0,d1								; read only the 1st digit
		ext.w	d1
		asr.w	#4,d1
		move.w	d1,conv_speed(a0)						; set belt speed

.action
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.draw								; if yes, branch

		; player 1
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.moveplayer

.draw
		pea	(Delete_Sprite_If_Not_In_Range).w

		; player 2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.return								; if yes, branch

; =============== S U B R O U T I N E =======================================

.moveplayer
		moveq	#0,d2
		move.b	conv_width(a0),d2
		move.w	d2,d3
		add.w	d3,d3
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bhs.s	.return
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		addi.w	#48,d1
		cmpi.w	#48,d1
		bhs.s	.return
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		bne.s	.return								; if yes, branch
		move.w	conv_speed(a0),d0
		add.w	d0,x_pos(a1)

.return
		rts
