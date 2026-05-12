; ---------------------------------------------------------------------------
; Boss Water (LZ3)
; Object 77 - Eggman (LZ)
; ---------------------------------------------------------------------------

; xypos
bosswater.xpos =			$1FE0
bosswater.ypos =			$C0

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

bosswater.origX				ds.l 1						; original x-axis position (4 bytes)
					ds.b 6						; skip wait_addr, state_flags and count (6 bytes)
bosswater.origY				ds.l 1						; original y-axis position (4 bytes)
bosswater.timer				ds.b 1						; (1 byte)
bosswater.counter			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_BossWater:

.hitcount =	8

		; don't load the objects until the art has been loaded
		tst.w	(KosPlus_modules_left).w
		bne.s	BossWater_MoveUp.return
		move.l	#BossWater_Setup2,code_addr(a0)

		; init
		lea	ObjDat_BossWater_ShipGlass(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w							; set boss flag
		move.w	x_pos(a0),bosswater.origX(a0)
		move.w	y_pos(a0),bosswater.origY(a0)
		move.b	#.hitcount,collision_property(a0)				; set hits
		move.l	#BossWater_MoveUp,wait_addr(a0)
		move.w	#bosswater.xpos,(Camera_saved_min_X_pos).w
		move.w	#bosswater.ypos,(Camera_saved_min_Y_pos).w

		; create
		lea	Child1_MakeRoboShipFlame(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_MakeRoboHead4(pc),a2
		jmp	(CreateChild1_Normal).w

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossWater_MoveUp:
		move.w	x_pos(a2),d0
		moveq	#-$40,d1
		add.w	(Camera_saved_min_X_pos).w,d1
		cmp.w	d1,d0
		blo.s	.return
		move.l	#words_to_long($60,-$180),x_vel(a0)
		move.l	#BossWater_MoveRight,wait_addr(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossWater_MoveRight:
		moveq	#-2,d0
		moveq	#$68,d1
		add.w	(Camera_saved_min_X_pos).w,d1
		cmp.w	bosswater.origX(a0),d1
		bhs.s	.loc_17FB6
		move.w	d1,bosswater.origX(a0)
		clr.w	x_vel(a0)
		addq.w	#1,d0

.loc_17FB6
		move.w	(Camera_saved_min_Y_pos).w,d1
		addi.w	#$440,d1
		cmp.w	bosswater.origY(a0),d1
		blt.s	.loc_17FCA
		move.w	d1,bosswater.origY(a0)
		clr.w	y_vel(a0)
		addq.w	#1,d0

.loc_17FCA
		bne.s	.return
		move.l	#words_to_long($140,-$200),x_vel(a0)
		move.l	#BossWater_MoveUp2,wait_addr(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossWater_MoveUp2:
		moveq	#-2,d0
		move.w	(Camera_saved_min_X_pos).w,d1
		addi.w	#$90,d1
		cmp.w	bosswater.origX(a0),d1
		bhs.s	.loc_17FF6
		move.w	d1,bosswater.origX(a0)
		clr.w	x_vel(a0)
		addq.w	#1,d0

.loc_17FF6
		move.w	(Camera_saved_min_Y_pos).w,d1
		addi.w	#$400,d1
		cmp.w	bosswater.origY(a0),d1
		blt.s	.loc_1800A
		move.w	d1,bosswater.origY(a0)
		clr.w	y_vel(a0)
		addq.w	#1,d0

.loc_1800A
		bne.s	.return
		move.w	#-$180,y_vel(a0)
		move.l	#BossWater_Setup,code_addr(a0)
		move.l	#BossWater_MoveSwing,wait_addr(a0)
		clr.b	angle(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossWater_MoveSwing:
		moveq	#$40,d1
		add.w	(Camera_saved_min_Y_pos).w,d1
		cmp.w	bosswater.origY(a0),d1
		blt.s	.loc_1804E
		move.w	d1,bosswater.origY(a0)
		move.l	#words_to_long($140,-$80),x_vel(a0)
		tst.b	bosswater.counter(a0)
		beq.s	.loc_18046
		asl.w	x_vel(a0)
		asl.w	y_vel(a0)

.loc_18046
		move.l	#BossWater_MoveUp3,wait_addr(a0)
		move.l	#BossWater_Setup2,code_addr(a0)
		rts
; ---------------------------------------------------------------------------

.loc_1804E
		bset	#render_flags.x_flip,render_flags(a0)
		addq.b	#2,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		tst.w	d1
		bpl.s	.loc_1806C
		bclr	#render_flags.x_flip,render_flags(a0)

.loc_1806C
		asr.w	#4,d0
		swap	d0
		clr.w	d0
		add.l	bosswater.origX(a0),d0
		swap	d0
		move.w	d0,x_pos(a0)

		; check
		move.w	y_vel(a0),d0
		move.w	y_pos(a2),d1
		sub.w	y_pos(a0),d1
		blo.s	.loc_180A2
		subi.w	#72,d1
		blo.s	.loc_180A2
		asr.w	d0
		subi.w	#40,d1
		blo.s	.loc_180A2
		asr.w	d0
		subi.w	#40,d1
		blo.s	.loc_180A2
		moveq	#0,d0

.loc_180A2
		ext.l	d0
		asl.l	#8,d0
		tst.b	bosswater.counter(a0)
		beq.s	.loc_180AE
		add.l	d0,d0

.loc_180AE
		add.l	d0,bosswater.origY(a0)
		move.w	bosswater.origY(a0),y_pos(a0)
		rts
; ---------------------------------------------------------------------------

BossWater_MoveUp3:
		moveq	#-2,d0
		move.w	(Camera_saved_min_X_pos).w,d1
		addi.w	#$16C,d1
		cmp.w	bosswater.origX(a0),d1
		bhs.s	.loc_180D2
		move.w	d1,bosswater.origX(a0)
		clr.w	x_vel(a0)
		addq.w	#1,d0

.loc_180D2
		move.w	(Camera_saved_min_Y_pos).w,d1
		cmp.w	bosswater.origY(a0),d1
		blt.s	.loc_180E6
		move.w	d1,bosswater.origY(a0)
		clr.w	y_vel(a0)
		addq.w	#1,d0

.loc_180E6
		bne.s	.return
		move.l	#BossWater_MoveUp4,wait_addr(a0)
		bclr	#render_flags.x_flip,render_flags(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossWater_MoveUp4:
		tst.b	bosswater.counter(a0)
		bne.s	.loc_18112
		move.w	(Camera_saved_min_X_pos).w,d1
		addi.w	#$E8,d1
		cmp.w	x_pos(a2),d1
		bgt.s	.return
		moveq	#$30,d1
		add.w	(Camera_saved_min_Y_pos).w,d1
		cmp.w	y_pos(a2),d1
		blt.s	.return
		move.b	#50,bosswater.timer(a0)

.loc_18112
		music	mus_LZ								; play LZ music
		bset	#render_flags.x_flip,render_flags(a0)
		move.l	#BossWater_MoveUp5,wait_addr(a0)

		; flags
		st	(Last_act_end_flag).w
		st	(Level_results_flag).w

		; set lower y-boundary
		move.w	#224,d0
		move.w	d0,(Camera_max_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

.return
		rts
; ---------------------------------------------------------------------------

BossWater_MoveUp5:
		tst.b	bosswater.counter(a0)
		bne.s	.loc_18136
		subq.b	#1,bosswater.timer(a0)
		bne.s	.return

.loc_18136
		clr.b	bosswater.timer(a0)
		move.l	#words_to_long($400,-$40),x_vel(a0)
		move.l	#BossWater_MoveUp6,wait_addr(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossWater_MoveUp6:
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$1A0,d0
		cmp.w	x_pos(a0),d0
		blt.s	.delete
		rts
; ---------------------------------------------------------------------------

.delete

		; return
		move.l	#LZ3_Resize.after_boss,(Level_data_addr_RAM.Resize).w

		; remove Robotnik head and fire
		bset	#5,state_flags(a0)
		clr.b	(Boss_flag).w

		; fix palette
		moveq	#0,d0
		jsr	(BossFlash2).w

		; delete
		jmp	(Go_Delete_Object_3).w

; ---------------------------------------------------------------------------
; Setup
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossWater_Setup2:
		movem.w	x_vel(a0),d0-d1							; load xy speed
		asl.l	#8,d0								; shift velocity to line up with the middle 16 bits of the 32-bit position
		asl.l	#8,d1								; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,bosswater.origX(a0)						; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
		add.l	d1,bosswater.origY(a0)						; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
		move.w	bosswater.origX(a0),x_pos(a0)
		move.w	bosswater.origY(a0),y_pos(a0)

BossWater_Setup:
		lea	(Player_1).w,a2							; a2=character

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossWater_MainProcess:
		pea	(Draw_And_Touch_Sprite).w

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		; check touch
		tst.b	bosswater.counter(a0)
		bne.s	.return
		tst.b	status(a0)							; bit 7
		bmi.s	BossWater_Defeated						; branch, if boss is defeated
		tst.b	collision_type(a0)						; are boss's collisions enabled?
		bne.s	.return								; if yes, branch
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
		move.b	boss_saved_collision(a0),collision_type(a0)			; if invincibility ended, allow collision again

.return
		rts

; ---------------------------------------------------------------------------
; Defeated
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossWater_Defeated:
		st	bosswater.counter(a0)						; don't touch the boss anymore

		; create explosion
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.notfree
		move.w	#4,subtype(a1)

.notfree
		clr.b	(Update_HUD_timer).w
		jmp	(BossDefeated_NoTime).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_BossWater_ShipGlass:	subObjData Map_RobotnikShip, $1F0, 1, FALSE, 64, 64, 4, 7, collision_type.npc.touch, 48, 48

PLC_BossWater: plrlistheader
		plreq $1F0, ArtKosPlusM_RobotnikShip2
		plreq $500, ArtKosPlusM_BossExplosion
		plrlistend
