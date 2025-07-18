; ---------------------------------------------------------------------------
; Tails (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Tails:

		; load some addresses into registers
		; this is done to allow some subroutines to be
		; shared with Tails/Knuckles.

		lea	(Max_speed_P2).w,a4
		lea	(Distance_from_top_P2).w,a5
		lea	(Dust_P2).w,a6

	if GameDebug
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	Tails_Normal
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		beq.s	Tails_Normal							; if not, branch

		; debug only code
		cmpi.b	#1,(Debug_placement_type).w					; are Tails in debug object placement mode?
		beq.s	loc_136A8							; if so, skip to debug mode routine

		; by this point, we're assuming you're in frame cycling mode
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	.next
		clr.w	(Debug_placement_mode).w					; leave debug mode

.next
		addq.b	#1,mapping_frame(a0)						; next frame
		cmpi.b	#((Map_Tails_end-Map_Tails)/2)-1,mapping_frame(a0)		; have we reached the end of Tails's frames?
		blo.s	.draw
		clr.b	mapping_frame(a0)						; if so, reset to Tails's first frame

.draw
		bsr.w	Tails_Load_PLC
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_136A8:
		jmp	(Debug_Mode).l
; ---------------------------------------------------------------------------

Tails_Normal:
	endif

		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Tails_Index(pc,d0.w),d0
		jmp	Tails_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Tails_Index: offsetTable
		ptrTableEntry.w Tails_Init						; 0
		ptrTableEntry.w Tails_Control						; 2
		ptrTableEntry.w Tails_Hurt						; 4
		ptrTableEntry.w Tails_Death						; 6
		ptrTableEntry.w Tails_Restart						; 8
		ptrTableEntry.w loc_157F4						; A
		ptrTableEntry.w Tails_Drown						; C
; ---------------------------------------------------------------------------

Tails_Init:										; Routine 0
		addq.b	#2,routine(a0)							; => Tails_Control
		move.w	#bytes_to_word(30/2,18/2),y_radius(a0)				; set y_radius and x_radius ; this sets Tails's collision height (2*pixels)
		move.w	y_radius(a0),default_y_radius(a0)				; set default_y_radius and default_x_radius
		move.l	#Map_Tails,mappings(a0)
		move.l	#bytes_word_to_long(48/2,48/2,priority_2),height_pixels(a0)	; set height, width and priority

		; use screen coordinates
		move.b	#( \
			setBit(render_flags.level) | \
			setBit(render_flags.on_screen) \
		),render_flags(a0)

		move.b	#PlayerID_Tails,character_id(a0)
		move.w	#$600,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$C,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$80,Deceleration_P2-Max_speed_P2(a4)
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	loc_1375E
		tst.b	(Last_star_post_hit).w
		bne.s	Tails_Init_Continued

		; only happens when not starting at a checkpoint:
		move.w	#make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
		move.w	#bytes_to_word($C,$D),top_solid_bit(a0)

		cmpi.b	#2,(Special_bonus_entry_flag).w
		beq.s	Tails_Init_Continued

		; only happens when not starting at a Special Stage ring:
		move.w	x_pos(a0),(Saved_X_pos).w
		move.w	y_pos(a0),(Saved_Y_pos).w
		move.w	art_tile(a0),(Saved_art_tile).w
		move.w	top_solid_bit(a0),(Saved_solid_bits).w
		bra.s	Tails_Init_Continued
; ---------------------------------------------------------------------------

loc_1375E:
		move.w	#make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
		move.w	(Player_1+top_solid_bit).w,top_solid_bit(a0)
		tst.w	(Player_1+art_tile).w
		bpl.s	Tails_Init_Continued
		ori.w	#high_priority,art_tile(a0)

Tails_Init_Continued:
		clr.b	flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.b	#30,air_left(a0)
		cmpi.w	#$20,(Tails_CPU_routine).w
		beq.s	loc_137A4
		cmpi.w	#$12,(Tails_CPU_routine).w
		beq.s	loc_137A4
		clr.w	(Tails_CPU_routine).w

loc_137A4:
		clr.w	(Tails_CPU_idle_timer).w
		clr.w	(Tails_CPU_flight_timer).w
		move.l	#Obj_Tails_Tail,(Tails_tails+address).w
		move.w	a0,(Tails_tails+objoff_30).w
		move.b	(Last_star_post_hit).w,(Tails_CPU_star_post_flag).w
		rts
; ---------------------------------------------------------------------------

Tails_Control:

	if GameDebug
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	loc_13808
		tst.b	(Debug_mode_flag).w
		beq.s	loc_13808
		bclr	#button_A,(Ctrl_1_pressed).w
		beq.s	loc_137E0
		eori.b	#1,(Reverse_gravity_flag).w

loc_137E0:
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	loc_13808
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Ctrl_1_locked).w						; unlock control
		btst	#button_C,(Ctrl_1_held).w
		beq.s	locret_13806
		move.w	#2,(Debug_placement_mode).w
		clr.b	anim(a0)							; AniIDSonAni_Walk

locret_13806:
		rts
; ---------------------------------------------------------------------------

loc_13808:
	endif

		cmpa.w	#Player_1,a0
		bne.s	loc_13830
		move.w	(Ctrl_1_logical).w,(Ctrl_2_logical).w
		tst.b	(Ctrl_1_locked).w
		bne.s	loc_1384A
		move.w	(Ctrl_1).w,(Ctrl_2_logical).w
		move.w	(Ctrl_1).w,(Ctrl_1_logical).w
		cmpi.w	#$1A,(Tails_CPU_routine).w
		bhs.s	loc_13840
		bra.s	loc_1384A
; ---------------------------------------------------------------------------

loc_13830:
		tst.b	(Ctrl_2_locked).w
		beq.s	loc_1383A
		bpl.s	loc_13840
		bra.s	loc_1384A
; ---------------------------------------------------------------------------

loc_1383A:
		move.w	(Ctrl_2).w,(Ctrl_2_logical).w

loc_13840:
		bsr.w	Tails_CPU_Control

loc_1384A:
		btst	#0,object_control(a0)
		beq.s	loc_13872
		clr.b	double_jump_flag(a0)
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_1388C
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w
		bra.s	loc_1388C
; ---------------------------------------------------------------------------

loc_13872:
		movem.l	a4-a6,-(sp)

		moveq	#signextendB( \
			setBit(status.player.in_air) | \
			setBit(status.player.rolling) \
		),d0

		and.b	status(a0),d0
		move.w	Tails_Modes(pc,d0.w),d0
		jsr	Tails_Modes(pc,d0.w)						; run Tails's movement control code
		movem.l	(sp)+,a4-a6

loc_1388C:
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		bne.s	.display							; if not, branch
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)							; perform wrapping of Tails's y position

.display
		bsr.s	Tails_Display
		bsr.w	Tails_Super
		bsr.w	Sonic_RecordPos
		bsr.w	Tails_Water
		move.b	(Primary_Angle).w,next_tilt(a0)
		move.b	(Secondary_Angle).w,tilt(a0)
		tst.b	(WindTunnel_flag_P2).w
		beq.s	.anim
		tst.b	anim(a0)							; AniIDSonAni_Walk
		bne.s	.anim
		move.b	prev_anim(a0),anim(a0)

.anim
		btst	#1,object_control(a0)
		bne.s	.touch
		bsr.w	Animate_Tails
		tst.b	(Reverse_gravity_flag).w
		beq.s	.plc
		eori.b	#setBit(render_flags.y_flip),render_flags(a0)

.plc
		bsr.w	Tails_Load_PLC

.touch
		moveq	#signextendB($A0),d0
		and.b	object_control(a0),d0
		bne.s	.return
		jmp	TouchResponse(pc)
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Secondary states under state Tails_Control
; ---------------------------------------------------------------------------

Tails_Modes: offsetTable
		offsetTableEntry.w Tails_MdNormal					; 0
		offsetTableEntry.w Tails_MdAir						; 2
		offsetTableEntry.w Tails_MdRoll						; 4
		offsetTableEntry.w Tails_MdJump						; 6
; ---------------------------------------------------------------------------

Tails_Display:
		move.b	invulnerability_timer(a0),d0
		beq.s	.draw
		subq.b	#1,invulnerability_timer(a0)
		lsr.b	#3,d0								; division by 8
		bhs.s	Tails_ChkInvin

.draw
		jsr	(Draw_Sprite).w

Tails_ChkInvin:										; checks if invincibility has expired and disables it if it has.
		btst	#status_secondary.invincible,status_secondary(a0)
		beq.s	Tails_ChkShoes
		tst.b	invincibility_timer(a0)
		beq.s	Tails_ChkShoes							; if there wasn't any time left, that means we're in Super/Hyper mode
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	Tails_ChkShoes
		subq.b	#1,invincibility_timer(a0)					; reduce invincibility_timer only on every 8th frame
		bne.s	Tails_ChkShoes							; if time is still left, branch
		tst.b	(Music_results_flag).w						; don't change music if level is end
		bne.s	Tails_RmvInvin
		tst.b	(Boss_flag).w							; don't change music if in a boss fight
		bne.s	Tails_RmvInvin
		cmpi.b	#12,air_left(a0)						; don't change music if drowning
		blo.s	Tails_RmvInvin
		move.w	(Current_music).w,d0
		jsr	(Play_Music).w							; stop playing invincibility theme and resume normal level music

Tails_RmvInvin:
		bclr	#status_secondary.invincible,status_secondary(a0)

Tails_ChkShoes:										; checks if Speed Shoes have expired and disables them if they have
		btst	#status_secondary.speed_shoes,status_secondary(a0)		; does Sonic have speed shoes?
		beq.s	Tails_ExitChk							; if so, branch
		tst.b	speed_shoes_timer(a0)
		beq.s	Tails_ExitChk
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	Tails_ExitChk
		subq.b	#1,speed_shoes_timer(a0)					; reduce speed_shoes_timer only on every 8th frame
		bne.s	Tails_ExitChk
		move.w	#$600,Max_speed_P2-Max_speed_P2(a4)				; set Max_speed
		move.w	#$C,Acceleration_P2-Max_speed_P2(a4)				; set Acceleration
		move.w	#$80,Deceleration_P2-Max_speed_P2(a4)				; set Deceleration
		tst.b	(Super_Tails_flag).w
		beq.s	.nots
		move.w	#$800,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$18,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$C0,Deceleration_P2-Max_speed_P2(a4)

.nots
		bclr	#status_secondary.speed_shoes,status_secondary(a0)
		music	mus_Slowdown,1							; slow down tempo
; ---------------------------------------------------------------------------

Tails_ExitChk:
		rts

; =============== S U B R O U T I N E =======================================

Tails_CPU_Control:
		moveq	#btnDir+btnABC,d0
		and.b	(Ctrl_2_logical).w,d0
		beq.s	.skip
		move.w	#10*60,(Tails_CPU_idle_timer).w					; set wait

.skip
		lea	(Player_1).w,a1							; a1=character
		move.w	(Tails_CPU_routine).w,d0
		move.w	off_139EC(pc,d0.w),d0
		jmp	off_139EC(pc,d0.w)
; ---------------------------------------------------------------------------

off_139EC: offsetTable
		offsetTableEntry.w loc_13A10						; 0
		offsetTableEntry.w Tails_Catch_Up_Flying				; 2
		offsetTableEntry.w Tails_FlySwim_Unknown				; 4
		offsetTableEntry.w loc_13D4A						; 6
		offsetTableEntry.w loc_13F40						; 8
		offsetTableEntry.w locret_13FBE						; A
		offsetTableEntry.w loc_13FC2						; C
		offsetTableEntry.w loc_13FFA						; E
		offsetTableEntry.w loc_1408A						; 10
		offsetTableEntry.w loc_140C6						; 12
		offsetTableEntry.w loc_140CE						; 14
		offsetTableEntry.w loc_14106						; 16
		offsetTableEntry.w loc_1414C						; 18
		offsetTableEntry.w loc_141F2						; 1A
		offsetTableEntry.w loc_1421C						; 1C
		offsetTableEntry.w loc_14254						; 1E
		offsetTableEntry.w loc_1425C						; 20
		offsetTableEntry.w loc_14286						; 22
; ---------------------------------------------------------------------------

loc_13A10:
		tst.b	(Tails_CPU_star_post_flag).w
		bne.s	loc_13AF4
		cmpi.w	#bytes_to_word(LevelID_LZ,3),(Current_zone_and_act).w		; is LZ4?
		beq.s	loc_13B12							; if yes, branch
		cmpi.w	#bytes_to_word(LevelID_SBZ,2),(Current_zone_and_act).w		; is FZ?
		beq.s	loc_13B12							; if yes, branch

loc_13AF4:
		clr.b	anim(a0)							; AniIDSonAni_Walk
		clr.l	x_vel(a0)
		clr.w	ground_vel(a0)
		clr.b	status(a0)

loc_13B12:
		clr.b	object_control(a0)

loc_13B18:
		move.w	#6,(Tails_CPU_routine).w
		clr.w	(Tails_CPU_flight_timer).w

locret_13B1E:
		rts
; ---------------------------------------------------------------------------

Tails_Catch_Up_Flying:
		moveq	#signextendB(btnABCS),d0
		and.b	(Ctrl_2_logical).w,d0
		bne.s	loc_13B50
		moveq	#$3F,d0
		and.w	(Level_frame_counter).w,d0
		bne.s	locret_13B1E
		tst.b	object_control(a1)
		bmi.s	locret_13B1E

		moveq	#signextendB( \
			setBit(status.player.prevent_tails_respawn) \
		),d0

		and.b	status(a1),d0
		bne.s	locret_13B1E

loc_13B50:
		move.w	#4,(Tails_CPU_routine).w
		move.w	x_pos(a1),d0
		move.w	d0,x_pos(a0)
		move.w	d0,(Tails_CPU_target_X).w
		move.w	y_pos(a1),d0
		move.w	d0,(Tails_CPU_target_Y).w
		subi.w	#$C0,d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_13B78
		addi.w	#$C0+$C0,d0

loc_13B78:
		move.w	d0,y_pos(a0)
		ori.w	#high_priority,art_tile(a0)
		move.w	#priority_2,priority(a0)
		move.w	#$600,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$C,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$80,Deceleration_P2-Max_speed_P2(a4)
		moveq	#0,d0
		move.l	d0,x_vel(a0)
		move.w	d0,ground_vel(a0)
		move.b	d0,flip_type(a0)
		move.b	d0,double_jump_flag(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		move.b	#30,air_left(a0)
		move.b	#$81,object_control(a0)
		move.b	d0,flips_remaining(a0)
		move.b	d0,flip_speed(a0)
		move.w	d0,move_lock(a0)
		move.b	d0,invulnerability_timer(a0)
		move.b	d0,invincibility_timer(a0)
		move.b	d0,speed_shoes_timer(a0)
		move.b	d0,status_tertiary(a0)
		move.b	d0,scroll_delay_counter(a0)
		move.w	d0,next_tilt(a0)
		move.b	d0,stick_to_convex(a0)
		move.b	d0,spin_dash_flag(a0)
		move.w	d0,spin_dash_counter(a0)
		move.b	d0,jumping(a0)
		move.b	d0,objoff_41(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		bra.w	Tails_Set_Flying_Animation
; ---------------------------------------------------------------------------

Tails_FlySwim_Unknown:
		tst.b	render_flags(a0)						; is the player visible on the screen?
		bmi.s	loc_13C3A							; if yes, branch
		addq.w	#1,(Tails_CPU_flight_timer).w
		cmpi.w	#5*60,(Tails_CPU_flight_timer).w
		blo.s	loc_13C50
		clr.w	(Tails_CPU_flight_timer).w
		move.w	#2,(Tails_CPU_routine).w
		move.b	#$81,object_control(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		clr.w	x_pos(a0)
		clr.w	y_pos(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		bra.w	Tails_Set_Flying_Animation
; ---------------------------------------------------------------------------

loc_13C3A:
		move.b	#(8*60)/2,double_jump_property(a0)
		ori.b	#setBit(status.player.in_air),status(a0)
		bsr.w	Tails_Set_Flying_Animation
		clr.w	(Tails_CPU_flight_timer).w

loc_13C50:
		lea	(Pos_table).w,a2
		moveq	#$10,d2
		add.b	d2,d2
		add.b	d2,d2
		addq.b	#4,d2
		move.w	(Pos_table_index).w,d3
		sub.b	d2,d3
		move.l	(a2,d3.w),(Tails_CPU_target_X).w
		move.w	x_pos(a0),d0
		sub.w	(Tails_CPU_target_X).w,d0
		beq.s	loc_13CBE
		mvabs.w	d0,d2
		lsr.w	#4,d2
		cmpi.w	#$C,d2
		blo.s	loc_13C88
		moveq	#$C,d2

loc_13C88:
		move.b	x_vel(a1),d1
		bpl.s	loc_13C90
		neg.b	d1

loc_13C90:
		add.b	d1,d2
		addq.w	#1,d2
		tst.w	d0
		bmi.s	loc_13CAA
		bset	#status.player.x_flip,status(a0)
		cmp.w	d0,d2
		blo.s	loc_13CA6
		move.w	d0,d2
		moveq	#0,d0

loc_13CA6:
		neg.w	d2
		bra.s	loc_13CBA
; ---------------------------------------------------------------------------

loc_13CAA:
		bclr	#status.player.x_flip,status(a0)
		neg.w	d0
		cmp.w	d0,d2
		blo.s	loc_13CBA
		move.b	d0,d2
		moveq	#0,d0

loc_13CBA:
		add.w	d2,x_pos(a0)

loc_13CBE:
		moveq	#1,d2
		move.w	y_pos(a0),d1
		sub.w	(Tails_CPU_target_Y).w,d1
		beq.s	loc_13CD2
		bmi.s	loc_13CCE
		neg.w	d2

loc_13CCE:
		add.w	d2,y_pos(a0)

loc_13CD2:
		lea	(Stat_table).w,a2
		moveq	#signextendB($80),d2
		and.b	2(a2,d3.w),d2							; p1 status
		bne.s	loc_13D42
		or.w	d0,d1
		bne.s	loc_13D42
		cmpi.b	#PlayerID_Death,(Player_1+routine).w				; has player just died?
		bhs.s	loc_13D42							; if yes, branch
		move.w	#6,(Tails_CPU_routine).w
		clr.b	object_control(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		clr.l	x_vel(a0)
		clr.w	ground_vel(a0)
		andi.b	#setBit(status.player.underwater),status(a0)
		ori.b	#setBit(status.player.in_air),status(a0)
		clr.w	move_lock(a0)
		andi.w	#drawing_mask,art_tile(a0)
		tst.b	art_tile(a1)
		bpl.s	loc_13D34
		ori.w	#high_priority,art_tile(a0)

loc_13D34:
		move.w	top_solid_bit(a1),top_solid_bit(a0)				; set top_solid_bit and lrb_solid_bit
		rts
; ---------------------------------------------------------------------------

loc_13D42:
		move.b	#$81,object_control(a0)
		rts
; ---------------------------------------------------------------------------

loc_13D4A:
		cmpi.b	#PlayerID_Death,(Player_1+routine).w
		blo.s	loc_13D78
		move.w	#4,(Tails_CPU_routine).w
		clr.b	spin_dash_flag(a0)
		clr.w	spin_dash_counter(a0)
		move.b	#$81,object_control(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		move.b	#$20,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_13D78:
		bsr.w	sub_13EFC
		tst.w	(Tails_CPU_idle_timer).w
		bne.w	loc_13EBE
		tst.b	object_control(a0)
		bmi.w	loc_13EBE
		tst.b	status_tertiary(a1)
		bmi.w	loc_13EBE
		tst.w	move_lock(a0)
		beq.s	loc_13DA6
		tst.w	ground_vel(a0)
		bne.s	loc_13DA6
		move.w	#8,(Tails_CPU_routine).w

loc_13DA6:
		lea	(Pos_table).w,a2
		moveq	#$10,d1
		add.b	d1,d1
		add.b	d1,d1
		addq.b	#4,d1
		move.w	(Pos_table_index).w,d0
		sub.b	d1,d0
		move.w	(a2,d0.w),d2							; p1 xpos
		btst	#status.player.on_object,status(a1)
		bne.s	loc_13DD0
		cmpi.w	#$400,ground_vel(a1)
		bge.s	loc_13DD0
		subi.w	#32,d2

loc_13DD0:
		move.w	2(a2,d0.w),d3							; p1 ypos
		lea	(Stat_table).w,a2
		move.w	(a2,d0.w),d1							; Ctrl_1_logical
		move.b	2(a2,d0.w),d4							; p1 status
		move.w	d1,d0
		btst	#status.player.pushing,status(a0)				; is Tails hitting a solid?
		beq.s	loc_13DF2							; if not, branch
		btst	#status.player.pushing,d4					; is Sonic hitting a solid?
		beq.w	loc_13E9C							; if not, branch

loc_13DF2:
		sub.w	x_pos(a0),d2
		beq.s	loc_13E50
		bpl.s	loc_13E26
		neg.w	d2
		cmpi.w	#48,d2
		blo.s	loc_13E0A
		andi.w	#bytes_to_word(btnUD+btnABCS,btnUD+btnABCS),d1
		ori.w	#bytes_to_word(btnL,btnL),d1

loc_13E0A:
		tst.w	ground_vel(a0)
		beq.s	loc_13E64
		btst	#status.player.x_flip,status(a0)
		beq.s	loc_13E64
		btst	#0,object_control(a0)
		bne.s	loc_13E64
		subq.w	#1,x_pos(a0)
		bra.s	loc_13E64
; ---------------------------------------------------------------------------

loc_13E26:
		cmpi.w	#48,d2
		blo.s	loc_13E34
		andi.w	#bytes_to_word(btnUD+btnABCS,btnUD+btnABCS),d1
		ori.w	#bytes_to_word(btnR,btnR),d1

loc_13E34:
		tst.w	ground_vel(a0)
		beq.s	loc_13E64
		btst	#status.player.x_flip,status(a0)
		bne.s	loc_13E64
		btst	#0,object_control(a0)
		bne.s	loc_13E64
		addq.w	#1,x_pos(a0)
		bra.s	loc_13E64
; ---------------------------------------------------------------------------

loc_13E50:
		bclr	#status.player.x_flip,status(a0)
		move.b	d4,d0
		andi.b	#1,d0
		beq.s	loc_13E64
		bset	#status.player.x_flip,status(a0)

loc_13E64:
		tst.b	(Tails_CPU_auto_jump_flag).w
		beq.s	loc_13E7C
		ori.w	#bytes_to_word(btnABC,0),d1
		btst	#status.player.in_air,status(a0)				; is the player in the air?
		bne.s	loc_13EB8							; if yes, branch
		clr.b	(Tails_CPU_auto_jump_flag).w

loc_13E7C:
		move.w	(Level_frame_counter).w,d0
		andi.w	#$FF,d0
		beq.s	loc_13E8C
		cmpi.w	#64,d2
		bhs.s	loc_13EB8

loc_13E8C:
		sub.w	y_pos(a0),d3
		beq.s	loc_13EB8
		bpl.s	loc_13EB8
		neg.w	d3
		cmpi.w	#32,d3
		blo.s	loc_13EB8

loc_13E9C:
		moveq	#$3F,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_13EB8
		cmpi.b	#AniIDSonAni_Duck,anim(a0)
		beq.s	loc_13EB8
		ori.w	#bytes_to_word(btnABC,btnABC),d1
		move.b	#1,(Tails_CPU_auto_jump_flag).w

loc_13EB8:
		move.w	d1,(Ctrl_2_logical).w
		rts
; ---------------------------------------------------------------------------

loc_13EBE:
		tst.w	(Tails_CPU_idle_timer).w
		beq.s	locret_13EC8
		subq.w	#1,(Tails_CPU_idle_timer).w

locret_13EC8:
		rts

; =============== S U B R O U T I N E =======================================

sub_13ECA:
		clr.w	(Tails_CPU_idle_timer).w
		clr.w	(Tails_CPU_flight_timer).w
		move.w	#2,(Tails_CPU_routine).w
		move.b	#$81,object_control(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		move.w	#$7F00,x_pos(a0)						; move offscreen
		clr.w	y_pos(a0)
		clr.b	double_jump_flag(a0)
		rts

; =============== S U B R O U T I N E =======================================

sub_13EFC:
		tst.b	render_flags(a0)						; is the player visible on the screen?
		bmi.s	loc_13F28							; if yes, branch
		btst	#status.player.on_object,status(a0)
		beq.s	loc_13F18
		moveq	#0,d0
		movea.w	interact(a0),a3
		move.w	(Tails_CPU_interact).w,d0
		cmp.w	(a3),d0
		bne.s	loc_13F24

loc_13F18:
		addq.w	#1,(Tails_CPU_flight_timer).w
		cmpi.w	#5*60,(Tails_CPU_flight_timer).w
		blo.s	loc_13F2E

loc_13F24:
		bra.s	sub_13ECA
; ---------------------------------------------------------------------------

loc_13F28:
		clr.w	(Tails_CPU_flight_timer).w

loc_13F2E:
		btst	#status.player.on_object,status(a0)
		beq.s	locret_13F3E
		movea.w	interact(a0),a3
		move.w	(a3),(Tails_CPU_interact).w

locret_13F3E:
		rts
; ---------------------------------------------------------------------------

loc_13F40:
		bsr.s	sub_13EFC
		tst.w	(Tails_CPU_idle_timer).w
		bne.s	locret_13F3E
		tst.w	move_lock(a0)
		bne.s	locret_13F3E
		tst.b	spin_dash_flag(a0)
		bne.s	loc_13F94
		tst.w	ground_vel(a0)
		bne.s	locret_13F3E
		bclr	#status.player.x_flip,status(a0)
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		blo.s	loc_13F74
		bset	#status.player.x_flip,status(a0)

loc_13F74:
		move.w	#bytes_to_word(btnDn,btnDn),(Ctrl_2_logical).w
		moveq	#$7F,d0
		and.b	(Level_frame_counter+1).w,d0
		beq.s	loc_13FA4
		cmpi.b	#AniIDSonAni_Duck,anim(a0)
		bne.s	locret_13FBE
		move.w	#bytes_to_word(btnDn+btnABC,btnDn+btnABC),(Ctrl_2_logical).w
		rts
; ---------------------------------------------------------------------------

loc_13F94:
		move.w	#bytes_to_word(btnDn,btnDn),(Ctrl_2_logical).w
		moveq	#$7F,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_13FB2

loc_13FA4:
		clr.w	(Ctrl_2_logical).w
		move.w	#6,(Tails_CPU_routine).w
		rts
; ---------------------------------------------------------------------------

loc_13FB2:
		andi.b	#$1F,d0
		bne.s	locret_13FBE
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w

locret_13FBE:
		rts
; ---------------------------------------------------------------------------

loc_13FC2:
		move.b	#1,double_jump_flag(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		move.l	#words_to_long($100,0),x_vel(a0)
		clr.w	ground_vel(a0)
		lea	(Player_1).w,a1							; a1=character
		bsr.w	sub_1459E
		move.b	#1,(Flying_carrying_Sonic_flag).w
		move.w	#$E,(Tails_CPU_routine).w

loc_13FFA:
		clr.w	(Tails_CPU_idle_timer).w
		clr.w	(Ctrl_2_logical).w
		moveq	#$1F,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_14016
		ori.w	#bytes_to_word(btnR,btnR),(Ctrl_2_logical).w

loc_14016:
		lea	(Flying_carrying_Sonic_flag).w,a2
		lea	(Player_1).w,a1							; a1=character
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		bne.s	loc_14082							; if yes, branch
		move.w	#6,(Tails_CPU_routine).w
		clr.b	object_control(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		clr.l	x_vel(a0)
		clr.w	ground_vel(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		clr.w	move_lock(a0)
		andi.w	#drawing_mask,art_tile(a0)
		tst.b	art_tile(a1)
		bpl.s	loc_14068
		ori.w	#high_priority,art_tile(a0)

loc_14068:
		move.w	top_solid_bit(a1),top_solid_bit(a0)				; set top_solid_bit and lrb_solid_bit
		cmpi.w	#PlayerModeID_Sonic,(Player_mode).w
		bne.s	loc_14082
		move.w	#$10,(Tails_CPU_routine).w

loc_14082:
		move.w	(Ctrl_1).w,d0
		bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_1408A:
		clr.w	(Tails_CPU_idle_timer).w
		move.b	#(8*60)/2,double_jump_property(a0)
		clr.w	(Ctrl_2_logical).w
		moveq	#$F,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_140AC
		ori.w	#bytes_to_word(btnR+btnABC,btnR+btnABC),(Ctrl_2_logical).w

loc_140AC:
		tst.b	render_flags(a0)						; is the player visible on the screen?
		bmi.s	locret_140C4							; if yes, branch

		; delete
		moveq	#0,d0
		move.l	d0,address(a0)
		move.w	d0,x_pos(a0)
		move.w	d0,y_pos(a0)
		move.w	#$A,(Tails_CPU_routine).w

locret_140C4:
		rts
; ---------------------------------------------------------------------------

loc_140C6:
		clr.w	(Ctrl_2_logical).w
		rts
; ---------------------------------------------------------------------------

loc_140CE:
		move.b	#1,double_jump_flag(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		clr.l	x_vel(a0)
		clr.w	ground_vel(a0)
		lea	(Player_1).w,a1							; a1=character
		bsr.w	sub_1459E
		move.b	#1,(Flying_carrying_Sonic_flag).w
		move.w	#$16,(Tails_CPU_routine).w

loc_14106:
		clr.w	(Tails_CPU_idle_timer).w
		move.b	#(8*60)/2,double_jump_property(a0)
		clr.w	(Ctrl_2_logical).w
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_14128
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w

loc_14128:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$90,d0
		cmp.w	y_pos(a0),d0
		blo.s	loc_1413C
		move.w	#$18,(Tails_CPU_routine).w

loc_1413C:
		lea	(Flying_carrying_Sonic_flag).w,a2
		lea	(Player_1).w,a1							; a1=character
		move.w	(Ctrl_1).w,d0
		bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_1414C:
		move.b	#(8*60)/2,double_jump_property(a0)
		tst.w	(Tails_CPU_idle_timer).w
		beq.s	loc_14164
		tst.b	(Flying_carrying_Sonic_flag).w
		bne.s	loc_141E2
		bra.w	loc_142E2
; ---------------------------------------------------------------------------

loc_14164:
		clr.w	(Ctrl_2_logical).w
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.w	loc_142E2
		clr.b	(_unkFAAC).w
		btst	#button_down,(Ctrl_1).w
		beq.s	loc_14198
		addq.b	#1,(Tails_CPU_auto_fly_timer).w
		cmpi.b	#192,(Tails_CPU_auto_fly_timer).w
		blo.s	loc_141D2
		clr.b	(Tails_CPU_auto_fly_timer).w
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w
		bra.s	loc_141D2
; ---------------------------------------------------------------------------

loc_14198:
		btst	#button_up,(Ctrl_1).w
		beq.s	loc_141BA
		addq.b	#1,(Tails_CPU_auto_fly_timer).w
		cmpi.b	#32,(Tails_CPU_auto_fly_timer).w
		blo.s	loc_141D2
		clr.b	(Tails_CPU_auto_fly_timer).w
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w
		bra.s	loc_141D2
; ---------------------------------------------------------------------------

loc_141BA:
		addq.b	#1,(Tails_CPU_auto_fly_timer).w
		cmpi.b	#88,(Tails_CPU_auto_fly_timer).w
		blo.s	loc_141D2
		clr.b	(Tails_CPU_auto_fly_timer).w
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w

loc_141D2:
		moveq	#btnLR,d0
		and.b	(Ctrl_1).w,d0
		or.b	(Ctrl_2_logical).w,d0
		move.b	d0,(Ctrl_2_logical).w

loc_141E2:
		lea	(Flying_carrying_Sonic_flag).w,a2
		lea	(Player_1).w,a1							; a1=character
		move.w	(Ctrl_1).w,d0
		bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_141F2:
		move.b	#1,double_jump_flag(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		clr.l	x_vel(a0)
		clr.w	ground_vel(a0)
		move.w	#$1C,(Tails_CPU_routine).w

loc_1421C:
		clr.w	(Tails_CPU_idle_timer).w
		move.b	#(8*60)/2,double_jump_property(a0)
		clr.w	(Ctrl_2_logical).w
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_1423E
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w

loc_1423E:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$90,d0
		cmp.w	y_pos(a0),d0
		blo.s	locret_14252
		move.w	#$1E,(Tails_CPU_routine).w

locret_14252:
		rts
; ---------------------------------------------------------------------------

loc_14254:
		move.b	#(8*60)/2,double_jump_property(a0)
		rts
; ---------------------------------------------------------------------------

loc_1425C:
		move.b	#1,double_jump_flag(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		move.l	#words_to_long($100,0),x_vel(a0)
		clr.w	ground_vel(a0)
		move.w	#$22,(Tails_CPU_routine).w

loc_14286:
		clr.w	(Tails_CPU_idle_timer).w
		clr.w	(Ctrl_2_logical).w
		moveq	#$1F,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	loc_142A2
		ori.w	#bytes_to_word(btnR,btnR),(Ctrl_2_logical).w

loc_142A2:
		btst	#status.player.in_air,status(a0)				; is the player in the air?
		bne.s	locret_142E0							; if yes, branch
		move.w	#6,(Tails_CPU_routine).w
		clr.b	object_control(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		clr.l	x_vel(a0)
		clr.w	ground_vel(a0)
		move.b	#setBit(status.player.in_air),status(a0)
		clr.w	move_lock(a0)
		andi.w	#drawing_mask,art_tile(a0)

locret_142E0:
		rts
; ---------------------------------------------------------------------------

loc_142E2:
		tst.b	(_unkFAAC).w
		bne.s	loc_14362
		lea	(Player_1).w,a1							; a1=character
		tst.b	render_flags(a1)						; is the player visible on the screen?
		bpl.s	loc_14330							; if not, branch
		tst.w	(Tails_CPU_idle_timer).w
		bne.w	loc_143AA
		cmpi.w	#$300,y_vel(a1)
		bge.s	loc_14330
		clr.w	x_vel(a0)
		clr.w	(Ctrl_2_logical).w
		cmpi.w	#$200,y_vel(a0)
		bge.s	loc_14328
		addq.b	#1,(Tails_CPU_auto_fly_timer).w
		cmpi.b	#88,(Tails_CPU_auto_fly_timer).w
		blo.s	loc_1432E
		clr.b	(Tails_CPU_auto_fly_timer).w

loc_14328:
		ori.w	#bytes_to_word(btnABC,btnABC),(Ctrl_2_logical).w

loc_1432E:
		bra.s	loc_143AA
; ---------------------------------------------------------------------------

loc_14330:
		st	(_unkFAAC).w
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		bpl.s	loc_14340
		neg.w	d1

loc_14340:
		lsr.w	#2,d1
		move.w	d1,d2
		lsr.w	d2
		add.w	d2,d1
		move.w	d1,(Camera_stored_min_X_pos).w
		move.w	x_pos(a1),d1
		sub.w	x_pos(a0),d1
		bpl.s	loc_14358
		neg.w	d1

loc_14358:
		lsr.w	#2,d1
		move.w	d1,(Camera_stored_max_X_pos).w
		bra.s	loc_143AA
; ---------------------------------------------------------------------------

loc_14362:
		clr.w	(Ctrl_2_logical).w
		lea	(Player_1).w,a1							; a1=character
		move.w	x_pos(a0),d0
		moveq	#-16,d1
		add.w	y_pos(a0),d1
		move.w	(Camera_stored_max_X_pos).w,d2
		bclr	#status.player.x_flip,status(a0)
		cmp.w	x_pos(a1),d0
		blo.s	loc_14390
		bset	#status.player.x_flip,status(a0)
		neg.w	d2

loc_14390:
		add.w	d2,x_vel(a0)
		cmp.w	y_pos(a1),d1
		bhs.s	loc_143AA
		move.w	(Camera_stored_min_X_pos).w,d2
		cmp.w	y_pos(a1),d1
		blo.s	loc_143A6
		neg.w	d2

loc_143A6:
		add.w	d2,y_vel(a0)

loc_143AA:
		lea	(Flying_carrying_Sonic_flag).w,a2
		lea	(Player_1).w,a1							; a1=character
		move.w	(Ctrl_1).w,d0

; =============== S U B R O U T I N E =======================================

Tails_Carry_Sonic:
		tst.b	(a2)
		beq.w	loc_14534
		cmpi.b	#PlayerID_Hurt,routine(a1)
		bhs.w	loc_14466
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		beq.w	loc_1445A							; if not, branch
		move.w	(_unkF744).w,d1
		cmp.w	x_vel(a1),d1
		bne.s	loc_1445A
		move.w	(_unkF74C).w,d1
		cmp.w	y_vel(a1),d1
		bne.s	loc_14460
		tst.b	object_control(a1)
		bmi.w	loc_1446A
		andi.b	#btnABC,d0							; are buttons A, B or C being pressed?
		beq.w	loc_14474							; if not, branch
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		clr.b	(a2)
		move.b	#18,1(a2)
		andi.w	#bytes_to_word(btnDir,0),d0					; are buttons up, down, left or right being pressed?
		beq.s	loc_14410							; if not, branch
		move.b	#60,1(a2)

loc_14410:
		btst	#button_left+setBit(3),d0					; is left being held?
		beq.s	loc_1441C							; if not, branch
		move.w	#-$200,x_vel(a1)

loc_1441C:
		btst	#button_right+setBit(3),d0					; is right being held?
		beq.s	loc_14428							; if not, branch
		move.w	#$200,x_vel(a1)

loc_14428:
		move.w	#-$380,y_vel(a1)
		bset	#status.player.in_air,status(a1)
		move.b	#1,jumping(a1)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a1)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a1)
		bset	#status.player.rolling,status(a1)
		rts
; ---------------------------------------------------------------------------

loc_1445A:
		move.w	#-$100,y_vel(a1)

loc_14460:
		clr.b	jumping(a1)

loc_14466:
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)

loc_1446A:
		clr.b	(a2)
		move.b	#60,1(a2)
		rts
; ---------------------------------------------------------------------------

loc_14474:
		move.w	x_pos(a0),x_pos(a1)
		moveq	#28,d0
		add.w	y_pos(a0),d0
		move.w	d0,y_pos(a1)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_14492
		subi.w	#28+28,y_pos(a1)

loc_14492:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a1)

		andi.b	#~( \
			setBit(render_flags.x_flip) \
		),status(a1)

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d0

		and.b	status(a0),d0
		or.b	d0,render_flags(a1)
		or.b	d0,status(a1)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_144BA
		eori.b	#setBit(render_flags.y_flip),render_flags(a1)

loc_144BA:
		subq.b	#1,anim_frame_timer(a1)
		bpl.s	loc_144F8
		move.b	#$B,anim_frame_timer(a1)
		moveq	#0,d1
		move.b	anim_frame(a1),d1
		addq.b	#1,anim_frame(a1)
		move.b	AniRaw_Tails_Carry(pc,d1.w),d0
		cmpi.b	#-1,d0
		bne.s	loc_144E4
		clr.b	anim_frame(a1)
		move.b	AniRaw_Tails_Carry(pc),d0

loc_144E4:
		move.b	d0,mapping_frame(a1)
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		pea	(a2)								; save a2
		bsr.w	Perform_Player_DPLC
		movea.l	(sp)+,a2							; restore a2

loc_144F8:
		movem.w	x_vel(a0),d0-d1							; load xy speed
		movem.w	d0-d1,(Player_1+x_vel).w					; save xy speed
		move.w	d0,(_unkF744).w							; save x speed
		move.w	d1,(_unkF74C).w							; save y speed
		movem.l	d0-a6,-(sp)
		lea	(Player_1).w,a0							; a0=character
		bsr.w	SonicKnux_DoLevelCollision
		movem.l	(sp)+,d0-a6
		rts
; ---------------------------------------------------------------------------

AniRaw_Tails_Carry:	dc.b $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91, $FF
	even
; ---------------------------------------------------------------------------

loc_14534:
		tst.b	1(a2)
		beq.s	loc_14542
		subq.b	#1,1(a2)
		bne.s	locret_1459C

loc_14542:
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		addi.w	#16,d0
		cmpi.w	#32,d0
		bhs.s	locret_1459C
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		subi.w	#32,d1
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_1456C
		addi.w	#32+32+16,d1

loc_1456C:
		cmpi.w	#16,d1
		bhs.s	locret_1459C
		tst.b	object_control(a1)
		bne.s	locret_1459C
		cmpi.b	#PlayerID_Hurt,routine(a1)
		bhs.s	locret_1459C
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	locret_1459C							; if yes, branch
		tst.b	spin_dash_flag(a1)
		bne.s	locret_1459C
		bsr.s	sub_1459E
		sfx	sfx_Grab
		move.b	#1,(a2)

locret_1459C:
		rts

; =============== S U B R O U T I N E =======================================

sub_1459E:
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		clr.w	angle(a1)
		move.w	x_pos(a0),x_pos(a1)
		moveq	#28,d0
		add.w	y_pos(a0),d0
		move.w	d0,y_pos(a1)

		; set anim
		move.w	#bytes_to_word(AniIDSonAni_Carry,AniIDSonAni_Walk),d0		; put Sonic in his falling animation
		cmpi.b	#PlayerID_Knuckles,character_id(a1)				; is character Knuckles?
		bne.s	.set								; if not, branch
		move.w	#bytes_to_word(AniIDKnuxAni_Carry,AniIDSonAni_Walk),d0		; put Knuckles in his falling animation

.set
		move.w	d0,anim(a1)
		clr.b	anim_frame_timer(a1)
		clr.b	anim_frame(a1)
		move.b	#3,object_control(a1)
		bset	#status.player.in_air,status(a1)
		clr.b	spin_dash_flag(a1)

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a1)

		andi.b	#~( \
			setBit(render_flags.x_flip) \
		),status(a1)

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d0

		and.b	status(a0),d0
		or.b	d0,render_flags(a1)
		or.b	d0,status(a1)
		move.w	x_vel(a0),(_unkF744).w
		move.w	x_vel(a0),x_vel(a1)
		move.w	y_vel(a0),(_unkF74C).w
		move.w	y_vel(a0),y_vel(a1)
		tst.b	(Reverse_gravity_flag).w
		beq.s	locret_14630
		subi.w	#56,y_pos(a1)
		eori.b	#setBit(render_flags.y_flip),render_flags(a1)

locret_14630:
		rts

; =============== S U B R O U T I N E =======================================

Tails_Water:
		tst.b	(Water_flag).w							; does level have water?
		bne.s	Tails_InWater							; if yes, branch

locret_14638:
		rts
; ---------------------------------------------------------------------------

Tails_InWater:
		move.w	(Water_level).w,d0
		cmp.w	y_pos(a0),d0
		bge.s	loc_146BA
		bset	#status.player.underwater,status(a0)
		bne.s	locret_14638
		addq.b	#1,(Water_entered_counter).w
		movea.w	a0,a1
		bsr.w	Player_ResetAirTimer
		move.l	#Obj_AirCountdown,(Breathing_bubbles_P2+address).w
		move.w	a0,(Breathing_bubbles_P2+parent).w
		move.w	#$300,Max_speed_P2-Max_speed_P2(a4)
		move.w	#6,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$40,Deceleration_P2-Max_speed_P2(a4)

		; check
		tst.b	(Super_Tails_flag).w
		beq.s	loc_1468E
		move.w	#$400,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$C,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$60,Deceleration_P2-Max_speed_P2(a4)

loc_1468E:
		cmpi.w	#4,(Tails_CPU_routine).w
		beq.s	loc_1469C
		tst.b	object_control(a0)
		bne.s	locret_14638

loc_1469C:
		asr.w	x_vel(a0)
		asr.w	y_vel(a0)
		asr.w	y_vel(a0)
		beq.s	locret_14638
		move.w	#bytes_to_word(1,0),anim(a6)					; splash animation, write 1 to anim and clear prev_anim
		sfx	sfx_Splash,1							; splash sound
; ---------------------------------------------------------------------------

loc_146BA:
		bclr	#status.player.underwater,status(a0)
		beq.s	locret_14638
		addq.b	#1,(Water_entered_counter).w
		movea.w	a0,a1
		bsr.w	Player_ResetAirTimer
		move.w	#$600,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$C,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$80,Deceleration_P2-Max_speed_P2(a4)

		; check
		tst.b	(Super_Tails_flag).w
		beq.s	loc_146F4
		move.w	#$800,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$18,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$C0,Deceleration_P2-Max_speed_P2(a4)

loc_146F4:
		cmpi.b	#PlayerID_Hurt,routine(a0)
		beq.s	loc_14718
		cmpi.w	#4,(Tails_CPU_routine).w
		beq.s	loc_1470A
		tst.b	object_control(a0)
		bne.s	loc_14718

loc_1470A:
		move.w	y_vel(a0),d0
		cmpi.w	#-$400,d0
		blt.s	loc_14718
		asl.w	y_vel(a0)

loc_14718:
		cmpi.b	#AniIDSonAni_Blank,anim(a0)					; is Tails in his 'blank' animation
		beq.w	locret_14638							; if so, branch
		tst.w	y_vel(a0)
		beq.w	locret_14638
		move.w	#bytes_to_word(1,0),anim(a6)					; splash animation, write 1 to anim and clear prev_anim
		cmpi.w	#-$1000,y_vel(a0)
		bgt.s	loc_1473E
		move.w	#-$1000,y_vel(a0)

loc_1473E:
		sfx	sfx_Splash,1							; splash sound

; =============== S U B R O U T I N E =======================================

Tails_MdNormal:
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_14760
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w

loc_14760:
		bsr.w	Tails_Spindash
		bsr.w	Tails_Jump
		bsr.w	Player_SlopeResist
		bsr.w	Tails_InputAcceleration_Path
		bsr.w	Tails_Roll
		bsr.w	Player_LevelBound
		jsr	(MoveSprite2_TestGravity).w
		bsr.w	Call_Player_AnglePos
		bsr.w	Player_SlopeRepel

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_147B6
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_147A6
		sub.w	d1,x_pos(a0)

loc_147A6:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_147B2
		add.w	d1,x_pos(a0)

loc_147B2:
		movem.l	(sp)+,a4-a6

locret_147B6:
		rts

; ---------------------------------------------------------------------------
; Start of subroutine Tails_MdAir
; Called if Tails is airborne, but not in a ball (thus, probably not jumping)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Tails_Stand_Freespace:
Tails_MdAir:
		tst.b	double_jump_flag(a0)
		bne.s	Tails_FlyingSwimming

	if RollInAir
		bsr.w	Sonic_ChgFallAnim
	endif

		bsr.w	Tails_JumpHeight
		bsr.w	Tails_ChgJumpDir
		bsr.w	Player_LevelBound
		jsr	(MoveSprite_TestGravity).w
		btst	#status.player.underwater,status(a0)				; is Tails underwater?
		beq.s	loc_147DE							; if not, branch
		subi.w	#$28,y_vel(a0)							; reduce gravity by $28 ($38-$28=$10)

loc_147DE:
		cmpi.w	#$1000,y_vel(a0)
		ble.s	.maxy
		move.w	#$1000,y_vel(a0)

.maxy
		bsr.w	Player_JumpAngle
		bra.w	Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_FlyingSwimming:
		bsr.s	Tails_Move_FlySwim
		bsr.w	Tails_ChgJumpDir
		bsr.w	Player_LevelBound
		jsr	(MoveSprite2_TestGravity).w
		bsr.w	Player_JumpAngle
		movem.l	a4-a6,-(sp)
		bsr.w	Tails_DoLevelCollision
		movem.l	(sp)+,a4-a6
		cmpi.w	#PlayerModeID_KnucklesTails,(Player_mode).w
		beq.s	.load
		tst.w	(Player_mode).w
		bne.s	locret_14820

.load
		lea	(Flying_carrying_Sonic_flag).w,a2
		lea	(Player_1).w,a1							; a1=character
		move.w	(Ctrl_1).w,d0
		bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

locret_14820:
		rts

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
		moveq	#1,d0
		and.b	(Level_frame_counter+1).w,d0
		beq.s	loc_14836
		tst.b	double_jump_property(a0)
		beq.s	loc_14836
		subq.b	#1,double_jump_property(a0)

loc_14836:
		cmpi.b	#1,double_jump_flag(a0)
		beq.s	loc_14860
		cmpi.w	#-$100,y_vel(a0)
		blt.s	loc_14858
		subi.w	#$20,y_vel(a0)
		addq.b	#1,double_jump_flag(a0)
		cmpi.b	#$20,double_jump_flag(a0)
		bne.s	loc_1485E

loc_14858:
		move.b	#1,double_jump_flag(a0)

loc_1485E:
		bra.s	loc_14892
; ---------------------------------------------------------------------------

loc_14860:
		moveq	#btnABC,d0
		and.b	(Ctrl_2_pressed_logical).w,d0
		beq.s	loc_1488C
		cmpi.w	#-$100,y_vel(a0)
		blt.s	loc_1488C
		tst.b	double_jump_property(a0)
		beq.s	loc_1488C
		btst	#status.player.underwater,status(a0)
		beq.s	loc_14886
		tst.b	(Flying_carrying_Sonic_flag).w
		bne.s	loc_1488C

loc_14886:
		move.b	#2,double_jump_flag(a0)

loc_1488C:
		addq.w	#8,y_vel(a0)

loc_14892:
		moveq	#16,d0
		add.w	(Camera_min_Y_pos).w,d0
		cmp.w	y_pos(a0),d0
		blt.s	Tails_Set_Flying_Animation
		tst.w	y_vel(a0)
		bpl.s	Tails_Set_Flying_Animation
		clr.w	y_vel(a0)

; =============== S U B R O U T I N E =======================================

Tails_Set_Flying_Animation:
		btst	#status.player.underwater,status(a0)
		bne.s	loc_14914
		moveq	#$20,d0
		tst.w	y_vel(a0)
		bpl.s	loc_148C4
		moveq	#$21,d0

loc_148C4:
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_148CC
		addq.b	#2,d0

loc_148CC:
		tst.b	double_jump_property(a0)
		bne.s	loc_148F4
		moveq	#$24,d0
		move.b	d0,anim(a0)
		tst.b	render_flags(a0)						; is the player visible on the screen?
		bpl.s	locret_148F2							; if not, branch
		move.b	(Level_frame_counter+1).w,d0
		addq.b	#8,d0
		andi.b	#$F,d0
		bne.s	locret_148F2
		sfx	sfx_FlyTired,1
; ---------------------------------------------------------------------------

locret_148F2:
		rts
; ---------------------------------------------------------------------------

loc_148F4:
		move.b	d0,anim(a0)
		tst.b	render_flags(a0)						; is the player visible on the screen?
		bpl.s	locret_148F2							; if not, branch
		move.b	(Level_frame_counter+1).w,d0
		addq.b	#8,d0
		andi.b	#$F,d0
		bne.s	locret_148F2
		sfx	sfx_Flying,1
; ---------------------------------------------------------------------------

loc_14914:
		moveq	#$25,d0
		tst.w	y_vel(a0)
		bpl.s	loc_1491E
		moveq	#$26,d0

loc_1491E:
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_14926
		moveq	#$27,d0

loc_14926:
		tst.b	double_jump_property(a0)
		bne.s	loc_1492E
		moveq	#$28,d0

loc_1492E:
		move.b	d0,anim(a0)
		rts

; ---------------------------------------------------------------------------
; Start of subroutine Tails_MdRoll
; Called if Tails is in a ball, but not airborne (thus, probably rolling)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Tails_Spin_Path:
Tails_MdRoll:
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_1494C
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w

loc_1494C:
		tst.b	spin_dash_flag(a0)
		bne.s	loc_14956
		bsr.w	Tails_Jump

loc_14956:
		bsr.w	Player_RollRepel
		bsr.w	Tails_RollSpeed
		bsr.w	Player_LevelBound
		jsr	(MoveSprite2_TestGravity).w
		bsr.w	Call_Player_AnglePos
		bsr.w	Player_SlopeRepel

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_149A0
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_14990
		sub.w	d1,x_pos(a0)

loc_14990:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_1499C
		add.w	d1,x_pos(a0)

loc_1499C:
		movem.l	(sp)+,a4-a6

locret_149A0:
		rts

; ---------------------------------------------------------------------------
; Start of subroutine Tails_MdJump
; Called if Tails is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to Tails_MdAir, at least at this outer level.
; Why they gave it a separate copy of the code, I don't know.
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Tails_Spin_Freespace:
Tails_MdJump:
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_149BA
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w

loc_149BA:
		bsr.w	Tails_JumpHeight
		bsr.w	Tails_ChgJumpDir
		bsr.w	Player_LevelBound
		jsr	(MoveSprite_TestGravity).w
		btst	#status.player.underwater,status(a0)				; is Tails underwater?
		beq.s	loc_149DA							; if not, branch
		subi.w	#$28,y_vel(a0)							; reduce gravity by $28 ($38-$28=$10)

loc_149DA:
		cmpi.w	#$1000,y_vel(a0)
		ble.s	.maxy
		move.w	#$1000,y_vel(a0)

.maxy
		bsr.w	Player_JumpAngle
		bra.w	Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
		move.w	Max_speed_P2-Max_speed_P2(a4),d6
		move.w	Acceleration_P2-Max_speed_P2(a4),d5
		move.w	Deceleration_P2-Max_speed_P2(a4),d4
		tst.b	status_secondary(a0)
		bmi.w	loc_14B5C
		tst.w	move_lock(a0)
		bne.w	loc_14B14
		btst	#button_left,(Ctrl_2_logical).w
		beq.s	loc_14A0A
		bsr.w	sub_14C20

loc_14A0A:
		btst	#button_right,(Ctrl_2_logical).w
		beq.s	loc_14A16
		bsr.w	sub_14CAC

loc_14A16:
		move.w	(Camera_H_scroll_shift).w,d1
		beq.s	.skip
		bclr	#status.player.x_flip,status(a0)
		tst.w	d1
		bpl.s	.skip
		bset	#status.player.x_flip,status(a0)

.skip
		moveq	#$20,d0
		add.b	angle(a0),d0
		andi.b	#$C0,d0
		bne.w	loc_14B14
		tst.w	ground_vel(a0)
		bne.w	loc_14B14
		bclr	#status.player.pushing,status(a0)
		move.b	#AniIDSonAni_Wait,anim(a0)
		btst	#status.player.on_object,status(a0)
		beq.s	loc_14A6C
		movea.w	interact(a0),a1
		tst.b	status(a1)
		bmi.s	loc_14AA0
		moveq	#0,d1
		move.b	width_pixels(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	x_pos(a0),d1
		sub.w	x_pos(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_14A92
		cmp.w	d2,d1
		bge.s	loc_14A82
		bra.s	loc_14AA0
; ---------------------------------------------------------------------------

loc_14A6C:
		move.w	x_pos(a0),d3
		bsr.w	ChooseChkFloorEdge
		cmpi.w	#$C,d1
		blt.s	loc_14AA0
		cmpi.b	#3,next_tilt(a0)
		bne.s	loc_14A8A

loc_14A82:
		bclr	#status.player.x_flip,status(a0)
		bra.s	loc_14A98
; ---------------------------------------------------------------------------

loc_14A8A:
		cmpi.b	#3,tilt(a0)
		bne.s	loc_14AA0

loc_14A92:
		bset	#status.player.x_flip,status(a0)

loc_14A98:
		move.b	#AniIDSonAni_Balance,anim(a0)
		bra.s	loc_14B14
; ---------------------------------------------------------------------------

loc_14AA0:
		tst.w	(Camera_H_scroll_shift).w
		bne.s	loc_14ADA
		btst	#button_down,(Ctrl_2_logical).w
		beq.s	loc_14ADA
		move.b	#AniIDSonAni_Duck,anim(a0)
		addq.b	#1,scroll_delay_counter(a0)
		cmpi.b	#2*60,scroll_delay_counter(a0)
		blo.s	loc_14B1A
		move.b	#2*60,scroll_delay_counter(a0)
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_14AD0
		cmpi.w	#8,(a5)
		beq.s	loc_14B26
		subq.w	#2,(a5)
		bra.s	loc_14B26
; ---------------------------------------------------------------------------

loc_14AD0:
		cmpi.w	#$D8,(a5)
		beq.s	loc_14B26
		addq.w	#2,(a5)
		bra.s	loc_14B26
; ---------------------------------------------------------------------------

loc_14ADA:
		btst	#button_up,(Ctrl_2_logical).w
		beq.s	loc_14B14
		move.b	#AniIDSonAni_LookUp,anim(a0)
		addq.b	#1,scroll_delay_counter(a0)
		cmpi.b	#2*60,scroll_delay_counter(a0)
		blo.s	loc_14B1A
		move.b	#2*60,scroll_delay_counter(a0)
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_14B0A
		cmpi.w	#$C8,(a5)
		beq.s	loc_14B26
		addq.w	#2,(a5)
		bra.s	loc_14B26
; ---------------------------------------------------------------------------

loc_14B0A:
		cmpi.w	#$18,(a5)
		beq.s	loc_14B26
		subq.w	#2,(a5)
		bra.s	loc_14B26
; ---------------------------------------------------------------------------

loc_14B14:
		clr.b	scroll_delay_counter(a0)

loc_14B1A:
		cmpi.w	#$60,(a5)
		beq.s	loc_14B26
		bhs.s	loc_14B24
		addq.w	#4,(a5)

loc_14B24:
		subq.w	#2,(a5)

loc_14B26:
		tst.b	(Super_Tails_flag).w
		beq.s	loc_14B30
		moveq	#$C,d5

loc_14B30:
		moveq	#btnLR,d0
		and.b	(Ctrl_2_logical).w,d0
		bne.s	loc_14B5C
		move.w	ground_vel(a0),d0
		beq.s	loc_14B5C
		bmi.s	loc_14B50
		sub.w	d5,d0
		bhs.s	loc_14B4A
		moveq	#0,d0

loc_14B4A:
		move.w	d0,ground_vel(a0)
		bra.s	loc_14B5C
; ---------------------------------------------------------------------------

loc_14B50:
		add.w	d5,d0
		bhs.s	loc_14B58
		moveq	#0,d0

loc_14B58:
		move.w	d0,ground_vel(a0)

loc_14B5C:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	ground_vel(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	ground_vel(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

loc_14B7A:
		btst	#6,object_control(a0)
		bne.s	locret_14BF8
		moveq	#$3F,d0
		and.b	angle(a0),d0
		beq.s	loc_14B9A
		moveq	#$40,d0
		add.b	angle(a0),d0
		bmi.s	locret_14BF8

loc_14B9A:
		move.b	#$40,d1
		tst.w	ground_vel(a0)
		beq.s	locret_14BF8
		bmi.s	loc_14BA8
		neg.w	d1

loc_14BA8:
		move.b	angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		jsr	(CalcRoomInFront).w
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_14BF8
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_14C1A
		cmpi.b	#$40,d0
		beq.s	loc_14C00
		cmpi.b	#$80,d0
		beq.s	loc_14BFA
		add.w	d1,x_vel(a0)
		clr.w	ground_vel(a0)
		btst	#status.player.x_flip,status(a0)
		bne.s	locret_14BF8
		bset	#status.player.pushing,status(a0)

locret_14BF8:
		rts
; ---------------------------------------------------------------------------

loc_14BFA:
		sub.w	d1,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_14C00:
		sub.w	d1,x_vel(a0)
		clr.w	ground_vel(a0)
		btst	#status.player.x_flip,status(a0)
		beq.s	locret_14C1E
		bset	#status.player.pushing,status(a0)
		rts
; ---------------------------------------------------------------------------

loc_14C1A:
		add.w	d1,y_vel(a0)

locret_14C1E:
		rts

; =============== S U B R O U T I N E =======================================

sub_14C20:
		move.w	ground_vel(a0),d0
		beq.s	loc_14C28
		bpl.s	loc_14C5A

loc_14C28:
		tst.w	(Camera_H_scroll_shift).w
		bne.s	loc_14C3C
		bset	#status.player.x_flip,status(a0)
		bne.s	loc_14C3C
		bclr	#status.player.pushing,status(a0)
		move.b	#AniIDSonAni_Run,prev_anim(a0)

loc_14C3C:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_14C4E
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_14C4E
		move.w	d1,d0

loc_14C4E:
		move.w	d0,ground_vel(a0)
		clr.b	anim(a0)	; AniIDSonAni_Walk
		rts
; ---------------------------------------------------------------------------

loc_14C5A:
		sub.w	d4,d0
		bhs.s	loc_14C62
		moveq	#-$80,d0

loc_14C62:
		move.w	d0,ground_vel(a0)
		moveq	#$20,d1
		add.b	angle(a0),d1
		andi.b	#$C0,d1
		bne.s	locret_14CAA
		cmpi.w	#$400,d0
		blt.s	locret_14CAA
		tst.b	flip_type(a0)
		bmi.s	locret_14CAA
		sfx	sfx_Skid
		move.b	#AniIDSonAni_Stop,anim(a0)
		bclr	#status.player.x_flip,status(a0)
		cmpi.b	#12,air_left(a0)						; check air remaining
		blo.s	locret_14CAA							; if less than 12, branch
		move.l	#DashDust_CheckSkid,address(a6)					; Dust_P2
		move.b	#$15,mapping_frame(a6)						; Dust_P2

locret_14CAA:
		rts

; =============== S U B R O U T I N E =======================================

sub_14CAC:
		move.w	ground_vel(a0),d0
		bmi.s	loc_14CE0
		bclr	#status.player.x_flip,status(a0)
		beq.s	loc_14CC6
		bclr	#status.player.pushing,status(a0)
		move.b	#AniIDSonAni_Run,prev_anim(a0)

loc_14CC6:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_14CD4
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_14CD4
		move.w	d6,d0

loc_14CD4:
		move.w	d0,ground_vel(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		rts
; ---------------------------------------------------------------------------

loc_14CE0:
		add.w	d4,d0
		bhs.s	loc_14CE8
		move.w	#$80,d0

loc_14CE8:
		move.w	d0,ground_vel(a0)
		moveq	#$20,d1
		add.b	angle(a0),d1
		andi.b	#$C0,d1
		bne.s	locret_14D30
		cmpi.w	#-$400,d0
		bgt.s	locret_14D30
		tst.b	flip_type(a0)
		bmi.s	locret_14D30
		sfx	sfx_Skid
		move.b	#AniIDSonAni_Stop,anim(a0)
		bset	#status.player.x_flip,status(a0)
		cmpi.b	#12,air_left(a0)						; check air remaining
		blo.s	locret_14D30							; if less than 12, branch
		move.l	#DashDust_CheckSkid,address(a6)					; Dust_P2
		move.b	#$15,mapping_frame(a6)						; Dust_P2

locret_14D30:
		rts

; =============== S U B R O U T I N E =======================================

Tails_RollSpeed:
		move.w	Max_speed_P2-Max_speed_P2(a4),d6
		asl.w	d6
		move.w	Acceleration_P2-Max_speed_P2(a4),d5
		asr.w	d5
		tst.b	(Super_Tails_flag).w
		beq.s	loc_14D46
		moveq	#6,d5

loc_14D46:
		moveq	#$20,d4
		tst.b	spin_dash_flag(a0)
		bmi.w	loc_14DF0
		tst.b	status_secondary(a0)
		bmi.w	loc_14DF0
		tst.w	move_lock(a0)
		bne.s	loc_14D78
		tst.w	(Camera_H_scroll_shift).w
		bne.s	loc_14D78
		btst	#button_left,(Ctrl_2_logical).w
		beq.s	loc_14D6C
		bsr.w	sub_14E32

loc_14D6C:
		btst	#button_right,(Ctrl_2_logical).w
		beq.s	loc_14D78
		bsr.w	sub_14E56

loc_14D78:
		move.w	ground_vel(a0),d0
		beq.s	loc_14D9A
		bmi.s	loc_14D8E
		sub.w	d5,d0
		bhs.s	loc_14D88
		moveq	#0,d0

loc_14D88:
		move.w	d0,ground_vel(a0)
		bra.s	loc_14D9A
; ---------------------------------------------------------------------------

loc_14D8E:
		add.w	d5,d0
		bhs.s	loc_14D96
		moveq	#0,d0

loc_14D96:
		move.w	d0,ground_vel(a0)

loc_14D9A:
		mvabs.w	ground_vel(a0),d0
		cmpi.w	#$80,d0
		bhs.s	loc_14DF0
		tst.b	spin_dash_flag(a0)
		bne.s	loc_14DDE
		bclr	#status.player.rolling,status(a0)
		move.b	y_radius(a0),d0
		move.w	default_y_radius(a0),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Wait,anim(a0)

		; check
		tst.w	(Camera_H_scroll_shift).w
		beq.s	.skip
		move.b	#AniIDSonAni_Walk,anim(a0)

.skip
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_14DD8
		neg.w	d0

loc_14DD8:
		add.w	d0,y_pos(a0)
		bra.s	loc_14DF0
; ---------------------------------------------------------------------------

loc_14DDE:
		move.w	#$400,ground_vel(a0)
		btst	#status.player.x_flip,status(a0)
		beq.s	loc_14DF0
		neg.w	ground_vel(a0)

loc_14DF0:
		cmpi.w	#$60,(a5)
		beq.s	loc_14DFC
		bhs.s	loc_14DFA
		addq.w	#4,(a5)

loc_14DFA:
		subq.w	#2,(a5)

loc_14DFC:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	ground_vel(a0),d2						; devon fix
		cmpi.w	#$1000,d2
		ble.s	loc_14E20
		move.w	#$1000,d2

loc_14E20:
		cmpi.w	#-$1000,d2
		bge.s	loc_14E2A
		move.w	#-$1000,d2

loc_14E2A:
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		bra.w	loc_14B7A

; =============== S U B R O U T I N E =======================================

sub_14E32:
		move.w	ground_vel(a0),d0
		beq.s	loc_14E3A
		bpl.s	loc_14E48

loc_14E3A:
		bset	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Roll,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_14E48:
		sub.w	d4,d0
		bhs.s	loc_14E50
		moveq	#-$80,d0

loc_14E50:
		move.w	d0,ground_vel(a0)
		rts

; =============== S U B R O U T I N E =======================================

sub_14E56:
		move.w	ground_vel(a0),d0
		bmi.s	loc_14E6A
		bclr	#status.player.x_flip,status(a0)
		move.b	#AniIDSonAni_Roll,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_14E6A:
		add.w	d4,d0
		bhs.s	loc_14E72
		move.w	#$80,d0

loc_14E72:
		move.w	d0,ground_vel(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine for moving Tails left or right when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Tails_ChgJumpDir:
		move.w	Max_speed_P2-Max_speed_P2(a4),d6
		move.w	Acceleration_P2-Max_speed_P2(a4),d5
		asl.w	d5
		move.w	x_vel(a0),d0
		btst	#button_left,(Ctrl_2_logical).w
		beq.s	loc_14EAC							; if not holding left, branch
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
		bgt.s	loc_14EAC							; if new speed is less than the maximum, branch
		add.w	d5,d0								; remove this frame's acceleration change
		cmp.w	d1,d0								; compare speed with top speed
		ble.s	loc_14EAC							; if speed was already greater than the maximum, branch
		move.w	d1,d0

loc_14EAC:
		btst	#button_right,(Ctrl_2_logical).w
		beq.s	loc_14EC8							; if not holding right, branch
		bclr	#status.player.x_flip,status(a0)
		add.w	d5,d0								; accelerate right in the air
		cmp.w	d6,d0								; compare new speed with top speed
		blt.s	loc_14EC8							; if new speed is less than the maximum, branch
		sub.w	d5,d0								; remove this frame's acceleration change
		cmp.w	d6,d0								; compare speed with top speed
		bge.s	loc_14EC8							; if speed was already greater than the maximum, branch
		move.w	d6,d0

loc_14EC8:
		move.w	d0,x_vel(a0)

Tails_Jump_ResetScr:
		cmpi.w	#$60,(a5)							; is screen in its default position?
		beq.s	Tails_JumpPeakDecelerate					; if yes, branch
		bhs.s	loc_14ED6							; depending on the sign of the difference
		addq.w	#2+2,(a5)							; either add 2

loc_14ED6:
		subq.w	#2,(a5)								; or subtract 2

Tails_JumpPeakDecelerate:
		cmpi.w	#-$400,y_vel(a0)						; is Sonic moving faster than -$400 upwards?
		blo.s	locret_14F06							; if yes, return
		move.w	x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1								; d1 = x_velocity / 32
		beq.s	locret_14F06							; return if d1 is 0
		bmi.s	Tails_JumpPeakDecelerateLeft					; branch if moving left
		sub.w	d1,d0								; reduce x velocity by d1
		bhs.s	loc_14EF4
		moveq	#0,d0

loc_14EF4:
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

Tails_JumpPeakDecelerateLeft:
		sub.w	d1,d0								; reduce x velocity by d1
		blo.s	loc_14F02
		moveq	#0,d0

loc_14F02:
		move.w	d0,x_vel(a0)

locret_14F06:
		rts

; =============== S U B R O U T I N E =======================================

Tails_Roll:
		tst.b	status_secondary(a0)
		bmi.s	locret_14FA8

	if PlayerMoveLock
		tst.w	move_lock(a0)
		bne.s	locret_14FA8
	else
		cmpi.b	#AniIDSonAni_Slide,anim(a0)
		beq.s	locret_14FA8
	endif

		tst.w	(Camera_H_scroll_shift).w
		bne.s	locret_14FA8
		moveq	#btnLR,d0							; is left/right being pressed?
		and.b	(Ctrl_2_logical).w,d0
		bne.s	locret_14FA8
		btst	#button_down,(Ctrl_2_logical).w					; is down being pressed?
		beq.s	Tails_ChkWalk							; if not, branch
		mvabs.w	ground_vel(a0),d0
		cmpi.w	#$100,d0							; is Tails moving at $100 speed or faster?
		bhs.s	Tails_ChkRoll							; if so, branch

;		btst	#status.player.on_object,status(a0)				; is Tails stand on object?
;		bne.s	locret_14FA8							; if yes, branch

		move.b	#AniIDSonAni_Duck,anim(a0)					; enter ducking animation

locret_14FA8:
		rts
; ---------------------------------------------------------------------------

Tails_ChkWalk:
		cmpi.b	#AniIDSonAni_Duck,anim(a0)					; is Tails ducking?
		bne.s	locret_14FA8
		clr.b	anim(a0)							; if so, enter walking animation
		rts
; ---------------------------------------------------------------------------

Tails_ChkRoll:
		btst	#status.player.rolling,status(a0)				; is Tails already rolling?
		beq.s	Tails_DoRoll							; if not, branch
		rts
; ---------------------------------------------------------------------------

Tails_DoRoll:
		bset	#status.player.rolling,status(a0)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)					; enter roll animation
		addq.w	#1,y_pos(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_14FEA
		subq.w	#2,y_pos(a0)

loc_14FEA:
		sfx	sfx_Roll
		tst.w	ground_vel(a0)
		bne.s	locret_15000
		move.w	#$200,ground_vel(a0)

locret_15000:
		rts

; =============== S U B R O U T I N E =======================================

Tails_Jump:

	if PlayerMoveLock
		tst.w	move_lock(a0)
		bne.s	locret_15000
	endif

		moveq	#btnABC,d0
		and.b	(Ctrl_2_pressed_logical).w,d0
		beq.s	locret_15000
		moveq	#0,d0
		move.b	angle(a0),d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_15024
		addi.b	#$40,d0
		neg.b	d0
		subi.b	#$40,d0

loc_15024:
		addi.b	#$80,d0
		movem.l	a4-a6,-(sp)
		bsr.w	CalcRoomOverHead
		movem.l	(sp)+,a4-a6
		cmpi.w	#6,d1
		blt.s	locret_15000
		move.w	#$680,d2
		btst	#status.player.underwater,status(a0)				; test if underwater
		beq.s	loc_1504C
		move.w	#$380,d2

loc_1504C:
		moveq	#-$40,d0
		add.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,y_vel(a0)
		bset	#status.player.in_air,status(a0)
		bclr	#status.player.pushing,status(a0)
		addq.w	#4,sp
		move.b	#1,jumping(a0)
		clr.b	stick_to_convex(a0)
		sfx	sfx_Jump
		move.w	default_y_radius(a0),y_radius(a0)
		btst	#status.player.rolling,status(a0)
		bne.s	locret_150D0
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)					; use "jumping" animation
		bset	#status.player.rolling,status(a0)
		move.b	y_radius(a0),d0
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_150CC
		neg.w	d0

loc_150CC:
		sub.w	d0,y_pos(a0)

locret_150D0:
		rts

; =============== S U B R O U T I N E =======================================

Tails_JumpHeight:
		tst.b	jumping(a0)
		beq.s	loc_15106
		move.w	#-$400,d1
		btst	#status.player.underwater,status(a0)
		beq.s	loc_150F0
		move.w	#-$200,d1

loc_150F0:
		cmp.w	y_vel(a0),d1
		ble.s	Tails_Test_For_Flight
		moveq	#btnABC,d0
		and.b	(Ctrl_2_logical).w,d0
		bne.s	locret_15104
		move.w	d1,y_vel(a0)

locret_15104:
		rts
; ---------------------------------------------------------------------------

loc_15106:
		tst.b	spin_dash_flag(a0)
		bne.s	locret_1511A
		cmpi.w	#-$FC0,y_vel(a0)
		bge.s	locret_1511A
		move.w	#-$FC0,y_vel(a0)

locret_1511A:
		rts
; ---------------------------------------------------------------------------

Tails_Test_For_Flight:
		tst.b	double_jump_flag(a0)
		bne.s	locret_1511A
		moveq	#btnABC,d0
		and.b	(Ctrl_2_pressed_logical).w,d0
		beq.s	locret_1511A
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	loc_15156

		if SonKnuxTransform
		tst.b	(Super_Tails_flag).w
		bne.s	loc_1515C

	if CheckChaosEmer
		cmpi.b	#7,(Chaos_emerald_count).w
		blo.s	loc_1515C
	endif

		cmpi.w	#50,(Ring_count).w
		blo.s	loc_1515C
		tst.b	(Level_results_flag).w						; is level over?
		beq.s	Tails_Transform							; if not, branch
		endif

		bra.s	loc_1515C
; ---------------------------------------------------------------------------

loc_15156:
		tst.w	(Tails_CPU_idle_timer).w
		beq.s	locret_1511A

loc_1515C:
		btst	#status.player.rolling,status(a0)
		beq.s	loc_1518C
		bclr	#status.player.rolling,status(a0)
		move.b	y_radius(a0),d1
		move.w	default_y_radius(a0),y_radius(a0)
		sub.b	default_y_radius(a0),d1
		ext.w	d1
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_15188
		neg.w	d0

loc_15188:
		add.w	d1,y_pos(a0)

loc_1518C:
		move.b	#1,double_jump_flag(a0)
		move.b	#(8*60)/2,double_jump_property(a0)
		bra.w	Tails_Set_Flying_Animation

; =============== S U B R O U T I N E =======================================

Tails_Transform:
		move.b	#1,(Super_palette_status).w					; set Super/Hyper palette status to 'fading'
		move.b	#$F,(Palette_timer).w
		move.b	#1,(Super_Tails_flag).w						; set flag to Super Tails
		move.w	#60,(Super_frame_count).w
		move.b	#$81,object_control(a0)
		move.b	#AniIDTailsAni_Transform,anim(a0)				; enter 'transformation' animation
		move.l	#Obj_SuperTailsBirds,(Invincibility_stars).w			; load Super Flickies object
		move.w	#$800,Max_speed_P2-Max_speed_P2(a4)
		move.w	#$18,Acceleration_P2-Max_speed_P2(a4)
		move.w	#$C0,Deceleration_P2-Max_speed_P2(a4)
		clr.b	invincibility_timer(a0)
		bset	#status_secondary.invincible,status_secondary(a0)
		sfx	sfx_SuperTransform
		music	mus_Invincible,1						; play invincibility theme

; =============== S U B R O U T I N E =======================================

Tails_Spindash:
		tst.b	spin_dash_flag(a0)
		bne.s	loc_1527C
		cmpi.b	#AniIDSonAni_Duck,anim(a0)
		bne.s	locret_1527A
		moveq	#btnABC,d0
		and.b	(Ctrl_2_pressed_logical).w,d0
		beq.s	locret_1527A
		move.b	#AniIDSonAni_SpinDash,anim(a0)
		sfx	sfx_SpinDash
		addq.w	#4,sp
		move.b	#1,spin_dash_flag(a0)
		clr.w	spin_dash_counter(a0)
		cmpi.b	#12,air_left(a0)						; check air remaining
		blo.s	loc_15242							; if less than 12, branch
		move.b	#2,anim(a6)							; Dust_P2

loc_15242:
		bsr.w	Player_LevelBound
		bsr.w	Call_Player_AnglePos

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_1527A
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_1526A
		sub.w	d1,x_pos(a0)

loc_1526A:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_15276
		add.w	d1,x_pos(a0)

loc_15276:
		movem.l	(sp)+,a4-a6

locret_1527A:
		rts
; ---------------------------------------------------------------------------

loc_1527C:
		btst	#button_down,(Ctrl_2_logical).w
		bne.w	loc_15332
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a0)
		addq.w	#1,y_pos(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_152A8
		subq.w	#2,y_pos(a0)

loc_152A8:
		moveq	#0,d0
		move.b	d0,spin_dash_flag(a0)
		move.b	spin_dash_counter(a0),d0
		add.w	d0,d0
		move.w	word_1530E(pc,d0.w),ground_vel(a0)
		tst.b	(Super_Tails_flag).w
		beq.s	loc_152C8
		move.w	word_15320(pc,d0.w),ground_vel(a0)

loc_152C8:
		move.w	ground_vel(a0),d0
		subi.w	#$800,d0
		add.w	d0,d0
		andi.w	#$1F00,d0
		neg.w	d0
		addi.w	#$2000,d0
		lea	(H_scroll_frame_offset).w,a1
		cmpa.w	#Player_1,a0
		beq.s	loc_152EA
		lea	(H_scroll_frame_offset_P2).w,a1

loc_152EA:
		move.w	d0,(a1)
		btst	#status.player.x_flip,status(a0)
		beq.s	loc_152F8
		neg.w	ground_vel(a0)

loc_152F8:
		bset	#status.player.rolling,status(a0)
		clr.w	anim(a6)							; Dust_P2
		sfx	sfx_Dash
		bra.s	loc_1537A
; ---------------------------------------------------------------------------

word_1530E:
		dc.w $800
		dc.w $880
		dc.w $900
		dc.w $980
		dc.w $A00
		dc.w $A80
		dc.w $B00
		dc.w $B80
		dc.w $C00
word_15320:
		dc.w $A00
		dc.w $A80
		dc.w $B00
		dc.w $B80
		dc.w $C00
		dc.w $C80
		dc.w $D00
		dc.w $D80
		dc.w $E00
; ---------------------------------------------------------------------------

loc_15332:
		tst.w	spin_dash_counter(a0)
		beq.s	loc_1534A
		move.w	spin_dash_counter(a0),d0
		lsr.w	#5,d0
		sub.w	d0,spin_dash_counter(a0)
		bhs.s	loc_1534A
		clr.w	spin_dash_counter(a0)

loc_1534A:
		moveq	#btnABC,d0
		and.b	(Ctrl_2_pressed_logical).w,d0
		beq.s	loc_1537A
		move.w	#bytes_to_word(AniIDSonAni_SpinDash,AniIDSonAni_Walk),anim(a0)
		sfx	sfx_SpinDash
		addi.w	#$200,spin_dash_counter(a0)
		cmpi.w	#$800,spin_dash_counter(a0)
		blo.s	loc_1537A
		move.w	#$800,spin_dash_counter(a0)

loc_1537A:

	if ExtendedCamera
		moveq	#0,d0
		move.b	spin_dash_counter(a0),d0
		add.w	d0,d0
		move.w	word_1530E(pc,d0.w),ground_vel(a0)
		tst.b	(Super_Tails_flag).w
		beq.s	.nots
		move.w	word_15320(pc,d0.w),ground_vel(a0)

.nots
		btst	#status.player.x_flip,status(a0)
		beq.s	.notflipx
		neg.w	ground_vel(a0)

.notflipx
	endif

		addq.w	#4,sp
		cmpi.w	#$60,(a5)
		beq.s	loc_15388
		bhs.s	loc_15386
		addq.w	#4,(a5)

loc_15386:
		subq.w	#2,(a5)

loc_15388:
		bsr.w	Player_LevelBound
		bsr.w	Call_Player_AnglePos

		; check flag
		tst.b	(Background_collision_flag).w
		beq.s	locret_153C0
		jsr	(sub_F846).w
		tst.w	d1
		bmi.w	Kill_Character
		movem.l	a4-a6,-(sp)
		jsr	(CheckLeftWallDist).w
		tst.w	d1
		bpl.s	loc_153B0
		sub.w	d1,x_pos(a0)

loc_153B0:
		jsr	(CheckRightWallDist).w
		tst.w	d1
		bpl.s	loc_153BC
		add.w	d1,x_pos(a0)

loc_153BC:
		movem.l	(sp)+,a4-a6

locret_153C0:
		rts

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
		move.l	(Primary_collision_addr).w,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_153D6
		move.l	(Secondary_collision_addr).w,(Collision_addr).w

loc_153D6:
		move.b	lrb_solid_bit(a0),d5
		movem.w	x_vel(a0),d1-d2							; load xy speed
		jsr	(GetArcTan).w
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_154AC
		cmpi.b	#$80,d0
		beq.w	loc_15538
		cmpi.b	#$C0,d0
		beq.w	loc_1559C
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_1541A
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)

loc_1541A:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_1542C
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)

loc_1542C:
		bsr.w	sub_11FD6
		tst.w	d1
		bpl.s	locret_154AA
		move.b	y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_15444
		cmp.b	d2,d0
		blt.s	locret_154AA

loc_15444:
		move.b	d3,angle(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_15450
		neg.w	d1

loc_15450:
		add.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_15484
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.s	loc_15472
		asr.w	y_vel(a0)
		bra.s	loc_15498
; ---------------------------------------------------------------------------

loc_15472:
		clr.w	y_vel(a0)
		move.w	x_vel(a0),ground_vel(a0)
		bra.w	Tails_TouchFloor_Check_Spindash
; ---------------------------------------------------------------------------

loc_15484:
		clr.w	x_vel(a0)
		cmpi.w	#$FC0,y_vel(a0)
		ble.s	loc_15498
		move.w	#$FC0,y_vel(a0)

loc_15498:
		bsr.w	Tails_TouchFloor_Check_Spindash
		move.w	y_vel(a0),ground_vel(a0)
		tst.b	d3
		bpl.s	locret_154AA
		neg.w	ground_vel(a0)

locret_154AA:
		rts
; ---------------------------------------------------------------------------

loc_154AC:
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_154C4
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)
		move.w	y_vel(a0),ground_vel(a0)

loc_154C4:
		bsr.w	sub_11FEE
		tst.w	d1
		bpl.s	loc_15502
		neg.w	d1
		cmpi.w	#$14,d1
		bhs.s	loc_154EE
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_154DC
		neg.w	d1

loc_154DC:
		add.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_154EC
		clr.w	y_vel(a0)

locret_154EC:
		rts
; ---------------------------------------------------------------------------

loc_154EE:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	locret_15500
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)

locret_15500:
		rts
; ---------------------------------------------------------------------------

loc_15502:
		tst.b	(WindTunnel_flag_P2).w
		bne.s	loc_1550E
		tst.w	y_vel(a0)
		bmi.s	locret_15500

loc_1550E:
		bsr.w	sub_11FD6
		tst.w	d1
		bpl.s	locret_15500
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_1551E
		neg.w	d1

loc_1551E:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		clr.w	y_vel(a0)
		move.w	x_vel(a0),ground_vel(a0)
		bra.w	Tails_TouchFloor_Check_Spindash
; ---------------------------------------------------------------------------

loc_15538:
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_1554A
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)

loc_1554A:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_1555C
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)

loc_1555C:
		bsr.w	sub_11FEE
		tst.w	d1
		bpl.s	locret_1559A
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_1556C
		neg.w	d1

loc_1556C:
		sub.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_15584
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_15584:
		move.b	d3,angle(a0)
		bsr.s	Tails_TouchFloor_Check_Spindash
		move.w	y_vel(a0),ground_vel(a0)
		tst.b	d3
		bpl.s	locret_1559A
		neg.w	ground_vel(a0)

locret_1559A:
		rts
; ---------------------------------------------------------------------------

loc_1559C:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_155B4
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)
		move.w	y_vel(a0),ground_vel(a0)

loc_155B4:
		bsr.w	sub_11FEE
		tst.w	d1
		bpl.s	loc_155D6
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_155C4
		neg.w	d1

loc_155C4:
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_155D4
		clr.w	y_vel(a0)

locret_155D4:
		rts
; ---------------------------------------------------------------------------

loc_155D6:
		tst.b	(WindTunnel_flag_P2).w
		bne.s	loc_155E2
		tst.w	y_vel(a0)
		bmi.s	locret_155D4

loc_155E2:
		bsr.w	sub_11FD6
		tst.w	d1
		bpl.s	locret_155D4
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_155F2
		neg.w	d1

loc_155F2:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		clr.w	y_vel(a0)
		move.w	x_vel(a0),ground_vel(a0)

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
		tst.b	spin_dash_flag(a0)
		bne.s	loc_1565E
		clr.b	anim(a0)							; AniIDSonAni_Walk

Tails_TouchFloor:
		move.b	y_radius(a0),d0
		move.w	default_y_radius(a0),y_radius(a0)				; set y_radius and x_radius
		btst	#status.player.rolling,status(a0)
		beq.s	loc_1565E
		bclr	#status.player.rolling,status(a0)
		clr.b	anim(a0)							; AniIDSonAni_Walk
		sub.b	default_y_radius(a0),d0
		ext.w	d0
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_1564A
		neg.w	d0

loc_1564A:
		move.w	d0,-(sp)
		moveq	#$40,d0
		add.b	angle(a0),d0
		bpl.s	loc_15658
		neg.w	(sp)

loc_15658:
		move.w	(sp)+,d0
		add.w	d0,y_pos(a0)

loc_1565E:
		bclr	#status.player.in_air,status(a0)
		bclr	#status.player.pushing,status(a0)
		moveq	#0,d0
		move.b	d0,jumping(a0)

		; without this check, AI Tails will ruin the player's
		; combo when he touches the floor
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	.notp1
		move.w	d0,(Chain_bonus_counter).w

.notp1
		move.b	d0,flip_angle(a0)
		move.b	d0,flip_type(a0)
		move.b	d0,flips_remaining(a0)
		move.b	d0,scroll_delay_counter(a0)
		move.b	d0,double_jump_flag(a0)
		rts

; =============== S U B R O U T I N E =======================================

Tails_Hurt:

	if GameDebug
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	.nodebug
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

		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_156D6
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w

loc_156D6:
		jsr	(MoveSprite2_TestGravity).w
		addi.w	#$30,y_vel(a0)
		btst	#status.player.underwater,status(a0)
		beq.s	loc_156F0
		subi.w	#$20,y_vel(a0)

loc_156F0:
		cmpi.w	#-$100,(Camera_min_Y_pos).w
		bne.s	loc_15700
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)

loc_15700:
		bsr.s	sub_15716
		bsr.w	Player_LevelBound
		bsr.w	Sonic_RecordPos
		bsr.w	Tails_Water
		bsr.w	sub_15842
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_15716:
		tst.b	(Disable_death_plane).w
		bne.s	loc_15742
		tst.b	(Reverse_gravity_flag).w
		bne.s	loc_15734
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		blt.s	loc_15788
		bra.s	loc_15742
; ---------------------------------------------------------------------------

loc_15734:
		move.w	(Camera_min_Y_pos).w,d0
		cmp.w	y_pos(a0),d0
		blt.s	loc_15742
		bra.s	loc_15788
; ---------------------------------------------------------------------------

loc_15742:
		movem.l	a4-a6,-(sp)
		bsr.w	Tails_DoLevelCollision
		movem.l	(sp)+,a4-a6
		btst	#status.player.in_air,status(a0)				; is the player in the air?
		bne.s	locret_15786							; if yes, branch
		moveq	#0,d0
		move.l	d0,x_vel(a0)
		move.w	d0,ground_vel(a0)
		move.b	d0,object_control(a0)
		move.b	d0,anim(a0)							; AniIDSonAni_Walk
		move.b	d0,spin_dash_flag(a0)
		move.w	#priority_2,priority(a0)
		move.b	#PlayerID_Control,routine(a0)
		move.b	#2*60,invulnerability_timer(a0)

locret_15786:
		rts
; ---------------------------------------------------------------------------

loc_15788:
		movea.w	a0,a2
		jmp	Kill_Character(pc)
; ---------------------------------------------------------------------------

Tails_Death:

	if GameDebug
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	.nodebug
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

		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_157C8
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w

loc_157C8:
		bsr.w	sub_123C2
		jsr	(MoveSprite_TestGravity).w
		bsr.w	Sonic_RecordPos
		bsr.w	sub_15842
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Tails_Restart:
		tst.w	restart_timer(a0)
		beq.s	locret_157F2
		subq.w	#1,restart_timer(a0)
		bne.s	locret_157F2
		st	(Restart_level_flag).w

locret_157F2:
		rts
; ---------------------------------------------------------------------------

loc_157F4:
		tst.w	(H_scroll_amount_P2).w
		bne.s	loc_15806
		tst.w	(V_scroll_amount_P2).w
		bne.s	loc_15806
		move.b	#PlayerID_Control,routine(a0)

loc_15806:
		bsr.s	sub_15842
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Tails_Drown:

	if GameDebug
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		bne.s	.nodebug
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

		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	loc_15828
		lea	(Player_1).w,a1							; a1=character
		clr.b	object_control(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		bset	#status.player.in_air,status(a1)
		clr.w	(Flying_carrying_Sonic_flag).w

loc_15828:
		jsr	(MoveSprite2_TestGravity).w
		addi.w	#$10,y_vel(a0)
		bsr.w	Sonic_RecordPos
		bsr.s	sub_15842
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_15842:
		bsr.s	Animate_Tails
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_15856
		eori.b	#setBit(render_flags.y_flip),render_flags(a0)

loc_15856:
		bra.w	Tails_Load_PLC

; =============== S U B R O U T I N E =======================================

Animate_Tails:
		lea	(AniTails).l,a1

Animate_Tails_Part2:
		moveq	#0,d0
		move.b	anim(a0),d0
		cmp.b	prev_anim(a0),d0
		beq.s	loc_1588A
		move.b	d0,prev_anim(a0)
		clr.b	anim_frame(a0)
		clr.b	anim_frame_timer(a0)
		bclr	#status.player.pushing,status(a0)

loc_1588A:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	loc_158FA

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
		bpl.s	locret_158C8
		move.b	d0,anim_frame_timer(a0)

; =============== S U B R O U T I N E =======================================

sub_158B0:
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#-4,d0
		bhs.s	loc_158CA

loc_158C0:
		move.b	d0,mapping_frame(a0)
		addq.b	#1,anim_frame(a0)

locret_158C8:
		rts
; ---------------------------------------------------------------------------

loc_158CA:
		addq.b	#1,d0
		bne.s	loc_158DA
		clr.b	anim_frame(a0)
		move.b	1(a1),d0
		bra.s	loc_158C0
; ---------------------------------------------------------------------------

loc_158DA:
		addq.b	#1,d0
		bne.s	loc_158EE
		move.b	2(a1,d1.w),d0
		sub.b	d0,anim_frame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_158C0
; ---------------------------------------------------------------------------

loc_158EE:
		addq.b	#1,d0
		bne.s	locret_158F8
		move.b	2(a1,d1.w),anim(a0)

locret_158F8:
		rts
; ---------------------------------------------------------------------------

loc_158FA:
		addq.b	#1,d0
		bne.w	loc_159C8
		moveq	#0,d0
		tst.b	flip_type(a0)
		bmi.w	loc_127C0
		move.b	flip_angle(a0),d0
		bne.w	loc_127C0
		moveq	#0,d1
		move.b	angle(a0),d0
		bmi.s	loc_1591E
		beq.s	loc_1591E
		subq.b	#1,d0

loc_1591E:

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_1592A
		not.b	d0

loc_1592A:
		addi.b	#$10,d0
		bpl.s	loc_15932
		moveq	#3,d1

loc_15932:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		btst	#status.player.pushing,status(a0)
		bne.w	loc_15A14
		lsr.b	#4,d0
		andi.b	#6,d0
		mvabs.w	ground_vel(a0),d2
		add.w	(Camera_H_scroll_shift).w,d2
		tst.b	status_secondary(a0)
		bpl.s	loc_15960
		add.w	d2,d2

loc_15960:
		move.b	d0,d3
		add.b	d3,d3
		add.b	d3,d3

		; check
		lea	(TailsAni_Walk).l,a1						; use walking animation
		cmpi.w	#$600,d2
		blo.s	loc_1598A

.trani		:= TailsAni_Run-TailsAni_Walk						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.trani)(a1),a1							; use running animation
		move.b	d0,d3
		add.b	d3,d3
		cmpi.w	#$700,d2
		blo.s	loc_1598A

.tr2ani		:= TailsAni_Run2-TailsAni_Run						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.tr2ani)(a1),a1						; use running 2 animation
		move.b	d0,d3

loc_1598A:
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#-1,d0
		bne.s	loc_159A4
		clr.b	anim_frame(a0)
		move.b	1(a1),d0

loc_159A4:
		move.b	d0,mapping_frame(a0)
		add.b	d3,mapping_frame(a0)
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	locret_159C6
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_159BC
		moveq	#0,d2

loc_159BC:
		move.w	d2,-(sp)
		move.b	(sp)+,d2
		move.b	d2,anim_frame_timer(a0)
		addq.b	#1,anim_frame(a0)

locret_159C6:
		rts
; ---------------------------------------------------------------------------

loc_159C8:
		addq.b	#1,d0
		bne.s	loc_15A3C

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
		bpl.w	locret_158C8
		mvabs.w	ground_vel(a0),d2
		add.w	(Camera_H_scroll_shift).w,d2

		; check
		lea	(TailsAni_Roll2).l,a1						; use roll 2 animation
		cmpi.w	#$600,d2
		bhs.s	loc_15A00

.trani		:= TailsAni_Roll-TailsAni_Roll2						; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.trani)(a1),a1							; use roll animation

loc_15A00:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_15A0A
		moveq	#0,d2

loc_15A0A:
		move.w	d2,-(sp)
		move.b	(sp)+,d2
		move.b	d2,anim_frame_timer(a0)
		bra.w	sub_158B0
; ---------------------------------------------------------------------------

loc_15A14:
		subq.b	#1,anim_frame_timer(a0)
		bpl.w	locret_158C8
		move.w	ground_vel(a0),d2
		bmi.s	loc_15A24
		neg.w	d2

loc_15A24:
		addi.w	#$800,d2
		bpl.s	loc_15A2C
		moveq	#0,d2

loc_15A2C:
		lsr.w	#6,d2
		move.b	d2,anim_frame_timer(a0)
		lea	(TailsAni_Push).l,a1						; use push animation
		bra.w	sub_158B0
; ---------------------------------------------------------------------------

loc_15A3C:
		subq.b	#1,anim_frame_timer(a0)
		bpl.w	locret_158C8
		movem.w	x_vel(a2),d1-d2							; load xy speed
		jsr	(GetArcTan).w
		moveq	#0,d1

		moveq	#signextendB( \
			setBit(status.player.x_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	loc_15A6E
		not.b	d0
		bra.s	loc_15A72
; ---------------------------------------------------------------------------

loc_15A6E:
		addi.b	#$80,d0

loc_15A72:
		addi.b	#$10,d0
		bpl.s	loc_15A7A
		moveq	#3,d1

loc_15A7A:

		andi.b	#~( \
			setBit(render_flags.x_flip) | \
			setBit(render_flags.y_flip) \
		),render_flags(a0)

		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_15A92
		eori.b	#setBit(render_flags.y_flip),render_flags(a0)

loc_15A92:
		lsr.b	#3,d0
		andi.b	#$C,d0
		move.b	d0,d3
		lea	(AniTails_Tail03).l,a1
		move.b	#3,anim_frame_timer(a0)
		bsr.w	sub_158B0
		add.b	d3,mapping_frame(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

Tails_Tail_Load_PLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(Player_prev_frame_P2_tail).w,d0
		beq.s	loc_15A92.return
		move.b	d0,(Player_prev_frame_P2_tail).w
		add.w	d0,d0
		lea	(DPLC_Tails_Tail).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	loc_15A92.return

		; check
		move.w	#tiles_to_bytes(ArtTile_Player_2_Tail),d4			; normal
		cmpi.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; is game mode Special Stage?
		bne.s	.notspecial							; if not, branch
		move.w	#tiles_to_bytes($7AC),d4					; Special Stage

.notspecial
		move.l	#dmaSource(ArtUnc_Tails_Tail),d6
		bra.s	Tails_Load_PLC2.readentry

; =============== S U B R O U T I N E =======================================

Tails_Load_PLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0

Tails_Load_PLC2:
		cmp.b	(Player_prev_frame_P2).w,d0
		beq.s	.return
		move.b	d0,(Player_prev_frame_P2).w

		; load
		add.w	d0,d0
		lea	(DPLC_Tails).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.return

		; check
		move.w	#tiles_to_bytes(ArtTile_Player_2),d4				; normal
		cmpi.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; is game mode Special Stage?
		bne.s	.notspecial							; if not, branch
		move.w	#tiles_to_bytes($79C),d4					; Special Stage

.notspecial
		move.l	#dmaSource(ArtUnc_Tails),d6
		cmpi.w	#$D1*2,d0							; mapping frame * 2
		blo.s	.readentry
		move.l	#dmaSource(ArtUnc_Tails_Extra),d6

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
