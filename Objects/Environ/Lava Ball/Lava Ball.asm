; ---------------------------------------------------------------------------
; Object 13 - lava ball maker (MZ, SLZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset wait_timer								; pretend we're in the RAM

lavamaker.timer				ds.w 1						; current time remaining (2 bytes)
lavamaker.delay				ds.w 1						; time delay (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

		; lava ball production rates
LavaMaker_Rates:	dc.w ((1*60)-30), (1*60), ((1*60)+30), (2*60), ((2*60)+30), (3*60)
; ---------------------------------------------------------------------------

Obj_LavaMaker:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; set
		move.b	subtype.byte(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		move.w	LavaMaker_Rates(pc,d0.w),d0
		move.w	d0,lavamaker.timer(a0)						; set time delay for lava balls
		move.w	d0,lavamaker.delay(a0)
		andi.b	#$F,subtype.byte(a0)

		; init
		movem.l	ObjDat_LavaMaker(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object

.makelava

		; wait
		subq.w	#1,lavamaker.timer(a0)						; subtract 1 from time delay
		bne.s	.draw								; if time still remains, branch
		move.w	lavamaker.delay(a0),lavamaker.timer(a0)				; reset time delay

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch

		; create lava ball object
		jsr	(Create_New_Object_3).w
		bne.s	.draw
		move.l	#Obj_LavaBall,code_addr(a1)					; load lava ball object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	subtype.byte(a0),subtype.byte(a1)

.draw
		jmp	(Sprite_OnScreen_Test).w

; ---------------------------------------------------------------------------
; Object 14 - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

lavaball.origY				ds.w 1						; original y-axis position (2 bytes)
lavaball.boss_flag			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

LavaBall_Speeds:
		dc.w -$400, -$500, -$600, -$700, -$200
		dc.w $200, -$200, $200, 0
; ---------------------------------------------------------------------------

Obj_LavaBall:

		; init
		movem.l	ObjDat_LavaBall(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	y_pos(a0),lavaball.origY(a0)

		; check
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; is level Star Light Zone?
		bne.s	.notSLZ								; if not, branch
		move.w	#make_art_tile($434,0,FALSE),art_tile(a0)			; SLZ specific code

.notSLZ
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set lava ball collision type
		move.w	#bytes_to_word(16/2,16/2),collision_height(a0)			; set height and width collision
		bset	#shield_reaction.fire_shield,shield_reaction(a0)

		; check MZ boss
		tst.b	lavaball.boss_flag(a0)						; is lava ball was created by the MZ boss?
		beq.s	.speed								; if not, branch
		move.w	#priority_5,priority(a0)					; set priority

.speed

		; set
		moveq	#0,d0
		move.b	subtype.byte(a0),d0
		add.w	d0,d0								; multiply by 2
		move.w	LavaBall_Speeds(pc,d0.w),y_vel(a0)				; load object speed (vertical)
		move.w	#bytes_to_word(16/2,32/2),y_radius(a0)				; set y_radius and x_radius

		; check
		cmpi.b	#6,subtype.byte(a0)						; is object type below $06?
		blo.s	.sound								; if yes, branch
		move.w	#bytes_to_word(32/2,16/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#2,anim(a0)							; use horizontal animation
		move.w	y_vel(a0),x_vel(a0)						; set horizontal speed
		clr.w	y_vel(a0)							; delete vertical speed

.sound
		sfx	sfx_Fireball							; play lava ball sound

.action
		moveq	#0,d0
		move.b	subtype.byte(a0),d0
		add.w	d0,d0								; multiply by 2
		move.w	LavaBall_TypeIndex(pc,d0.w),d0
		jsr	LavaBall_TypeIndex(pc,d0.w)

		; draw
		MoveSprite2
		lea	Ani_LavaBall(pc),a1
		jsr	(Animate_SpriteNoSST).w
		tst.b	routine(a0)							; changed by Animate_Sprite
		bne.s	.delete
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

LavaBall_TypeIndex: offsetTable
		offsetTableEntry.w LavaBall_Type00					; 0
		offsetTableEntry.w LavaBall_Type00					; 1
		offsetTableEntry.w LavaBall_Type00					; 2
		offsetTableEntry.w LavaBall_Type00					; 3
		offsetTableEntry.w LavaBall_Type04					; 4
		offsetTableEntry.w LavaBall_Type05					; 5
		offsetTableEntry.w LavaBall_Type06					; 6
		offsetTableEntry.w LavaBall_Type07					; 7
		offsetTableEntry.w LavaBall_Type08					; 8
; ---------------------------------------------------------------------------
; lavaball types 00-03 fly up and fall back down

LavaBall_Type00:
		addi.w	#$18,y_vel(a0)							; increase object's downward speed
		move.w	lavaball.origY(a0),d0
		cmp.w	y_pos(a0),d0							; has object fallen back to its original position?
		bhs.s	.loc_E41E							; if not, branch
		move.l	#Delete_Current_Object,code_addr(a0)				; goto "LavaBall_Delete" routine

.loc_E41E
		bclr	#status.npc.y_flip,status(a0)					; clear flipy
		tst.w	y_vel(a0)							; is object falling down?
		bpl.s	LavaBall_Type08							; if yes, branch
		bset	#status.npc.y_flip,status(a0)					; set flipy

LavaBall_Type08:
		rts
; ---------------------------------------------------------------------------
; lavaball type 04 flies up until it hits the ceiling

LavaBall_Type04:
		bset	#status.npc.y_flip,status(a0)					; set flipy
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype.byte(a0)
		move.b	#1,anim(a0)
		clr.w	y_vel(a0)							; stop the object when it touches the ceiling

.return
		rts
; ---------------------------------------------------------------------------
; lavaball type 05 falls down until it hits the floor

LavaBall_Type05:
		bclr	#status.npc.y_flip,status(a0)					; clear flipy
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype.byte(a0)
		move.b	#1,anim(a0)
		clr.w	y_vel(a0)							; stop the object when it touches the floor

.return
		rts
; ---------------------------------------------------------------------------
; lavaball types 06-07 move sideways

LavaBall_Type06:
		bset	#status.npc.x_flip,status(a0)					; set flipx

		move.b	x_radius(a0),d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype.byte(a0)
		move.b	#3,anim(a0)
		clr.w	x_vel(a0)							; stop object when it touches a wall

.return
		rts
; ---------------------------------------------------------------------------

LavaBall_Type07:
		bclr	#status.npc.x_flip,status(a0)					; clear flipx

		move.b	x_radius(a0),d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.return
		move.b	#8,subtype.byte(a0)
		move.b	#3,anim(a0)
		clr.w	x_vel(a0)							; stop object when it touches a wall

.return
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_LavaMaker:	subObjMainData Obj_LavaMaker.makelava, setBit(render_flags.level), 0, 64, 64, 0, 0, 0, FALSE, Map_Offscreen
ObjDat_LavaBall:	subObjMainData Obj_LavaBall.action, setBit(render_flags.level), 0, 16, 16, 3, $298, 0, FALSE, Map_LavaBall
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Lava Ball/Object Data/Anim - Lava Ball.asm"
		include "Objects/Environ/Lava Ball/Object Data/Map - Lava Ball.asm"
