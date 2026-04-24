; ---------------------------------------------------------------------------
; Credits
; ---------------------------------------------------------------------------

; RAM

	dsset ramaddr(Object_load_addr_front)						; pretend we're in the RAM

Credits.routine						ds.w 1
Credits.process						ds.l 1
Credits.process_time					ds.w 1
Credits.end						ds.b 1

	dsreset										; stop pretending and reset the program counter

; ---------------------------------------------------------------------------

Credits_VDP:
		dc.w $8004								; disable HInt, HV counter, 8-color mode
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)				; set foreground nametable address
		dc.w $8300+(VRAM_Plane_B_Name_Table>>10)				; set window nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)				; set background nametable address
		dc.w $8700+(0<<4)							; set background color (line 3; color 0)
		dc.w $8B00								; full-screen horizontal and vertical scrolling
		dc.w $8C81								; set 40cell screen size, no interlacing, no s/h
		dc.w $9001								; 64x32 cell nametable area
		dc.w $9100								; set window H position at default
		dc.w $9200								; set window V position at default
		dc.w 0									; end marker

; =============== S U B R O U T I N E =======================================

CreditsScreen:
		music	mus_Stop							; stop music
		jsr	(Clear_KosPlus_Module_Queue).w					; clear KosPlusM PLCs
		ResetDMAQueue								; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableDisplay
		jsr	(Clear_DisplayData).w
		lea	Credits_VDP(pc),a1
		jsr	(Load_VDP).w
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_end					; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end				; clear variables
		clearRAM Camera_RAM, Camera_RAM_end					; clear the camera RAM
		clearRAM Oscillating_variables, Oscillating_variables_end		; clear variables

		; clear
		move.b	d0,(Water_full_screen_flag).w
		move.b	d0,(Water_flag).w
		move.b	d0,(HUD_RAM.status).w
		move.b	d0,(Extra_life_flags).w						; reset extra life ring flag
		move.b	d0,(Update_HUD_timer).w						; clear time counter update flag
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w
		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w

		; load art
		lea	PLC_Credits(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

.artsize	:= (ArtUnc_TitleCardLargeText_end-ArtUnc_TitleCardLargeText)&$FFFF

		; load text art
		QueueStaticDMA ArtUnc_TitleCardLargeText,.artsize,tiles_to_bytes(1)

		; load palette
		lea	(Pal_Credits).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line32).w

		; set
		move.l	#VInt_Fade,(V_int_ptr).w					; set VInt pointer

.waitplc
		st	(V_int_flag).w							; set VInt flag
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync.skip).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc							; wait for KosPlusM queue to clear

		; load text
		move.w	(Credits.routine).w,d0
		addq.w	#2,(Credits.routine).w
		lea	CreditsText_Index(pc),a1
		adda.w	(a1,d0.w),a1
		move.l	#$A0018100,d5							; VRAM shift (font pos in VRAM) ; large and small font
		bsr.w	Credits_LoadText

		; set
		music	mus_S3Credits
		move.w	#3*60,(Credits.process_time).w
		move.l	#Credits_Process_LoadText,(Credits.process).w
		move.l	#VInt_Main,(V_int_ptr).w					; set VInt pointer
		jsr	(Wait_VSync).w
		enableDisplay
		jsr	(Pal_FadeFromBlack).w

.loopt
		jsr	(Wait_VSync).w

		; load process
		movea.l	(Credits.process).w,a0
		jsr	(a0)

		; check end
		tst.b	(Credits.end).w
		beq.s	.loopt
		clr.b	(Credits.end).w

		; set
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.w	#$7F0,(Camera_Y_pos_mask).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$7F0,(Camera_target_max_Y_pos).w

		; set
		move.l	#Credits_Process_LoadText.return,(Credits.process).w

		; create objects
		jsr	(Create_New_Object).w
		bne.s	.fadefrom
		move.l	#Obj_CreditsRobotnik,code_addr(a1)
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.fadefrom
		move.l	#Obj_CreditsEggRobo,code_addr(a1)

.fadefrom
		jsr	(Process_Objects).w
		jsr	(Render_Sprites).w
		jsr	(Pal_FadeFromBlack).w

.loope
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w

		; load process
		movea.l	(Credits.process).w,a0
		jsr	(a0)
		jsr	(Process_Objects).w
		bsr.w	Credits_ScreenShake
		jsr	(Render_Sprites).w
		bra.s	.loope

; =============== S U B R O U T I N E =======================================

Credits_Process_LoadText:

		; check buttons
		move.b	(Ctrl_1_pressed).w,d0
		bmi.s	.skipcredits							; if start was pressed, skip ahead
		andi.b	#btnABC,d0							; are buttons A, B, or C being pressed?
		bne.s	.skipt								; if yes, branch

		; wait
		subq.w	#1,(Credits.process_time).w
		bpl.s	.return

.skipt
		move.w	#3*60,(Credits.process_time).w

		; fade and clear plane
		jsr	(Pal_FadeToBlack).w
		stopZ80
		dmaFillVRAM 0, VRAM_Plane_A_Name_Table, VRAM_Plane_Table_Size		; clear plane A PNT
		startZ80

		; load text
		move.w	(Credits.routine).w,d0
		addq.w	#2,(Credits.routine).w
		lea	CreditsText_Index(pc),a1
		move.w	(a1,d0.w),d0
		beq.s	.loadtextend							; if zero, branch
		adda.w	d0,a1
		move.l	#$A0018100,d5							; VRAM shift (font pos in VRAM) ; large and small font
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
		dmaFillVRAM 0, VRAM_Plane_A_Name_Table, VRAM_Plane_Table_Size		; clear plane A PNT
		startZ80

.loadtextend
		move.l	#.return,(Credits.process).w
		st	(Credits.end).w

		; load text
		lea	Credits_TextEnd(pc),a1
		cmpi.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		beq.s	.loadtext							; if yes, branch
		lea	Credits_TextTryAgain(pc),a1

.loadtext
		move.l	#$80018100,d5							; VRAM shift (font pos in VRAM) ; large and small font
		bsr.s	Credits_LoadText

		; load player palette
		moveq	#PalID_Sonic,d0
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w				; is Knuckles?
		blo.s	.notKnux							; if not, branch
		moveq	#PalID_Knuckles,d0

.notKnux
		jsr	(LoadPalette).w							; load player's palette
		moveq	#PalID_Ending,d0
		jmp	(LoadPalette).w

; ---------------------------------------------------------------------------
; Load text
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Credits_LoadText:
		disableIntsSave
		lea	(VDP_data_port).l,a6						; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5				; load VDP control address to a5
		move.w	#$8F80,VDP_control_port-VDP_control_port(a5)			; VRAM increment at $80 bytes (vertical write)
		move.l	#vdpCommDelta(planeLoc(64,1,0)),d4				; row increment value

.loop
		move.l	d5,d3
		moveq	#(Credits_DrawSmallText-Credits_DrawSmallText),d0		; small text
		moveq	#0,d1
		move.w	(a1)+,d1							; get plane pos
		beq.s	.exit								; if zero, end queue
		bpl.s	.normal
		andi.w	#$FFF,d1
		moveq	#(Credits_DrawLargeText-Credits_DrawSmallText),d0		; large text
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
		move.w	#$8F02,VDP_control_port-VDP_control_port(a5)			; VRAM increment at 2 bytes (horizontal write)
		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

		; set the character
		save
		codepage CREDITSCREEN2

Credits_DrawSmallText:
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	.exit								; if zero, exit

		; load small letter (8x16)
		cmpi.b	#' ',d0
		bne.s	.calc
		moveq	#0,d0
		bra.s	.setpos
; ---------------------------------------------------------------------------

.calc
		subq.w	#1,d0								; -1
		add.w	d0,d0
		move.w	d0,d2
		addq.w	#1,d2
		swap	d0
		move.w	d2,d0
		move.w	d3,d2								; VRAM shift (font pos in VRAM)
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

		; fix odd address
		move.w	a1,d0								; load ROM address (lower 16 bits)
		andi.w	#1,d0								; (0 = even, 1 = odd)
		adda.w	d0,a1								; add 1 if it was odd, else add 0

.return
		rts

; =============== S U B R O U T I N E =======================================

		; set the character
		codepage CREDITSCREEN

Credits_DrawLargeText:
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	Credits_DrawSmallText.exit					; if zero, exit

		; load large letter
		cmpi.b	#' ',d0
		bne.s	.calc
		moveq	#0,d0
		moveq	#0,d2								; set next tiles
		moveq	#1-1,d6								; 8x24
		bra.s	.setpos
; ---------------------------------------------------------------------------

.calc
		subq.w	#1,d0								; -1
		add.w	d0,d0
		add.w	d0,d0
		movem.w	.letters(pc,d0.w),d0/d6						; get id letter and size
		move.w	d0,d2
		addq.w	#1,d2
		swap	d0
		move.w	d2,d0
		move.w	d3,d2								; VRAM shift (font pos in VRAM)
		swap	d2
		move.w	d3,d2
		add.l	d2,d0
		move.l	#$10001,d2							; set next tiles

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
		creditsletters "ABCDEFGHIJKLMNOPQRSTUVWXYZ.()0123456789!"

		restore	; reset character set

; ---------------------------------------------------------------------------
; Object 8B - Eggman on "TRY AGAIN" and "END" screens (Credits)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset count									; pretend we're in the RAM

creditsrobotnik.drop_flag		ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_CreditsRobotnik:

		; init
		movem.l	ObjDat_CreditsRobotnik(pc),d0-d3				; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	#screen_width/2,x_pos(a0)
		move.w	#screen_height/2,y_pos(a0)
		move.w	#(20*60)-1,wait_timer(a0)					; set wait timer

		; END
		cmpi.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		beq.s	.defeated							; if yes, branch

		; Try Again
		move.b	#5,anim_frame_timer(a0)
		move.l	#.main,code_addr(a0)
		bsr.w	CreditsRobotnik_LoadEmeralds

.main
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		move.b	#$80,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		st	creditsrobotnik.drop_flag(a0)

		; next
		move.l	#.wait,code_addr(a0)

.wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		addq.b	#5+1,anim_frame_timer(a0)
		move.l	#.main,code_addr(a0)

		; set frame
		clr.b	mapping_frame(a0)
		bchg	#0,prev_anim(a0)						; prev frame
		bne.s	.draw
		addq.b	#2,mapping_frame(a0)

.draw

		; check
		move.b	(Ctrl_1_pressed).w,d0
		or.b	(Ctrl_2_pressed).w,d0
		bmi.s	.finish								; if start was pressed, skip ahead

		; wait
		subq.w	#1,wait_timer(a0)						; decrement timer
		bmi.s	.finish								; if timer has run out, branch

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
		move.b	#GameModeID_SegaScreen,(Game_mode).w				; set screen mode to Sega
		addq.w	#4*2,sp								; exit from object and current screen
		rts
; ---------------------------------------------------------------------------

AniRaw_RobotnikEnd:	dc.b 7, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, arfEnd
	even

; ---------------------------------------------------------------------------
; Robotnik load emeralds (Credits)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CreditsRobotnik_LoadEmeralds:

		; load emeralds
		lea	(Collected_emeralds_array).w,a2
		moveq	#0,d1
		moveq	#0,d2
		moveq	#ChaosEmeralds_Count-1,d6

		; create emeralds
		jsr	(Create_New_Object_3).w
		bne.s	.return

.loop
		tst.b	(a2)+								; was the emerald collected?
		bne.s	.next								; if yes, branch

		; load emerald object
		move.l	#Obj_CreditsRobotnik_Emeralds,code_addr(a1)
		move.w	a0,parent3(a1)							; save Robotnik address to emeralds
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d1,mapping_frame(a1)
		move.b	d2,subtype(a1)
		addq.b	#2,d2

.next
		addq.b	#1,d1								; next emerald frame

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d6,.loop

.return
		rts

; ---------------------------------------------------------------------------
; Object 8C - chaos emeralds on the "TRY AGAIN" screen (Credits)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

creditsrobotnik_emeralds.origX		ds.w 1						; original x-axis position (2 bytes)
creditsrobotnik_emeralds.origY		ds.w 1						; original y-axis position (2 bytes)
creditsrobotnik_emeralds.delay		ds.w 1						; (2 bytes)
creditsrobotnik_emeralds.radius		ds.w 1						; radius of circular (2 bytes)
creditsrobotnik_emeralds.speed		ds.w 1						; rotation speed (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_CreditsRobotnik_Emeralds:

		; set wait
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1								; multiply by $0A
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,wait_timer(a0)						; set wait timer
		move.w	d0,creditsrobotnik_emeralds.delay(a0)

		; init
		movem.l	ObjDat_CreditsRobotnik_Emeralds(pc),d0-d3			; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	x_pos(a0),creditsrobotnik_emeralds.origX(a0)
		moveq	#-12,d0
		add.w	y_pos(a0),d0
		move.w	d0,creditsrobotnik_emeralds.origY(a0)
		move.b	#$80,angle(a0)
		move.b	#28,creditsrobotnik_emeralds.radius(a0)

.main

		; check flag
		movea.w	parent3(a0),a1							; load Robotnik address
		tst.b	creditsrobotnik.drop_flag(a1)
		beq.s	.circular
		move.l	#.move,code_addr(a0)

		; set move
		moveq	#2,d0
		btst	#0,prev_anim(a1)						; check Robotnik prev frame
		beq.s	.mset
		neg.w	d0

.mset
		move.b	d0,creditsrobotnik_emeralds.speed(a0)
		asl.w	#3,d0
		add.b	d0,angle(a0)

.move
		tst.w	wait_timer(a0)							; is timer over?
		beq.s	.aradius							; if yes, branch
		subq.w	#1,wait_timer(a0)						; decrement timer
		bne.s	.cangle								; if time remains, branch

.aradius
		move.b	creditsrobotnik_emeralds.speed(a0),d0
		add.b	d0,angle(a0)

.cangle
		move.b	angle(a0),d0
		beq.s	.clrs								; branch, if it's right side
		cmpi.b	#$80,d0								; is it left side?
		bne.s	.circular							; if not, branch

.clrs
		clr.b	creditsrobotnik_emeralds.speed(a0)
		move.w	creditsrobotnik_emeralds.delay(a0),wait_timer(a0)
		move.l	#.main,code_addr(a0)

		; check
		tst.b	subtype(a0)							; is first emerald?
		bne.s	.circular							; if not, branch

		; clear flag
		movea.w	parent3(a0),a1							; load Robotnik address
		clr.b	creditsrobotnik.drop_flag(a1)

.circular
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	creditsrobotnik_emeralds.radius(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	creditsrobotnik_emeralds.origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)							; move object circularly
		move.w	creditsrobotnik_emeralds.origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo (Credits)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo:

		; init
		movem.l	ObjDat_CreditsEggRobo(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	#screen_width/2,x_pos(a0)
		move.w	#screen_height/2,y_pos(a0)

		; Try Again
		move.l	#AniRaw_CreditsEggRoboEnd,animations(a0)
		cmpi.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		bne.s	.createemrl							; if not, branch

		; END
		move.l	#AniRaw_CreditsEggRobo,animations(a0)
		move.w	#(screen_height/2)+32,y_pos(a0)
		move.l	#.wait,code_addr(a0)
		lea	Child1_CreditsEggRobo_Misc(pc),a2
		jsr	(CreateChild1_Normal).w

.wait
		btst	#2,state_flags(a0)
		beq.s	.draw
		move.w	#$1F,wait_timer(a0)						; set wait timer
		move.l	#.rise,code_addr(a0)

.rise
		subq.w	#1,y_pos(a0)
		subq.w	#1,wait_timer(a0)						; decrement timer
		bpl.s	.draw								; if time remains, branch
		move.l	#.animate,code_addr(a0)

.riseskip
		move.w	#(20*60)-1,wait_timer(a0)					; set wait timer

.animate
		jsr	(Animate_Raw).w

		; check
		move.b	(Ctrl_1_pressed).w,d0
		or.b	(Ctrl_2_pressed).w,d0
		bmi.s	.finish								; if start was pressed, skip ahead

		; wait
		subq.w	#1,wait_timer(a0)						; decrement timer
		bmi.s	.finish								; if time remains, branch

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.finish
		move.b	#GameModeID_SegaScreen,(Game_mode).w				; set screen mode to Sega
		addq.w	#4*2,sp								; exit from object and current screen
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

		; calc emeralds position
		moveq	#ChaosEmeralds_Count,d6						; max emeralds
		sub.b	(Chaos_emerald_count).w,d6
		blo.s	.return
		move.l	#256,d4								; 360 degrees = 256
		divu.w	d6,d4

		; load emeralds
		lea	(Collected_emeralds_array).w,a2
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#ChaosEmeralds_Count-1,d6

		; create emeralds
		jsr	(Create_New_Object_3).w
		bne.s	.return

.loop
		tst.b	(a2)+								; was the emerald collected?
		bne.s	.next								; if yes, branch

		; load emerald object
		move.l	#Obj_CreditsEggRobo_Emeralds,code_addr(a1)
		move.w	a0,parent3(a1)							; save Egg Robo address to emeralds
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d1,mapping_frame(a1)
		move.b	d2,subtype(a1)
		addq.b	#2,d2
		move.b	d3,angle(a1)
		add.b	d4,d3

.next
		addq.b	#1,d1								; next emerald frame

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d6,.loop

.return
		rts

; ---------------------------------------------------------------------------
; Egg Robo emeralds (Credits)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

creditseggrobo_emeralds.origX		ds.w 1						; original x-axis position (2 bytes)
creditseggrobo_emeralds.origY		ds.w 1						; original y-axis position (2 bytes)
creditseggrobo_emeralds.radius		ds.w 1						; radius of circular (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo_Emeralds:

		; init
		movem.l	ObjDat_CreditsEggRobo_Emeralds(pc),d0-d3			; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	x_pos(a0),creditseggrobo_emeralds.origX(a0)
		moveq	#-72,d0
		add.w	y_pos(a0),d0
		move.w	d0,creditseggrobo_emeralds.origY(a0)
		move.b	#24,creditseggrobo_emeralds.radius(a0)

.circular
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		jsr	(GetSineCosine).w
		move.w	creditseggrobo_emeralds.radius(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	creditseggrobo_emeralds.origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)							; move object circularly
		move.w	creditseggrobo_emeralds.origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo scrap metal (Credits)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo_ScrapMetal:

		; init
		movem.l	ObjDat_CreditsEggRobo_ScrapMetal(pc),d0-d3			; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.b	#4,mapping_frame(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo eyes (Credits)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_CreditsEggRobo_Eyes:

		; init
		movem.l	ObjDat_CreditsEggRobo_Eyes(pc),d0-d3				; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.b	#2,mapping_frame(a0)
		cmpi.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		bne.s	.setframe							; if not, branch
		move.w	#(2*60)-1,wait_timer(a0)					; set wait timer
		move.l	#.main,code_addr(a0)

.main
		subq.w	#1,wait_timer(a0)						; decrement timer
		bpl.s	.return								; if time remains, branch
		move.l	#.animate,code_addr(a0)
		move.l	#.setf,wait_addr(a0)

.return
		rts
; ---------------------------------------------------------------------------

.animate
		lea	AniRaw_CreditsEggRobo_Eyes(pc),a1
		jsr	(Animate_RawNoSSTMultiDelay).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.setf
		move.l	#.refresh,code_addr(a0)
		movea.w	parent3(a0),a1							; a1=parent object
		bset	#2,state_flags(a1)
		rts
; ---------------------------------------------------------------------------

.setframe
		move.b	#3,mapping_frame(a0)

.refresh
		moveq	#-20,d0
		movea.w	parent3(a0),a1							; a1=parent object
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
		beq.s	.return								; if timer has run out, don't do anything
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

; init
ObjDat_CreditsRobotnik:			subObjMainData Obj_CreditsRobotnik.defeated, setBit(render_flags.level), 0, 64, 56, 3, $182, 0, FALSE, Map_CreditsRobotnik
ObjDat_CreditsRobotnik_Emeralds:	subObjMainData Obj_CreditsRobotnik_Emeralds.main, setBit(render_flags.level), 0, 16, 16, 1, $2D3, 0, FALSE, Map_ECha
ObjDat_CreditsEggRobo:			subObjMainData Obj_CreditsEggRobo.animate, setBit(render_flags.level), 0, 64, 56, 5, $232, 0, FALSE, Map_CreditsEggRobo
ObjDat_CreditsEggRobo_Emeralds:		subObjMainData Obj_CreditsEggRobo_Emeralds.circular, setBit(render_flags.level), 0, 16, 16, 1, $2D3, 0, FALSE, Map_ECha
ObjDat_CreditsEggRobo_ScrapMetal:	subObjMainData Draw_Sprite, setBit(render_flags.level), 0, 64, 112, 4, $232, 0, FALSE, Map_CreditsEggRobo
ObjDat_CreditsEggRobo_Eyes:		subObjMainData Obj_CreditsEggRobo_Eyes.refresh, setBit(render_flags.level), 0, 16, 16, 3, $232, 0, FALSE, Map_CreditsEggRobo

PLC_Credits: plrlistheader
		plreq $100, ArtKosPlusM_CreditsSmallText
		plreq $182, ArtKosPlusM_CreditsRobotnik
		plreq $232, ArtKosPlusM_CreditsEggRobo
		plreq $2D3, ArtKosPlusM_EndingEmeralds
		plrlistend
; ---------------------------------------------------------------------------

		; mappings
		include "Screens/Credits/Object Data/Map - Robotnik.asm"
		include "Screens/Credits/Object Data/Map - Egg Robo.asm"
