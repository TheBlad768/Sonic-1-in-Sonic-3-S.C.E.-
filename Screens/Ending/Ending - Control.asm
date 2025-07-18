; ---------------------------------------------------------------------------
; Subroutine controlling players on the ending sequence
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

End_MoveSonic:
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w

		; routine buffer
		lea	(Ending_player).w,a0

		; p1
		moveq	#0,d5
		lea	(Player_1).w,a1							; a1=character
		lea	(Ctrl_1_logical).w,a2
		lea	(Ctrl_1_locked).w,a3
		bsr.s	.movep

		; p2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.return								; if yes, branch
		moveq	#1,d5
		addq.w	#1,a0								; next routine RAM
		addq.w	#Ctrl_2_logical-Ctrl_1_logical,a2
		addq.w	#Ctrl_2_locked-Ctrl_1_locked,a3

.movep
		move.b	(a0),d0								; check routine
		bne.s	.movep2
		move.w	#-$600,ground_vel(a1)
		cmpi.w	#(320/2)-16,x_pos(a1)						; has player passed $90 on x-axis?
		bhs.s	.return								; if not, branch
		addq.b	#2,(a0)								; next routine
		st	(a3)								; set ctrl locked
		move.w	#bytes_to_word(btnR,0),(a2)					; set ctrl logical

.return
		rts
; ---------------------------------------------------------------------------

.movep2
		subq.b	#2,d0								; check routine
		bne.s	.movep3

		; check
		move.w	#320/2,d2							; p1
		tst.b	d5								; is player 1?
		beq.s	.p11								; if yes, branch
		move.w	#(320/2)+64,d2							; p2

.p11
		move.w	(Camera_min_X_pos).w,d0
		move.w	#bytes_to_word(btnL,0),d1
		add.w	d2,d0
		sub.w	x_pos(a1),d0
		beq.s	.done
		blo.s	.setlog
		move.w	#bytes_to_word(btnR,0),d1

.setlog
		move.w	d1,(a2)
		rts
; ---------------------------------------------------------------------------

.done
		addq.b	#2,(a0)								; next routine
		clr.b	(a3)								; clear ctrl locked
		clr.w	(a2)								; clear ctrl logical
		clr.w	ground_vel(a1)							; clear ground velocity
		move.b	#$81,object_control(a1)

		; p2
		move.w	#bytes_to_word(AniIDSonAni_Wait,AniIDSonAni_Walk),anim(a1)	; use "standing" animation and reset animate
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		bne.s	.nonoemrd							; if not, branch
		move.w	#bytes_to_word(AniIDSonAni_LookUp,AniIDSonAni_Walk),anim(a1)	; use "look up" animation and reset animate

.nonoemrd
		tst.b	d5								; is player 1?
		bne.s	.return2							; if not, branch

		; p1
		move.b	#3,anim_frame_timer(a1)
		move.w	#bytes_to_word(AniIDSonAni_Wait,AniIDSonAni_Wait),anim(a1)	; use "standing" animation and not reset animate

		; set frame
		moveq	#0,d0
		move.b	(Player_1+character_id).w,d0
		move.b	.fdata(pc,d0.w),mapping_frame(a1)

.return2
		rts
; ---------------------------------------------------------------------------

.fdata	dc.b $BD, $B1, $D2	; Sonic, Tails, Knuckles
	even
; ---------------------------------------------------------------------------

.movep3
		subq.b	#2,d0								; check routine
		bne.s	.return3
		addq.b	#2,(a0)								; next routine
		bset	#status.player.x_flip,status(a1)				; left side
		move.w	#(320/2)+64,x_pos(a1)						; p2
		tst.b	d5								; is player 1?
		bne.s	.return3							; if not, branch
		move.w	#320/2,x_pos(a1)						; p1
		move.l	#Obj_Sonic_Ending,(Player_1+address).w

.return3
		rts
