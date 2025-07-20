; ---------------------------------------------------------------------------
; Super Birds (Object)
; ---------------------------------------------------------------------------

; Dynamic object variables
superTailsBirds_target_found		= $30
superTailsBirds_search_delay		= $32
superTailsBirds_angle			= $34
superTailsBirds_target_address		= $42

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds:

.artsize	:= (ArtUnc_SuperTailsBirds_end-ArtUnc_SuperTailsBirds)&$FFFF

		; load birds art
		QueueStaticDMA ArtUnc_SuperTailsBirds,.artsize,tiles_to_bytes(ArtTile_Player_1)

		; load
		lea	(a0),a1
		moveq	#0,d0
		moveq	#4-1,d1

.loop
		move.l	#Obj_SuperTailsBirds_Init,address(a1)
		move.b	d0,superTailsBirds_angle(a1)
		addi.b	#256/4,d0							; 90 degrees
		lea	next_object(a1),a1
		dbf	d1,.loop

Obj_SuperTailsBirds_Init:

		; wait for art to finish loading before we display
		tst.w	(KosPlus_modules_left).w
		beq.s	.art_done_loading
		rts
; ---------------------------------------------------------------------------

.art_done_loading

		; init
		move.l	#Map_SuperTails_Birds,mappings(a0)

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_1, \
			make_art_tile(ArtTile_Player_1,0,1) \
		),priority(a0)

		; set screen coordinates flag and height and width
		move.l	#bytes_to_long( \
			setBit(render_flags.level), \
		0,16/2,16/2 \
		),render_flags(a0)

		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)
		subi.w	#$C0,x_pos(a0)
		subi.w	#$C0,y_pos(a0)
		clr.l	x_vel(a0)
		move.l	#Obj_SuperTailsBirds_Main,address(a0)

Obj_SuperTailsBirds_Main:

		; check
		tst.b	(Super_Tails_flag).w
		bne.s	.Tails_still_super

		; Tails has returned to normal - make the birds fly away
		moveq	#0,d0
		move.w	d0,(Player_2+x_pos).w
		move.w	d0,(Player_2+y_pos).w
		move.b	d0,(Player_2+anim).w

		; check
		tst.b	superTailsBirds_target_found(a0)
		beq.s	.no_target
		movea.w	superTailsBirds_target_address(a0),a1
		move.b	d0,objoff_2D(a1)						; seems to be for indicating whether an object has been 'locked-onto' or not

.no_target
		move.b	d0,superTailsBirds_target_found(a0)
		move.b	#2*60,superTailsBirds_search_delay(a0)				; only search for enemies every two seconds (probably to reduce lag)
		move.l	#Obj_SuperTailsBirds_FlyAway,address(a0)

.Tails_still_super
		bsr.s	Obj_SuperTailsBirds_GetDestination

.move
		bsr.w	Obj_SuperTailsBirds_Move
		addq.b	#2,superTailsBirds_angle(a0)

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
		bpl.s	.timer_not_over
		addq.b	#1+1,anim_frame_timer(a0)

		; next
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

.timer_not_over
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_SuperTailsBirds_FlyAway:

		; set bird's destination to top-left of the screen
		move.w	(Player_1+x_pos).w,d2
		move.w	(Player_1+y_pos).w,d3
		subi.w	#192,d2
		subi.w	#192,d3

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bmi.s	Obj_SuperTailsBirds_Main.move					; if yes, branch

		; if sprite is off-screen, delete it
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds_GetDestination:
		tst.b	superTailsBirds_target_found(a0)
		bne.s	.fly_towards_enemy
		tst.b	superTailsBirds_search_delay(a0)
		beq.s	.look_for_target
		subq.b	#1,superTailsBirds_search_delay(a0)
		bra.s	.fly_around_tails
; ---------------------------------------------------------------------------

.look_for_target
		bsr.w	Obj_SuperTailsBirds_FindTarget
		tst.w	d1
		bne.s	.fly_towards_enemy

.fly_around_tails
		move.b	superTailsBirds_angle(a0),d0
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
		movea.w	superTailsBirds_target_address(a0),a1
		move.w	x_pos(a1),d2
		move.w	y_pos(a1),d3
		tst.b	render_flags(a1)						; object visible on the screen?
		bpl.s	.enemy_off_screen						; if not, branch
		move.w	x_pos(a0),d0
		sub.w	d2,d0
		addi.w	#12,d0
		cmpi.w	#24,d0
		bhs.s	.enemy_out_of_range
		move.w	y_pos(a0),d1
		sub.w	d3,d1
		addi.w	#12,d1
		cmpi.w	#24,d1
		bhs.s	.enemy_out_of_range
		bsr.s	.hit_enemy

.enemy_off_screen
		moveq	#0,d0
		move.b	d0,objoff_2D(a1)
		move.b	d0,superTailsBirds_target_found(a0)
		move.b	#2*60,superTailsBirds_search_delay(a0)

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
		move.b	collision_flags(a1),boss_backup_collision(a1)			; save current collision
		move.b	#Player_2&$FF,objoff_1C(a1)					; save value of RAM address of which player hit the boss
		clr.b	collision_flags(a1)

	if BossDebug
		clr.b	boss_hitcount2(a1)
	else
		subq.b	#1,boss_hitcount2(a1)
		bne.s	.skip
	endif

		bset	#status.npc.defeated,status(a1)

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

Obj_SuperTailsBirds_Move:

		; update the bird's x_vel
		moveq	#32,d1
		cmp.w	x_pos(a0),d2
		bge.s	.go_right
		neg.w	d1
		tst.w	x_vel(a0)
		bmi.s	.x_vel_done

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1
		bra.s	.x_vel_done
; ---------------------------------------------------------------------------

.go_right
		tst.w	x_vel(a0)
		bpl.s	.x_vel_done

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1

.x_vel_done
		add.w	d1,x_vel(a0)

		; update the bird's y_vel
		and.w	(Screen_Y_wrap_value).w,d3
		moveq	#32,d1
		sub.w	y_pos(a0),d3
		bhs.s	loc_1A3CA
		cmpi.w	#-$500,d3
		ble.s	loc_1A3D0

loc_1A3B4:
		cmpi.w	#-$1000,y_vel(a0)
		ble.s	loc_1A3D8

loc_1A3BC:
		neg.w	d1
		tst.w	y_vel(a0)
		bmi.s	loc_1A3E2

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1
		bra.s	loc_1A3E2
; ---------------------------------------------------------------------------

loc_1A3CA:
		cmpi.w	#$500,d3
		bge.s	loc_1A3B4

loc_1A3D0:
		cmpi.w	#$1000,y_vel(a0)
		bge.s	loc_1A3BC

loc_1A3D8:
		tst.w	y_vel(a0)
		bpl.s	loc_1A3E2

		; going the wrong way - make it turn around faster
		add.w	d1,d1
		add.w	d1,d1

loc_1A3E2:
		add.w	d1,y_vel(a0)
		jsr	(MoveSprite2).w
		move.w	(Level_repeat_offset).w,d0
		sub.w	d0,x_pos(a0)
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds_FindTarget:
		moveq	#0,d1
		lea	(Collision_response_list).w,a4
		move.w	(a4)+,d6
		beq.s	.return
		moveq	#0,d0
		addq.b	#2,(_unkF66C).w
		cmp.b	(_unkF66C).w,d6
		bhi.s	.noreset
		clr.b	(_unkF66C).w

.noreset
		move.b	(_unkF66C).w,d0
		sub.w	d0,d6
		adda.w	d0,a4

.loop
		movea.w	(a4)+,a1
		move.b	collision_flags(a1),d0
		beq.s	.ignore_object
		bsr.s	.check_if_object_valid

.ignore_object
		subq.w	#2,d6
		bne.s	.loop

.return
		rts

; =============== S U B R O U T I N E =======================================

.check_if_object_valid
		tst.b	render_flags(a1)						; object visible on the screen?
		bpl.s	.invalid							; if not, branch
		tst.b	objoff_2D(a1)
		bne.s	.invalid
		andi.b	#$C0,d0
		beq.s	.valid
		cmpi.b	#$C0,d0
		beq.s	.valid

.invalid
		rts
; ---------------------------------------------------------------------------

.valid
		st	objoff_2D(a1)
		move.w	a1,superTailsBirds_target_address(a0)
		move.b	#1,superTailsBirds_target_found(a0)
		moveq	#1,d1
		moveq	#2,d6
		rts
; ---------------------------------------------------------------------------

		include "Objects/Players/Transform/Object Data/Map - Super Tails birds.asm"
