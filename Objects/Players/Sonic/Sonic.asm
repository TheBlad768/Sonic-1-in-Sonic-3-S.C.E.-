; ---------------------------------------------------------------------------
; Sonic (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Sonic:

		; load some addresses into registers
		; this is done to allow some subroutines to be
		; shared with Tails/Knuckles.

		lea	(Max_speed).w,a4
		lea	(Distance_from_top).w,a5
		lea	(Dust).w,a6

	if GameDebug
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		beq.s	Sonic_Normal							; if not, branch

		; debug only code
		cmpi.b	#1,(Debug_placement_type).w					; are Sonic in debug object placement mode?
		beq.s	JmpTo_DebugMode							; if so, skip to debug mode routine

		; by this point, we're assuming you're in frame cycling mode
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	.next
		clr.w	(Debug_placement_mode).w					; leave debug mode

.next
		addq.b	#1,mapping_frame(a0)						; next frame
		cmpi.b	#((Map_Sonic_end-Map_Sonic)/2)-1,mapping_frame(a0)		; have we reached the end of Sonic's frames?
		blo.s	.draw
		clr.b	mapping_frame(a0)						; if so, reset to Sonic's first frame

.draw
		bsr.w	Sonic_Load_PLC
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

JmpTo_DebugMode:
		jmp	(Debug_Mode).l
; ---------------------------------------------------------------------------

Sonic_Normal:
	endif

		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d0
		jmp	Sonic_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Sonic_Index: offsetTable
		ptrTableEntry.w Sonic_Init						; 0
		ptrTableEntry.w Sonic_Control						; 2
		ptrTableEntry.w Sonic_Hurt						; 4
		ptrTableEntry.w Sonic_Death						; 6
		ptrTableEntry.w Sonic_Restart						; 8
		ptrTableEntry.w loc_12590						; A
		ptrTableEntry.w Sonic_Drown						; C
; ---------------------------------------------------------------------------

Sonic_Init:										; Routine 0
		addq.b	#2,routine(a0)							; => Sonic_Control
		move.w	#bytes_to_word(38/2,18/2),y_radius(a0)				; set y_radius and x_radius ; this sets Sonic's collision height (2*pixels)
		move.w	y_radius(a0),default_y_radius(a0)				; set default_y_radius and default_x_radius
		move.l	#Map_Sonic,mappings(a0)
		move.l	#bytes_word_to_long(48/2,48/2,priority_2),height_pixels(a0)	; set height, width and priority
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		clr.b	character_id(a0)						; PlayerID_Sonic
		move.w	#$600,Max_speed-Max_speed(a4)
		move.w	#$C,Acceleration-Max_speed(a4)
		move.w	#$80,Deceleration-Max_speed(a4)
		tst.b	(Last_star_post_hit).w
		bne.s	Sonic_Init_Continued

		; only happens when not starting at a checkpoint:
		move.w	#make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
		move.w	#bytes_to_word($C,$D),top_solid_bit(a0)

		cmpi.b	#2,(Special_bonus_entry_flag).w
		beq.s	Sonic_Init_Continued

		; only happens when not starting at a Special Stage ring:
		move.w	x_pos(a0),(Saved_X_pos).w
		move.w	y_pos(a0),(Saved_Y_pos).w
		move.w	art_tile(a0),(Saved_art_tile).w
		move.w	top_solid_bit(a0),(Saved_solid_bits).w

Sonic_Init_Continued:
		clr.b	flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.b	#30,air_left(a0)
		subi.w	#32,x_pos(a0)
		addq.w	#4,y_pos(a0)
		bsr.w	Reset_Player_Position_Array
		addi.w	#32,x_pos(a0)
		subq.w	#4,y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Normal state for Sonic
; ---------------------------------------------------------------------------

Sonic_Control:										; Routine 2

	if GameDebug
		tst.b	(Debug_mode_flag).w						; is debug cheat enabled?
		beq.s	loc_10BF0							; if not, branch
		bclr	#button_A,(Ctrl_1_pressed).w					; is button A pressed?
		beq.s	loc_10BCE							; if not, branch
		eori.b	#1,(Reverse_gravity_flag).w					; toggle reverse gravity

loc_10BCE:
		btst	#button_B,(Ctrl_1_pressed).w					; is button B pressed?
		beq.s	loc_10BF0							; if not, branch
		move.w	#1,(Debug_placement_mode).w					; change Sonic into a ring/item
		clr.b	(Ctrl_1_locked).w						; unlock control
		btst	#button_C,(Ctrl_1_held).w					; was button C held before pressing B?
		beq.s	locret_10BEE							; if not, branch
		move.w	#2,(Debug_placement_mode).w					; enter animation cycle mode

locret_10BEE:
		rts
; ---------------------------------------------------------------------------

loc_10BF0:
	endif

		tst.b	(Ctrl_1_locked).w						; are controls locked?
		bne.s	loc_10BFC							; if yes, branch
		move.w	(Ctrl_1).w,(Ctrl_1_logical).w					; copy new held buttons, to enable joypad control

loc_10BFC:
		btst	#0,object_control(a0)						; is Sonic interacting with another object that holds him in place or controls his movement somehow?
		beq.s	loc_10C0C							; if yes, branch to skip Sonic's control
		clr.b	double_jump_flag(a0)						; enable double jump
		bra.s	loc_10C26
; ---------------------------------------------------------------------------

loc_10C0C:
		movem.l	a4-a6,-(sp)

		moveq	#signextendB( \
			setBit(status.player.in_air) | \
			setBit(status.player.rolling) \
		),d0

		and.b	status(a0),d0
		move.w	Sonic_Modes(pc,d0.w),d0
		jsr	Sonic_Modes(pc,d0.w)						; run Sonic's movement control code
		movem.l	(sp)+,a4-a6

loc_10C26:
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		bne.s	.display							; if not, branch
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)							; perform wrapping of Sonic's y position

.display
		bsr.s	Sonic_Display
		bsr.w	SonicKnux_SuperHyper
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Water
		move.b	(Primary_Angle).w,next_tilt(a0)
		move.b	(Secondary_Angle).w,tilt(a0)
		tst.b	(WindTunnel_flag).w
		beq.s	.anim
		tst.b	anim(a0)							; AniIDSonAni_Walk
		bne.s	.anim
		move.b	prev_anim(a0),anim(a0)

.anim
		btst	#1,object_control(a0)
		bne.s	.touch
		bsr.w	Animate_Sonic
		tst.b	(Reverse_gravity_flag).w
		beq.s	.plc
		eori.b	#setBit(render_flags.y_flip),render_flags(a0)

.plc
		bsr.w	Sonic_Load_PLC

.touch
		moveq	#signextendB($A0),d0
		and.b	object_control(a0),d0
		bne.s	.return
		jmp	TouchResponse(pc)
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Secondary states under state Sonic_Control
; ---------------------------------------------------------------------------

Sonic_Modes: offsetTable
		offsetTableEntry.w Sonic_MdNormal					; 0
		offsetTableEntry.w Sonic_MdAir						; 2
		offsetTableEntry.w Sonic_MdRoll						; 4
		offsetTableEntry.w Sonic_MdJump						; 6

; =============== S U B R O U T I N E =======================================

Sonic_Display:
		move.b	invulnerability_timer(a0),d0
		beq.s	.draw
		subq.b	#1,invulnerability_timer(a0)
		lsr.b	#3,d0								; division by 8
		bhs.s	Sonic_ChkInvin

.draw
		jsr	(Draw_Sprite).w

Sonic_ChkInvin:										; checks if invincibility has expired and disables it if it has.
		btst	#status_secondary.invincible,status_secondary(a0)
		beq.s	Sonic_ChkShoes
		tst.b	invincibility_timer(a0)
		beq.s	Sonic_ChkShoes							; if there wasn't any time left, that means we're in Super/Hyper mode
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	Sonic_ChkShoes
		subq.b	#1,invincibility_timer(a0)					; reduce invincibility_timer only on every 8th frame
		bne.s	Sonic_ChkShoes							; if time is still left, branch
		tst.b	(Music_results_flag).w						; don't change music if level is end
		bne.s	Sonic_RmvInvin
		tst.b	(Boss_flag).w							; don't change music if in a boss fight
		bne.s	Sonic_RmvInvin
		cmpi.b	#12,air_left(a0)						; don't change music if drowning
		blo.s	Sonic_RmvInvin
		move.w	(Current_music).w,d0
		jsr	(Play_Music).w							; stop playing invincibility theme and resume normal level music

Sonic_RmvInvin:
		bclr	#status_secondary.invincible,status_secondary(a0)

Sonic_ChkShoes:										; checks if Speed Shoes have expired and disables them if they have.
		btst	#status_secondary.speed_shoes,status_secondary(a0)		; does Sonic have speed shoes?
		beq.s	Sonic_ExitChk							; if so, branch
		tst.b	speed_shoes_timer(a0)
		beq.s	Sonic_ExitChk
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	Sonic_ExitChk
		subq.b	#1,speed_shoes_timer(a0)					; reduce speed_shoes_timer only on every 8th frame
		bne.s	Sonic_ExitChk
		move.w	#$600,Max_speed-Max_speed(a4)					; set Max_speed
		move.w	#$C,Acceleration-Max_speed(a4)					; set Acceleration
		move.w	#$80,Deceleration-Max_speed(a4)					; set Deceleration

		; check
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots								; if Super/Hyper, set different values
		move.w	#$A00,Max_speed-Max_speed(a4)					; set Max_speed
		move.w	#$30,Acceleration-Max_speed(a4)					; set Acceleration
		move.w	#$100,Deceleration-Max_speed(a4)				; set Deceleration

.nots
		bclr	#status_secondary.speed_shoes,status_secondary(a0)
		music	mus_Slowdown,1							; slow down tempo
; ---------------------------------------------------------------------------

Sonic_ExitChk:
		rts

; ---------------------------------------------------------------------------
; Subroutine to record Sonic's previous positions for invincibility stars
; and input/status flags for Tails' AI to follow
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_RecordPos:
		cmpa.w	#Player_1,a0							; is Sonic the sidekick?
		bne.s	.return								; if so, branch

		; record
		move.w	(Pos_table_index).w,d0
		lea	(Pos_table).w,a1
		adda.w	d0,a1
		move.w	x_pos(a0),(a1)+							; write location to pos_table
		move.w	y_pos(a0),(a1)+
		addq.b	#4,(Pos_table_byte).w						; increment index as the post-increments did a1
		lea	(Stat_table).w,a1
		adda.w	d0,a1
		move.w	(Ctrl_1_logical).w,(a1)+
		move.b	status(a0),(a1)+
		move.b	art_tile(a0),(a1)+

.return
		rts

; =============== S U B R O U T I N E =======================================

Reset_Player_Position_Array:
		cmpa.w	#Player_1,a0							; is object player 1?
		bne.s	.return								; if not, branch

		; copy
		lea	(Pos_table).w,a1
		lea	(Stat_table).w,a2
		moveq	#$3F,d0

.loop
		move.w	x_pos(a0),(a1)+							; write location to pos_table
		move.w	y_pos(a0),(a1)+
		clr.l	(a2)+
		dbf	d0,.loop
		clr.w	(Pos_table_index).w

.return
		rts

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Water:
		tst.b	(Water_flag).w							; does level have water?
		bne.s	Sonic_InWater							; if yes, branch

locret_10E2C:
		rts
; ---------------------------------------------------------------------------

Sonic_InWater:
		move.w	(Water_level).w,d0
		cmp.w	y_pos(a0),d0							; is Sonic above the water?
		bge.s	Sonic_OutWater							; if yes, branch
		bset	#status.player.underwater,status(a0)				; set underwater flag
		bne.s	locret_10E2C							; if already underwater, branch
		addq.b	#1,(Water_entered_counter).w
		movea.w	a0,a1
		jsr	(Player_ResetAirTimer).l
		move.l	#Obj_AirCountdown,(Breathing_bubbles+address).w			; load Sonic's breathing bubbles
		move.w	a0,(Breathing_bubbles+parent).w
		move.w	#$300,Max_speed-Max_speed(a4)
		move.w	#6,Acceleration-Max_speed(a4)
		move.w	#$40,Deceleration-Max_speed(a4)

		; check
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots								; if Super/Hyper, set different values
		move.w	#$500,Max_speed-Max_speed(a4)
		move.w	#$18,Acceleration-Max_speed(a4)
		move.w	#$80,Deceleration-Max_speed(a4)

.nots
		tst.b	object_control(a0)
		bne.s	locret_10E2C
		asr.w	x_vel(a0)
		asr.w	y_vel(a0)							; memory operands can only be shifted one bit at a time
		asr.w	y_vel(a0)
		beq.s	locret_10E2C
		move.w	#bytes_to_word(1,0),anim(a6)					; splash animation, write 1 to anim and clear prev_anim
		sfx	sfx_Splash,1							; splash sound
; ---------------------------------------------------------------------------

Sonic_OutWater:
		bclr	#status.player.underwater,status(a0)				; unset underwater flag
		beq.s	locret_10E2C							; if already above water, branch
		addq.b	#1,(Water_entered_counter).w

		movea.w	a0,a1
		jsr	(Player_ResetAirTimer).l
		move.w	#$600,Max_speed-Max_speed(a4)
		move.w	#$C,Acceleration-Max_speed(a4)
		move.w	#$80,Deceleration-Max_speed(a4)

		; check
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots								; if Super/Hyper, set different values
		move.w	#$A00,Max_speed-Max_speed(a4)
		move.w	#$30,Acceleration-Max_speed(a4)
		move.w	#$100,Deceleration-Max_speed(a4)

.nots
		cmpi.b	#PlayerID_Hurt,routine(a0)					; is Sonic falling back from getting hurt?
		beq.s	loc_10EFC							; if yes, branch
		tst.b	object_control(a0)
		bne.s	loc_10EFC
		move.w	y_vel(a0),d0
		cmpi.w	#-$400,d0
		blt.s	loc_10EFC
		asl.w	y_vel(a0)

loc_10EFC:
		cmpi.b	#AniIDSonAni_Blank,anim(a0)					; is Sonic in his 'blank' animation
		beq.w	locret_10E2C							; if so, branch
		tst.w	y_vel(a0)
		beq.w	locret_10E2C
		move.w	#bytes_to_word(1,0),anim(a6)					; splash animation, write 1 to anim and clear prev_anim
		cmpi.w	#-$1000,y_vel(a0)
		bgt.s	loc_10F22
		move.w	#-$1000,y_vel(a0)						; limit upward y velocity exiting the water

loc_10F22:
		sfx	sfx_Splash,1							; splash sound

; =============== S U B R O U T I N E =======================================

Sonic_MdNormal:
		bsr.w	SonicKnux_Spindash
		bsr.w	Sonic_Jump
		bsr.w	Player_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	SonicKnux_Roll
		bsr.w	Player_LevelBound
		jsr	(MoveSprite2_TestGravity).w
		bsr.s	Call_Player_AnglePos
		bsr.w	Player_SlopeRepel

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_10F82
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_10F72
		sub.w	d1,x_pos(a0)

loc_10F72:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_10F7E
		add.w	d1,x_pos(a0)

loc_10F7E:
		movem.l	(sp)+,a4-a6

locret_10F82:
		rts

; =============== S U B R O U T I N E =======================================

Call_Player_AnglePos:
		tst.b	(Reverse_gravity_flag).w
		beq.w	Player_AnglePos
		moveq	#$40,d0
		add.b	angle(a0),d0
		neg.b	d0
		subi.b	#$40,d0
		move.b	d0,angle(a0)
		bsr.w	Player_AnglePos
		moveq	#$40,d0
		add.b	angle(a0),d0
		neg.b	d0
		subi.b	#$40,d0
		move.b	d0,angle(a0)
		rts

; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdAir
; Called if Sonic is airborne, but not in a ball (thus, probably not jumping)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Sonic_Stand_Freespace:
Sonic_MdAir:

	if RollInAir
		bsr.w	Sonic_ChgFallAnim
	endif

		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDir
		bsr.w	Player_LevelBound
		jsr	(MoveSprite_TestGravity).w
		btst	#status.player.underwater,status(a0)				; is Sonic underwater?
		beq.s	loc_10FD6							; if not, branch
		subi.w	#$28,y_vel(a0)							; reduce gravity by $28 ($38-$28=$10)

loc_10FD6:
		cmpi.w	#$1000,y_vel(a0)
		ble.s	.maxy
		move.w	#$1000,y_vel(a0)

.maxy
		bsr.w	Player_JumpAngle
		bra.w	SonicKnux_DoLevelCollision

; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdRoll
; Called if Sonic is in a ball, but not airborne (thus, probably rolling)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Sonic_Spin_Path:
Sonic_MdRoll:
		tst.b	spin_dash_flag(a0)
		bne.s	loc_10FEA
		bsr.w	Sonic_Jump

loc_10FEA:
		bsr.w	Player_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Player_LevelBound
		jsr	(MoveSprite2_TestGravity).w
		bsr.w	Call_Player_AnglePos
		bsr.w	Player_SlopeRepel

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_11034
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_11024
		sub.w	d1,x_pos(a0)

loc_11024:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_11030
		add.w	d1,x_pos(a0)

loc_11030:
		movem.l	(sp)+,a4-a6

locret_11034:
		rts

; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdJump
; Called if Sonic is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to Sonic_MdAir, at least at this outer level.
; Why they gave it a separate copy of the code, I don't know.
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Sonic_Spin_Freespace:
Sonic_MdJump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDir
		bsr.w	Player_LevelBound
		jsr	(MoveSprite_TestGravity).w
		btst	#status.player.underwater,status(a0)				; is Sonic underwater?
		beq.s	loc_11056							; if not, branch
		subi.w	#$28,y_vel(a0)							; reduce gravity by $28 ($38-$28=$10)

loc_11056:
		cmpi.w	#$1000,y_vel(a0)
		ble.s	.maxy
		move.w	#$1000,y_vel(a0)

.maxy
		bsr.w	Player_JumpAngle
		bra.w	SonicKnux_DoLevelCollision

	if RollInAir

; ---------------------------------------------------------------------------
; Subroutine to make Sonic roll
; ---------------------------------------------------------------------------

Sonic_ChgFallAnim:
		btst	#status.player.rolling,status(a0)				; is Sonic rolling?
		bne.s	.return								; if yes, branch
		btst	#status.player.on_object,status(a0)				; is Sonic standing on an object?
		bne.s	.return								; if yes, branch
		tst.b	flip_angle(a0)							; flip angle?
		bne.s	.return								; if yes, branch
		tst.b	anim(a0)							; walk animation?
		bne.s	.return								; if not, branch
		moveq	#btnABC,d0							; read only A/B/C buttons
		and.b	(Ctrl_1_pressed_logical).w,d0					; get button presses
		beq.s	.return
		bset	#status.player.rolling,status(a0)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)					; use "rolling"	animation
		addq.w	#5,y_pos(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	.return
		subi.w	#5+5,y_pos(a0)

.return
		rts

	endif

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Move:
		move.w	Max_speed-Max_speed(a4),d6					; set Max_speed
		move.w	Acceleration-Max_speed(a4),d5					; set Acceleration
		move.w	Deceleration-Max_speed(a4),d4					; set Deceleration
		tst.b	status_secondary(a0)						; is bit 7 set? (Infinite inertia)
		bmi.w	loc_11332							; if so, branch
		tst.w	move_lock(a0)
		bne.w	loc_112EA
		btst	#button_left,(Ctrl_1_logical).w					; is left being pressed?
		beq.s	Sonic_NotLeft							; if not, branch
		bsr.w	sub_113F6

Sonic_NotLeft:
		btst	#button_right,(Ctrl_1_logical).w				; is right being pressed?
		beq.s	Sonic_NotRight							; if not, branch
		bsr.w	sub_11482

Sonic_NotRight:
		move.w	(Camera_H_scroll_shift).w,d1
		beq.s	.skip
		bclr	#status.player.x_flip,status(a0)
		tst.w	d1
		bpl.s	.skip
		bset	#status.player.x_flip,status(a0)

.skip
		moveq	#$20,d0
		add.b	angle(a0),d0
		andi.b	#$C0,d0								; is Sonic on a slope?
		bne.w	loc_112EA							; if yes, branch
		tst.w	ground_vel(a0)							; is Sonic moving?
		bne.w	loc_112EA							; if yes, branch
		tst.w	d1
		bne.w	loc_112EA
		bclr	#status.player.pushing,status(a0)
		move.b	#AniIDSonAni_Wait,anim(a0)					; use standing animation
		btst	#status.player.on_object,status(a0)
		beq.w	Sonic_Balance
		movea.w	interact(a0),a1							; load interacting object's RAM space
		tst.b	status(a1)							; is status bit 7 set? (Balance anim off)
		bmi.w	loc_11276							; if so, branch

		; calculations to determine where on the object Sonic is, and make him balance accordingly
		moveq	#0,d1								; clear d1
		move.b	width_pixels(a1),d1						; load interacting object's width into d1
		move.w	d1,d2								; move to d2 for seperate calculations
		add.w	d2,d2								; double object width, converting it to X pos' units of measurement
		subq.w	#2,d2								; subtract 2: This is the margin for 'on edge'
		add.w	x_pos(a0),d1							; add Sonic's X position to object width
		sub.w	x_pos(a1),d1							; subtract object's X position from width+Sonic's X pos, giving you Sonic's distance from left edge of object
		tst.b	(Super_Sonic_Knux_flag).w					; is Sonic Super/Hyper?
		bne.s	SuperSonic_Balance						; if so, branch
		cmpi.w	#2,d1								; is Sonic within two units of object's left edge?
		blt.s	Sonic_BalanceOnObjLeft						; if so, branch
		cmp.w	d2,d1
		bge.s	Sonic_BalanceOnObjRight						; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
		bra.w	loc_11276							; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------

SuperSonic_Balance:
		cmpi.w	#2,d1								; is Sonic within two units of object's left edge?
		blt.w	loc_11268							; if so, branch
		cmp.w	d2,d1
		bge.w	loc_11258							; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
		bra.w	loc_11276							; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------
; balancing checks for when you're on the right edge of an object

Sonic_BalanceOnObjRight:
		btst	#status.player.x_flip,status(a0)				; is Sonic facing right?
		bne.s	loc_11128							; if so, branch
		move.b	#AniIDSonAni_Balance,anim(a0)					; balance animation 1
		addq.w	#6,d2								; extend balance range
		cmp.w	d2,d1								; is Sonic within (two units before and) four units past the right edge?
		blt.w	loc_112EA							; if so branch
		move.b	#AniIDSonAni_Balance2,anim(a0)					; if REALLY close to the edge, use different animation (Balance animation 2)
		bra.w	loc_112EA
; ---------------------------------------------------------------------------

loc_11128:

		; somewhat dummied out/redundant code from Sonic 2
		; originally, Sonic displayed different animations for each direction faced
		; but now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
		bclr	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)					; balance animation 1
		addq.w	#6,d2								; extend balance range
		cmp.w	d2,d1								; is Sonic within (two units before and) four units past the right edge?
		blt.w	loc_112EA							; if so branch
		move.b	#AniIDSonAni_Balance2,anim(a0)					; if REALLY close to the edge, use different animation (Balance animation 2)
		bra.w	loc_112EA
; ---------------------------------------------------------------------------

Sonic_BalanceOnObjLeft:
		btst	#status.player.x_flip,status(a0)				; is Sonic facing right?
		beq.s	loc_11166
		move.b	#AniIDSonAni_Balance,anim(a0)					; balance animation 1
		cmpi.w	#-4,d1								; is Sonic within (two units before and) four units past the left edge?
		bge.w	loc_112EA							; if so branch (instruction signed to match)
		move.b	#AniIDSonAni_Balance2,anim(a0)					; if REALLY close to the edge, use different animation (Balance animation 2)
		bra.w	loc_112EA
loc_11166:	; +
		; somewhat dummied out/redundant code from Sonic 2
		; originally, Sonic displayed different animations for each direction faced
		; but now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
		bset	#status.player.x_flip,status(a0)				; is Sonic facing right?
		move.b	#AniIDSonAni_Balance,anim(a0)					; balance animation 1
		cmpi.w	#-4,d1								; is Sonic within (two units before and) four units past the left edge?
		bge.w	loc_112EA							; if so branch (instruction signed to match)
		move.b	#AniIDSonAni_Balance2,anim(a0)					; if REALLY close to the edge, use different animation (Balance animation 2)
		bra.w	loc_112EA
; ---------------------------------------------------------------------------
; balancing checks for when you're on the edge of part of the level
Sonic_Balance:
		move.w	x_pos(a0),d3
		bsr.w	ChooseChkFloorEdge
		cmpi.w	#$C,d1
		blt.w	loc_11276
		tst.b	(Super_Sonic_Knux_flag).w					; is Sonic Super/Hyper?
		bne.w	loc_11250							; if so, branch
		cmpi.b	#3,next_tilt(a0)
		bne.s	loc_111F6
		btst	#status.player.x_flip,status(a0)
		bne.s	loc_111CE
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.w	x_pos(a0),d3
		subq.w	#6,d3
		bsr.w	ChooseChkFloorEdge
		cmpi.w	#$C,d1
		blt.w	loc_112EA
		move.b	#AniIDSonAni_Balance2,anim(a0)
		bra.w	loc_112EA
		; on right edge but facing left:
loc_111CE:	; +
		; Somewhat dummied out/redundant code from Sonic 2
		; Originally, Sonic displayed different animations for each direction faced
		; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
		bclr	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.w	x_pos(a0),d3
		subq.w	#6,d3
		bsr.w	ChooseChkFloorEdge
		cmpi.w	#$C,d1
		blt.w	loc_112EA
		move.b	#AniIDSonAni_Balance2,anim(a0)
		bra.w	loc_112EA
; ---------------------------------------------------------------------------

loc_111F6:
		cmpi.b	#3,tilt(a0)
		bne.s	loc_11276
		btst	#status.player.x_flip,status(a0)
		beq.s	loc_11228
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.w	x_pos(a0),d3
		addq.w	#6,d3
		bsr.w	ChooseChkFloorEdge
		cmpi.w	#$C,d1
		blt.w	loc_112EA
		move.b	#AniIDSonAni_Balance2,anim(a0)
		bra.w	loc_112EA
; ---------------------------------------------------------------------------

loc_11228:
		bset	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.w	x_pos(a0),d3
		addq.w	#6,d3
		bsr.w	ChooseChkFloorEdge
		cmpi.w	#$C,d1
		blt.w	loc_112EA
		move.b	#AniIDSonAni_Balance2,anim(a0)
		bra.w	loc_112EA
; ---------------------------------------------------------------------------

loc_11250:
		cmpi.b	#3,next_tilt(a0)
		bne.s	loc_11260

loc_11258:
		bclr	#status.player.x_flip,status(a0)
		bra.s	loc_1126E
; ---------------------------------------------------------------------------

loc_11260:
		cmpi.b	#3,tilt(a0)
		bne.s	loc_11276

loc_11268:
		bset	#status.player.x_flip,status(a0)

loc_1126E:
		move.b	#6,anim(a0)
		bra.s	loc_112EA
; ---------------------------------------------------------------------------

loc_11276:
		tst.w	(Camera_H_scroll_shift).w
		bne.s	loc_112B0
		btst	#button_down,(Ctrl_1_logical).w
		beq.s	loc_112B0
		move.b	#AniIDSonAni_Duck,anim(a0)
		addq.b	#1,scroll_delay_counter(a0)
		cmpi.b	#2*60,scroll_delay_counter(a0)
		blo.s	loc_112F0
		move.b	#2*60,scroll_delay_counter(a0)
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_112A6
		cmpi.w	#8,(a5)
		beq.s	loc_112FC
		subq.w	#2,(a5)
		bra.s	loc_112FC
; ---------------------------------------------------------------------------

loc_112A6:
		cmpi.w	#$D8,(a5)
		beq.s	loc_112FC
		addq.w	#2,(a5)
		bra.s	loc_112FC
; ---------------------------------------------------------------------------

loc_112B0:
		btst	#button_up,(Ctrl_1_logical).w
		beq.s	loc_112EA
		move.b	#AniIDSonAni_LookUp,anim(a0)
		addq.b	#1,scroll_delay_counter(a0)
		cmpi.b	#2*60,scroll_delay_counter(a0)
		blo.s	loc_112F0
		move.b	#2*60,scroll_delay_counter(a0)
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_112E0
		cmpi.w	#$C8,(a5)
		beq.s	loc_112FC
		addq.w	#2,(a5)
		bra.s	loc_112FC
; ---------------------------------------------------------------------------

loc_112E0:
		cmpi.w	#$18,(a5)
		beq.s	loc_112FC
		subq.w	#2,(a5)
		bra.s	loc_112FC
; ---------------------------------------------------------------------------

loc_112EA:
		clr.b	scroll_delay_counter(a0)

loc_112F0:
		cmpi.w	#$60,(a5)
		beq.s	loc_112FC
		bhs.s	loc_112FA
		addq.w	#4,(a5)

loc_112FA:
		subq.w	#2,(a5)

loc_112FC:
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	loc_11306
		moveq	#$C,d5

loc_11306:
		moveq	#btnLR,d0
		and.b	(Ctrl_1_logical).w,d0
		bne.s	loc_11332
		move.w	ground_vel(a0),d0
		beq.s	loc_11332
		bmi.s	loc_11326
		sub.w	d5,d0
		bhs.s	loc_11320
		moveq	#0,d0

loc_11320:
		move.w	d0,ground_vel(a0)
		bra.s	loc_11332
; ---------------------------------------------------------------------------

loc_11326:
		add.w	d5,d0
		bhs.s	loc_1132E
		moveq	#0,d0

loc_1132E:
		move.w	d0,ground_vel(a0)

loc_11332:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	ground_vel(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	ground_vel(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

loc_11350:
		btst	#6,object_control(a0)
		bne.s	locret_113CE
		moveq	#$3F,d0
		and.b	angle(a0),d0
		beq.s	loc_11370
		moveq	#$40,d0
		add.b	angle(a0),d0
		bmi.s	locret_113CE

loc_11370:
		move.b	#$40,d1
		tst.w	ground_vel(a0)
		beq.s	locret_113CE
		bmi.s	loc_1137E
		neg.w	d1

loc_1137E:
		move.b	angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		jsr	(CalcRoomInFront).w
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_113CE
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_113F0
		cmpi.b	#$40,d0
		beq.s	loc_113D6
		cmpi.b	#$80,d0
		beq.s	loc_113D0
		add.w	d1,x_vel(a0)
		clr.w	ground_vel(a0)
		btst	#status.player.x_flip,status(a0)
		bne.s	locret_113CE
		bset	#status.player.pushing,status(a0)

locret_113CE:
		rts
; ---------------------------------------------------------------------------

loc_113D0:
		sub.w	d1,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_113D6:
		sub.w	d1,x_vel(a0)
		clr.w	ground_vel(a0)
		btst	#status.player.x_flip,status(a0)
		beq.s	locret_113CE
		bset	#status.player.pushing,status(a0)
		rts
; ---------------------------------------------------------------------------

loc_113F0:
		add.w	d1,y_vel(a0)
		rts

; =============== S U B R O U T I N E =======================================

sub_113F6:
		move.w	ground_vel(a0),d0
		beq.s	loc_113FE
		bpl.s	loc_11430

loc_113FE:
		tst.w	(Camera_H_scroll_shift).w
		bne.s	loc_11412
		bset	#status.player.x_flip,status(a0)
		bne.s	loc_11412
		bclr	#status.player.pushing,status(a0)
		move.b	#AniIDSonAni_Run,prev_anim(a0)

loc_11412:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_11424
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_11424
		move.w	d1,d0

loc_11424:
		move.w	d0,ground_vel(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		rts
; ---------------------------------------------------------------------------

loc_11430:
		sub.w	d4,d0
		bhs.s	loc_11438
		moveq	#-$80,d0

loc_11438:
		move.w	d0,ground_vel(a0)
		moveq	#$20,d1
		add.b	angle(a0),d1
		andi.b	#$C0,d1
		bne.s	locret_11480
		cmpi.w	#$400,d0
		blt.s	locret_11480
		tst.b	flip_type(a0)
		bmi.s	locret_11480
		sfx	sfx_Skid
		move.b	#AniIDSonAni_Stop,anim(a0)
		bclr	#status.player.x_flip,status(a0)
		cmpi.b	#12,air_left(a0)						; check air remaining
		blo.s	locret_11480							; if less than 12, branch
		move.l	#DashDust_CheckSkid,address(a6)					; Dust
		move.b	#$15,mapping_frame(a6)						; Dust

locret_11480:
		rts

; =============== S U B R O U T I N E =======================================

sub_11482:
		move.w	ground_vel(a0),d0
		bmi.s	loc_114B6
		bclr	#status.player.x_flip,status(a0)
		beq.s	loc_1149C
		bclr	#status.player.pushing,status(a0)
		move.b	#AniIDSonAni_Run,prev_anim(a0)

loc_1149C:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_114AA
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_114AA
		move.w	d6,d0

loc_114AA:
		move.w	d0,ground_vel(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		rts
; ---------------------------------------------------------------------------

loc_114B6:
		add.w	d4,d0
		bhs.s	loc_114BE
		move.w	#$80,d0

loc_114BE:
		move.w	d0,ground_vel(a0)
		moveq	#$20,d1
		add.b	angle(a0),d1
		andi.b	#$C0,d1
		bne.s	locret_11506
		cmpi.w	#-$400,d0
		bgt.s	locret_11506
		tst.b	flip_type(a0)
		bmi.s	locret_11506
		sfx	sfx_Skid
		move.b	#AniIDSonAni_Stop,anim(a0)
		bset	#status.player.x_flip,status(a0)
		cmpi.b	#12,air_left(a0)						; check air remaining
		blo.s	locret_11506							; if less than 12, branch
		move.l	#DashDust_CheckSkid,address(a6)					; Dust
		move.b	#$15,mapping_frame(a6)						; Dust

locret_11506:
		rts

; =============== S U B R O U T I N E =======================================

Sonic_RollSpeed:
		move.w	Max_speed-Max_speed(a4),d6
		asl.w	d6
		move.w	Acceleration-Max_speed(a4),d5
		asr.w	d5

		; check
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots
		moveq	#6,d5

.nots
		moveq	#$20,d4
		tst.b	spin_dash_flag(a0)
		bmi.w	loc_115C6
		tst.b	status_secondary(a0)
		bmi.w	loc_115C6
		tst.w	move_lock(a0)
		bne.s	loc_1154E
		tst.w	(Camera_H_scroll_shift).w
		bne.s	loc_1154E
		btst	#button_left,(Ctrl_1_logical).w
		beq.s	loc_11542
		bsr.w	sub_11608

loc_11542:
		btst	#button_right,(Ctrl_1_logical).w
		beq.s	loc_1154E
		bsr.w	sub_1162C

loc_1154E:
		move.w	ground_vel(a0),d0
		beq.s	loc_11570
		bmi.s	loc_11564
		sub.w	d5,d0
		bhs.s	loc_1155E
		moveq	#0,d0

loc_1155E:
		move.w	d0,ground_vel(a0)
		bra.s	loc_11570
; ---------------------------------------------------------------------------

loc_11564:
		add.w	d5,d0
		bhs.s	loc_1156C
		moveq	#0,d0

loc_1156C:
		move.w	d0,ground_vel(a0)

loc_11570:
		mvabs.w	ground_vel(a0),d0
		cmpi.w	#$80,d0
		bhs.s	loc_115C6
		tst.b	spin_dash_flag(a0)
		bne.s	loc_115B4
		bclr	#status.player.rolling,status(a0)
		move.b	y_radius(a0),d0
		move.w	default_y_radius(a0),y_radius(a0)
		move.b	#AniIDSonAni_Wait,anim(a0)

		; check
		tst.w	(Camera_H_scroll_shift).w
		beq.s	.skip
		move.b	#AniIDSonAni_Walk,anim(a0)

.skip
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_115AE
		neg.w	d0

loc_115AE:
		add.w	d0,y_pos(a0)
		bra.s	loc_115C6
; ---------------------------------------------------------------------------

loc_115B4:
		move.w	#$400,ground_vel(a0)
		btst	#status.player.x_flip,status(a0)
		beq.s	loc_115C6
		neg.w	ground_vel(a0)

loc_115C6:
		cmpi.w	#$60,(a5)
		beq.s	loc_115D2
		bhs.s	loc_115D0
		addq.w	#4,(a5)

loc_115D0:
		subq.w	#2,(a5)

loc_115D2:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	ground_vel(a0),d2						; devon fix
		cmpi.w	#$1000,d2
		ble.s	loc_115F6
		move.w	#$1000,d2

loc_115F6:
		cmpi.w	#-$1000,d2
		bge.s	loc_11600
		move.w	#-$1000,d2

loc_11600:
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		bra.w	loc_11350

; =============== S U B R O U T I N E =======================================

sub_11608:
		move.w	ground_vel(a0),d0
		beq.s	loc_11610
		bpl.s	loc_1161E

loc_11610:
		bset	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Roll,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_1161E:
		sub.w	d4,d0
		bhs.s	loc_11626
		moveq	#-$80,d0

loc_11626:
		move.w	d0,ground_vel(a0)
		rts

; =============== S U B R O U T I N E =======================================

sub_1162C:
		move.w	ground_vel(a0),d0
		bmi.s	loc_11640
		bclr	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Roll,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_11640:
		add.w	d4,d0
		bhs.s	loc_11648
		move.w	#$80,d0

loc_11648:
		move.w	d0,ground_vel(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine for moving Sonic left or right when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_ChgJumpDir:
		move.w	Max_speed-Max_speed(a4),d6
		move.w	Acceleration-Max_speed(a4),d5
		asl.w	d5
		move.w	x_vel(a0),d0
		btst	#button_left,(Ctrl_1_logical).w
		beq.s	loc_11682							; if not holding left, branch
		bset	#status.player.x_flip,status(a0)

		; check
		tst.w	(Camera_H_scroll_shift).w
		beq.s	.skip
		bclr	#status.player.x_flip,status(a0)

.skip
		sub.w	d5,d0								; add acceleration to the left
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0								; compare new speed with top speed
		bgt.s	loc_11682							; if new speed is less than the maximum, branch
		add.w	d5,d0								; remove this frame's acceleration change
		cmp.w	d1,d0								; compare speed with top speed
		ble.s	loc_11682							; if speed was already greater than the maximum, branch
		move.w	d1,d0

loc_11682:
		btst	#button_right,(Ctrl_1_logical).w
		beq.s	loc_1169E							; if not holding right, branch
		bclr	#status.player.x_flip,status(a0)
		add.w	d5,d0								; accelerate right in the air
		cmp.w	d6,d0								; compare new speed with top speed
		blt.s	loc_1169E							; if new speed is less than the maximum, branch
		sub.w	d5,d0								; remove this frame's acceleration change
		cmp.w	d6,d0								; compare speed with top speed
		bge.s	loc_1169E							; if speed was already greater than the maximum, branch
		move.w	d6,d0

loc_1169E:
		move.w	d0,x_vel(a0)

Sonic_Jump_ResetScr:
		cmpi.w	#$60,(a5)							; is screen in its default position?
		beq.s	Sonic_JumpPeakDecelerate					; if yes, branch
		bhs.s	loc_116AC							; depending on the sign of the difference
		addq.w	#2+2,(a5)							; either add 2

loc_116AC:
		subq.w	#2,(a5)								; or subtract 2

Sonic_JumpPeakDecelerate:
		cmpi.w	#-$400,y_vel(a0)						; is Sonic moving faster than -$400 upwards?
		blo.s	locret_116DC							; if yes, return
		move.w	x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1								; d1 = x_velocity / 32
		beq.s	locret_116DC							; return if d1 is 0
		bmi.s	Sonic_JumpPeakDecelerateLeft					; branch if moving left
		sub.w	d1,d0								; reduce x velocity by d1
		bhs.s	loc_116CA
		moveq	#0,d0

loc_116CA:
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpPeakDecelerateLeft:
		sub.w	d1,d0								; reduce x velocity by d1
		blo.s	loc_116D8
		moveq	#0,d0

loc_116D8:
		move.w	d0,x_vel(a0)

locret_116DC:
		rts

; ---------------------------------------------------------------------------
; Subroutine to prevent Sonic from leaving the boundaries of a level
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_LevelBound:

		; check xpos
		move.l	x_pos(a0),d1
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		moveq	#16,d0
		add.w	(Camera_min_X_pos).w,d0
		cmp.w	d1,d0								; has Sonic/Knux touched the left boundary?
		bgt.s	Player_Boundary_Sides						; if yes, branch
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#320-24,d0
		cmp.w	d1,d0
		blt.s	Player_Boundary_Sides

	if LevelBoundCheckTop

Player_Boundary_CheckTop:
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		beq.s	Player_Boundary_CheckBottom					; if yes, branch
		tst.b	(Reverse_gravity_flag).w
		bne.s	Player_Boundary_CheckBottom

		; check ypos
		move.l	y_pos(a0),d1
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_min_Y_pos).w,d0
		addq.w	#8,d0
		cmp.w	d1,d0								; has Sonic/Knux touched the up boundary?
		bgt.s	Player_Boundary_Top						; if yes, branch

	endif

Player_Boundary_CheckBottom:
		tst.b	(Disable_death_plane).w
		bne.s	locret_11720
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_11722
		move.w	(Camera_max_Y_pos).w,d0
		cmp.w	(Camera_target_max_Y_pos).w,d0
		blt.s	locret_11720
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0							; has Sonic/Knux touched the bottom boundary?
		blt.s	Player_Boundary_Bottom						; if yes, branch

locret_11720:
		rts
; ---------------------------------------------------------------------------

loc_11722:
		move.w	(Camera_min_Y_pos).w,d0
		cmp.w	y_pos(a0),d0
		blt.s	locret_11720

Player_Boundary_Bottom:
		movea.w	a0,a2
		jmp	Kill_Character(pc)
; ---------------------------------------------------------------------------

Player_Boundary_Sides:
		move.w	d0,x_pos(a0)
		clr.w	2+x_pos(a0)							; subpixel x
		clr.w	x_vel(a0)
		clr.w	ground_vel(a0)

	if ~~LevelBoundCheckTop
		bra.s	Player_Boundary_CheckBottom
	else
		bra.s	Player_Boundary_CheckTop
; ---------------------------------------------------------------------------

Player_Boundary_Top:
		move.w	d0,y_pos(a0)
		clr.w	2+y_pos(a0)							; subpixel y
		clr.w	y_vel(a0)
		bra.s	Player_Boundary_CheckBottom
	endif

; =============== S U B R O U T I N E =======================================

SonicKnux_Roll:
		tst.b	status_secondary(a0)
		bmi.s	locret_1177E

	if PlayerMoveLock
		tst.w	move_lock(a0)
		bne.s	locret_1177E
	else
		cmpi.b	#AniIDSonAni_Slide,anim(a0)
		beq.s	locret_1177E
	endif

		tst.w	(Camera_H_scroll_shift).w
		bne.s	locret_1177E
		moveq	#btnLR,d0							; is left/right being pressed?
		and.b	(Ctrl_1_logical).w,d0
		bne.s	locret_1177E
		btst	#button_down,(Ctrl_1_logical).w					; is down being pressed?
		beq.s	SonicKnux_ChkWalk						; if not, branch
		mvabs.w	ground_vel(a0),d0
		cmpi.w	#$100,d0							; is Sonic moving at $100 speed or faster?
		bhs.s	SonicKnux_ChkRoll						; if so, branch

;		btst	#status.player.on_object,status(a0)				; is Sonic/Knux stand on object?
;		bne.s	locret_1177E							; if yes, branch

		move.b	#AniIDSonAni_Duck,anim(a0)					; enter ducking animation

locret_1177E:
		rts
; ---------------------------------------------------------------------------

SonicKnux_ChkWalk:
		cmpi.b	#AniIDSonAni_Duck,anim(a0)					; is Sonic ducking?
		bne.s	locret_1177E
		clr.b	anim(a0)							; if so, enter walking animation
		rts
; ---------------------------------------------------------------------------

SonicKnux_ChkRoll:
		btst	#status.player.rolling,status(a0)				; is Sonic already rolling?
		beq.s	SonicKnux_DoRoll						; if not, branch
		rts
; ---------------------------------------------------------------------------

SonicKnux_DoRoll:
		bset	#status.player.rolling,status(a0)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)					; enter roll animation
		addq.w	#5,y_pos(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_117C2
		subi.w	#5+5,y_pos(a0)

loc_117C2:
		sfx	sfx_Roll
		tst.w	ground_vel(a0)
		bne.s	locret_117D8
		move.w	#$200,ground_vel(a0)

locret_117D8:
		rts

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Jump:

	if PlayerMoveLock
		tst.w	move_lock(a0)
		bne.s	locret_117D8
	endif

		moveq	#btnABC,d0
		and.b	(Ctrl_1_pressed_logical).w,d0
		beq.s	locret_117D8
		moveq	#0,d0
		move.b	angle(a0),d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_117FC
		addi.b	#$40,d0
		neg.b	d0
		subi.b	#$40,d0

loc_117FC:
		addi.b	#$80,d0
		movem.l	a4-a6,-(sp)
		bsr.w	CalcRoomOverHead
		movem.l	(sp)+,a4-a6
		cmpi.w	#6,d1								; does Sonic have enough room to jump?
		blt.s	locret_117D8							; if not, branch
		move.w	#$680,d2
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	loc_11822
		move.w	#$800,d2							; set higher jump speed if super

loc_11822:
		btst	#status.player.underwater,status(a0)				; test if underwater
		beq.s	loc_1182E
		move.w	#$380,d2							; set lower jump speed if under

loc_1182E:
		moveq	#-$40,d0
		add.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,x_vel(a0)							; make Sonic jump (in X... this adds nothing on level ground)
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,y_vel(a0)							; make Sonic jump (in Y)
		bset	#status.player.in_air,status(a0)
		bclr	#status.player.pushing,status(a0)
		addq.w	#4,sp
		move.b	#1,jumping(a0)
		clr.b	stick_to_convex(a0)
		sfx	sfx_Jump
		move.w	default_y_radius(a0),y_radius(a0)
		btst	#status.player.rolling,status(a0)
		bne.s	locret_118B2
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)					; use "jumping" animation
		bset	#status.player.rolling,status(a0)
		move.b	y_radius(a0),d0
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_118AE
		neg.w	d0

loc_118AE:
		sub.w	d0,y_pos(a0)

locret_118B2:
		rts

; =============== S U B R O U T I N E =======================================

Sonic_JumpHeight:
		tst.b	jumping(a0)							; is Sonic jumping?
		beq.s	Sonic_UpVelCap							; if not, branch

		; check
		move.w	#-$400,d1
		btst	#status.player.underwater,status(a0)				; is Sonic underwater?
		beq.s	loc_118D2							; if not, branch
		move.w	#-$200,d1							; underwater-specific

loc_118D2:
		cmp.w	y_vel(a0),d1							; is y speed greater than 4? (2 if underwater)
		ble.s	Sonic_InstaAndShieldMoves					; if not, branch
		moveq	#btnABC,d0							; are buttons A, B or C being pressed?
		and.b	(Ctrl_1_logical).w,d0
		bne.s	locret_118E8							; if yes, branch
		move.w	d1,y_vel(a0)							; cap jump height

locret_118E8:
		rts
; ---------------------------------------------------------------------------

Sonic_UpVelCap:
		tst.b	spin_dash_flag(a0)						; is Sonic charging his spin dash?
		bne.s	locret_118FE							; if yes, branch
		cmpi.w	#-$FC0,y_vel(a0)						; is Sonic's Y speed faster (less than) than -15.75 (-$FC0)?
		bge.s	locret_118FE							; if not, branch
		move.w	#-$FC0,y_vel(a0)						; cap upward speed

locret_118FE:
		rts
; ---------------------------------------------------------------------------

Sonic_InstaAndShieldMoves:
		tst.b	double_jump_flag(a0)						; is Sonic currently performing a double jump?
		bne.s	locret_118FE							; if yes, branch
		moveq	#btnABC,d0							; are buttons A, B, or C being pressed?
		and.b	(Ctrl_1_pressed_logical).w,d0
		beq.s	locret_118FE							; if not, branch
		tst.b	(Super_Sonic_Knux_flag).w					; check Super-state
		beq.s	Sonic_FireShield						; if not in a super-state, branch
		bmi.w	Sonic_HyperDash							; if Hyper, branch
		move.b	#1,double_jump_flag(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_FireShield:
		btst	#status_secondary.invincible,status_secondary(a0)		; first, does Sonic have invincibility?
		bne.s	locret_118FE							; if yes, branch
		btst	#status_secondary.fire_shield,status_secondary(a0)		; does Sonic have a Fire Shield?
		beq.s	Sonic_LightningShield						; if not, branch
		move.b	#1,(Shield+anim).w
		move.b	#1,double_jump_flag(a0)
		move.w	#$800,d0
		btst	#status.player.x_flip,status(a0)				; is Sonic facing left?
		beq.s	loc_11958							; if not, branch
		neg.w	d0								; reverse speed value, moving Sonic left

loc_11958:
		move.w	d0,x_vel(a0)							; apply velocity...
		move.w	d0,ground_vel(a0)						; ...both ground and air
		clr.w	y_vel(a0)							; kill y-velocity
		move.w	#$2000,(H_scroll_frame_offset).w
		bsr.w	Reset_Player_Position_Array
		sfx	sfx_FireAttack,1						; play Fire Shield attack sound
; ---------------------------------------------------------------------------

Sonic_LightningShield:
		btst	#status_secondary.lightning_shield,status_secondary(a0)		; does Sonic have a Lightning Shield?
		beq.s	Sonic_BubbleShield						; if not, branch
		move.b	#1,(Shield+anim).w
		move.b	#1,double_jump_flag(a0)
		move.w	#-$580,y_vel(a0)						; bounce Sonic up, creating the double jump effect
		clr.b	jumping(a0)
		sfx	sfx_ElectricAttack,1						; play Lightning Shield attack sound
; ---------------------------------------------------------------------------

Sonic_BubbleShield:
		btst	#status_secondary.bubble_shield,status_secondary(a0)		; does Sonic have a Bubble Shield
		beq.s	Sonic_CheckTransform						; if not, branch
		move.b	#1,(Shield+anim).w
		move.b	#1,double_jump_flag(a0)
		clr.w	x_vel(a0)							; halt horizontal speed...
		clr.w	ground_vel(a0)							; ...both ground and air
		move.w	#$800,y_vel(a0)							; force Sonic down
		sfx	sfx_BubbleAttack,1						; play Bubble Shield attack sound

; ---------------------------------------------------------------------------
; Code that transforms Sonic into Super/Hyper Sonic
; if he has enough rings and emeralds
; ---------------------------------------------------------------------------

Sonic_CheckTransform:

		if SonKnuxTransform

	if CheckChaosEmer
		cmpi.b	#7,(Chaos_emerald_count).w					; does Sonic have all 7 Chaos Emeralds?
		blo.s	Sonic_InstaShield						; if not, branch
	endif

		cmpi.w	#50,(Ring_count).w						; does Sonic have at least 50 rings?
		blo.s	Sonic_InstaShield						; if not, perform Insta-Shield
		tst.b	(Level_results_flag).w						; is level over?
		beq.s	Sonic_Transform							; if not, branch
		endif

Sonic_InstaShield:
		btst	#status_secondary.shield,status_secondary(a0)			; does Sonic have an S2 shield (The Elementals were already filtered out at this point)?
		bne.s	locret_11A14							; if yes, branch
		move.b	#1,(Shield+anim).w
		move.b	#1,double_jump_flag(a0)
		sfx	sfx_InstaAttack,1						; play Insta-Shield sound
; ---------------------------------------------------------------------------

locret_11A14:
		rts

; =============== S U B R O U T I N E =======================================

Sonic_Transform:
		move.b	#1,(Super_palette_status).w					; set Super/Hyper palette status to 'fading'
		move.b	#$F,(Palette_timer).w
		move.w	#60,(Super_frame_count).w
		move.l	#Map_SuperSonic,mappings(a0)
		move.b	#$81,object_control(a0)
		move.b	#AniIDSupSonAni_Transform,anim(a0)				; enter 'transformation' animation

	if ~~SuperHyperSonKnux
		; check
		bra.s	.super
	endif

		; set
		st	(Super_Sonic_Knux_flag).w					; set flag to Hyper Sonic
		move.l	#Obj_HyperSonic_Stars,(Invincibility_stars).w			; load Hyper Stars object
		move.l	#Obj_HyperSonicKnux_Trail,(Super_stars).w			; load After-Images object
		bra.s	.continued
; ---------------------------------------------------------------------------

.super
		move.b	#1,(Super_Sonic_Knux_flag).w					; set flag to Super Sonic
		move.l	#Obj_SuperSonicKnux_Stars,(Super_stars).w			; load Super Stars object

.continued
		move.w	#$A00,Max_speed-Max_speed(a4)
		move.w	#$30,Acceleration-Max_speed(a4)
		move.w	#$100,Deceleration-Max_speed(a4)
		clr.b	invincibility_timer(a0)
		bset	#status_secondary.invincible,status_secondary(a0)
		sfx	sfx_SuperTransform
		music	mus_Invincible,1						; play invincibility theme
; ---------------------------------------------------------------------------

Sonic_HyperDash:
		bsr.w	HyperAttackTouchResponse
		move.w	#$2000,(H_scroll_frame_offset).w
		bsr.w	Reset_Player_Position_Array
		move.b	#1,double_jump_flag(a0)
		move.b	#1,(Invincibility_stars+anim).w					; this causes the screen flash, and sparks to come out of Sonic
		sfx	sfx_Dash
		move.b	(Ctrl_1_logical).w,d0
		andi.w	#btnDir,d0							; get D-pad input
		beq.s	.noInput

		; any values totalling $B or above are produced by holding
		; both opposing directions on the D-pad, which is invalid
		cmpi.b	#$B,d0
		bhs.s	.noInput
		add.w	d0,d0
		add.w	d0,d0
		lea	Sonic_HyperDash_Velocities-4(pc,d0.w),a1
		move.w	(a1)+,d0
		move.w	d0,x_vel(a0)
		move.w	d0,ground_vel(a0)
		move.w	(a1)+,d0
		move.w	d0,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

.noInput

		; if there's no directional input, we just dash forward
		move.w	#$800,d0							; go right...
		btst	#status.player.x_flip,status(a0)				; ...unless Sonic is facing left...
		beq.s	.applySpeeds
		neg.w	d0								; ...in which case, go left

.applySpeeds
		move.w	d0,x_vel(a0)
		move.w	d0,ground_vel(a0)
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_HyperDash_Velocities:
		dc.w 0, -$800								; up
		dc.w 0, $800								; down
		dc.w 0, 0								; up + down (shouldn't happen)
		dc.w -$800, 0								; left
		dc.w -$800, -$800							; left + up
		dc.w -$800, $800							; left + down
		dc.w 0, 0								; left + up + down (shouldn't happen)
		dc.w $800, 0								; right
		dc.w $800, -$800							; right + up
		dc.w $800, $800								; right + down
		; everything after this would be bad button combinations
; ---------------------------------------------------------------------------

Tails_Super:
		tst.b	(Super_Tails_flag).w						; is Tails Super?
		beq.w	SonicKnux_SuperHyper.return					; if not, branch
		bra.s	SonicKnux_SuperHyper.continued

; =============== S U B R O U T I N E =======================================

SonicKnux_SuperHyper:
		tst.b	(Super_Sonic_Knux_flag).w
		beq.w	.return								; if not Super/Hyper, return

.continued
		tst.b	(Level_results_flag).w						; is level over?
		bne.s	.revertToNormal							; if yes, branch
		subq.w	#1,(Super_frame_count).w
		bhi.w	.return
		move.w	#60,(Super_frame_count).w
		tst.w	(Ring_count).w
		beq.s	.revertToNormal							; if rings depleted, return to normal

		; this checks if the ring counter needs to be blanked
		; for example, this ticks '10' down to ' 9' instead of '19' (yes, this does happen)
		ori.b	#1,(Update_HUD_ring_count).w					; update ring counter
		cmpi.w	#1,(Ring_count).w
		beq.s	.resetHUD
		cmpi.w	#10,(Ring_count).w
		beq.s	.resetHUD
		cmpi.w	#100,(Ring_count).w
		bne.s	.updateHUD

.resetHUD
		ori.b	#$80,(Update_HUD_ring_count).w					; re-init ring counter

.updateHUD
		subq.w	#1,(Ring_count).w
		bne.s	.return								; if rings aren't depleted, we're done here

		; if rings depleted, return to normal

.revertToNormal
		move.b	#2,(Super_palette_status).w
		move.w	#$1E,(Palette_frame).w
		clr.b	(Super_Sonic_Knux_flag).w
		clr.b	(Super_Tails_flag).w
		st	(Player_prev_frame).w
		tst.b	character_id(a0)						; is this Sonic?
		bne.s	.notSonic
		move.l	#Map_Sonic,mappings(a0)						; if so, load Sonic's normal mappings (was using Super/Hyper mappings)

.notSonic
		move.b	#1,prev_anim(a0)
		move.b	#1,invincibility_timer(a0)
		move.w	#$600,Max_speed-Max_speed(a4)
		move.w	#$C,Acceleration-Max_speed(a4)
		move.w	#$80,Deceleration-Max_speed(a4)
		btst	#status.player.underwater,status(a0)
		beq.s	.return

		; if underwater, apply corrected speed/acceleration/deceleration
		move.w	#$300,Max_speed-Max_speed(a4)
		move.w	#6,Acceleration-Max_speed(a4)
		move.w	#$40,Deceleration-Max_speed(a4)

.return
		rts

; =============== S U B R O U T I N E =======================================

SonicKnux_Spindash:
		tst.b	spin_dash_flag(a0)
		bne.s	loc_11C5E
		cmpi.b	#AniIDSonAni_Duck,anim(a0)
		bne.s	SonicKnux_SuperHyper.return
		moveq	#btnABC,d0
		and.b	(Ctrl_1_pressed_logical).w,d0
		beq.s	SonicKnux_SuperHyper.return
		move.b	#AniIDSonAni_SpinDash,anim(a0)
		sfx	sfx_SpinDash
		addq.w	#4,sp
		move.b	#1,spin_dash_flag(a0)
		clr.w	spin_dash_counter(a0)
		cmpi.b	#12,air_left(a0)						; check air remaining
		blo.s	loc_11C24							; if less than 12, branch
		move.b	#2,anim(a6)							; Dust

loc_11C24:
		bsr.w	Player_LevelBound
		bsr.w	Call_Player_AnglePos

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_11C5C
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_11C4C
		sub.w	d1,x_pos(a0)

loc_11C4C:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_11C58
		add.w	d1,x_pos(a0)

loc_11C58:
		movem.l	(sp)+,a4-a6

locret_11C5C:
		rts
; ---------------------------------------------------------------------------

loc_11C5E:
		btst	#button_down,(Ctrl_1_logical).w
		bne.w	loc_11D16
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)
		addq.w	#5,y_pos(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_11C8C
		subi.w	#5+5,y_pos(a0)

loc_11C8C:
		moveq	#0,d0
		move.b	d0,spin_dash_flag(a0)
		move.b	spin_dash_counter(a0),d0
		add.w	d0,d0
		move.w	word_11CF2(pc,d0.w),ground_vel(a0)
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	loc_11CAC
		move.w	word_11D04(pc,d0.w),ground_vel(a0)

loc_11CAC:
		move.w	ground_vel(a0),d0
		subi.w	#$800,d0
		add.w	d0,d0
		andi.w	#$1F00,d0
		neg.w	d0
		addi.w	#$2000,d0
		lea	(H_scroll_frame_offset).w,a1
		cmpa.w	#Player_1,a0
		beq.s	loc_11CCE
		lea	(H_scroll_frame_offset_P2).w,a1

loc_11CCE:
		move.w	d0,(a1)
		btst	#status.player.x_flip,status(a0)
		beq.s	loc_11CDC
		neg.w	ground_vel(a0)

loc_11CDC:
		bset	#status.player.rolling,status(a0)
		clr.w	anim(a6)							; Dust
		sfx	sfx_Dash
		bra.s	loc_11D5E
; ---------------------------------------------------------------------------

word_11CF2:
		dc.w $800
		dc.w $880
		dc.w $900
		dc.w $980
		dc.w $A00
		dc.w $A80
		dc.w $B00
		dc.w $B80
		dc.w $C00
word_11D04:
		dc.w $B00
		dc.w $B80
		dc.w $C00
		dc.w $C80
		dc.w $D00
		dc.w $D80
		dc.w $E00
		dc.w $E80
		dc.w $F00
; ---------------------------------------------------------------------------

loc_11D16:
		tst.w	spin_dash_counter(a0)
		beq.s	loc_11D2E
		move.w	spin_dash_counter(a0),d0
		lsr.w	#5,d0
		sub.w	d0,spin_dash_counter(a0)
		bhs.s	loc_11D2E
		clr.w	spin_dash_counter(a0)

loc_11D2E:
		moveq	#btnABC,d0
		and.b	(Ctrl_1_pressed_logical).w,d0
		beq.s	loc_11D5E
		move.w	#bytes_to_word(AniIDSonAni_SpinDash,AniIDSonAni_Walk),anim(a0)
		sfx	sfx_SpinDash
		addi.w	#$200,spin_dash_counter(a0)
		cmpi.w	#$800,spin_dash_counter(a0)
		blo.s	loc_11D5E
		move.w	#$800,spin_dash_counter(a0)

loc_11D5E:

	if ExtendedCamera
		moveq	#0,d0
		move.b	spin_dash_counter(a0),d0
		add.w	d0,d0
		move.w	word_11CF2(pc,d0.w),ground_vel(a0)
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots
		move.w	word_11D04(pc,d0.w),ground_vel(a0)

.nots
		btst	#status.player.x_flip,status(a0)
		beq.s	.notflipx
		neg.w	ground_vel(a0)

.notflipx
	endif

		addq.w	#4,sp
		cmpi.w	#$60,(a5)
		beq.s	loc_11D6C
		bhs.s	loc_11D6A
		addq.w	#4,(a5)

loc_11D6A:
		subq.w	#2,(a5)

loc_11D6C:
		bsr.w	Player_LevelBound
		bsr.w	Call_Player_AnglePos

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_11DA4
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_11D94
		sub.w	d1,x_pos(a0)

loc_11D94:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_11DA0
		add.w	d1,x_pos(a0)

loc_11DA0:
		movem.l	(sp)+,a4-a6

locret_11DA4:
		rts

; ---------------------------------------------------------------------------
; Subroutine to slow Sonic walking up a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeResist:
		moveq	#$60,d0
		add.b	angle(a0),d0
		cmpi.b	#$C0,d0
		bhs.s	locret_11DDA
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	ground_vel(a0)
		beq.s	loc_11DDC
		bmi.s	loc_11DD6
		tst.w	d0
		beq.s	locret_11DD4
		add.w	d0,ground_vel(a0)

locret_11DD4:
		rts
; ---------------------------------------------------------------------------

loc_11DD6:
		add.w	d0,ground_vel(a0)

locret_11DDA:
		rts
; ---------------------------------------------------------------------------

loc_11DDC:
		mvabs.w	d0,d1
		cmpi.w	#$D,d1
		blo.s	locret_11DDA
		add.w	d0,ground_vel(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope while he's rolling
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_RollRepel:
		moveq	#$60,d0
		add.b	angle(a0),d0
		cmpi.b	#$C0,d0
		bhs.s	locret_11E28
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	ground_vel(a0)
		bmi.s	loc_11E1E
		tst.w	d0
		bpl.s	loc_11E18
		asr.l	#2,d0

loc_11E18:
		add.w	d0,ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_11E1E:
		tst.w	d0
		bmi.s	loc_11E24
		asr.l	#2,d0

loc_11E24:
		add.w	d0,ground_vel(a0)

locret_11E28:
		rts

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeRepel:
		tst.b	stick_to_convex(a0)
		bne.s	locret_11E6E
		tst.w	move_lock(a0)
		bne.s	loc_11E86
		moveq	#$18,d0
		add.b	angle(a0),d0
		cmpi.b	#$30,d0
		blo.s	locret_11E6E
		mvabs.w	ground_vel(a0),d0
		cmpi.w	#$280,d0
		bhs.s	locret_11E6E
		move.w	#30,move_lock(a0)
		moveq	#$30,d0
		add.b	angle(a0),d0
		cmpi.b	#$60,d0
		blo.s	loc_11E70
		bset	#status.player.in_air,status(a0)

locret_11E6E:
		rts
; ---------------------------------------------------------------------------

loc_11E70:
		cmpi.b	#$30,d0
		blo.s	loc_11E7E
		addi.w	#$80,ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_11E7E:
		subi.w	#$80,ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_11E86:
		subq.w	#1,move_lock(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to return Sonic's angle to 0 as he jumps
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_JumpAngle:
		move.b	angle(a0),d0							; get Sonic's angle
		beq.s	Player_JumpFlip							; if already 0, branch
		bpl.s	loc_11E9C							; if higher than 0, branch
		addq.b	#2,d0								; increase angle
		bhs.s	loc_11E9A
		moveq	#0,d0

loc_11E9A:
		bra.s	Player_JumpAngleSet
; ---------------------------------------------------------------------------

loc_11E9C:
		subq.b	#2,d0								; decrease angle
		bhs.s	Player_JumpAngleSet
		moveq	#0,d0

Player_JumpAngleSet:
		move.b	d0,angle(a0)
		; continue straight to Player_JumpFlip

; ---------------------------------------------------------------------------
; Updates Sonic's secondary angle if he's tumbling
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_JumpFlip:
		move.b	flip_angle(a0),d0
		beq.s	locret_11EEA
		tst.w	ground_vel(a0)
		bmi.s	Player_JumpLeftFlip

Player_JumpRightFlip:
		move.b	flip_speed(a0),d1
		add.b	d1,d0
		bhs.s	loc_11EC8
		subq.b	#1,flips_remaining(a0)
		bhs.s	loc_11EC8
		moveq	#0,d0
		move.b	d0,flips_remaining(a0)

loc_11EC8:
		bra.s	Player_JumpFlipSet
; ---------------------------------------------------------------------------

Player_JumpLeftFlip:
		tst.b	flip_type(a0)
		bmi.s	Player_JumpRightFlip
		move.b	flip_speed(a0),d1
		sub.b	d1,d0
		bhs.s	Player_JumpFlipSet
		subq.b	#1,flips_remaining(a0)
		bhs.s	Player_JumpFlipSet
		moveq	#0,d0
		move.b	d0,flips_remaining(a0)

Player_JumpFlipSet:
		move.b	d0,flip_angle(a0)

locret_11EEA:
		rts

; ---------------------------------------------------------------------------
; Subroutine for Sonic to interact with the floor and walls when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SonicKnux_DoLevelCollision:
		move.l	(Primary_collision_addr).w,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	.check
		move.l	(Secondary_collision_addr).w,(Collision_addr).w

.check
		move.b	lrb_solid_bit(a0),d5
		movem.w	x_vel(a0),d1-d2	; load xy speed
		jsr	(GetArcTan).w
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Player_HitLeftWall
		cmpi.b	#$80,d0
		beq.w	Player_HitCeilingAndWalls
		cmpi.b	#$C0,d0
		beq.w	loc_12102
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_11F44
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop Sonic since he hit a wall

loc_11F44:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_11F56
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop Sonic since he hit a wall

loc_11F56:
		bsr.s	sub_11FD6
		tst.w	d1
		bpl.s	locret_11FD4
		move.b	y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_11F6E
		cmp.b	d2,d0
		blt.s	locret_11FD4

loc_11F6E:
		move.b	d3,angle(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_11F7A
		neg.w	d1

loc_11F7A:
		add.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_11FAE
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.s	loc_11F9C
		asr.w	y_vel(a0)
		bra.s	loc_11FC2
; ---------------------------------------------------------------------------

loc_11F9C:
		clr.w	y_vel(a0)
		move.w	x_vel(a0),ground_vel(a0)
		bra.w	Player_TouchFloor
; ---------------------------------------------------------------------------

loc_11FAE:
		clr.w	x_vel(a0)							; stop Sonic since he hit a wall
		cmpi.w	#$FC0,y_vel(a0)
		ble.s	loc_11FC2
		move.w	#$FC0,y_vel(a0)

loc_11FC2:
		bsr.w	Player_TouchFloor
		move.w	y_vel(a0),ground_vel(a0)
		tst.b	d3
		bpl.s	locret_11FD4
		neg.w	ground_vel(a0)

locret_11FD4:
		rts

; =============== S U B R O U T I N E =======================================

sub_11FD6:
		tst.b	(Reverse_gravity_flag).w
		beq.w	Sonic_CheckFloor
		bsr.w	Sonic_CheckCeiling
		addi.b	#$40,d3
		neg.b	d3
		subi.b	#$40,d3
		rts

; =============== S U B R O U T I N E =======================================

sub_11FEE:
		tst.b	(Reverse_gravity_flag).w
		beq.w	Sonic_CheckCeiling2
		bsr.w	Sonic_CheckFloor2
		addi.b	#$40,d3
		neg.b	d3
		subi.b	#$40,d3
		rts

; =============== S U B R O U T I N E =======================================

ChooseChkFloorEdge:
		tst.b	(Reverse_gravity_flag).w
		beq.w	ChkFloorEdge_Part2
		bra.w	ChkFloorEdge_ReverseGravity
; ---------------------------------------------------------------------------

Player_HitLeftWall:
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	Player_HitCeiling						; branch if distance is positive (not inside wall)
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop Sonic since he hit a wall
		move.w	y_vel(a0),ground_vel(a0)

Player_HitCeiling:
		bsr.s	sub_11FEE
		tst.w	d1
		bpl.s	loc_12068							; branch if distance is positive (not inside ceiling)
		neg.w	d1
		cmpi.w	#$14,d1
		bhs.s	loc_12054
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_12042
		neg.w	d1

loc_12042:
		add.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_12052
		clr.w	y_vel(a0)							; stop Sonic in y since he hit a ceiling

locret_12052:
		rts
; ---------------------------------------------------------------------------

loc_12054:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	locret_12066
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)

locret_12066:
		rts
; ---------------------------------------------------------------------------

loc_12068:
		tst.b	(WindTunnel_flag).w
		bne.s	loc_12074
		tst.w	y_vel(a0)
		bmi.s	locret_12066

loc_12074:
		bsr.w	sub_11FD6
		tst.w	d1
		bpl.s	locret_12066
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_12084
		neg.w	d1

loc_12084:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		clr.w	y_vel(a0)
		move.w	x_vel(a0),ground_vel(a0)
		bra.w	Player_TouchFloor
; ---------------------------------------------------------------------------

Player_HitCeilingAndWalls:
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_120B0
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop Sonic since he hit a wall

loc_120B0:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_120C2
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop Sonic since he hit a wall

loc_120C2:
		bsr.w	sub_11FEE
		tst.w	d1
		bpl.s	locret_12100
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_120D2
		neg.w	d1

loc_120D2:
		sub.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_120EA
		clr.w	y_vel(a0)							; stop Sonic in y since he hit a ceiling
		rts
; ---------------------------------------------------------------------------

loc_120EA:
		move.b	d3,angle(a0)
		bsr.s	Player_TouchFloor
		move.w	y_vel(a0),ground_vel(a0)
		tst.b	d3
		bpl.s	locret_12100
		neg.w	ground_vel(a0)

locret_12100:
		rts
; ---------------------------------------------------------------------------

loc_12102:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_1211A
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)
		move.w	y_vel(a0),ground_vel(a0)

loc_1211A:
		bsr.w	sub_11FEE
		tst.w	d1
		bpl.s	loc_1213C
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_1212A
		neg.w	d1

loc_1212A:
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_1213A
		clr.w	y_vel(a0)

locret_1213A:
		rts
; ---------------------------------------------------------------------------

loc_1213C:
		tst.b	(WindTunnel_flag).w
		bne.s	loc_12148
		tst.w	y_vel(a0)
		bmi.s	locret_1213A

loc_12148:
		bsr.w	sub_11FD6
		tst.w	d1
		bpl.s	locret_1213A
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_12158
		neg.w	d1

loc_12158:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		clr.w	y_vel(a0)
		move.w	x_vel(a0),ground_vel(a0)

; =============== S U B R O U T I N E =======================================

Player_TouchFloor:
		cmpi.b	#PlayerID_Tails,character_id(a0)				; is player Tails?
		beq.w	Tails_TouchFloor_Check_Spindash					; if yes, branch
		cmpi.b	#PlayerID_Knuckles,character_id(a0)				; is player Knuckles?
		beq.w	Knux_TouchFloor_Check_Spindash					; if yes, branch

Sonic_TouchFloor_Check_Spindash:
		tst.b	spin_dash_flag(a0)
		bne.s	loc_121D8
		clr.b	anim(a0)							; AniIDSonAni_Walk

Sonic_TouchFloor:
		move.b	y_radius(a0),d0
		move.w	default_y_radius(a0),y_radius(a0)				; set y_radius and x_radius
		btst	#status.player.rolling,status(a0)
		beq.s	loc_121D8
		bclr	#status.player.rolling,status(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_121C4
		neg.w	d0

loc_121C4:
		move.w	d0,-(sp)
		moveq	#$40,d0
		add.b	angle(a0),d0
		bpl.s	loc_121D2
		neg.w	(sp)

loc_121D2:
		move.w	(sp)+,d0
		add.w	d0,y_pos(a0)

loc_121D8:
		bclr	#status.player.in_air,status(a0)
		bclr	#status.player.pushing,status(a0)
		moveq	#0,d0
		move.b	d0,jumping(a0)
		move.w	d0,(Chain_bonus_counter).w
		move.b	d0,flip_angle(a0)
		move.b	d0,flip_type(a0)
		move.b	d0,flips_remaining(a0)
		move.b	d0,scroll_delay_counter(a0)
		tst.b	double_jump_flag(a0)
		beq.s	locret_12230
		tst.b	(Super_Sonic_Knux_flag).w
		bne.s	loc_1222A
		btst	#status_secondary.invincible,status_secondary(a0)		; don't bounce when invincible
		bne.s	loc_1222A
		btst	#status_secondary.bubble_shield,status_secondary(a0)
		beq.s	loc_1222A
		bsr.s	BubbleShield_Bounce

loc_1222A:
		clr.b	double_jump_flag(a0)

locret_12230:
		rts

; =============== S U B R O U T I N E =======================================

BubbleShield_Bounce:
		movem.l	d1-d2,-(sp)
		move.w	#$780,d2
		btst	#status.player.underwater,status(a0)				; is Sonic underwater?
		beq.s	.isdry								; if not, branch
		move.w	#$400,d2

.isdry
		moveq	#-$40,d0
		add.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,y_vel(a0)
		movem.l	(sp)+,d1-d2
		bset	#status.player.in_air,status(a0)
		bclr	#status.player.pushing,status(a0)
		move.b	#1,jumping(a0)
		clr.b	stick_to_convex(a0)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)
		bset	#status.player.rolling,status(a0)
		move.b	y_radius(a0),d0
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	.notgrav
		neg.w	d0

.notgrav
		sub.w	d0,y_pos(a0)
		move.b	#2,(Shield+anim).w
		sfx	sfx_BubbleAttack,1

; =============== S U B R O U T I N E =======================================

Sonic_Hurt:

	if GameDebug
		tst.b	(Debug_mode_flag).w
		beq.s	.nodebug
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	.nodebug
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Ctrl_1_locked).w						; unlock control
		rts
; ---------------------------------------------------------------------------
.nodebug
	endif

		jsr	(MoveSprite2_TestGravity).w
		addi.w	#$30,y_vel(a0)
		btst	#status.player.underwater,status(a0)
		beq.s	loc_122F2
		subi.w	#$20,y_vel(a0)

loc_122F2:
		cmpi.w	#-$100,(Camera_min_Y_pos).w
		bne.s	loc_12302
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)

loc_12302:
		bsr.s	sub_12318
		bsr.w	Player_LevelBound
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Water
		bsr.w	sub_125E0
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_12318:
		tst.b	(Disable_death_plane).w
		bne.s	loc_12344
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_12336
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		blt.s	loc_1238A
		bra.s	loc_12344
; ---------------------------------------------------------------------------

loc_12336:
		move.w	(Camera_min_Y_pos).w,d0
		cmp.w	y_pos(a0),d0
		blt.s	loc_12344
		bra.s	loc_1238A
; ---------------------------------------------------------------------------

loc_12344:
		movem.l	a4-a6,-(sp)
		bsr.w	SonicKnux_DoLevelCollision
		movem.l	(sp)+,a4-a6
		btst	#status.player.in_air,status(a0)				; is the player in the air?
		bne.s	locret_12388							; if yes, branch
		moveq	#0,d0
		move.l	d0,x_vel(a0)
		move.w	d0,ground_vel(a0)
		move.b	d0,object_control(a0)
		move.b	d0,anim(a0)							; AniIDSonAni_Walk
		move.b	d0,spin_dash_flag(a0)
		move.w	#priority_2,priority(a0)
		move.b	#PlayerID_Control,routine(a0)
		move.b	#2*60,invulnerability_timer(a0)

locret_12388:
		rts
; ---------------------------------------------------------------------------

loc_1238A:
		movea.w	a0,a2
		jmp	Kill_Character(pc)

; =============== S U B R O U T I N E =======================================

Sonic_Death:

	if GameDebug
		tst.b	(Debug_mode_flag).w
		beq.s	.nodebug
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	.nodebug
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Ctrl_1_locked).w						; unlock control
		rts
; ---------------------------------------------------------------------------
.nodebug
	endif

		bsr.s	sub_123C2
		jsr	(MoveSprite_TestGravity).w
		bsr.w	Sonic_RecordPos
		bsr.w	sub_125E0
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_123C2:
		cmpa.w	#Player_1,a0
		bne.s	.sidekick
		st	(Scroll_lock).w

.sidekick
		move.w	(Camera_Y_pos).w,d0
		clr.b	spin_dash_flag(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_123FA
		subi.w	#$10,d0
		cmp.w	y_pos(a0),d0
		bge.s	loc_12410

locret_123F8:
		rts
; ---------------------------------------------------------------------------

loc_123FA:
		addi.w	#$100,d0
		cmp.w	y_pos(a0),d0
		bge.s	locret_123F8

loc_12410:
		cmpi.b	#PlayerID_Tails,character_id(a0)				; is player Tails?
		bne.s	loc_12432							; if not, branch
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w				; is Tails alone?
		beq.s	loc_12432							; if yes, branch
		move.b	#PlayerID_Control,routine(a0)
		bra.w	sub_13ECA
; ---------------------------------------------------------------------------

loc_12432:
		move.b	#PlayerID_Restart,routine(a0)
		move.w	#1*60,restart_timer(a0)
		clr.b	(Respawn_table_keep).w
		addq.b	#1,(Update_HUD_life_count).w
		subq.b	#1,(Life_count).w
		bne.s	loc_12498
		clr.w	restart_timer(a0)
		moveq	#0,d1								; current slot
		move.l	#Render_GameOver,d0						; load GAME OVER
		jsr	(AddSlot_ExtraRender).w
		clr.b	(GameOver_RAM.status).w
		clr.b	(Time_over_flag).w

loc_12478:
		clr.b	(Update_HUD_timer).w
		move.b	#PlayerID_Restart,routine(a0)
		music	mus_GameOver							; play the Game Over song

		; load game over art
		QueueKosPlusModule	ArtKosPM_GameOver, ArtTile_Shield, 1
; ---------------------------------------------------------------------------

loc_12498:
		tst.b	(Time_over_flag).w
		beq.s	locret_1258E
		clr.w	restart_timer(a0)
		moveq	#0,d1								; current slot
		move.l	#Render_GameOver,d0						; load TIME OVER
		jsr	(AddSlot_ExtraRender).w
		clr.b	(GameOver_RAM.status).w
		bra.s	loc_12478

; =============== S U B R O U T I N E =======================================

Sonic_Restart:
		tst.w	restart_timer(a0)
		beq.s	locret_1258E
		subq.w	#1,restart_timer(a0)
		bne.s	locret_1258E
		st	(Restart_level_flag).w

locret_1258E:
		rts

; =============== S U B R O U T I N E =======================================

loc_12590:
		tst.w	(H_scroll_amount).w
		bne.s	.skip
		tst.w	(V_scroll_amount).w
		bne.s	.skip
		move.b	#PlayerID_Control,routine(a0)

.skip
		bsr.s	sub_125E0
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sonic_Drown:

	if GameDebug
		tst.b	(Debug_mode_flag).w
		beq.s	.nodebug
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	.nodebug
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Ctrl_1_locked).w						; unlock control
		rts
; ---------------------------------------------------------------------------
.nodebug
	endif

		jsr	(MoveSprite2_TestGravity).w
		addi.w	#$10,y_vel(a0)
		bsr.w	Sonic_RecordPos
		bsr.s	sub_125E0
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_125E0:
		bsr.s	Animate_Sonic
		tst.b	(Reverse_gravity_flag).w
		beq.s	.notgrav
		eori.b	#setBit(render_flags.y_flip),render_flags(a0)

.notgrav
		bra.w	Sonic_Load_PLC

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
		lea	(AniSonic).l,a1
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots

.ssani		:= AniSuperSonic-AniSonic						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.ssani)(a1),a1

.nots
		moveq	#0,d0
		move.b	anim(a0),d0
		cmp.b	prev_anim(a0),d0
		beq.s	SAnim_Do
		move.b	d0,prev_anim(a0)
		clr.b	anim_frame(a0)
		clr.b	anim_frame_timer(a0)
		bclr	#status.player.pushing,status(a0)

SAnim_Do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	SAnim_WalkRun

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d1

		and.b	status(a0),d1

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		or.b	d1,render_flags(a0)
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	SAnim_Delay
		move.b	d0,anim_frame_timer(a0)

SAnim_Do2:
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#-4,d0
		bhs.s	SAnim_End_FF

SAnim_Next:
		move.b	d0,mapping_frame(a0)
		addq.b	#1,anim_frame(a0)

SAnim_Delay:
		rts
; ---------------------------------------------------------------------------

SAnim_End_FF:
		addq.b	#1,d0
		bne.s	SAnim_End_FE
		clr.b	anim_frame(a0)
		move.b	1(a1),d0
		bra.s	SAnim_Next
; ---------------------------------------------------------------------------

SAnim_End_FE:
		addq.b	#1,d0
		bne.s	SAnim_End_FD
		move.b	2(a1,d1.w),d0
		sub.b	d0,anim_frame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	SAnim_Next
; ---------------------------------------------------------------------------

SAnim_End_FD:
		addq.b	#1,d0
		bne.s	SAnim_End
		move.b	2(a1,d1.w),anim(a0)

SAnim_End:
		rts
; ---------------------------------------------------------------------------

SAnim_WalkRun:
		addq.b	#1,d0
		bne.w	loc_12A2A
		moveq	#0,d0
		tst.b	flip_type(a0)
		bmi.w	loc_127C0
		move.b	flip_angle(a0),d0
		bne.w	loc_127C0
		moveq	#0,d1
		move.b	angle(a0),d0
		bmi.s	loc_126C8
		beq.s	loc_126C8
		subq.b	#1,d0

loc_126C8:

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_126D4
		not.b	d0

loc_126D4:
		addi.b	#$10,d0
		bpl.s	loc_126DC
		moveq	#3,d1

loc_126DC:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		btst	#status.player.pushing,status(a0)
		bne.w	SAnim_Push
		lsr.b	#4,d0
		andi.b	#6,d0
		mvabs.w	ground_vel(a0),d2
		add.w	(Camera_H_scroll_shift).w,d2
		tst.b	status_secondary(a0)
		bpl.s	loc_1270A
		add.w	d2,d2

loc_1270A:
		tst.b	(Super_Sonic_Knux_flag).w
		bne.s	loc_12766

		; check
		lea	(SonAni_Run).l,a1						; use running animation
		cmpi.w	#$600,d2
		bhs.s	loc_12724

.sani		:= SonAni_Walk-SonAni_Run						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.sani)(a1),a1							; use walking animation
		add.b	d0,d0

loc_12724:
		add.b	d0,d0
		move.b	d0,d3
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#-1,d0
		bne.s	loc_12742
		clr.b	anim_frame(a0)
		move.b	1(a1),d0

loc_12742:
		move.b	d0,mapping_frame(a0)
		add.b	d3,mapping_frame(a0)
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	locret_12764
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_1275A
		moveq	#0,d2

loc_1275A:
		move.w	d2,-(sp)
		move.b	(sp)+,d2
		move.b	d2,anim_frame_timer(a0)
		addq.b	#1,anim_frame(a0)

locret_12764:
		rts
; ---------------------------------------------------------------------------

loc_12766:

		; check
		lea	(SuperSonAni_Run).l,a1
		cmpi.w	#$800,d2
		bhs.s	loc_1277E

.sani		:= SuperSonAni_Walk-SuperSonAni_Run					; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.sani)(a1),a1
		add.b	d0,d0
		add.b	d0,d0
		bra.s	loc_12780
; ---------------------------------------------------------------------------

loc_1277E:
		add.b	d0,d0

loc_12780:
		move.b	d0,d3
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#-1,d0
		bne.s	loc_1279C
		clr.b	anim_frame(a0)
		move.b	1(a1),d0

loc_1279C:
		move.b	d0,mapping_frame(a0)
		add.b	d3,mapping_frame(a0)
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	locret_127BE
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_127B4
		moveq	#0,d2

loc_127B4:
		move.w	d2,-(sp)
		move.b	(sp)+,d2
		move.b	d2,anim_frame_timer(a0)
		addq.b	#1,anim_frame(a0)

locret_127BE:
		rts
; ---------------------------------------------------------------------------

loc_127C0:
		moveq	#$7F,d1
		and.b	flip_type(a0),d1
		bne.s	loc_12872
		move.b	flip_angle(a0),d0
		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_1281E

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		tst.b	flip_type(a0)
		bpl.s	loc_12806
		ori.b	#( \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		neg.b	d0
		addi.b	#$8F,d0
		bra.s	loc_1280A
; ---------------------------------------------------------------------------

loc_12806:
		addi.b	#$B,d0

loc_1280A:
		divu.w	#$16,d0
		addi.b	#$31,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_1281E:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		ori.b	#( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		neg.b	d0
		addi.b	#$8F,d0
		divu.w	#$16,d0
		addi.b	#$31,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

byte_1286E:	dc.b 0, $3D, $49, $49
	even
; ---------------------------------------------------------------------------

loc_12872:
		move.b	byte_1286E(pc,d1.w),d3
		cmpi.b	#1,d1
		bne.s	loc_128CA
		move.b	flip_angle(a0),d0
		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_128A8

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		addi.b	#-8,d0
		divu.w	#$16,d0
		add.b	d3,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_128A8:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		ori.b	#render_flags.y_flip,render_flags(a0)
		addi.b	#-8,d0
		divu.w	#$16,d0
		add.b	d3,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_128CA:
		cmpi.b	#2,d1
		bne.s	loc_12920
		move.b	flip_angle(a0),d0
		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_128FC

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		addi.b	#$B,d0
		divu.w	#$16,d0
		add.b	d3,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_128FC:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		ori.b	#( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		neg.b	d0
		addi.b	#$8F,d0
		divu.w	#$16,d0
		add.b	d3,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_12920:
		cmpi.b	#3,d1
		bne.s	loc_1297C
		move.b	flip_angle(a0),d0
		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_1295A

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		ori.b	#( \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		neg.b	d0
		addi.b	#$8F,d0
		divu.w	#$16,d0
		add.b	d3,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_1295A:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		ori.b	#render_flags.y_flip,render_flags(a0)
		addi.b	#$B,d0
		divu.w	#$16,d0
		add.b	d3,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_1297C:
		cmpi.b	#4,d1
		bne.s	loc_129F6
		move.b	flip_angle(a0),d0
		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_129BC

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		tst.b	flip_type(a0)
		bpl.s	loc_129A4
		addi.b	#$B,d0
		bra.s	loc_129A8
; ---------------------------------------------------------------------------

loc_129A4:
		addi.b	#$B,d0

loc_129A8:
		divu.w	#$16,d0
		addi.b	#$31,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_129BC:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		tst.b	flip_type(a0)
		bpl.s	loc_129D6
		ori.b	#( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		neg.b	d0
		addi.b	#$8F,d0
		bra.s	loc_129E2
; ---------------------------------------------------------------------------

loc_129D6:
		ori.b	#( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		neg.b	d0
		addi.b	#$8F,d0

loc_129E2:
		divu.w	#$16,d0
		addi.b	#$31,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_129F6:
		move.b	flip_angle(a0),d0

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		beq.s	loc_12A12
		ori.b	#render_flags.y_flip,render_flags(a0)

loc_12A12:
		addi.b	#$B,d0
		divu.w	#$16,d0
		addi.b	#$31,d0
		move.b	d0,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		rts
; ---------------------------------------------------------------------------

loc_12A2A:

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d1

		and.b	status(a0),d1

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		or.b	d1,render_flags(a0)
		subq.b	#1,anim_frame_timer(a0)
		bpl.w	SAnim_Delay
		mvabs.w	ground_vel(a0),d2
		add.w	(Camera_H_scroll_shift).w,d2

		; check
		lea	(SonAni_Roll2).l,a1						; use roll 2 animation
		cmpi.w	#$600,d2
		bhs.s	loc_12A5E

.sani		:= SonAni_Roll-SonAni_Roll2						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.sani)(a1),a1							; use roll animation

loc_12A5E:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_12A68
		moveq	#0,d2

loc_12A68:
		move.w	d2,-(sp)
		move.b	(sp)+,d2
		move.b	d2,anim_frame_timer(a0)
		bra.w	SAnim_Do2
; ---------------------------------------------------------------------------

SAnim_Push:
		subq.b	#1,anim_frame_timer(a0)
		bpl.w	SAnim_Delay
		move.w	ground_vel(a0),d2
		bmi.s	loc_12A82
		neg.w	d2

loc_12A82:
		addi.w	#$800,d2
		bpl.s	loc_12A8A
		moveq	#0,d2

loc_12A8A:
		lsr.w	#6,d2
		move.b	d2,anim_frame_timer(a0)

		; check
		lea	(SonAni_Push).l,a1						; use push animation
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	loc_12AA2

.sani		:= SuperSonAni_Push-SonAni_Push						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.sani)(a1),a1

loc_12AA2:
		bra.w	SAnim_Do2

; =============== S U B R O U T I N E =======================================

Sonic_Load_PLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0

Sonic_Load_PLC2:
		cmp.b	(Player_prev_frame).w,d0
		beq.s	.return
		move.b	d0,(Player_prev_frame).w

		; load
		add.w	d0,d0
		lea	(DPLC_Sonic).l,a2
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	.nots

.sdplc		:= DPLC_SuperSonic-DPLC_Sonic						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.sdplc)(a2),a2

.nots
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.return
		move.l	#dmaSource(ArtUnc_Sonic),d6

		; check
		move.w	#tiles_to_bytes(ArtTile_Player_1),d4				; normal
		cmpi.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; is game mode Special Stage?
		bne.s	.readentry							; if not, branch
		move.w	#tiles_to_bytes($79C),d4					; Special Stage

.readentry
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		move.w	d3,-(sp)
		move.b	(sp)+,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#4,d1
		add.l	d6,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(Add_To_DMA_Queue).w
		dbf	d5,.readentry

.return
		rts

; =============== S U B R O U T I N E =======================================

Perform_Player_DPLC:
		tst.b	character_id(a1)						; is the player Sonic?
		beq.s	Sonic_Load_PLC2							; if so, branch
		cmpi.b	#PlayerID_Tails,character_id(a1)				; is player Tails?
		beq.w	Tails_Load_PLC2							; if so, branch
		bra.w	Knuckles_Load_PLC2
