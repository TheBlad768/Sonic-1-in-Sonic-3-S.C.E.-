; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

Level_VDP:
		dc.w $8004										; disable HInt, HV counter, 8-colour mode
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)						; set foreground nametable address
		dc.w $8300+(VRAM_Plane_B_Name_Table>>10)						; set window nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)						; set background nametable address
		dc.w $8700+(2<<4)									; set background colour (line 3; colour 0)
		dc.w $8B03										; line scroll mode
		dc.w $8C81										; set 40cell screen size, no interlacing, no s/h
		dc.w $9001										; 64x32 cell nametable area
		dc.w $9100										; set window H position at default
		dc.w $9200										; set window V position at default
		dc.w 0											; end marker

; =============== S U B R O U T I N E =======================================

LevelScreen:
		bset	#GameModeFlag_TitleCard,(Game_mode).w						; set bit 7 is indicate that we're loading the level
		music	mus_FadeOut									; fade out music
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		jsr	(Clear_DisplayData).w
		enableInts
		tst.b	(Last_star_post_hit).w
		beq.s	.notstarpost									; if no starpost was set, branch
		tst.b	(Special_bonus_entry_flag).w
		bne.s	.special
		move.w	(Saved_zone_and_act).w,(Current_zone_and_act).w
		move.w	(Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
		bra.s	.notstarpost
; ---------------------------------------------------------------------------

.special
		move.w	(Saved2_zone_and_act).w,(Current_zone_and_act).w
		move.w	(Saved2_apparent_zone_and_act).w,(Apparent_zone_and_act).w

.notstarpost
		clearRAM Object_RAM, Object_RAM_end							; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end						; clear variables
		clearRAM Camera_RAM, Camera_RAM_end							; clear the camera RAM
		clearRAM Oscillating_variables, Oscillating_variables_end				; clear variables
		lea	Level_VDP(pc),a1
		jsr	(Load_VDP).w									; a6 now has a VDP control address do not overwrite this register
		jsr	(LoadLevelPointer).w								; load level data

	if GameDebug

		if GameDebugCheat
			ifndef __DEBUG__
				; check cheat
				tst.b	(Debug_cheat_flag).w
				beq.s	.anotheld
			endif
		endif

		btst	#button_C,(Ctrl_1_held).w							; is C button held?
		beq.s	.cnotheld									; if not, branch
		move.w	#$8C89,VDP_control_port-VDP_control_port(a6)					; set shadow/highlight mode ; warning: don't overwrite a6

.cnotheld
		btst	#button_A,(Ctrl_1_held).w							; is A button held?
		beq.s	.anotheld									; if not, branch
		st	(Debug_mode_flag).w								; enable debug mode

.anotheld
	endif

		move.w	#$8A00+255,(H_int_counter_command).w						; set palette change position (for water)
		move.w	(H_int_counter_command).w,VDP_control_port-VDP_control_port(a6)			; warning: don't overwrite a6

		; load player palette
		lea	(Level_data_addr_RAM.SPal).w,a1							; load Sonic palette
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		blo.s	.notKnux									; if not, branch
		addq.w	#1,a1										; load Knuckles palette

.notKnux
		moveq	#0,d0
		move.b	(a1),d0										; player palette
		move.w	d0,d1
		jsr	(LoadPalette).w									; load player's palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w

		; load HUD art
		move.w	(Player_mode).w,d0
		subq.w	#1,d0
		bhs.s	.loadplc
		moveq	#0,d0

.loadplc
		add.w	d0,d0
		add.w	d0,d0
		lea	PLC_PlayerIndex(pc),a5
		movea.l	(a5,d0.w),a5

		; check Miles
		cmpi.w	#(PlayerModeID_Tails-1)*4,d0
		bne.s	.notMiles
		tst.b	(Graphics_flags).w								; check console region
		bmi.s	.notMiles
		lea	(PLC1_Miles).l,a5

.notMiles
		jsr	(LoadPLC_Raw_KosPlusM).w							; load HUD and ring art
		jsr	(CheckLevelForWater).w
		clearRAM Water_palette_line_2, Normal_palette
		tst.b	(Water_flag).w
		beq.s	.notwater
		move.w	#$8014,VDP_control_port-VDP_control_port(a6)					; H-int enabled	; last use a6 here

.notwater

		; get level music id
		lea	(Level_data_addr_RAM.Music).w,a1						; load music
		moveq	#0,d0
		move.b	(a1),d0
		move.w	d0,(Current_music).w
		jsr	(Play_Music).w									; play music
		move.l	#Obj_TitleCard,(Dynamic_object_RAM+(object_size*5)+address).w			; load title card object

.wait
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(Dynamic_object_RAM+(object_size*5)+objoff_48).w				; has title card sequence finished?
		bne.s	.wait										; if not, branch
		tst.w	(KosPlus_modules_left).w							; are there any items in the pattern load cue?
		bne.s	.wait										; if yes, branch
		disableInts
		jsr	(HUD_DrawInitial).w								; init HUD
		enableInts
		jsr	(Get_LevelSizeStart).w
		jsr	(DeformBgLayer).w
		jsr	(LoadLevelLoadBlock).w
		jsr	(LoadLevelLoadBlock2).w
		disableInts
		jsr	(Level_Setup).w									; draw level
		enableInts

		; check
		move.l	(Level_data_addr_RAM.AnimateTilesInit).w,d0
		beq.s	.askip
		movea.l	d0,a0
		jsr	(a0)										; animate art init

.askip
		jsr	(Load_Solids).w
		jsr	(Handle_Onscreen_Water_Height).w
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_2_logical).w
		move.w	d0,(Ctrl_1).w
		move.w	d0,(Ctrl_2).w
		move.b	d0,(HUD_RAM.status).w								; clear HUD flag
		move.b	d0,(Update_HUD_timer).w								; clear time counter update flag
		tst.b	(Last_star_post_hit).w								; are you starting from a starpost?
		bne.s	.starpost									; if yes, branch
		move.w	d0,(Ring_count).w								; clear rings
		move.l	d0,(Timer).w									; clear time
		move.b	d0,(Extra_life_flags).w
		move.b	d0,(Saved_status_secondary).w
		move.b	d0,(Respawn_table_keep).w

.starpost
		move.b	d0,(Time_over_flag).w
		jsr	(OscillateNumInit).w
		moveq	#1,d0
		move.b	d0,(Ctrl_1_locked).w
		move.b	d0,(Ctrl_2_locked).w
		move.b	d0,(Update_HUD_score).w								; update score counter
		move.b	d0,(Update_HUD_ring_count).w							; update rings counter
		move.b	d0,(Level_started_flag).w
		lea	LevelExtraRender_Data(pc),a1
		jsr	(Load_ExtraRender).w
		move.l	#Load_Objects_Init,(Object_load_addr_RAM).w
		move.l	#Load_Rings_Init,(Rings_manager_addr_RAM).w
		tst.b	(Water_flag).w
		beq.s	.notwater2
		cmpi.w	#bytes_to_word(LevelID_LZ,2),(Current_zone_and_act).w				; is LZ3?
		beq.s	.notwater2									; if yes, branch
		move.l	#Obj_WaveSplash,(Wave_Splash+address).w

.notwater2
		cmpi.b	#LevelID_SLZ,(Current_zone).w							; is SLZ?
		bne.s	.notslz										; if not, branch

		; load pylon
		moveq	#1,d1										; current slot priority
		move.l	#Render_Pylon,d0
		jsr	(AddSlot_ExtraRender).w

.notslz
		bsr.w	SpawnLevelMainSprites
		jsr	(Load_Objects).w
		jsr	(Load_Rings).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Animate_Tiles).w
		bsr.w	GetDemoPtr
		move.w	#bytes_to_word((palette_line_1>>8),48-1),(Palette_fade_info).w			; set fade info and fade count
		jsr	(Pal_FillBlack).w
		moveq	#22,d0
		move.w	d0,(Palette_fade_timer).w							; time for Pal_FromBlack
		move.w	d0,(Dynamic_object_RAM+(object_size*5)+objoff_2E).w				; time for Title Card
		move.w	#$7F00,d0
		move.w	d0,(Ctrl_1).w
		move.w	d0,(Ctrl_2).w
		andi.b	#$7F,(Last_star_post_hit).w
		bclr	#GameModeFlag_TitleCard,(Game_mode).w						; subtract $80 from mode to end pre-level stuff

.loop
		jsr	(Pause_Game).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	Demo_PlayRecord
		jsr	(Special_Events).w
		jsr	(Load_Objects).w
		jsr	(Process_Sprites).w
		tst.b	(Restart_level_flag).w
		bne.w	LevelScreen

		; check demo (we need to avoid render sprite subroutine so as not to break the shields graphics and other things)
		tst.b	(Demo_mode_flag).w
		beq.s	.notdemo
		tst.w	(Demo_timer).w
		beq.s	.exit

.notdemo
		jsr	(DeformBgLayer).w
		jsr	(Screen_Events).w
		jsr	(Handle_Onscreen_Water_Height).w
		jsr	(Load_Rings).w
		jsr	(Animate_Palette).w
		jsr	(Animate_Tiles).w
		jsr	(Process_KosPlus_Module_Queue).w
		jsr	(OscillateNumDo).w
		jsr	(ChangeRingFrame).w
		jsr	(Render_Sprites).w
		bra.s	.loop
; ---------------------------------------------------------------------------

.exit

		; exit from demo
		move.b	#GameModeID_SegaScreen,(Game_mode).w						; set screen mode to Sega
		rts
; ---------------------------------------------------------------------------

PLC_PlayerIndex:
		dc.l PLC1_Sonic		; 0
		dc.l PLC1_Tails		; 1
		dc.l PLC1_Knuckles	; 2
		dc.l PLC1_Knuckles	; 3
LevelExtraRender_Data:
		dc.w 2-1
		dc.l Render_HUD		; 0
		dc.l Render_Rings	; 1

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites:
		move.l	#Obj_ResetCollisionResponseList,(Reserved_object_3+address).w
		bsr.s	SpawnLevelMainSprites_SpawnPlayers
		bsr.w	SpawnLevelMainSprites_SpawnPowerup


		tst.b	(Last_star_post_hit).w
		bne.s	.return
		tst.b	(Special_bonus_entry_flag).w
		bne.s	.return

		; load players
		lea	(Player_1).w,a1									; a1=character
		lea	(Player_2).w,a2									; a2=character

		cmpi.w	#bytes_to_word(LevelID_LZ,3),(Current_zone_and_act).w				; is LZ4?
		bne.s	.notLZ4										; if not, branch

		; set fall
		moveq	#AniIDSonAni_Slide,d1
		btst	#status.player.rolling,(SBZ2_player_roll).w					; is Sonic rolling after SBZ2?
		beq.s	.setfall									; if not, branch
		moveq	#AniIDSonAni_Roll,d1

.setfall
		move.b	d1,anim(a1)
		bset	#status.player.in_air,status(a1)
		tst.l	address(a2)
		beq.s	.notLZ4
		move.b	d1,anim(a2)
		bset	#status.player.in_air,status(a2)

.notLZ4
		cmpi.w	#bytes_to_word(LevelID_SBZ,2),(Current_zone_and_act).w				; is FZ?
		bne.s	.return										; if not, branch
		cmpi.b	#GameModeID_LevelSelectScreen,(Game_mode_last).w				; is the level loaded from Level Select?
		beq.s	.return										; if yes, branch

		; create jump object
		move.l	#Obj_Spawn_FinalZone,(Dynamic_object_RAM+(object_size*2)).w

		; set jump
		moveq	#48,d0
		add.w	d0,y_pos(a1)
		tst.l	address(a2)
		beq.s	.return
		add.w	d0,y_pos(a2)

.return
		rts

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPlayers:
		move.w	(Player_mode).w,d0
		bne.s	.SonicAlone

		; Sonic and Tails
		move.l	#Obj_Sonic,(Player_1+address).w
		move.l	#Obj_DashDust,(Dust+address).w
		move.l	#Obj_InstaShield,(Shield+address).w
		move.w	#Player_1,(Shield+parent).w
		move.l	#Obj_Tails,(Player_2+address).w
		moveq	#-32,d0
		add.w	(Player_1+x_pos).w,d0
		move.w	d0,(Player_2+x_pos).w
		move.w	(Player_1+y_pos).w,d0
		addq.w	#4,d0
		move.w	d0,(Player_2+y_pos).w
		move.l	#Obj_DashDust,(Dust_P2+address).w
		clr.w	(Tails_CPU_routine).w
		rts
; ---------------------------------------------------------------------------

.SonicAlone
		subq.w	#1,d0
		bne.s	.TailsAlone

		; Sonic alone
		move.l	#Obj_Sonic,(Player_1+address).w
		move.l	#Obj_DashDust,(Dust+address).w
		move.l	#Obj_InstaShield,(Shield+address).w
		move.w	#Player_1,(Shield+parent).w
		rts
; ---------------------------------------------------------------------------

.TailsAlone
		subq.w	#1,d0
		bne.s	.KnuxAlone

		; Tails alone
		move.l	#Obj_Tails,(Player_1+address).w
		move.l	#Obj_DashDust,(Dust_P2+address).w
		addq.w	#4,(Player_1+y_pos).w
		clr.w	(Tails_CPU_routine).w
		rts
; ---------------------------------------------------------------------------

.KnuxAlone
		subq.w	#1,d0
		bne.s	.KnuxTails

		; Knuckles alone
		move.l	#Obj_Knuckles,(Player_1+address).w
		move.l	#Obj_DashDust,(Dust+address).w
		rts
; ---------------------------------------------------------------------------

.KnuxTails

		; Knuckles and Tails
		move.l	#Obj_Knuckles,(Player_1+address).w
		move.l	#Obj_DashDust,(Dust+address).w
		move.l	#Obj_Tails,(Player_2+address).w
		moveq	#-32,d0
		add.w	(Player_1+x_pos).w,d0
		move.w	d0,(Player_2+x_pos).w
		move.w	(Player_1+y_pos).w,d0
		addq.w	#4,d0
		move.w	d0,(Player_2+y_pos).w
		move.l	#Obj_DashDust,(Dust_P2+address).w
		clr.w	(Tails_CPU_routine).w
		rts

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPowerup:

		; check status
		moveq	#signextendB( \
			setBit(status_secondary.shield) | \
			setBit(status_secondary.fire_shield) | \
			setBit(status_secondary.lightning_shield) | \
			setBit(status_secondary.bubble_shield) \
		),d1

		move.b	(Saved_status_secondary).w,d0
		clr.b	(Saved_status_secondary).w
		and.b	d1,d0
		bne.s	.fireshield
		move.b	(Saved2_status_secondary).w,d0
		clr.b	(Saved2_status_secondary).w
		and.b	d1,d0
		bne.s	.fireshield

.return
		rts
; ---------------------------------------------------------------------------

.fireshield

		; load player
		lea	(Player_1).w,a1									; a1=character

		; check shields
		btst	#status_secondary.fire_shield,d0
		beq.s	.ltngshield

		; sets Status_Shield, Status_FireShield, Status_LtngShield, and Status_BublShield to 0
		andi.b	#~( \
			setBit(status_secondary.shield) | \
			setBit(status_secondary.fire_shield) | \
			setBit(status_secondary.lightning_shield) | \
			setBit(status_secondary.bubble_shield) \
		),status_secondary(a1)

		bset	#status_secondary.shield,status_secondary(a1)
		bset	#status_secondary.fire_shield,status_secondary(a1)
		move.l	#Obj_FireShield,(Shield+address).w
		move.w	a1,(Shield+parent).w
		rts
; ---------------------------------------------------------------------------

.ltngshield
		btst	#status_secondary.lightning_shield,d0
		beq.s	.bublshield

		; sets Status_Shield, Status_FireShield, Status_LtngShield, and Status_BublShield to 0
		andi.b	#~( \
			setBit(status_secondary.shield) | \
			setBit(status_secondary.fire_shield) | \
			setBit(status_secondary.lightning_shield) | \
			setBit(status_secondary.bubble_shield) \
		),status_secondary(a1)

		bset	#status_secondary.shield,status_secondary(a1)
		bset	#status_secondary.lightning_shield,status_secondary(a1)
		move.l	#Obj_LightningShield,(Shield+address).w
		move.w	a1,(Shield+parent).w
		rts
; ---------------------------------------------------------------------------

.bublshield
		btst	#status_secondary.bubble_shield,d0
		beq.s	.blueshield

		; sets Status_Shield, Status_FireShield, Status_LtngShield, and Status_BublShield to 0
		andi.b	#~( \
			setBit(status_secondary.shield) | \
			setBit(status_secondary.fire_shield) | \
			setBit(status_secondary.lightning_shield) | \
			setBit(status_secondary.bubble_shield) \
		),status_secondary(a1)

		bset	#status_secondary.shield,status_secondary(a1)
		bset	#status_secondary.bubble_shield,status_secondary(a1)
		move.l	#Obj_BubbleShield,(Shield+address).w
		move.w	a1,(Shield+parent).w
		rts
; ---------------------------------------------------------------------------

.blueshield
		btst	#status_secondary.shield,d0
		beq.s	.notshield

		; sets Status_Shield, Status_FireShield, Status_LtngShield, and Status_BublShield to 0
		andi.b	#~( \
			setBit(status_secondary.shield) | \
			setBit(status_secondary.fire_shield) | \
			setBit(status_secondary.lightning_shield) | \
			setBit(status_secondary.bubble_shield) \
		),status_secondary(a1)

		bset	#status_secondary.shield,status_secondary(a1)
		move.l	#Obj_BlueShield,(Shield+address).w
		move.w	a1,(Shield+parent).w

.notshield
		rts

; ---------------------------------------------------------------------------
; Reset collision (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ResetCollisionResponseList:
		clr.w	(Collision_response_list).w
		rts
