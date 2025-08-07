; ---------------------------------------------------------------------------
; Special Stage
; ---------------------------------------------------------------------------

; Constants
SpecialStage_Offset:			= *

; Special Stage
ArtTile_SS_Background_Clouds:		= 0
ArtTile_SS_Background_Fish:		= $51

; Items
ArtTile_SS_Wall:			= $142
ArtTile_SS_Bumper:			= $152
ArtTile_SS_Goal:			= $168
ArtTile_SS_Up_Down:			= $17A
ArtTile_SS_R_Block:			= $195
ArtTile_SS_Emerald_Sparkle:		= $19E
ArtTile_SS_Red_White_Block:		= $1A7
ArtTile_SS_Ghost_Block:			= $1B0
ArtTile_SS_Glass:			= $1B9
ArtTile_SS_Emerald:			= $1C2

; Unused
ArtTile_SS_Extra_Life:			= $370
ArtTile_SS_W_Block:			= $570
ArtTile_SS_Zone_1:			= $797
ArtTile_SS_Zone_2:			= $7A0
ArtTile_SS_Zone_3:			= $7A9
ArtTile_SS_Zone_4:			= $797
ArtTile_SS_Zone_5:			= $7A0
ArtTile_SS_Zone_6:			= $7A9

; Misc
ArtTile_SS_HUD				= $260
ArtTile_SS_Ring				= $7B2
ArtTile_SS_Ring_Sparks			= ArtTile_SS_Ring+4

; RAM
	phase ramaddr(RAM_start)

SStage_Buffer1:				ds.b $4000							; S1: $0000-$3FFF
SStage_Buffer1_end			= *								; S1: ($4000 bytes)
SStage_BlockBuffer:			= SStage_Buffer1+$1020						; S1: $1020-$31FF
SStage_BlockBuffer_end			= SStage_BlockBuffer+$80*$40					; S1: ($2000 bytes)


SStage_Buffer2:				ds.b $1000							; S1: layout data ; ($1000 bytes)
SStage_BlockTypes:			= SStage_Buffer2						; S1: $4000-$43FF ; ($400 bytes)
SStage_ItemBuffer:			= SStage_Buffer2+$400						; S1: $4400-$44FF ; ($100 bytes)
SStage_ItemBuffer_end			= SStage_Buffer2+$500

SStage_Buffer3:				ds.b $400							; S1: $5000-$53FF ; item xypos ; ($400 bytes)

SStage_Scroll_Buffer:			ds.b $100							; S1: $1C bytes used?
SStage_Scroll_Buffer2:			ds.b $100							; S1: $28 bytes used?

SStage_Ghost_Buffer:			ds.w 14+2							; max ghost solids + header

	dephase


	phase ramaddr(Palette_cycle_counters)

SStage_scalar_index_0:			ds.w 1
SStage_scalar_index_1:			ds.w 1
v_palss_num:				ds.w 1
v_palss_time:				ds.w 1
v_ssbganim:				ds.w 1


v_bg3screenposx:			ds.l 1
v_ani0_time:				ds.b 1
v_ani0_frame:				ds.b 1
v_ani2_time:				ds.b 1
v_ani2_frame:				ds.b 1
v_ani3_time:				ds.b 1
v_ani3_frame:				ds.b 1
Special_stage_flag:			ds.b 1
					ds.b 1	; even

Special_stage_ring_count:		ds.w 1
Emerald_flicker_flag:			ds.w 1
Special_stage_spheres_left:		ds.w 1
Special_stage_rings_left:		ds.w 1
Saved_special_stage:			ds.b 1

	dephase
	!org	SpecialStage_Offset
; ---------------------------------------------------------------------------

SpecialStage_VDP:
		dc.w $8004										; disable HInt, HV counter, 8-colour mode
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)						; set foreground nametable address
		dc.w $8300+(VRAM_Plane_B_Name_Table>>10)						; set window nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)						; set background nametable address
		dc.w $8700+(2<<4)									; set background colour (line 3; colour 0)
		dc.w $8B03										; line scroll mode
		dc.w $8C81										; set 40cell screen size, no interlacing, no s/h
		dc.w $9011										; 64x64 cell nametable area
		dc.w $9100										; set window H position at default
		dc.w $9200										; set window V position at default
		dc.w 0											; end marker
SpecialStage_VDP2:
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)						; set foreground nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)						; set background nametable address
		dc.w $9001										; 64x32 cell nametable area
		dc.w 0											; end marker

; =============== S U B R O U T I N E =======================================

SpecialStageScreen:
		music	mus_Stop									; stop music
		sfx	sfx_EnterSS									; play special stage entry sound
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToWhite).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	SpecialStage_VDP(pc),a1
		jsr	(Load_VDP).w
		clearRAM Object_RAM, Object_RAM_end							; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end						; clear variables
		clearRAM Camera_RAM, Camera_RAM_end							; clear the camera RAM
		clearRAM Oscillating_variables, Oscillating_variables_end				; clear variables

		; clear
		move.b	d0,(Water_full_screen_flag).w
		move.b	d0,(Water_flag).w
		move.b	d0,(HUD_RAM.status).w
		move.w	d0,(Camera_min_Y_pos).w								; set level size for debug mode

		; set
		moveq	#-1,d0
		move.w	d0,(Anim_Counters).w								; reset block frame
		move.w	d0,(Special_stage_spheres_left).w						; set -1 (0 = Got)
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.w	#$7F0,(Camera_Y_pos_mask).w
		move.w	#$7F0,(Camera_target_max_Y_pos).w						; set level size for debug mode
		moveq	#1,d0
		move.b	d0,(Update_HUD_ring_count).w							; update rings counter
		move.b	d0,(Level_started_flag).w

	if (GameDebug)&&(~~GameDebugAlt)
		move.l	#Debug_Special,(Level_data_addr_RAM.Debug).w					; set debug mode items
	endif

		; load BG
		bsr.w	SS_BGLoad

		; load art
		lea	PLC_SpecialStage(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w							; load special stage patterns

		; load special stage palette
		lea	(Pal_SSSonic).l,a1
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.notKnux

.palssk		:= Pal_SSKnuckles-Pal_SSSonic								; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.palssk)(a1),a1								; Pal_SSKnuckles

.notKnux
		lea	(Target_palette_line_1).w,a2
		jsr	(PalLoad_Line16).w

		; load special stage palette
		lea	(Pal_SpecialStage).l,a1
		lea	(Target_palette_line_2).w,a2
		jsr	(PalLoad_Line48).w

		; load emeralds palette
		moveq	#0,d0
		lea	(Pal_SpecialStageEmeralds).l,a1
		move.b	(Current_special_stage).w,d0
		add.w	d0,d0										; multiply by 6
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		lea	(Target_palette_line_2+$18).w,a2
		move.l	(a1)+,(a2)+
		move.w	(a1),(a2)

.waitplc
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; load layout
		bsr.w	SS_Load										; load SS layout data

		; load character
		move.l	#Obj_PlayerSpecial,(Player_1+address).w						; load special stage player object

		; update palette
		lea	(VDP_data_port).l,a6								; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5						; load VDP control address to a5
		bsr.w	PalCycle_SS

		; set
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.w	d0,(SStage_scalar_index_0).w							; set stage angle to "upright"
		move.w	#$40,(SStage_scalar_index_1).w							; set stage rotation speed
		move.b	#1,(HUD_RAM.status).w								; load HUD
		lea	SSExtraRender_Data(pc),a1
		jsr	(Load_ExtraRender).w

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
		move.w	#$8C89,VDP_control_port-VDP_control_port(a5)					; set shadow/highlight mode

.cnotheld
		btst	#button_A,(Ctrl_1_held).w							; is A button held?
		beq.s	.anotheld									; if not, branch
		st	(Debug_mode_flag).w								; enable debug mode

.anotheld
	endif

		music	mus_SpecialStage								; play Special Stage BG music
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	GetDemoPtr
		enableScreen
		jsr	(Pal_FadeFromWhite).w

.loop
		jsr	(Pause_Game).w
		move.b	#VintID_SpecialStage,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Demo_PlayRecord
		bsr.w	Process_SSSprites
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		jsr	(Render_Sprites).w
		bsr.w	SS_ShowLayout
		bsr.w	SS_BGAnimate

		; check demo
		tst.b	(Demo_mode_flag).w
		beq.s	.notdemo
		tst.w	(Demo_timer).w
		beq.s	.exit

.notdemo
		tst.b	(Special_stage_flag).w
		beq.s	.loop
		clr.b	(Special_stage_flag).w

		; check demo
		tst.b	(Demo_mode_flag).w
		beq.s	.fin

.exit

		; exit from demo
		move.b	#GameModeID_SegaScreen,(Game_mode).w						; set screen mode to Sega
		rts
; ---------------------------------------------------------------------------

.fin
		move.w	#1*60,(Demo_timer).w								; set delay time to 1 second
		move.w	#bytes_to_word((palette_line_0>>8),64-1),(Palette_fade_info).w			; set fade info and fade count
		clr.w	(Pal_fade_delay).w

.finloop
		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	Process_SSSprites
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		jsr	(Render_Sprites).w
		bsr.w	SS_ShowLayout
		bsr.w	SS_BGAnimate

		; fade to white
		subq.w	#1,(Pal_fade_delay).w								; decrement timer
		bpl.s	.skippal									; if time remains, branch
		addq.w	#2+1,(Pal_fade_delay).w								; reset timer to 2 frames
		jsr	(Pal_ToWhite).w

.skippal
		tst.w	(Demo_timer).w
		bne.s	.finloop

		; next
		music	mus_FadeOut									; fade out music
		ResetDMAQueue										; clear DMA queue
		disableInts
		lea	SpecialStage_VDP2(pc),a1
		jsr	(Load_VDP).w
		jsr	(Clear_DisplayData).w
		clearRAM Object_RAM, Object_RAM_end							; clear object RAM
		jsr	(HUD_DrawInitial).w
		move.b	#1,(Update_HUD_score).w
		clr.b	(HUD_RAM.status).w
		clr.b	(Level_started_flag).w

		; remove HUD
		moveq	#0,d1										; current slot
		jsr	(DeleteSlot_ExtraRender).w
		enableInts

		; check restore
		tst.b	(Special_bonus_entry_flag).w
		beq.s	.skip
		clr.b	(Special_bonus_entry_flag).w							; clear Special Stage flag
		move.w	(Saved2_zone_and_act).w,(Current_zone_and_act).w
		ori.b	#$80,(Last_star_post_hit).w							; flag for restore starpost data

.skip

		; load Special Stage palette
		lea	(Pal_Sonic).l,a1
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.notKnux2

.palk		:= Pal_Knuckles-Pal_Sonic								; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.palk)(a1),a1									; Pal_Knuckles

.notKnux2
		lea	(Target_palette_line_1).w,a2
		jsr	(PalLoad_Line16).w

		; load Special Stage palette
		lea	(Pal_SpecialStageResults).l,a1
		jsr	(PalLoad_Line48).w

		; load art
		lea	PLC_SpecialStageResults(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load character name art
		move.w	(Player_mode).w,d0
		add.w	d0,d0
		add.w	d0,d0
		lea	(PlayerResults_Index).l,a1							; select character name to use based on character of course
		movea.l	(a1,d0.w),a1

		; check Miles
		cmpi.w	#PlayerModeID_Tails*4,d0
		bne.s	.notMiles
		tst.b	(Graphics_flags).w								; check console region
		bmi.s	.notMiles
		lea	(ArtKosPM_ResultsMILES).l,a1

.notMiles
		move.w	#tiles_to_bytes($548),d2
		jsr	(Queue_KosPlus_Module).w

	if SuperHyperSonKnux
		lea	(ArtKosPM_SSResultsHYPER).l,a1
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w						; is Tails?
		bne.s	.notTails									; if not, branch

.artss		:= ArtKosPM_SSResultsSUPER-ArtKosPM_SSResultsHYPER					; Macro AS hack: if you use subtraction directly in lea it will slow down the assembly several times. So we will use :=/set

		lea	(.artss)(a1),a1

.notTails
	else
		lea	(ArtKosPM_SSResultsSUPER).l,a1
	endif

		move.w	#tiles_to_bytes($4E0),d2
		jsr	(Queue_KosPlus_Module).w

		; load object
		move.l	#Obj_SpecialStage_Results,(Dynamic_object_RAM+(object_size*29)+address).w	; load results screen object
		jsr	(Pal_FadeFromWhite).w

.results
		move.b	#VintID_SpecialStageResults,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		move.w	(Emerald_flicker_flag).w,d1
		addq.w	#1,d1
		cmpi.w	#3,d1
		blo.s	.flicker
		moveq	#0,d1

.flicker
		move.w	d1,(Emerald_flicker_flag).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		bra.s	.results
; ---------------------------------------------------------------------------

SSExtraRender_Data:
		dc.w 1-1
		dc.l Render_SSHUD	; 0

; ---------------------------------------------------------------------------
; Special Stage background loading subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_BGLoad:

		; load mappings for the birds and fish
		EniDecomp	MapEni_SSBg1, RAM_start, ArtTile_SS_Background_Fish, 2, 0		; decompress Enigma mappings
		locVRAM	$5000,d3									; set nametable address
		lea	(RAM_start+$80).l,a2
		moveq	#7-1,d7

loc_48BE:
		move.l	d3,d0
		moveq	#4-1,d6
		moveq	#0,d4
		cmpi.w	#4-1,d7
		bhs.s	loc_48CC
		moveq	#1,d4

loc_48CC:
		moveq	#8-1,d5

loc_48CE:
		lea	(a2),a1
		eori.b	#1,d4
		bne.s	loc_48E2
		cmpi.w	#7-1,d7
		bne.s	loc_48F2
		lea	(RAM_start).l,a1

loc_48E2:
		movem.l	d0-d4,-(sp)
		moveq	#bytesToXcnt(64,8),d1
		moveq	#bytesToXcnt(64,8),d2
		jsr	(Plane_Map_To_VRAM).w
		movem.l	(sp)+,d0-d4

loc_48F2:
		addi.l	#vdpCommDelta(planeLoc(8,0,1)),d0
		dbf	d5,loc_48CE
		addi.l	#vdpCommDelta(planeLoc(128,320,1)),d0
		eori.b	#1,d4
		dbf	d6,loc_48CC
		addi.l	#vdpCommDelta(planeLoc(2048,0,1)),d3
		bpl.s	loc_491C
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_491C:
		lea	$80(a2),a2
		dbf	d7,loc_48BE

		; load mappings for the clouds
		EniDecomp	MapEni_SSBg2, RAM_start, ArtTile_SS_Background_Clouds, 2, 0		; decompress Enigma mappings
		copyTilemap	VRAM_Plane_A_Name_Table, 512, 256
		lea	(RAM_start).l,a1
		copyTilemap	(VRAM_Plane_A_Name_Table+$1000), 512, 512, 1

; ---------------------------------------------------------------------------
; Subroutine to make the Special Stage background animated
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_BGAnimate:
		move.w	(v_ssbganim).w,d0
		bne.s	loc_4BF6
		clr.w	(Camera_Y_pos_BG_copy).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w

loc_4BF6:
		cmpi.w	#8,d0
		bhs.s	loc_4C4E
		cmpi.w	#6,d0
		bne.s	loc_4C10
		addq.w	#1,(v_bg3screenposx).w
		addq.w	#1,(Camera_Y_pos_BG_copy).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w

loc_4C10:
		moveq	#0,d0
		move.w	(Camera_X_pos_BG_copy).w,d0
		neg.w	d0
		swap	d0
		lea	byte_4CCC(pc),a1
		lea	(SStage_Scroll_Buffer2).l,a3
		moveq	#10-1,d3

loc_4C26:
		move.w	2(a3),d0
		jsr	(GetSineCosine).w
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_4C26
		lea	(SStage_Scroll_Buffer2).l,a3
		lea	byte_4CB8(pc),a2
		bra.s	loc_4C7E
; ---------------------------------------------------------------------------

loc_4C4E:
		cmpi.w	#$C,d0
		bne.s	loc_4C74
		subq.w	#1,(v_bg3screenposx).w
		lea	(SStage_Scroll_Buffer).l,a3
		move.l	#$18000,d2
		moveq	#7-1,d1

loc_4C64:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_4C64

loc_4C74:
		lea	(SStage_Scroll_Buffer).l,a3
		lea	byte_4CC4(pc),a2

loc_4C7E:
		lea	(H_scroll_buffer).w,a1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(Camera_Y_pos_BG_copy).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		add.w	d2,d2
		add.w	d2,d2

loc_4C9A:
		move.w	(a3),d0
		addq.w	#4,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1										; dbf fix

loc_4CA4:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_4CA4
		dbf	d3,loc_4C9A
		rts
; ---------------------------------------------------------------------------

byte_4CB8:				; SStage_Scroll_Buffer2
		dc.b 9, $28		; d3, d1
		dc.b $18, $10
		dc.b $28, $18
		dc.b $10, $30
		dc.b $18, 8
		dc.b $10, 0
byte_4CC4:				; SStage_Scroll_Buffer
		dc.b 6, $30		; d3, d1
		dc.b $30, $30
		dc.b $28, $18
		dc.b $18, $18
byte_4CCC:
		dc.b 8, 2		; sin, cos
		dc.b 4, -1
		dc.b 2, 3
		dc.b 8, -1
		dc.b 4, 2
		dc.b 2, 3
		dc.b 8, -3
		dc.b 4, 2
		dc.b 2, 3
		dc.b 2, -1

; ---------------------------------------------------------------------------
; Subroutine to show the Special Stage layout
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_ShowLayout:
		bsr.w	SS_AniWallsRings
		bsr.w	SS_AniItems
		lea	(SStage_Buffer3).l,a1

	if ~~SpecialStageRotation
		moveq	#-4,d0
		and.b	(SStage_scalar_index_0).w,d0							; original rotation
	else
		move.b	(SStage_scalar_index_0).w,d0							; smooth rotation
	endif

		jsr	(GetSineCosine).w
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(Camera_X_pos_copy).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(Camera_Y_pos_copy).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		moveq	#16-1,d7

loc_1B19E:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		moveq	#16-1,d6

loc_1B1C0:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_1B1C0
		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_1B19E

		lea	(SStage_Buffer1).l,a0
		moveq	#0,d0
		move.w	(Camera_Y_pos_copy).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(Camera_X_pos_copy).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0

; BuildSprites:
		lea	(SStage_Buffer2).l,a2								; load layout
		lea	SStage_Buffer3-SStage_Buffer2(a2),a1						; load object xypos
		lea	(Sprite_table_buffer).w,a6							; set address for sprite table
		moveq	#80-1,d7									; max sprites
		moveq	#0,d6
		move.b	(Sprites_drawn).w,d6								; load sprite count
		sub.b	d6,d7
		lsl.w	#3,d6										; 1=8
		adda.w	d6,a6
		moveq	#16-1,d2

.levelloop
		moveq	#16-1,d3									; set objects count

.objloop
		moveq	#0,d0
		move.b	(a0)+,d0									; load mapping ID
		beq.s	.nextlevel									; if null, branch
		cmpi.b	#(SS_MapIndex_end-SS_MapIndex)/6,d0						; is last mapping?
		bhi.s	.nextlevel									; if yes, branch

		; check xpos
		move.w	(a1),d4										; get xpos
		addi.w	#288,d4
		cmpi.w	#112,d4
		blo.s	.nextlevel
		cmpi.w	#464,d4
		bhs.s	.nextlevel

		; check ypos
		move.w	2(a1),d5									; get ypos
		addi.w	#240,d5
		cmpi.w	#112,d5
		blo.s	.nextlevel
		cmpi.w	#368,d5
		bhs.s	.nextlevel

		; load mapping
		lsl.w	#3,d0										; 1=8
		lea	(a2,d0.w),a4
		movea.l	(a4)+,a3									; address of mappings
		move.w	(a4)+,d6									; frame number
		add.w	d6,d6										; 1+1
		adda.w	(a3,d6.w),a3									; get mappings frame address
		move.w	(a4),d6										; VRAM
		move.w	(a3)+,d1									; number of sprite pieces
		subq.w	#1,d1										; "
		bmi.s	.nextlevel									; if there are 0 pieces, branch

.setmap
		move.b	(a3)+,d0									; get y-offset
		ext.w	d0										; byte to word
		add.w	d5,d0										; add y-position
		move.w	d0,(a6)+									; write to buffer
		move.b	(a3)+,(a6)+									; write sprite size
		addq.w	#1,a6										; skip sprite link
		move.w	(a3)+,d0									; get art tile
		add.w	d6,d0										; add art tile offset
		move.w	d0,(a6)+									; write to buffer
		move.w	(a3)+,d0									; get x-offset
		add.w	d4,d0										; add x-position
		andi.w	#$1FF,d0									; keep within 512px
		bne.s	.writeX
		addq.w	#1,d0

.writeX
		move.w	d0,(a6)+									; write to buffer
		subq.w	#1,d7										; decrease sprite counter
		dbmi	d1,.setmap									; process next sprite piece
		bmi.s	.finish

.nextlevel
		addq.w	#4,a1										; next object xypos
		dbf	d3,.objloop
		lea	$70(a0),a0
		dbf	d2,.levelloop

.finish
		move.w	d7,d6
		bmi.s	.end
		moveq	#0,d0

.clear
		move.w	d0,(a6)
		addq.w	#8,a6
		dbf	d7,.clear

.end
		subi.w	#80-1,d6
		neg.w	d6
		move.b	d6,(Sprites_drawn).w
		rts

; ---------------------------------------------------------------------------
; Subroutine to animate walls and rings in the Special Stage
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_AniWallsRings:

.frames	= 16				; walls frames
.size		= ($200/$20)>>2		; art size (32x32) ; rotation in 16 frames(&$FC00)

		; dynamic blocks graphics
		moveq	#0,d1										; VRAM
		move.w	(SStage_scalar_index_0).w,d1
		andi.w	#(((.frames-1)*(.size))<<8)&$FC00,d1						; calc frames and art size

		; check frame
		cmp.w	(Anim_Counters).w,d1
		beq.s	.ranim
		move.w	d1,(Anim_Counters).w								; set prev_anim	; save art pos

		; load art
		lsr.w	#2,d1										; /2 = $0100 (AssumeSourceAddressIsRAMSafe) ; $400>>1
		addi.l	#dmaSource(ArtUnc_SSWalls),d1							; get next frame
		move.w	#tiles_to_bytes(ArtTile_SS_Wall),d2						; load art destination

		; size of art (in words) ; we only need one frame
		move.w	#tiles_to_bytes( \
		dmaLength(16) \
		),d3

		jsr	(Add_To_DMA_Queue).w

.ranim

		; ring anim
		subq.b	#1,(Rings_frame_timer).w
		bpl.s	loc_1B2C8
		addq.b	#4+1,(Rings_frame_timer).w
		addq.b	#1,(Rings_frame).w
		andi.b	#7,(Rings_frame).w

		; dynamic ring graphics
		moveq	#0,d1
		move.b	(Rings_frame).w,d1
		lsl.w	#6,d1
		add.l	#dmaSource(ArtUnc_SSRing),d1							; get next frame
		move.w	#tiles_to_bytes($7B2),d2							; load art destination

		; size of art (in words) ; we only need one frame
		moveq	#tiles_to_bytes( \
		dmaLength(4) \
		),d3

		jsr	(Add_To_DMA_Queue).w

loc_1B2C8:
		lea	(SStage_Buffer2+5).l,a1
		subq.b	#1,(v_ani2_time).w
		bpl.s	loc_1B2E4
		addq.b	#7+1,(v_ani2_time).w
		addq.b	#1,(v_ani2_frame).w
		andi.b	#1,(v_ani2_frame).w

loc_1B2E4:
		move.b	(v_ani2_frame).w,d0
		move.b	d0,$27*8(a1)									; goal ($27)
		move.b	d0,$29*8(a1)									; up/down ($29)	; (up)
		move.b	d0,$2A*8(a1)									; up/down ($2A)	; (down)
		move.b	d0,$2C*8(a1)									; white block ($2C)
		move.b	d0,$3B*8(a1)									; emerald 1 ($3B)
		move.b	d0,$3C*8(a1)									; emerald 2 ($3C)
		move.b	d0,$3D*8(a1)									; emerald 3 ($3D)
		move.b	d0,$3E*8(a1)									; emerald 4 ($3E)
		move.b	d0,$3F*8(a1)									; emerald 5 ($3F)
		move.b	d0,$40*8(a1)									; emerald 6 ($40)
		move.b	d0,$4F*8(a1)									; emerald 7 ($4F)

		; next anim
		subq.b	#1,(v_ani3_time).w
		bpl.s	loc_1B326
		addq.b	#4+1,(v_ani3_time).w
		addq.b	#1,(v_ani3_frame).w
		andi.b	#3,(v_ani3_frame).w

loc_1B326:
		move.b	(v_ani3_frame).w,d0
		move.b	d0,$2D*8(a1)									; glass ($2D)
		move.b	d0,$2E*8(a1)									; glass ($2E)
		move.b	d0,$2F*8(a1)									; glass ($2F)
		move.b	d0,$30*8(a1)									; glass ($30)

		; next anim
		subq.b	#1,(v_ani0_time).w
		bpl.s	loc_1B350
		addq.b	#7+1,(v_ani0_time).w
		subq.b	#1,(v_ani0_frame).w
		andi.b	#7,(v_ani0_frame).w

loc_1B350:

		; wall anim (blue, yellow, purple)
		lea	(SStage_Buffer2+$16).l,a1
		lea	SS_WaRiVramSet(pc),a0
		moveq	#0,d0
		move.b	(v_ani0_frame).w,d0
		add.w	d0,d0
		adda.w	d0,a0

		set	.a,0

	rept 3
		move.w	(a0)+,.a(a1)									; 1 ; 0
		move.w	(a0)+,.a+(1*8)(a1)								; 2 ; 2
		move.w	(a0)+,.a+(2*8)(a1)								; 3 ; 4
		move.w	(a0)+,.a+(3*8)(a1)								; 4 ; 6
		move.w	(a0)+,.a+(4*8)(a1)								; 5 ; 8
		move.w	(a0)+,.a+(5*8)(a1)								; 6 ; A
		move.w	(a0)+,.a+(6*8)(a1)								; 7 ; C
		move.w	(a0),.a+(7*8)(a1)								; 8 ; E
		lea	$12(a0),a0									; $10+2
		set	.a,.a + 9*8									; next wall
	endr

		; last (green)
		move.w	(a0)+,.a(a1)									; 1 ; 0
		move.w	(a0)+,.a+(1*8)(a1)								; 2 ; 2
		move.w	(a0)+,.a+(2*8)(a1)								; 3 ; 4
		move.w	(a0)+,.a+(3*8)(a1)								; 4 ; 6
		move.w	(a0)+,.a+(4*8)(a1)								; 5 ; 8
		move.w	(a0)+,.a+(5*8)(a1)								; 6 ; A
		move.w	(a0)+,.a+(6*8)(a1)								; 7 ; C
		move.w	(a0),.a+(7*8)(a1)								; 8 ; E
		rts
; ---------------------------------------------------------------------------

		include "Screens/Special Stage/Object Data/Walls VRAM Pointers.asm"

; ---------------------------------------------------------------------------
; Object code execution subroutine (Special Stage)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Process_SSSprites:

		; player
		lea	(Player_1).w,a0
		move.l	address(a0),d0
		beq.s	.nextslot
		movea.l	d0,a1
		jsr	(a1)

.nextslot

		; tails for Tails
		lea	(Tails_tails).w,a0
		move.l	address(a0),d0
		beq.s	SS_RemoveCollectedItem.return
		movea.l	d0,a1
		jmp	(a1)

; ---------------------------------------------------------------------------
; Subroutine to remove items when you collect them in the Special Stage
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_RemoveCollectedItem:
		lea	(SStage_ItemBuffer).l,a2
		moveq	#bytesToXcnt((SStage_ItemBuffer_end-SStage_ItemBuffer),8),d0			; check $100 bytes

.loop
		tst.b	(a2)
		beq.s	.return
		addq.w	#8,a2										; next
		dbf	d0,.loop

.return
		rts

; ---------------------------------------------------------------------------
; Subroutine to animate Special Stage items when you touch them
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_AniItems:
		lea	(SStage_ItemBuffer).l,a0
		moveq	#bytesToXcnt((SStage_ItemBuffer_end-SStage_ItemBuffer),8),d7			; check $100 bytes

.loop
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	.next
		add.w	d0,d0
		move.w	SS_AniItems_Index-2(pc,d0.w),d0
		jsr	SS_AniItems_Index(pc,d0.w)

.next
		addq.w	#8,a0										; next
		dbf	d7,.loop
		rts
; ---------------------------------------------------------------------------

SS_AniItems_Index: offsetTable
		offsetTableEntry.w SS_AniRingSparks							; 1
		offsetTableEntry.w SS_AniBumper								; 2
		offsetTableEntry.w SS_Ani1Up								; 3 (unused)
		offsetTableEntry.w SS_AniReverse							; 4
		offsetTableEntry.w SS_AniEmeraldSparks							; 5
		offsetTableEntry.w SS_AniGlassBlock							; 6
; ---------------------------------------------------------------------------

SS_AniRingSparks:

		; wait
		subq.b	#1,2(a0)									; decrement timer
		bpl.s	.return										; if time remains, branch
		addq.b	#5+1,2(a0)									; reset timer to 5+1 frames

		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	.anim(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	.return
		clr.l	(a0)
		clr.l	4(a0)

.return
		rts
; ---------------------------------------------------------------------------

.anim													; MapIndex
		dc.b $42
		dc.b $43
		dc.b $44
		dc.b $45
		dc.b 0											; reset
	even
; ---------------------------------------------------------------------------

SS_AniBumper:

		; wait
		subq.b	#1,2(a0)									; decrement timer
		bpl.s	.return										; if time remains, branch
		addq.b	#7+1,2(a0)									; reset timer to 7+1 frames

		; anim
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	.anim(pc,d0.w),d0
		bne.s	.notzero
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$25,(a1)
		rts
; ---------------------------------------------------------------------------

.notzero
		move.b	d0,(a1)

.return
		rts
; ---------------------------------------------------------------------------

.anim													; MapIndex
		dc.b $32
		dc.b $33
		dc.b $32
		dc.b $33
		dc.b 0											; reset
	even
; ---------------------------------------------------------------------------

SS_Ani1Up:

		; wait
		subq.b	#1,2(a0)									; decrement timer
		bpl.s	.return										; if time remains, branch
		addq.b	#5+1,2(a0)									; reset timer to 5+1 frames

		; anim
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	.anim(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	.return
		clr.l	(a0)
		clr.l	4(a0)

.return
		rts
; ---------------------------------------------------------------------------

.anim													; MapIndex
		dc.b $46
		dc.b $47
		dc.b $48
		dc.b $49
		dc.b 0											; reset
	even
; ---------------------------------------------------------------------------

SS_AniReverse:

		; wait
		subq.b	#1,2(a0)									; decrement timer
		bpl.s	.return										; if time remains, branch
		addq.b	#7+1,2(a0)									; reset timer to 7+1 frames

		; anim
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	.anim(pc,d0.w),d0
		bne.s	.notzero
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$2B,(a1)
		rts
; ---------------------------------------------------------------------------

.notzero
		move.b	d0,(a1)

.return
		rts
; ---------------------------------------------------------------------------

.anim													; MapIndex
		dc.b $2B
		dc.b $31
		dc.b $2B
		dc.b $31
		dc.b 0											; reset
	even
; ---------------------------------------------------------------------------

SS_AniEmeraldSparks:

		; wait
		subq.b	#1,2(a0)									; decrement timer
		bpl.s	SS_AniReverse.return								; if time remains, branch
		addq.b	#5+1,2(a0)									; reset timer to 5+1 frames

		; anim
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	.anim(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	SS_AniReverse.return
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#4,(Player_1+routine).w
		sfx	sfx_SSGoal,1									; play Special Stage GOAL sound
; ---------------------------------------------------------------------------

.anim													; MapIndex
		dc.b $46
		dc.b $47
		dc.b $48
		dc.b $49
		dc.b 0											; reset
	even
; ---------------------------------------------------------------------------

SS_AniGlassBlock:

		; wait
		subq.b	#1,2(a0)									; decrement timer
		bpl.s	.return										; if time remains, branch
		addq.b	#1+1,2(a0)									; reset timer to 1+1 frames

		; anim
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	.anim(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	.return
		move.b	4(a0),(a1)
		clr.l	(a0)
		clr.l	4(a0)

.return
		rts
; ---------------------------------------------------------------------------

.anim													; MapIndex
		dc.b $4B
		dc.b $4C
		dc.b $4D
		dc.b $4E
		dc.b $4B
		dc.b $4C
		dc.b $4D
		dc.b $4E
		dc.b 0											; reset
	even

; ---------------------------------------------------------------------------
; Special Stage start locations
; ---------------------------------------------------------------------------

		include "Screens/Special Stage/Start Location/Start Location Array - Special Stages.asm"

; ---------------------------------------------------------------------------
; Subroutine to load Special Stage layout
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_Load:
		moveq	#0,d0
		move.b	(Current_special_stage).w,d0							; load number of last Special Stage entered
		move.b	d0,(Saved_special_stage).w
		addq.b	#1,(Current_special_stage).w
		cmpi.b	#ChaosEmer_Count,(Current_special_stage).w
		blo.s	SS_ChkEmldNum
		clr.b	(Current_special_stage).w							; reset if higher than 6/7

SS_ChkEmldNum:
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all emeralds?
		beq.s	SS_LoadData									; if yes, branch
		moveq	#0,d1
		move.b	(Chaos_emerald_count).w,d1
		subq.b	#1,d1
		blo.s	SS_LoadData
		lea	(Collected_emeralds_array).w,a3							; check which emeralds you have

SS_ChkEmldLoop:
		cmpi.b	#1,(a3,d0.w)
		bne.s	SS_ChkEmldRepeat
		bra.s	SS_Load
; ---------------------------------------------------------------------------

		include "Screens/Special Stage/Layout/Layout Pointers - Special Stages.asm"
; ---------------------------------------------------------------------------

SS_ChkEmldRepeat:
		dbf	d1,SS_ChkEmldLoop

SS_LoadData:
		add.w	d0,d0
		add.w	d0,d0
		lea	SS_StartLoc(pc,d0.w),a1								; load player's start location
		move.w	(a1)+,(Player_1+x_pos).w							; set player's position on x-axis
		move.w	(a1)+,(Player_1+y_pos).w							; set player's position on y-axis

		; load layout
		movea.l	SS_LayoutIndex(pc,d0.w),a0
		lea	(SStage_Buffer2).l,a1
		jsr	(KosPlus_Decomp).w

		; clear items buffer
		clearRAM SStage_Buffer1, SStage_Buffer1_end

		; items
		lea	(SStage_BlockBuffer).l,a1
		lea	(SStage_Buffer2-SStage_BlockBuffer)(a1),a0
		moveq	#$40-1,d1

.nexti

	rept $40/4
		move.l	(a0)+,(a1)+
	endr

		lea	$40(a1),a1									; next
		dbf	d1,.nexti

		; load mapping
		lea	(SStage_Buffer2+8).l,a1
		lea	SS_MapIndex(pc),a0
		moveq	#(SS_MapIndex_end-SS_MapIndex)/6-1,d1						; number of objects

.loadm
		move.l	(a0)+,(a1)+									; address of mappings
		clr.w	(a1)+
		move.b	-4(a0),-1(a1)									; frame
		move.w	(a0)+,(a1)+									; VRAM
		dbf	d1,.loadm

		; find all ghost solids and rings
		lea	(SStage_Ghost_Buffer).l,a1
		lea	(SStage_BlockBuffer-SStage_Ghost_Buffer)(a1),a0
		moveq	#$40-1,d1

.gloop2
		moveq	#$40-1,d2

.gloop
		cmpi.b	#$41,(a0)									; is the item a	ghost block?
		bne.s	.gring										; if not, branch
		move.w	a0,(a1)+									; save address ghost block

.gring
		cmpi.b	#$3A,(a0)									; is the item a	ring?
		bne.s	.notgb										; if not, branch
		addq.w	#1,(Special_stage_rings_left).w							; add ring to counter

.notgb
		addq.w	#1,a0
		dbf	d2,.gloop
		lea	$40(a0),a0
		dbf	d1,.gloop2

		; set ghost solids end flag
		clr.w	(a1)

		; clear items buffer
		clearRAM SStage_ItemBuffer, SStage_ItemBuffer_end
		rts

; =============== S U B R O U T I N E =======================================

PLC_SpecialStage: plrlistheader
		plreq ArtTile_SS_Background_Clouds, ArtKosPM_SSBgCloud
		plreq ArtTile_SS_Background_Fish, ArtKosPM_SSBgFish
		plreq ArtTile_SS_Bumper, ArtKosPM_Bumper
		plreq ArtTile_SS_Goal, ArtKosPM_SSGOAL
		plreq ArtTile_SS_Up_Down, ArtKosPM_SSUpDown
		plreq ArtTile_SS_R_Block, ArtKosPM_SSRBlock
		plreq ArtTile_SS_HUD, ArtKosPM_SSHUD
		plreq ArtTile_SS_Emerald_Sparkle, ArtKosPM_SSEmStars
		plreq ArtTile_SS_Red_White_Block, ArtKosPM_SSRedWhite
		plreq ArtTile_SS_Ghost_Block, ArtKosPM_SSGhost
		plreq ArtTile_SS_Glass, ArtKosPM_SSGlass
		plreq ArtTile_SS_Emerald, ArtKosPM_SSEmerald
		plreq ArtTile_SS_Ring_Sparks, ArtKosPM_Ring_Sparks
PLC_SpecialStage_end

PLC_SpecialStageResults: plrlistheader
		plreq $500, ArtKosPM_ResultsGeneral
		plreq $570, ArtKosPM_SSResults
		plreq $680, ArtKosPM_SSResultsTKIcons
		plreq ArtTile_HUD, ArtKosPM_HUD
PLC_SpecialStageResults_end
; ---------------------------------------------------------------------------

		; animate palette
		include "Screens/Special Stage/Palettes/Animated/Special Stage - Animate Palette.asm"

		; objects
		include "Screens/Special Stage/Player.asm"
		include "Screens/Special Stage/Results.asm"

		; mappings
		include "Screens/Special Stage/Object Data/Special Stage Mappings & VRAM Pointers.asm"
		include "Screens/Special Stage/Object Data/R Block.asm"
		include "Screens/Special Stage/Object Data/Glass Block.asm"
		include "Screens/Special Stage/Object Data/UP Block.asm"
		include "Screens/Special Stage/Object Data/DOWN Block.asm"
		include "Screens/Special Stage/Object Data/Chaos Emeralds.asm"
		include "Screens/Special Stage/Object Data/Walls.asm"
		include "Screens/Special Stage/Object Data/Bumper.asm"
