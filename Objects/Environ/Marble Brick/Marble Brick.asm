; ---------------------------------------------------------------------------
; Object 46 - solid blocks and blocks that fall from the ceiling (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

marblebrick.origY			ds.w 1						; original y-axis position (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_MarbleBrick:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		movem.l	ObjDat_MarbleBrick(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	#bytes_to_word(30/2,30/2),y_radius(a0)				; set y_radius and x_radius
		move.w	y_pos(a0),marblebrick.origY(a0)

.action
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; type
		moveq	#7,d0								; read only the 1st digit
		and.b	subtype(a0),d0							; get object type
		beq.s	.solid								; if zero, branch
		add.w	d0,d0
		jsr	.index-2(pc,d0.w)

.solid

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1						; monitor's width
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3								; monitor's height
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

.chkdel
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

.index
		bra.s	.type01								; 1
		bra.s	.type02								; 2
		bra.s	.type03								; 3
; ---------------------------------------------------------------------------

		; type04								; 4
		moveq	#0,d0
		move.b	(Oscillating_Data+$10).w,d0
		lsr.w	#3,d0
		move.w	marblebrick.origY(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)							; make the block wobble
		rts
; ---------------------------------------------------------------------------

.type02
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.type01								; if yes, branch
		jsr	(Find_SonicTails).w
		cmpi.w	#144,d2								; is Sonic within $90 pixels of the block?
		bhs.s	.type01								; if not, resume wobbling
		move.b	#3,subtype(a0)							; if yes, make the block fall

.type01
		moveq	#0,d0
		move.b	(Oscillating_Data+$14).w,d0
		btst	#3,subtype(a0)
		beq.s	.set
		neg.w	d0
		addi.w	#$10,d0

.set
		move.w	marblebrick.origY(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)							; update the block's position to make it wobble
		rts
; ---------------------------------------------------------------------------

.type03
		MoveSpriteYOnly , $18							; increase falling speed
		jsr	(ObjCheckFloorDist).w
		tst.w	d1								; has the block hit the floor?
		bpl.s	.return								; if not, branch
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)							; stop the block falling
		move.w	y_pos(a0),marblebrick.origY(a0)
		move.b	#4,subtype(a0)

		; check lava
		move.w	(a1),d0								; get id of the 16x16 block
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0							; brick has touched the lava?
		bhs.s	.return								; if yes, branch
		clr.b	subtype(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_MarbleBrick:	subObjMainData \
				Obj_MarbleBrick.action, \
					setBit(render_flags.level) | \
					setBit(render_flags.static_mappings), \
				0, 32, 32, 1, 0, 2, FALSE, Map_MarbleBrick
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Marble Brick/Object Data/Map - Marble Brick.asm"
