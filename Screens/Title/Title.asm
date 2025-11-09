; ---------------------------------------------------------------------------
; Title
; ---------------------------------------------------------------------------

; Constants
Title_Offset:				= *

; RAM
	phase ramaddr(Boss_events)

Title_cheat_counter:			ds.b 1
Title_control:				ds.b 1
Title_end:				ds.b 1

	dephase
	!org	Title_Offset

; =============== S U B R O U T I N E =======================================

TitleScreen:
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
		move.b	d0,(HUD_RAM.status).w
		move.b	d0,(Extra_life_flags).w								; reset extra life ring flag
		move.b	d0,(Update_HUD_timer).w								; clear time counter update flag
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Apparent_zone_and_act).w
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w
		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w
		move.b	d0,(SBZ2_player_roll).w

		; load level
		lea	LevelLoadPointer_Title(pc),a2
		jsr	(LoadLevelPointer.load).w

		; load text art
		lea	(ArtKosPM_TitleText).l,a1
		tst.b	(Japan_credits_flag).w								; check cheat
		beq.s	.notcheat

		; load mapping
		EniDecomp	MapEni_TitleCredits, RAM_start, $540, 0, TRUE				; decompress Enigma mappings
		copyTilemap	VRAM_Plane_B_Name_Table, 320, 224

		; load credits text art
		lea	(ArtKosPM_TitleCredits).l,a1

.notcheat
		move.w	#tiles_to_bytes($540),d2
		jsr	(Queue_KosPlus_Module).w

		; load text palette
		lea	(Target_palette_line_1+4).w,a1
		move.l	#words_to_long($822,$A44),(a1)+
		move.l	#words_to_long($C66,$E88),(a1)+
		move.w	#cWhite,(a1)

		; set
		move.l	#VInt_Fade,(V_int_ptr).w							; set VInt pointer

.waitplc
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; check cheat
		tst.b	(Japan_credits_flag).w
		bne.s	.skiptext

		; create
		lea	(Reserved_object_3).w,a1							; load "SONIC TEAM PRESENTS" object
		move.l	#Draw_Sprite,address(a1)
		move.l	#Map_TText,mappings(a1)
		move.w	#make_art_tile($540,0,FALSE),art_tile(a1)
		move.w	#$120,x_pos(a1)
		move.w	#$F0,y_pos(a1)

.skiptext

		; set wait
		move.w	#1*60,(Demo_timer).w								; set to wait for 1 seconds

		; load main art
		lea	PLC_Title(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; fade from
		move.l	#VInt_Menu,(V_int_ptr).w							; set VInt pointer
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.tloop
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.tloop										; wait for KosPlusM queue to clear
		tst.b	(Ctrl_1_pressed).w								; is Start pressed?
		bmi.s	.tnext										; if yes, branch
		tst.w	(Demo_timer).w
		bne.s	.tloop

.tnext
		jsr	(Pal_FadeToBlack).w
		disableInts
		disableScreen

		; check cheat
		tst.b	(Japan_credits_flag).w
		bne.s	.skiptext2

		; delete
		lea	(Reserved_object_3).w,a1							; remove "SONIC TEAM PRESENTS" object
		jsr	(Delete_Referenced_Sprite).w

.skiptext2

		; load mapping
		EniDecomp	MapEni_TitleFG, RAM_start, $200, 0, FALSE				; decompress Enigma mappings
		copyTilemap	(VRAM_Plane_A_Name_Table+$208), 272, 176

		; load ©1991 text
		lea	Title_CopyrightText(pc),a1
		locVRAM	(VRAM_Plane_A_Name_Table+$D38),d1
		move.w	#$250F,d3
		jsr	(Load_PlaneText).w

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

		; set
		move.l	#Obj_TitleSonic,(Player_2+address).w						; load big Sonic object
		move.l	#Obj_TitlePSB,(Reserved_object_3+address).w					; load "PRESS START BUTTON" object

		; check console region
		tst.b	(Graphics_flags).w
		bpl.s	.skipTM										; remove the TM from the title logo if on a japan console

		; create "TM" object
		lea	(Breathing_bubbles+address).w,a1
		move.l	#Map_TTM,mappings(a1)
		move.b	#setBit(render_flags.static_mappings),render_flags(a1)				; set static mapping
		move.w	#$178,x_pos(a1)
		move.w	#$F8,y_pos(a1)
		move.l	#Draw_Sprite,address(a1)

.skipTM
		music	mus_Title
		move.w	#(9*60)+16,(Demo_timer).w							; set to wait for 9 seconds

		; next
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

		; set
		move.l	#VInt_Level,(V_int_ptr).w							; set VInt pointer

.loop
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Process_Sprites).w

		; move background
		move.w	(Player_1+x_pos).w,d0
		addq.w	#2,d0
		move.w	d0,(Player_1+x_pos).w								; move Sonic to the right
		cmpi.w	#$1C00,d0									; has Sonic object passed $1C00 on x-axis?
		bhs.w	.demo										; if yes, branch

		; check exit
		tst.w	(Demo_timer).w
		beq.w	.demo
		tst.b	(Title_end).w
		beq.s	.notexit
		tst.b	(Ctrl_1_pressed).w								; is Start pressed?
		bmi.s	.exit										; if yes, branch

.notexit
		bsr.w	Title_Code
		jsr	(DeformBgLayer).w
		jsr	(Screen_Events).w
		jsr	(Animate_Palette).w
		jsr	(Process_KosPlus_Module_Queue).w
		jsr	(Render_Sprites).w
		bra.s	.loop
; ---------------------------------------------------------------------------

.exit
		tst.b	(Title_control).w
		bne.s	.options

		; set
		move.w	(Player_option).w,(Player_mode).w						; move selected character to active character
		move.b	(Game_mode).w,(Game_mode_last).w						; save current Game mode
		move.b	#3,(Life_count).w
		move.l	#5000,(Next_extra_life_score).w

		; clear
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		move.b	d0,(Continue_count).w
		move.b	d0,(Current_special_stage).w
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Apparent_zone_and_act).w
		move.b	d0,(Current_special_stage).w

		; clear emeralds RAM
		lea	(Collected_emeralds_array).w,a1
		clr.l	(a1)+
		clr.l	(a1)+

		; load
		move.b	#GameModeID_LevelScreen,(Game_mode).w						; set screen mode to Level

	if LevelSelectCheat
		ifndef __DEBUG__
			; check cheat
			tst.b	(Level_select_flag).w							; check if level select code is on
			beq.s	.return									; if not, play level
		endif
	endif

		moveq	#btnDir+btnABC,d0								; don't check Start
		and.b	(Ctrl_1_held).w,d0
		cmpi.b	#btnAC,d0									; is button A and C held?
		beq.s	.levelselect									; if yes, branch
		btst	#button_A,d0									; is A button held?
		beq.s	.return										; if not, branch

	if LevelSelectVer
		move.b	#GameModeID_LevelSelectRSDKScreen,(Game_mode).w					; set screen mode to Level Select RSDK
		rts
	else
		; load original Level Select
		bra.w	TitleLevelSelectScreen
	endif

; ---------------------------------------------------------------------------

.levelselect
		move.b	#GameModeID_LevelSelectScreen,(Game_mode).w					; set screen mode to Level Select

.return
		rts
; ---------------------------------------------------------------------------

.options
		move.b	#GameModeID_OptionsScreen,(Game_mode).w						; set screen mode to Options
		rts
; ---------------------------------------------------------------------------

.demo

		; set
		st	(Demo_mode_flag).w								; enable demo mode
		move.w	(Player_option).w,(Player_mode).w						; move selected character to active character
		move.b	#3,(Life_count).w								; set life count
		move.l	#5000,(Next_extra_life_score).w

		; clear
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		move.b	d0,(Continue_count).w

		; get demo
		move.w	(Next_demo_number).w,d0								; get index of current demo to run
		move.w	d0,(Demo_number).w
		andi.w	#3,d0
		add.w	d0,d0
		move.w	DemoLevels(pc,d0.w),d0
		move.w	d0,(Current_zone_and_act).w							; load level index to the appropriate variables
		move.w	d0,(Apparent_zone_and_act).w
		move.w	d0,(Saved_zone_and_act).w

		; load demo
		move.w	(Next_demo_number).w,d1
		addq.w	#1,d1
		cmpi.w	#(DemoLevels_end-DemoLevels)/2,d1
		blo.s	.dnotreset
		moveq	#0,d1

.dnotreset
		move.w	d1,(Next_demo_number).w
		tst.w	d0
		bpl.s	.demolevel									; branch if we are indeed playing a level

		; load special stage
		move.b	#GameModeID_SpecialStageScreen,(Game_mode).w					; set screen mode to Special Stage
		clr.b	(Current_special_stage).w

		; clear emeralds RAM
		lea	(Collected_emeralds_array).w,a1
		clr.l	(a1)+
		clr.l	(a1)+
		rts
; ---------------------------------------------------------------------------

.demolevel
		move.b	#GameModeID_DemoScreen,(Game_mode).w						; set screen mode to Demo
		rts
; ---------------------------------------------------------------------------

DemoLevels:
		dc.w bytes_to_word(LevelID_GHZ,0)	; Green Hill Zone Act 1
		dc.w bytes_to_word(LevelID_MZ,0)	; Marble Zone Act 1
		dc.w bytes_to_word(LevelID_SYZ,0)	; Spring Yard Zone Act 1
		dc.w -1					; Special Stage 1
DemoLevels_end

; ---------------------------------------------------------------------------
; Object 0E - Sonic on the title screen
; ---------------------------------------------------------------------------

; Dynamic object variables
ts_timer		= objoff_2E	; .w

; =============== S U B R O U T I N E =======================================

Obj_TitleSonic:

		; init
		move.l	#Map_TSon,mappings(a0)

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_2, \
			make_art_tile($300,1,FALSE) \
		),priority(a0)

		st	objoff_3A(a0)									; reset DPLC frame
		move.w	#$80+120,x_pos(a0)
		move.w	#$80+94,y_pos(a0)								; position is fixed to screen
		move.w	#30-1,objoff_2E(a0)								; set time delay to 0.5 seconds
		move.l	#.wait,address(a0)

		; create sprite mask
		jsr	(Create_New_Sprite).w
		bne.s	.wait
		move.l	#Obj_SpriteMask2,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	#$80+144,y_pos(a1)

		; height/frame, bit 3(parent flag) + priority
		move.b	#( \
			$A0 + \
				setBit(3) + \
			1 \
		),subtype(a1)

		move.w	a0,parent3(a1)									; save parent

.wait
		subq.w	#1,objoff_2E(a0)								; subtract 1 from time delay
		bpl.s	.return										; if time remains, branch
		move.l	#.move,address(a0)

.return
		rts
; ---------------------------------------------------------------------------

.move
		subq.w	#8,y_pos(a0)									; move Sonic up
		cmpi.w	#$80+22,y_pos(a0)								; has Sonic reached final position?
		bne.s	.dplc										; if not, branch
		move.l	#.anim,address(a0)

.anim
		lea	Ani_TSon(pc),a1
		jsr	(Animate_Sprite).w

.dplc
		lea	PLCPtr_TSon(pc),a2
		jsr	(Perform_DPLC).w

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" from title screen
; ---------------------------------------------------------------------------

; Dynamic object variables
tpsb_timer		= objoff_2E	; .w

tpsb_counter		= objoff_3E	; .w

; =============== S U B R O U T I N E =======================================

Obj_TitlePSB:

		; init
		move.l	#Map_TPSB,mappings(a0)
		move.w	#make_art_tile($200,0,FALSE),art_tile(a0)
		move.w	#$D8,x_pos(a0)
		move.w	#$130,y_pos(a0)
		move.w	#(1<<5)-1,tpsb_timer(a0)							; set wait
		move.l	#.main,address(a0)

.main
		subq.w	#1,tpsb_timer(a0)								; wait
		bpl.s	.anim
		move.l	#.cstart,address(a0)

.cstart
		bclr	#button_start,(Ctrl_1_pressed).w						; is Start pressed? ; clear Start button so we don't exit the title screen early
		bne.s	.soptions									; if yes, branch

.anim
		addq.w	#1,tpsb_counter(a0)								; alternative for "Level_frame_counter"
		btst	#5,tpsb_counter+1(a0)
		beq.s	.return

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.return
		rts
; ---------------------------------------------------------------------------

.soptions

		; fix options xpos
		moveq	#4+8,d0										; set FG line pos
		lea	(H_scroll_buffer+(192*4)).w,a1

	rept 7
		move.w	d0,(a1)										; set FG line pos
		addq.w	#4,a1										; next FG line
	endr

		; last FG line
		move.w	d0,(a1)										; set FG line pos

		; next
		sfx	sfx_StarPost
		move.w	#(1<<4)-1,tpsb_timer(a0)							; set wait
		move.l	#.woptions,address(a0)
		bra.s	.options2
; ---------------------------------------------------------------------------

.woptions
		subq.w	#1,tpsb_timer(a0)								; wait
		bpl.s	.return
		move.l	#.options,address(a0)
		st	(Title_end).w									; set exit flag from current screen

.options
		moveq	#btnUD,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return
		not.b	(Title_control).w								; 0 or -1
		sfx	sfx_Switch

.options2
		move.w	#(9*60)+16,(Demo_timer).w							; set to wait for 9 seconds

		; draw icon
		moveq	#1,d0
		and.b	(Title_control).w,d0
		locVRAM	(VRAM_Plane_A_Name_Table+$C1A),d1
		move.l	#vdpCommDelta(planeLoc(64,1,2)),d2
		tst.w	(Current_zone_and_act).w
		beq.s	.drawicon
		move.l	#vdpCommDelta(planeLoc(64,0,2)),d2

.drawicon
		moveq	#2-1,d6
		bsr.s	Title_DrawVIcon

		; draw text
		lea	Title_StartGameText(pc),a1
		tst.b	(Title_control).w
		beq.s	.skip
		lea	Title_StartGameText2(pc),a1

.skip
		tst.w	(Current_zone_and_act).w
		beq.s	.drawtext

		; draw text
		lea	Title_ContinueText(pc),a1
		tst.b	(Title_control).w
		beq.s	.drawtext
		lea	Title_ContinueText2(pc),a1

.drawtext
		locVRAM	(VRAM_Plane_A_Name_Table+$B1E),d1
		move.w	#$50F,d3
		jmp	(Load_PlaneText).w

; ---------------------------------------------------------------------------
; Draw icon
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Title_DrawVIcon:
		disableIntsSave
		lea	(VDP_data_port).l,a6								; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5						; load VDP control address to a5

.next
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		moveq	#0,d3										; space
		cmp.w	d0,d6
		bne.s	.skip
		move.l	#$053B053C,d3									; icon

.skip
		move.l	d3,VDP_data_port-VDP_data_port(a6)
		sub.l	d2,d1
		dbf	d6,.next

		; exit
		enableIntsSave
		rts

; ---------------------------------------------------------------------------
; Level Select code
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Title_Code:
		moveq	#btnDir+btnABC,d0
		and.b	(Ctrl_1_pressed).w,d0
		beq.s	.return
		lea	(Title_cheat_counter).w,a2
		moveq	#0,d0
		move.b	(a2),d0
		lea	.codedat(pc,d0.w),a1
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1)+,d0
		bne.s	.fail
		addq.b	#1,(a2)
		tst.b	(a1)
		bne.s	.return
		st	(Level_select_flag).w
		sfx	sfx_RingRight									; play ring sound

.fail
		clr.b	(a2)

.return
		rts
; ---------------------------------------------------------------------------

.codedat	dc.b btnUp, btnDn, btnL, btnR								; buttons
		dc.b 0											; stop
	even

; =============== S U B R O U T I N E =======================================

; dplc
PLCPtr_TSon:	DPLCEntry ArtUnc_TitleSonic, DPLC_TSon

; ---------------------------------------------------------------------------
; Title pointer data
; ---------------------------------------------------------------------------

		include "Levels/GHZ/Pointers/Title - Pointers.asm"

; ---------------------------------------------------------------------------

PLC_Title: plrlistheader
		plreq 0, GHZ_8x8_KosPM
		plreq $200, ArtKosPM_TitleFG
		plreq $510, ArtKosPM_OptionsText
PLC_Title_end
; ---------------------------------------------------------------------------

		; set the character
		save
		codepage OPTIONSCREEN

Title_StartGameText:
		dc.b "Start Game"
		dc.b $81, $F3		; next line, select palette line
		dc.b "Options",-1
Title_StartGameText2:
		dc.b $F3		; select palette line
		dc.b "Start Game"
		dc.b $81, $F2		; next line, select palette line
		dc.b "Options",-1
Title_ContinueText:
		dc.b " Continue"
		dc.b $81, $F3		; next line, select palette line
		dc.b "Options",-1
Title_ContinueText2:
		dc.b $F3		; select palette line
		dc.b " Continue"
		dc.b $81, $F2		; next line, select palette line
		dc.b "Options",-1
Title_CopyrightText:
		dc.b "@ 1991 SEGA",-1
	even

		restore	; reset character set

; ---------------------------------------------------------------------------

		; mappings
		include "Screens/Title/Object Data/Anim - Sonic.asm"
		include "Screens/Title/Object Data/Map - Text.asm"
		include "Screens/Title/Object Data/Map - Sonic.asm"
		include "Screens/Title/Object Data/DPLC - Sonic.asm"
		include "Screens/Title/Object Data/Map - Press Start.asm"
		include "Screens/Title/Object Data/Map - TM.asm"
