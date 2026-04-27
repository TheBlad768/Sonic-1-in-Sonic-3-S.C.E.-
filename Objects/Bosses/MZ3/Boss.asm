; ---------------------------------------------------------------------------
; Boss Fire (MZ3)
; Object 73 - Eggman (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

bossfire.timer				ds.w 1						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_BossFire:

.hitcount =	8

		; don't load the objects until the art has been loaded
		tst.w	(KosPlus_modules_left).w
		bne.s	BossFire_MoveLeft.return
		move.l	#BossFire_Setup3,code_addr(a0)

		; init
		lea	ObjDat_RobotnikShip2(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#.hitcount,collision_property(a0)				; set hits
		move.w	#-$100,x_vel(a0)						; set move left
		move.l	#BossFire_MoveLeft,wait_addr(a0)

		; create
		lea	Child1_MakeRoboHead4(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_BossFire_ShipTube(pc),a2
		jsr	(CreateChild1_Normal).w
		jmp	(Swing_Setup1).w

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFire_MoveLeft:

		; fireball timer
		jsr	(Random_Number).w
		move.b	d0,count(a0)

		; check xcam
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$110,d0
		cmp.w	x_pos(a0),d0
		bne.s	.return

		; next
		move.l	#BossFire_Setup2,code_addr(a0)
		move.l	#BossFire_MoveCircle,wait_addr(a0)
		clr.l	x_vel(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossFire_MoveCircle:
		tst.w	x_vel(a0)
		bne.s	loc_183FE
		moveq	#$40,d0
		moveq	#$2C,d1
		add.w	(Camera_max_Y_pos).w,d1
		cmp.w	y_pos(a0),d1
		beq.s	loc_183E6
		bhs.s	loc_183DE
		neg.w	d0

loc_183DE:
		move.w	d0,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_183E6:
		move.l	#words_to_long($200,$100),x_vel(a0)				; x_vel + y_vel
		btst	#render_flags.x_flip,render_flags(a0)
		bne.s	loc_183FE
		neg.w	x_vel(a0)

loc_183FE:
		cmpi.b	#$18,boss_invulnerable_time(a0)
		bhs.s	Obj73_MakeLava
		subq.w	#4,y_vel(a0)

Obj73_MakeLava:
		subq.b	#1,count(a0)
		bhs.s	loc_1845C

		; create
		jsr	(Create_New_Object_3).w
		bne.s	loc_1844A
		move.l	#Obj_LavaBall,code_addr(a1)					; load lava ball object
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$E8,d0
		move.w	d0,y_pos(a1)							; set Y position
		jsr	(Random_Number).w
		swap	d0
		clr.w	d0
		swap	d0
		divu.w	#$50,d0
		swap	d0
		moveq	#$78,d1
		add.w	(Camera_max_X_pos).w,d1
		add.w	d1,d0
		move.w	d0,x_pos(a1)
		clr.b	subtype.byte(a1)
		st	lavaball.boss_flag(a1)

loc_1844A:
		jsr	(Random_Number).w
		andi.b	#$1F,d0
		addi.b	#$40,d0
		move.b	d0,count(a0)

loc_1845C:
		move.w	(Camera_max_X_pos).w,d0
		btst	#render_flags.x_flip,render_flags(a0)
		beq.s	loc_18474
		addi.w	#screen_width-48,d0
		cmp.w	x_pos(a0),d0
		bgt.s	locret_1849C
		move.w	d0,x_pos(a0)
		bra.s	loc_18482
; ---------------------------------------------------------------------------

loc_18474:
		addi.w	#48,d0
		cmp.w	x_pos(a0),d0
		blt.s	locret_1849C
		move.w	d0,x_pos(a0)

loc_18482:
		clr.w	x_vel(a0)
		move.w	#-$180,y_vel(a0)
		moveq	#44,d0
		add.w	(Camera_max_Y_pos).w,d0
		cmp.w	y_pos(a0),d0
		blo.s	loc_18498
		neg.w	y_vel(a0)

loc_18498:
		move.l	#BossFire_AttackFire2,wait_addr(a0)

locret_1849C:
		rts
; ---------------------------------------------------------------------------

BossFire_AttackFire2:
		moveq	#44,d0
		add.w	(Camera_max_Y_pos).w,d0
		sub.w	y_pos(a0),d0
		blt.s	.return
		tst.w	y_vel(a0)
		beq.s	.skip
		clr.w	y_vel(a0)
		move.w	#$50,bossfire.timer(a0)						; set wait
		bchg	#render_flags.x_flip,render_flags(a0)
		bset	#6,state_flags(a0)						; set Robotnik laugh flag

		; create
		jsr	(Create_New_Object_3).w
		bne.s	.skip
		move.l	#Obj_BossFire_Fire,code_addr(a1)				; load lava ball object
		move.w	x_pos(a0),d0
		moveq	#-1,d1
		btst	#render_flags.x_flip,render_flags(a0)
		beq.s	.notflipx
		neg.w	d1

.notflipx
		add.w	d1,d0
		move.w	d0,x_pos(a1)
		move.w	y_pos(a0),d0
		addq.w	#8,d0
		move.w	d0,y_pos(a1)
		st	subtype.byte(a1)

.skip
		subq.w	#1,bossfire.timer(a0)
		bne.s	.return
		move.l	#BossFire_MoveCircle,wait_addr(a0)
		bclr	#6,state_flags(a0)						; clear Robotnik laugh flag

.return
		rts

; ---------------------------------------------------------------------------
; Setup
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFire_Setup3:
		jsr	(Swing_UpAndDown).w

BossFire_Setup2:
		cmpi.b	#$18,boss_invulnerable_time(a0)
		bhs.s	BossFire_Setup
		jsr	(MoveSprite2).w

BossFire_Setup:

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFire_MainProcess:
		pea	(Draw_And_Touch_Sprite).w

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		; check touch
		tst.b	collision_type(a0)						; are boss's collisions enabled?
		bne.s	.return								; if yes, branch
		tst.b	collision_property(a0)						; has boss run out of hits?
		beq.s	BossFire_Defeated						; if yes, branch
		tst.b	boss_invulnerable_time(a0)					; is boss invulnerable?
		bne.s	.flash								; if yes, branch
		move.b	#$28,boss_invulnerable_time(a0)					; make boss invulnerable
		sfx	sfx_BossHit							; play "boss hit" sound
		bset	#status.npc.touch,status(a0)					; set "boss hit" flag

.flash
		moveq	#0,d0								; load normal palette
		btst	#0,boss_invulnerable_time(a0)
		bne.s	.skip
		addq.w	#3*2,d0								; load flashing palette

.skip
		jsr	(BossFlash2).w
		subq.b	#1,boss_invulnerable_time(a0)					; decrease boss invincibility timer
		bne.s	.return
		bclr	#status.npc.touch,status(a0)					; clear "boss hit" flag
		move.b	boss_saved_collision(a0),collision_type(a0)			; if invincibility ended, allow collision again

.return
		rts

; ---------------------------------------------------------------------------
; Defeated
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFire_Defeated:
		move.l	#Obj_WaitFadeToLevelMusic,code_addr(a0)
		move.l	#.explosion,wait_addr(a0)
		clr.l	x_vel(a0)
		lea	Child1_MakeRoboShipFlame(pc),a2
		jsr	(CreateChild1_Normal).w

		; create explosion
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.notfree
		move.w	#4,subtype(a1)

.notfree
		jmp	(BossDefeated_StopTimer).w
; ---------------------------------------------------------------------------

.explosion
		move.l	#.move,code_addr(a0)

		; increase level size
		lea	(Child6_IncLevX).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree3
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$180,d0
		move.w	d0,(Camera_stored_max_X_pos).w

.notfree3
		bset	#render_flags.x_flip,render_flags(a0)
		move.l	#words_to_long($400,0),x_vel(a0)

		; return
		move.l	#MZ3_Resize.after_boss,(Level_data_addr_RAM.Resize).w

		; flags
		st	(Last_act_end_flag).w
		st	(Level_results_flag).w

		; create
		jsr	(Create_New_Object).w
		bne.s	.notfree2
		move.l	#Obj_EggCapsule,code_addr(a1)
		move.w	(Camera_stored_max_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,y_pos(a1)

.notfree2
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.move
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$1A0,d0
		cmp.w	x_pos(a0),d0
		blt.s	.delete
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		bset	#5,state_flags(a0)						; remove Robotnik head and fire
		clr.b	(Boss_flag).w
		clr.b	(Intro_flag).w

		; delete
		jmp	(Go_Delete_Object_3).w

; ---------------------------------------------------------------------------
; Boss Fire tube (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFire_ShipTube:

		; init
		lea	ObjDat_BossFire_ShipTube(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,code_addr(a0)

.main
		jsr	(Refresh_ChildPositionAdjusted).w

		; draw
		moveq	#4,d0								; set index velocity
		jmp	(Child_Draw_Sprite_FlickerMove).w

; ---------------------------------------------------------------------------
; Boss Fire tube flame (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFire_ShipTubeFlame:

		; init
		lea	ObjDat_BossFire_ShipTubeFlame(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,code_addr(a0)

.main
		jsr	(Refresh_ChildPositionAdjusted).w

		; anim
		moveq	#1,d0
		btst	#0,(V_int_run_count.byte).w					; 0 or 1
		bne.s	.setf
		tst.w	x_vel(a1)
		beq.s	.setf
		addq.b	#1,d0

.setf
		move.b	d0,mapping_frame(a0)

		; draw
		jmp	(Child_Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 74 - lava that Eggman drops (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

bossfire_fire.origX			ds.w 1						; original x-axis position (2 bytes)
bossfire_fire.copyX			ds.w 1						; copy x-axis position (2 bytes)
					ds.l 1						; skip wait_addr (4 bytes)
bossfire_fire.origY			ds.w 1						; original y-axis position (2 bytes)
bossfire_fire.timer			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_BossFire_Fire:

		; init
		lea	ObjDat_BossFire_Fire(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.w	height_pixels(a0),y_radius(a0)					; set y_radius and x_radius
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.w	y_pos(a0),bossfire_fire.origY(a0)
		move.l	#Obj74_Drop,wait_addr(a0)
		move.l	#Obj74_Action,code_addr(a0)

		; check
		tst.b	subtype.byte(a0)
		bne.s	loc_1870A
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set fire collision type
		move.w	#bytes_to_word(16/2,16/2),collision_height(a0)			; set height and width collision
		move.l	#loc_18886,code_addr(a0)
		bra.w	loc_18886
; ---------------------------------------------------------------------------

loc_1870A:
		sfx	sfx_Fireball							; play lava ball sound
		move.b	#30,bossfire_fire.timer(a0)					; set wait

Obj74_Action:

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)
		jsr	(MoveSprite2).w
		lea	Ani_LavaBall(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

Obj74_Drop:
		bset	#status.npc.y_flip,status(a0)

		; check
		subq.b	#1,bossfire_fire.timer(a0)
		bpl.s	.return
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set fire collision type
		move.w	#bytes_to_word(16/2,16/2),collision_height(a0)			; set height and width collision
		clr.b	subtype.byte(a0)
		addi.w	#$18,y_vel(a0)
		bclr	#status.npc.y_flip,status(a0)
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.return
		move.l	#Obj74_MakeFlame,wait_addr(a0)

.return
		rts
; ---------------------------------------------------------------------------

Obj74_MakeFlame:
		subq.w	#2,y_pos(a0)
		bset	#high_priority_bit,art_tile(a0)					; high priority
		move.l	#words_to_long($A0,0),x_vel(a0)
		move.w	x_pos(a0),bossfire_fire.origX(a0)
		move.w	y_pos(a0),bossfire_fire.origY(a0)
		move.b	#3,bossfire_fire.timer(a0)					; set wait

		; create flame
		jsr	(Create_New_Object_3).w
		bne.s	.notfree
		lea	(a1),a3
		lea	(a0),a2

		; if you make a different object size, you need to change this code

	if object_size<>$50
		fatal "Warning! The object size is different!"
	endif

		set	.a,0

	rept object_size/$28
		movem.l	(a2)+,d0-d6/a4-a6
		movem.l	d0-d6/a4-a6,.a(a3)						; copy $28 bytes
		set	.a,.a + $28
	endr

		neg.w	x_vel(a1)
		move.l	#Obj74_Duplicate,wait_addr(a1)

.notfree
		move.l	#Obj74_Duplicate,wait_addr(a0)
		rts
; ---------------------------------------------------------------------------

Obj74_Duplicate:
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	loc_18826
		move.w	x_pos(a0),d0
		move.w	(Camera_saved_min_X_pos).w,d1
		addi.w	#screen_width,d1
		cmp.w	d1,d0
		bgt.s	loc_1882C
		move.w	bossfire_fire.origX(a0),d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		moveq	#$10,d2
		and.w	d2,d0
		and.w	d2,d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		bsr.s	Obj74_Duplicate2
		move.w	x_pos(a0),bossfire_fire.copyX(a0)

loc_1881E:
		move.w	x_pos(a0),bossfire_fire.origX(a0)
		rts
; ---------------------------------------------------------------------------

loc_18826:
		move.l	#Obj74_FallEdge,wait_addr(a0)
		rts
; ---------------------------------------------------------------------------

loc_1882C:
		move.l	#loc_18886,code_addr(a0)
		rts

; =============== S U B R O U T I N E =======================================

Obj74_Duplicate2:
		jsr	(Create_New_Object_3).w
		bne.s	.return
		move.l	#Obj_BossFire_Fire,code_addr(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#$67,bossfire_fire.timer(a1)					; set wait
		clr.b	subtype.byte(a1)

.return
		rts

; =============== S U B R O U T I N E =======================================

Obj74_FallEdge:
		bclr	#status.npc.y_flip,status(a0)
		addi.w	#$24,y_vel(a0)							; make flame fall
		move.w	x_pos(a0),d0
		sub.w	bossfire_fire.copyX(a0),d0
		bpl.s	.abs
		neg.w	d0

.abs
		cmpi.w	#18,d0
		bne.s	.skip
		bclr	#high_priority_bit,art_tile(a0)					; low priority

.skip
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.return

		; check
		subq.b	#1,bossfire_fire.timer(a0)
		beq.s	Obj74_Delete
		clr.w	y_vel(a0)
		move.w	bossfire_fire.copyX(a0),x_pos(a0)
		move.w	bossfire_fire.origY(a0),y_pos(a0)
		move.l	#Obj74_Duplicate,wait_addr(a0)
		bset	#high_priority_bit,art_tile(a0)					; high priority

.return
		rts
; ---------------------------------------------------------------------------

Obj74_Delete:
		jmp	(Go_Delete_Object).w

; =============== S U B R O U T I N E =======================================

loc_18886:
		bset	#high_priority_bit,art_tile(a0)					; high priority

		; check
		subq.b	#1,bossfire_fire.timer(a0)
		bne.s	.anim
		move.b	#1,anim(a0)
		subq.w	#4,y_pos(a0)
		clr.b	collision_type(a0)						; remove collision

.anim
		lea	Ani_LavaBall(pc),a1
		jsr	(Animate_SpriteNoSST).w

		; check
		tst.b	routine(a0)							; changed by Animate_Sprite
		bne.s	Obj74_Delete

		; draw
		jmp	(Draw_And_Touch_Sprite).w

; ---------------------------------------------------------------------------
; Scaled (Intro)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_BossFire_Scaled:

		; init
		lea	ObjDat_BossFire_Scaled(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#render_flags.x_flip,render_flags(a0)
		move.b	#$18,scaling_scale_factor(a0)
		move.w	#$3F,wait_timer(a0)
		move.w	#$200,x_vel(a0)
		move.w	#tiles_to_bytes($340),scaling_art_tile(a0)			; VRAM
		move.l	#ArtScaled_RobotnikMZ,d0					; art pointer
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w				; is Knuckles?
		blo.s	.artpointer							; if not, branch
		move.l	#ArtScaled_EggRoboMZ,d0						; art pointer

.artpointer
		move.l	d0,scaling_art_addr(a0)						; set art pointer
		move.l	#.wait,code_addr(a0)

		; create decorative pillar
		jsr	(Create_New_Object_3).w
		bne.s	.wait
		move.l	#Child_Draw_Sprite,code_addr(a1)
		move.l	#Map_BossFire_Pillar,mappings(a1)
		move.b	#setBit(render_flags.level),render_flags(a1)			; use screen coordinates
		move.w	#priority_3,priority(a1)
		move.w	#$1C20,x_pos(a1)
		move.w	#$240,y_pos(a1)
		move.w	a0,parent3(a1)							; parent RAM address into parent3

.wait
		subq.w	#1,wait_timer(a0)
		bpl.s	.scale
		move.l	#.main,code_addr(a0)

.main
		moveq	#$6F,d0
		and.b	(Level_frame_counter.byte).w,d0
		bne.s	.frame
		cmpi.b	#$10,scaling_scale_factor(a0)
		beq.s	.frame
		subq.b	#1,scaling_scale_factor(a0)

.frame
		bchg	#0,scaling_frame(a0)

.scale
		jsr	(Perform_Art_Scaling).l

.draw
		out_of_xrange.s	.delete
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete

		; restore primary chunks
		QueueKosPlus	MZ_128x128_KosP, Chunk_table

		; update time counter
		move.b	#1,(Update_HUD_timer).w

		; delete
		move.l	#MZ3_Resize.load_boss,(Level_data_addr_RAM.Resize).w
		jmp	(Go_Delete_Object).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_BossFire_Fire:			subObjData Map_LavaBall, $298, 0, FALSE, 16, 16, 5, 0, collision_type.npc.none, 0, 0
ObjDat_BossFire_ShipTube:		subObjData Map_BossFire_Tube, $420, 1, FALSE, 32, 48, 3, 0, collision_type.npc.none, 0, 0
ObjDat_BossFire_ShipTubeFlame:		subObjData Map_BossFire_Tube, $420, 1, FALSE, 8, 16, 5, 1, collision_type.npc.none, 0, 0
ObjDat_BossFire_Scaled:			subObjData Map_ScaledArt, $340, 0, FALSE, 128, 128, 6, 0, collision_type.npc.none, 0, 0

Child1_BossFire_ShipTube:
		dc.w 2-1
		dc.l Obj_BossFire_ShipTube
		dc.b 11, 11
		dc.l Obj_BossFire_ShipTubeFlame
		dc.b 29, 10

PLC_BossFire: plrlistheader
		plreq $380, ArtKosPlusM_RobotnikShip2
		plreq $420, ArtKosPlusM_BossFireTube
		plreq $500, ArtKosPlusM_BossExplosion
		plrlistend
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Bosses/MZ3/Object Data/Map - Tube.asm"
		include "Objects/Bosses/MZ3/Object Data/Map - Pillar.asm"
