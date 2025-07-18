; ---------------------------------------------------------------------------
; Object 30 - large green glass blocks (MZ)
; ---------------------------------------------------------------------------

; Options
_GLASSBLOCK_YPOS_		= 1		; fixed version

; Dynamic object variables
glass_ypos			= objoff_30	; copy ypos
glass_dist			= objoff_32	; distance block moves when switch is pressed

; =============== S U B R O U T I N E =======================================

Obj_GlassBlock:

		; init
		movem.l	ObjDat_GlassBlock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	y_pos(a0),glass_ypos(a0)
		move.w	#$90,glass_dist(a0)
		move.w	#2,mainspr_childsprites(a0)					; block and reflector

		; sub objects
		lea	sub2_x_pos(a0),a1						; $16-$23 bytes reserved
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	y_pos(a0),(a1)+							; ypos
		move.w	#2,(a1)+							; frame (reflect)
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	y_pos(a0),(a1)+							; ypos
		move.w	#1,(a1)								; frame (block)
		cmpi.b	#3,subtype(a0)							; is object type 0/1/2?
		blo.s	.block012							; if yes, branch
		move.w	#3,(a1)								; frame (block)
		move.b	#112/2,height_pixels(a0)

.block012
		moveq	#7,d0
		and.b	subtype(a0),d0
		beq.s	.solid								; if zero, branch
		add.w	d0,d0
		move.w	Glass_TypeIndex-2(pc,d0.w),d0
		jsr	Glass_TypeIndex(pc,d0.w)

.solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Glass_TypeIndex: offsetTable
		offsetTableEntry.w Glass_Type01						; 1
		offsetTableEntry.w Glass_Type02						; 2
		offsetTableEntry.w Glass_Type03						; 3
		offsetTableEntry.w Glass_Type04						; 4
; ---------------------------------------------------------------------------

Glass_Type01:
		moveq	#0,d0
		move.b	(Oscillating_Data+$10).w,d0
		moveq	#$40,d1
		bra.s	loc_B514
; ---------------------------------------------------------------------------

Glass_Type02:
		moveq	#0,d0
		move.b	(Oscillating_Data+$10).w,d0
		moveq	#$40,d1
		neg.w	d0
		add.w	d1,d0

loc_B514:
		move.w	glass_ypos(a0),d2
		sub.w	d0,d2

		; move main object
		move.w	d2,y_pos(a0)

		; move sub object 1
		move.w	d2,sub3_y_pos(a0)

		; move sub object 2
		neg.w	d0
		add.w	d1,d0
		lsr.b	d0
		addi.w	#$20,d0
		move.w	glass_ypos(a0),d2
		sub.w	d0,d2
		move.w	d2,sub2_y_pos(a0)
		rts
; ---------------------------------------------------------------------------

Glass_Type03:
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	loc_B54E							; if yes, branch
		bclr	#0,objoff_34(a0)
		bra.s	loc_B582
; ---------------------------------------------------------------------------

loc_B54E:
		tst.b	objoff_34(a0)
		bne.s	loc_B582
		move.b	#1,objoff_34(a0)
		bset	#0,objoff_35(a0)
		beq.s	loc_B582
		bset	#7,objoff_34(a0)
		move.w	#$10,objoff_36(a0)
		move.b	#$A,objoff_38(a0)
		cmpi.w	#$40,glass_dist(a0)
		bne.s	loc_B582
		move.w	#$40,objoff_36(a0)

loc_B582:
		tst.b	objoff_34(a0)
		bpl.s	loc_B5AA
		tst.b	objoff_38(a0)
		beq.s	loc_B594
		subq.b	#1,objoff_38(a0)
		bne.s	loc_B5AA

loc_B594:
		tst.w	glass_dist(a0)
		beq.s	loc_B5A4
		subq.w	#1,glass_dist(a0)
		subq.w	#1,objoff_36(a0)
		bne.s	loc_B5AA

loc_B5A4:
		bclr	#7,objoff_34(a0)

loc_B5AA:
		move.w	glass_dist(a0),d0
		bra.s	loc_B5EE
; ---------------------------------------------------------------------------

Glass_Type04:
		tst.b	objoff_34(a0)
		bne.s	loc_B5E0
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	subtype(a0),d0							; load object type number
		lsr.w	#4,d0								; read only the first nybble
		tst.b	(a2,d0.w)							; has switch number d0 been pressed?
		beq.s	loc_B5EA							; if not, branch
		move.b	#1,objoff_34(a0)

loc_B5E0:
		tst.w	glass_dist(a0)
		beq.s	loc_B5EA
		subq.w	#2,glass_dist(a0)

loc_B5EA:
		move.w	glass_dist(a0),d0

loc_B5EE:
		move.w	glass_ypos(a0),d2
		sub.w	d0,d2

		; move main object
		move.w	d2,y_pos(a0)

		; move sub object 1
		move.w	d2,sub3_y_pos(a0)

		; move sub object 2
		moveq	#0,d0
		move.b	(Oscillating_Data+$10).w,d0

	if _GLASSBLOCK_YPOS_
		; fix ypos
		subi.w	#$10-2,d0
	else
		subi.w	#$10,d0
	endif

		sub.w	d0,d2
		move.w	d2,sub2_y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_GlassBlock:		subObjMainData Obj_GlassBlock.block012, setBit(render_flags.level)|setBit(render_flags.multi_sprite), 0, 144, 64, 2, $300, 2, 1, Map_Glass
; ---------------------------------------------------------------------------

		include "Objects/Environ/Glass Block/Object Data/Map - Glass Block.asm"
