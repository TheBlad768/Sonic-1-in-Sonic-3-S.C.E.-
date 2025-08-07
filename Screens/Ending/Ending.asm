; ---------------------------------------------------------------------------
; Ending
; ---------------------------------------------------------------------------

; Constants
Ending_Offset:				= *

; Variables


; RAM
	phase ramaddr(Level_trigger_array)

Ending_player:				ds.w 1

	dephase
	!org	Ending_Offset

; =============== S U B R O U T I N E =======================================

EndingScreen:
		music	mus_Stop									; stop music
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	Level_VDP(pc),a1
		jsr	(Load_VDP).w
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_end							; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end						; clear variables
		clearRAM Camera_RAM, Camera_RAM_end							; clear the camera RAM
		clearRAM Oscillating_variables, Oscillating_variables_end				; clear variables

		; clear
		move.b	d0,(Water_full_screen_flag).w
		move.b	d0,(Water_flag).w
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Apparent_zone_and_act).w
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w
;		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w

		; load level
		lea	LevelLoadPointer_Ending(pc),a2
		jsr	(LoadLevelPointer.load).w

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
		move.w	#$8C89,VDP_control_port-VDP_control_port(a6)					; set shadow/highlight mode

.cnotheld
		btst	#button_A,(Ctrl_1_held).w							; is A button held?
		beq.s	.anotheld									; if not, branch
		st	(Debug_mode_flag).w								; enable debug mode

.anotheld
	endif

		; reset water
		move.w	#$8A00+255,(H_int_counter_command).w						; set palette change position (for water)
		move.w	(H_int_counter_command).w,VDP_control_port-VDP_control_port(a6)

		; load general art
		lea	PLC_Ending(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load player palette
		lea	(Level_data_addr_RAM.SPal).w,a1							; load Sonic palette
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		blo.s	.notKnux									; if not, branch
		addq.w	#1,a1										; load Knuckles palette

.notKnux
		moveq	#0,d0
		move.b	(a1),d0										; player palette
		jsr	(LoadPalette).w									; load player's palette

.waitplc
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; check emeralds
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all the emeralds?
		bne.s	.noemer										; if not, branch

		; with emeralds
		move.l	#words_to_long(0,$500),(Level_data_addr_RAM.xstart).w				; camerax (with emeralds)
		move.w	#$620-$20,d0
		move.w	d0,(Level_data_addr_RAM.SonLoc).w						; xpos (with emeralds)
		move.w	d0,(Level_data_addr_RAM.KnuxLoc).w						; xpos (with emeralds)

.noemer

		; set level size
		jsr	(Get_LevelSizeStart).w

		; load level data
		jsr	(DeformBgLayer).w
		jsr	(LoadLevelLoadBlock2.skipPLC).w
		disableInts
		jsr	(Level_Setup).w
		enableInts

		; check
		move.l	(Level_data_addr_RAM.AnimateTilesInit).w,d0
		beq.s	.askip
		movea.l	d0,a0
		jsr	(a0)										; animate art init

.askip

		; load level solid
		jsr	(Load_Solids).w

		; reset level flags
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_2_logical).w
		move.w	d0,(Ctrl_1).w
		move.w	d0,(Ctrl_2).w
		move.b	d0,(HUD_RAM.status).w
		move.b	d0,(Update_HUD_timer).w								; clear time counter update flag
		move.b	d0,(Update_HUD_score).w								; clear score counter update flag
		move.b	d0,(Update_HUD_ring_count).w							; clear rings counter update flag
		move.w	d0,(Ring_count).w								; clear rings
		move.l	d0,(Timer).w									; clear time
		move.b	d0,(Extra_life_flags).w
		move.b	d0,(Saved_status_secondary).w
		move.b	d0,(Respawn_table_keep).w
		move.b	d0,(Time_over_flag).w

		; load level objects (animals)
		move.l	#Load_Objects_Init,(Object_load_addr_RAM).w

		; load players
		bsr.w	SpawnLevelMainSprites

		; p1
		lea	(Player_1).w,a1									; a1=character
		bset	#status.player.x_flip,status(a1)						; make Sonic face left
		move.w	#-$600,ground_vel(a1)								; set Sonic's speed
		st	(Ctrl_1_locked).w								; lock controls
		move.w	#bytes_to_word(btnL,0),(Ctrl_1_logical).w					; move Sonic to the left

		; p2
		lea	(Player_2).w,a1									; a1=character
		tst.l	address(a1)									; is player RAM empty?
		beq.s	.notp2										; if yes, branch
		addi.w	#64,x_pos(a1)
		bset	#status.player.x_flip,status(a1)						; make Tails face left
		move.w	#-$600,ground_vel(a1)								; set Tails's speed
		st	(Ctrl_2_locked).w								; lock controls
		move.w	#bytes_to_word(btnL,0),(Ctrl_2_logical).w					; move Tails to the left
		move.w	#$12,(Tails_CPU_routine).w							; disable CPU

.notp2
		jsr	(Load_Objects).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Animate_Tiles).w

		; set
		music	mus_Ending									; play music

		; next
		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		jsr	(Pause_Game.ending).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	End_MoveSonic
		jsr	(Load_Objects).w
		jsr	(Process_Sprites).w
		jsr	(DeformBgLayer).w
		jsr	(Screen_Events).w
		jsr	(Animate_Palette).w
		jsr	(Animate_Tiles).w
		jsr	(Process_KosPlus_Module_Queue).w
		jsr	(ChangeRingFrame).w
		jsr	(Render_Sprites).w

		; check emeralds
		tst.b	(Restart_level_flag).w								; has Sonic released the emeralds?
		beq.s	.loop										; if not, branch
		clr.b	(Restart_level_flag).w

		; set
		move.w	#bytes_to_word((palette_line_0>>8),64-1),(Palette_fade_info).w			; set fade info and fade count
		clr.w	(Pal_fade_delay).w

.allemlds_loop
		jsr	(Pause_Game.ending).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.s	End_MoveSonic
		jsr	(Load_Objects).w
		jsr	(Process_Sprites).w
		jsr	(DeformBgLayer).w
		jsr	(Screen_Events).w
		jsr	(Animate_Tiles).w
		jsr	(Process_KosPlus_Module_Queue).w
		jsr	(Render_Sprites).w

		; fade to white
		subq.w	#1,(Pal_fade_delay).w								; decrement timer
		bpl.s	.skippal									; if time remains, branch
		addq.w	#2+1,(Pal_fade_delay).w								; reset timer to 2 frames
		jsr	(Pal_ToWhite).w

.skippal
		tst.b	(Restart_level_flag).w
		beq.s	.allemlds_loop
		clr.b	(Restart_level_flag).w

		; modify level layout
		bsr.w	Redraw_EndingChunks

		; redraw fg screen
		lea	(Plane_buffer).w,a0
		movea.l	(Level_data_addr_RAM.16x16RAM).w,a2
		movea.l	(Level_layout_addr2_ROM).w,a3
		move.w	#VRAM_Plane_A_Name_Table,d7							; PNT A base: $C000
		jsr	(Refresh_PlaneScreenDirect).w

		; back to loop
		jsr	(Pal_FadeFromWhite).w
		bra.w	.loop

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

		include "Screens/Ending/Ending - Control.asm"

; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence
; ---------------------------------------------------------------------------

eson_time		= objoff_2E ; time to wait between events
eson_anim		= objoff_30
eson_dplc		= objoff_34

; =============== S U B R O U T I N E =======================================

Obj_Sonic_Ending:
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all the emeralds?
		bne.w	.nonoemrd									; if not, branch

		; init (with emeralds)
		lea	ObjDat_SonicEnding(pc),a1							; load Sonic data
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w						; is Tails?
		bne.s	.notTails									; if not, branch

		; remove Tails tails
		lea	(Tails_tails).w,a1
		jsr	(Delete_Referenced_Sprite).w

		; init
		lea	ObjDat_TailsEnding(pc),a1							; load Tails data

.notTails
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		blo.s	.loadobja									; if not, branch
		lea	ObjDat_KnuxEnding(pc),a1							; load Knuckles data

.loadobja
		clr.b	render_flags(a0)
		jsr	(SetUp_ObjAttributes).w
		move.l	(a1)+,eson_anim(a0)
		move.l	(a1),eson_dplc(a0)
		st	objoff_3A(a0)									; reset DPLC frame
		clr.b	routine(a0)
		clr.b	status(a0)
		clr.b	anim(a0)
		clr.b	mapping_frame(a0)
		move.w	#(1*60)+20,eson_time(a0)							; set duration for Sonic to pause
		move.l	#.makeemrd,address(a0)

.makeemrd
		subq.w	#1,eson_time(a0)								; subtract 1 from duration
		bne.w	.dplc
		move.l	#.waitradanim,address(a0)
		sfx	sfx_MechaTransform								; play sfx
		move.w	#bytes_to_word(0,1),anim(a0)							; use "radiance" animation and reset animate

		; load chaos emeralds objects
		jsr	(Create_New_Sprite).w
		bne.w	.draw
		move.w	a0,parent3(a1)
		move.l	#Obj_EndChaos,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	a1,parent3(a0)

		; next
		bra.w	.draw
; ---------------------------------------------------------------------------

.waitradanim
		tst.b	routine(a0)
		beq.w	.anim
		clr.b	routine(a0)

		; next
		move.l	#.lookup,address(a0)
		bra.w	.draw
; ---------------------------------------------------------------------------

.lookup
		movea.w	parent3(a0),a1									; a1=parent object
		cmpi.w	#$2000,echa_radius(a1)
		bne.w	.draw
		sfx	sfx_SuperEmerald								; play sfx
		st	(Restart_level_flag).w								; set level to restart (causes flash)
		move.w	#(1*60)+30,eson_time(a0)

		; next
		move.l	#.clrobjram,address(a0)
		bra.w	.draw
; ---------------------------------------------------------------------------

.clrobjram
		subq.w	#1,eson_time(a0)								; subtract 1 from duration
		bne.w	.draw

		; delete chaos emeralds objects
		movea.w	parent3(a0),a1									; a1=parent object
		move.l	#Go_Delete_Sprite,address(a1)
		st	(Restart_level_flag).w								; set level to restart
		move.w	#1*60,eson_time(a0)
		move.b	#1,anim(a0)									; use "looks left/right" animation

		; check Tails
		lea	(Player_2).w,a1									; a1=character
		tst.l	address(a1)									; is player RAM empty?
		beq.s	.notp2										; if yes, branch
		move.b	#$2A,anim(a1)									; use "looks left/right" animation

.notp2

		; next
		move.l	#.waitlooksanim,address(a0)
		bra.w	.anim
; ---------------------------------------------------------------------------

.waitlooksanim
		tst.b	routine(a0)
		beq.w	.anim
		clr.b	routine(a0)

		; next
		move.l	#.makelogo,address(a0)
		bra.w	.draw
; ---------------------------------------------------------------------------

.makelogo
		subq.w	#1,eson_time(a0)								; subtract 1 from duration
		bne.w	.draw
		move.w	#3*60,eson_time(a0)
		move.b	#2,anim(a0)									; use "leaping" animation

		; check Tails
		lea	(Player_2).w,a1									; a1=character
		tst.l	address(a1)									; is player RAM empty?
		beq.s	.notp22										; if yes, branch
		move.b	#AniIDSonAni_Landing,anim(a1)							; use "landing" animation

.notp22

		; load "SONIC THE HEDGEHOG" object
		jsr	(Create_New_Sprite).w
		bne.w	.draw
		move.l	#Obj_EndSTH,address(a1)

		; next
		move.l	#.anim,address(a0)
		bra.w	.draw

; =============== S U B R O U T I N E =======================================

.nonoemrd
		move.w	#(4*60)-24,eson_time(a0)
		move.l	#.waitnoemrd,address(a0)

.waitnoemrd
		subq.w	#1,eson_time(a0)
		bpl.w	.draw
		move.l	#.anim,address(a0)

		; check
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w						; is Tails?
		bne.s	.map										; if not, branch

		; remove Tails tails
		lea	(Tails_tails).w,a1
		jsr	(Delete_Referenced_Sprite).w

.map

		; init (without emeralds)
		lea	ObjDat_SonicEnding(pc),a1							; load Sonic data
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w						; is Tails?
		bne.s	.notTails2									; if not, branch
		lea	ObjDat_TailsEnding(pc),a1							; load Tails data

.notTails2
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		blo.s	.loadobja2									; if not, branch
		lea	ObjDat_KnuxEnding(pc),a1							; load Knuckles data

.loadobja2
		clr.b	render_flags(a0)
		jsr	(SetUp_ObjAttributes).w
		move.l	(a1)+,eson_anim(a0)
		move.l	(a1),eson_dplc(a0)
		st	objoff_3A(a0)									; reset DPLC frame
		clr.b	routine(a0)
		clr.b	status(a0)
		move.b	#2,anim(a0)									; use "leaping" animation
		move.b	#5,mapping_frame(a0)

		; check Tails
		lea	(Player_2).w,a1									; a1=character
		tst.l	address(a1)									; is player RAM empty?
		beq.s	.notp222									; if yes, branch
		move.b	#AniIDSonAni_Landing,anim(a1)							; use "landing" animation

.notp222

		; load "SONIC THE HEDGEHOG" object
		jsr	(Create_New_Sprite).w
		bne.s	.anim
		move.l	#Obj_EndSTH,address(a1)

.anim
		movea.l	eson_anim(a0),a1
		jsr	(Animate_Sprite).w

.dplc
		movea.l	eson_dplc(a0),a2
		jsr	(Perform_DPLC).w

.draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 88 - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------

; Dynamic object variables
echa_origX		= objoff_30 ; x-axis center of emerald circle (2 bytes)
echa_origY		= objoff_32 ; y-axis center of emerald circle (2 bytes)
echa_radius		= objoff_3A ; radius (2 bytes)
echa_speed		= objoff_3C ; angle for rotation (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_EndChaos:

		; wait
		cmpi.b	#2,(Player_1+mapping_frame).w							; is object 87, which has its own frames
		bne.w	.return

		; create
		move.l	#.expand,address(a0)

		; copy xypos
		move.w	x_pos(a0),echa_origX(a0)
		move.w	y_pos(a0),echa_origY(a0)

		; create chaos emeralds
		moveq	#0,d2										; mapping frame
		moveq	#0,d3										; angle
		moveq	#ChaosEmer_Count-1,d6
		jsr	(Create_New_Sprite3).w
		bne.s	.expand

.cloop
		move.w	a0,parent3(a1)
		move.l	#.circular,address(a1)
		move.l	#Map_ECha,mappings(a1)
		move.w	#make_art_tile($3C5,0,1),art_tile(a1)
		move.b	#setBit(render_flags.level),render_flags(a1)					; use screen coordinates
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#bytes_word_to_long(16/2,16/2,priority_1),height_pixels(a0)			; set height, width and priority
		move.b	d2,mapping_frame(a1)
		addq.b	#1,d2
		move.b	d3,angle(a1)
		addi.b	#256/ChaosEmer_Count,d3								; angle between each emerald
		jsr	(Create_New_Sprite4).w								; find next free object slot
		dbne	d6,.cloop

.expand
		cmpi.w	#$2000,echa_radius(a0)
		beq.s	.rotate
		addi.w	#$20,echa_radius(a0)								; expand circle of emeralds

.rotate
		cmpi.w	#$2000,echa_speed(a0)
		beq.s	.rise
		addi.w	#$20,echa_speed(a0)								; move emeralds around the center

.rise
		cmpi.w	#$140,echa_origY(a0)
		beq.s	.return
		subq.w	#1,echa_origY(a0)								; make circle rise

.return
		rts
; ---------------------------------------------------------------------------

.circular
		movea.w	parent3(a0),a1									; a1=parent object
		move.w	echa_speed(a1),d0
		add.w	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	echa_radius(a1),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	echa_origY(a1),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)									; move object circularly
		move.w	echa_origX(a1),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw
		jmp	(Child_Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 89 - "SONIC THE HEDGEHOG" text on the ending sequence
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_EndSTH:

		; init
		move.l	#Map_ESth,mappings(a0)
		move.w	#make_art_tile($480,3,1),art_tile(a0)
		move.w	#$80+88,y_pos(a0)
		move.b	(Player_mode+1).w,mapping_frame(a0)
		move.w	#4-1,objoff_2E(a0)								; set duration for delay
		move.l	#.swait,address(a0)

.swait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.l	#.move,address(a0)

.move
		addi.w	#16,x_pos(a0)									; move object to the right
		cmpi.w	#$80+64,x_pos(a0)								; has object reached $40?
		bne.s	.draw										; if yes, branch
		move.w	#5*60,objoff_2E(a0)								; set duration for delay (5 seconds)
		move.l	#.ewait,address(a0)

.ewait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.b	#GameModeID_CreditsScreen,(Game_mode).w						; set screen mode to Credits
		addq.w	#4*2,sp										; exit from object and current screen

.draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Redraw chunks
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Redraw_EndingChunks:
		lea	(RAM_start+$80).l,a1								; get $01-$06 chunk (1*$80)
		lea	$1480(a1),a2									; get $2A-$2F chunk ($2A*$80-$80)

		; redraw

		set	.a,0

	rept 4*6											; replace 6 chunks
		movem.l	(a2)+,d0-d7
		movem.l	d0-d7,.a(a1)									; copy $20 bytes
		set	.a,.a + $20
	endr

		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_SonicEnding:	subObjData Map_SonicEnding, $3E1, 0, 0, 38, 18, 2, 0, 0
			dc.l Ani_ESonic, PLCPtr_SonicEnding
ObjDat_TailsEnding:	subObjData Map_TailsEnding, $3E1, 0, 0, 30, 18, 2, 0, 0
			dc.l Ani_ETails, PLCPtr_TailsEnding
ObjDat_KnuxEnding:	subObjData Map_KnucklesEnding, $3E1, 0, 0, 38, 18, 2, 0, 0
			dc.l Ani_EKnuckles, PLCPtr_KnucklesEnding

; dplc
PLCPtr_SonicEnding:	dc.l dmaSource(ArtUnc_SonicEnding), DPLC_SonicEnding
PLCPtr_TailsEnding:	dc.l dmaSource(ArtUnc_TailsEnding), DPLC_TailsEnding
PLCPtr_KnucklesEnding:	dc.l dmaSource(ArtUnc_KnucklesEnding), DPLC_KnucklesEnding

; ---------------------------------------------------------------------------
; Ending pointer data
; ---------------------------------------------------------------------------

		include "Levels/GHZ/Pointers/Ending - Pointers.asm"

; ---------------------------------------------------------------------------

PLC_Ending: plrlistheader
		plreq 0, GHZ_8x8_KosPM
		plreq $3A0, ArtKosPM_FlowersEnding
		plreq $3C5, ArtKosPM_EmeraldsEnding
		plreq $480, ArtKosPM_StHLogoEnding
		plreq $553, ArtKosPM_Rabbit
		plreq $565, ArtKosPM_Chicken
		plreq $573, ArtKosPM_Penguin
		plreq $585, ArtKosPM_Seal
		plreq $593, ArtKosPM_Pig
		plreq $5A5, ArtKosPM_BlueFlicky
		plreq $5B3, ArtKosPM_Squirrel
PLC_Ending_end
; ---------------------------------------------------------------------------

		include "Screens/Ending/Object Data/Anim - Sonic Ending.asm"
		include "Screens/Ending/Object Data/Anim - Tails Ending.asm"
		include "Screens/Ending/Object Data/Anim - Knuckles Ending.asm"
		include "Screens/Ending/Object Data/Map - Sonic Ending.asm"
		include "Screens/Ending/Object Data/DPLC - Sonic Ending.asm"
		include "Screens/Ending/Object Data/Map - Tails Ending.asm"
		include "Screens/Ending/Object Data/DPLC - Tails Ending.asm"
		include "Screens/Ending/Object Data/Map - Knuckles Ending.asm"
		include "Screens/Ending/Object Data/DPLC - Knuckles Ending.asm"
		include "Screens/Ending/Object Data/Map - Emeralds Ending.asm"
		include "Screens/Ending/Object Data/Map - Sequence STH Ending.asm"
