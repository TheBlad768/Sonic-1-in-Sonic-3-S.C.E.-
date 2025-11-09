; ---------------------------------------------------------------------------
; Level Select (Title)
; ---------------------------------------------------------------------------

; Constants
TitleLevelSelect_Offset:		= *
TitleLevelSelect_VRAM:			= $C50F

; Variables
TitleLevelSelect_MaxCount:		= 22
TitleLevelSelect_SpecialStageCount:	= 19
TitleLevelSelect_MaxSpecialStages:	= ChaosEmeralds_Count
TitleLevelSelect_MaxCharacters:		= 5
TitleLevelSelect_MaxMusicNumber:	= ((mus__Last-mus__First)-1) + ((sfx__Last-sfx__First)-1)

; RAM
	phase ramaddr(RAM_start)

TitleLevelSelect_buffer:		ds.b $1000							; background buffer (copy)
TitleLevelSelect_buffer2:		ds.b $1000							; background buffer (main)
TitleLevelSelect_buffer3:		ds.b $1000

	dephase

	phase ramaddr(Object_load_addr_front)

TitleLevelSelect_music_count:		ds.w 1
TitleLevelSelect_sound_count:		ds.w 1
TitleLevelSelect_sample_count:		ds.w 1
TitleLevelSelect_control_timer:		ds.w 1
TitleLevelSelect_saved_act:		ds.w 1
TitleLevelSelect_cheat_counter:		ds.w 1								; debug mode
TitleLevelSelect_cheat_counter2:	ds.w 1								; emeralds
TitleLevelSelect_vertical_count:	ds.w 1

	dephase
	!org	TitleLevelSelect_Offset

; =============== S U B R O U T I N E =======================================

TitleLevelSelectScreen:

		; clear
		clearRAM RAM_start, (RAM_start+$2000)							; clear foreground buffers
		clearRAM Object_RAM, Object_RAM_end							; clear the object RAM
		clearRAM Lag_frame_count, Lag_frame_count_end						; clear variables
		clearRAM Camera_RAM, Camera_RAM_end							; clear the camera RAM
		clearRAM H_scroll_buffer, V_scroll_buffer_end						; clear hvscroll buffer

		; clear
		move.l	d0,(V_scroll_value).w								; clear VScroll value
		move.l	d0,(H_scroll_value).w								; clear HScroll value

		; load text
		bsr.w	TitleLevelSelect_LoadText
		move.w	#palette_line_0+TitleLevelSelect_VRAM,d3
		bsr.w	TitleLevelSelect_MarkFields.drawss
		move.w	#palette_line_0+TitleLevelSelect_VRAM,d3
		bsr.w	TitleLevelSelect_MarkFields.drawmusic
		move.w	#palette_line_0+TitleLevelSelect_VRAM,d3
		bsr.w	TitleLevelSelect_MarkFields.drawplayer

		; we need to switch plans
		disableInts
		lea	(VDP_data_port).l,a6								; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5						; load VDP control address to a5

		; copy foreground buffer from VRAM to RAM
		lea	(TitleLevelSelect_buffer3).l,a1
		bsr.w	TitleLevelSelect_VRAMRead

		; clear title text
		moveq	#0,d0
		lea	-$4E8(a1),a1

	rept 7
		move.l	d0,(a1)+									; clear "Start Game"
	endr

		lea	$EC(a1),a1

	rept 4
		move.l	d0,(a1)+									; clear "Options"
	endr

		; send foreground buffer to background
		bsr.w	TitleLevelSelect_VRAMWrite

		; load main palette
		lea	(Pal_TitleLevelSelect).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line64).w

		; set
		move.l	#VInt_LevelSelect,(V_int_ptr).w							; set VInt pointer

.loop
		jsr	(Wait_VSync).w
		moveq	#palette_line_0,d3
		bsr.w	TitleLevelSelect_MarkFields
		bsr.w	TitleLevelSelect_Controls
		move.w	#palette_line_1,d3
		bsr.w	TitleLevelSelect_MarkFields
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop
		cmpi.w	#TitleLevelSelect_SpecialStageCount,(TitleLevelSelect_vertical_count).w
		bhi.s	.exit

		; set
		move.w	(Player_option).w,(Player_mode).w						; move selected character to active character
		move.b	#GameModeID_LevelSelectScreen,(Game_mode_last).w				; save current Game mode
		move.b	#3,(Life_count).w								; set life count
		move.l	#5000,(Next_extra_life_score).w

		; clear
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		move.b	d0,(Continue_count).w
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Apparent_zone_and_act).w

		; load
		cmpi.w	#TitleLevelSelect_SpecialStageCount,(TitleLevelSelect_vertical_count).w
		beq.s	.special

		; clear
		move.b	d0,(Current_special_stage).w

		; load zone and act
		move.b	#GameModeID_LevelScreen,(Game_mode).w						; set screen mode to Level
		move.w	(TitleLevelSelect_vertical_count).w,d2
		add.w	d2,d2
		move.w	.index(pc,d2.w),d2
		move.w	d2,(Current_zone_and_act).w
		move.w	d2,(Apparent_zone_and_act).w
		clr.b	(Current_special_stage).w

		; clear emeralds RAM
		lea	(Collected_emeralds_array).w,a1
		clr.l	(a1)+
		clr.l	(a1)+
		rts
; ---------------------------------------------------------------------------

.exit
		move.b	#GameModeID_TitleScreen,(Game_mode).w						; set screen mode to Title Screen
		rts
; ---------------------------------------------------------------------------

.special
		move.b	#GameModeID_SpecialStageScreen,(Game_mode).w					; set screen mode to Special Stage

		; clear emeralds RAM
		lea	(Collected_emeralds_array).w,a1
		clr.l	(a1)+
		clr.l	(a1)+
		rts
; ---------------------------------------------------------------------------

.index
		dc.w bytes_to_word(LevelID_GHZ,0)
		dc.w bytes_to_word(LevelID_GHZ,1)
		dc.w bytes_to_word(LevelID_GHZ,2)
		dc.w bytes_to_word(LevelID_MZ,0)
		dc.w bytes_to_word(LevelID_MZ,1)
		dc.w bytes_to_word(LevelID_MZ,2)
		dc.w bytes_to_word(LevelID_SYZ,0)
		dc.w bytes_to_word(LevelID_SYZ,1)
		dc.w bytes_to_word(LevelID_SYZ,2)
		dc.w bytes_to_word(LevelID_LZ,0)
		dc.w bytes_to_word(LevelID_LZ,1)
		dc.w bytes_to_word(LevelID_LZ,2)
		dc.w bytes_to_word(LevelID_SLZ,0)
		dc.w bytes_to_word(LevelID_SLZ,1)
		dc.w bytes_to_word(LevelID_SLZ,2)
		dc.w bytes_to_word(LevelID_SBZ,0)
		dc.w bytes_to_word(LevelID_SBZ,1)
		dc.w bytes_to_word(LevelID_LZ,3)
		dc.w bytes_to_word(LevelID_SBZ,2)

; ---------------------------------------------------------------------------
; Check vertical line
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

TitleLevelSelect_Controls:

		; set vertical line
		moveq	#TitleLevelSelect_MaxCount-1,d2
		move.w	(TitleLevelSelect_vertical_count).w,d3
		lea	(TitleLevelSelect_control_timer).w,a3
		bsr.w	Options_FindUpDownControls
		move.w	d3,(TitleLevelSelect_vertical_count).w

		; check vertical line
		subi.w	#TitleLevelSelect_SpecialStageCount,d3
		blo.s	.return
		add.w	d3,d3
		jmp	.index(pc,d3.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.getss										; 0
		bra.s	.getcharacter									; 2
		bra.s	.getmusic									; 4

; ---------------------------------------------------------------------------
; Load character
; ---------------------------------------------------------------------------

.getcharacter
		moveq	#TitleLevelSelect_MaxCharacters-1,d2						; set max count
		move.w	(Player_option).w,d3
		lea	(TitleLevelSelect_control_timer).w,a3
		bsr.w	Options_FindLeftRightControls
		move.w	d3,(Player_option).w

.return
		rts

; ---------------------------------------------------------------------------
; Load special stage
; ---------------------------------------------------------------------------

.getss
		moveq	#TitleLevelSelect_MaxSpecialStages-1,d2						; set max count
		moveq	#0,d3
		move.b	(Current_special_stage).w,d3
		lea	(TitleLevelSelect_control_timer).w,a3
		bsr.w	Options_FindLeftRightControls
		move.b	d3,(Current_special_stage).w
		rts

; ---------------------------------------------------------------------------
; Play music
; ---------------------------------------------------------------------------

.getmusic
		moveq	#TitleLevelSelect_MaxMusicNumber,d2						; set max count
		move.w	(TitleLevelSelect_music_count).w,d3
		lea	(TitleLevelSelect_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(TitleLevelSelect_music_count).w

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
		jsr	(Play_Music).w									; play music/sfx

		; get current music for cheats
		move.w	d3,d0

		; check debug mode cheat
		lea	LevelSelect_Code.dcodedat(pc),a1						; load cheat code
		lea	(TitleLevelSelect_cheat_counter).w,a2						; load cheat counter
		lea	LevelSelect_Code.debugcheat(pc),a3						; jmp to activation
		bsr.w	LevelSelect_Code								; branch to check cheat

		; check emeralds cheat
		lea	LevelSelect_Code.ecodedat(pc),a1						; load cheat code
		lea	(TitleLevelSelect_cheat_counter2).w,a2						; load cheat counter
		lea	LevelSelect_Code.emeraldcheat(pc),a3						; jmp to activation
		bra.w	LevelSelect_Code								; branch to check cheat
; --------------------------------------------------------------------------

.stop
		music	mus_Stop,1

; ---------------------------------------------------------------------------
; VRAM read buffer
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

TitleLevelSelect_VRAMRead:

		; copy buffer from VRAM to RAM
		moveq	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,READ),d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		moveq	#bytesToXcnt(($1000),8*4),d1

.bcopy

	rept 8
		move.l	VDP_data_port-VDP_data_port(a6),(a1)+
	endr

		dbf	d1,.bcopy
		rts

; ---------------------------------------------------------------------------
; VRAM write buffer
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

TitleLevelSelect_VRAMWrite:

		; copy buffer to VRAM
		stopZ80
		dma68kToVDP (TitleLevelSelect_buffer3),VRAM_Plane_B_Name_Table,VRAM_Plane_Table_Size,VRAM	; foreground buffer to VRAM
		startZ80
		rts

; ---------------------------------------------------------------------------
; Draw line and numbers
; ---------------------------------------------------------------------------

TitleLevelSelect_MappingOffsets:
		dc.w planeLoc(64,0,4)
		dc.w planeLoc(64,0,5)
		dc.w planeLoc(64,0,6)
		dc.w planeLoc(64,0,7)
		dc.w planeLoc(64,0,8)
		dc.w planeLoc(64,0,9)
		dc.w planeLoc(64,0,10)
		dc.w planeLoc(64,0,11)
		dc.w planeLoc(64,0,12)
		dc.w planeLoc(64,0,13)
		dc.w planeLoc(64,0,14)
		dc.w planeLoc(64,0,15)
		dc.w planeLoc(64,0,16)
		dc.w planeLoc(64,0,17)
		dc.w planeLoc(64,0,18)
		dc.w planeLoc(64,0,19)
		dc.w planeLoc(64,0,20)
		dc.w planeLoc(64,0,21)
		dc.w planeLoc(64,0,22)
		dc.w planeLoc(64,0,23)
		dc.w planeLoc(64,0,24)
		dc.w planeLoc(64,0,25)

; =============== S U B R O U T I N E =======================================

TitleLevelSelect_MarkFields:

		; get text pos
		move.w	(TitleLevelSelect_vertical_count).w,d0
		add.w	d0,d0
		move.w	TitleLevelSelect_MappingOffsets(pc,d0.w),d0

		; RAM shift
		lea	(TitleLevelSelect_buffer).l,a1
		lea	TitleLevelSelect_buffer2-TitleLevelSelect_buffer(a1),a2
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

	if TitleLevelSelect_VRAM<>0
		ori.w	#TitleLevelSelect_VRAM,d3
	endif

		; check vertical line
		moveq	#-TitleLevelSelect_SpecialStageCount,d0
		add.w	(TitleLevelSelect_vertical_count).w,d0
		bhs.s	.return
		add.w	d0,d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.drawss										; 0
		bra.s	.drawplayer									; 2

; ---------------------------------------------------------------------------
; Draw music
; ---------------------------------------------------------------------------

.drawmusic												; 4
		lea	(TitleLevelSelect_buffer2+planeLoc(64,25,25)).l,a5
		move.w	(TitleLevelSelect_music_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw player
; ---------------------------------------------------------------------------

.drawplayer
		lea	(TitleLevelSelect_buffer2+planeLoc(64,25,24)).l,a5
		move.w	(Player_option).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw special stage
; ---------------------------------------------------------------------------

.drawss
		lea	(TitleLevelSelect_buffer2+planeLoc(64,25,23)).l,a5
		moveq	#1,d0
		add.b	(Current_special_stage).w,d0

.drawnumbers
		move.b	d0,d2
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
; Load text
; ---------------------------------------------------------------------------

		save
		codepage	OPTIONSCREEN

TitleLevelSelect_MappingOffsets2:
		dc.w planeLoc(64,9,4)
		dc.w planeLoc(64,26,5)
		dc.w planeLoc(64,26,6)
		dc.w planeLoc(64,9,7)
		dc.w planeLoc(64,26,8)
		dc.w planeLoc(64,26,9)
		dc.w planeLoc(64,9,10)
		dc.w planeLoc(64,26,11)
		dc.w planeLoc(64,26,12)
		dc.w planeLoc(64,9,13)
		dc.w planeLoc(64,26,14)
		dc.w planeLoc(64,26,15)
		dc.w planeLoc(64,9,16)
		dc.w planeLoc(64,26,17)
		dc.w planeLoc(64,26,18)
		dc.w planeLoc(64,9,19)
		dc.w planeLoc(64,26,20)
		dc.w planeLoc(64,26,21)
		dc.w planeLoc(64,9,22)
		dc.w planeLoc(64,9,23)
		dc.w planeLoc(64,9,24)
		dc.w planeLoc(64,9,25)

; =============== S U B R O U T I N E =======================================

TitleLevelSelect_LoadText:
		lea	TitleLevelSelect_MappingOffsets2(pc),a0
		lea	(TitleLevelSelect_buffer).l,a1
		lea	TitleLevelSelect_Text(pc),a2

	if TitleLevelSelect_VRAM=0
		moveq	#0,d3
	else
		move.w	#TitleLevelSelect_VRAM,d3
	endif

		moveq	#TitleLevelSelect_MaxCount-1,d1

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
		lea	(TitleLevelSelect_buffer).l,a1
		lea	TitleLevelSelect_buffer2-TitleLevelSelect_buffer(a1),a2
		moveq	#bytesToXcnt(($1000),8*4),d1

.bcopy

	rept 8
		move.l	(a1)+,(a2)+
	endr

		dbf	d1,.bcopy
		rts

		restore

; ---------------------------------------------------------------------------

; main text
TitleLevelSelect_Text:
		optstr "GREEN HILL ZONE  STAGE 1"
		optstr "STAGE 2"
		optstr "STAGE 3"
		optstr "MARBLE ZONE      STAGE 1"
		optstr "STAGE 2"
		optstr "STAGE 3"
		optstr "SPRING YARD ZONE STAGE 1"
		optstr "STAGE 2"
		optstr "STAGE 3"
		optstr "LABYRINTH ZONE   STAGE 1"
		optstr "STAGE 2"
		optstr "STAGE 3"
		optstr "STAR LIGHT ZONE  STAGE 1"
		optstr "STAGE 2"
		optstr "STAGE 3"
		optstr "SCRAP BRAIN ZONE STAGE 1"
		optstr "STAGE 2"
		optstr "STAGE 3"
		optstr "FINAL ZONE"
		optstr "SPECIAL STAGE"
		optstr "PLAYER SELECT"
		optstr "SOUND SELECT"
	even
