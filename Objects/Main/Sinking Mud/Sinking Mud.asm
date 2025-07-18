; ---------------------------------------------------------------------------
; Sinking Mud (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SinkingMud:

		; set
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,width_pixels(a0)
		move.w	y_pos(a0),objoff_30(a0)
		moveq	#$30,d0
		move.b	d0,objoff_38(a0)
		move.b	d0,objoff_3A(a0)
		bset	#status.npc.no_balancing,status(a0)				; disable player's balance animation
		move.l	#.main,address(a0)

.main
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.w	loc_32B62							; if yes, branch
		lea	(Player_1).w,a1
		btst	#p1_standing_bit,status(a0)
		bne.s	loc_32AEA
		cmpi.b	#$30,objoff_38(a0)
		bhs.s	loc_32ACE
		addq.b	#2,objoff_38(a0)

loc_32ACE:
		btst	#status.player.on_object,status(a1)
		beq.s	loc_32AF4
		movea.w	interact(a1),a2
		cmpi.l	#Obj_SinkingMud.main,address(a2)
		bne.s	loc_32AF4
		move.b	objoff_38(a2),objoff_38(a0)
		bra.s	loc_32AF4
; ---------------------------------------------------------------------------

loc_32AEA:
		tst.b	objoff_38(a0)
		beq.s	loc_32B68
		subq.b	#1,objoff_38(a0)

loc_32AF4:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	objoff_38(a0),d3
		moveq	#p1_standing_bit,d6
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop.check).w
		lea	(Player_2).w,a1
		btst	#p2_standing_bit,status(a0)
		bne.s	loc_32B40
		cmpi.b	#$30,objoff_3A(a0)
		bhs.s	loc_32B24
		addq.b	#2,objoff_3A(a0)

loc_32B24:
		btst	#status.player.on_object,status(a1)
		beq.s	loc_32B4A
		movea.w	interact(a1),a2
		cmpi.l	#Obj_SinkingMud.main,address(a2)
		bne.s	loc_32B4A
		move.b	objoff_3A(a2),objoff_3A(a0)
		bra.s	loc_32B4A
; ---------------------------------------------------------------------------

loc_32B40:
		tst.b	objoff_3A(a0)
		beq.s	loc_32B70
		subq.b	#1,objoff_3A(a0)

loc_32B4A:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	objoff_3A(a0),d3
		moveq	#p2_standing_bit,d6
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop.check).w

loc_32B62:
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

loc_32B68:
		move.b	#$30,objoff_38(a0)
		bra.s	loc_32B76
; ---------------------------------------------------------------------------

loc_32B70:
		move.b	#$30,objoff_3A(a0)

loc_32B76:
		not.b	d1
		and.b	d1,status(a0)

		; kill player
		move.w	a0,-(sp)
		movea.w	a0,a2
		movea.w	a1,a0
		jsr	(Kill_Character).l
		movea.w	(sp)+,a0
		rts
