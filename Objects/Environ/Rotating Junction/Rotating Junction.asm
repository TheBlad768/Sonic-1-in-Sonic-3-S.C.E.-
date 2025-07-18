; ---------------------------------------------------------------------------
; Object 66 - rotating disc junction that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
jun_save			= objoff_32	; save frame (1 byte)
jun_frame			= objoff_34	; add or sub frame (1 byte)
jun_reverse			= objoff_36	; flag set when switch is pressed (1 byte)
jun_switch			= objoff_38	; which switch will reverse the disc (1 byte)
jun_status			= objoff_39	; status (1 byte)

; =============== S U B R O U T I N E =======================================

Obj_Junction:

		; set
		move.b	subtype(a0),jun_switch(a0)

		; init
		movem.l	ObjDat_Junction(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	#2,mainspr_childsprites(a0)					; large circular and wheel
		addq.b	#1,jun_frame(a0)						; set 1

		; sub objects
		lea	sub2_x_pos(a0),a1						; $16-$23 bytes reserved
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	y_pos(a0),(a1)+							; ypos
		move.w	#$10,(a1)+							; frame (large circular)
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	y_pos(a0),(a1)+							; ypos
;		move.w	#0,(a1)								; frame (wheel)

.action
		bsr.w	Jun_ChkSwitch							; animate
		pea	(Sprite_OnScreen_Test).w					; draw
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.w	.return								; if not, branch

		; solid
		moveq	#96/2,d1							; width
		move.w	d1,d2								; height
		move.w	d2,d3
		addq.w	#1,d3								; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; check player 1
		lea	(Player_1).w,a1							; a1=character
		moveq	#p1_pushing_bit,d6
		bsr.s	.pushing

		; check player 2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.w	.return								; if yes, branch
		tst.b	render_flags(a1)						; player 2 visible on the screen?
		bpl.w	.return								; if not, branch
		addq.b	#p2_pushing_bit-p1_pushing_bit,d6

.pushing
		btst	d6,jun_status(a0)
		bne.s	.release
		btst	d6,status(a0)
		beq.s	.return

		moveq	#7*2,d1								; set frame 14
		move.w	x_pos(a1),d0
		cmp.w	x_pos(a0),d0							; is Sonic to the left of the disc?
		blo.s	.isleft								; if yes, branch
		subq.b	#7,d1								; set frame 7

.isleft
		cmp.b	sub3_mapframe(a0),d1						; is the gap next to Sonic?
		bne.s	.return								; if not, branch
		move.b	d1,jun_save(a0)

		sfx	sfx_Roll
		move.b	#PlayerID_Control,routine(a1)
		move.b	#AniIDSonAni_Roll,anim(a1)					; make Sonic use "rolling" animation
		clr.l	x_vel(a1)
		move.w	#$800,ground_vel(a1)
		move.b	#1,object_control(a1)						; lock controls
		bclr	#status.player.pushing,status(a1)				; clear character push bit
		bset	#status.player.in_air,status(a1)				; set character in air bit
		clr.b	jumping(a1)							; clear character jumping flag
		clr.b	double_jump_flag(a1)						; clear character double jumping flag
		clr.b	spin_dash_flag(a1)						; clear spin dash flag
		bclr	d6,status(a0)							; clear object push bit
		bset	d6,jun_status(a0)						; set object push bit

		; get xypos
		move.w	x_pos(a1),d2
		move.w	y_pos(a1),d3
		bsr.s	Jun_ChgPos
		add.w	d2,x_pos(a1)
		add.w	d3,y_pos(a1)
		asr.w	x_pos(a1)
		asr.w	y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

.release
		move.b	sub3_mapframe(a0),d0
		cmpi.b	#4,d0								; is gap pointing down?
		beq.s	.setrelease							; if yes, branch
		cmpi.b	#7,d0								; is gap pointing right?
		bne.s	Jun_ChgPos							; if not, branch

.setrelease
		cmp.b	jun_save(a0),d0
		beq.s	Jun_ChgPos							; don't release
		move.l	#words_to_long(0,$800),x_vel(a1)				; x_vel + y_vel
		cmpi.b	#4,d0
		beq.s	.isdown
		move.l	#words_to_long($800,$800),x_vel(a1)				; x_vel + y_vel

.isdown
		clr.b	object_control(a1)						; unlock controls
		bclr	d6,jun_status(a0)						; clear push
		sfx	sfx_Dash							; play teleport sound

; =============== S U B R O U T I N E =======================================

Jun_ChgPos:
		moveq	#0,d0
		move.b	sub3_mapframe(a0),d0
		add.w	d0,d0
		lea	.data(pc,d0.w),a2

		; set x-offset
		move.b	(a2)+,d0
		ext.w	d0
		add.w	x_pos(a0),d0
		move.w	d0,x_pos(a1)

		; set y-offset
		move.b	(a2)+,d0
		ext.w	d0
		add.w	y_pos(a0),d0
		move.w	d0,y_pos(a1)
		rts
; ---------------------------------------------------------------------------

.data					; Sonic x-pos, Sonic y-pos
		dc.b -32, 0		; 0 (frame)
		dc.b -30, 14		; 1 (frame)
		dc.b -24, 24		; 2 (frame)
		dc.b -14, 30		; 3 (frame)
		dc.b 0, 32		; 4 (frame)
		dc.b 14, 30		; 5 (frame)
		dc.b 24, 24		; 6 (frame)
		dc.b 30, 14		; 7 (frame)
		dc.b 32, 0		; 8 (frame)
		dc.b 30, -14		; 9 (frame)
		dc.b 24, -24		; A (frame)
		dc.b 14, -30		; B (frame)
		dc.b 0, -32		; C (frame)
		dc.b -14, -30		; D (frame)
		dc.b -24, -24		; E (frame)
		dc.b -30, -14		; F (frame)

; =============== S U B R O U T I N E =======================================

Jun_ChkSwitch:
		moveq	#0,d0
		lea	(Level_trigger_array).w,a2
		move.b	jun_switch(a0),d0
		btst	#0,(a2,d0.w)							; is switch pressed?
		beq.s	.unpressed							; if not, branch
		tst.b	jun_reverse(a0)							; has switch previously been pressed?
		bne.s	.animate							; if yes, branch
		st	jun_reverse(a0)							; set to "previously pressed"
		neg.b	jun_frame(a0)
		bra.s	.animate
; ---------------------------------------------------------------------------

.unpressed
		clr.b	jun_reverse(a0)							; set to "not yet pressed"

.animate

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement frame timer
		bpl.s	.nochange							; if time remains, branch
		addq.b	#7+1,anim_frame_timer(a0)

		; animate
		move.b	jun_frame(a0),d1
		move.b	sub3_mapframe(a0),d0
		add.b	d1,d0
		andi.b	#$F,d0								; max 16 frames
		move.b	d0,sub3_mapframe(a0)						; update frame

.nochange
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Junction:	subObjMainData Obj_Junction.action, setBit(render_flags.level)|setBit(render_flags.multi_sprite), 0, 112, 112, 4, $31B, 2, 0, Map_Jun
; ---------------------------------------------------------------------------

		include "Objects/Environ/Rotating Junction/Object Data/Map - Rotating Junction.asm"
