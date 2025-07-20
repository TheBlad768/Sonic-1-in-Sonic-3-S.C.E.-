; ---------------------------------------------------------------------------
; Boss Ball (GHZ3)
; Object 3D - Eggman (GHZ)
; ---------------------------------------------------------------------------

; Hits
BossBall_Hits				= 8

; Dynamic object variables
obBGB_Timer				= objoff_2E	; .w
obBGB_Jump				= objoff_34	; .l

obBGB_Status				= objoff_38	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossBall:

		; don't load the objects until the art has been loaded
		tst.w	(KosPlus_modules_left).w
		bne.w	BossBall_MoveDown.return
		move.l	#BossBall_Setup2,address(a0)

		; init
		lea	ObjDat_RobotnikShip2(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#BossBall_Hits,collision_property(a0)				; set hits
		move.w	#$100,y_vel(a0)							; set move down
		move.l	#BossBall_MoveDown,objoff_34(a0)

		; create
		lea	Child1_MakeRoboShipFlame(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_MakeRoboHead4(pc),a2
		jmp	(CreateChild1_Normal).w

; ---------------------------------------------------------------------------
; Start (Intro)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBall_MoveDown:

		; check
		moveq	#$28,d0
		add.w	(Camera_max_Y_pos).w,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.return

		; next
		move.l	#BossBall_Setup3,address(a0)
		move.l	#.createball,objoff_34(a0)
		move.w	#-$100,x_vel(a0)						; set move left
		jmp	(Swing_Setup1).w
; ---------------------------------------------------------------------------

.createball

		; check
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#320/2,d0
		cmp.w	x_pos(a0),d0
		bne.s	.return

		; next
		clr.w	x_vel(a0)							; set stop move
		move.w	#(2*60)-1,objoff_2E(a0)						; set wait
		move.l	#.wait,objoff_34(a0)
		bset	#6,objoff_38(a0)						; set laugh flag

		; create
		lea	Child9_GHZBall(pc),a2
		jmp	(CreateChild9_TreeList).w
; ---------------------------------------------------------------------------

.wait
		move.w	#(1<<7)-1,objoff_2E(a0)						; set wait
		move.w	#-$40,x_vel(a0)
		move.l	#BossBall_Move.flipx,objoff_34(a0)
		bset	#2,obBGB_Status(a0)
		bclr	#6,objoff_38(a0)						; clear laugh flag

.return
		rts

; ---------------------------------------------------------------------------
; Move (Attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBall_Move:
		move.w	#(1<<6)-1,objoff_2E(a0)						; set wait
		move.l	#.flipx,objoff_34(a0)

		; set move
		move.w	#-$100,d0
		jmp	(Change_VelocityWithFlipX).w
; ---------------------------------------------------------------------------

.flipx
		move.w	#(1<<6)-1,objoff_2E(a0)						; set wait
		move.l	#BossBall_Move,objoff_34(a0)
		bchg	#render_flags.x_flip,render_flags(a0)
		clr.w	x_vel(a0)
		rts

; ---------------------------------------------------------------------------
; Setup
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBall_Setup3:
		jsr	(Swing_UpAndDown).w

BossBall_Setup2:
		jsr	(MoveSprite2).w

BossBall_Setup:
		jsr	(Obj_Wait).w

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBall_MainProcess:
		btst	#2,obBGB_Status(a0)						; wait boss attack flag
		beq.s	.draw
		jsr	(Add_SpriteToCollisionResponseList).w

.draw
		pea	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		; check touch
		tst.b	collision_flags(a0)						; are boss's collisions enabled?
		bne.s	.return								; if yes, branch
		tst.b	collision_property(a0)						; has boss run out of hits?
		beq.s	BossBall_Defeated						; if yes, branch
		tst.b	boss_invulnerable_time(a0)					; is boss invulnerable?
		bne.s	.flash								; if yes, branch
		move.b	#$30,boss_invulnerable_time(a0)					; make boss invulnerable
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
		move.b	boss_backup_collision(a0),collision_flags(a0)			; if invincibility ended, allow collision again

.return
		rts

; ---------------------------------------------------------------------------
; Defeated
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBall_Defeated:
		move.l	#Wait_FadeToLevelMusic,address(a0)
		move.l	#.explosion,objoff_34(a0)
		clr.l	x_vel(a0)

		; use the first line of the palette
		andi.w	#$87FF,art_tile(a0)

.artsize	:= (ArtUnc_RobotnikShip1_end-ArtUnc_RobotnikShip1)&$FFFF

		; load alternative ship art
		QueueStaticDMA ArtUnc_RobotnikShip1,.artsize,tiles_to_bytes($3B6)

		; restore the flower palette
		lea	(Pal_GHZ).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line16).w

		; create explosion
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.notfree
		move.b	#4,subtype(a1)

.notfree
		jmp	(BossDefeated_StopTimer).w
; ---------------------------------------------------------------------------

.explosion
		move.l	#.move,address(a0)

		; increase level size
		lea	(Child6_IncLevX).w,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree3
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$1AC,d0
		move.w	d0,(Camera_stored_max_X_pos).w

.notfree3
		bset	#render_flags.x_flip,render_flags(a0)
		move.l	#words_to_long($400,0),x_vel(a0)

		; reset animate art
		clr.l	(Anim_Counters).w
		clr.w	(Anim_Counters+4).w

		; return
		move.l	#AnimateTiles_DoAniPLC,(Level_data_addr_RAM.AnimateTiles).w
		move.l	#End_GHZ3Boss,(Level_data_addr_RAM.Resize).w

		; flags
		st	(Last_act_end_flag).w
		st	(Level_results_flag).w

		; create
		jsr	(Create_New_Sprite).w
		bne.s	.notfree2
		move.l	#Obj_EggCapsule,address(a1)
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
		bset	#5,objoff_38(a0)						; remove Robotnik head and fire
		clr.b	(Boss_flag).w
		clr.b	(Intro_flag).w

		; delete
		jmp	(Go_Delete_Sprite_3).w

; ---------------------------------------------------------------------------
; Crane
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossBall_Crane:

		; init
		lea	ObjDat_BossBall_Crane(pc),a1
		jsr	(SetUp_ObjAttributes).w
		ori.b	#setBit(render_flags.static_mappings),render_flags(a0)		; set static mapping flag
		move.b	#26,child_dy(a0)
		move.w	#-$200,objoff_3A(a0)						; speed
		move.w	#$80,objoff_3C(a0)
		bsr.s	BossBall_GetWaitTime
		move.l	#.down,address(a0)

.down
		addq.w	#1,y_pos(a0)
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.l	#.wait,address(a0)
		bra.s	.refresh
; ---------------------------------------------------------------------------

.wait
		movea.w	parent4(a0),a1							; load boss address
		btst	#2,obBGB_Status(a1)						; wait boss attack flag
		beq.s	.refresh
		move.l	#.circular,address(a0)
		bra.s	.refresh
; ---------------------------------------------------------------------------

.circular
		move.w	objoff_3A(a0),d0

		; check
		tst.b	objoff_39(a0)							; is the ball moving left?
		bne.s	.cleft								; if yes, branch
		addq.w	#8,d0								; moving to the right

		; check
		cmpi.w	#$200,d0
		seq	objoff_39(a0)
		bra.s	.cset
; ---------------------------------------------------------------------------

.cleft
		subq.w	#8,d0								; moving to the left

		; check
		cmpi.w	#-$200,d0
		sne	objoff_39(a0)

.cset
		move.w	d0,objoff_3A(a0)
		sub.w	d0,objoff_3C(a0)

.refresh
		jsr	(Refresh_ChildPosition).w

.draw
		moveq	#0,d0								; set index velocity
		jmp	(Child_Draw_Sprite_FlickerMove).w

; =============== S U B R O U T I N E =======================================

BossBall_GetWaitTime:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	.time(pc,d0.w),objoff_2E(a0)
		rts
; ---------------------------------------------------------------------------

.time	dc.w 10*2, 20*2, 28*2, 36*2, 44*2, 60*2						; we've slowed the ball down, now we need twice as much time

; ---------------------------------------------------------------------------
; Chain
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossBall_Chain:

		; init
		lea	ObjDat_BossBall_Chain(pc),a1
		jsr	(SetUp_ObjAttributes).w
		ori.b	#setBit(render_flags.static_mappings),render_flags(a0)		; set static mapping flag
		bsr.s	BossBall_GetWaitTime
		move.l	#.down,address(a0)

.down
		addq.w	#1,y_pos(a0)
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.l	#.circular,address(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.circular
		movea.w	parent3(a0),a1							; load crane address
		move.b	objoff_3C(a1),objoff_3C(a0)					; angle
		moveq	#4,d2								; radius
		jsr	(MoveSprite_CircularSimple).w

.draw
		moveq	#0,d0								; set index velocity
		jmp	(Child_Draw_Sprite_FlickerMove).w

; ---------------------------------------------------------------------------
; Ball
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossBall_Ball:

		; init
		lea	ObjDat_BossBall_Ball(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	objoff_3A(a0)							; reset DPLC frame
		bsr.s	BossBall_GetWaitTime
		move.l	#.down,address(a0)

.down
		addq.w	#1,y_pos(a0)
		subq.w	#1,objoff_2E(a0)
		bpl.s	.angle
		move.b	#$F|collision_flags.npc.hurt,collision_flags(a0)		; set collision
		move.l	#.wait,address(a0)

.wait
		movea.w	parent4(a0),a1							; load boss address
		btst	#2,obBGB_Status(a1)						; wait boss attack flag
		beq.s	.circular
		move.l	#.circular,address(a0)

.circular
		movea.w	parent3(a0),a1							; load crane address
		move.b	objoff_3C(a1),objoff_3C(a0)					; angle
		moveq	#3,d2								; radius
		jsr	(MoveSprite_CircularSimple).w

.angle

		; set angle frame
		movea.w	parent3(a0),a1							; load crane address
		move.b	objoff_3C(a1),d0
		addq.b	#3,d0								; fix angle
		andi.b	#$3F,d0
		lsr.b	#3,d0								; division by 8 (0-7 frames)
		not.b	anim_frame(a0)							; 0 or -1
		bne.s	.setframe
		moveq	#8,d0								; shiny frame

.setframe
		move.b	d0,mapping_frame(a0)

		; draw
		lea	PLCPtr_BossBall_Ball(pc),a2
		jsr	(Perform_DPLC).w
		moveq	#0,d0								; set index velocity
		jmp	(Child_DrawTouch_Sprite_FlickerMove).w

; ---------------------------------------------------------------------------
; Scaled (Intro)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossBall_Scaled:

		; init
		lea	ObjDat_BossBall_Scaled(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#render_flags.x_flip,render_flags(a0)
		st	objoff_41(a0)							; reset prev scale factor
		move.w	#$3F,objoff_2E(a0)
		move.l	#words_to_long($300,$200),x_vel(a0)
		move.w	#tiles_to_bytes($340),objoff_3A(a0)				; VRAM
		move.l	#.wait,address(a0)
		move.l	#ArtScaled_RobotnikGHZ,d0					; art pointer
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w				; is Knuckles?
		blo.s	.notKnux							; if not, branch
		move.l	#ArtScaled_EggRoboGHZ,d0					; art pointer

.notKnux
		move.l	d0,objoff_42(a0)						; set art pointer

.wait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.scale
		move.l	#.main,address(a0)

.main
		subi.w	#$40,y_vel(a0)
		cmpi.b	#$10,objoff_40(a0)
		beq.s	.frame
		addq.b	#1,objoff_40(a0)
		cmpi.b	#4,objoff_40(a0)
		bne.s	.frame
		move.w	#priority_4,priority(a0)

.frame
		moveq	#1,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	.scale
		cmpi.b	#5,objoff_20(a0)
		bhs.s	.scale
		addq.b	#1,objoff_20(a0)						; next frame

.scale
		moveq	#0,d0
		move.b	objoff_40(a0),d0						; get current scale factor
		cmp.b	objoff_41(a0),d0						; check previous scale factor
		beq.s	.draw
		move.b	d0,objoff_41(a0)						; save current scale factor
		jsr	(Perform_Art_Scaling).l

.draw

		; play continuous sfx
		sfxcont	sfx_RobotnikSiren,7						; play robotnik siren sound every 8th frame

		; check delete
		out_of_yrange.s	.delete
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete

		; restore chunks
		QueueKosPlus	GHZ3_128x128_KosP, RAM_start

		; update time counter
		move.b	#1,(Update_HUD_timer).w

		; delete
		move.l	#Load_GHZ3Boss,(Level_data_addr_RAM.Resize).w
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BossBall_Crane:		subObjData Map_GiantBall_Crane, $494, 0, 0, 16, 16, 6, 0, 0
ObjDat_BossBall_Chain:		subObjData Map_GiantBall_Crane, $498, 0, 0, 16, 16, 6, 0, 0
ObjDat_BossBall_Ball:		subObjData Map_GiantBall, $49C, 2, 0, 64, 64, 5, 0, 0
ObjDat_BossBall_Scaled:		subObjData Map_ScaledArt, $340, 0, 0, 128, 128, 1, 0, 0

; dplc
PLCPtr_BossBall_Ball:		dc.l dmaSource(ArtUnc_GiantBall), DPLC_GiantBall

Child9_GHZBall:
		dc.w 6-1
		dc.l Obj_BossBall_Crane		; 0
		dcb.l 4, Obj_BossBall_Chain	; 2-8
		dc.l Obj_BossBall_Ball		; A

PLC_BossBall: plrlistheader
		plreq $380, ArtKosPM_RobotnikShip2
		plreq $494, ArtKosPM_BossCrane
		plreq $500, ArtKosPM_BossExplosion
PLC_BossBall_end
; ---------------------------------------------------------------------------

		include "Objects/Bosses/GHZ3/Object Data/Map - Giant Ball Crane.asm"
		include "Objects/Bosses/GHZ3/Object Data/Map - Giant Ball.asm"
		include "Objects/Bosses/GHZ3/Object Data/DPLC - Giant Ball.asm"
