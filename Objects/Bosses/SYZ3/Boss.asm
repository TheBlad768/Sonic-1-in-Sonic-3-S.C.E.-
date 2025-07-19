; ---------------------------------------------------------------------------
; Boss Block (SYZ3)
; Object 75 - Eggman (SYZ)
; ---------------------------------------------------------------------------

; Hits
BossBlock_Hits				= 8

; Dynamic object variables
obBB_Timer				= objoff_2E	; .w
obBB_SaveYpos				= objoff_32	; .w
obBB_Jump				= objoff_34	; .l
obBB_Status				= objoff_38	; .b
obBB_CamXpos				= objoff_39	; .b
obBB_Counter				= objoff_3A	; .b
obBB_Timer2				= objoff_3E	; .w

; Functions (objoff_38 Status)
sBossBlock_SpikeEnable			= 2
sBossBlock_SpikeTouch			= 3

; =============== S U B R O U T I N E =======================================

Obj_BossBlock:

		; don't load the objects until the art has been loaded
		tst.w	(KosPlus_modules_left).w
		bne.w	BossBlock_MoveLeftRight.return
		move.l	#BossBlock_Setup4,address(a0)

		; init
		lea	ObjDat_RobotnikShip2(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#BossBlock_Hits,collision_property(a0)				; set hits
		move.w	#-$100,x_vel(a0)						; set move left
		move.l	#BossBlock_MoveLeftRight,obBB_Jump(a0)

		; create
		lea	Child1_MakeRoboShipFlame(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_MakeRoboHead4(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	Child1_BossBlock_Spike(pc),a2
		jsr	(CreateChild1_Normal).w
		jmp	(Swing_Setup1).w

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBlock_MoveLeftRight:

		; check boss position
		move.w	x_pos(a0),d0
		moveq	#16,d1
		add.w	(Camera_min_X_pos).w,d1
		sub.w	d1,d0
		andi.w	#32-1,d0
		bne.s	.return

		; check player position
		jsr	(Find_SonicTails).w
		move.w	x_pos(a1),d1
		sub.w	(Camera_min_X_pos).w,d1
		asr.w	#5,d1
		cmp.b	obBB_CamXpos(a0),d1
		bne.s	.return

		; fix boss position
		moveq	#0,d0
		move.b	obBB_CamXpos(a0),d0
		asl.w	#5,d0
		moveq	#16,d1
		add.w	(Camera_min_X_pos).w,d1
		add.w	d1,d0
		move.w	d0,x_pos(a0)

		; check block
		clr.w	parent3(a0)
		bsr.w	BossBlock_BreakChunkBlock

		; set
		move.l	#BossBlock_Setup2,address(a0)
		move.l	#BossBlock_MoveDown,obBB_Jump(a0)
		bset	#sBossBlock_SpikeEnable,obBB_Status(a0)
		move.l	#words_to_long(0,$180),x_vel(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossBlock_MoveDown:

		; check
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$AC,d0
		cmp.w	y_pos(a0),d0
		bhs.s	BossBlock_MoveLeftRight.return
		move.w	d0,y_pos(a0)
		clr.w	y_vel(a0)
		move.w	y_pos(a0),obBB_SaveYpos(a0)

		; check block
		move.l	#BossBlock_FloorShaking.exit,d1
		move.w	parent3(a0),d0
		beq.s	.set
		movea.w	d0,a1
		bset	#5,objoff_38(a1)						; grab block
		sfx	sfx_BossHitFloor
		move.w	#50-30,obBB_Timer(a0)
		move.w	#30,obBB_Timer2(a0)
		move.l	#BossBlock_FloorShaking,d1

.set
		move.l	d1,obBB_Jump(a0)
		rts
; ---------------------------------------------------------------------------

BossBlock_FloorShaking:
		moveq	#2,d0
		addq.b	#1,obBB_Counter(a0)
		btst	#1,obBB_Counter(a0)
		bne.s	.set
		neg.w	d0

.set
		add.w	obBB_SaveYpos(a0),d0
		move.w	d0,y_pos(a0)
		subq.w	#1,obBB_Timer2(a0)
		bpl.s	.return

.exit
		clr.b	obBB_Counter(a0)
		bset	#sBossBlock_SpikeTouch,obBB_Status(a0)
		move.l	#BossBlock_MoveUp,obBB_Jump(a0)
		move.w	#-$800,y_vel(a0)
		tst.w	parent3(a0)
		bne.s	.return
		asr.w	y_vel(a0)
		bclr	#sBossBlock_SpikeTouch,obBB_Status(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossBlock_MoveUp:
		moveq	#$28,d1
		tst.w	parent3(a0)
		beq.s	.notblock
		moveq	#$28-$18,d1

.notblock
		move.w	(Camera_max_Y_pos).w,d0
		add.w	d1,d0
		cmp.w	y_pos(a0),d0
		blo.s	.moveupfix
		move.w	d0,y_pos(a0)
		clr.w	y_vel(a0)
		move.l	#BossBlock_AirShaking,obBB_Jump(a0)
		move.w	y_pos(a0),obBB_SaveYpos(a0)
		moveq	#8,d0
		tst.w	parent3(a0)
		beq.s	.set
		moveq	#$2D,d0

.set
		move.w	d0,obBB_Timer2(a0)
		rts
; ---------------------------------------------------------------------------

.moveupfix
		cmpi.w	#-$40,y_vel(a0)
		bge.s	.return
		addi.w	#$C,y_vel(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossBlock_AirShaking:
		moveq	#1,d1
		tst.w	parent3(a0)
		beq.s	.notblock
		addq.w	#1,d1

.notblock
		moveq	#$28,d0
		add.w	(Camera_max_Y_pos).w,d0
		cmp.w	obBB_SaveYpos(a0),d0
		beq.s	.shaking
		bhs.s	.add
		neg.w	d1

.add
		add.w	d1,obBB_SaveYpos(a0)

.shaking
		moveq	#0,d0
		tst.w	parent3(a0)
		beq.s	.set
		addq.w	#2,d0
		addq.b	#1,obBB_Counter(a0)
		btst	#1,obBB_Counter(a0)
		beq.s	.set
		neg.w	d0

.set
		add.w	obBB_SaveYpos(a0),d0
		move.w	d0,y_pos(a0)
		subq.w	#1,obBB_Timer2(a0)
		bpl.s	BossBlock_MoveUp.return
		move.w	#30,obBB_Timer(a0)
		move.l	#BossBlock_MoveRestart,obBB_Jump(a0)
		bclr	#sBossBlock_SpikeEnable,obBB_Status(a0)				; hide spike
		clr.b	obBB_Counter(a0)
		move.w	parent3(a0),d0
		beq.s	.return
		movea.w	d0,a1
		bset	#6,objoff_38(a1)						; break block

.return
		rts
; ---------------------------------------------------------------------------

BossBlock_MoveRestart:
		moveq	#$28,d0
		add.w	(Camera_max_Y_pos).w,d0
		move.w	d0,y_pos(a0)
		move.l	#BossBlock_Setup3,address(a0)
		move.l	#BossBlock_Restart,obBB_Jump(a0)
		move.w	#-$100,d0
		jsr	(Change_VelocityWithFlipX).w
		tst.w	parent3(a0)
		beq.s	.notblock
		bclr	#sBossBlock_SpikeTouch,obBB_Status(a0)				; set spike touch

.notblock
		jmp	(Swing_Setup1).w
; ---------------------------------------------------------------------------

BossBlock_Restart:
		move.w	(Camera_min_X_pos).w,d0
		btst	#render_flags.x_flip,render_flags(a0)
		bne.s	.right
		addq.w	#8,d0
		cmp.w	x_pos(a0),d0
		blt.s	.return
		bra.s	.restart
; ---------------------------------------------------------------------------

.right
		addi.w	#320-8,d0
		cmp.w	x_pos(a0),d0
		bgt.s	.return

.restart
		move.l	#BossBlock_Setup4,address(a0)
		move.l	#BossBlock_MoveLeftRight,obBB_Jump(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Setup
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBlock_Setup4:
		move.w	(Camera_min_X_pos).w,d0
		btst	#render_flags.x_flip,render_flags(a0)
		bne.s	.right
		addq.w	#8,d0
		cmp.w	x_pos(a0),d0
		blt.s	BossBlock_Setup3
		neg.w	x_vel(a0)
		bchg	#render_flags.x_flip,render_flags(a0)
		bra.s	BossBlock_Setup3
; ---------------------------------------------------------------------------

.right
		addi.w	#320-8,d0
		cmp.w	x_pos(a0),d0
		bgt.s	BossBlock_Setup3
		neg.w	x_vel(a0)
		bchg	#render_flags.x_flip,render_flags(a0)

BossBlock_Setup3:
		jsr	(Swing_UpAndDown).w

BossBlock_Setup2:
		jsr	(MoveSprite2).w

BossBlock_Setup:
		movea.l	obBB_Jump(a0),a1
		jsr	(a1)

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBlock_MainProcess:
		pea	(Draw_And_Touch_Sprite).w

		; calc boss position (32 pixels)
		move.w	x_pos(a0),d0
		sub.w	(Camera_min_X_pos).w,d0
		lsr.w	#5,d0
		move.b	d0,obBB_CamXpos(a0)

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		; check touch
		tst.b	collision_flags(a0)						; are boss's collisions enabled?
		bne.s	.return								; if yes, branch
		tst.b	collision_property(a0)						; has boss run out of hits?
		beq.s	BossBlock_Defeated						; if yes, branch
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

BossBlock_Defeated:
		move.l	#Wait_FadeToLevelMusic,address(a0)
		move.l	#.explosion,obBB_Jump(a0)
		bclr	#sBossBlock_SpikeEnable,obBB_Status(a0)				; hide spike
		clr.l	x_vel(a0)

		; use the first line of the palette
		andi.w	#$87FF,art_tile(a0)

.artsize	:= (ArtUnc_RobotnikShip1_end-ArtUnc_RobotnikShip1)&$FFFF

		; load alternative ship art
		QueueStaticDMA ArtUnc_RobotnikShip1,.artsize,tiles_to_bytes($3B6)

		; restore the level palette
		lea	(Pal_SYZ).l,a1
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
		addi.w	#$200,d0
		move.w	d0,(Camera_stored_max_X_pos).w

.notfree3
		bset	#render_flags.x_flip,render_flags(a0)
		move.l	#words_to_long($400,0),x_vel(a0)

		; return
		move.l	#End_SYZ3Boss,(Level_data_addr_RAM.Resize).w
		move.l	#DrawTilesAsYouMove,(Level_data_addr_RAM.ScreenEvent).w

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
		addi.w	#$91,d0
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
		bset	#4,objoff_38(a0)						; remove Robotnik spike
		bset	#5,objoff_38(a0)						; remove Robotnik head and fire
		clr.b	(Boss_flag).w

		; delete
		jmp	(Go_Delete_Sprite_3).w

; ---------------------------------------------------------------------------
; Spike
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossBlock_Spike:

		; init
		lea	ObjDat_BossBlock_Spike(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#render_flags.static_mappings,render_flags(a0)			; set static mapping flag
		move.l	#.main,address(a0)

.main
		jsr	(Refresh_ChildPosition).w
		move.w	objoff_3C(a0),d0
		btst	#sBossBlock_SpikeEnable,obBB_Status(a1)
		beq.s	.suby

.addy
		cmpi.w	#$94,d0
		bge.s	.ypos
		addq.w	#7,d0
		bra.s	.ypos
; ---------------------------------------------------------------------------

.suby
		tst.w	d0
		ble.s	.ypos
		subq.w	#5,d0

.ypos
		move.w	d0,objoff_3C(a0)
		asr.w	#2,d0
		add.w	d0,y_pos(a0)

		; check touch
		tst.w	objoff_3C(a0)							; spike hidden?
		bmi.s	.draw								; if yes, branch
		btst	#status.npc.touch,status(a1)					; boss flashing?
		bne.s	.draw								; if yes, branch
		btst	#sBossBlock_SpikeTouch,obBB_Status(a1)				; flag set?
		bne.s	.draw								; if yes, branch

.touch
		jmp	(Child_DrawTouch_Sprite2).w
; ---------------------------------------------------------------------------

.draw
		jmp	(Child_Draw_Sprite2).w

; ---------------------------------------------------------------------------
; Block (SYZ)
; Object 76 - blocks that Eggman picks up (SYZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SYZBlock:

		; init
		lea	ObjDat_BossBlock_Block(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#bytes_to_word(0,36),child_dx(a0)				; set dxy
		move.w	y_pos(a0),objoff_30(a0)
		bset	#status.npc.no_balancing,status(a0)				; disable player's balance animation
		move.l	#.check,address(a0)

.check
		btst	#5,objoff_38(a0)
		beq.s	.solid
		move.l	#.position,address(a0)
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object

.position
		jsr	(Refresh_ChildPosition).w
		tst.b	collision_property(a1)
		beq.s	.break
		btst	#6,objoff_38(a0)
		beq.s	.draw

.break
		sfx	sfx_BossHit
		lea	Child6_BossSYZBlock_FlickerMove(pc),a2
		jsr	(CreateChild6_Simple).w
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

.draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Block pieces
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossSYZBlock_FlickerMove:

		; init
		lea	ObjDat_BossBlock_Block(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#Obj_FlickerMove,address(a0)
		move.b	subtype(a0),d0
		lsr.b	d0								; division by 2
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		moveq	#2<<2,d0							; set index velocity
		jsr	(Set_IndexedVelocity).w
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Break chunk block
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossBlock_BreakChunkBlock:

		; set boss block xypos
		move.w	(Camera_Y_pos_copy).w,d2
		addi.w	#224-32,d2
		moveq	#-32,d3								; set align (32 pixels)
		and.w	x_pos(a0),d3

		; calc chunk pos
		movea.l	(Level_layout_addr_ROM).w,a1
		move.w	d2,d0
		lsr.w	#5,d0
		and.w	(Layout_row_index_mask).w,d0
		move.w	d3,d1
		lsr.w	#3,d1
		move.w	d1,d4
		lsr.w	#4,d1
		add.w	d1,d1								; chunk ID to word
		add.w	8(a1,d0.w),d1
		adda.w	d1,a1
		moveq	#0,d1
		move.w	(a1),d1								; move 128*128 chunk ID to d1
		move.w	d1,d5								; save chunk id
		lsl.w	#7,d1								; multiply by $80
		move.w	d2,d0
		andi.w	#$70,d0
		add.w	d0,d1
		andi.w	#$E,d4
		add.w	d4,d1
		movea.l	(Level_data_addr_RAM.128x128RAM).w,a1
		adda.l	d1,a1

		; check block
		tst.l	(a1)								; is empty block?
		beq.s	.return								; if yes, branch
		clr.l	(a1)								; clear top of block (32x16)
		clr.l	$110(a1)							; clear bottom of block (32x16)

		; check chunk
		cmpi.w	#$CF,d5								; is it $CF chunk?
		bne.s	.redraw								; if not, branch

		; replace block (32x16)
		move.l	-(($CF*$80-$B*$80)+$70)(a1),$110(a1)				; copy data from $B chunk to $CF

.redraw
		move.w	(Camera_Y_pos_copy).w,d0
		addi.w	#224-16,d0
		move.w	d0,(Draw_delayed_position).w					; set up redraw memory
		move.w	#(32/16)-1,(Draw_delayed_rowcount).w				; redraw only 4 tiles 8x8
		st	(Screen_event_flag).w						; set redraw flag

		; create sprite boss block
		jsr	(Create_New_Sprite3).w
		bne.s	.return
		move.l	#Obj_SYZBlock,address(a1)
		moveq	#32/2,d1
		add.w	d1,d2
		add.w	d1,d3
		move.w	d2,y_pos(a1)
		move.w	d3,x_pos(a1)
		move.w	a0,parent3(a1)							; save boss address for block
		move.w	a1,parent3(a0)							; save block address for boss

.return
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BossBlock_Spike:		subObjData Map_BossSYZBlockSpike, $400, 0, 0, 32, 32, 5, 0, 4|collision_flags.npc.hurt
ObjDat_BossBlock_Block:		subObjData Map_BossSYZBlock, $406, 2, 1, 32, 32, 4, 0, 0

Child1_BossBlock_Spike:
		dc.w 1-1
		dc.l Obj_BossBlock_Spike
		dc.b 0, -2
Child6_BossSYZBlock_FlickerMove:
		dc.w 4-1
		dc.l Obj_BossSYZBlock_FlickerMove

PLC_BossBlock: plrlistheader
		plreq $380, ArtKosPM_RobotnikShip2
		plreq $400, ArtKosPM_SYZSpike
		plreq $406, ArtKosPM_SYZBlock
		plreq $500, ArtKosPM_BossExplosion
PLC_BossBlock_end
; ---------------------------------------------------------------------------

		include "Objects/Bosses/SYZ3/Object Data/Map - Boss Block.asm"
		include "Objects/Bosses/SYZ3/Object Data/Map - Boss Block(Spike).asm"
