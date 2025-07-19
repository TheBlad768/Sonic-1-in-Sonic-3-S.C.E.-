; ---------------------------------------------------------------------------
; Object 4F - Splats enemy from beta version (MZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Splats:

		; init
		lea	ObjDat_Splats(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.checkfall,address(a0)

.checkfall
		MoveSpriteYOnly a0
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#.floor,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.floor
		jsr	(MoveSprite).w
		move.b	#1,mapping_frame(a0)						; set jump frame
		tst.w	y_vel(a0)
		bmi.s	.wall
		clr.b	mapping_frame(a0)						; set normal frame
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.wall
		add.w	d1,y_pos(a0)

		; check lava
		move.w	(a1),d0								; get id of the 16x16 block
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0							; Splats has touched the lava?
		bhs.s	.destroy							; if yes, branch

		; play sfx
		sfx	sfx_SSItem							; play "jump" sfx

		; check Sonic
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#-$400,y_vel(a0)
		move.w	#-$100,d0
		jmp	(Change_VelocityWithFlipX).w
; ---------------------------------------------------------------------------

.wall
		bsr.s	Splats_CheckWall
		beq.s	.return
		neg.w	x_vel(a0)
		bchg	#render_flags.x_flip,render_flags(a0)

.return
		rts
; ---------------------------------------------------------------------------

.destroy
		jmp	(Sprite_CheckDelete.offscreen).w

; =============== S U B R O U T I N E =======================================

Splats_CheckWall:
		move.b	(V_int_run_count+3).w,d0
		add.b	d7,d0								; d7 - object count (Process_Sprites)
		andi.b	#3,d0
		bne.s	.nottouch

		; check wall
		move.b	x_radius(a0),d3
		ext.w	d3
		tst.w	x_vel(a0)
		bmi.s	.left
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.nottouch

.settouch
		moveq	#1,d0								; Splats has touched the wall
		rts
; ---------------------------------------------------------------------------

.left
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bmi.s	.settouch

.nottouch
		moveq	#0,d0								; Splats didn't touch the wall
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Splats:		subObjData Map_Splats, $400, 0, 0, 40, 24, 4, 0, 2|collision_flags.npc.touch
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Splats/Object Data/Map - Splats.asm"
