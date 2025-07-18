; ---------------------------------------------------------------------------
; Updraft (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Updraft:

		; check player
		lea	(Player_1).w,a1
		bsr.s	.check
		lea	(Player_2).w,a1
		bsr.s	.check

		; check delete
		jmp	(Delete_Sprite_If_Not_In_Range).w

; =============== S U B R O U T I N E =======================================

.check
		cmpi.b	#PlayerID_Hurt,routine(a1)					; is the character hurt, dying, etc. ?
		bhs.w	.return								; if yes, branch

		; check control flag
		tst.b	object_control(a1)
		bne.w	.return

		; check xpos
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		addi.w	#64,d0
		cmpi.w	#128,d0
		bhs.w	.return

		; check ypos
		moveq	#0,d1
		move.b	(Oscillating_Data+$14).w,d1
		add.w	y_pos(a1),d1
		addi.w	#64,d1
		sub.w	y_pos(a0),d1
		blo.s	.return
		cmpi.w	#80,d1
		bhs.s	.return
		subi.w	#64,d1
		blo.s	.skip
		not.w	d1
		add.w	d1,d1

.skip
		addi.w	#64,d1
		neg.w	d1
		asr.w	#6,d1
		add.w	d1,y_pos(a1)
		bset	#status.player.in_air,status(a1)

		; clr
		moveq	#0,d0
		move.w	d0,y_vel(a1)
		move.b	d0,double_jump_flag(a1)
		move.b	d0,jumping(a1)

		; play sfx
		moveq	#$F,d0
		and.b	(V_int_run_count+3).w,d0
		bne.s	.notplay
		sfx	sfx_WindQuiet

.notplay

		; check
		tst.b	subtype(a0)
		bmi.s	.alt

		; set
		move.w	#1,ground_vel(a1)
		tst.b	flip_angle(a1)
		bne.s	.return
		move.b	#1,flip_angle(a1)
		clr.b	anim(a1)
		move.b	#$7F,flips_remaining(a1)
		move.b	#8,flip_speed(a1)

.return
		rts
; ---------------------------------------------------------------------------

.alt
		move.w	#1,ground_vel(a1)
		move.b	#AniIDSonAni_Float2,anim(a1)
		rts
