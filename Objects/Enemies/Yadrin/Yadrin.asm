; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

; dynamic object variables
yad_timedelay			= objoff_3C

; =============== S U B R O U T I N E =======================================

Obj_Yadrin:

		; init
		lea	ObjDat_Yadrin(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)							; match object's position with the floor
		clr.w	y_vel(a0)
		bchg	#status.npc.x_flip,status(a0)
		move.l	#.move,jump_ptr(a0)
		move.l	#.action,address(a0)

.action

		; jump
		movea.l	jump_ptr(a0),a1
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
		move.l	#.fixtofloor,jump_ptr(a0)
		move.w	#-$100,x_vel(a0)						; move object
		move.b	#1,anim(a0)
		bchg	#status.npc.x_flip,status(a0)
		bne.s	.noflip
		neg.w	x_vel(a0)							; change direction

.noflip
		rts
; ---------------------------------------------------------------------------

.fixtofloor
		MoveSpriteXOnly
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#-8,d1
		blt.s	.pause
		cmpi.w	#12,d1
		bge.s	.pause
		add.w	d1,y_pos(a0)							; match object's position to the floor
		bsr.s	Yad_CheckWall
		bne.s	.pause
		rts
; ---------------------------------------------------------------------------

.pause
		move.l	#.move,jump_ptr(a0)
		move.w	#60-1,yad_timedelay(a0)						; set pause time to 1 second
		clr.w	x_vel(a0)
		clr.b	anim(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to check the wall for a Yadrin
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Yad_CheckWall:
		move.w	(Level_frame_counter).w,d0
		add.w	d7,d0								; d7 - object count (Process_Sprites)
		andi.w	#3,d0
		bne.s	.nottouch

		; check wall
		move.b	x_radius(a0),d3
		ext.w	d3
		tst.w	x_vel(a0)							; check x velocity
		bmi.s	.left								; left move
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.nottouch

.settouch
		moveq	#1,d0								; Yadrin has touched the wall
		rts
; ---------------------------------------------------------------------------

.left
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bmi.s	.settouch

.nottouch
		moveq	#0,d0								; Yadrin didn't touch the wall
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Yadrin:		subObjData Map_Yad, $3BE, 1, FALSE, 34, 40, 4, 0, $C|collision_flags.npc.special
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Enemies/Yadrin/Object Data/Anim - Yadrin.asm"
		include "Objects/Enemies/Yadrin/Object Data/Map - Yadrin.asm"
