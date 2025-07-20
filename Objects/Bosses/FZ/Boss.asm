; ---------------------------------------------------------------------------
; Boss Final (FZ)
; Object 85 - Eggman (FZ)
; ---------------------------------------------------------------------------

; Hits
BossFinal_Hits				= 8

; Dynamic object variables
obBFZ_Timer				= objoff_2E	; .w

obBFZ_Jump				= objoff_34	; .l
obBFZ_Count				= objoff_39	; .w
obBFZ_DPLC				= objoff_3A	; .b

obBFZ_PlasmaBall			= objoff_48	; .w

; =============== S U B R O U T I N E =======================================

Obj_BossFinal:

		; init
		lea	ObjDat_BossFZEggman(pc),a1					; load Eggman data
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w			; is Knuckles?
		bne.s	.notKnux							; if not, branch
		lea	ObjDat_BossFZEggRobo(pc),a1					; load Egg Robo data

.notKnux
		jsr	(SetUp_ObjAttributes).w
		st	obBFZ_DPLC(a0)							; reset DPLC frame
		st	(Boss_flag).w
		move.l	(V_int_run_count).w,(RNG_seed).w				; set to RNG for more RNG
		move.b	#BossFinal_Hits,collision_property(a0)				; set hits
		move.l	#BossFinal_Setup,address(a0)
		move.l	#BossFinal_WaitXpos,obBFZ_Jump(a0)
		move.b	#1,anim(a0)							; set laugh anim

		; load plasma ball launcher
		lea	Child6_BossPlasma(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFinal_Setup
		move.w	a1,parent2(a0)							; save Plasma address

		; set xypos
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#320-24,d0
		move.w	d0,x_pos(a1)
		moveq	#44,d0
		add.w	(Camera_min_Y_pos).w,d0
		move.w	d0,y_pos(a1)

		; load cylinders
		lea	Child6_EggmanCylinder(pc),a2
		jsr	(CreateChild6_Simple).w

BossFinal_Setup:
		movea.l	obBFZ_Jump(a0),a1
		jsr	(a1)
		addq.w	#7,(RNG_seed).w
		bra.w	BossFinal_MainProcess

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinal_WaitXpos:

		; don't load the objects until the art has been loaded
		tst.w	(KosPlus_modules_left).w
		bne.s	.return
		move.l	#.checkxpos,obBFZ_Jump(a0)

.checkxpos

		; check xcam
		moveq	#-16,d0
		add.w	(Camera_max_X_pos).w,d0
		cmp.w	(Camera_X_pos).w,d0
		bhs.s	.return
		move.l	#BossFinal_MoveCylinders,obBFZ_Jump(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Cylinders
; ---------------------------------------------------------------------------

BossFinal_CylData:		; crushing cylinder object address (0, 2 address)
		dc.b 0, 2	; 0
		dc.b 2, 4	; 2
		dc.b 4, 6	; 4
		dc.b 6, 0	; 6
BossFinal_Range:
		dc.w -44, 88	; xpos ; 64+24
		dc.w -32, 64	; ypos

; =============== S U B R O U T I N E =======================================

BossFinal_MoveCylinders:

		; jmp
		move.l	#.waitcyl,obBFZ_Jump(a0)

		; calc cylinders address
		jsr	(Random_Number).w
		andi.w	#6,d0								; max 8 cylinders addresses
		move.w	d0,d1
		addq.w	#1,d1								; next cylinder address
		tst.l	d0
		bpl.s	.skip
		exg	d1,d0								; swap cylinders

.skip
		move.b	BossFinal_CylData(pc,d0.w),d0					; 1 cylinder address
		move.b	BossFinal_CylData(pc,d1.w),d1					; 2 cylinder address

		; load cylinders
		lea	(Boss_events).w,a2						; load cylinders address list

		; load cylinder #1
		movea.w	(a2,d0.w),a1
		st	obBFZEC_Enable(a1)
		st	obBFZEC_Grab(a1)						; set grab Eggman

		; load cylinder #2
		movea.w	(a2,d1.w),a1
		st	obBFZEC_Enable(a1)
		clr.b	obBFZEC_Grab(a1)						; set not grab Eggman

		; set
		clr.b	boss_invulnerable_time(a0)
		st	collision_flags(a0)
		move.b	#2,obBFZ_Count(a0)						; set 2 cylinders count
		sfx	sfx_Rumbling

.waitcyl
		tst.b	obBFZ_Count(a0)							; wait end attack cylinders
		bne.s	.flipx
		move.l	#BossFinal_CreatePlasmaBalls,obBFZ_Jump(a0)

.flipx

		; flipx Eggman
		jsr	(Find_SonicObject).w
		bclr	#status.npc.x_flip,status(a0)					; left
		tst.w	d0
		beq.s	.return
		bset	#status.npc.x_flip,status(a0)					; right

.return
		rts

; ---------------------------------------------------------------------------
; Plasma balls
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinal_CreatePlasmaBalls:
		move.l	#.waitpl,obBFZ_Jump(a0)

		; enable plasma ball launcher
		sfx	sfx_Electric							; play sfx
		move.w	parent2(a0),a1							; load plasma ball launcher address
		st	obBFZBP_Enable(a1)						; create plasma balls
		move.b	#1,obBFZ_Count(a0)

.waitpl

		; play continuous sfx
		sfxcont	sfx_Electric,$F							; play electricity sound every 16th frame

		; check end
		tst.b	obBFZ_Count(a0)
		bne.s	.return
		move.l	#BossFinal_MoveCylinders,obBFZ_Jump(a0)				; routine back

.return
		rts

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinal_MainProcess:

		; anim
		lea	Ani_EggmanFZ(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w

		; DPLC
		lea	PLCPtr_ScrapEggman(pc),a2
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w			; is Knuckles?
		bne.s	.notKnux							; if not, branch
		lea	PLCPtr_ScrapEggRobo(pc),a2

.notKnux
		jsr	(Perform_DPLC).w

		; draw
		pea	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		; check touch flag
		tst.b	collision_flags(a0)
		beq.s	.return

		; check touch
		tst.b	boss_invulnerable_time(a0)
		bne.s	.flash

		; check players
		lea	BossFinal_Range(pc),a1
		jsr	(Check_PlayerInRange).w
		tst.l	d0								; check Tails and Sonic address
		beq.s	.return								; if neither player is in range, don't do anything
		tst.w	d0								; is Sonic?
		beq.s	.notp1								; if it's not Sonic, branch
		move.l	d0,-(sp)							; save players address
		bsr.s	.checkhit
		move.l	(sp)+,d0							; restore players address

.notp1
		btst	#status.npc.touch,status(a0)							; Sonic hit the boss?
		bne.s	.return								; if yes, branch
		swap	d0								; get Tails address
		tst.w	d0								; is Tails?
		beq.s	.return								; if not, branch

.checkhit
		movea.w	d0,a1
		jsr	(Check_PlayerAttack).w
		beq.s	.return

		; hurt boss
		subq.b	#1,collision_property(a0)
		beq.s	BossFinal_Defeated

		; set flash anim
		move.b	#100,boss_invulnerable_time(a0)
		sfx	sfx_BossHit
		bset	#status.npc.touch,status(a0)					; set "boss hit" flag

		; bounce player
		bsr.s	.bounce

.flash
		move.b	#2,anim(a0)							; set hurt anim
		subq.b	#1,boss_invulnerable_time(a0)
		bne.s	.return
		bclr	#status.npc.touch,status(a0)					; clear "boss hit" flag
		move.b	#1,anim(a0)							; set laugh anim
		clr.b	collision_flags(a0)

.return
		rts
; ---------------------------------------------------------------------------

.bounce
		move.w	#-$300,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		neg.w	d0

.notflipx
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)

		; check Knuckles
		cmpi.b	#PlayerID_Knuckles,character_id(a1)				; is player Knuckles?
		bne.s	.return2							; if not, return
		cmpi.b	#1,double_jump_flag(a1)						; is Knuckles gliding?
		bne.s	.return2							; if not, return
		move.b	#2,double_jump_flag(a1)						; make him stop gliding
		move.b	#$21,anim(a1)							; put Knuckles in his falling animation

		; decide which direction to make Knuckles face
		bclr	#status.player.x_flip,status(a1)
		tst.w	x_vel(a1)
		bmi.s	.directiondecided
		bset	#status.player.x_flip,status(a1)

.directiondecided
		move.w	default_y_radius(a1),y_radius(a1)				; set default_y_radius and default_x_radius

.return2
		rts

; ---------------------------------------------------------------------------
; Defeated
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFinal_Defeated:

		; bounce player
		bsr.s	BossFinal_MainProcess.bounce

		; start defeated
		move.l	#.defeated,address(a0)
		bset	#status.npc.defeated,status(a0)					; set defeated flag
		move.b	#3,anim(a0)							; set defeated anim
		jmp	(BossDefeated_StopTimer).w
; ---------------------------------------------------------------------------

.defeated

		; wait end attack cylinders
		tst.b	obBFZ_Count(a0)
		bne.w	.draw
		move.l	#.defeatedfall,address(a0)
		move.l	#FZ_Resize.afterboss,(Level_data_addr_RAM.Resize).w
		bset	#status.npc.x_flip,status(a0)					; set flipx
		bset	#4,objoff_38(a0)						; remove plasma ball launcher
		move.b	#9,anim(a0)							; set defeated jump anim

		; set xypos
		move.w	#$27C0,x_pos(a0)
		move.w	#$53C,y_pos(a0)

		; load misc objects
		lea	Child11_BossFinal_AfterBoss(pc),a2
		jsr	(CreateChild11_Simple).w
		bne.s	.defeatedfall
		move.w	a1,parent2(a0)							; save robotnik ship address

.defeatedfall

		; wall for players
		jsr	(Find_SonicTails).w
		move.w	#$2794,d0
		cmp.w	x_pos(a1),d0
		bhs.s	.pwall
		move.w	d0,x_pos(a1)
		clr.w	2+x_pos(a1)
		clr.w	x_vel(a1)
		clr.w	ground_vel(a1)

.pwall
		moveq	#$10,d1
		jsr	(MoveSprite_CustomGravity).w

		; check floor
		move.w	#$59C,d0
		cmp.w	y_pos(a0),d0
		bhs.w	.draw
		move.w	d0,y_pos(a0)
		move.l	#.defeatedfloor,address(a0)
		move.b	#5,anim(a0)							; set run anim
		move.l	#words_to_long($100,-$100),x_vel(a0)				; x_vel + y_vel
		move.w	#priority_5,priority(a0)

.defeatedfloor
		moveq	#$10,d1
		jsr	(MoveSprite_CustomGravity).w

		; check floor
		cmpi.w	#$5A3,y_pos(a0)
		blo.s	.defeatedrun
		move.w	#-$40,y_vel(a0)

.defeatedrun
		jsr	(Find_SonicObject).w
		move.w	#$500,d1							; right
		tst.w	d0								; is player on the right side?
		bne.s	.defeatedruncheck						; if so, branch
		move.w	#$400,d1							; left

		; speed
		subi.w	#112,d2
		blo.s	.defeatedruncheck
		subi.w	#$100,d1
		subq.w	#8,d2
		blo.s	.defeatedruncheck
		subi.w	#$100,d1
		subq.w	#8,d2
		blo.s	.defeatedruncheck
		subi.w	#$80,d1
		subq.w	#8,d2
		blo.s	.defeatedruncheck
		subi.w	#$80,d1
		subq.w	#8,d2
		blo.s	.defeatedruncheck
		subi.w	#$80,d1
		subi.w	#56,d2
		blo.s	.defeatedruncheck
		moveq	#0,d1

.defeatedruncheck
		move.w	d1,x_vel(a0)

		; check robotnik ship
		cmp.w	#$28A0,x_pos(a0)
		blo.s	.draw
		move.l	#.defeatedfallrs,address(a0)
		move.b	#6,anim(a0)							; set jump anim
		move.l	#words_to_long($240,-$4C0),x_vel(a0)				; x_vel + y_vel

.defeatedfallrs

		; check robotnik ship
		cmp.w	#$28E0,x_pos(a0)
		blo.s	.defeatedfallrs2
		clr.w	x_vel(a0)
		move.l	#.defeatedfallrs2,address(a0)

.defeatedfallrs2
		moveq	#$34,d1
		jsr	(MoveSprite_CustomGravity).w

		; check jump
		tst.w	y_vel(a0)
		bmi.s	.draw

		; check floor
		move.w	#$59C,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.defeatedfallrscheck
		move.w	d0,y_pos(a0)
		clr.w	y_vel(a0)

.defeatedfallrscheck
		tst.l	x_vel(a0)							; check xvel and yvel
		bne.s	.draw

		; delete Eggman
		move.l	#Delete_Current_Sprite,address(a0)

		; load robotnik ship address
		movea.w	parent2(a0),a1
		move.l	#Obj_BossFinal_RobotnikShip.main,address(a1)
		rts
; ---------------------------------------------------------------------------

.draw
		; anim
		lea	Ani_EggmanFZ(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w

		; DPLC
		lea	PLCPtr_ScrapEggman(pc),a2
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w			; is Knuckles?
		bne.s	.notKnux							; if not, branch
		lea	PLCPtr_ScrapEggRobo(pc),a2

.notKnux
		jsr	(Perform_DPLC).w

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 85 - control desk (Boss Final)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinal_ControlDesk:

		; set xy
		move.w	#$27B0,x_pos(a0)
		move.w	#$590,y_pos(a0)

		; init
		lea	ObjDat_BossFZControlDesk(pc),a1
		jsr	(SetUp_ObjAttributes).w

		; draw
		lea	(Draw_Sprite).w,a1
		move.l	a1,address(a0)
		jmp	(a1)

; ---------------------------------------------------------------------------
; Object 85 - robotnik ship (Boss Final)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinal_RobotnikShip:

		; set xy
		move.w	#$28E0,x_pos(a0)
		move.w	#$5A0,y_pos(a0)

		; init
		lea	ObjDat_BossFZRobotnikShip(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#render_flags.x_flip,render_flags(a0)
		move.b	#1,collision_property(a0)

		; load robotnik ship stand
		lea	Child1_BossFinal_RobotnikShipStand(pc),a2
		jsr	(CreateChild1_Normal).w

		; draw
		lea	(Draw_Sprite).w,a1
		move.l	a1,address(a0)
		jmp	(a1)
; ---------------------------------------------------------------------------

.main
		sfx	sfx_Rising
		move.w	#-$180,y_vel(a0)
		move.l	#.moveup,address(a0)

		; load fire
		lea	Child1_MakeRoboShipFlame(pc),a2
		jsr	(CreateChild1_Normal).w

		; load head
		lea	Child1_MakeRoboHead4(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	.moveup
		move.b	#-10,child_dy(a1)
		move.w	a1,parent3(a0)

.moveup
		movea.w	parent3(a0),a1							; load head address
		subq.b	#1,child_dy(a1)
		cmpi.b	#-28,child_dy(a1)
		bne.s	.move
		move.l	#.moveupchk,address(a0)

.moveupchk

		move.w	#$550,d0
		cmp.w	y_pos(a0),d0
		blo.s	.move
		move.w	d0,y_pos(a0)
		move.l	#words_to_long($180,-$18),x_vel(a0)				; x_vel + y_vel
		move.l	#.checktouch,address(a0)
		move.b	#$F|collision_flags.npc.touch,collision_flags(a0)

.checktouch
		tst.b	collision_property(a0)
		bne.s	.chkdel
		clr.b	collision_flags(a0)
		bset	#status.npc.defeated,status(a0)					; set defeated flag
		move.l	#.chkdel,address(a0)
		move.w	#$60,y_vel(a0)

		; create explosion
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.chkdel
		move.b	#4,subtype(a1)

.chkdel

		; check delete
		out_of_xrange.s	.delete

.move
		jsr	(MoveSprite2).w

.draw
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

.delete
		move.l	#FZ_Resize.endboss,(Level_data_addr_RAM.Resize).w
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Object 85 - robotnik ship (Boss Final)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinal_RobotnikShipStand:

		; init
		lea	ObjDat_BossFZRobotnikShipStand(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,address(a0)

.main
		movea.w	parent3(a0),a1							; load robotnik ship address
		cmpi.l	#Obj_BossFinal_RobotnikShip.moveup,address(a1)
		bne.s	.draw
		move.l	#.anim,address(a0)
		move.b	#20-1,anim_frame_timer(a0)

.anim

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.draw								; if time remains, branch
		move.b	#20-1,anim_frame_timer(a0)					; reset timer to 20 frames

		; next frame
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		beq.s	.delete

.draw
		jsr	(Refresh_ChildPositionAdjusted).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Object 85 - check players (Boss Final)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFinal_CheckPlayers:
		move.l	#.check,address(a0)

		; get address
		movea.w	parent3(a0),a1							; load robotnik address
		move.w	parent2(a1),parent3(a0)						; save robotnik ship address

.check

		; p1
		lea	(Player_1).w,a1							; a1=character
		lea	(Ctrl_1_logical).w,a2
		lea	(Ctrl_1_locked).w,a3
		bsr.s	.chkpxpos

		; p2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.return								; if yes, branch
		tst.b	render_flags(a1)						; player 2 visible on the screen?
		bpl.s	.return								; if not, branch
		addq.w	#Ctrl_2_logical-Ctrl_1_logical,a2
		addq.w	#Ctrl_2_locked-Ctrl_1_locked,a3

.chkpxpos
		cmpi.w	#$2990,x_pos(a1)
		blt.s	.chkpxcam
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		bne.s	.chkpxcam							; if yes, branch
		clr.w	ground_vel(a1)							; clear ground velocity
		st	(a3)								; set ctrl locked
		move.w	#bytes_to_word(btnUp,0),(a2)					; set ctrl logical
		movea.w	parent3(a0),a4							; load robotnik ship address
		btst	#status.npc.defeated,status(a4)							; is boss defeated?
		beq.s	.chkpxcam							; if not, branch
		clr.w	(a2)								; clear ctrl logical

.chkpxcam
		move.w	#$29E0,d0
		cmp.w	x_pos(a1),d0
		bhi.s	.return
		move.w	d0,x_pos(a1)

.return
		rts

; =============== S U B R O U T I N E =======================================

		include "Objects/Bosses/FZ/Boss Cylinders.asm"
		include "Objects/Bosses/FZ/Boss Plasma Ball Launcher.asm"

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BossFZEggman:			subObjData Map_ScrapEggman, $2B0, 0, 0, 56, 56, 4, 0, 0
ObjDat_BossFZEggRobo:			subObjData Map_ScrapEggRobo, $2B0, 0, 0, 56, 56, 4, 0, 0
ObjDat_BossFZControlDesk:		subObjData Map_EggCyl, $300, 0, 0, 16, 32, 0, $B, 0
ObjDat_BossFZRobotnikShip:		subObjData Map_RobotnikShip, $3A0, 0, 0, 64, 64, 4, $C, 0
ObjDat_BossFZRobotnikShipStand:		subObjData Map_RobotnikShipStand, $420, 0, 0, 24, 56, 3, 0, 0

Child11_BossFinal_AfterBoss:
		dc.w 3-1
		dc.l Obj_BossFinal_CheckPlayers
		dc.l Obj_BossFinal_ControlDesk
		dc.l Obj_BossFinal_RobotnikShip	; always last

Child1_BossFinal_RobotnikShipStand:
		dc.w 1-1
		dc.l Obj_BossFinal_RobotnikShipStand
		dc.b 0, 20
; ---------------------------------------------------------------------------

		include "Objects/Bosses/FZ/Object Data/Anim - Eggman.asm"
