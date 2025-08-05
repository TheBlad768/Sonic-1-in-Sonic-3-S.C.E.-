; ---------------------------------------------------------------------------
; Continue
; ---------------------------------------------------------------------------

; Constants
Continue_Offset:			= *

; Variables

; RAM
	phase ramaddr(Palette_cycle_counters)

Continue_countdown:			ds.w 1
Continue_routine:			ds.b 1
Continue_countdown_numbers:		ds.b 1
Continue_countdown_update:		ds.b 1

	dephase
	!org	Continue_Offset

Continue_VDP:
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

ContinueScreen:
		music	mus_Stop									; stop music
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	Continue_VDP(pc),a1
		jsr	(Load_VDP).w
		clearRAM Object_RAM, Object_RAM_end							; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end						; clear variables
		clearRAM Camera_RAM, Camera_RAM_end							; clear the camera RAM
		clearRAM Oscillating_variables, Oscillating_variables_end				; clear variables

		; clear
		move.b	d0,(Water_full_screen_flag).w
		move.b	d0,(Water_flag).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w

		; load main art
		lea	PLC_Continue(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

.waitplc
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; set
		move.w	#(11*60)-1,(Demo_timer).w							; set to wait

		; load Sonic palette
		lea	(Pal_Sonic).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line16).w

		move.w	#$222,-2(a2)									; fix black color

		; load main palette
		lea	(Pal_Continue).l,a1
		jsr	(PalLoad_Line32).w

		; load Knuckles palette
		lea	(Pal_Knuckles).l,a1
		jsr	(PalLoad_Line16).w

		move.w	#$222,-2(a2)									; fix black color...

		; load text
		lea	Credits_TextCONTINUE(pc),a1
		move.l	#$C347C347,d5									; VRAM shift (font pos in VRAM) ; large and small font
		bsr.w	Credits_LoadText

		; check players
		move.w	(Player_mode).w,d0
		cmpi.w	#PlayerModeID_Knuckles,d0							; is Knuckles?
		bhs.s	.main										; if yes, branch
		cmpi.w	#PlayerModeID_Sonic,d0								; is Sonic alone?
		bne.s	.notsa										; if not, branch
		move.l	#Obj_Continue_SonicAlone,(Player_1+address).w					; create Sonic alone
		bra.s	.main
; ---------------------------------------------------------------------------

.notsa
		move.l	#Obj_Continue_SonicWTails,(Player_1+address).w					; create Sonic and Tails
		move.l	#Obj_Continue_TailsWSonic,(Player_2+address).w

.main
		move.l	#Obj_Continue_Knuckles,(Reserved_object_3+address).w				; create Knuckles for Sonic and Tails

		; create countdown object
		jsr	(Create_New_Sprite).w
		bne.s	.notfree
		move.l	#Obj_Continue_Countdown,address(a1)
		move.w	a1,(Continue_countdown).w							; save parent

		; create stars object
		jsr	(Create_New_Sprite4).w
		bne.s	.notfree
		move.l	#Obj_Continue_Stars,address(a1)

.notfree

		; load icons object
		bsr.w	Continue_LoadIcons
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		music	mus_Continue
		move.b	#VintID_Continue,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		move.b	#VintID_Continue,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_KosPlus_Module_Queue).w
		move.b	(Continue_routine).w,d0								; load Continue routine
		beq.s	.loop
		subq.b	#1,d0
		beq.s	.back

		; exit to Sega screen
		move.b	#GameModeID_SegaScreen,(Game_mode).w						; set screen mode to Sega
		rts
; ---------------------------------------------------------------------------

.back
		move.b	#GameModeID_LevelScreen,(Game_mode).w						; set screen mode to Level

		; set
		move.b	#3,(Life_count).w
		move.l	#5000,(Next_extra_life_score).w

		; clear
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		subq.b	#1,(Continue_count).w								; subtract 1 from number of continue
		rts

; ---------------------------------------------------------------------------
; Countdown (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_Countdown:
		move.b	#9+1,(Continue_countdown_numbers).w						; set 10 seconds
		move.l	#.main,address(a0)

.main
		move.b	(Ctrl_1_pressed).w,d0
		or.b	(Ctrl_2_pressed).w,d0
		bmi.s	.pstart										; if start was pressed, skip ahead

		; wait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.return
		move.w	#60-1,objoff_2E(a0)

		; sub and draw numbers
		move.b	(Continue_countdown_numbers).w,d0
		subq.b	#1,d0
		bmi.s	.end
		move.b	d0,(Continue_countdown_numbers).w
		st	(Continue_countdown_update).w
		rts
; ---------------------------------------------------------------------------

.end
		move.b	#2,(Continue_routine).w
		rts
; ---------------------------------------------------------------------------

.pstart
		bset	#3,objoff_38(a0)								; set "press start" flag
		move.l	#.return,address(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Sonic (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_SonicWTails:

		; init
		movem.l	ObjDat_Continue_SonicWTails(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	#$80+((320/2)-8),x_pos(a0)
		move.w	#$80+((224/2)+48),y_pos(a0)

.main
		movea.w	(Continue_countdown).w,a1
		btst	#3,objoff_38(a1)								; is Start was pressed?
		bne.s	.pstart										; if yes, branch

		; anim
		moveq	#0,d0
		btst	#4,(V_int_run_count+3).w
		beq.s	.setanim
		addq.b	#1,d0

.setanim
		move.b	d0,mapping_frame(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.pstart
		move.l	#.rotation,address(a0)
		move.l	#Map_Sonic,mappings(a0)
		move.w	#make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
		clr.b	(Player_prev_frame).w
		move.b	#$5A,mapping_frame(a0)
		move.b	#6,anim_frame_timer(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.rotation

		; wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		addq.b	#6+1,anim_frame_timer(a0)

		; anim
		moveq	#0,d0
		move.b	anim_frame(a0),d0
		addq.w	#2,d0										; next data
		cmpi.b	#(.aniraw_end-.aniraw),d0
		bhs.s	.setrun
		move.b	d0,anim_frame(a0)
		lea	.aniraw(pc,d0.w),a2
		move.b	(a2)+,mapping_frame(a0)
		bclr	#render_flags.x_flip,render_flags(a0)						; clear flipx
		tst.b	(a2)
		beq.s	.draw
		bset	#render_flags.x_flip,render_flags(a0)						; set flipx

.draw
		jsr	(Sonic_Load_PLC).l
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.setrun
		move.l	#.waitrun,address(a0)
		move.w	#bytes_to_word(0,1),anim(a0)
		move.w	#$600,ground_vel(a0)
		move.w	#(1<<4)-1,objoff_2E(a0)								; set wait
		bra.s	.draw
; ---------------------------------------------------------------------------

.aniraw		; frame, flipx flag
		dc.b $5A, 1
		dc.b $59, 1
		dc.b $55, 0
		dc.b $56, 0
		dc.b $57, 0
.aniraw_end
; ---------------------------------------------------------------------------

.waitrun
		jsr	(Animate_Sonic).l
		subq.w	#1,objoff_2E(a0)
		bmi.s	.startrun
		bra.s	.draw
; ---------------------------------------------------------------------------

.startrun
		move.l	#.run,address(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.run
		jsr	(Animate_Sonic).l
		addq.w	#6,x_pos(a0)
		cmpi.w	#$80+(320+32),x_pos(a0)
		bhs.s	.stoprun
		bra.s	.draw
; ---------------------------------------------------------------------------

.stoprun
		move.l	#.draw,address(a0)
		bra.s	.draw

; ---------------------------------------------------------------------------
; Sonic Alone (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_SonicAlone:

		; init
		movem.l	ObjDat_Continue_SonicAlone(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	#$80+(320/2),x_pos(a0)
		move.w	#$80+((224/2)+48),y_pos(a0)

.main
		movea.w	(Continue_countdown).w,a1
		btst	#2,objoff_38(a1)								; Knuckles run to the middle of the screen?
		bne.s	.setrun										; if yes, branch
		lea	AniRaw_5CBC5(pc),a1

.anim
		jsr	(Animate_RawNoSSTCheckResult).w

.draw
		jsr	(Sonic_Load_PLC).l
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.setrun
		move.l	#.waitrun,address(a0)
		move.b	#$BA,mapping_frame(a0)
		move.w	#(1<<3)-1,objoff_2E(a0)								; set wait
		bra.s	.draw
; ---------------------------------------------------------------------------

.waitrun
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.l	#.run,address(a0)
		move.b	#$21,mapping_frame(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.run
		addq.w	#6,x_pos(a0)
		cmpi.w	#$80+(320+32),x_pos(a0)
		bhs.s	.stoprun
		lea	AniRaw_5CBB4(pc),a1
		bra.s	.anim
; ---------------------------------------------------------------------------

.stoprun
		move.b	#1,(Continue_routine).w								; set screen routine
		move.l	#.draw,address(a0)
		bra.s	.draw

; ---------------------------------------------------------------------------
; Tails (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_TailsWSonic:

		; init
		movem.l	ObjDat_Continue_TailsWSonic(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	#$80+((320/2)+12),x_pos(a0)
		move.w	#$80+((224/2)+48),y_pos(a0)

.waitstart
		movea.w	(Continue_countdown).w,a1
		btst	#3,objoff_38(a1)								; is Start was pressed?
		bne.s	.pstart										; if yes, branch

		; anim
		moveq	#5,d0
		btst	#5,(V_int_run_count+3).w
		beq.s	.setframe
		addq.b	#1,d0

.setframe
		move.b	d0,mapping_frame(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.pstart
		move.l	#.main,address(a0)
		addq.w	#4,y_pos(a0)									; fix pos

		; create tails
		move.l	#Obj_Tails_Tail,(Tails_tails+address).w
		move.w	a0,(Tails_tails+objoff_30).w

		; create fix for tails
		move.l	#Obj_Continue_Tails_tails_Fix,(Dust+address).w

.main
		move.l	#.wait,address(a0)
		move.l	#Map_Tails,mappings(a0)

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_5, \
			make_art_tile(ArtTile_Player_2,0,0) \
		),priority(a0)

		clr.b	(Player_prev_frame_P2).w
		move.w	#bytes_to_word(5,0),anim(a0)							; set anim and prev_anim
		move.w	#bytes_to_word($AD,0),mapping_frame(a0)						; set frame and clear anim_frame
		move.w	#$28-1,objoff_2E(a0)								; set wait
		bra.s	.anim
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.anim
		move.l	#.waitrun,address(a0)

		; set run
		clr.b	anim(a0)
		move.w	#$600,ground_vel(a0)
		move.w	#$14-1,objoff_2E(a0)								; set wait

.waitrun
		subq.w	#1,objoff_2E(a0)
		bpl.s	.anim
		move.l	#.run,address(a0)

.anim
		jsr	(Animate_Tails).l
		jsr	(Tails_Load_PLC).l
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.run
		addq.w	#6,x_pos(a0)
		cmpi.w	#$80+(320+32),x_pos(a0)
		blo.s	.anim
		move.b	#1,(Continue_routine).w								; set screen routine
		bra.s	.anim

; ---------------------------------------------------------------------------
; Tails tails fix (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_Tails_tails_Fix:
		bclr	#2,(Tails_tails+render_flags).w
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Knuckles (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_Knuckles:

		; check
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		bhs.s	.setKnux									; if yes, branch

		; for Sonic and Tails
		move.w	#$80-64,x_pos(a0)
		move.w	#$80+((224/2)+48),y_pos(a0)

		; next
		move.l	#.main,address(a0)
		bra.s	.main
; ---------------------------------------------------------------------------

.setKnux

		; init
		movem.l	ObjDat_Continue_Knuckles(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.w	#$80+((320/2)-4),x_pos(a0)
		move.w	#$80+((224/2)+48),y_pos(a0)

.waitstart
		move.w	#$2F,objoff_2E(a0)								; set wait
		movea.w	(Continue_countdown).w,a1
		btst	#3,objoff_38(a1)								; is Start was pressed?
		beq.s	.wait										; if not, branch
		move.l	#.wait,address(a0)

		; create egg robo
		jsr	(Create_New_Sprite).w
		bne.s	.wait
		move.l	#Obj_Continue_EggRobo,address(a1)

.wait
		subq.w	#1,objoff_2E(a0)
		bpl.s	.anim
		move.l	#.main,address(a0)

.anim
		lea	AniRaw_5CBC0(pc),a1
		jsr	(Animate_RawNoSST).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.main
		movem.l	ObjDat_Continue_Knuckles2(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.b	#7,mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		clr.b	anim_frame(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.waitstart2
		movea.w	(Continue_countdown).w,a1
		btst	#3,objoff_38(a1)								; is Start was pressed?
		bne.s	.pstart										; if yes, branch

.draw
		bsr.s	Knuckles_Load_PLC_Continue
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.pstart
		move.l	#.run,address(a0)

.run
		move.w	x_pos(a0),d0
		addq.w	#6,d0
		move.w	d0,x_pos(a0)
		movea.w	(Continue_countdown).w,a1
		cmpi.w	#$80+(320/2),d0
		blo.s	.checkpos
		bset	#2,objoff_38(a1)								; set Knuckles in the middle of the screen flag

.checkpos
		cmpi.w	#$80+(320+32),d0
		bhs.s	.stoprun
		lea	AniRaw_5CBB4(pc),a1
		jsr	(Animate_RawNoSSTCheckResult).w
		bra.s	.draw
; ---------------------------------------------------------------------------

.stoprun
		move.l	#.draw,address(a0)
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w						; is Knuckles?
		blo.s	.draw										; if not, branch
		move.b	#1,(Continue_routine).w								; set screen routine
		bra.s	.draw

; ---------------------------------------------------------------------------
; Knuckles (DPLC)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Knuckles_Load_PLC_Continue:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	objoff_3A(a0),d0
		beq.s	.return
		move.b	d0,objoff_3A(a0)

		; load
		add.w	d0,d0
		lea	(DPLC_Knuckles).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.return
		move.w	#tiles_to_bytes(ArtTile_CutsceneKnuckles),d4
		move.l	#dmaSource(ArtUnc_Knuckles),d6

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

; ---------------------------------------------------------------------------
; Egg Robo (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_EggRobo:

		; init
		lea	ObjDat_919A6(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#render_flags.y_flip,render_flags(a0)						; flipx
		move.l	#.main,address(a0)
		move.w	#$80-32,x_pos(a0)
		move.w	#$80+(224/2),y_pos(a0)
		move.w	#$600,x_vel(a0)
		jsr	(Swing_Setup1).w
		lea	Child1_EggRobo_Misc(pc),a2
		jsr	(CreateChild1_Normal).w

		; load egg robo badnik art
		QueueKosPlusModule	ArtKosPM_EggRoboBadnik, $500, 1
; ---------------------------------------------------------------------------

.main
		jsr	(Swing_UpAndDown).w
		jsr	(MoveSprite2).w
		pea	(Draw_Sprite).w

		; anim
		moveq	#1,d0
		btst	#0,(V_int_run_count+3).w
		beq.s	.skip
		moveq	#3,d0

.skip
		move.b	d0,mapping_frame(a0)
		rts

; ---------------------------------------------------------------------------
; Egg Robo legs (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_EggRobo_Legs:

		; init
		lea	ObjDat3_919BE(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.main,address(a0)

		; check
		movea.w	parent3(a0),a1									; a1=parent object
		btst	#render_flags.level,render_flags(a1)						; is parent uses screen coordinates flag?
		bne.s	.main										; if yes, branch
		bclr	#render_flags.level,render_flags(a0)						; clear screen coordinates flag

.main
		jsr	(Refresh_ChildPositionAdjusted).w
		moveq	#6,d0
		move.w	y_vel(a1),d1
		bmi.s	.setframe
		moveq	#5,d0
		cmpi.w	#$20,d1
		blo.s	.setframe
		moveq	#4,d0

.setframe
		move.b	d0,mapping_frame(a0)
		jmp	(Child_Draw_Sprite).w

; ---------------------------------------------------------------------------
; Egg Robo gun (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_EggRobo_Gun:

		; init
		lea	ObjDat3_919C4(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.main,address(a0)

		; check
		movea.w	parent3(a0),a1									; a1=parent object
		btst	#render_flags.level,render_flags(a1)						; is parent uses screen coordinates flag?
		bne.s	.main										; if yes, branch
		bclr	#render_flags.level,render_flags(a0)						; clear screen coordinates flag

.main
		pea	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Refresh_ChildPositionAdjusted_Continue:
		movea.w	parent3(a0),a1									; a1=parent object

.skipp
		move.w	x_pos(a1),d0
		move.b	child_dx(a0),d1
		ext.w	d1
		bclr	#render_flags.x_flip,render_flags(a0)
		btst	#render_flags.x_flip,render_flags(a1)
		beq.s	.notflipx
		neg.w	d1
		bset	#render_flags.x_flip,render_flags(a0)

.notflipx
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	objoff_32(a1),d0
		bne.s	.skipypos
		move.w	y_pos(a1),d0

.skipypos
		move.b	child_dy(a0),d1
		ext.w	d1
		bclr	#render_flags.y_flip,render_flags(a0)
		btst	#render_flags.y_flip,render_flags(a1)
		beq.s	.notflipy
		neg.w	d1
		bset	#render_flags.y_flip,render_flags(a0)

.notflipy
		add.w	d1,d0
		move.w	d0,y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Stars (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_Stars:

		; init
		movem.l	ObjDat_Continue_Stars(pc),d0-d3							; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object
		move.b	#7,mapping_frame(a0)
		move.w	#$80+(320/2),x_pos(a0)
		move.w	#($80+(224/2))+5,y_pos(a0)

		; draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Load icons
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Continue_LoadIcons:
		moveq	#0,d6
		move.b	(Continue_count).w,d6
		beq.s	.return
		cmpi.b	#9,d6
		blo.s	.create
		moveq	#9,d6										; create 9 icons (max)

.create
		subq.w	#1,d6										; fix dbf
		moveq	#0,d2
		jsr	(Create_New_Sprite).w
		bne.s	.return

.loop
		move.l	#Obj_Continue_Icons,address(a1)
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		jsr	(Create_New_Sprite4).w								; find next free object slot
		dbne	d6,.loop

.return
		rts

; ---------------------------------------------------------------------------
; Tails tails icons (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_Tails_tails_Icons:

		; init
		movem.l	ObjDat_Continue_Tails_tails_Icons(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object

.main
		lea	AniRaw_5CBBB(pc),a1
		jsr	(Animate_RawNoSST).w
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Icons (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Continue_Icons:

		; init
		movem.l	ObjDat_Continue_Icons(pc),d0-d3							; copy data to d0-d3
		movem.l	d0-d3,address(a0)								; set data from d0-d3 to current object

		; check
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		blo.s	.notKnux
		ori.w	#palette_line_3,art_tile(a0)							; for Knuckles

.notKnux
		bsr.s	Continue_Icons_GetPos
		move.w	#$80+((224/2)-24),y_pos(a0)
		bsr.s	Continue_Icons_LoadAnim

.main
		moveq	#0,d0
		btst	#4,(V_int_run_count+3).w
		beq.s	.skip
		addq.w	#1,d0

.skip
		movea.l	objoff_30(a0),a1
		move.b	(a1,d0.w),mapping_frame(a0)
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Continue_Icons_GetPos:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	.xpos(pc,d0.w),x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.xpos
		dc.w $80+160	; 1
		dc.w $80+184	; 2
		dc.w $80+136	; 3
		dc.w $80+208	; 4
		dc.w $80+112	; 5
		dc.w $80+232	; 6
		dc.w $80+88	; 7
		dc.w $80+256	; 8
		dc.w $80+64	; 9

; =============== S U B R O U T I N E =======================================

Continue_Icons_LoadAnim:
		move.w	(Player_mode).w,d4
		cmpi.w	#PlayerModeID_Tails,d4								; is Tails?
		bne.s	.notTails									; if not, branch

		; create tails tails icons
		lea	Child6_Continue_Tails_tails_Icons(pc),a2
		jsr	(CreateChild6_Simple).w

.notTails
		add.w	d4,d4
		add.w	d4,d4
		move.l	.index(pc,d4.w),objoff_30(a0)
		rts
; ---------------------------------------------------------------------------

.index
		dc.l byte_5CBAE		; 0 (Sonic and Tails)
		dc.l byte_5CBAE		; 1 (Sonic)
		dc.l byte_5CBB0		; 2 (Tails)
		dc.l byte_5CBB2		; 3 (Knuckles)
		dc.l byte_5CBB2		; 4 (Knuckles and Tails)

byte_5CBAE:	dc.b 0, 1		; frames
byte_5CBB0:	dc.b 2, 3
byte_5CBB2:	dc.b 7, 8

; ---------------------------------------------------------------------------
; Load numbers (VInt)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Continue_LoadNumbers:
		tst.b	(Continue_countdown_update).w							; does the numbers need updating?
		beq.s	.return										; if not, branch
		clr.b	(Continue_countdown_update).w

		; get countdown numbers
		move.b	(Continue_countdown_numbers).w,d0
		move.b	d0,d1										; copy numbers

		; calc left number (0)
		andi.w	#$F0,d0
		addq.w	#1,d0										; VRAM shift (numbers pos in VRAM)
		move.w	d0,d2
		swap	d0
		move.w	d2,d0
		addq.w	#1,d0										; next tile

		; calc right number (9)
		andi.w	#$F,d1
		add.w	d1,d1
		addq.w	#1,d1										; VRAM shift (numbers pos in VRAM)
		move.w	d1,d2
		swap	d1
		move.w	d2,d1
		addq.w	#1,d1										; next tile
		move.w	#$8F80,VDP_control_port-VDP_control_port(a5)					; VRAM increment at $80 bytes (draw tiles vertically)
		move.l	#vdpCommDelta(planeLoc(64,1,0)),d4						; row increment value

		; draw numbers
		locVRAM	(VRAM_Plane_A_Name_Table+$726),d2
		move.l	d2,VDP_control_port-VDP_control_port(a5)					; set pos
		move.l	d0,VDP_data_port-VDP_data_port(a6)						; left number
		add.l	d4,d2										; next pos
		move.l	d2,VDP_control_port-VDP_control_port(a5)					; set pos
		move.l	d1,VDP_data_port-VDP_data_port(a6)						; right number

		; exit
		move.w	#$8F02,VDP_control_port-VDP_control_port(a5)					; VRAM increment at 2 bytes (draw tiles horizontally)

.return
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Continue_SonicWTails:			subObjMainData Obj_Continue_SonicWTails.main, 0, 0, 40, 24, 5, $8C, 0, 0, Map_ContinueSprites
ObjDat_Continue_SonicAlone:			subObjMainData Obj_Continue_SonicAlone.main, 0, 0, 40, 24, 5, ArtTile_Player_1, 0, 0, Map_Sonic
ObjDat_Continue_TailsWSonic:			subObjMainData Obj_Continue_TailsWSonic.waitstart, 0, 0, 40, 32, 4, $8C, 0, 0, Map_ContinueSprites
ObjDat_Continue_Knuckles:			subObjMainData Obj_Continue_Knuckles.waitstart, 0, 0, 48, 32, 4, $8C, 3, 0, Map_ContinueSprites
ObjDat_Continue_Knuckles2:			subObjMainData Obj_Continue_Knuckles.waitstart2, 0, 0, 96, 64, 1, ArtTile_CutsceneKnuckles, 3, 0, Map_Knuckles
ObjDat_919A6:					subObjData Map_EggRoboBadnik, $500, 0, 1, 48, 40, 5, 1, 6|collision_flags.npc.touch
ObjDat3_919BE:					subObjData FALSE, FALSE, 0, 0, 32, 24, 5, 6, 0
ObjDat3_919C4:					subObjData FALSE, FALSE, 0, 0, 24, 32, 5, 2, 0
ObjDat3_919CA:					subObjData FALSE, FALSE, 0, 0, 8, 64, 5, 7, 0
ObjDat_Continue_Stars:				subObjMainData Draw_Sprite, 0, 0, 16, 16, 7, $8C, 1, 0, Map_ContinueSprites
ObjDat_Continue_Tails_tails_Icons:		subObjMainData Obj_Continue_Tails_tails_Icons.main, 0, 0, 16, 16, 5, $D9, 0, 0, Map_ContinueIcons
ObjDat_Continue_Icons:				subObjMainData Obj_Continue_Icons.main, 0, 0, 16, 16, 7, $D9, 0, 0, Map_ContinueIcons

Child6_Continue_Tails_tails_Icons:
		dc.w 1-1
		dc.l Obj_Continue_Tails_tails_Icons
Child1_EggRobo_Misc:
		dc.w 2-1
		dc.l Obj_Continue_EggRobo_Legs
		dc.b -12, 28
		dc.l Obj_Continue_EggRobo_Gun
		dc.b -28, -4

AniRaw_5CBB4:	dc.b 2, $21, $22, $23, $24, arfIndex, arfEnd
AniRaw_5CBBB:	dc.b 8, 4, 5, 6, arfEnd
AniRaw_5CBC0:	dc.b $B, 2, 2, 4, arfEnd
AniRaw_5CBC5:	dc.b $B, $BD, $BE, arfIndex, arfEnd
	even

Credits_TextCONTINUE:
		creditstr $F292, "C O N T I N U E"
		creditstr_end

PLC_Continue: plrlistheader
		plreq 1, ArtKosPM_ContinueDigits
		plreq $8C, ArtKosPM_ContinueSprites
		plreq $D9, ArtKosPM_ContinueIcons
		plreq $347, ArtKosPM_LargeTextCredits
PLC_Continue_end
; ---------------------------------------------------------------------------

		include "Screens/Continue/Object Data/Map - Player Sprites.asm"
		include "Screens/Continue/Object Data/Map - Player Icons.asm"
		include "Screens/Continue/Object Data/Map - Egg Robo Badnik.asm"
