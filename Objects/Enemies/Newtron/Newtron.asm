; ---------------------------------------------------------------------------
; Object 42 - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
obStatusTron		= objoff_32

; =============== S U B R O U T I N E =======================================

Obj_Newtron:

		; init
		lea	ObjDat_Newtron(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.chkdistance,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Newt(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.action2
		jsr	(MoveSprite2).w
		lea	Ani_Newt(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.chkdistance
		jsr	(Find_SonicTails).w
		bset	#status.npc.x_flip,status(a0)
		tst.w	d0
		bne.s	.Sonicisright
		bclr	#status.npc.x_flip,status(a0)

.Sonicisright
		cmpi.w	#128,d2								; is Sonic within $80 pixels of the newtron?
		bhs.s	.outofrange							; if not, branch
		move.l	#.type00,objoff_34(a0)						; goto .type00 next
		move.b	#1,anim(a0)
		tst.b	subtype(a0)							; check object type
		beq.s	.istype00							; if type is 00, branch
		ori.w	#palette_line_1,art_tile(a0)
		move.l	#.type01,objoff_34(a0)						; goto .type01 next
		move.b	#4,anim(a0)							; use different	animation

.outofrange
.istype00
		rts
; ---------------------------------------------------------------------------

.type00
		cmpi.b	#4,mapping_frame(a0)						; has "appearing" animation finished?
		bhs.s	.fall								; is yes, branch
		jsr	(Find_SonicTails).w
		bset	#status.npc.x_flip,status(a0)
		tst.w	d0
		bne.s	.Sonicisright
		bclr	#status.npc.x_flip,status(a0)

.Sonicisright2
		rts
; ---------------------------------------------------------------------------

.fall
		cmpi.b	#1,mapping_frame(a0)
		bne.s	.loc_DE42
		move.b	#$C|collision_flags.npc.touch,collision_flags(a0)

.loc_DE42
		jsr	(MoveSprite).w
		jsr	(ObjCheckFloorDist).w
		tst.w	d1								; has newtron hit the floor?
		bpl.s	.keepfalling							; if not, branch
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)							; stop newtron falling
		move.l	#.matchfloor,objoff_34(a0)
		move.b	#2,anim(a0)
		btst	#5,art_tile(a0)							; palette_line_1
		beq.s	.notgreen
		addq.b	#1,anim(a0)

.notgreen
		move.b	#$D|collision_flags.npc.touch,collision_flags(a0)
		move.w	#$200,x_vel(a0)							; move newtron horizontally
		btst	#status.npc.x_flip,status(a0)
		bne.s	.keepfalling
		neg.w	x_vel(a0)

.keepfalling
		rts
; ---------------------------------------------------------------------------

.matchfloor
		jsr	(MoveSprite2).w
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#-8,d1
		blt.s	.nextroutine
		cmpi.w	#12,d1
		bge.s	.nextroutine
		add.w	d1,y_pos(a0)							; match newtron's position with floor
		rts
; ---------------------------------------------------------------------------

.nextroutine
		move.l	#.action2,address(a0)						; goto .speed next
		rts

; =============== S U B R O U T I N E =======================================

.type01
		cmpi.b	#1,mapping_frame(a0)
		bne.s	.firemissile
		move.b	#$C|collision_flags.npc.touch,collision_flags(a0)

.firemissile
		cmpi.b	#2,mapping_frame(a0)
		bne.s	.fail
		tst.b	obStatusTron(a0)
		bne.s	.fail
		st	obStatusTron(a0)

		; set delete
		move.l	#.delete,objoff_34(a0)

		; create missile
		jsr	(Create_New_Sprite3).w
		bne.s	.fail
		move.l	#Obj_Missile,address(a1)					; load missile object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		subq.w	#8,y_pos(a1)
		move.w	#$200,x_vel(a1)
		moveq	#20,d0
		btst	#status.npc.x_flip,status(a0)
		bne.s	.noflip
		neg.w	d0
		neg.w	x_vel(a1)

.noflip
		add.w	d0,x_pos(a1)
		move.b	status(a0),status(a1)
		move.w	a0,parent3(a1)
		st	subtype(a1)

.fail
		rts
; ---------------------------------------------------------------------------

.delete
		tst.b	routine(a0)
		beq.s	.fail
		jmp	(Go_Delete_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Newtron:		subObjData Map_Newt, $50C, 0, 0, 32, 40, 4, 0, 0
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Newtron/Object Data/Anim - Newtron.asm"
		include "Objects/Enemies/Newtron/Object Data/Map - Newtron.asm"
