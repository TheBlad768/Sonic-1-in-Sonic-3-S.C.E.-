; ---------------------------------------------------------------------------
; Object 62 - gargoyle head (LZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

gargoyle.timer				ds.b 1						; (1 byte)
gargoyle.delay				ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

		; fire ball production rates
Gar_SpitRate:	dc.b 30, 60, 90, 120, 150, 180, 210, 240
; ---------------------------------------------------------------------------

Obj_Gargoyle:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_Gargoyle(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.makefire,code_addr(a0)

		; set
		moveq	#$F,d0								; read only the 2nd digit
		and.w	subtype(a0),d0							; get object type
		move.b	Gar_SpitRate(pc,d0.w),gargoyle.delay(a0)			; set fireball spit rate
		move.b	gargoyle.delay(a0),gargoyle.timer(a0)

.makefire
		subq.b	#1,gargoyle.timer(a0)						; decrement timer
		bne.s	.draw								; if time remains, branch
		move.b	gargoyle.delay(a0),gargoyle.timer(a0)				; reset timer

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch

		; create
		jsr	(Create_New_Object_3).w
		bne.s	.draw
		move.l	#Obj_Gargoyle_FireBall,code_addr(a1)				; load fireball object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),d0
		addq.w	#8,d0
		move.w	d0,y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)

.draw
		jmp	(Sprite_OnScreen_Test).w

; ---------------------------------------------------------------------------
; Gargoyle fire ball
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_Gargoyle_FireBall:

		; init
		lea	ObjDat_Gargoyle_FireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		sfx	sfx_Fireball							; play lava ball sound
		move.l	#.anifire,code_addr(a0)
		move.w	#$200,x_vel(a0)
		btst	#status.npc.x_flip,status(a0)					; is gargoyle facing left?
		bne.s	.anifire							; if not, branch
		neg.w	x_vel(a0)

.anifire
		moveq	#7,d0
		and.b	(Level_frame_counter.byte).w,d0
		bne.s	.nochg
		bchg	#0,mapping_frame(a0)						; change every 8 frames

.nochg
		MoveSpriteXOnly

		; check wall
		move.b	x_radius(a0),d3
		ext.w	d3
		btst	#status.npc.x_flip,status(a0)					; is fireball moving left?
		bne.s	.isright							; if not, branch
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bmi.s	.delete								; delete if the fireball hits a wall

.draw
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

.isright
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.draw

.delete
		jmp	(Delete_Current_Object).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Gargoyle:		subObjData Map_Gargoyle, $2E9, 2, FALSE, 32, 32, 3, 0, collision_type.npc.none, 0, 0
ObjDat_Gargoyle_FireBall:	subObjData Map_Gargoyle, $2E9, 0, FALSE, 16, 16, 4, 2, collision_type.npc.hurt, 8, 8
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Gargoyle/Object Data/Map - Gargoyle.asm"
