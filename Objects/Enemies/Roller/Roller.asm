; ---------------------------------------------------------------------------
; Object 43 - Roller enemy (SYZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
roller_timedelay		= objoff_30	; (2 bytes)
roller_flag			= objoff_32	; (1 byte)

; =============== S U B R O U T I N E =======================================

Obj_Roller:

		; init
		lea	ObjDat_Roller(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)							; match roller's position with the floor
		clr.w	y_vel(a0)
		move.l	#.rollchk,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Roll(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.rollchk
		move.w	(Player_1+x_pos).w,d0
		subi.w	#512/2,d0
		blo.s	.skip
		sub.w	x_pos(a0),d0							; check distance between Roller and Sonic
		blo.s	.skip
		move.l	#.chkjump,objoff_34(a0)
		move.b	#2,anim(a0)
		move.w	#$700,x_vel(a0)							; move Roller horizontally
		move.b	#$E|collision_flags.npc.hurt,collision_flags(a0)		; make Roller invincible

.skip
		addq.w	#4,sp								; exit from current object
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.rollnochk
		cmpi.b	#2,anim(a0)
		beq.s	.loc_E0F8
		subq.w	#1,roller_timedelay(a0)
		bpl.s	.return
		move.b	#1,anim(a0)
		move.w	#$700,x_vel(a0)
		move.b	#$E|collision_flags.npc.hurt,collision_flags(a0)

.return
		rts
; ---------------------------------------------------------------------------

.loc_E0F8
		move.l	#.chkjump,objoff_34(a0)
		rts
; ---------------------------------------------------------------------------

.chkjump
		bsr.s	Roll_Stop
		jsr	(MoveSprite2).w
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#-8,d1
		blt.s	.jump
		cmpi.w	#12,d1
		bge.s	.jump
		add.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.jump
		move.l	#.matchfloor,objoff_34(a0)
		bset	#0,roller_flag(a0)
		beq.s	.return2
		move.w	#-$600,y_vel(a0)						; move Roller vertically

.return2
		rts
; ---------------------------------------------------------------------------

.matchfloor
		jsr	(MoveSprite).w
		tst.w	y_vel(a0)
		bmi.s	.return3
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.return3
		add.w	d1,y_pos(a0)							; match Roller's position with the floor
		clr.w	y_vel(a0)
		move.l	#.chkjump,objoff_34(a0)

.return3
		rts

; =============== S U B R O U T I N E =======================================

Roll_Stop:
		tst.b	roller_flag(a0)
		bmi.s	.return
		moveq	#-(96/2),d0
		add.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bhs.s	.return
		clr.b	anim(a0)
		move.b	#$E|collision_flags.npc.touch,collision_flags(a0)
		clr.w	x_vel(a0)
		move.w	#2*60,roller_timedelay(a0)					; set waiting time to 2 seconds
		bset	#7,roller_flag(a0)
		move.l	#Obj_Roller.rollnochk,objoff_34(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Roller:		subObjData Map_Roll, $4F0, 0, 0, 28, 32, 4, 0, 0
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Roller/Object Data/Anim - Roller.asm"
		include "Objects/Enemies/Roller/Object Data/Map - Roller.asm"
