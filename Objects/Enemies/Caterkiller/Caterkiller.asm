; ---------------------------------------------------------------------------
; Object 78 - Caterkiller enemy (MZ, SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
cat_count:			= objoff_2E	; byte
cat_timer:			= objoff_2F	; byte
cat_flag:			= objoff_30	; byte
cat_flag2:			= objoff_31	; byte ; $00-$0F bytes

; =============== S U B R O U T I N E =======================================

Obj_Caterkiller:

		; init
		lea	ObjDat_Caterkiller(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.w	#bytes_to_word(14/2,16/2),y_radius(a0)				; set y_radius and x_radius

		andi.b	#( \
			setBit(status.npc.x_flip) | \
			setBit(status.npc.y_flip) \
		),render_flags(a0)

		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.b	render_flags(a0),status(a0)
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		move.b	#7,cat_timer(a0)
		move.l	#.head,address(a0)

		; create tail
		lea	Child8_Caterkiller_FragBody(pc),a2
		moveq	#2,d2								; set subtype
		jsr	(CreateChild8_TreeListRepeated2).w
		bne.s	.fail

.head
		btst	#status.npc.touch,status(a0)
		bne.w	Caterkiller_FragHead

		; jump
		lea	.wait(pc),a1
		tst.b	routine(a0)
		beq.s	.jmp
		lea	.wait2(pc),a1

.jmp
		jsr	(a1)

		; anim
		move.b	cat_flag(a0),d1
		bpl.s	.display
		lea	Ani_Cat(pc),a1
		moveq	#$7F,d0
		and.b	angle(a0),d0
		addq.b	#4,angle(a0)
		move.b	(a1,d0.w),d0
		bpl.s	.animate
		bclr	#7,cat_flag(a0)
		bra.s	.display
; ---------------------------------------------------------------------------

.animate
		andi.b	#$10,d1
		add.b	d1,d0
		move.b	d0,mapping_frame(a0)

.display
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.fail
		jmp	(Sprite_CheckDelete.offscreen).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.wait
		subq.b	#1,cat_timer(a0)
		bmi.s	.move
		rts
; ---------------------------------------------------------------------------

.move
		addq.b	#2,routine(a0)
		move.b	#$10,cat_timer(a0)
		move.w	#-$C0,x_vel(a0)
		move.w	#$40,ground_vel(a0)
		bchg	#4,cat_flag(a0)
		bne.s	.mset
		clr.w	x_vel(a0)
		neg.w	ground_vel(a0)

.mset
		bset	#7,cat_flag(a0)

.wait2
		subq.b	#1,cat_timer(a0)
		bmi.s	.loc_16B5E
		tst.w	x_vel(a0)
		beq.s	.notmoving
		move.l	x_pos(a0),d2
		move.l	d2,d3
		move.w	x_vel(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		neg.w	d0

.notflipx
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,x_pos(a0)
		swap	d3
		cmp.w	x_pos(a0),d3
		beq.s	.notmoving
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#-8,d1
		blt.s	.loc_16B70
		cmpi.w	#12,d1
		bge.s	.loc_16B70
		add.w	d1,y_pos(a0)
		moveq	#0,d0
		move.b	cat_count(a0),d0
		addq.b	#1,cat_count(a0)
		andi.b	#$F,cat_count(a0)
		move.b	d1,cat_flag2(a0,d0.w)

.notmoving
		rts
; ---------------------------------------------------------------------------

.loc_16B5E
		clr.b	routine(a0)
		move.b	#7,cat_timer(a0)
		clr.w	x_vel(a0)
		clr.w	ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

.loc_16B70
		moveq	#0,d0
		move.b	cat_count(a0),d0
		move.b	#$80,cat_flag2(a0,d0.w)
		neg.w	x_pos+2(a0)
		beq.s	.loc_1730A
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_1730A
		subq.w	#1,x_pos(a0)
		addq.b	#1,cat_count(a0)
		moveq	#0,d0
		move.b	cat_count(a0),d0
		clr.b	cat_flag2(a0,d0.w)

.loc_1730A
		bchg	#status.npc.x_flip,status(a0)
		move.b	status(a0),render_flags(a0)
		addq.b	#1,cat_count(a0)
		andi.b	#$F,cat_count(a0)
		rts

; ---------------------------------------------------------------------------
; Body segments
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Caterkiller_BodySegments:

		; calc count and xpos
		moveq	#0,d0
		movea.w	objoff_44(a0),a1						; head address
		move.w	x_pos(a1),d2
		move.b	subtype(a0),d0
		move.w	d0,d1
		add.b	d0,d0
		move.b	d0,cat_count(a0)
		add.w	d1,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		btst	#status.npc.x_flip,status(a1)
		beq.s	.notflipx
		neg.w	d1

.notflipx
		add.w	d1,d2
		move.w	d2,x_pos(a0)

		; init
		lea	ObjDat3_Caterkiller_BodySeg(pc),a1
		jsr	(SetUp_ObjAttributes3).w

		; fix flip
		movea.w	objoff_44(a0),a1						; head address
		move.b	status(a1),status(a0)
		move.b	status(a1),render_flags(a0)
		move.w	#bytes_to_word(14/2,16/2),y_radius(a0)				; set y_radius and x_radius
		move.l	#Cat_BodySeg1,address(a0)
		cmpi.b	#4,subtype(a0)
		bne.s	Cat_BodySeg1
		move.l	#Cat_BodySeg2,address(a0)

; =============== S U B R O U T I N E =======================================

Cat_BodySeg2:
		movea.w	parent3(a0),a1							; body address
		move.b	cat_flag(a1),cat_flag(a0)
		bpl.s	Cat_BodySeg1
		lea	Ani_Cat(pc),a1
		moveq	#$7F,d0
		and.b	angle(a0),d0
		addq.b	#4,angle(a0)
		tst.b	4(a1,d0.w)
		bpl.s	.anibody
		addq.b	#4,angle(a0)

.anibody
		move.b	(a1,d0.w),d0
		addq.b	#8,d0
		move.b	d0,mapping_frame(a0)

; =============== S U B R O U T I N E =======================================

Cat_BodySeg1:
		movea.w	parent3(a0),a1							; body address
		btst	#status.npc.touch,status(a0)
		bne.w	Caterkiller_FragBody
		move.b	cat_flag(a1),cat_flag(a0)
		move.b	routine(a1),routine(a0)
		beq.w	.loc_16C64
		move.w	ground_vel(a1),ground_vel(a0)
		move.w	x_vel(a1),d0
		add.w	ground_vel(a0),d0
		move.w	d0,x_vel(a0)
		move.l	x_pos(a0),d2
		move.l	d2,d3
		move.w	x_vel(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_16C0C
		neg.w	d0

.loc_16C0C
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,x_pos(a0)
		swap	d3
		cmp.w	x_pos(a0),d3
		beq.s	.loc_16C64
		moveq	#0,d0
		move.b	cat_count(a0),d0
		move.b	cat_flag2(a1,d0.w),d1
		cmpi.b	#$80,d1
		bne.s	.loc_16C50
		move.b	d1,cat_flag2(a0,d0.w)
		neg.w	x_pos+2(a0)
		beq.s	.locj_173E4
		btst	#status.npc.x_flip,status(a0)
		beq.s	.locj_173E4
		cmpi.w	#-$C0,x_vel(a0)
		bne.s	.locj_173E4
		subq.w	#1,x_pos(a0)
		addq.b	#1,cat_count(a0)
		moveq	#0,d0
		move.b	cat_count(a0),d0
		clr.b	cat_flag2(a0,d0.w)

.locj_173E4
		bchg	#status.npc.x_flip,status(a0)
		move.b	status(a0),render_flags(a0)
		addq.b	#1,cat_count(a0)
		andi.b	#$F,cat_count(a0)
		bra.s	.loc_16C64
; ---------------------------------------------------------------------------

.loc_16C50
		ext.w	d1
		add.w	d1,y_pos(a0)
		addq.b	#1,cat_count(a0)
		andi.b	#$F,cat_count(a0)
		move.b	d1,cat_flag2(a0,d0.w)

.loc_16C64
		movea.w	objoff_44(a0),a2						; head address
		btst	#status.npc.touch,status(a2)
		bne.s	Caterkiller_FragBody
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

		; head, body1, body2, body3
Cat_FragSpeed:	dc.w -$200, -$180, $180, $200
; ---------------------------------------------------------------------------

Caterkiller_FragBody:									; body
		bset	#status.npc.touch,status(a1)					; set for head

Caterkiller_FragHead:									; head
		moveq	#6,d0
		and.b	subtype(a0),d0
		move.w	Cat_FragSpeed(pc,d0.w),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		neg.w	d0

.notflipx
		move.w	d0,x_vel(a0)
		move.w	#-$400,y_vel(a0)
		andi.b	#$F8,mapping_frame(a0)
		bset	#shield_reaction.all_shields,shield_reaction(a0)		; bounce off all shields
		move.l	#.main,address(a0)

.main
		jsr	(MoveSprite).w
		tst.w	y_vel(a0)
		bmi.s	.draw
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.draw
		add.w	d1,y_pos(a0)
		move.w	#-$400,y_vel(a0)

.draw
		jmp	(Sprite_CheckDeleteTouchXY).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Caterkiller:		subObjData Map_Cat, $552, 1, 0, 32, 16, 4, 0, $B|collision_flags.npc.touch
ObjDat3_Caterkiller_BodySeg:	subObjData FALSE, FALSE, 0, 0, 32, 16, 5, 8, $B|collision_flags.npc.special

Child8_Caterkiller_FragBody:
		dc.w 3-1
		dc.l Obj_Caterkiller_BodySegments
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Caterkiller/Object Data/Anim - Caterkiller.asm"
		include "Objects/Enemies/Caterkiller/Object Data/Map - Caterkiller.asm"
