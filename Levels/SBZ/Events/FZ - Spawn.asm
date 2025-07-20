; ---------------------------------------------------------------------------
; Spawn players (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Spawn_FinalZone:
		move.w	#30-1,objoff_2E(a0)						; set time
		move.l	#.wait,address(a0)

		; set
		move.w	#-1,(Ctrl_1_locked).w						; lock control 1 and control 2

		; clear
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_1).w
		move.w	d0,(Ctrl_2_logical).w
		move.w	d0,(Ctrl_2).w

		; check
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.set
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)
		beq.s	.return

.set
		move.b	#3,object_control(a1)

.return
		rts
; ---------------------------------------------------------------------------

.wait

		; set
		move.w	#-1,(Ctrl_1_locked).w						; lock control 1 and control 2

		; clear
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_2_logical).w

		; wait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.return

		; next
		move.l	#.fall,address(a0)
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.setjump
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)
		beq.s	.return2

.setjump
		move.w	#-$780,y_vel(a1)
		bset	#status.player.in_air,status(a1)
		clr.b	jumping(a1)
		move.b	#AniIDSonAni_Spring,anim(a1)
		move.b	#1,object_control(a1)						; lock controls

.return2
		rts
; ---------------------------------------------------------------------------

.fall

		; set
		move.w	#-1,(Ctrl_1_locked).w						; lock control 1 and control 2

		; clear
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_2_logical).w

		; check p1
		lea	(Player_1).w,a2							; a2=character
		cmpi.w	#$5C0,y_pos(a2)
		bhs.s	.checkfalling
		clr.b	object_control(a2)

		; check p2
		lea	(Player_2).w,a2							; a2=character
		tst.l	address(a2)
		beq.s	.delete
		clr.b	object_control(a2)

.delete
		clr.w	(Ctrl_1_locked).w						; unlock control 1 and control 2

		; save xypos (not load spawn jump again)
		move.b	#1,(Last_star_post_hit).w

		; check
		lea	(Level_data_addr_RAM.SonLoc).w,a1				; load Sonic's start location
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.notKnux
		addq.w	#2*2,a1								; load Knuckles's start location

.notKnux
		move.l	(a1),(Saved_X_pos).w						; save Sonic's position on x-axis and y-axis
		jsr	(Save_Level_Data).l
		clr.l	(Saved_timer).w

		; delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.checkfalling
		bsr.s	.falling
		lea	(Player_2).w,a2							; a2=character
		tst.l	address(a2)							; is player RAM empty?
		beq.s	.return3							; if yes, branch

.falling
		MoveSprite a2

.return3
		rts
