; ---------------------------------------------------------------------------
; Object 13 - lava ball maker (MZ, SLZ)
; ---------------------------------------------------------------------------

; Dynamic object variables

; =============== S U B R O U T I N E =======================================

		; lava ball production rates
LavaM_Rates:	dc.b 30, 60, 90, 120, 150, 180
; ---------------------------------------------------------------------------

Obj_LavaMaker:

		; set
		move.b	subtype(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	LavaM_Rates(pc,d0.w),d0
		move.b	d0,objoff_2E(a0)						; set time delay for lava balls
		move.b	d0,objoff_30(a0)
		andi.b	#$F,subtype(a0)

		; init
		movem.l	ObjDat_LavaMaker(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

.makelava
		subq.b	#1,objoff_2E(a0)						; subtract 1 from time delay
		bne.s	.draw								; if time still remains, branch
		move.b	objoff_30(a0),objoff_2E(a0)					; reset time delay

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch

		; create lava ball object
		jsr	(Create_New_Sprite3).w
		bne.s	.draw
		move.l	#Obj_LavaBall,address(a1)					; load lava ball object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	subtype(a0),subtype(a1)

.draw
		jmp	(Sprite_OnScreen_Test).w

; ---------------------------------------------------------------------------
; Object 14 - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LBall_Speeds:
		dc.w -$400, -$500, -$600, -$700, -$200
		dc.w $200, -$200, $200, 0
; ---------------------------------------------------------------------------

Obj_LavaBall:

		; init
		movem.l	ObjDat_LavaBall(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	y_pos(a0),objoff_30(a0)

		; check
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; is level Star Light Zone?
		bne.s	.notSLZ								; if not, branch
		move.w	#make_art_tile($434,0,0),art_tile(a0)				; SLZ specific code

.notSLZ
		move.b	#$B|collision_flags.npc.hurt,collision_flags(a0)
		bset	#shield_reaction.fire_shield,shield_reaction(a0)

		; check MZ boss
		tst.b	objoff_3F(a0)							; is lava ball was created by the MZ boss?
		beq.s	.speed								; if not, branch
		move.w	#priority_5,priority(a0)					; set priority

.speed

		; set
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	LBall_Speeds(pc,d0.w),y_vel(a0)					; load object speed (vertical)
		move.w	#bytes_to_word(16/2,32/2),y_radius(a0)				; set y_radius and x_radius
		cmpi.b	#6,subtype(a0)							; is object type below $06?
		blo.s	.sound								; if yes, branch
		move.w	#bytes_to_word(32/2,16/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#2,anim(a0)							; use horizontal animation
		move.w	y_vel(a0),x_vel(a0)						; set horizontal speed
		clr.w	y_vel(a0)							; delete vertical speed

.sound
		sfx	sfx_Fireball							; play lava ball sound

.action
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	LBall_TypeIndex(pc,d0.w),d0
		jsr	LBall_TypeIndex(pc,d0.w)
		jsr	(MoveSprite2).w
		lea	Ani_Fire(pc),a1
		jsr	(Animate_Sprite).w
		tst.b	routine(a0)							; changed by Animate_Sprite
		bne.s	.delete
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

LBall_TypeIndex: offsetTable
		offsetTableEntry.w LBall_Type00						; 0
		offsetTableEntry.w LBall_Type00						; 1
		offsetTableEntry.w LBall_Type00						; 2
		offsetTableEntry.w LBall_Type00						; 3
		offsetTableEntry.w LBall_Type04						; 4
		offsetTableEntry.w LBall_Type05						; 5
		offsetTableEntry.w LBall_Type06						; 6
		offsetTableEntry.w LBall_Type07						; 7
		offsetTableEntry.w LBall_Type08						; 8
; ---------------------------------------------------------------------------
; lavaball types 00-03 fly up and fall back down

LBall_Type00:
		addi.w	#$18,y_vel(a0)							; increase object's downward speed
		move.w	objoff_30(a0),d0
		cmp.w	y_pos(a0),d0							; has object fallen back to its original position?
		bhs.s	.loc_E41E							; if not, branch
		move.l	#Delete_Current_Sprite,address(a0)				; goto "LBall_Delete" routine

.loc_E41E
		bclr	#status.npc.y_flip,status(a0)
		tst.w	y_vel(a0)
		bpl.s	LBall_Type08
		bset	#status.npc.y_flip,status(a0)

LBall_Type08:
		rts
; ---------------------------------------------------------------------------
; lavaball type 04 flies up until it hits the ceiling

LBall_Type04:
		bset	#status.npc.y_flip,status(a0)
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype(a0)
		move.b	#1,anim(a0)
		clr.w	y_vel(a0)							; stop the object when it touches the ceiling

.return
		rts
; ---------------------------------------------------------------------------
; lavaball type 05 falls down until it hits the floor

LBall_Type05:
		bclr	#status.npc.y_flip,status(a0)
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype(a0)
		move.b	#1,anim(a0)
		clr.w	y_vel(a0)							; stop the object when it touches the floor

.return
		rts
; ---------------------------------------------------------------------------
; lavaball types 06-07 move sideways

LBall_Type06:
		bset	#status.npc.x_flip,status(a0)
		moveq	#-(16/2),d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype(a0)
		move.b	#3,anim(a0)
		clr.w	x_vel(a0)							; stop object when it touches a wall

.return
		rts
; ---------------------------------------------------------------------------

LBall_Type07:
		bclr	#status.npc.x_flip,status(a0)
		moveq	#16/2,d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype(a0)
		move.b	#3,anim(a0)
		clr.w	x_vel(a0)							; stop object when it touches a wall

.return
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_LavaMaker:	subObjMainData Obj_LavaMaker.makelava, setBit(render_flags.level), 0, 64, 64, 0, 0, 0, 0, Map_Offscreen
ObjDat_LavaBall:	subObjMainData Obj_LavaBall.action, setBit(render_flags.level), 0, 16, 16, 3, $298, 0, 0, Map_Fire
; ---------------------------------------------------------------------------

		include "Objects/Environ/Lava Ball/Object Data/Anim - Fireballs.asm"
		include "Objects/Environ/Lava Ball/Object Data/Map - Fireballs.asm"
