; ---------------------------------------------------------------------------
; Object 46 - solid blocks and blocks that fall from the ceiling (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
origY2				= objoff_30

; =============== S U B R O U T I N E =======================================

Obj_MarbleBrick:

		; init
		movem.l	ObjDat_MarbleBrick(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	#bytes_to_word(30/2,30/2),y_radius(a0)				; set y_radius and x_radius
		move.w	y_pos(a0),origY2(a0)

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
		moveq	#(32/2)+$B,d1							; width
		moveq	#32/2,d2							; height
		moveq	#(32/2)+1,d3							; height+1
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
		move.w	origY2(a0),d1
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
		move.w	origY2(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)							; update the block's position to make it wobble
		rts
; ---------------------------------------------------------------------------

.type03
		MoveSpriteYOnly a0, $18							; increase falling speed
		jsr	(ObjCheckFloorDist).w
		tst.w	d1								; has the block hit the floor?
		bpl.s	.return								; if not, branch
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)							; stop the block falling
		move.w	y_pos(a0),origY2(a0)
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

; mapping
ObjDat_MarbleBrick:		subObjMainData Obj_MarbleBrick.action, setBit(render_flags.level)|setBit(render_flags.static_mappings), 0, 32, 32, 1, 0, 2, 0, Map_Brick
; ---------------------------------------------------------------------------

		include "Objects/Environ/Marble Brick/Object Data/Map - Marble Brick.asm"
