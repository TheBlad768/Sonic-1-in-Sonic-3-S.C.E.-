; ---------------------------------------------------------------------------
; Super Birds (Object)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

superTailsBirds.timer			ds.b 1						; (1 byte)
superTailsBirds.found			ds.b 1						; (1 byte)
superTailsBirds.locked			ds.b 1						; (1 byte)
superTailsBirds.angle			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds:

.artsize :=	(ArtUnc_SuperTailsBirds_end-ArtUnc_SuperTailsBirds)&$FFFF

		; load birds art
		QueueStaticDMA ArtUnc_SuperTailsBirds,.artsize,tiles_to_bytes(ArtTile_Player_1)

.bcount =	4									; number of birds

		; load
		lea	(a0),a1
		moveq	#0,d0
		moveq	#.bcount-1,d1

.bloop
		move.l	#.init,code_addr(a1)
		move.b	d0,superTailsBirds.angle(a1)
		addi.b	#256/.bcount,d0							; 90 degrees
		lea	next_object(a1),a1
		dbf	d1,.bloop

.init

		; init
		movem.l	ObjDat_SuperTailsBirds(pc),d0-d3				; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object

		; get xypos
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)
		subi.w	#384/2,x_pos(a0)
		subi.w	#384/2,y_pos(a0)
		clr.l	x_vel(a0)							; clear velocity

.main

		; check Super Tails
		tst.b	(Super_Tails_flag).w						; is Tails Super?
		bne.s	.still_super							; if so, branch

		; Tails has returned to normal - make the birds fly away
		moveq	#0,d0
		move.w	d0,(Player_2+x_pos).w
		move.w	d0,(Player_2+y_pos).w
		move.b	d0,(Player_2+anim).w

		; check
		tst.b	superTailsBirds.found(a0)
		beq.s	.no_target
		movea.w	parent(a0),a1							; a1=target object
		move.b	d0,superTailsBirds.locked(a1)					; seems to be for indicating whether an object has been 'locked-onto' or not

.no_target
		move.b	d0,superTailsBirds.found(a0)
		move.b	#2*60,superTailsBirds.timer(a0)					; only search for enemies every two seconds (probably to reduce lag)
		move.l	#SuperTailsBirds_FlyAway,code_addr(a0)

.still_super
		bsr.s	SuperTailsBirds_GetDestination

.move
		bsr.w	SuperTailsBirds_Move
		addq.b	#2,superTailsBirds.angle(a0)

		; update which way the sprite faces
		tst.w	x_vel(a0)
		beq.s	.x_flip_done
		bpl.s	.face_right
		bset	#render_flags.x_flip,render_flags(a0)
		bra.s	.x_flip_done
; ---------------------------------------------------------------------------

.face_right
		bclr	#render_flags.x_flip,render_flags(a0)

.x_flip_done

		; update whether the sprite should be upside down
		andi.b	#~( \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		tst.b	(Reverse_gravity_flag).w
		beq.s	.not_upside_down

		ori.b	#( \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

.not_upside_down

		; wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		addq.b	#1+1,anim_frame_timer(a0)

		; next
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

SuperTailsBirds_FlyAway:

		; set bird's destination to top-left of the screen
		move.w	(Player_1+x_pos).w,d2
		move.w	(Player_1+y_pos).w,d3
		subi.w	#384/2,d2
		subi.w	#384/2,d3

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bmi.s	Obj_SuperTailsBirds.move					; if yes, branch

		; if sprite is off-screen, delete it
		jmp	(Delete_Current_Object).w

; =============== S U B R O U T I N E =======================================

SuperTailsBirds_GetDestination:
		tst.b	superTailsBirds.found(a0)
		bne.s	.fly_towards_enemy
		tst.b	superTailsBirds.timer(a0)
		beq.s	.look_for_target
		subq.b	#1,superTailsBirds.timer(a0)
		bra.s	.fly_around_tails
; ---------------------------------------------------------------------------

.look_for_target
		bsr.w	SuperTailsBirds_FindTarget
		tst.w	d1
		bne.s	.fly_towards_enemy

.fly_around_tails
		move.b	superTailsBirds.angle(a0),d0					; angle
		jsr	(GetSineCosine).w
		asr.w	#3,d0
		asr.w	#4,d1
		move.w	(Player_1+x_pos).w,d2
		moveq	#-32,d3
		add.w	(Player_1+y_pos).w,d3
		tst.b	(Reverse_gravity_flag).w
		beq.s	.not_upside_down
		addi.w	#32*2,d3

.not_upside_down
		add.w	d0,d2
		add.w	d1,d3
		rts
; ---------------------------------------------------------------------------

.fly_towards_enemy
		movea.w	parent(a0),a1							; a1=target object
		move.w	x_pos(a1),d2
		move.w	y_pos(a1),d3

		; check
		tst.b	render_flags(a1)						; object visible on the screen?
		bpl.s	.enemy_off_screen						; if not, branch

		; check xpos
		move.w	x_pos(a0),d0
		sub.w	d2,d0
		addi.w	#12,d0
		cmpi.w	#12*2,d0
		bhs.s	.enemy_out_of_range

		; check ypos
		move.w	y_pos(a0),d1
		sub.w	d3,d1
		addi.w	#12,d1
		cmpi.w	#12*2,d1
		bhs.s	.enemy_out_of_range
		bsr.s	.hit_enemy

.enemy_off_screen

		; reset
		moveq	#0,d0
		move.b	d0,superTailsBirds.locked(a1)
		move.b	d0,superTailsBirds.found(a0)
		move.b	#2*60,superTailsBirds.timer(a0)					; only search for enemies every two seconds (probably to reduce lag)

.enemy_out_of_range
		rts

; =============== S U B R O U T I N E =======================================

.hit_enemy
		move.b	collision_flags(a1),d0
		beq.s	.no_collision							; if object has no collision, give up
		andi.b	#$C0,d0
		beq.s	.enemy
		cmpi.b	#$C0,d0
		beq.s	.special

.no_collision
		rts
; ---------------------------------------------------------------------------

.enemy

		; boss related? could be special enemies in general
		tst.b	collision_property(a1)
		beq.s	.destroy_enemy
		move.b	collision_flags(a1),boss_saved_collision(a1)			; save current collision
		move.b	#Player_2&$FF,boss_saved_player(a1)				; save value of RAM address of which player hit the boss
		clr.b	collision_flags(a1)

	if BossDebug
		clr.b	boss_hitcount(a1)
	else
		subq.b	#1,boss_hitcount(a1)
		bne.s	.skip
	endif

		bset	#status.npc.defeated,status(a1)					; set "boss defeated" flag

.skip
		bra.s	.done
; ---------------------------------------------------------------------------

.destroy_enemy
		jmp	(HyperTouch_DestroyEnemy).l
; ---------------------------------------------------------------------------

.special
		ori.b	#2,collision_property(a1)

.done
		move.w	x_pos(a0),(Player_2+x_pos).w
		move.w	y_pos(a0),(Player_2+y_pos).w
		move.b	#AniIDSonAni_Roll,(Player_2+anim).w
		rts

; =============== S U B R O U T I N E =======================================

SuperTailsBirds_Move:

		; update the bird's x_vel
		moveq	#32,d1
		cmp.w	x_pos(a0),d2
		bge.s	.moveright

		; move left
		neg.w	d1
		tst.w	x_vel(a0)
		bmi.s	.applymovementx

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1
		bra.s	.applymovementx
; ---------------------------------------------------------------------------

.moveright
		tst.w	x_vel(a0)
		bpl.s	.applymovementx

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1

.applymovementx
		add.w	d1,x_vel(a0)

		; update the bird's y_vel
		and.w	(Screen_Y_wrap_value).w,d3
		moveq	#32,d1
		sub.w	y_pos(a0),d3
		bhs.s	.checkrightypos

		; check left ypos
		cmpi.w	#-$500,d3
		ble.s	.checkrightyvel

.checkleftyvel
		cmpi.w	#-$1000,y_vel(a0)
		ble.s	.moveup

.movedown

		; move down
		neg.w	d1
		tst.w	y_vel(a0)
		bmi.s	.applymovementy

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1
		bra.s	.applymovementy
; ---------------------------------------------------------------------------

.checkrightypos
		cmpi.w	#$500,d3
		bge.s	.checkleftyvel

.checkrightyvel
		cmpi.w	#$1000,y_vel(a0)
		bge.s	.movedown

.moveup
		tst.w	y_vel(a0)
		bpl.s	.applymovementy

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1

.applymovementy
		add.w	d1,y_vel(a0)
		MoveSprite2
		move.w	(Level_repeat_offset).w,d0
		sub.w	d0,x_pos(a0)
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to react to collision flags
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SuperTailsBirds_FindTarget:
		moveq	#0,d1
		lea	(Collision_response_list).w,a4
		move.w	(a4)+,d6							; get number of objects queued
		beq.s	.return								; if there are none, return

		; check
		moveq	#2,d0
		add.b	(Super_Tails_birds_target_counter).w,d0
		cmp.b	d0,d6
		bhi.s	.noreset
		moveq	#0,d0

.noreset
		move.b	d0,(Super_Tails_birds_target_counter).w
		sub.w	d0,d6
		adda.w	d0,a4

.loop
		movea.w	(a4)+,a1							; get address of first object's RAM
		tst.b	render_flags(a1)						; is the object visible on the screen?
		bpl.s	.ignore_object							; if not, branch
		move.b	collision_flags(a1),d0						; get its collision flags
		beq.s	.ignore_object							; if there is no collision here, branch
		bsr.s	.check_if_object_valid

.ignore_object
		subq.w	#2,d6								; count the object as done
		bne.s	.loop								; if there are still objects left, loop

.return
		rts

; =============== S U B R O U T I N E =======================================

.check_if_object_valid
		tst.b	superTailsBirds.locked(a1)
		bne.s	.return
		andi.b	#$C0,d0
		beq.s	.valid
		cmpi.b	#$C0,d0
		bne.s	.return

.valid
		st	superTailsBirds.locked(a1)
		move.w	a1,parent(a0)							; save target object
		move.b	#1,superTailsBirds.found(a0)
		moveq	#1,d1
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_SuperTailsBirds:		subObjMainData \
				Obj_SuperTailsBirds.main, \
					setBit(render_flags.level), \
				0, 16, 16, 1, ArtTile_Player_1, 0, TRUE, Map_SuperTails_Birds
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Players/Transform/Object Data/Map - Super Tails birds.asm"
