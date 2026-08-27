; ---------------------------------------------------------------------------
; Level Select (RSDK)
; ---------------------------------------------------------------------------

; Constants
LevelSelectRSDK.VRAM =					0

LevelSelectRSDK.SpecialStageCount =			19
LevelSelectRSDK.CharacterCount =			LevelSelectRSDK.SpecialStageCount+1
LevelSelectRSDK.MusicTestCount =			LevelSelectRSDK.CharacterCount+1
LevelSelectRSDK.SoundTestCount =			LevelSelectRSDK.MusicTestCount+1
LevelSelectRSDK.SampleTestCount =			LevelSelectRSDK.SoundTestCount+1

LevelSelectRSDK.MaxCount =				12
LevelSelectRSDK.MaxCharacters =				5
LevelSelectRSDK.MaxMusicNumber =			(mus__End-mus__First)-1
LevelSelectRSDK.MaxSoundNumber =			(sfx__End-sfx__First)-1
LevelSelectRSDK.MaxSampleNumber =			$10

; RAM

	dsset ramaddr(RAM_start)							; pretend we're in the RAM

LevelSelectRSDK.buffer					ds.b $1000			; foreground buffer (copy)
LevelSelectRSDK.buffer2					ds.b $1000			; foreground buffer (main)

	dsreset										; stop pretending and reset the program counter

	dsset ramaddr(Object_load_addr_front)						; pretend we're in the RAM

LevelSelectRSDK.music_count				ds.w 1
LevelSelectRSDK.sound_count				ds.w 1
LevelSelectRSDK.sample_count				ds.w 1
LevelSelectRSDK.control_timer				ds.w 1
LevelSelectRSDK.saved_act				ds.w 1
LevelSelectRSDK.cheat_counter				ds.w 1				; debug mode
LevelSelectRSDK.cheat_counter2				ds.w 1				; emeralds
LevelSelectRSDK.vertical_count				ds.w 1
LevelSelectRSDK.vertical_count_prev			ds.w 1

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

LevelSelectRSDKScreen:
		music	cmd_Stop							; stop music
		jsr	(Clear_KosPlus_Module_Queue).w					; clear KosPlusM PLCs
		ResetDMAQueue								; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableDisplay
		jsr	(Clear_DisplayData).w
		lea	Level_VDP(pc),a1
		jsr	(Load_VDP).w
		move.w	#$8700+(0<<4),VDP_control_port-VDP_control_port(a6)		; set background color (line 0; color 0)
		jsr	(Clear_Palette).w
		clearRAM RAM_start, (RAM_start+$2000)					; clear foreground buffers
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
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Apparent_zone_and_act).w
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Special_bonus_entry_flag).w
		move.b	d0,(Intro_flag).w
		move.b	d0,(Debug_mode_flag).w
		move.b	d0,(Demo_mode_flag).w

		; set
		move.w	#-1,(LevelSelectRSDK.vertical_count_prev).w

		; load main art
		lea	PLC_LevelSelectRSDK(pc),a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load BG mapping
		EniDecomp	MapEni_LevelSelectRSDKBG, LevelSelectRSDK.buffer2, $60, 0, FALSE	; decompress Enigma mappings
		copyTilemap	VRAM_Plane_B_Name_Table, 320, 224

		; load icons mapping
		EniDecomp	MapEni_LevelSelectRSDKIcons, LevelSelectRSDK.buffer2, 0, 0, FALSE	; decompress Enigma mappings
		lea	(LevelSelectRSDK.buffer+planeLoc(64,24,21)).l,a2
		copyTilemapToRAM	80, 48, $80

		; load icon art
		QueueKosPlus	ArtKosPlus_LevelSelectRSDKIcons, LevelSelectRSDK.buffer2

		; load text
		bsr.w	LevelSelectRSDK_LoadText
		move.w	#make_art_tile(0,1,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields
		mvq	make_art_tile(LevelSelectRSDK.VRAM,0,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields.drawplayer
		mvq	make_art_tile(LevelSelectRSDK.VRAM,0,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields.drawmusic
		mvq	make_art_tile(LevelSelectRSDK.VRAM,0,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields.drawsound
		mvq	make_art_tile(LevelSelectRSDK.VRAM,0,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields.drawsample

		; load main palette
		lea	(Pal_LevelSelectRSDK).l,a1
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

		; update icon
		lea	(Target_palette_line_3).w,a2
		bsr.w	LevelSelectRSDK_UpdateIcons

		; set
		music	mus_Menu							; play music

		; next
		move.l	#VInt_LevelSelect,(V_int_ptr).w					; set VInt pointer
		jsr	(Wait_VSync).w
		enableDisplay
		jsr	(Pal_FadeFromBlack).w

.loop
		jsr	(Wait_VSync).w

		; update text
		moveq	#make_art_tile(0,0,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields
		bsr.w	LevelSelectRSDK_Controls
		move.w	#make_art_tile(0,1,FALSE),d3
		bsr.w	LevelSelectRSDK_MarkFields
		lea	(Normal_palette_line_3).w,a2
		bsr.w	LevelSelectRSDK_UpdateIcons

		; check exit
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop
		cmpi.w	#LevelSelectRSDK.SpecialStageCount,(LevelSelectRSDK.vertical_count).w
		bhi.s	.exit

		; set
		move.w	(Player_option).w,(Player_mode).w				; move selected character to active character
		move.b	#GameModeID_LevelSelectScreen,(Game_mode_last).w		; save current Game mode
		move.b	#3,(Life_count).w						; set life count
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
		cmpi.w	#LevelSelectRSDK.SpecialStageCount,(LevelSelectRSDK.vertical_count).w
		beq.s	.special

		; clear
		move.b	d0,(Current_special_stage).w

		; load zone and act
		move.b	#GameModeID_LevelScreen,(Game_mode).w				; set screen mode to Level
		move.w	(LevelSelectRSDK.vertical_count).w,d2
		add.w	d2,d2								; multiply by 2
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
		move.b	#GameModeID_TitleScreen,(Game_mode).w				; set screen mode to Title Screen
		rts
; ---------------------------------------------------------------------------

.special
		move.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; set screen mode to Special Stage

		; clear emeralds RAM
		lea	(Collected_emeralds_array).w,a1
		clr.l	(a1)+
		clr.l	(a1)+
		rts

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_Controls:

		; set vertical line
		moveq	#24-1,d2							; set max count
		move.w	(LevelSelectRSDK.vertical_count).w,d3
		lea	(LevelSelectRSDK.control_timer).w,a3
		bsr.w	Options_FindUpDownControls
		move.w	d3,(LevelSelectRSDK.vertical_count).w

		; check vertical line
		subi.w	#LevelSelectRSDK.SpecialStageCount+1,d3
		blo.w	LevelSelectRSDK_SwitchSide
		add.w	d3,d3								; multiply by 2
		jmp	.index(pc,d3.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.getcharacter							; 0
		bra.s	.getmusic							; 2
		bra.s	.getsound							; 4

; ---------------------------------------------------------------------------
; Play sample
; ---------------------------------------------------------------------------

		; get sample								; 6
		moveq	#LevelSelectRSDK.MaxSampleNumber,d2				; set max count
		move.w	(LevelSelectRSDK.sample_count).w,d3
		lea	(LevelSelectRSDK.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelectRSDK.sample_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return

		; play sample
		move.w	d3,d0
		addq.w	#1,d0								; $00 is reserved for pause
		jmp	(Play_Sample).w							; play sample

; ---------------------------------------------------------------------------
; Load Character
; ---------------------------------------------------------------------------

.getcharacter
		moveq	#LevelSelectRSDK.MaxCharacters-1,d2				; set max count
		move.w	(Player_option).w,d3
		lea	(LevelSelectRSDK.control_timer).w,a3
		bsr.w	Options_FindLeftRightControls
		move.w	d3,(Player_option).w

.return
		rts

; ---------------------------------------------------------------------------
; Play sound
; ---------------------------------------------------------------------------

.getsound
		moveq	#LevelSelectRSDK.MaxSoundNumber,d2				; set max count
		move.w	(LevelSelectRSDK.sound_count).w,d3
		lea	(LevelSelectRSDK.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelectRSDK.sound_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	LevelSelectRSDK_SwitchSide.return

		; play sfx
		move.w	d3,d0
		addq.w	#sfx__First,d0							; $00 is reserved for silence
		jmp	(Play_SFX).w							; play sfx

; ---------------------------------------------------------------------------
; Play music
; ---------------------------------------------------------------------------

.getmusic
		moveq	#LevelSelectRSDK.MaxMusicNumber,d2				; set max count
		move.w	(LevelSelectRSDK.music_count).w,d3
		lea	(LevelSelectRSDK.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelectRSDK.music_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return

		; check stop music
		btst	#button_B,d1
		bne.s	.stop								; branch if B is pressed

		; play music
		move.w	d3,d0
		addq.w	#mus__First,d0							; $00 is reserved for silence
		jsr	(Play_Music).w							; play music

		; get current music for cheats
		move.w	d3,d0

		; check debug mode cheat
		lea	LevelSelect_Code.dcodedat(pc),a1				; load cheat code
		lea	(LevelSelectRSDK.cheat_counter).w,a2				; load cheat counter
		lea	LevelSelect_Code.debugcheat(pc),a3				; jmp to activation
		bsr.w	LevelSelect_Code						; branch to check cheat

		; check emeralds cheat
		lea	LevelSelect_Code.ecodedat(pc),a1				; load cheat code
		lea	(LevelSelectRSDK.cheat_counter2).w,a2				; load cheat counter
		lea	LevelSelect_Code.emeraldcheat(pc),a3				; jmp to activation
		bra.w	LevelSelect_Code						; branch to check cheat
; --------------------------------------------------------------------------

.stop
		music	cmd_Stop,1

; =============== S U B R O U T I N E =======================================

LevelSelectRSDK_SwitchSide:
		moveq	#btnLR,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return
		move.w	(LevelSelectRSDK.vertical_count).w,d0
		move.b	.table(pc,d0.w),(LevelSelectRSDK.vertical_count+1).w
		sfx	sfx_Switch, 1
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
		moveq	#0,d1								; is used to load art
		move.w	(LevelSelectRSDK.vertical_count).w,d1
		cmp.w	(LevelSelectRSDK.vertical_count_prev).w,d1
		beq.s	LevelSelectRSDK_SwitchSide.return
		move.w	d1,(LevelSelectRSDK.vertical_count_prev).w

		; load palette
		add.w	d1,d1								; multiply by 4
		add.w	d1,d1
		lea	(Pal_LevelSelectRSDKIcons).l,a1
		adda.w	.table(pc,d1.w),a1
		jsr	(PalLoad_Line16).w

		; load art
		move.w	.table+2(pc,d1.w),d1
		addi.l	#dmaSource(LevelSelectRSDK.buffer2),d1				; get next frame
		move.w	#tiles_to_bytes($50),d2						; load art destination

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
		lea	(LevelSelectRSDK.buffer).l,a1
		lea	LevelSelectRSDK.buffer2-LevelSelectRSDK.buffer(a1),a2
		lea	LevelSelectRSDK.buffer-LevelSelectRSDK.buffer(a1),a3

		; get text pos
		move.w	(LevelSelectRSDK.vertical_count).w,d0
		move.w	d0,d4
		add.w	d0,d0								; multiply by 4
		add.w	d0,d0
		movem.w	LevelSelectRSDK_MappingOffsets2(pc,d0.w),d0-d1			; get name and act pos

		; RAM shift
		adda.w	d0,a1
		adda.w	d0,a2

		; load line
		moveq	#bytesToXcnt(12,4),d2
		cmpi.w	#$13+1,d4							; is options?
		blo.s	.copy								; if not, branch
		moveq	#bytesToXcnt(16,4),d2

.copy

	rept 4
		move.w	(a1)+,d0
		add.w	d3,d0								; VRAM shift
		move.w	d0,(a2)+
	endr

		dbf	d2,.copy

		; last letter
		move.w	(a1)+,d0
		add.w	d3,d0								; VRAM shift
		move.w	d0,(a2)+

		; check options
		cmpi.w	#$13-1,d4							; is options?
		bhs.s	.options							; if yes, branch

		; highlight act number
		lea	LevelSelectRSDK.buffer-LevelSelectRSDK.buffer(a3),a1
		lea	LevelSelectRSDK.buffer2-LevelSelectRSDK.buffer(a1),a2

		; get text pos
		move.w	(a1,d1.w),d0
		add.w	d3,d0								; VRAM shift
		move.w	d0,(a2,d1.w)

.options

	if ((make_art_tile(LevelSelectRSDK.VRAM,0,FALSE))<>0)
		ori.w	#make_art_tile(LevelSelectRSDK.VRAM,0,FALSE),d3
	endif

		; check vertical line
		moveq	#-(LevelSelectRSDK.SpecialStageCount+1),d0
		add.w	(LevelSelectRSDK.vertical_count).w,d0
		bhs.s	.return
		add.w	d0,d0								; multiply by 2
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.drawplayer							; 0
		bra.s	.drawmusic							; 2
		bra.s	.drawsound							; 4

; ---------------------------------------------------------------------------
; Draw sample
; ---------------------------------------------------------------------------

.drawsample										; 6
		lea	(LevelSelectRSDK.buffer2+planeLoc(64,34,18)).l,a5
		move.w	(LevelSelectRSDK.sample_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw player
; ---------------------------------------------------------------------------

.drawplayer
		lea	(LevelSelectRSDK.buffer2+planeLoc(64,34,12)).l,a5
		move.w	(Player_option).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw sound
; ---------------------------------------------------------------------------

.drawsound
		lea	(LevelSelectRSDK.buffer2+planeLoc(64,34,16)).l,a5
		move.w	(LevelSelectRSDK.sound_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw music
; ---------------------------------------------------------------------------

.drawmusic
		lea	(LevelSelectRSDK.buffer2+planeLoc(64,34,14)).l,a5
		move.w	(LevelSelectRSDK.music_count).w,d0

.drawnumbers
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.s	.getnumber
		move.b	d2,d0

.getnumber
		andi.w	#$F,d0
		cmpi.b	#10,d0								; is digit $A-$F?
		blo.s	.skipsymbols							; if not, branch
		addq.b	#6,d0								; use alpha characters

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
		lea	(LevelSelectRSDK.buffer).l,a1
		lea	LevelSelectRSDK_MainText(pc),a2

		; set
		mvq	make_art_tile(LevelSelectRSDK.VRAM,0,FALSE),d3
		moveq	#LevelSelectRSDK.MaxCount-1,d1

.load
		moveq	#0,d2
		move.b	(a2)+,d2							; text size
		move.w	(a0)+,d0							; offset
		lea	(a1,d0.w),a3							; RAM shift

.copy
		moveq	#0,d0
		move.b	(a2)+,d0							; load letter
		add.w	d3,d0
		move.w	d0,(a3)+
		dbf	d2,.copy
		dbf	d1,.load

		; set act numbers
		lea	(LevelSelectRSDK.buffer+planeLoc(64,15,2)).l,a1
		moveq	#5-1,d1								; (GHZ-SLZ)

.nload
		moveq	#'1',d0								; write (act) '1'
		add.w	d3,d0
		move.w	d0,planeLoc(64,0,0)(a1)
		moveq	#'2',d0								; write (act) '2'
		add.w	d3,d0
		move.w	d0,planeLoc(64,0,1)(a1)
		moveq	#'3',d0								; write (act) '3'
		add.w	d3,d0
		move.w	d0,planeLoc(64,0,2)(a1)
		lea	planeLoc(64,0,4)(a1),a1						; next line
		dbf	d1,.nload

		; SBZ
		moveq	#'1',d0								; write (act) '1'
		add.w	d3,d0
		move.w	d0,-$9D6(a1)
		moveq	#'2',d0								; write (act) '2'
		add.w	d3,d0
		move.w	d0,-$956(a1)
		moveq	#'3',d0								; write (act) '3'
		add.w	d3,d0
		move.w	d0,-$8D6(a1)

		; copy buffer
		lea	(LevelSelectRSDK.buffer).l,a1
		lea	LevelSelectRSDK.buffer2-LevelSelectRSDK.buffer(a1),a2
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
		plreq 1, ArtKosPlusM_OptionsText
		plreq $30, ArtKosPlusM_LevelSelectRSDKIcons
		plreq $60, ArtKosPlusM_LevelSelectRSDKBG
		plrlistend								; end marker
