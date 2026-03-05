; ---------------------------------------------------------------------------
; Object 4C - lava geyser / lavafall producer (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset wait_timer								; pretend we're in the RAM

geysermaker.timer			ds.w 1						; current time remaining (2 bytes)
geysermaker.delay			ds.w 1						; time delay (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_GeyserMaker:

		; init
		lea	ObjDat_GeyserMaker(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.w	#2*60,geysermaker.delay(a0)					; set time delay to 2 seconds
		move.l	#.wait,address(a0)

.wait
		subq.w	#1,geysermaker.timer(a0)					; decrement timer
		bpl.s	.cancel								; if time remains, branch
		move.w	geysermaker.delay(a0),geysermaker.timer(a0)			; reset timer

		; find Sonic
		move.w	(Player_1+y_pos).w,d0
		move.w	y_pos(a0),d1
		cmp.w	d1,d0
		bhs.s	.cancel
		subi.w	#$170,d1
		cmp.w	d1,d0
		blo.s	.cancel
		move.l	#.chktype,address(a0)						; if Sonic is within range, goto GMake_ChkType

.cancel
		bra.s	.range
; ---------------------------------------------------------------------------

.chktype
		move.l	#.checkanim,address(a0)
		tst.b	subtype(a0)							; is object type 00 (geyser) ?
		beq.s	.draw								; if yes, branch
		move.l	#.makelava,address(a0)
		bra.s	.range
; ---------------------------------------------------------------------------

.checkanim
		tst.b	routine(a0)							; changed by Animate_Sprite
		beq.s	.draw
		clr.b	routine(a0)

.makelava
		move.l	#.checkdelete,address(a0)
		lea	Child6_LavaGeyser(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail
		move.b	subtype(a0),subtype(a1)

.fail
		move.b	#1,anim(a0)							; bubble2 anim
		tst.b	subtype(a0)							; is object type 0 (geyser) ?
		beq.s	.isgeyser							; if yes, branch
		move.b	#4,anim(a0)							; null frame
		bra.s	.draw
; ---------------------------------------------------------------------------

.isgeyser
		movea.w	parent3(a0),a1							; a1=parent object (pushable blocks)
		bset	#status.npc.y_flip,status(a1)					; set geyser flag
		move.w	#-$580,y_vel(a1)

.checkdelete
		tst.b	routine(a0)							; changed by Animate_Sprite
		beq.s	.draw
		clr.b	routine(a0)
		move.l	#.delete,address(a0)

.range
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w
; ---------------------------------------------------------------------------

.draw
		lea	Ani_Geyser(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDelete).w
; ---------------------------------------------------------------------------

.delete
		clr.b	anim(a0)							; bubble1 anim
		move.l	#.wait,address(a0)
		tst.b	subtype(a0)
		bne.s	.range
		jmp	(Sprite_CheckDelete.offscreen).w				; Delete_Sprite_If_Not_In_RangeCheck.offscreen

; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

lavageyser.origY			ds.w 1						; original y-axis position (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Geyser_Speeds:	dc.w -$500, 0
; ---------------------------------------------------------------------------

Obj_LavaGeyser:

		; get y velocity
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	Geyser_Speeds(pc,d0.w),y_vel(a0)

		; init
		lea	ObjDat_LavaGeyser(pc),a1
		jsr	(SetUp_ObjAttributes).w
;		sfx	sfx_Burning							; play flame sound
		move.w	y_pos(a0),lavageyser.origY(a0)
		move.l	#.action,address(a0)

		; check
		move.b	#5,anim(a0)							; bubble4 anim
		tst.b	subtype(a0)
		beq.s	.isgeyser
		move.b	#2,anim(a0)							; end anim
		subi.w	#$250,y_pos(a0)

.isgeyser
		lea	Child6_LavaGeyser_Extra(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail
		move.b	subtype(a0),subtype(a1)
		moveq	#96,d0
		add.w	d0,y_pos(a1)
		add.w	lavageyser.origY(a0),d0
		move.w	d0,lavageyser.origY(a1)

		; check
		move.b	#5,anim(a1)							; bubble4 anim
		tst.b	subtype(a0)
		beq.s	.fail
		move.b	#2,anim(a1)							; end anim

.fail
		tst.b	subtype(a0)
		beq.s	.action
		lea	Child6_LavaGeyser_Extra2(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail2
		move.b	subtype(a0),subtype(a1)
		bset	#flip_bit_y,art_tile(a1)					; flipy
		addi.w	#$100,y_pos(a1)
		move.w	lavageyser.origY(a0),lavageyser.origY(a1)
		move.w	parent3(a0),parent3(a1)

		; check
		move.b	#5,anim(a1)							; bubble4 anim
		tst.b	subtype(a0)
		beq.s	.fail2
		move.b	#2,anim(a1)							; end anim

.fail2
		clr.b	subtype(a0)

.action
		moveq	#7,d0								; read only the 1st digit
		and.b	subtype(a0),d0							; get object type
		add.w	d0,d0
		jsr	.index(pc,d0.w)

		; draw
		MoveSprite2YOnly
		lea	Ani_Geyser(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

.index
		bra.s	.type00								; 0
; ---------------------------------------------------------------------------

		; type01								; 1
		addi.w	#$18,y_vel(a0)							; increase object's falling speed
		move.w	lavageyser.origY(a0),d0
		cmp.w	y_pos(a0),d0
		bhs.s	.return
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	#1,anim(a1)							; bubble2 anim
		jmp	(Go_Delete_Object).w
; ---------------------------------------------------------------------------

.type00
		addi.w	#$18,y_vel(a0)							; increase object's falling speed
		move.w	lavageyser.origY(a0),d0
		cmp.w	y_pos(a0),d0
		bhs.s	.return
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	#3,anim(a1)							; bubble3 anim
		jmp	(Go_Delete_Object).w
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ) (Extra2)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_LavaGeyser_Extra2:

		; init
		lea	ObjDat3_LavaGeyser2(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#Obj_LavaGeyser.action,address(a0)
		bra.s	Obj_LavaGeyser.action

; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ) (Extra)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_LavaGeyser_Extra:

		; init
		lea	ObjDat3_LavaGeyser(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.l	#.main,address(a0)

.main
		movea.w	parent3(a0),a1							; a1=parent object
		moveq	#96,d0
		add.w	y_pos(a1),d0
		move.w	d0,y_pos(a0)
		sub.w	lavageyser.origY(a0),d0
		neg.w	d0

		; set
		moveq	#8,d1								; mapping_frame
		cmpi.w	#64,d0
		bge.s	.check
		moveq	#$B,d1								; mapping_frame

.check
		cmpi.w	#128,d0
		ble.s	.anim
		moveq	#$E,d1								; mapping_frame

.anim

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.draw								; if time remains, branch
		addq.b	#7+1,anim_frame_timer(a0)					; reset timer to 7 frames

		; next
		bchg	#0,anim_frame(a0)						; chg 0 or 1
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch
		sfx	sfx_LavaFall							; play lava fall sound

.draw
		move.b	anim_frame(a0),d0
		add.b	d1,d0
		move.b	d0,mapping_frame(a0)
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_GeyserMaker:		subObjData Map_Geyser, $36D, 3, TRUE, 112, 112, 1, 0, 0
ObjDat_LavaGeyser:		subObjData Map_Geyser, $36D, 3, FALSE, 64, 64, 1, 0, 0
ObjDat3_LavaGeyser:		subObjData FALSE, FALSE, 0, FALSE, 256, 64, 1, 0, $13|collision_flags.npc.hurt
ObjDat3_LavaGeyser2:		subObjData FALSE, FALSE, 0, FALSE, 64, 64, 0, 0, 0

Child6_LavaGeyser:
		dc.w 1-1
		dc.l Obj_LavaGeyser
Child6_LavaGeyser_Extra:
		dc.w 1-1
		dc.l Obj_LavaGeyser_Extra
Child6_LavaGeyser_Extra2:
		dc.w 1-1
		dc.l Obj_LavaGeyser_Extra2
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Lava Geyser/Object Data/Anim - Lava Geyser.asm"
		include "Objects/Environ/Lava Geyser/Object Data/Map - Lava Geyser.asm"
