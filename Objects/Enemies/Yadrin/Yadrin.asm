; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
yad_timedelay			= objoff_3C

; =============== S U B R O U T I N E =======================================

Obj_Yadrin:

		; init
		lea	ObjDat_Yadrin(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)							; match object's position with the floor
		clr.w	y_vel(a0)
		bchg	#status.npc.x_flip,status(a0)
		move.l	#.move,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Yad(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.move
		subq.w	#1,yad_timedelay(a0)						; subtract 1 from pause time
		bpl.s	.noflip								; if time remains, branch
		move.l	#.fixtofloor,objoff_34(a0)
		move.w	#-$100,x_vel(a0)						; move object
		move.b	#1,anim(a0)
		bchg	#status.npc.x_flip,status(a0)
		bne.s	.noflip
		neg.w	x_vel(a0)							; change direction

.noflip
		rts
; ---------------------------------------------------------------------------

.fixtofloor
		MoveSpriteXOnly a0
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#-8,d1
		blt.s	.pause
		cmpi.w	#12,d1
		bge.s	.pause
		add.w	d1,y_pos(a0)							; match object's position to the floor
		bsr.s	Yad_ChkWall
		bne.s	.pause
		rts
; ---------------------------------------------------------------------------

.pause
		move.l	#.move,objoff_34(a0)
		move.w	#60-1,yad_timedelay(a0)						; set pause time to 1 second
		clr.w	x_vel(a0)
		clr.b	anim(a0)
		rts

; =============== S U B R O U T I N E =======================================

Yad_ChkWall:
		move.w	(Level_frame_counter).w,d0
		add.w	d7,d0								; d7 - object count (Process_Sprites)
		andi.w	#3,d0
		bne.s	.loc_F836
		move.b	x_radius(a0),d3
		ext.w	d3
		tst.w	x_vel(a0)
		bmi.s	.loc_F82C
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.loc_F836

.loc_F828
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

.loc_F82C
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bmi.s	.loc_F828

.loc_F836
		moveq	#0,d0
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Yadrin:		subObjData Map_Yad, $3BE, 1, 0, 34, 40, 4, 0, $C|collision_flags.npc.special
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Yadrin/Object Data/Anim - Yadrin.asm"
		include "Objects/Enemies/Yadrin/Object Data/Map - Yadrin.asm"
