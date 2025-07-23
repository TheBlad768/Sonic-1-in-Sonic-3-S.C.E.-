; ---------------------------------------------------------------------------
; Level Select (RSDK)
; ---------------------------------------------------------------------------

; Constants
LevelSelectRSDK_Offset:			= *
LevelSelectRSDK_VRAM:			= 0

LevelSelectRSDK_SpecialStageCount:	= 19
LevelSelectRSDK_CharacterCount:		= LevelSelectRSDK_SpecialStageCount+1
LevelSelectRSDK_MusicTestCount:		= LevelSelectRSDK_CharacterCount+1
LevelSelectRSDK_SoundTestCount:		= LevelSelectRSDK_MusicTestCount+1
LevelSelectRSDK_SampleTestCount:	= LevelSelectRSDK_SoundTestCount+1

LevelSelectRSDK_MaxCount:		= 12
LevelSelectRSDK_MaxCharacters:		= 5
LevelSelectRSDK_MaxMusicNumber:		= (mus__Last-mus__First)
LevelSelectRSDK_MaxSoundNumber:		= (sfx__Last-sfx__First)
LevelSelectRSDK_MaxSampleNumber:	= (dac__Last-dac__First)

; RAM
	phase ramaddr(RAM_start)

LevelSelectRSDK_buffer:			ds.b $1000							; foreground buffer (copy)
LevelSelectRSDK_buffer2:		ds.b $1000							; foreground buffer (main)

	dephase

	phase ramaddr(Object_load_addr_front)

LevelSelectRSDK_music_count:		ds.w 1
LevelSelectRSDK_sound_count:		ds.w 1
LevelSelectRSDK_sample_count:		ds.w 1
LevelSelectRSDK_control_timer:		ds.w 1
LevelSelectRSDK_saved_act:		ds.w 1
LevelSelectRSDK_cheat_counter:		ds.w 1								; debug mode
LevelSelectRSDK_cheat_counter2:		ds.w 1								; emeralds
LevelSelectRSDK_vertical_count:		ds.w 1
LevelSelectRSDK_vertical_count_prev:	ds.w 1

	dephase
	!org	LevelSelectRSDK_Offset

; =============== S U B R O U T I N E =======================================

LevelSelectRSDKScreen:
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
		move.w	#$8700+(0<<4),VDP_control_port-VDP_control_port(a6)				; set background colour (line 0; colour 0)
		jsr	(Clear_Palette).w
		clearRAM RAM_start, (RAM_start+$2000)							; clear foreground buffers
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
		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w

		; set
		move.w	#-1,(LevelSelectRSDK_vertical_count_prev).w

		; load main art
		lea	PLC_LevelSelectRSDK(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load BG mapping
		EniDecomp	MapEni_LevelSelectRSDKBG, RAM_start+$2000, $60, 0, 0			; decompress Enigma mappings
		copyTilemap	VRAM_Plane_B_Name_Table, 320, 224

		; load icons mapping
		EniDecomp	MapEni_LevelSelectRSDKIcons, RAM_start+$2000, 0, 0, 0			; decompress Enigma mappings

		; load icon
		lea	(LevelSelectRSDK_buffer+$AB0).l,a2
		copyTilemapToRAM	80, 48, $80

		; load text
		bsr.w	LevelSelectRSDK_LoadText
		move.w	#palette_line_1,d3
		bsr.w	LevelSelectRSDK_MarkFields
		move.w	#palette_line_0+LevelSelectRSDK_VRAM,d3
		bsr.w	LevelSelectRSDK_MarkFields.drawplayer
		move.w	#palette_line_0+LevelSelectRSDK_VRAM,d3
		bsr.w	LevelSelectRSDK_MarkFields.drawmusic
		move.w	#palette_line_0+LevelSelectRSDK_VRAM,d3
		bsr.w	LevelSelectRSDK_MarkFields.drawsound
		move.w	#palette_line_0+LevelSelectRSDK_VRAM,d3
		bsr.w	LevelSelectRSDK_MarkFields.drawsample

		; load main palette
		lea	(Pal_LevelSelectRSDK).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line32).w

.waitplc
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; update icon
		lea	(Target_palette_line_3).w,a2
		bsr.w	LevelSelectRSDK_UpdateIcons

		; set
		music	mus_Menu									; play music

		; next
		move.b	#VintID_LevelSelect,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		move.b	#VintID_LevelSelect,(V_int_routine).w
		jsr	(Wait_VSync).w
		moveq	#palette_line_0,d3
		bsr.w	LevelSelectRSDK_MarkFields
		bsr.w	LevelSelectRSDK_Controls
		move.w	#palette_line_1,d3
		bsr.w	LevelSelectRSDK_MarkFields
		lea	(Normal_palette_line_3).w,a2
		bsr.w	LevelSelectRSDK_UpdateIcons
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop
		cmpi.w	#LevelSelectRSDK_SpecialStageCount,(LevelSelectRSDK_vertical_count).w
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
		cmpi.w	#LevelSelectRSDK_SpecialStageCount,(LevelSelectRSDK_vertical_count).w
		beq.s	.special

		; clear
		move.b	d0,(Current_special_stage).w

		; load zone and act
		move.b	#GameModeID_LevelScreen,(Game_mode).w						; set screen mode to Level
		move.w	(LevelSelectRSDK_vertical_count).w,d2
		add.w	d2,d2
		lea	TitleLevelSelectScreen.index(pc),a0
		move.w	(a0,d2.w),d2
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

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_Controls:

		; set vertical line
		moveq	#24-1,d2									; set max count
		move.w	(LevelSelectRSDK_vertical_count).w,d3
		lea	(LevelSelectRSDK_control_timer).w,a3
		bsr.w	Options_FindUpDownControls
		move.w	d3,(LevelSelectRSDK_vertical_count).w

		; check vertical line
		subi.w	#LevelSelectRSDK_SpecialStageCount+1,d3
		blo.w	LevelSelectRSDK_SwitchSide
		add.w	d3,d3
		jmp	.index(pc,d3.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.getcharacter									; 0
		bra.s	.getmusic									; 2
		bra.s	.getsound									; 4

; ---------------------------------------------------------------------------
; Play sample
; ---------------------------------------------------------------------------

		; get sample										; 6
		moveq	#LevelSelectRSDK_MaxSampleNumber,d2						; set max count
		move.w	(LevelSelectRSDK_sample_count).w,d3
		lea	(LevelSelectRSDK_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelectRSDK_sample_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return

		; play sample
		move.w	d3,d0
		addi.w	#dac__First,d0									; $00 is reserved for pause
		jmp	(Play_Sample).w									; play sample

; ---------------------------------------------------------------------------
; Load Character
; ---------------------------------------------------------------------------

.getcharacter
		moveq	#LevelSelectRSDK_MaxCharacters-1,d2						; set max count
		move.w	(Player_option).w,d3
		lea	(LevelSelectRSDK_control_timer).w,a3
		bsr.w	Options_FindLeftRightControls
		move.w	d3,(Player_option).w

.return
		rts

; ---------------------------------------------------------------------------
; Play sound
; ---------------------------------------------------------------------------

.getsound
		moveq	#LevelSelectRSDK_MaxSoundNumber,d2						; set max count
		move.w	(LevelSelectRSDK_sound_count).w,d3
		lea	(LevelSelectRSDK_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelectRSDK_sound_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	LevelSelectRSDK_SwitchSide.return

		; play sfx
		move.w	d3,d0
		addi.w	#sfx__First,d0									; $00 is reserved for silence
		jmp	(Play_SFX).w									; play sfx

; ---------------------------------------------------------------------------
; Play music
; ---------------------------------------------------------------------------

.getmusic
		moveq	#LevelSelectRSDK_MaxMusicNumber,d2						; set max count
		move.w	(LevelSelectRSDK_music_count).w,d3
		lea	(LevelSelectRSDK_control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelectRSDK_music_count).w

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
		jsr	(Play_Music).w									; play music

		; get current music for cheats
		move.w	d3,d0

		; check debug mode cheat
		lea	LevelSelect_Code.dcodedat(pc),a1						; load cheat code
		lea	(LevelSelectRSDK_cheat_counter).w,a2						; load cheat counter
		lea	LevelSelect_Code.debugcheat(pc),a3						; jmp to activation
		bsr.w	LevelSelect_Code								; branch to check cheat

		; check emeralds cheat
		lea	LevelSelect_Code.ecodedat(pc),a1						; load cheat code
		lea	(LevelSelectRSDK_cheat_counter2).w,a2						; load cheat counter
		lea	LevelSelect_Code.emeraldcheat(pc),a3						; jmp to activation
		bra.w	LevelSelect_Code								; branch to check cheat
; --------------------------------------------------------------------------

.stop
		music	mus_Stop,1

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_SwitchSide:
		moveq	#btnLR,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return
		move.w	(LevelSelectRSDK_vertical_count).w,d0
		move.b	.table(pc,d0.w),(LevelSelectRSDK_vertical_count+1).w
		sfx	sfx_Switch,1
; ---------------------------------------------------------------------------

.return
		rts
; ---------------------------------------------------------------------------

.table
		dc.b $F		; 0
		dc.b $10	; 1
		dc.b $11	; 2
		dc.b $12	; 3
		dc.b $12	; 4
		dc.b $13	; 5
		dc.b $13	; 6
		dc.b $14	; 7
		dc.b $14	; 8
		dc.b $15	; 9
		dc.b $15	; A
		dc.b $16	; B
		dc.b $17	; C
		dc.b $17	; D
		dc.b $17	; E
		dc.b 0		; F
		dc.b 1		; 10
		dc.b 2		; 11
		dc.b 3		; 12
		dc.b 5		; 13
		dc.b 8		; 14
		dc.b 9		; 15
		dc.b $B		; 16
		dc.b $C		; 17
	even

; ---------------------------------------------------------------------------
; Load icons
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_UpdateIcons:

		; check
		moveq	#0,d1										; is used to load art
		move.w	(LevelSelectRSDK_vertical_count).w,d1
		cmp.w	(LevelSelectRSDK_vertical_count_prev).w,d1
		beq.s	LevelSelectRSDK_SwitchSide.return
		move.w	d1,(LevelSelectRSDK_vertical_count_prev).w

		; load palette
		add.w	d1,d1
		add.w	d1,d1
		lea	(Pal_LevelSelectRSDKIcons).l,a1
		adda.w	.table(pc,d1.w),a1
		jsr	(PalLoad_Line16).w

		; load art
		move.w	.table+2(pc,d1.w),d1
		addi.l	#dmaSource(ArtUnc_LevelSelectRSDKIcons),d1					; get next frame
		move.w	#tiles_to_bytes($50),d2								; load art destination

		; size of art (in words) ; we only need one frame
		move.w	#tiles_to_bytes( \
		dmaLength(12) \
		),d3

		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

.table

		; palette, art
		setRSDKIcons 2, 2	; GHZ1
		setRSDKIcons 2, 2	; GHZ2
		setRSDKIcons 2, 2	; GHZ3
		setRSDKIcons 3, 3	; MZ1
		setRSDKIcons 3, 3	; MZ2
		setRSDKIcons 3, 3	; MZ3
		setRSDKIcons 4, 4	; SYZ1
		setRSDKIcons 4, 4	; SYZ2
		setRSDKIcons 4, 4	; SYZ3
		setRSDKIcons 5, 5	; LZ1
		setRSDKIcons 5, 5	; LZ2
		setRSDKIcons 5, 5	; LZ3
		setRSDKIcons 6, 6	; SLZ1
		setRSDKIcons 6, 6	; SLZ2
		setRSDKIcons 6, 6	; SLZ3
		setRSDKIcons 7, 7	; SBZ1
		setRSDKIcons 8, 8	; SBZ2
		setRSDKIcons 9, 5	; SBZ3
		setRSDKIcons 10, 9	; FZ
		setRSDKIcons 11, 10	; Special Stage
		setRSDKIcons 1, 1	; Player (options)
		setRSDKIcons 0, 0	; Music Test
		setRSDKIcons 0, 0	; Sound Test
		setRSDKIcons 0, 0	; Sample Test

; ---------------------------------------------------------------------------
; Draw line and numbers
; ---------------------------------------------------------------------------

LevelSelectRSDK_MappingOffsets2:
		dc.w planeLoc(64,1,2), planeLoc(64,15,2)	; GHZ1
		dc.w planeLoc(64,1,2), planeLoc(64,15,3)	; GHZ2
		dc.w planeLoc(64,1,2), planeLoc(64,15,4)	; GHZ3
		dc.w planeLoc(64,1,6), planeLoc(64,15,6)	; MZ1
		dc.w planeLoc(64,1,6), planeLoc(64,15,7)	; MZ2
		dc.w planeLoc(64,1,6), planeLoc(64,15,8)	; MZ3
		dc.w planeLoc(64,1,10), planeLoc(64,15,10)	; SYZ1
		dc.w planeLoc(64,1,10), planeLoc(64,15,11)	; SYZ2
		dc.w planeLoc(64,1,10), planeLoc(64,15,12)	; SYZ3
		dc.w planeLoc(64,1,14), planeLoc(64,15,14)	; LZ1
		dc.w planeLoc(64,1,14), planeLoc(64,15,15)	; LZ2
		dc.w planeLoc(64,1,14), planeLoc(64,15,16)	; LZ3
		dc.w planeLoc(64,1,18), planeLoc(64,15,18)	; SLZ1
		dc.w planeLoc(64,1,18), planeLoc(64,15,19)	; SLZ2
		dc.w planeLoc(64,1,18), planeLoc(64,15,20)	; SLZ3
		dc.w planeLoc(64,22,2), planeLoc(64,36,2)	; SBZ1
		dc.w planeLoc(64,22,2), planeLoc(64,36,3)	; SBZ2
		dc.w planeLoc(64,22,2), planeLoc(64,36,4)	; SBZ3
		dc.w planeLoc(64,23,6), 0			; FZ
		dc.w planeLoc(64,23,8), 0			; Special Stage
		dc.w planeLoc(64,20,12), 0			; Player (options)
		dc.w planeLoc(64,20,14), 0			; Music Test
		dc.w planeLoc(64,20,16), 0			; Sound Test
		dc.w planeLoc(64,20,18), 0			; Sample Test

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_MarkFields:

		; highlight name zone
		lea	(LevelSelectRSDK_buffer).l,a1
		lea	LevelSelectRSDK_buffer2-LevelSelectRSDK_buffer(a1),a2
		lea	LevelSelectRSDK_buffer-LevelSelectRSDK_buffer(a1),a3

		; get text pos
		move.w	(LevelSelectRSDK_vertical_count).w,d0
		move.w	d0,d4
		add.w	d0,d0
		add.w	d0,d0
		movem.w	LevelSelectRSDK_MappingOffsets2(pc,d0.w),d0-d1					; get name and act pos

		; RAM shift
		adda.w	d0,a1
		adda.w	d0,a2

		; load line
		moveq	#bytesToXcnt(12,4),d2
		cmpi.w	#$13+1,d4									; is options?
		blo.s	.copy										; if not, branch
		moveq	#bytesToXcnt(16,4),d2

.copy

	rept 4
		move.w	(a1)+,d0
		add.w	d3,d0										; VRAM shift
		move.w	d0,(a2)+
	endr

		dbf	d2,.copy

		; last letter
		move.w	(a1)+,d0
		add.w	d3,d0										; VRAM shift
		move.w	d0,(a2)+

		; check options
		cmpi.w	#$13-1,d4									; is options?
		bhs.s	.options									; if yes, branch

		; highlight act number
		lea	LevelSelectRSDK_buffer-LevelSelectRSDK_buffer(a3),a1
		lea	LevelSelectRSDK_buffer2-LevelSelectRSDK_buffer(a1),a2

		; get text pos
		move.w	(a1,d1.w),d0
		add.w	d3,d0										; VRAM shift
		move.w	d0,(a2,d1.w)

.options

	if LevelSelectRSDK_VRAM<>0
		ori.w	#LevelSelectRSDK_VRAM,d3
	endif

		; check vertical line
		moveq	#-(LevelSelectRSDK_SpecialStageCount+1),d0
		add.w	(LevelSelectRSDK_vertical_count).w,d0
		bhs.s	.return
		add.w	d0,d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.drawplayer									; 0
		bra.s	.drawmusic									; 2
		bra.s	.drawsound									; 4

; ---------------------------------------------------------------------------
; Draw sample
; ---------------------------------------------------------------------------

.drawsample												; 6
		lea	(LevelSelectRSDK_buffer2+planeLoc(64,34,18)).l,a5
		move.w	(LevelSelectRSDK_sample_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw player
; ---------------------------------------------------------------------------

.drawplayer
		lea	(LevelSelectRSDK_buffer2+planeLoc(64,34,12)).l,a5
		move.w	(Player_option).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw sound
; ---------------------------------------------------------------------------

.drawsound
		lea	(LevelSelectRSDK_buffer2+planeLoc(64,34,16)).l,a5
		move.w	(LevelSelectRSDK_sound_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw music
; ---------------------------------------------------------------------------

.drawmusic
		lea	(LevelSelectRSDK_buffer2+planeLoc(64,34,14)).l,a5
		move.w	(LevelSelectRSDK_music_count).w,d0

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

LevelSelectRSDK_MappingOffsets:
		dc.w planeLoc(64,4,2)		; GHZ
		dc.w planeLoc(64,8,6)		; MZ
		dc.w planeLoc(64,3,10)		; SYZ
		dc.w planeLoc(64,5,14)		; LZ
		dc.w planeLoc(64,4,18)		; SLZ
		dc.w planeLoc(64,24,2)		; SBZ
		dc.w planeLoc(64,31,6)		; FZ
		dc.w planeLoc(64,23,8)		; Special Stage
		dc.w planeLoc(64,20,12)		; Player (options)
		dc.w planeLoc(64,20,14)		; Music Test
		dc.w planeLoc(64,20,16)		; Sound Test
		dc.w planeLoc(64,20,18)		; Sample Test

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_LoadText:
		lea	LevelSelectRSDK_MappingOffsets(pc),a0
		lea	(LevelSelectRSDK_buffer).l,a1
		lea	LevelSelectRSDK_MainText(pc),a2

	if LevelSelectRSDK_VRAM=0
		moveq	#0,d3
	else
		move.w	#LevelSelectRSDK_VRAM,d3
	endif

		moveq	#LevelSelectRSDK_MaxCount-1,d1

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

		; set act numbers
		lea	(LevelSelectRSDK_buffer+$11E).l,a1
		moveq	#5-1,d1										; (GHZ-SLZ)

.nload
		moveq	#'1',d0										; write (act) '1'
		add.w	d3,d0
		move.w	d0,(a1)
		moveq	#'2',d0										; write (act) '2'
		add.w	d3,d0
		move.w	d0,$80(a1)
		moveq	#'3',d0										; write (act) '3'
		add.w	d3,d0
		move.w	d0,$100(a1)
		lea	$200(a1),a1									; next line
		dbf	d1,.nload

		; SBZ
		moveq	#'1',d0										; write (act) '1'
		add.w	d3,d0
		move.w	d0,-$9D6(a1)
		moveq	#'2',d0										; write (act) '2'
		add.w	d3,d0
		move.w	d0,-$956(a1)
		moveq	#'3',d0										; write (act) '3'
		add.w	d3,d0
		move.w	d0,-$8D6(a1)

		; copy buffer
		lea	(LevelSelectRSDK_buffer).l,a1
		lea	LevelSelectRSDK_buffer2-LevelSelectRSDK_buffer(a1),a2
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
LevelSelectRSDK_MainText:
		optstr "GREEN HILL"
		optstr "MARBLE"
		optstr "SPRING YARD"
		optstr "LABYRINTH"
		optstr "STAR LIGHT"
		optstr "SCRAP BRAIN"
		optstr "FINAL"
		optstr "SPECIAL STAGE"
		optstr "PLAYER       *  *"
		optstr "MUSIC TEST   *  *"
		optstr "SOUND TEST   *  *"
		optstr "SAMPLE TEST  *  *"
	even

; =============== S U B R O U T I N E =======================================

PLC_LevelSelectRSDK: plrlistheader
		plreq 1, ArtKosPM_OptionsText
		plreq $30, ArtKosPM_LevelSelectRSDKIcons
		plreq $60, ArtKosPM_LevelSelectRSDKBG
PLC_LevelSelectRSDK_end
