; ---------------------------------------------------------------------------
; Credits
; ---------------------------------------------------------------------------

; Constants
Credits_Offset:				= *

; Variables

; RAM
	phase ramaddr(Object_load_addr_front)

Credits_routine:			ds.w 1
Credits_process:			ds.l 1
Credits_process_time:			ds.w 1
Credits_end:				ds.b 1

	dephase
	!org	Credits_Offset
; ---------------------------------------------------------------------------

Credits_VDP:
		dc.w $8004										; disable HInt, HV counter, 8-colour mode
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)						; set foreground nametable address
		dc.w $8300+(VRAM_Plane_B_Name_Table>>10)						; set window nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)						; set background nametable address
		dc.w $8700+(0<<4)									; set background colour (line 3; colour 0)
		dc.w $8B00										; full-screen horizontal and vertical scrolling
		dc.w $8C81										; set 40cell screen size, no interlacing, no s/h
		dc.w $9001										; 64x32 cell nametable area
		dc.w $9100										; set window H position at default
		dc.w $9200										; set window V position at default
		dc.w 0											; end marker

; =============== S U B R O U T I N E =======================================

CreditsScreen:
		music	mus_Stop									; stop music
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	Credits_VDP(pc),a1
		jsr	(Load_VDP).w
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_end							; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end						; clear variables
		clearRAM Camera_RAM, Camera_RAM_end							; clear the camera RAM
		clearRAM Oscillating_variables, Oscillating_variables_end				; clear variables

		; clear
		move.b	d0,(Water_full_screen_flag).w
		move.b	d0,(Water_flag).w
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w
		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w

		; load art
		lea	PLC_Credits(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load palette
		lea	(Pal_Credits).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line32).w

.waitplc
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; load text
		move.w	(Credits_routine).w,d0
		addq.w	#2,(Credits_routine).w
		lea	CreditsText_Index(pc),a1
		adda.w	(a1,d0.w),a1
		move.l	#$A0018100,d5									; VRAM shift (font pos in VRAM) ; large and small font
		bsr.w	Credits_LoadText

		; set
		music	mus_S3Credits
		move.w	#3*60,(Credits_process_time).w
		move.l	#Credits_Process_LoadText,(Credits_process).w
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loopt
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w

		; load process
		move.l	(Credits_process).w,a0
		jsr	(a0)

		; check end
		tst.b	(Credits_end).w
		beq.s	.loopt
		clr.b	(Credits_end).w

		; set
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.w	#$7F0,(Camera_Y_pos_mask).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$7F0,(Camera_target_max_Y_pos).w

		; set
		move.l	#Credits_Process_LoadText.return,(Credits_process).w

		; create objects
		jsr	(Create_New_Sprite).w
		bne.s	.fadefrom
		move.l	#Obj_CreditsRobotnik,address(a1)
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.fadefrom
		move.l	#Obj_CreditsEggRobo,address(a1)

.fadefrom
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Pal_FadeFromBlack).w

.loope
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w

		; load process
		move.l	(Credits_process).w,a0
		jsr	(a0)
		jsr	(Process_Sprites).w
		bsr.w	Credits_ScreenShake
		jsr	(Render_Sprites).w
		bra.s	.loope

; =============== S U B R O U T I N E =======================================

Credits_Process_LoadText:

		; check buttons
		move.b	(Ctrl_1_pressed).w,d0
		bmi.s	.skipcredits									; if start was pressed, skip ahead
		andi.b	#btnABC,d0									; are buttons A, B, or C being pressed?
		bne.s	.skipt										; if yes, branch

		; wait
		subq.w	#1,(Credits_process_time).w
		bpl.s	.return

.skipt
		move.w	#3*60,(Credits_process_time).w

		; fade and clear plane
		jsr	(Pal_FadeToBlack).w
		stopZ80
		dmaFillVRAM 0, VRAM_Plane_A_Name_Table, VRAM_Plane_Table_Size				; clear plane A PNT
		startZ80

		; load text
		move.w	(Credits_routine).w,d0
		addq.w	#2,(Credits_routine).w
		lea	CreditsText_Index(pc),a1
		move.w	(a1,d0.w),d0
		beq.s	.loadtextend									; if zero, branch
		adda.w	d0,a1
		move.l	#$A0018100,d5									; VRAM shift (font pos in VRAM) ; large and small font
		bsr.s	Credits_LoadText
		jmp	(Pal_FadeFromBlack).w
; ---------------------------------------------------------------------------

.return
		rts
; ---------------------------------------------------------------------------

.skipcredits

		; fade and clear plane
		jsr	(Pal_FadeToBlack).w
		stopZ80
		dmaFillVRAM 0, VRAM_Plane_A_Name_Table, VRAM_Plane_Table_Size				; clear plane A PNT
		startZ80

.loadtextend
		move.l	#.return,(Credits_process).w
		st	(Credits_end).w

		; load text
		lea	Credits_TextEnd(pc),a1
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all the emeralds?
		beq.s	.loadtext									; if yes, branch
		lea	Credits_TextTryAgain(pc),a1

.loadtext
		move.l	#$80018100,d5									; VRAM shift (font pos in VRAM) ; large and small font
		bsr.s	Credits_LoadText

		; load player palette
		moveq	#PalID_Sonic,d0
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		blo.s	.notKnux									; if not, branch
		moveq	#PalID_Knuckles,d0

.notKnux
		jsr	(LoadPalette).w									; load player's palette
		moveq	#PalID_Ending,d0
		jmp	(LoadPalette).w

; ---------------------------------------------------------------------------
; Load text
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Credits_LoadText:
		disableIntsSave
		lea	(VDP_data_port).l,a6								; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5						; load VDP control address to a5
		move.w	#$8F80,VDP_control_port-VDP_control_port(a5)					; VRAM increment at $80 bytes (vertical write)
		move.l	#vdpCommDelta(planeLoc(64,1,0)),d4						; row increment value

.loop
		move.l	d5,d3
		moveq	#(Credits_DrawSmallText-Credits_DrawSmallText),d0				; small text
		moveq	#0,d1
		move.w	(a1)+,d1									; get plane pos
		beq.s	.exit										; if zero, end queue
		bpl.s	.normal
		andi.w	#$FFF,d1
		moveq	#(Credits_DrawLargeText-Credits_DrawSmallText),d0				; large text
		swap	d3

.normal
		addi.w	#VRAM_Plane_A_Name_Table,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#vdpComm(0,VRAM,WRITE)>>16,d1
		swap	d1
		jsr	Credits_DrawSmallText(pc,d0.w)
		bra.s	.loop
; ---------------------------------------------------------------------------

.exit
		move.w	#$8F02,VDP_control_port-VDP_control_port(a5)					; VRAM increment at 2 bytes (horizontal write)
		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

		; set the character
		save
		codepage CREDITSCREEN2

Credits_DrawSmallText:
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	.exit										; if zero, exit

		; load small letter (8x16)
		cmpi.b	#' ',d0
		bne.s	.calc
		moveq	#0,d0
		bra.s	.setpos
; ---------------------------------------------------------------------------

.calc
		subq.w	#1,d0										; -1
		add.w	d0,d0
		move.w	d0,d2
		addq.w	#1,d2
		swap	d0
		move.w	d2,d0
		move.w	d3,d2										; VRAM shift (font pos in VRAM)
		swap	d2
		move.w	d3,d2
		add.l	d2,d0

.setpos
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d4,d1

		; back
		bra.s	Credits_DrawSmallText
; ---------------------------------------------------------------------------

.exit
		move.l	a1,d0										; load ROM address
		btst	#0,d0										; is this an even address?
		beq.s	.return										; if yes, branch
		addq.w	#1,a1										; skip odd address (even)

.return
		rts

; =============== S U B R O U T I N E =======================================

		; set the character
		codepage CREDITSCREEN

Credits_DrawLargeText:
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	Credits_DrawSmallText.exit							; if zero, exit

		; load large letter
		cmpi.b	#' ',d0
		bne.s	.calc
		moveq	#0,d0
		moveq	#0,d2										; set next tiles
		moveq	#1-1,d6										; 8x24
		bra.s	.setpos
; ---------------------------------------------------------------------------

.calc
		subq.b	#1,d0										; -1
		add.w	d0,d0
		add.w	d0,d0
		movem.w	.letters(pc,d0.w),d0/d6								; get id letter and size
		move.w	d0,d2
		addq.w	#1,d2
		swap	d0
		move.w	d2,d0
		move.w	d3,d2										; VRAM shift (font pos in VRAM)
		swap	d2
		move.w	d3,d2
		add.l	d2,d0
		move.l	#$10001,d2									; set next tiles

.setpos
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d0
		add.l	d2,d0
		add.l	d4,d1
		dbf	d6,.setpos

		; back
		bra.s	Credits_DrawLargeText
; ---------------------------------------------------------------------------

.letters
		dc.w 0, 2-1		; A (16x24)
		dc.w 6, 2-1		; B (16x24)
		dc.w $C, 2-1		; C (16x24)
		dc.w $12, 2-1		; D (16x24)
		dc.w $18, 2-1		; E (16x24)
		dc.w $1E, 2-1		; F (16x24)
		dc.w $24, 2-1		; G (16x24)
		dc.w $2A, 2-1		; H (16x24)
		dc.w $30, 1-1		; I (8x24)
		dc.w $33, 1-1		; J (8x24)
		dc.w $36, 2-1		; K (16x24)
		dc.w $3C, 1-1		; L (8x24)
		dc.w $3F, 3-1		; M (24x24)
		dc.w $48, 2-1		; N (16x24)
		dc.w $4E, 3-1		; O (24x24)
		dc.w $57, 2-1		; P (16x24)
		dc.w $5D, 3-1		; Q (24x24)
		dc.w $66, 2-1		; R (16x24)
		dc.w $6C, 2-1		; S (16x24)
		dc.w $72, 2-1		; T (16x24)
		dc.w $78, 2-1		; U (16x24)
		dc.w $7E, 2-1		; V (16x24)
		dc.w $84, 3-1		; W (24x24)
		dc.w $8D, 2-1		; X (16x24)
		dc.w $93, 2-1		; Y (16x24)
		dc.w $99, 2-1		; Z (16x24)
		dc.w $9F, 1-1		; . (8x24)
		dc.w $A2, 2-1		; ( (16x24)
		dc.w $A8, 2-1		; ) (16x24)
		dc.w $4E, 3-1		; 0 (24x24)
		dc.w $AE, 1-1		; 1 (8x24)
		dc.w $B1, 2-1		; 2 (16x24)
		dc.w $B7, 2-1		; 3 (16x24)
		dc.w $BD, 2-1		; 4 (16x24)
		dc.w $C3, 2-1		; 5 (16x24)
		dc.w $C9, 3-1		; 6 (24x24)
		dc.w $D2, 2-1		; 7 (16x24)
		dc.w $D8, 2-1		; 8 (16x24)
		dc.w $DE, 3-1		; 9 (24x24)
		dc.w $E7, 1-1		; ! (8x24)

		restore	; reset character set

; ---------------------------------------------------------------------------
; Object 8B - Eggman on "TRY AGAIN" and "END" screens (Credits)
; ---------------------------------------------------------------------------

; Dynamic object variables
crdre_timer		= objoff_2E ; (2 bytes)

crdre_drop		= objoff_39 ; (1 byte)

; =============== S U B R O U T I N E =======================================

Obj_CreditsRobotnik:

		; init
		movem.l	ObjDat_CreditsRobotnik(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	#320/2,x_pos(a0)
		move.w	#224/2,y_pos(a0)
		move.w	#(20*60)-1,objoff_2E(a0)

		; END
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all the emeralds?
		beq.s	.defeated									; if yes, branch

		; Try Again
		move.b	#5,anim_frame_timer(a0)
		move.l	#.main,address(a0)
		bsr.w	CreditsRobotnik_LoadEmeralds

.main
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		move.b	#$80,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		st	crdre_drop(a0)

		; next
		move.l	#.wait,address(a0)

.wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		addq.b	#5+1,anim_frame_timer(a0)
		move.l	#.main,address(a0)

		; set frame
		clr.b	mapping_frame(a0)
		bchg	#0,prev_anim(a0)								; prev frame
		bne.s	.draw
		addq.b	#2,mapping_frame(a0)

.draw

		; check
		move.b	(Ctrl_1_pressed).w,d0
		or.b	(Ctrl_2_pressed).w,d0
		bmi.s	.finish										; if start was pressed, skip ahead

		; wait
		subq.w	#1,objoff_2E(a0)
		bmi.s	.finish

		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.defeated

		; animate
		lea	AniRaw_RobotnikEnd(pc),a1
		jsr	(Animate_RawNoSST).w
		cmpi.b	#4,mapping_frame(a0)
		bne.s	.draw
		move.w	#4,(Screen_shaking_flag).w
		bra.s	.draw
; ---------------------------------------------------------------------------

.finish
		move.b	#GameModeID_SegaScreen,(Game_mode).w						; set screen mode to Sega
		addq.w	#4*2,sp										; exit from object and current screen
		rts
; ---------------------------------------------------------------------------

AniRaw_RobotnikEnd:	dc.b 7, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, arfEnd
	even

; ---------------------------------------------------------------------------
; Robotnik load emeralds (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CreditsRobotnik_LoadEmeralds:

		; get RAM slot
		getobjectRAMslot a3
		bmi.s	.return										; branch, if object RAM slots ended

		; load emeralds
		movea.w	a0,a1										; load current object to a1
		lea	(Collected_emeralds_array).w,a2
		moveq	#0,d1
		moveq	#0,d2
		moveq	#ChaosEmer_Count-1,d6

.loop
		tst.b	(a2)+
		bne.s	.next

		; create emerald object

.find
		lea	next_object(a1),a1								; goto next object RAM slot
		tst.l	address(a1)									; is object RAM slot empty?
		dbeq	d0,.find									; if not, branch
		bne.s	.return										; branch, if object RAM slot is not empty
		subq.w	#1,d0										; dbeq didn't subtract sprite table so we'll do it ourselves

		; load object
		move.l	#Obj_CreditsRobotnik_Emeralds,address(a1)
		move.w	a0,parent3(a1)									; save Robotnik address to emeralds
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d1,mapping_frame(a1)
		move.b	d2,subtype(a1)
		addq.b	#2,d2

.next
		addq.b	#1,d1										; next emerald frame
		tst.w	d0										; object RAM slots ended?
		dbmi	d6,.loop									; if not, loop

.return
		rts

; ---------------------------------------------------------------------------
; Object 8C - chaos emeralds on the "TRY AGAIN" screen (Credits)
; ---------------------------------------------------------------------------

; Dynamic object variables
credre_timer		= objoff_2E ; (2 bytes)
credre_origX		= objoff_32 ; original x-axis position (2 bytes)
credre_origY		= objoff_30 ; original y-axis position (2 bytes)
credre_btimer		= objoff_34 ; (2 bytes)
credre_last		= objoff_39 ; (1 byte)
credre_radius		= objoff_3A ; radius of circle (2 bytes)
credre_speed		= objoff_40 ; speed (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_CreditsRobotnik_Emeralds:

		; set wait
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1										; multiply by $0A
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,credre_timer(a0)
		move.w	d0,credre_btimer(a0)

		; init
		movem.l	ObjDat_CreditsRobotnik_Emeralds(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	x_pos(a0),credre_origX(a0)
		moveq	#-12,d0
		add.w	y_pos(a0),d0
		move.w	d0,credre_origY(a0)
		move.b	#$80,angle(a0)
		move.b	#28,credre_radius(a0)

.main

		; check flag
		movea.w	parent3(a0),a1									; load Robotnik address
		tst.b	crdre_drop(a1)
		beq.s	.circular
		move.l	#.move,address(a0)

		; set move
		moveq	#2,d0
		btst	#0,prev_anim(a1)								; check Robotnik prev frame
		beq.s	.mset
		neg.w	d0

.mset
		move.b	d0,credre_speed(a0)
		asl.w	#3,d0
		add.b	d0,angle(a0)

.move
		tst.w	credre_timer(a0)
		beq.s	.aradius
		subq.w	#1,credre_timer(a0)
		bne.s	.cangle

.aradius
		move.b	credre_speed(a0),d0
		add.b	d0,angle(a0)

.cangle
		move.b	angle(a0),d0
		beq.s	.clrs										; branch, if it's right side
		cmpi.b	#$80,d0										; is it left side?
		bne.s	.circular									; if not, branch

.clrs
		clr.b	credre_speed(a0)
		move.w	credre_btimer(a0),credre_timer(a0)
		move.l	#.main,address(a0)

		; check
		tst.b	subtype(a0)									; is first emerald?
		bne.s	.circular									; if not, branch

		; clear flag
		movea.w	parent3(a0),a1									; load Robotnik address
		clr.b	crdre_drop(a1)

.circular
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	credre_radius(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	credre_origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)									; move object circularly
		move.w	credre_origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo:

		; init
		movem.l	ObjDat_CreditsEggRobo(pc),d0-d3							; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	#320/2,x_pos(a0)
		move.w	#(224/2),y_pos(a0)

		; Try Again
		move.l	#AniRaw_CreditsEggRoboEnd,objoff_30(a0)
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all the emeralds?
		bne.s	.createemrl									; if not, branch

		; END
		move.l	#AniRaw_CreditsEggRobo,objoff_30(a0)
		move.w	#(224/2)+32,y_pos(a0)
		move.l	#.wait,address(a0)
		lea	Child1_CreditsEggRobo_Misc(pc),a2
		jsr	(CreateChild1_Normal).w

.wait
		btst	#2,objoff_38(a0)
		beq.s	.draw
		move.w	#$1F,objoff_2E(a0)
		move.l	#.rise,address(a0)

.rise
		subq.w	#1,y_pos(a0)
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.l	#.animate,address(a0)

.riseskip
		move.w	#(20*60)-1,objoff_2E(a0)

.animate
		jsr	(Animate_Raw).w

		; check
		move.b	(Ctrl_1_pressed).w,d0
		or.b	(Ctrl_2_pressed).w,d0
		bmi.s	.finish										; if start was pressed, skip ahead

		; wait
		subq.w	#1,objoff_2E(a0)
		bmi.s	.finish

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.finish
		move.b	#GameModeID_SegaScreen,(Game_mode).w						; set screen mode to Sega
		addq.w	#4*2,sp										; exit from object and current screen
		rts
; ---------------------------------------------------------------------------

.createemrl

		; load eyes
		lea	Child1_CreditsEggRobo_Eyes(pc),a2
		jsr	(CreateChild1_Normal).w

		; load emeralds
		bsr.s	CreditsEggRobo_LoadEmeralds
		bra.s	.riseskip
; ---------------------------------------------------------------------------

AniRaw_CreditsEggRobo:		dc.b $B, 0, 1, arfEnd
AniRaw_CreditsEggRoboEnd:	dc.b $13, 0, 1, arfEnd
	even

; ---------------------------------------------------------------------------
; Egg Robo load emeralds (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CreditsEggRobo_LoadEmeralds:

		; get RAM slot
		getobjectRAMslot a3
		bmi.s	.return										; branch, if object RAM slots ended

		; calc pos
		moveq	#ChaosEmer_Count,d6								; max emeralds
		sub.b	(Chaos_emerald_count).w,d6
		blo.s	.return
		move.l	#256,d4										; 360 degrees = 256
		divu.w	d6,d4

		; load emeralds
		movea.w	a0,a1										; load current object to a1
		lea	(Collected_emeralds_array).w,a2
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#ChaosEmer_Count-1,d6

.loop
		tst.b	(a2)+
		bne.s	.next

		; create emerald object

.find
		lea	next_object(a1),a1								; goto next object RAM slot
		tst.l	address(a1)									; is object RAM slot empty?
		dbeq	d0,.find									; if not, branch
		bne.s	.return										; branch, if object RAM slot is not empty
		subq.w	#1,d0										; dbeq didn't subtract sprite table so we'll do it ourselves

		; load object
		move.l	#Obj_CreditsEggRobo_Emeralds,address(a1)
		move.w	a0,parent3(a1)									; save Egg Robo address to emeralds
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d1,mapping_frame(a1)
		move.b	d2,subtype(a1)
		addq.b	#2,d2
		move.b	d3,angle(a1)
		add.b	d4,d3

.next
		addq.b	#1,d1										; next emerald frame
		tst.w	d0										; object RAM slots ended?
		dbmi	d6,.loop									; if not, loop

.return
		rts

; ---------------------------------------------------------------------------
; Egg Robo emeralds (Credits)
; ---------------------------------------------------------------------------

; Dynamic object variables
cere_timer		= objoff_2E ; (2 bytes)
cere_origX		= objoff_32 ; original x-axis position (2 bytes)
cere_origY		= objoff_30 ; original y-axis position (2 bytes)

cere_radius		= objoff_3A ; radius of circle (2 bytes)
cere_speed		= objoff_40 ; speed (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo_Emeralds:

		; init
		movem.l	ObjDat_CreditsEggRobo_Emeralds(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	x_pos(a0),cere_origX(a0)
		moveq	#-72,d0
		add.w	y_pos(a0),d0
		move.w	d0,credre_origY(a0)
		move.b	#24,cere_radius(a0)

.circular
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		jsr	(GetSineCosine).w
		move.w	cere_radius(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	cere_origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)									; move object circularly
		move.w	cere_origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo scrap metal (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo_ScrapMetal:

		; init
		movem.l	ObjDat_CreditsEggRobo_ScrapMetal(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.b	#4,mapping_frame(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo eyes (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo_Eyes:

		; init
		movem.l	ObjDat_CreditsEggRobo_Eyes(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.b	#2,mapping_frame(a0)
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w					; do you have all the emeralds?
		bne.s	.setframe									; if not, branch
		move.w	#(2*60)-1,objoff_2E(a0)
		move.l	#.main,address(a0)

.main
		subq.w	#1,objoff_2E(a0)
		bpl.s	.return
		move.l	#.animate,address(a0)
		move.l	#.setf,objoff_34(a0)

.return
		rts
; ---------------------------------------------------------------------------

.animate
		lea	AniRaw_CreditsEggRobo_Eyes(pc),a1
		jsr	(Animate_RawNoSSTMultiDelay).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.setf
		move.l	#.refresh,address(a0)
		movea.w	parent3(a0),a1									; a1=parent object
		bset	#2,objoff_38(a1)
		rts
; ---------------------------------------------------------------------------

.setframe
		move.b	#3,mapping_frame(a0)

.refresh
		moveq	#-20,d0
		movea.w	parent3(a0),a1									; a1=parent object
		tst.b	mapping_frame(a1)
		beq.s	.refreshs
		addq.b	#1,d0

.refreshs
		move.b	d0,child_dy(a0)
		jsr	(Refresh_ChildPosition.skipp).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Child1_CreditsEggRobo_Misc:
		dc.w 2-1
		dc.l Obj_CreditsEggRobo_ScrapMetal
		dc.b 0, -16
		dc.l Obj_CreditsEggRobo_Eyes
		dc.b 0, -20
Child1_CreditsEggRobo_Eyes:
		dc.w 1-1
		dc.l Obj_CreditsEggRobo_Eyes
		dc.b 0, -20

AniRaw_CreditsEggRobo_Eyes:
		dc.b 2, 0	; frame, wait
		dc.b 2, 1
		dc.b 6, $F
		dc.b 2, 1
		dc.b 6, 7
		dc.b 2, 1
		dc.b 6, 3
		dc.b 2, 1
		dc.b 6, 1
		dc.b 2, 1
		dc.b 6, 1
		dc.b 2, $13
		dc.b 3, $3F
		dc.b arfJump
	even

; ---------------------------------------------------------------------------
; Shake (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Credits_ScreenShake:
		tst.w	(Screen_shaking_flag).w
		beq.s	.return										; if timer has run out, don't do anything
		subq.w	#1,(Screen_shaking_flag).w

		; start shake
		moveq	#$3F,d0
		and.w	(Level_frame_counter).w,d0
		lea	(ScreenShakeArray2).w,a1
		move.b	(a1,d0.w),d1
		ext.w	d1
		move.w	d1,(Camera_Y_pos_copy).w
		neg.w	d1
		move.w	d1,(V_scroll_value_FG).w

.return
		rts

; =============== S U B R O U T I N E =======================================

		; text
		include "Screens/Credits/Text Data/Text.asm"

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_CreditsRobotnik:			subObjMainData Obj_CreditsRobotnik.defeated, setBit(render_flags.level), 0, 64, 56, 3, $182, 0, 0, Map_CreditsRobotnik
ObjDat_CreditsRobotnik_Emeralds:	subObjMainData Obj_CreditsRobotnik_Emeralds.main, setBit(render_flags.level), 0, 16, 16, 1, $2D3, 0, 0, Map_ECha
ObjDat_CreditsEggRobo:			subObjMainData Obj_CreditsEggRobo.animate, setBit(render_flags.level), 0, 64, 56, 5, $232, 0, 0, Map_CreditsEggRobo
ObjDat_CreditsEggRobo_Emeralds:		subObjMainData Obj_CreditsEggRobo_Emeralds.circular, setBit(render_flags.level), 0, 16, 16, 1, $2D3, 0, 0, Map_ECha
ObjDat_CreditsEggRobo_ScrapMetal:	subObjMainData Draw_Sprite, setBit(render_flags.level), 0, 64, 112, 4, $232, 0, 0, Map_CreditsEggRobo
ObjDat_CreditsEggRobo_Eyes:		subObjMainData Obj_CreditsEggRobo_Eyes.refresh, setBit(render_flags.level), 0, 16, 16, 3, $232, 0, 0, Map_CreditsEggRobo

PLC_Credits: plrlistheader
		plreq 1, ArtKosPM_LargeTextCredits
		plreq $100, ArtKosPM_SmallTextCredits
		plreq $182, ArtKosPM_RobotnikCredits
		plreq $232, ArtKosPM_EggRoboCredits
		plreq $2D3, ArtKosPM_EmeraldsEnding
PLC_Credits_end
; ---------------------------------------------------------------------------

		include "Screens/Credits/Object Data/Map - Robotnik.asm"
		include "Screens/Credits/Object Data/Map - Egg Robo.asm"
