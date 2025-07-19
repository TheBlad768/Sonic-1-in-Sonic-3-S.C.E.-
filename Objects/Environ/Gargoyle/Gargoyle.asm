; ---------------------------------------------------------------------------
; Object 62 - gargoyle head (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
gar_time			= objoff_2E
gar_stime			= objoff_30

; =============== S U B R O U T I N E =======================================

		; fire ball production rates
Gar_SpitRate:	dc.b 30, 60, 90, 120, 150, 180, 210, 240
; ---------------------------------------------------------------------------

Obj_Gargoyle:

		; init
		lea	ObjDat_Gargoyle(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.makefire,address(a0)

		; set
		moveq	#$F,d0								; read only the 2nd digit
		and.b	subtype(a0),d0							; get object type
		move.b	Gar_SpitRate(pc,d0.w),gar_stime(a0)				; set fireball spit rate
		move.b	gar_stime(a0),gar_time(a0)
		andi.b	#$F,subtype(a0)

.makefire
		subq.b	#1,gar_time(a0)							; decrement timer
		bne.s	.draw								; if time remains, branch
		move.b	gar_stime(a0),gar_time(a0)					; reset timer

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch

		; create
		jsr	(Create_New_Sprite3).w
		bne.s	.draw
		move.l	#Obj_Gargoyle_FireBall,address(a1)				; load fireball object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),d0
		addq.w	#8,d0
		move.w	d0,y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)

.draw
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Obj_Gargoyle_FireBall:

		; init
		lea	ObjDat_Gargoyle_FireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.w	#bytes_to_word(16/2,16/2),y_radius(a0)				; set y_radius and x_radius
		sfx	sfx_Fireball							; play lava ball sound
		move.l	#.anifire,address(a0)
		move.w	#$200,x_vel(a0)
		btst	#status.npc.x_flip,status(a0)					; is gargoyle facing left?
		bne.s	.anifire							; if not, branch
		neg.w	x_vel(a0)

.anifire
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	.nochg
		bchg	#0,mapping_frame(a0)						; change every 8 frames

.nochg
		MoveSpriteXOnly a0

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
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Gargoyle:		subObjData Map_Gar, $2E9, 2, 0, 32, 32, 3, 0, 0
ObjDat_Gargoyle_FireBall:	subObjData Map_Gar, $2E9, 0, 0, 16, 16, 4, 2, $18|collision_flags.npc.hurt
; ---------------------------------------------------------------------------

		include "Objects/Environ/Gargoyle/Object Data/Map - Gargoyle.asm"
