; ---------------------------------------------------------------------------
; Object 72 - teleporter (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

; player 1
	dsset x_vel									; pretend we're in the RAM

teleport_p1_attached =			*
teleport_p1_attached.routine		ds.b 1	; (1 byte)
teleport_p1_attached.sine		ds.b 1	; (1 byte)
teleport_p1_attached.timer		ds.w 1	; (2 bytes)
teleport_p1_attached.size		ds.w 1	; (2 bytes)
teleport_p1_attached.pointer		ds.l 1	; (4 bytes)				; save address
teleport_p1_attached.saveX		ds.w 1	; (2 bytes)
teleport_p1_attached.saveY		ds.w 1	; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; player 2
	dsset wait_timer								; pretend we're in the RAM

teleport_p2_attached =			*
teleport_p2_attached.routine		ds.b 1	; (1 byte)
teleport_p2_attached.sine		ds.b 1	; (1 byte)
teleport_p2_attached.timer		ds.w 1	; (2 bytes)
teleport_p2_attached.size		ds.w 1	; (2 bytes)
teleport_p2_attached.pointer		ds.l 1	; (4 bytes)				; save address
teleport_p2_attached.saveX		ds.w 1	; (2 bytes)
teleport_p2_attached.saveY		ds.w 1	; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Teleport:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; set
		move.l	#.main,address(a0)

		; init
		moveq	#$F,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		lea	Teleport_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d0							; get size
		move.l	a2,d1								; get address
		move.l	(a2),d2								; get saveXY

		; player 1
		lea	teleport_p1_attached.size(a0),a4
		move.w	d0,(a4)+							; save size
		move.l	d1,(a4)+							; save address
		move.l	d2,(a4)								; save saveXY

		; player 2
		lea	teleport_p2_attached.size(a0),a4
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
		lea	teleport_p1_attached(a0),a4
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.check

		; player 2
		lea	teleport_p2_attached(a0),a4
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is object RAM slot empty?
		beq.s	.skipp2								; if yes, branch
		bsr.s	.check

.skipp2

		; check players
		move.b	teleport_p1_attached(a0),d0					; check player 1
		or.b	teleport_p2_attached(a0),d0					; check player 2
		bne.s	.return								; branch, if not touch

.chkdel
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.movecharacter
		jmp	(MoveSprite2_Parent).w
; ---------------------------------------------------------------------------

.check
		moveq	#0,d0
		move.b	teleport_p1_attached.routine-teleport_p1_attached(a4),d0	; get routine
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	loc_271D0							; 0
		rts									; nop
		bra.w	loc_27260							; 4
; ---------------------------------------------------------------------------

		; 8
		subq.b	#1,teleport_p1_attached.timer-teleport_p1_attached(a4)		; timer
		bpl.s	.movecharacter
		move.w	teleport_p1_attached.saveX-teleport_p1_attached(a4),x_pos(a1)	; get saveX
		move.w	teleport_p1_attached.saveY-teleport_p1_attached(a4),y_pos(a1)	; get saveY
		moveq	#4,d1
		add.b	teleport_p1_attached.size-teleport_p1_attached(a4),d1		; size (byte1)
		cmp.b	(teleport_p1_attached.size+1)-teleport_p1_attached(a4),d1	; size (byte2)
		blo.w	loc_273F2
		moveq	#0,d1
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		bne.s	.notwrapping							; if not, branch
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a1)							; perform wrapping of player's y position

.notwrapping
		clr.b	teleport_p1_attached.routine-teleport_p1_attached(a4)		; clear routine
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
		beq.s	.notflipx
		addi.w	#15,d0

.notflipx
		cmpi.w	#16,d0
		bhs.s	locret_1675C
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		addi.w	#32,d1
		cmpi.w	#64,d1
		bhs.s	locret_1675C
		tst.b	object_control(a1)
		bne.s	locret_1675C
		addq.b	#4,teleport_p1_attached.routine-teleport_p1_attached(a4)	; next routine
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
		clr.b	teleport_p1_attached.sine-teleport_p1_attached(a4)		; sine
		sfx	sfx_Roll,1							; play Sonic rolling sound
; ---------------------------------------------------------------------------

locret_1675C:
		rts
; ---------------------------------------------------------------------------

loc_27260:
		move.b	teleport_p1_attached.sine-teleport_p1_attached(a4),d0		; sine
		addq.b	#2,teleport_p1_attached.sine-teleport_p1_attached(a4)		; sine
		jsr	(GetSineCosine).w
		asr.w	#5,d0
		move.w	y_pos(a0),d2
		sub.w	d0,d2
		move.w	d2,y_pos(a1)
		cmpi.b	#$80,teleport_p1_attached.sine-teleport_p1_attached(a4)		; sine
		bne.s	locret_1675C
		bsr.s	sub_27310
		addq.b	#4,teleport_p1_attached.routine-teleport_p1_attached(a4)	; next routine
		sfx	sfx_Dash,1							; play teleport sound
; ---------------------------------------------------------------------------

loc_273F2:
		move.b	d1,teleport_p1_attached.size-teleport_p1_attached(a4)		; save size (byte1)
		movea.l	teleport_p1_attached.pointer-teleport_p1_attached(a4),a2	; load save address
		move.l	(a2,d1.w),teleport_p1_attached.saveX-teleport_p1_attached(a4)	; save saveXY

; =============== S U B R O U T I N E =======================================

sub_27310:
		moveq	#0,d0
		move.w	#$1000,d2
		move.w	d2,d3
		move.w	teleport_p1_attached.saveX-teleport_p1_attached(a4),d0		; get saveX
		sub.w	x_pos(a1),d0
		bge.s	.loc_27384
		neg.w	d0
		neg.w	d2

.loc_27384
		moveq	#0,d1
		move.w	teleport_p1_attached.saveY-teleport_p1_attached(a4),d1		; get saveY
		sub.w	y_pos(a1),d1
		bge.s	.loc_27392
		neg.w	d1
		neg.w	d3

.loc_27392
		cmp.w	d0,d1
		blo.s	.loc_273C4
		moveq	#0,d1
		move.w	teleport_p1_attached.saveY-teleport_p1_attached(a4),d1		; get saveY
		sub.w	y_pos(a1),d1
		swap	d1
		divs.w	d3,d1
		moveq	#0,d0
		move.w	teleport_p1_attached.saveX-teleport_p1_attached(a4),d0		; get saveX
		sub.w	x_pos(a1),d0
		beq.s	.loc_273B0
		swap	d0
		divs.w	d1,d0

.loc_273B0
		movem.w	d0/d3,x_vel(a1)
		abs.w	d1
		move.w	d1,teleport_p1_attached.timer-teleport_p1_attached(a4)		; timer
		rts
; ---------------------------------------------------------------------------

.loc_273C4
		moveq	#0,d0
		move.w	teleport_p1_attached.saveX-teleport_p1_attached(a4),d0		; get saveX
		sub.w	x_pos(a1),d0
		swap	d0
		divs.w	d2,d0
		moveq	#0,d1
		move.w	teleport_p1_attached.saveY-teleport_p1_attached(a4),d1		; get saveY
		sub.w	y_pos(a1),d1
		beq.s	.loc_273DE
		swap	d1
		divs.w	d0,d1

.loc_273DE
		move.w	d1,y_vel(a1)
		move.w	d2,x_vel(a1)
		abs.w	d0
		move.w	d0,teleport_p1_attached.timer-teleport_p1_attached(a4)		; timer
		rts
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Teleporter/Object Data/Data - Teleporter.asm"
