; ---------------------------------------------------------------------------
; Object 72 - teleporter (SBZ)
; ---------------------------------------------------------------------------

; Constants
Teleport_Offset:			= *

; Dynamic object variables

; player 1
	phase objoff_18	; $E bytes ($18-$26)

tele_player1_attached		= *

.routine			ds.b 1	; 0
.sine				ds.b 1	; 1
.timer				ds.w 1	; 2
.size				ds.w 1	; 4
.pointer			ds.l 1	; 6	; save address
.saveX				ds.w 1	; $A
.saveY				ds.w 1	; $C

	dephase

; player 2
	phase objoff_2E	; $E bytes ($2E-$3C)

tele_player2_attached		= *

.routine			ds.b 1	; 0
.sine				ds.b 1	; 1
.timer				ds.w 1	; 2
.size				ds.w 1	; 4
.pointer			ds.l 1	; 6	; save address
.saveX				ds.w 1	; $A
.saveY				ds.w 1	; $C

	dephase
	!org	Teleport_Offset

; =============== S U B R O U T I N E =======================================

Obj_Teleport:
		move.l	#.main,address(a0)

		; init
		moveq	#$F,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		lea	Tele_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d0							; get size
		move.l	a2,d1								; get address
		move.l	(a2),d2								; get saveXY

		; player 1
		lea	tele_player1_attached+4(a0),a4
		move.w	d0,(a4)+							; save size
		move.l	d1,(a4)+							; save address
		move.l	d2,(a4)								; save saveXY

		; player 2
		lea	tele_player2_attached+4(a0),a4
		move.w	d0,(a4)+							; save size
		move.l	d1,(a4)+							; save address
		move.l	d2,(a4)								; save saveXY

.main
		cmpi.b	#7,subtype(a0)
		bne.s	.players
		cmpi.w	#50,(Ring_count).w						; does Sonic have at least 50 rings?
		blo.s	.chkdel								; if not, branch

.players

		; player 1
		lea	tele_player1_attached(a0),a4
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.check

		; player 2
		lea	tele_player2_attached(a0),a4
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)
		beq.s	.skipp2
		bsr.s	.check

.skipp2

		; check players
		move.b	tele_player1_attached(a0),d0					; check player 1
		or.b	tele_player2_attached(a0),d0					; check player 2
		bne.s	.return								; branch, if not touch

.chkdel
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.movecharacter
		jmp	(MoveSprite2_Parent).w
; ---------------------------------------------------------------------------

.check
		moveq	#0,d0
		move.b	(a4),d0								; get routine
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	loc_271D0							; 0
		rts									; nop
		bra.w	loc_27260							; 4
; ---------------------------------------------------------------------------

		; 8
		subq.b	#1,2(a4)							; timer
		bpl.s	.movecharacter
		move.w	$A(a4),x_pos(a1)						; get saveX
		move.w	$C(a4),y_pos(a1)						; get saveY
		moveq	#4,d1
		add.b	4(a4),d1							; size (byte1)
		cmp.b	5(a4),d1							; size (byte2)
		blo.w	loc_273F2
		moveq	#0,d1
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		bne.s	.notwrapping							; if not, branch
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a1)							; perform wrapping of player's y position

.notwrapping
		clr.b	(a4)								; clear routine
		clr.b	object_control(a1)
		move.l	#words_to_long(0,$200),x_vel(a1)				; x_vel + y_vel

.return
		rts
; ---------------------------------------------------------------------------

loc_271D0:
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	Obj_Teleport.return						; if yes, branch
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	loc_166E0
		addi.w	#15,d0

loc_166E0:
		cmpi.w	#16,d0
		bhs.s	locret_1675C
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		addi.w	#32,d1
		cmpi.w	#64,d1
		bhs.s	locret_1675C
		tst.b	object_control(a1)
		bne.s	locret_1675C
		addq.b	#4,(a4)								; next routine
		move.b	#$81,object_control(a1)						; lock controls and disable object interaction
		move.b	#PlayerID_Control,routine(a1)
		move.b	#AniIDSonAni_Roll,anim(a1)					; use Sonic's rolling animation
		move.w	#$800,ground_vel(a1)
		clr.l	x_vel(a1)
		clr.b	spin_dash_flag(a1)						; clear spin dash flag
		bclr	#status.player.pushing,status(a1)
		bset	#status.player.in_air,status(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		clr.b	1(a4)								; sine
		sfx	sfx_Roll,1							; play Sonic rolling sound
; ---------------------------------------------------------------------------

locret_1675C:
		rts
; ---------------------------------------------------------------------------

loc_27260:
		move.b	1(a4),d0							; sine
		addq.b	#2,1(a4)							; sine
		jsr	(GetSineCosine).w
		asr.w	#5,d0
		move.w	y_pos(a0),d2
		sub.w	d0,d2
		move.w	d2,y_pos(a1)
		cmpi.b	#$80,1(a4)							; sine
		bne.s	locret_1675C
		bsr.s	sub_27310
		addq.b	#4,(a4)								; next routine
		sfx	sfx_Dash,1							; play teleport sound
; ---------------------------------------------------------------------------

loc_273F2:
		move.b	d1,4(a4)							; save size (byte1)
		movea.l	6(a4),a2							; load save address
		move.l	(a2,d1.w),$A(a4)						; save saveXY

; =============== S U B R O U T I N E =======================================

sub_27310:
		moveq	#0,d0
		move.w	#$1000,d2
		move.w	d2,d3
		move.w	$A(a4),d0							; get saveX
		sub.w	x_pos(a1),d0
		bge.s	loc_27384
		neg.w	d0
		neg.w	d2

loc_27384:
		moveq	#0,d1
		move.w	$C(a4),d1							; get saveY
		sub.w	y_pos(a1),d1
		bge.s	loc_27392
		neg.w	d1
		neg.w	d3

loc_27392:
		cmp.w	d0,d1
		blo.s	loc_273C4
		moveq	#0,d1
		move.w	$C(a4),d1							; get saveY
		sub.w	y_pos(a1),d1
		swap	d1
		divs.w	d3,d1
		moveq	#0,d0
		move.w	$A(a4),d0							; get saveX
		sub.w	x_pos(a1),d0
		beq.s	loc_273B0
		swap	d0
		divs.w	d1,d0

loc_273B0:
		movem.w	d0/d3,x_vel(a1)
		abs.w	d1
		move.w	d1,2(a4)							; timer
		rts
; ---------------------------------------------------------------------------

loc_273C4:
		moveq	#0,d0
		move.w	$A(a4),d0							; get saveX
		sub.w	x_pos(a1),d0
		swap	d0
		divs.w	d2,d0
		moveq	#0,d1
		move.w	$C(a4),d1							; get saveY
		sub.w	y_pos(a1),d1
		beq.s	loc_273DE
		swap	d1
		divs.w	d0,d1

loc_273DE:
		move.w	d1,y_vel(a1)
		move.w	d2,x_vel(a1)
		abs.w	d0
		move.w	d0,2(a4)							; timer
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Teleporter/Object Data/Data - Teleporter.asm"
