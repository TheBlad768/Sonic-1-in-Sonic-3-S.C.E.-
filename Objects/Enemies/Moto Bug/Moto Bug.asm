; ---------------------------------------------------------------------------
; Object 40 - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
moto_time			= objoff_2E
moto_smokedelay			= objoff_39

; =============== S U B R O U T I N E =======================================

Obj_MotoBug:

		; init
		lea	ObjDat_MotoBug(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#bytes_to_word(28/2,40/2),y_radius(a0)				; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.notonfloor
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		bchg	#status.npc.x_flip,status(a0)
		move.l	#.move,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		jsr	(Obj_Wait).w
		lea	Ani_Moto(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.notonfloor
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.move
		move.l	#.findfloor,objoff_34(a0)
		move.b	#1,anim(a0)
		move.w	#-$100,x_vel(a0)						; move object to the left
		bchg	#status.npc.x_flip,status(a0)
		bne.s	.wait
		neg.w	x_vel(a0)							; change direction

.wait
		rts
; ---------------------------------------------------------------------------

.findfloor
		MoveSpriteXOnly a0
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#-8,d1
		blt.s	.pause
		cmpi.w	#12,d1
		bge.s	.pause
		add.w	d1,y_pos(a0)							; match object's position with the floor

		; wait
		subq.b	#1,moto_smokedelay(a0)
		bpl.s	.nosmoke
		move.b	#$F,moto_smokedelay(a0)

		; create smoke
		lea	Child6_MotoBug_Smoke(pc),a2
		jsr	(CreateChild6_Simple).w						; load exhaust smoke object
		bne.s	.nosmoke
		move.b	status(a0),status(a1)
		move.b	#2,anim(a1)

.nosmoke
		rts
; ---------------------------------------------------------------------------

.pause
		move.w	#60-1,moto_time(a0)						; set pause time to 1 second
		move.l	#.move,objoff_34(a0)
		clr.w	x_vel(a0)							; stop the object moving
		clr.b	anim(a0)
		rts

; ---------------------------------------------------------------------------
; Object 40 - Moto Bug smoke
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MotoBug_Smoke:

		; init
		lea	ObjDat3_MotoBug_Smoke(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		clr.b	routine(a0)
		move.l	#.check,address(a0)

.check
		lea	Ani_Moto(pc),a1
		jsr	(Animate_Sprite).w
		tst.b	routine(a0)
		bne.s	.delete
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_MotoBug:			subObjData Map_Moto, $561, 0, 0, 40, 40, 4, 0, $C|collision_flags.npc.touch
ObjDat3_MotoBug_Smoke:		subObjData FALSE, FALSE, 0, 0, 8, 8, 4, 0, 0

Child6_MotoBug_Smoke:
		dc.w 1-1
		dc.l Obj_MotoBug_Smoke
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Moto Bug/Object Data/Anim - Moto Bug.asm"
		include "Objects/Enemies/Moto Bug/Object Data/Map - Moto Bug.asm"
