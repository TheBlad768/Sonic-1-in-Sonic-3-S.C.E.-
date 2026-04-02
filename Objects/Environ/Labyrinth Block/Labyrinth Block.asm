; ---------------------------------------------------------------------------
; Object 61 - blocks (LZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

labyrinthblock.origX			ds.w 1						; original x-axis position (2 bytes)
labyrinthblock.origY			ds.w 1						; original y-axis position (2 bytes)
labyrinthblock.timer			ds.w 1						; time delay for block movement (2 bytes)
labyrinthblock.touch_flag		ds.b 1						; flag block as untouched (1 byte)
labyrinthblock.bend			ds.b 1						; block bend (1 byte)
labyrinthblock.solid			ds.b 1						; solid status (1 byte)

	dsreset										; stop pretending and reset the program counter

; ---------------------------------------------------------------------------

LabyrinthBlock_Var:

		; width/2, height/2
		dc.b 32/2, 32/2
		dc.b 24/2, 64/2
		dc.b 32/2, 32/2
		dc.b 32/2, 32/2

; =============== S U B R O U T I N E =======================================

Obj_LabyrinthBlock:

		; init
		movem.l	ObjDat_LabyrinthBlock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object

		; set
		move.b	subtype(a0),d0							; get block type
		lsr.w	#3,d0								; read only the 1st digit
		andi.w	#$E,d0
		move.w	LabyrinthBlock_Var(pc,d0.w),d1
		move.w	d1,height_pixels(a0)						; set height and width
		move.w	d1,y_radius(a0)							; set y_radius and x_radius
		lsr.b	d0								; division by 2
		move.b	d0,mapping_frame(a0)
		move.w	x_pos(a0),labyrinthblock.origX(a0)
		move.w	y_pos(a0),labyrinthblock.origY(a0)

		; check
		moveq	#$F,d0								; read only the 2nd digit
		and.b	subtype(a0),d0							; get block type
		beq.s	.action								; branch if 0
		cmpi.b	#7,d0
		beq.s	.action								; branch if 7
		st	labyrinthblock.touch_flag(a0)

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
		move.b	d4,labyrinthblock.solid(a0)					; save solid status
		bsr.s	LabyrinthBlock_Nudge

.chkdel
		moveq	#-$80,d0							; round down to nearest $80
		and.w	labyrinthblock.origX(a0),d0					; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

LabyrinthBlock_Nudge:

		; check standing
		tst.b	labyrinthblock.touch_flag(a0)					; has block been stood on or touched?
		beq.s	.return								; if yes, branch
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on it now?
		bne.s	.down								; if yes, branch

		; check
		tst.b	labyrinthblock.bend(a0)
		beq.s	.return
		subq.b	#4,labyrinthblock.bend(a0)					; block up
		bra.s	.bend
; ---------------------------------------------------------------------------

.down
		cmpi.b	#$40,labyrinthblock.bend(a0)
		beq.s	.return
		addq.b	#4,labyrinthblock.bend(a0)					; block down

.bend
		move.b	labyrinthblock.bend(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	labyrinthblock.origY(a0),d0
		move.w	d0,y_pos(a0)

.return
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
		tst.w	labyrinthblock.timer(a0)					; does time remain?
		bne.s	.wait01								; if yes, branch
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		beq.s	.donothing01							; if not, branch
		move.w	#30,labyrinthblock.timer(a0)					; wait for half second

.donothing01
		rts
; ---------------------------------------------------------------------------

.wait01
		subq.w	#1,labyrinthblock.timer(a0)					; decrement waiting time
		bne.s	.donothing01							; if time remains, branch
		addq.b	#1,subtype(a0)							; goto .type02 or .type04
		clr.b	labyrinthblock.touch_flag(a0)					; flag block as touched
		rts
; ---------------------------------------------------------------------------

.type02
.type06
		MoveSpriteYOnly , 8							; make block fall
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
		MoveSpriteYOnly , -8							; make block rise
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
		cmpi.b	#1,labyrinthblock.solid(a0)					; is Sonic touching the block?
		bne.s	.notouch05							; if not, branch
		addq.b	#1,subtype(a0)							; goto .type06
		clr.b	labyrinthblock.touch_flag(a0)

.notouch05
		rts
; ---------------------------------------------------------------------------

.type07
		move.w	(Water_level).w,d0
		sub.w	y_pos(a0),d0							; is block level with water?
		beq.s	.stop07								; if yes, branch
		bhs.s	.fall07								; branch if block is above water
		cmpi.w	#-2,d0
		bge.s	.checkceiling
		moveq	#-2,d0

.checkceiling
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
		ble.s	.checkfloor
		moveq	#2,d0

.checkfloor
		add.w	d0,y_pos(a0)							; make the block sink with water level
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.stop07
		addq.w	#1,d1
		add.w	d1,y_pos(a0)

.stop07
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_LabyrinthBlock:		subObjMainData Obj_LabyrinthBlock.action, setBit(render_flags.level), 0, 0, 0, 3, $3E6, 2, FALSE, Map_LabyrinthBlock
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Labyrinth Block/Object Data/Map - Labyrinth Block.asm"
