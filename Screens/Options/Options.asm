; ---------------------------------------------------------------------------
; Options
; ---------------------------------------------------------------------------

; Constants
Options_Offset:				= *
Options_VRAM:				= $50F

; Variables
Options_MaxCount:			= 7
Options_MaxCharacters:			= 5
Options_MaxMusicOpt:			= 2								; on/off
Options_MaxSoundOpt:			= 2								; on/off
Options_MaxMusicNumber:			= (mus__Last-mus__First)
Options_MaxSoundNumber:			= (sfx__Last-sfx__First)
Options_MaxSampleNumber:		= (dac__Last-dac__First)

; RAM
	phase ramaddr(RAM_start)

Options_buffer:				ds.b $1000							; foreground buffer (copy)
Options_buffer2:			ds.b $1000							; foreground buffer (main)

	dephase

	phase ramaddr(Object_load_addr_front)

Options_music_count:			ds.w 1
Options_sound_count:			ds.w 1
Options_sample_count:			ds.w 1
Options_save_music:			ds.w 1
Options_control_timer:			ds.w 1
Options_vertical_count:			ds.w 1

	dephase
	!org	Options_Offset
; ---------------------------------------------------------------------------

Options_VDP:
		dc.w $8004										; disable HInt, HV counter, 8-colour mode
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)						; set foreground nametable address
		dc.w $8300+(VRAM_Plane_B_Name_Table>>10)						; set window nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)						; set background nametable address
		dc.w $8700+(2<<4)									; set background colour (line 3; colour 0)
		dc.w $8B00										; full-screen horizontal and vertical scrolling
		dc.w $8C81										; set 40cell screen size, no interlacing, no s/h
		dc.w $9001										; 64x32 cell nametable area
		dc.w $9100										; set window H position at default
		dc.w $9200										; set window V position at default
		dc.w 0											; end marker

; =============== S U B R O U T I N E =======================================

OptionsScreen:
		music	mus_Stop									; stop music
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	Options_VDP(pc),a1
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
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w
		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w
		move.b	d0,(SBZ2_player_roll).w

		; load main art
		lea	PLC_Options(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; set
		move.l	#VInt_Fade,(V_int_ptr).w							; set VInt pointer

.waitplc
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear
		disableInts

		; load mapping
		EniDecomp	MapEni_OptionsBG, RAM_start, 1, 2, FALSE				; decompress Enigma mappings
		copyTilemap	VRAM_Plane_B_Name_Table, 320, 224

		; clear foreground buffers
		clearRAM RAM_start, (RAM_start+$2000)

		; load text
		bsr.w	Options_LoadText
		move.w	#palette_line_0+Options_VRAM,d3
		bsr.w	Options_MarkFields.loadcharacter
		move.w	#palette_line_0+Options_VRAM,d3
		bsr.w	Options_MarkFields.musicopt
		move.w	#palette_line_0+Options_VRAM,d3
		bsr.w	Options_MarkFields.soundopt
		move.w	#palette_line_0+Options_VRAM,d3
		bsr.w	Options_MarkFields.drawmusic
		move.w	#palette_line_0+Options_VRAM,d3
		bsr.w	Options_MarkFields.drawsound
		move.w	#palette_line_0+Options_VRAM,d3
		bsr.w	Options_MarkFields.drawsample
		move.w	#palette_line_1,d3
		bsr.w	Options_MarkFields

		; load main palette
		lea	(Pal_Options).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line48).w

		; set
		music	mus_Menu									; play music
		move.w	d0,(Options_save_music).w							; save id music

		; next
		move.l	#VInt_LevelSelect,(V_int_ptr).w							; set VInt pointer
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		jsr	(Wait_VSync).w
		moveq	#palette_line_0,d3
		bsr.w	Options_MarkFields
		bsr.s	Options_Controls
		move.w	#palette_line_1,d3
		bsr.w	Options_MarkFields
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop

		; exit
		move.b	#GameModeID_TitleScreen,(Game_mode).w						; set screen mode to Title Screen
		rts

; ---------------------------------------------------------------------------
; Check vertical line
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Options_Controls:

		; set vertical line
		moveq	#Options_MaxCount-1,d2
		move.w	(Options_vertical_count).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	Options_FindUpDownControls
		move.w	d3,(Options_vertical_count).w

		; check vertical line
		add.w	d3,d3
		add.w	d3,d3
		jmp	.index(pc,d3.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.getcharacter									; 0
		rts											; nop
		bra.s	.getmusicopt									; 4
		rts											; nop
		bra.s	.getsoundopt									; 8
		rts											; nop
		bra.s	.getmusic									; C
		rts											; nop
		bra.w	.getsound									; 10
		bra.w	.getsample									; 14
		rts											; 18
		rts

; ---------------------------------------------------------------------------
; Get Character
; ---------------------------------------------------------------------------

.getcharacter
		moveq	#Options_MaxCharacters-1,d2
		move.w	(Player_option).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	Options_FindLeftRightControls
		move.w	d3,(Player_option).w
		rts

; ---------------------------------------------------------------------------
; Get music option
; ---------------------------------------------------------------------------

.getmusicopt
		moveq	#Options_MaxMusicOpt-1,d2
		moveq	#0,d3
		move.b	(Music_disable_flag).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.b	d3,(Music_disable_flag).w

		; check ctrl
		moveq	#btnLR,d0
		and.b	(Ctrl_1_pressed).w,d0
		beq.s	.return

		; check disable music flag
		move.w	(Options_save_music).w,d0
		tst.b	d3
		beq.s	.play
		moveq	#signextendB(mus_Stop),d0

.play
		jmp	(Play_Music2).w

; ---------------------------------------------------------------------------
; Get sound option
; ---------------------------------------------------------------------------

.getsoundopt
		moveq	#Options_MaxSoundOpt-1,d2
		moveq	#0,d3
		move.b	(Sound_disable_flag).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.b	d3,(Sound_disable_flag).w

		; check ctrl
		moveq	#btnLR,d0
		and.b	(Ctrl_1_pressed).w,d0
		beq.s	.return

		; check disable sfx flag
		tst.b	d3
		bne.s	.return
		sfx	sfx_RingRight,1									; play ring sound
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Play music
; ---------------------------------------------------------------------------

.getmusic
		moveq	#Options_MaxMusicNumber,d2
		move.w	(Options_music_count).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(Options_music_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return

		; check stop music
		btst	#button_B,d1
		bne.s	.stop										; branch if B is pressed

		; play music
		move.w	d3,d0
		addq.w	#mus__First,d0									; $00 is reserved for silence
		move.w	d0,(Options_save_music).w							; save id music
		jmp	(Play_Music).w									; play music
; --------------------------------------------------------------------------

.stop
		music	mus_Stop,1

; ---------------------------------------------------------------------------
; Play sound
; ---------------------------------------------------------------------------

.getsound
		moveq	#Options_MaxSoundNumber,d2
		move.w	(Options_sound_count).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(Options_sound_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	Options_FindUpDownControls.returnup

		; play sfx
		move.w	d3,d0
		addi.w	#sfx__First,d0									; $00 is reserved for silence
		jmp	(Play_SFX).w									; play sfx

; ---------------------------------------------------------------------------
; Play sample
; ---------------------------------------------------------------------------

.getsample
		moveq	#Options_MaxSampleNumber,d2
		move.w	(Options_sample_count).w,d3
		lea	(Options_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(Options_sample_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	Options_FindUpDownControls.returnup

		; play sample
		move.w	d3,d0
		addi.w	#dac__First,d0									; $00 is reserved for pause
		jmp	(Play_Sample).w									; play sample

; ---------------------------------------------------------------------------
; Control (up/down)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Options_FindUpDownControls:
		moveq	#btnUD,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.notpressed
		sfx	sfx_Switch
		move.w	#16,(a3)
		bra.s	.pressed
; --------------------------------------------------------------------------

.notpressed
		moveq	#btnUD,d1
		and.b	(Ctrl_1_held).w,d1
		beq.s	.returnup
		subq.w	#1,(a3)
		bpl.s	.returnup
		addq.w	#4,(a3)
		sfx	sfx_Switch

.pressed
		btst	#button_up,d1
		beq.s	.notdown
		subq.w	#1,d3
		bpl.s	.returnup
		move.w	d2,d3

.returnup
		rts
; ---------------------------------------------------------------------------

.notdown
		addq.w	#1,d3
		cmp.w	d2,d3
		bls.s	.returndown
		moveq	#0,d3

.returndown
		rts

; ---------------------------------------------------------------------------
; Control (left/right)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Options_FindLeftRightControls:
		moveq	#btnLR,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.notpressed
		sfx	sfx_Switch
		move.w	#16,(a3)
		bra.s	.pressed
; --------------------------------------------------------------------------

.notpressed
		moveq	#btnLR,d1
		and.b	(Ctrl_1_held).w,d1
		beq.s	.returnleft
		subq.w	#1,(a3)
		bpl.s	.returnleft
		addq.w	#4,(a3)
		sfx	sfx_Switch

.pressed
		btst	#button_left,d1
		beq.s	.notright
		subq.w	#1,d3
		bpl.s	.returnleft
		move.w	d2,d3

.returnleft
		rts
; ---------------------------------------------------------------------------

.notright
		addq.w	#1,d3
		cmp.w	d2,d3
		bls.s	.returnright
		moveq	#0,d3

.returnright
		rts

; ---------------------------------------------------------------------------
; Draw line and numbers
; ---------------------------------------------------------------------------

Options_MappingOffsets:
		dc.w planeLoc(64,0,4)
		dc.w planeLoc(64,0,7)
		dc.w planeLoc(64,0,10)
		dc.w planeLoc(64,0,13)
		dc.w planeLoc(64,0,16)
		dc.w planeLoc(64,0,19)
		dc.w planeLoc(64,0,24)

; =============== S U B R O U T I N E =======================================

Options_MarkFields:

		; get text pos
		move.w	(Options_vertical_count).w,d0
		add.w	d0,d0
		move.w	Options_MappingOffsets(pc,d0.w),d0

		; RAM shift
		lea	(Options_buffer).l,a1
		lea	Options_buffer2-Options_buffer(a1),a2
		adda.w	d0,a1
		adda.w	d0,a2

		; load line
		moveq	#bytesToXcnt(40,8),d2

.copy

	rept 8
		move.w	(a1)+,d0
		add.w	d3,d0										; VRAM shift
		move.w	d0,(a2)+
	endr

		dbf	d2,.copy

		; check icon
		cmpi.w	#palette_line_1,d3
		bne.s	.skipi
		move.l	#words_to_long($253B,$253C),-(38*2)(a2)						; send icon data

.skipi

	if Options_VRAM<>0
		ori.w	#Options_VRAM,d3
	endif

		; check vertical line
		move.w	(Options_vertical_count).w,d0
		add.w	d0,d0
		add.w	d0,d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.w	.loadcharacter									; 0
		bra.s	.musicopt									; 4
		rts											; nop
		bra.s	.soundopt									; 8
		rts											; nop
		bra.s	.drawmusic									; C
		rts											; nop
		bra.s	.drawsound									; 10
		rts											; nop
		bra.s	.drawsample									; 14
		rts											; nop
		rts											; 18
		rts											; nop
; ---------------------------------------------------------------------------

.drawsample
		lea	(Options_buffer2+planeLoc(64,23,19)).l,a5
		move.w	(Options_sample_count).w,d0
		bra.s	.drawnumbers
; ---------------------------------------------------------------------------

.drawsound
		lea	(Options_buffer2+planeLoc(64,23,16)).l,a5
		move.w	(Options_sound_count).w,d0
		bra.s	.drawnumbers
; ---------------------------------------------------------------------------

.drawmusic
		lea	(Options_buffer2+planeLoc(64,23,13)).l,a5
		move.w	(Options_music_count).w,d0

.drawnumbers
		move.w	d0,d2
		move.w	d0,-(sp)									; division by $100
		move.b	(sp)+,d0
		bsr.s	.getnumber
		move.b	d2,d0
		lsr.b	#4,d0
		bsr.s	.getnumber
		move.b	d2,d0

.getnumber
		andi.w	#$F,d0
		cmpi.b	#10,d0										; is digit $A-$F?
		blo.s	.skipsymbols									; if not, branch
		addq.b	#6,d0										; use alpha characters

.skipsymbols
		addq.b	#1,d0
		add.w	d3,d0
		move.w	d0,(a5)+

.return
		rts

; ---------------------------------------------------------------------------
; Draw music (on/off)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.soundopt
		lea	(Options_buffer2+planeLoc(64,23,10)).l,a5
		lea	(Sound_disable_flag).w,a1
		bra.s	.main

; ---------------------------------------------------------------------------
; Draw music (on/off)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.musicopt
		lea	(Options_buffer2+planeLoc(64,23,7)).l,a5
		lea	(Music_disable_flag).w,a1

.main
		lea	Options_On(pc),a0
		tst.b	(a1)
		beq.s	.loadtext
		lea	Options_Off(pc),a0
		bra.s	.loadtext

; ---------------------------------------------------------------------------
; Draw character
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.loadcharacter
		lea	(Options_buffer2+planeLoc(64,23,4)).l,a5
		move.w	(Player_option).w,d0
		add.w	d0,d0
		lea	LevelSelect_LoadCharacterText1(pc),a0
		tst.b	(Graphics_flags).w								; check console region
		bmi.s	.notMiles
		lea	LevelSelect_LoadCharacterText2(pc),a0

.notMiles
		adda.w	(a0,d0.w),a0

.loadtext
		moveq	#0,d6
		move.b	(a0)+,d6

.tcopy
		moveq	#0,d0
		move.b	(a0)+,d0
		add.w	d3,d0
		move.w	d0,(a5)+
		dbf	d6,.tcopy
		rts

; ---------------------------------------------------------------------------
; Load text
; ---------------------------------------------------------------------------

		save
		codepage	OPTIONSCREEN

; =============== S U B R O U T I N E =======================================

Options_LoadText:
		lea	Options_MappingOffsets(pc),a0
		lea	(Options_buffer).l,a1
		lea	Options_Text(pc),a2

	if Options_VRAM=0
		moveq	#0,d3
	else
		move.w	#Options_VRAM,d3
	endif

		moveq	#Options_MaxCount-1,d1

.load
		moveq	#0,d2
		move.b	(a2)+,d2									; text size
		move.w	(a0)+,d0									; offset
		lea	(a1,d0.w),a3									; RAM shift

.copy
		moveq	#0,d0
		move.b	(a2)+,d0									; load letter
		add.w	d3,d0
		move.w	d0,(a3)+
		dbf	d2,.copy
		dbf	d1,.load

		; copy buffer
		lea	(Options_buffer).l,a1
		lea	Options_buffer2-Options_buffer(a1),a2
		moveq	#bytesToXcnt(($1000),8*4),d1

.bcopy

	rept 8
		move.l	(a1)+,(a2)+
	endr

		dbf	d1,.bcopy
		rts

		restore

; ---------------------------------------------------------------------------

; misc
Options_On:	optstr "ON"
Options_Off:	optstr "OFF"

; main text
Options_Text:
		optstr "     CHARACTER:      -"
		optstr "     GAME MUSIC:     -"
		optstr "     GAME SOUND:     -"
		optstr "     MUSIC TEST:     -"
		optstr "     SOUND TEST:     -"
		optstr "     SAMPLE TEST:    -"
		optstr "     EXIT"
	even

; =============== S U B R O U T I N E =======================================

PLC_Options: plrlistheader
		plreq 1, ArtKosPM_OptionsBG
		plreq $510, ArtKosPM_OptionsText
PLC_Options_end
