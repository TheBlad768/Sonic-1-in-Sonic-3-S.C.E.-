; ---------------------------------------------------------------------------
; Boss SpikeBall (SLZ3)
; Object 7A - Eggman (SLZ)
; ---------------------------------------------------------------------------

; Hits
BossSpikeBall_Hits			= 8

; Dynamic object variables
obBSB_Timer				= objoff_2E	; .w
obBSB_Jump				= objoff_34	; .l

; =============== S U B R O U T I N E =======================================

Obj_BossSpikeBall:

		; don't load the objects until the art has been loaded
		tst.w	(KosPlus_modules_left).w
		bne.s	BossSpikeBall_MoveLeft.return
		move.l	#BossSpikeBall_Setup3,address(a0)

		; init
		lea	ObjDat_BossSpikeBall_Ship(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#BossSpikeBall_Hits,collision_property(a0)			; set hits
		move.w	#-$100,x_vel(a0)						; set move left
		move.l	#BossSpikeBall_MoveLeft,obBSB_Jump(a0)

		; create
		lea	Child1_MakeRoboHead4(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_MakeRoboShipFlame(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_BossSpikeBall_ShipTube(pc),a2
		jsr	(CreateChild1_Normal).w
		jmp	(Swing_Setup1).w

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossSpikeBall_MoveLeft:
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$120+1,d0
		cmp.w	x_pos(a0),d0
		bne.s	.return
		move.l	#BossSpikeBall_MoveLeftRight,obBSB_Jump(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossSpikeBall_MoveRestore:
		move.l	#BossSpikeBall_Setup3,address(a0)
		move.l	#BossSpikeBall_MoveLeftRight,obBSB_Jump(a0)

BossSpikeBall_MoveLeftRight:
		move.w	(Camera_max_X_pos).w,d0
		move.w	#$200,x_vel(a0)
		btst	#render_flags.x_flip,render_flags(a0)
		bne.s	.notflipx
		neg.w	x_vel(a0)
		addq.w	#8,d0
		cmp.w	x_pos(a0),d0
		blt.s	.exit
		bra.s	.setflipx

.notflipx
		addi.w	#320-8,d0
		cmp.w	x_pos(a0),d0
		bgt.s	.exit

.setflipx
		bchg	#render_flags.x_flip,render_flags(a0)

.exit

		; load seesaw address
		lea	(Boss_events+6).w,a1

		moveq	#80/2,d1
		tst.w	x_vel(a0)
		bpl.s	.notleft
		neg.w	d1

.notleft
		movea.w	-(a1),a2							; get seesaw #3 address to a2
		bsr.s	.checkpos
		movea.w	-(a1),a2							; get seesaw #2 address to a2
		bsr.s	.checkpos
		movea.w	-(a1),a2							; get seesaw #1 address to a2

.checkpos

		; check slot
		tst.w	(a1)								; is seesaw address enabled?
		bpl.s	.return								; if not, branch

		; check players standing
		moveq	#standing_mask,d0
		and.b	status(a2),d0							; is player 1 or player 2 standing on the seesaw?
		bne.s	.return								; if yes, branch

		; check
		move.w	x_pos(a2),d3
		add.w	d1,d3
		sub.w	x_pos(a0),d3
		beq.s	.found

.return
		rts
; ---------------------------------------------------------------------------

.found
		move.w	a1,parent2(a0)							; save seesaw address buffer
		move.w	a2,parent3(a0)							; save found seesaw address
		move.l	#BossSpikeBall_Setup,address(a0)
		move.l	#BossSpikeBall_MakeBall,obBSB_Jump(a0)
		rts
; ---------------------------------------------------------------------------

BossSpikeBall_MakeBall:

		; load spikeball object
		sfx	sfx_MissileThrow
		lea	Child1_BossSpikeBall_SpikeBall(pc),a2
		jsr	(CreateChild10_NormalAdjusted).w
		bne.s	.nofree
		move.w	a0,parent4(a1)							; save boss address
		move.w	parent2(a0),parent2(a1)						; save seesaw address buffer
		movea.w	parent3(a0),a2							; load found seesaw address
		move.b	status(a2),status(a1)
		move.w	a2,parent3(a1)

.nofree

		; wait
		move.w	#40-1,obBSB_Timer(a0)						; set wait

		; back
		move.l	#BossSpikeBall_MoveRestore,obBSB_Jump(a0)
		rts

; ---------------------------------------------------------------------------
; Setup
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossSpikeBall_Setup3:
		jsr	(Swing_UpAndDown).w

BossSpikeBall_Setup2:
		jsr	(MoveSprite2).w

BossSpikeBall_Setup:
		jsr	(Obj_Wait).w

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossSpikeBall_MainProcess:
		pea	(Draw_And_Touch_Sprite).w

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		; check touch
		tst.b	collision_flags(a0)						; are boss's collisions enabled?
		bne.s	.return								; if yes, branch
		tst.b	collision_property(a0)						; has boss run out of hits?
		beq.s	BossSpikeBall_Defeated						; if yes, branch
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

BossSpikeBall_Defeated:
		move.l	#Wait_FadeToLevelMusic,address(a0)
		move.l	#.explosion,obBSB_Jump(a0)
		clr.l	x_vel(a0)
		move.b	#$F,mapping_frame(a0)						; set the broken frame

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
		addi.w	#$1D0,d0
		move.w	d0,(Camera_stored_max_X_pos).w

.notfree3
		bset	#render_flags.x_flip,render_flags(a0)
		move.l	#words_to_long($400,0),x_vel(a0)

		; return
		move.l	#End_SLZ3Boss,(Level_data_addr_RAM.Resize).w

		; restore pylon
		moveq	#1,d1								; current slot priority
		move.l	#Render_Pylon,d0
		jsr	(AddSlot_ExtraRender).w

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
		addi.w	#$B0,d0
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

		; delete
		jmp	(Go_Delete_Sprite_3).w

; ---------------------------------------------------------------------------
; Boss SpikeBall tube (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossSpikeBall_ShipTube:

		; init
		lea	ObjDat_BossSpikeBall_ShipTube(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,address(a0)

.main
		jsr	(Refresh_ChildPositionAdjusted).w

		; draw
		movea.w	parent3(a0),a1							; a1=parent object (boss)

		; check defeated flag
		btst	#status.npc.defeated,status(a1)
		bne.s	.delete
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete

		; create pieces
		lea	Child6_BossSpikeBall_ShipTubePieces(pc),a2
		jsr	(CreateChild6_Simple).w

		; delete
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Boss SpikeBall tube pieces (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossSpikeBall_ShipTubePieces:

		; init
		lea	ObjDat_BossSpikeBall_ShipTube(pc),a1
		jsr	(SetUp_ObjAttributes).w
		jsr	(Change_FlipXUseParent).w
		move.l	#Obj_FlickerMove,address(a0)
		move.b	subtype(a0),d0
		lsr.b	d0								; division by 2
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		moveq	#2<<2,d0							; set index velocity
		jsr	(Set_IndexedVelocity).w
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 7B - exploding spikeys that Eggman drops (SLZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossSpikeBall_SpikeBall:

		; disable
		movea.w	parent2(a0),a1							; load seesaw address buffer
		bclr	#7,(a1)								; disable seesaw address

		; init
		lea	ObjDat_See_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.fall,address(a0)
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		move.w	x_pos(a1),see_origX(a0)
		move.w	y_pos(a1),see_origY(a0)
		bset	#status.npc.x_flip,status(a0)
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		bgt.s	.fall
		bclr	#status.npc.x_flip,status(a0)
		move.b	#2,see_frame(a0)

.fall
		pea	.draw(pc)
		jsr	(MoveSprite).w
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		lea	See_Speeds(pc),a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	x_pos(a0),d1
		sub.w	see_origX(a0),d1
		bhs.s	.leftside
		addq.w	#2,d0

.leftside
		add.w	d0,d0
		move.w	see_origY(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	y_pos(a0),d1
		bgt.w	.locret_18EA8
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		moveq	#2,d1
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		moveq	#0,d1

.notflipx
		move.w	#$F0,objoff_2E(a0)						; timer
		move.b	#10,anim_frame(a0)						; set frame duration to 10 frames
		move.b	anim_frame(a0),anim_frame_timer(a0)
		bra.w	.spring
; ---------------------------------------------------------------------------

.loc_18DC6
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		moveq	#0,d0
		move.b	see_frame(a0),d0
		sub.b	see_frame(a1),d0
		beq.s	.loc_18E2A
		bhs.s	.loc_18DDA
		neg.b	d0

.loc_18DDA
		move.l	#words_to_long(-$114,-$818),d1					; x_vel + y_vel
		cmpi.b	#1,d0
		beq.s	.loc_18E00
		move.l	#words_to_long(-$F4,-$960),d1					; x_vel + y_vel
		cmpi.w	#$9C0,see_speed(a1)
		blt.s	.loc_18E00
		move.l	#words_to_long(-$80,-$A20),d1					; x_vel + y_vel

.loc_18E00
		move.l	d1,x_vel(a0)
		move.w	x_pos(a0),d0
		sub.w	see_origX(a0),d0
		bhs.s	.leftside1
		neg.w	x_vel(a0)

.leftside1
		move.b	#1,mapping_frame(a0)
		move.w	#$20,objoff_2E(a0)						; timer
		move.l	#.loc_18EAA,address(a0)
		bra.w	.loc_18EAA
; ---------------------------------------------------------------------------

.loc_18E2A
		lea	See_Speeds(pc),a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		moveq	#$28,d2
		move.w	x_pos(a0),d1
		sub.w	see_origX(a0),d1
		bhs.s	.leftside2
		neg.w	d2
		addq.w	#2,d0

.leftside2
		add.w	d0,d0
		move.w	see_origY(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,y_pos(a0)
		add.w	see_origX(a0),d2
		move.w	d2,x_pos(a0)
		clr.w	y_pos+2(a0)
		clr.w	x_pos+2(a0)
		subq.w	#1,objoff_2E(a0)
		bne.s	.loc_18E7A
		move.w	#$20,objoff_2E(a0)						; timer
		move.l	#BossSpikeBall_SpikeBall_Explode,address(a0)
		rts
; ---------------------------------------------------------------------------

.loc_18E7A
		pea	.draw(pc)
		cmpi.w	#2*60,objoff_2E(a0)
		bne.s	.loc_18E88
		move.b	#5,anim_frame(a0)						; set frame duration to 5 frames

.loc_18E88
		cmpi.w	#1*60,objoff_2E(a0)
		bne.s	.loc_18E96
		move.b	#2,anim_frame(a0)						; set frame duration to 2 frames

.loc_18E96
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.locret_18EA8							; if time remains, branch
		move.b	anim_frame(a0),anim_frame_timer(a0)				; reset timer
		bchg	#0,mapping_frame(a0)						; change frame

.locret_18EA8
		rts
; ---------------------------------------------------------------------------

.xydata
		dc.w -32, 64	; xpos
		dc.w -32, 64	; ypos
; ---------------------------------------------------------------------------

.loc_18EAA
		movea.w	parent4(a0),a1							; a1=parent object (boss)

		; check touch and defeated
		moveq	#signextendB( \
			setBit(status.npc.touch) | \
			setBit(status.npc.defeated) \
		),d0

		and.b	status(a1),d0							; boss get hit or defeated?
		bne.s	.loc_18F38							; if yes, branch

		; check
		lea	.xydata(pc),a2
		jsr	(Check_InTheirRange).w
		beq.s	.loc_18F38
		move.l	#BossSpikeBall_SpikeBall_Explode,address(a0)
		clr.w	objoff_2E(a0)							; timer
		move.b	collision_flags(a1),boss_backup_collision(a1)
		clr.b	collision_flags(a1)
		subq.b	#1,collision_property(a1)
		bne.s	.loc_18F38
		bset	#status.npc.defeated,status(a1)
		clr.l	x_vel(a0)

.loc_18F38
		tst.w	y_vel(a0)							; is spikeball falling down?
		bpl.s	.loc_18F5C							; if yes, branch
		jsr	(MoveSprite).w
		moveq	#-47,d0
		add.w	see_origY(a0),d0
		cmp.w	y_pos(a0),d0
		bgt.s	.loc_18F58
		jsr	(MoveSprite).w

.loc_18F58
		bra.w	.loc_18E7A
; ---------------------------------------------------------------------------

.loc_18F5C
		jsr	(MoveSprite).w
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		lea	See_Speeds(pc),a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	x_pos(a0),d1
		sub.w	see_origX(a0),d1
		bhs.s	.loc_18F7E
		addq.w	#2,d0

.loc_18F7E
		add.w	d0,d0
		move.w	see_origY(a0),d1						; d1 = bottom of seesaw y position
		add.w	(a2,d0.w),d1							; + offset for current angle
		cmp.w	y_pos(a0),d1							; return if y position < d1
		bgt.s	.loc_18F58
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		moveq	#2,d1
		tst.w	x_vel(a0)
		bmi.s	.loc_18F9C
		moveq	#0,d1

.loc_18F9C
		clr.w	objoff_2E(a0)							; timer

.spring
		move.b	d1,see_frame(a1)
		move.b	d1,see_frame(a0)
		cmp.b	mapping_frame(a1),d1
		beq.s	.clear

		; launch main character if stood on seesaw
		lea	(Player_1).w,a2							; a2=character
		bclr	#p1_standing_bit,status(a1)
		beq.s	.notplayer1
		bsr.s	BossSpikeBall_SpikeBall_LaunchCharacter

.notplayer1

		; launch sidekick if stood on seesaw
		lea	(Player_2).w,a2							; a2=character
		bclr	#p2_standing_bit,status(a1)
		beq.s	.clear
		bsr.s	BossSpikeBall_SpikeBall_LaunchCharacter

.clear
		clr.l	x_vel(a0)							; clear ball velocity

		; load routine
		move.l	#.loc_18DC6,d0
		cmpi.l	#.fall,address(a0)
		beq.s	.skipr
		move.l	#BossSpikeBall_SpikeBall_Explode,d0

.skipr
		move.l	d0,address(a0)
		bra.w	.loc_18E7A
; ---------------------------------------------------------------------------

.draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	see_origX(a0),d0						; get object position
		jmp	(Sprite_CheckDeleteTouch3.skipxpos).w

; =============== S U B R O U T I N E =======================================

BossSpikeBall_SpikeBall_LaunchCharacter:
		move.w	y_vel(a0),y_vel(a2)						; set character y velocity to inverse of sol
		neg.w	y_vel(a2)							; y velocity
		cmpi.b	#1,mapping_frame(a1)
		bne.s	.loc_18FDC
		asr.w	y_vel(a2)

.loc_18FDC
		bset	#status.player.in_air,status(a2)				; set character airborne flag
		bclr	#status.player.on_object,status(a2)				; clear character on object flag
		clr.b	jumping(a2)							; clear character jumping flag
		clr.b	spin_dash_flag(a2)						; clear spin dash flag

		; set
		move.w	a0,-(sp)
		movea.w	a2,a0
		lea	(SonicKnux_ChkRoll).l,a3					; Sonic/Knux
		cmpi.b	#PlayerID_Tails,character_id(a0)				; is player Tails?
		bne.s	.proll								; if not, branch

.troll		:= Tails_ChkRoll-SonicKnux_ChkRoll					; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.troll)(a3),a3							; Tails

.proll
		jsr	(a3)
		movea.w	(sp)+,a0
		move.b	#PlayerID_Control,routine(a2)					; set character to airborne state
		sfx	sfx_Spring,1							; play spring sound

; =============== S U B R O U T I N E =======================================

BossSpikeBall_SpikeBall_Explode:

		; enable
		movea.w	parent2(a0),a1							; load seesaw address buffer
		bset	#7,(a1)								; enable seesaw address

		; remove
		jsr	(Go_Delete_Sprite).w

		; explosion
		lea	(Child6_MakeBossExplosion1).l,a2
		jsr	(CreateChild6_Simple).w

		; check
		cmpi.w	#32,objoff_2E(a0)						; timer
		beq.s	.makefrag
		rts
; ---------------------------------------------------------------------------

.makefrag
		move.w	see_origY(a0),y_pos(a0)

		; load spikeball shrapnel object
		lea	Child6_BossSpikeBall_SpikeBall_Shrapnel(pc),a2
		jmp	(CreateChild6_Simple).w

; ---------------------------------------------------------------------------
; Object 7B - shrapnel from spikeball (SLZ)
; ---------------------------------------------------------------------------

BossSpikeBall_FragSpeed:		; xyvel
		dc.w -$100, -$340	; 0
		dc.w -$A0, -$240	; 4
		dc.w $100, -$340	; 8
		dc.w $A0, -$240		; C

; =============== S U B R O U T I N E =======================================

Obj_BossSpikeBall_SpikeBall_Shrapnel:

		; set xyvel
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.l	BossSpikeBall_FragSpeed(pc,d0.w),x_vel(a0)

		; init
		lea	ObjDat_RobotnikShip_SpikeBall_Shrapnel(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.all_shields,shield_reaction(a0)		; bounce off all shields
		move.l	#.action,address(a0)
		bset	#render_flags.on_screen,render_flags(a0)

.action
		MoveSprite a0, $18							; make obj fall

		; animate
		moveq	#$A,d0
		btst	#2,(V_int_run_count+3).w					; 0 or 4
		beq.s	.setframe
		addq.b	#1,d0

.setframe
		move.b	d0,mapping_frame(a0)
		jmp	(Sprite_CheckDeleteTouchXY).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BossSpikeBall_Ship:			subObjData Map_RobotnikShip, $3B0, 1, 0, 64, 64, 4, $C, $F|collision_flags.npc.touch
ObjDat_BossSpikeBall_ShipTube:			subObjData Map_BossSpikeBall_Tube, $440, 1, 0, 8, 32, 3, 0, 0
ObjDat_RobotnikShip_SpikeBall_Shrapnel:		subObjData Map_Bomb, $4C1, 0, 1, 8, 8, 2, $A, $18|collision_flags.npc.hurt

Child1_BossSpikeBall_ShipTube:
		dc.w 1-1
		dc.l Obj_BossSpikeBall_ShipTube
		dc.b 0, 16
Child1_BossSpikeBall_SpikeBall:
		dc.w 1-1
		dc.l Obj_BossSpikeBall_SpikeBall
		dc.b -1, 8
Child6_BossSpikeBall_SpikeBall_Shrapnel:
		dc.w 4-1
		dc.l Obj_BossSpikeBall_SpikeBall_Shrapnel
Child6_BossSpikeBall_ShipTubePieces:
		dc.w 4-1
		dc.l Obj_BossSpikeBall_ShipTubePieces

PLC_BossSpikeBall: plrlistheader
		plreq $3B0, ArtKosPM_RobotnikShip2
		plreq $440, ArtKosPM_BossSpikeBallTube
		plreq $4C1, ArtKosPM_Bomb
		plreq $500, ArtKosPM_BossExplosion
PLC_BossSpikeBall_end
; ---------------------------------------------------------------------------

		include "Objects/Bosses/SLZ3/Object Data/Map - Tube.asm"
