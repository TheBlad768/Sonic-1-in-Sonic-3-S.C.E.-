; ---------------------------------------------------------------------------
; Water handle
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Handle_Onscreen_Water_Height:
		tst.b	(Water_flag).w								; does level have water?
		beq.s	.slide									; if not, branch
		tst.b	(Deform_lock).w
		bne.s	.skip
		cmpi.b	#PlayerID_Death,(Player_1+routine).w					; is player dead?
		bhs.s	.skip									; if yes, branch
		bsr.w	Water_WindTunnels
		bsr.s	DynamicWaterHeight

.skip
		moveq	#0,d0
		move.b	d0,(Water_full_screen_flag).w
		move.b	(Oscillating_Data).w,d0
		lsr.w	d0
		add.w	(Mean_water_level).w,d0
		move.w	d0,(Water_level).w

		; calculate distance between water surface and top of screen
		move.w	(Water_level).w,d0
		sub.w	(Camera_Y_pos).w,d0
		beq.s	.set
		bhs.s	.check
		bpl.s	.check

.set
		st	(Water_full_screen_flag).w
		st	(H_int_counter).w							; set 256-1
		rts
; ---------------------------------------------------------------------------

.check
		cmpi.w	#224-1,d0
		blo.s	.counter
		moveq	#-1,d0									; set 256-1

.counter
		move.b	d0,(H_int_counter).w

.slide
		bra.w	Water_WaterSlides

; ---------------------------------------------------------------------------
; Dynamic water level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DynamicWaterHeight:

		; check
		move.l	(Level_data_addr_RAM.WaterResize).w,d0
		beq.s	.wrskip									; if zero, branch
		movea.l	d0,a0
		jsr	(a0)

.wrskip
		moveq	#0,d1
		move.b	(Water_speed).w,d1
		move.w	(Target_water_level).w,d0
		sub.w	(Mean_water_level).w,d0
		beq.s	.return
		bhs.s	.skip
		neg.w	d1

.skip
		add.w	d1,(Mean_water_level).w

.return
		rts

; ---------------------------------------------------------------------------
; Water init
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CheckLevelForWater:
		cmpi.b	#LevelID_LZ,(Current_zone).w						; check if level is LZ
		beq.s	.getwater								; if so, branch

		; reset water
		move.w	#$1000,d0
		move.w	d0,(Water_level).w
		move.w	d0,(Mean_water_level).w
		move.w	d0,(Target_water_level).w
		clr.b	(Water_flag).w								; disable water
		rts
; ---------------------------------------------------------------------------

.getwater

		; set water
		move.w	(Level_data_addr_RAM.WaterHeight).w,d0					; load water height
		move.w	d0,(Water_level).w
		move.w	d0,(Mean_water_level).w
		move.w	d0,(Target_water_level).w
		st	(Water_flag).w								; enable water
		clr.b	(Water_entered_counter).w
		clr.b	(Water_full_screen_flag).w
		move.b	#1,(Water_speed).w

		; load player water palette
		lea	(Level_data_addr_RAM.WaterSPal).w,a1					; load Sonic's palette
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.notwaterKnux
		addq.w	#1,a1									; load Knuckles's palette

.notwaterKnux
		moveq	#0,d0
		move.b	(a1),d0									; player water palette
		move.w	d0,d1
		jsr	(LoadPalette2).w							; load player's water palette
		move.w	d1,d0
		jsr	(LoadPalette2_Immediate).w

LoadWaterPalette:
		tst.b	(Water_flag).w
		beq.s	.return

		; load level water palette
		lea	(Level_data_addr_RAM.WaterPalette).w,a1					; water palette
		moveq	#0,d0
		move.b	(a1),d0
		move.w	d0,d1
		jsr	(LoadPalette2).w							; load water palette
		move.w	d1,d0
		jsr	(LoadPalette2_Immediate).w

		; restore water full flag
		tst.b	(Last_star_post_hit).w
		beq.s	.return
		move.b	(Saved_water_full_screen_flag).w,(Water_full_screen_flag).w

.return
		rts

; =============== S U B R O U T I N E =======================================

Water_WindTunnels:
		cmpi.b	#LevelID_LZ,(Current_zone).w						; check if level is LZ
		bne.s	LoadWaterPalette.return							; if not, branch
		tst.w	(Debug_placement_mode).w						; is debug mode on?
		bne.s	LoadWaterPalette.return							; if yes, branch
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w					; is Tails?
		beq.s	.isTails								; if yes, branch

		; check p1
		lea	(Player_1).w,a1								; a1=character
		lea	(WindTunnel_flag).w,a3
		move.b	(Ctrl_1_logical).w,d6
		moveq	#WindTunnel_holding_flag.player_1,d5
		bsr.s	LZ_WaterTunnels

		; check p2
		addq.w	#1,a3
		lea	(Player_2).w,a1								; a1=character
		tst.l	address(a1)								; is player RAM empty?
		beq.s	LoadWaterPalette.return							; if yes, branch
		move.b	(Ctrl_2_logical).w,d6
		moveq	#WindTunnel_holding_flag.player_2,d5
		bra.s	LZ_WaterTunnels
; ---------------------------------------------------------------------------

.isTails

		; check p1
		lea	(Player_1).w,a1								; a1=character
		lea	(WindTunnel_flag_P2).w,a3
		move.b	(Ctrl_1_logical).w,d6
		moveq	#WindTunnel_holding_flag.player_1,d5

; =============== S U B R O U T I N E =======================================

LZ_WaterTunnels:
		moveq	#0,d0
		move.b	(Current_act).w,d0
		add.w	d0,d0
		lea	LZ_WaterTunLocs_Index(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d2

.chksonic
		move.w	x_pos(a1),d0
		cmp.w	(a2),d0
		blo.w	.chknext
		cmp.w	4(a2),d0
		bhs.w	.chknext
		move.w	y_pos(a1),d1
		cmp.w	2(a2),d1
		blo.s	.chknext
		cmp.w	6(a2),d1
		bhs.s	.chknext

		; play continuous sfx
		sfxcont	sfx_Waterfall,$3F							; play water sound every 64th frame

		; check
		cmpi.b	#PlayerID_Hurt,routine(a1)						; is Sonic falling back from getting hurt?
		bhs.s	.clr									; if yes, branch
		btst	d5,(WindTunnel_holding_flag).w
		bne.s	.return
		tst.b	object_control(a1)
		bne.s	.clr
		move.b	#1,(a3)
		moveq	#-128,d0
		add.w	x_pos(a1),d0								; get sonic xpos again
		cmp.w	(a2),d0
		bhs.s	.movesonic
		moveq	#2,d0
		cmpi.b	#1,(Current_act).w							; check if level is LZ2
		bne.s	.notact2								; if not, branch
		neg.w	d0

.notact2
		add.w	d0,y_pos(a1)								; adjust Sonic's y-axis for curve of tunnel

.movesonic
		addq.w	#4,x_pos(a1)
		move.l	#words_to_long($400,0),x_vel(a1)
		move.b	#AniIDSonAni_Float2,anim(a1)
		bset	#status.player.in_air,status(a1)

		; clear
		moveq	#0,d0
		move.b	d0,spin_dash_flag(a1)
		move.b	d0,jumping(a1)
		move.b	d0,double_jump_flag(a1)

		; check buttons
		btst	#button_up,d6								; is up being held?
		beq.s	.down									; if not, branch
		subq.w	#1,y_pos(a1)

.down
		btst	#button_down,d6								; is down being held?
		beq.s	.return									; if not, branch
		addq.w	#1,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

.chknext
		addq.w	#8,a2
		dbf	d2,.chksonic
		tst.b	(a3)
		beq.s	.return2
		move.b	#AniIDSonAni_Hurt,anim(a1)

.clr
		clr.b	(a3)

.return2
		rts

; =============== S U B R O U T I N E =======================================

Water_WaterSlides:
		cmpi.b	#LevelID_LZ,(Current_zone).w						; check if level is LZ
		bne.s	locret_3F7A								; if not, branch
		cmpi.b	#3,(Current_act).w							; check if level is SBZ3
		beq.s	locret_3F7A								; if yes, branch

		; check
		lea	(Player_1).w,a1								; a1=character
		move.b	(Ctrl_1_logical).w,d2
		bsr.s	sub_71E4
		lea	(Player_2).w,a1								; a1=character
		tst.l	address(a1)								; is player RAM empty?
		beq.s	locret_3F7A								; if yes, branch
		move.b	(Ctrl_2_logical).w,d2

sub_71E4:
		btst	#status.player.in_air,status(a1)					; is the player in the air?
		bne.s	loc_3F6A								; if yes, branch
		btst	#status.player.on_object,status(a1)
		bne.s	loc_3F6A

		; calc chunk
		movea.l	(Level_layout_addr_ROM).w,a2
		move.w	y_pos(a1),d0
		lsr.w	#5,d0
		and.w	(Layout_row_index_mask).w,d0
		move.w	x_pos(a1),d1
		lsr.w	#7,d1
		add.w	d1,d1									; chunk ID to word
		add.w	8(a2,d0.w),d1
		adda.w	d1,a2
		move.w	(a2),d0									; get chunk id

		; check chunks
		moveq	#0,d1
		move.b	(Current_act).w,d1
		add.w	d1,d1
		lea	Slide_Chunks_Index(pc),a2
		adda.w	(a2,d1.w),a2
		move.w	-(a2),d1

loc_3F62:
		cmp.w	-(a2),d0
		dbeq	d1,loc_3F62
		beq.s	LZSlide_Move

loc_3F6A:
		tst.b	status_secondary(a1)
		bpl.s	locret_3F7A
		move.w	#5,move_lock(a1)
		andi.b	#$7F,status_secondary(a1)

locret_3F7A:
		rts
; ---------------------------------------------------------------------------

LZSlide_Move:
		moveq	#0,d0
		move.b	(Current_act).w,d0
		add.w	d0,d0
		lea	Slide_Speeds_Index(pc),a2
		adda.w	(a2,d0.w),a2
		move.b	(a2,d1.w),d0
		beq.s	loc_728A
		move.b	ground_vel(a1),d1
		tst.b	d0
		bpl.s	loc_7254
		cmp.b	d0,d1
		ble.s	loc_725E
		subi.w	#$40,ground_vel(a1)
		bra.s	loc_725E
; ---------------------------------------------------------------------------

loc_7254:
		cmp.b	d0,d1
		bge.s	loc_725E
		addi.w	#$40,ground_vel(a1)

loc_725E:
		bclr	#status.player.x_flip,status(a1)
		tst.b	d1
		bpl.s	loc_3F9A
		bset	#status.player.x_flip,status(a1)

loc_3F9A:
		move.b	#AniIDSonAni_Slide,anim(a1)						; use Sonic's "sliding" animation
		ori.b	#$80,status_secondary(a1)						; set water slide flag

		; play continuous sfx
		sfxcont	sfx_Waterfall,$1F,1							; play water sound every 32th frame
; ---------------------------------------------------------------------------

loc_728A:
		moveq	#4,d1
		move.w	ground_vel(a1),d0
		btst	#button_left,d2
		beq.s	loc_72AC
		clr.b	anim(a1)
		bset	#status.player.x_flip,status(a1)
		sub.w	d1,d0
		tst.w	d0
		bpl.s	loc_72AC
		sub.w	d1,d0

loc_72AC:
		btst	#button_right,d2
		beq.s	loc_72C6
		clr.b	anim(a1)
		bclr	#status.player.x_flip,status(a1)
		add.w	d1,d0
		tst.w	d0
		bmi.s	loc_72C6
		add.w	d1,d0

loc_72C6:
		moveq	#4,d1
		tst.w	d0
		beq.s	loc_72EE
		bmi.s	loc_72E0
		sub.w	d1,d0
		bhi.s	loc_72EE
		bra.s	loc_72E6
; ---------------------------------------------------------------------------

loc_72E0:
		add.w	d1,d0
		bhi.s	loc_72EE

loc_72E6:
		moveq	#0,d0
		move.b	#AniIDSonAni_Wait,anim(a1)

loc_72EE:
		move.w	d0,ground_vel(a1)
		ori.b	#$80,status_secondary(a1)
		rts
; ---------------------------------------------------------------------------

		include "Levels/LZ/Misc/Data - Water Effects.asm"
