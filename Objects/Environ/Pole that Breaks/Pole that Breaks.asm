; ---------------------------------------------------------------------------
; Object 0B - pole that breaks (LZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

; players
pole_p1_attached =			*
pole_p1_attached.touch			ds.b 1						; (1 byte)
pole_p2_attached =			*
pole_p2_attached.touch			ds.b 1						; (1 byte)
pole_p1_attached.timer			ds.b 1						; (1 byte)
pole_p2_attached.timer			ds.b 1						; (1 byte)

; main
pole.timer				ds.w 1						; time between grabbing the pole & breaking (2 bytes)
pole.ysub				ds.w 1						; (2 bytes)
pole.yadd				ds.w 1						; (2 bytes)
pole.grabbed				ds.b 1						; flag set when Sonic grabs the pole (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Pole:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		movem.l	ObjDat_Pole(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.l	#words_to_long(24,36),pole.ysub(a0)

		; set time
		moveq	#$F,d0
		and.b	subtype(a0),d0							; get object type
		add.w	d0,d0								; multiply by 60 (1 second)
		add.w	d0,d0
		move.w	d0,d1
		lsl.w	#4,d0
		sub.w	d1,d0
		move.w	d0,pole.timer(a0)						; set breakage time

.action
		lea	pole_p1_attached(a0),a2						; load player status
		tst.w	pole.timer(a0)
		beq.s	.moveup
		tst.w	pole_p1_attached.touch-pole_p1_attached(a2)			; is players holding onto a pole?
		beq.s	.moveup								; if not, branch
		subq.w	#1,pole.timer(a0)						; decrement time until break
		beq.s	.release

.moveup

		; check p1
		lea	(Player_1).w,a1							; a1=character
		move.w	(Ctrl_1).w,d1
		moveq	#WindTunnel_holding_flag.player_1,d2
		bsr.s	.control

		; check p2
		addq.w	#pole_p2_attached-pole_p1_attached,a2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.rcheck								; if yes, branch
		move.w	(Ctrl_2).w,d1
		moveq	#WindTunnel_holding_flag.player_2,d2
		bsr.s	.control

.rcheck
		tst.b	pole.grabbed(a0)
		bne.s	.release

		; draw
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

.release
		tst.b	pole_p1_attached(a0)
		beq.s	.notp1
		andi.b	#$FE,(Player_1+object_control).w

.notp1
		tst.b	pole_p2_attached(a0)
		beq.s	.notp2
		andi.b	#$FE,(Player_2+object_control).w

.notp2
		clr.b	(WindTunnel_holding_flag).w					; enable wind tunnel
		clr.w	pole_p1_attached(a0)
		move.b	#1,mapping_frame(a0)						; break the pole
;		sfx	sfx_Collapse							; play smashing sound

		; draw
		lea	(Sprite_OnScreen_Test).w,a1
		move.l	a1,address(a0)
		jmp	(a1)

; =============== S U B R O U T I N E =======================================

.control
		tst.b	pole_p1_attached.touch-pole_p1_attached(a2)			; has player touched the pole?
		beq.s	.grab								; if not, branch

		; move up
		move.w	y_pos(a0),d0
		sub.w	pole.ysub(a0),d0
		btst	#button_up+setBit(3),d1						; is "up" pressed?
		beq.s	.movedown							; if not, branch
		subq.w	#1,y_pos(a1)							; move Sonic up
		cmp.w	y_pos(a1),d0
		blo.s	.movedown
		move.w	d0,y_pos(a1)

.movedown
		add.w	pole.yadd(a0),d0
		btst	#button_down+setBit(3),d1					; is "down" pressed?
		beq.s	.letgo								; if not, branch
		addq.w	#1,y_pos(a1)							; move Sonic down
		cmp.w	y_pos(a1),d0
		bhs.s	.letgo
		move.w	d0,y_pos(a1)

.letgo
		andi.w	#btnABC,d1							; is A/B/C pressed?
		beq.s	.return								; if not, branch
		clr.b	pole_p1_attached.touch-pole_p1_attached(a2)
		move.b	#1*60,pole_p1_attached.timer-pole_p1_attached(a2)
		bclr	d2,(WindTunnel_holding_flag).w					; enable wind tunnel
		andi.b	#$FE,object_control(a1)
		btst	#6,subtype(a0)							; $40?
		bne.s	.return
		st	pole.grabbed(a0)						; begin countdown to breakage

.return
		rts

; =============== S U B R O U T I N E =======================================

.grab
		tst.b	pole_p1_attached.timer-pole_p1_attached(a2)			; is timer over?
		beq.s	.check								; if yes, branch
		subq.b	#1,pole_p1_attached.timer-pole_p1_attached(a2)			; subtract 1

.return2
		rts
; ---------------------------------------------------------------------------

.check

		; check height
		moveq	#0,d1
		move.b	height_pixels(a0),d1
		move.w	y_pos(a0),d0
		sub.w	d1,d0
		move.w	y_pos(a1),d2
		cmp.w	d0,d2
		blo.s	.return2
		add.w	d1,d0
		add.w	d1,d0
		cmp.w	d0,d2
		bhs.s	.return2

		; check xpos
		moveq	#20,d0
		add.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		bhs.s	.return2
		addi.w	#16,d0
		cmp.w	x_pos(a1),d0
		blo.s	.return2

		; check player
		cmpi.b	#PlayerID_Hurt,routine(a1)					; is player gets hurt?
		bhs.s	.return2							; if yes, branch
		tst.b	object_control(a1)
		bne.s	.return2

		; check ypos
		move.w	y_pos(a0),d0
		sub.w	pole.ysub(a0),d0
		cmp.w	y_pos(a1),d0
		blo.s	.skipy
		move.w	d0,y_pos(a1)

.skipy
		add.w	pole.yadd(a0),d0
		cmp.w	y_pos(a1),d0
		bhs.s	.skipy2
		move.w	d0,y_pos(a1)

.skipy2
		clr.l	x_vel(a1)							; stop player moving
		moveq	#20,d0
		add.w	x_pos(a0),d0
		move.w	d0,x_pos(a1)
		bclr	#status.player.x_flip,status(a1)
		move.b	#AniIDSonAni_Hang,anim(a1)					; set player's animation to "hanging" ($11)
		move.b	#1,object_control(a1)						; lock controls
		bset	d2,(WindTunnel_holding_flag).w					; disable wind tunnel
		st	pole_p1_attached.touch-pole_p1_attached(a2)			; set "grab" flag
		sfx	sfx_Grab,1							; play grab sound

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Pole:		subObjMainData Obj_Pole.action, setBit(render_flags.level), 0, 64, 16, 4, $3DE, 2, FALSE, Map_Pole
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Pole that Breaks/Object Data/Map - Pole that Breaks.asm"
