; ---------------------------------------------------------------------------
; Object 35 - fireball that sits on the floor (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
gfire_origX			= objoff_2E
gfire_origY			= objoff_30

; =============== S U B R O U T I N E =======================================

Obj_GrassFire:

		; init
		lea	ObjDat_GrassFire(pc),a1
		jsr	(SetUp_ObjAttributes).w
		sfx	sfx_Burning
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.w	x_pos(a0),gfire_origX(a0)
		move.l	#.main,address(a0)

.main
		movea.w	parent3(a0),a2							; a2=parent object (Large Grassy Platforms)
		movea.l	objoff_3C(a0),a1						; LGrass data pointer
		move.w	x_pos(a0),d1
		sub.w	gfire_origX(a0),d1
		addi.w	#12,d1
		move.w	d1,d0
		lsr.w	d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	gfire_origY(a0),d0
		move.w	d0,d3
		add.w	objoff_32(a2),d0
		move.w	d0,y_pos(a0)
		cmpi.w	#$84,d1
		bhs.s	Obj_GrassFire_Fire.anim
		addq.w	#1,x_pos(a0)
		cmpi.w	#$80,d1
		bhs.s	Obj_GrassFire_Fire.anim
		move.w	x_pos(a0),d0
		addq.w	#8,d0
		andi.w	#$F,d0
		bne.s	Obj_GrassFire_Fire.anim

		; create
		lea	Child6_GrassFire_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	Obj_GrassFire_Fire.anim
		move.b	shield_reaction(a0),shield_reaction(a1)
		move.w	parent3(a0),parent3(a1)						; copy parent object
		move.w	d3,gfire_origY(a1)
		bra.s	Obj_GrassFire_Fire.anim

; ---------------------------------------------------------------------------
; Additional grass fire
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GrassFire_Fire:

		; init
		lea	ObjDat3_GrassFire_Fire(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.main,address(a0)

.main
		movea.w	parent3(a0),a1							; a1=parent object (Large Grassy Platforms)
		move.w	gfire_origY(a0),d0
		add.w	objoff_32(a1),d0
		move.w	d0,y_pos(a0)

.anim

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.draw								; if time remains, branch
		addq.b	#7+1,anim_frame_timer(a0)					; reset timer to 7 frames

		; next frame
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#4,mapping_frame(a0)
		bne.s	.draw
		clr.b	mapping_frame(a0)

.draw
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_GrassFire:		subObjData Map_Fire, $298, 0, 0, 16, 16, 1, 0, $B|collision_flags.npc.hurt
ObjDat3_GrassFire_Fire:		subObjData FALSE, FALSE, 0, 0, 16, 16, 1, 0, $B|collision_flags.npc.hurt

Child6_GrassFire_Fire:
		dc.w 1-1
		dc.l Obj_GrassFire_Fire
