; ---------------------------------------------------------------------------
; Twisted Ramp (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TwistedRamp:

		; check player
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.check
		lea	(Player_2).w,a1							; a1=character
		bsr.s	.check

		; check delete
		jmp	(Delete_Sprite_If_Not_In_Range).w

; =============== S U B R O U T I N E =======================================

.check
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		bne.w	.return								; if yes, branch

		; check control flag
		tst.b	object_control(a1)
		bne.s	.return

		; check xpos
		moveq	#16,d0
		add.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		blo.s	.return
		cmpi.w	#32,d0
		bge.s	.return

		; check ypos
		move.w	y_pos(a1),d0
		sub.w	y_pos(a0),d0
		cmpi.w	#-20,d0
		blt.s	.return
		cmpi.w	#32,d0
		bgt.s	.return

		; check xflip
		btst	#status.npc.x_flip,status(a0)
		bne.s	.left

		; right
		cmpi.w	#$400,x_vel(a1)
		blt.s	.return
		addi.w	#$400,x_vel(a1)
		bra.s	.launch
; ---------------------------------------------------------------------------

.left
		cmpi.w	#-$400,x_vel(a1)
		bgt.s	.return
		subi.w	#$400,x_vel(a1)

.launch
		move.w	#-$700,y_vel(a1)
		bset	#status.player.in_air,status(a1)
		move.b	#PlayerID_Control,routine(a1)
		moveq	#1,d0
		move.w	d0,ground_vel(a1)
		move.b	d0,flip_angle(a1)
		moveq	#0,d0
		move.b	d0,anim(a1)
		move.b	d0,flips_remaining(a1)
		move.b	#4,flip_speed(a1)
		move.b	#5,flip_type(a1)

.return
		rts
