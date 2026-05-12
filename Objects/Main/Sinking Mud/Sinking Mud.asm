; ---------------------------------------------------------------------------
; Sinking Mud (Object)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

; players
sinkingmud.p1_depth			ds.b 1						; Sonic's depth of the mud (1 byte)
sinkingmud.p2_depth			ds.b 1						; Tails's depth of the mud (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SinkingMud:

		; calc
		move.b	subtype.byte(a0),d0
		lsl.b	#3,d0								; multiply by 8
		move.b	d0,width_pixels(a0)

		; set
		moveq	#$30,d0
		move.b	d0,sinkingmud.p1_depth(a0)
		move.b	d0,sinkingmud.p2_depth(a0)
		bset	#status.npc.no_balancing,status(a0)				; disable player's balance animation
		move.l	#.main,code_addr(a0)

.main

		; check debug
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.chkdel								; if yes, branch

		; check p1
		lea	(Player_1).w,a1							; a1=character
		lea	sinkingmud.p1_depth(a0),a2
		moveq	#p1_standing_bit,d6
		bsr.s	.process

		; check p2
		lea	(Player_2).w,a1							; a1=character
		tst.l	code_addr(a1)							; is the player RAM empty?
		beq.s	.chkdel								; if yes, branch
		lea	sinkingmud.p2_depth(a0),a2
		moveq	#p2_standing_bit,d6
		bsr.s	.process

.chkdel
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.process
		btst	d6,status(a0)							; is the player standing on the current object?
		bne.s	.sinking							; if yes, branch

		; smoothly restore the depth
		cmpi.b	#$30,(a2)
		bhs.s	.check
		addq.b	#2,(a2)

.check
		btst	#status.player.on_object,status(a1)				; is player standing on an object?
		beq.s	.solid								; if not, branch
		movea.w	interact(a1),a3
		cmpi.l	#Obj_SinkingMud.main,code_addr(a3)
		bne.s	.solid
		move.w	a2,d0
		sub.w	a0,d0
		move.b	(a3,d0.w),(a2)
		bra.s	.solid
; ---------------------------------------------------------------------------

.sinking
		tst.b	(a2)
		beq.s	.kill_player
		subq.b	#1,(a2)

.solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	(a2),d3								; height_pixels
		move.w	x_pos(a0),d4
		jmp	(SolidObjectTop.check).w
; ---------------------------------------------------------------------------

.kill_player
		move.b	#$30,(a2)							; reset depth of the mud

		; kill player
		move.w	a0,-(sp)
		movea.w	a0,a2
		movea.w	a1,a0
		jsr	(Kill_Character).l
		movea.w	(sp)+,a0
		rts
