; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

yadrin.timer				ds.w 1						; time between direction changes (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Yadrin:

		; init
		lea	ObjDat_Yadrin(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		move.l	#.checkfall,code_addr(a0)

.checkfall
		MoveSpriteYOnly
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,y_pos(a0)							; match object's position with the floor
		clr.w	y_vel(a0)
		bchg	#status.npc.x_flip,status(a0)
		move.l	#.move,wait_addr(a0)
		move.l	#.action,code_addr(a0)

.action

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)
		lea	Ani_Yadrin(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

.floornotfound
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w

; =============== S U B R O U T I N E =======================================

.move
		subq.w	#1,yadrin.timer(a0)						; subtract 1 from pause time
		bpl.s	.noflip								; if time remains, branch
		move.l	#.fixtofloor,wait_addr(a0)
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
		bsr.s	Yadrin_CheckWall
		bmi.s	.pause								; if Yadrin touch the wall, branch
		rts
; ---------------------------------------------------------------------------

.pause
		move.l	#.move,wait_addr(a0)
		move.w	#60-1,yadrin.timer(a0)						; set pause time to 1 second
		clr.w	x_vel(a0)
		clr.b	anim(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to check the wall for a Yadrin
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Yadrin_CheckWall:
		move.w	(Level_frame_counter).w,d1
		add.w	d7,d1								; d7 - object count (Process_Objects)
		andi.w	#3,d1								; check wall every 4th frame
		beq.s	.wall								; if zero, branch

		; exit
		moveq	#0,d1								; Yadrin didn't touch the wall
		rts
; ---------------------------------------------------------------------------

.wall
		move.b	x_radius(a0),d3
		ext.w	d3
		lea	(ObjCheckRightWallDist).w,a1
		tst.w	x_vel(a0)							; check x velocity
		bpl.s	.check								; right move
		neg.w	d3
		lea	(ObjCheckLeftWallDist).w,a1

.check
		jsr	(a1)
		tst.w	d1								; check if Yadrin touch the wall
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Yadrin:		subObjData Map_Yadrin, $3BE, 1, FALSE, 34, 40, 4, 0, collision_type.npc.caterkiller, 32, 40
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Enemies/Yadrin/Object Data/Anim - Yadrin.asm"
		include "Objects/Enemies/Yadrin/Object Data/Map - Yadrin.asm"
