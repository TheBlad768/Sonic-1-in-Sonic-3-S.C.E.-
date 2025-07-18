; ---------------------------------------------------------------------------
; Object 61 - blocks (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
lblk_origX			= objoff_34	; original x-axis position
lblk_origY			= objoff_30	; original y-axis position
lblk_time			= objoff_36	; time delay for block movement
lblk_untouched			= objoff_38	; flag block as untouched
; ---------------------------------------------------------------------------

LBlk_Var:	; width/2, height/2
		dc.b 32/2, 32/2
		dc.b 24/2, 64/2
		dc.b 32/2, 32/2
		dc.b 32/2, 32/2

; =============== S U B R O U T I N E =======================================

Obj_LabyrinthBlock:

		; init
		movem.l	ObjDat_LabyrinthBlock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; set
		move.b	subtype(a0),d0							; get block type
		lsr.w	#3,d0								; read only the 1st digit
		andi.w	#$E,d0
		move.w	LBlk_Var(pc,d0.w),d1
		move.w	d1,height_pixels(a0)						; set height and width
		move.w	d1,y_radius(a0)							; set y_radius and x_radius
		lsr.b	d0								; division by 2
		move.b	d0,mapping_frame(a0)
		move.w	x_pos(a0),lblk_origX(a0)
		move.w	y_pos(a0),lblk_origY(a0)
		moveq	#$F,d0								; read only the 2nd digit
		and.b	subtype(a0),d0							; get block type
		beq.s	.action								; branch if 0
		cmpi.b	#7,d0
		beq.s	.action								; branch if 7
		move.b	#1,lblk_untouched(a0)

.action
		move.w	x_pos(a0),-(sp)
		moveq	#$F,d0
		and.b	subtype(a0),d0
		beq.s	.skipt								; if zero, branch
		add.w	d0,d0
		move.w	LabyrinthBlock_TypeIndex-2(pc,d0.w),d0
		jsr	LabyrinthBlock_TypeIndex(pc,d0.w)

.skipt
		move.w	(sp)+,d4
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		jsr	(SolidObjectFull).w
		move.b	d4,objoff_3F(a0)
		bsr.s	sub_12180

.chkdel
		moveq	#-$80,d0							; round down to nearest $80
		and.w	lblk_origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_12180:
		tst.b	lblk_untouched(a0)						; has block been stood on or touched?
		beq.s	.locret_121C0							; if yes, branch
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on it now?
		bne.s	.loc_1219A							; if yes, branch
		tst.b	objoff_3E(a0)
		beq.s	.locret_121C0
		subq.b	#4,objoff_3E(a0)
		bra.s	.loc_121A6
; ---------------------------------------------------------------------------

.loc_1219A
		cmpi.b	#$40,objoff_3E(a0)
		beq.s	.locret_121C0
		addq.b	#4,objoff_3E(a0)

.loc_121A6
		move.b	objoff_3E(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	lblk_origY(a0),d0
		move.w	d0,y_pos(a0)

.locret_121C0
		rts

; =============== S U B R O U T I N E =======================================

LabyrinthBlock_TypeIndex: offsetTable
		offsetTableEntry.w .type01						; 1
		offsetTableEntry.w .type02						; 2
		offsetTableEntry.w .type03						; 3
		offsetTableEntry.w .type04						; 4
		offsetTableEntry.w .type05						; 5
		offsetTableEntry.w .type06						; 6
		offsetTableEntry.w .type07						; 7
; ---------------------------------------------------------------------------

.type01
.type03
		tst.w	lblk_time(a0)							; does time remain?
		bne.s	.wait01								; if yes, branch
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		beq.s	.donothing01							; if not, branch
		move.w	#30,lblk_time(a0)						; wait for half second

.donothing01
		rts
; ---------------------------------------------------------------------------

.wait01
		subq.w	#1,lblk_time(a0)						; decrement waiting time
		bne.s	.donothing01							; if time remains, branch
		addq.b	#1,subtype(a0)							; goto .type02 or .type04
		clr.b	lblk_untouched(a0)						; flag block as touched
		rts
; ---------------------------------------------------------------------------

.type02
.type06
		moveq	#8,d1
		jsr	(MoveSprite_CustomGravity).w					; make block fall
		jsr	(ObjCheckFloorDist).w
		tst.w	d1								; has block hit the floor?
		bpl.s	.nofloor02							; if not, branch
		addq.w	#1,d1
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)							; stop when it touches the floor
		clr.b	subtype(a0)							; set type to 00 (non-moving type)

.nofloor02
		rts
; ---------------------------------------------------------------------------

.type04
		moveq	#-8,d1
		jsr	(MoveSprite_CustomGravity).w					; make block rise
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1								; has block hit the ceiling?
		bpl.s	.noceiling04							; if not, branch
		sub.w	d1,y_pos(a0)
		clr.w	y_vel(a0)							; stop when it touches the ceiling
		clr.b	subtype(a0)							; set type to 00 (non-moving type)

.noceiling04
		rts
; ---------------------------------------------------------------------------

.type05
		cmpi.b	#1,objoff_3F(a0)						; is Sonic touching the block?
		bne.s	.notouch05							; if not, branch
		addq.b	#1,subtype(a0)							; goto .type06
		clr.b	lblk_untouched(a0)

.notouch05
		rts
; ---------------------------------------------------------------------------

.type07
		move.w	(Water_level).w,d0
		sub.w	y_pos(a0),d0							; is block level with water?
		beq.s	.stop07								; if yes, branch
		bhs.s	.fall07								; branch if block is above water
		cmpi.w	#-2,d0
		bge.s	.loc_1214E
		moveq	#-2,d0

.loc_1214E
		add.w	d0,y_pos(a0)							; make the block rise with water level
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1								; has block hit the ceiling?
		bpl.s	.noceiling07							; if not, branch
		sub.w	d1,y_pos(a0)							; stop block

.noceiling07
		rts
; ---------------------------------------------------------------------------

.fall07
		cmpi.w	#2,d0
		ble.s	.loc_1216A
		moveq	#2,d0

.loc_1216A
		add.w	d0,y_pos(a0)							; make the block sink with water level
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.stop07
		addq.w	#1,d1
		add.w	d1,y_pos(a0)

.stop07
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_LabyrinthBlock:		subObjMainData Obj_LabyrinthBlock.action, setBit(render_flags.level), 0, 0, 0, 3, $3E6, 2, 0, Map_LBlock
; ---------------------------------------------------------------------------

		include "Objects/Environ/Labyrinth Blocks/Object Data/Map - Labyrinth Blocks.asm"
