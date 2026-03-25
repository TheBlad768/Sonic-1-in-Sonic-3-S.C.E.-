; ---------------------------------------------------------------------------
; Level Select
; ---------------------------------------------------------------------------

; Constants
LevelSelect.VRAM =					0

LevelSelect.ZoneCount =					ZoneCount
LevelSelect.ActGHZCount =				3				; GHZ
LevelSelect.ActMZCount =				3				; MZ
LevelSelect.ActSYZCount =				3				; SYZ
LevelSelect.ActLZCount =				4				; LZ
LevelSelect.ActSLZCount =				3				; SLZ
LevelSelect.ActSBZCount =				3				; SBZ

LevelSelect.SpecialStageCount =				6
LevelSelect.CharacterCount =				LevelSelect.SpecialStageCount+1
LevelSelect.MusicTestCount =				LevelSelect.CharacterCount+1
LevelSelect.SoundTestCount =				LevelSelect.MusicTestCount+1
LevelSelect.SampleTestCount =				LevelSelect.SoundTestCount+1
LevelSelect.MaxCount =					11
LevelSelect.MaxSpecialStages =				ChaosEmeralds_Count
LevelSelect.MaxCharacters =				5
LevelSelect.MaxMusicNumber =				(mus__Last-mus__First)
LevelSelect.MaxSoundNumber =				(sfx__Last-sfx__First)
LevelSelect.MaxSampleNumber =				(dac__Last-dac__First)

; RAM

	dsset ramaddr(RAM_start)							; pretend we're in the RAM

LevelSelect.buffer					ds.b $1000			; foreground buffer (copy)
LevelSelect.buffer2					ds.b $1000			; foreground buffer (main)

	dsreset										; stop pretending and reset the program counter

	dsset ramaddr(Object_load_addr_front)						; pretend we're in the RAM

LevelSelect.music_count					ds.w 1
LevelSelect.sound_count					ds.w 1
LevelSelect.sample_count				ds.w 1
LevelSelect.control_timer				ds.w 1
LevelSelect.saved_act					ds.w 1
LevelSelect.cheat_counter				ds.w 1				; debug mode
LevelSelect.cheat_counter2				ds.w 1				; emeralds
LevelSelect.vertical_count				ds.w 1
LevelSelect.horizontal_count				ds.w $10

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

LevelSelectScreen:
		music	mus_Stop							; stop music
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

		; load main art
		QueueKosPlusModule	ArtKosPM_LevelSelectText, 1

		; load text
		bsr.w	LevelSelect_LoadText
		move.w	#make_art_tile(LevelSelect.VRAM,1,FALSE),d3
		bsr.w	LevelSelect_LoadHeaderText
		mvq	make_art_tile(LevelSelect.VRAM,0,FALSE),d3
		bsr.w	LevelSelect_LoadSpecialStage
		mvq	make_art_tile(LevelSelect.VRAM,0,FALSE),d3
		bsr.w	LevelSelect_LoadCharacter
		mvq	make_art_tile(LevelSelect.VRAM,0,FALSE),d3
		bsr.w	LevelSelect_MarkFields.drawmusic
		mvq	make_art_tile(LevelSelect.VRAM,0,FALSE),d3
		bsr.w	LevelSelect_MarkFields.drawsound
		mvq	make_art_tile(LevelSelect.VRAM,0,FALSE),d3
		bsr.w	LevelSelect_MarkFields.drawsample
		move.w	#make_art_tile(0,1,FALSE),d3
		bsr.w	LevelSelect_MarkFields

		; load main palette
		lea	(Pal_LevelSelect).l,a1
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

		; next
		move.l	#VInt_LevelSelect,(V_int_ptr).w					; set VInt pointer
		jsr	(Wait_VSync).w
		enableDisplay
		jsr	(Pal_FadeFromBlack).w

.loop
		jsr	(Wait_VSync).w
		lea	LSScroll_Data(pc),a2
		lea	(H_scroll_table).w,a3						; load scroll table
		jsr	(HScroll_Deform).w

		; update text
		moveq	#make_art_tile(0,0,FALSE),d3
		bsr.w	LevelSelect_MarkFields
		bsr.w	LevelSelect_Controls
		move.w	#make_art_tile(0,1,FALSE),d3
		bsr.w	LevelSelect_MarkFields

		; check exit
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop
		cmpi.w	#LevelSelect.SpecialStageCount,(LevelSelect.vertical_count).w
		bhi.s	.exit

		; set
		move.w	(Player_option).w,(Player_mode).w				; move selected character to active character
		move.b	(Game_mode).w,(Game_mode_last).w				; save current Game mode
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
		cmpi.w	#LevelSelect.SpecialStageCount,(LevelSelect.vertical_count).w
		beq.s	.special

		; clear
		move.b	d0,(Current_special_stage).w

		; load zone and act
		move.b	#GameModeID_LevelScreen,(Game_mode).w				; set screen mode to Level
		move.w	(LevelSelect.vertical_count).w,d2
		move.b	d2,-(sp)							; multiply by $100
		move.w	(sp)+,d2
		clr.b	d2								; clear garbage data
		add.w	(LevelSelect.saved_act).w,d2
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
		move.b	#GameModeID_SegaScreen,(Game_mode).w				; set screen mode to Sega
		rts
; ---------------------------------------------------------------------------

.special
		move.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; set screen mode to Special Stage

		; clear emeralds RAM
		lea	(Collected_emeralds_array).w,a1
		clr.l	(a1)+
		clr.l	(a1)+
		rts

; ---------------------------------------------------------------------------
; Check vertical line
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_Controls:

		; set vertical line
		moveq	#LevelSelect.MaxCount-1,d2					; set max count
		move.w	(LevelSelect.vertical_count).w,d3
		lea	(LevelSelect.control_timer).w,a3
		bsr.w	LevelSelect_FindUpDownControls
		move.w	d3,(LevelSelect.vertical_count).w

		; check vertical line
		cmpi.w	#LevelSelect.ZoneCount,d3
		blo.s	.getact
		subq.w	#LevelSelect.SpecialStageCount,d3
		blo.s	.return
		add.w	d3,d3								; multiply by 4
		add.w	d3,d3
		jmp	.index(pc,d3.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.getspecialstage						; 0

.return
		rts									; nop
		bra.s	.getcharacter							; 4
		rts									; nop
		bra.w	.getmusic							; 8
		bra.w	.getsound							; C

; ---------------------------------------------------------------------------
; Play sample
; ---------------------------------------------------------------------------

		; get sample								; 10
		moveq	#LevelSelect.MaxSampleNumber,d2					; set max count
		move.w	(LevelSelect.sample_count).w,d3
		lea	(LevelSelect.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelect.sample_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return

		; play sample
		move.w	d3,d0
		addi.w	#dac__First,d0							; $80 is reserved for pause
		jmp	(Play_Sample).w							; play sample

; ---------------------------------------------------------------------------
; Get act
; ---------------------------------------------------------------------------

.getact
		lea	(LevelSelect.horizontal_count).w,a0
		move.w	(LevelSelect.vertical_count).w,d4
		add.w	d4,d4								; multiply by 2
		move.w	(a0,d4.w),d3
		move.w	.maxacts(pc,d4.w),d2						; set max count
		lea	(LevelSelect.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(a0,d4.w)
		move.w	d3,(LevelSelect.saved_act).w
		rts
; ---------------------------------------------------------------------------

.maxacts
		dc.w LevelSelect.ActGHZCount-1	; GHZ
		dc.w LevelSelect.ActMZCount-1	; MZ
		dc.w LevelSelect.ActSYZCount-1	; SYZ
		dc.w LevelSelect.ActLZCount-1	; LZ
		dc.w LevelSelect.ActSLZCount-1	; SLZ
		dc.w LevelSelect.ActSBZCount-1	; SBZ

		zonewarning .maxacts,(2*1)

; ---------------------------------------------------------------------------
; Load Special Stage
; ---------------------------------------------------------------------------

.getspecialstage
		moveq	#LevelSelect.MaxSpecialStages-1,d2				; set max count
		moveq	#0,d3
		move.b	(Current_special_stage).w,d3
		lea	(LevelSelect.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.b	d3,(Current_special_stage).w
		rts

; ---------------------------------------------------------------------------
; Load Character
; ---------------------------------------------------------------------------

.getcharacter
		moveq	#LevelSelect.MaxCharacters-1,d2					; set max count
		move.w	(Player_option).w,d3
		lea	(LevelSelect.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(Player_option).w

.return2
		rts

; ---------------------------------------------------------------------------
; Play music
; ---------------------------------------------------------------------------

.getmusic
		moveq	#LevelSelect.MaxMusicNumber,d2					; set max count
		move.w	(LevelSelect.music_count).w,d3
		lea	(LevelSelect.control_timer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelect.music_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.return2

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
		lea	(LevelSelect.cheat_counter).w,a2				; load cheat counter
		lea	LevelSelect_Code.debugcheat(pc),a3				; jmp to activation
		bsr.w	LevelSelect_Code						; branch to check cheat

		; check emeralds cheat
		lea	LevelSelect_Code.ecodedat(pc),a1				; load cheat code
		lea	(LevelSelect.cheat_counter2).w,a2				; load cheat counter
		lea	LevelSelect_Code.emeraldcheat(pc),a3				; jmp to activation
		bra.w	LevelSelect_Code						; branch to check cheat
; --------------------------------------------------------------------------

.stop
		music	mus_Stop,1

; ---------------------------------------------------------------------------
; Play sound
; ---------------------------------------------------------------------------

.getsound
		moveq	#LevelSelect.MaxSoundNumber,d2					; set max count
		move.w	(LevelSelect.sound_count).w,d3
		lea	(LevelSelect.control_timer).w,a3
		bsr.s	LevelSelect_FindLeftRightControls
		move.w	d3,(LevelSelect.sound_count).w

		; check ctrl
		moveq	#btnABC,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	LevelSelect_FindUpDownControls.returnup

		; play sfx
		move.w	d3,d0
		addi.w	#sfx__First,d0							; $00 is reserved for silence
		jmp	(Play_SFX).w							; play sfx

; ---------------------------------------------------------------------------
; Control (up/down)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_FindUpDownControls:
		moveq	#btnUD,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.notpressed
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

LevelSelect_FindLeftRightControls:
		moveq	#btnLR,d1
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.notpressed
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

LevelSelect_MappingOffsets:
		dc.w planeLoc(64,0,5)
		dc.w planeLoc(64,0,7)
		dc.w planeLoc(64,0,9)
		dc.w planeLoc(64,0,11)
		dc.w planeLoc(64,0,13)
		dc.w planeLoc(64,0,15)
		dc.w planeLoc(64,0,17)
		dc.w planeLoc(64,0,20)
		dc.w planeLoc(64,0,22)
		dc.w planeLoc(64,0,24)
		dc.w planeLoc(64,0,26)

; =============== S U B R O U T I N E =======================================

LevelSelect_MarkFields:
		lea	(LevelSelect.buffer).l,a1
		lea	LevelSelect.buffer2-LevelSelect.buffer(a1),a2

		; get text pos
		move.w	(LevelSelect.vertical_count).w,d0
		add.w	d0,d0								; multiply by 2
		move.w	LevelSelect_MappingOffsets(pc,d0.w),d0

		; RAM shift
		adda.w	d0,a1
		adda.w	d0,a2

		; load line
		moveq	#bytesToXcnt(64,8),d2

.copy

	rept 8
		move.w	(a1)+,d0
		add.w	d3,d0								; VRAM shift
		move.w	d0,(a2)+
	endr

		dbf	d2,.copy

	if ((make_art_tile(LevelSelect.VRAM,0,FALSE))<>0)
		ori.w	#make_art_tile(LevelSelect.VRAM,0,FALSE),d3
	endif

		; check vertical line
		move.w	(LevelSelect.vertical_count).w,d0
		cmpi.w	#LevelSelect.ZoneCount,d0
		blo.w	LevelSelect_LoadAct
		subq.w	#LevelSelect.SpecialStageCount,d0
		blo.s	.return
		add.w	d0,d0								; multiply by 4
		add.w	d0,d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	LevelSelect_LoadSpecialStage					; 0

.return
		rts									; nop
		bra.s	LevelSelect_LoadCharacter					; 4
		rts									; nop
		bra.s	.drawmusic							; 8
		rts									; nop
		bra.s	.drawsound							; C
		rts									; nop

; ---------------------------------------------------------------------------
; Draw sample
; ---------------------------------------------------------------------------

.drawsample										; 10
		lea	(LevelSelect.buffer2+planeLoc(64,24,26)).l,a5
		move.w	(LevelSelect.sample_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw sound
; ---------------------------------------------------------------------------

.drawsound
		lea	(LevelSelect.buffer2+planeLoc(64,24,24)).l,a5
		move.w	(LevelSelect.sound_count).w,d0
		bra.s	.drawnumbers

; ---------------------------------------------------------------------------
; Draw music
; ---------------------------------------------------------------------------

.drawmusic
		lea	(LevelSelect.buffer2+planeLoc(64,24,22)).l,a5
		move.w	(LevelSelect.music_count).w,d0

.drawnumbers
		move.w	d0,d2
		move.w	d0,-(sp)							; division by $100
		move.b	(sp)+,d0
		bsr.s	.getnumber
		move.b	d2,d0
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
		rts

; ---------------------------------------------------------------------------
; Draw Special Stage
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadSpecialStage:
		lea	(LevelSelect.buffer2+planeLoc(64,24,17)).l,a5
		moveq	#0,d0
		move.b	(Current_special_stage).w,d0
		add.w	d0,d0
		lea	LevelSelect_LoadSpecialStageText(pc),a0
		adda.w	(a0,d0.w),a0
		bra.s	LevelSelect_LoadAct.loadtext

; ---------------------------------------------------------------------------
; Draw character
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadCharacter:
		lea	(LevelSelect.buffer2+planeLoc(64,24,20)).l,a5
		move.w	(Player_option).w,d0
		add.w	d0,d0
		lea	LevelSelect_LoadCharacterText1(pc),a0
		tst.b	(Graphics_flags).w						; check console region
		bmi.s	.notMiles
		lea	LevelSelect_LoadCharacterText2(pc),a0

.notMiles
		adda.w	(a0,d0.w),a0
		bra.s	LevelSelect_LoadAct.loadtext

; ---------------------------------------------------------------------------
; Draw act
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadAct:
		lea	(LevelSelect.buffer2+planeLoc(64,24,5)).l,a5
		lea	(LevelSelect.horizontal_count).w,a0
		move.w	(LevelSelect.vertical_count).w,d0
		move.w	d0,d1
		move.b	d0,-(sp)							; multiply by $100
		move.w	(sp)+,d0
		clr.b	d0								; clear garbage data
		adda.w	d0,a5
		add.w	d1,d1								; multiply by 2
		move.w	(a0,d1.w),d0
		add.w	d1,d1								; multiply by 4
		add.w	d1,d1
		add.w	d0,d0								; multiply by 2
		add.w	d1,d0
		lea	LevelSelect_ActTextIndex(pc),a0
		adda.w	(a0,d0.w),a0

.loadtext
		moveq	#0,d6
		move.b	(a0)+,d6							; get text size

.tcopy
		moveq	#0,d0
		move.b	(a0)+,d0
		add.w	d3,d0
		move.w	d0,(a5)+
		dbf	d6,.tcopy
		rts

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadHeaderText:
		lea	(LevelSelect.buffer2+planeLoc(64,0,1)).l,a5
		lea	LevelSelect_HeaderText(pc),a0
		bra.s	LevelSelect_LoadAct.loadtext

; ---------------------------------------------------------------------------
; Load text
; ---------------------------------------------------------------------------

		save
		codepage	LEVELSCREEN

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadText:
		lea	LevelSelect_MappingOffsets(pc),a0
		lea	(LevelSelect.buffer).l,a1
		lea	LevelSelect_MainText(pc),a2

		; set
		mvq	make_art_tile(LevelSelect.VRAM,0,FALSE),d3
		moveq	#LevelSelect.MaxCount-1,d1

.load
		moveq	#0,d2
		move.b	(a2)+,d2							; text size
		move.w	d2,d4								; save text size
		move.w	(a0)+,d0							; offset
		lea	(a1,d0.w),a3							; RAM shift

.copy
		moveq	#0,d0
		move.b	(a2)+,d0							; load letter
		add.w	d3,d0
		move.w	d0,(a3)+
		dbf	d2,.copy

		; fill with spaces
		moveq	#64-2,d2							; maximum length of line (dbf + dbf)
		sub.w	d4,d2
		blo.s	.next

.sloop
		moveq	#' ',d0								; space
		add.w	d3,d0
		move.w	d0,(a3)+
		dbf	d2,.sloop

.next
		dbf	d1,.load

		; copy buffer
		lea	(LevelSelect.buffer).l,a1
		lea	LevelSelect.buffer2-LevelSelect.buffer(a1),a2
		moveq	#bytesToXcnt(($1000),8*4),d1

.bcopy

	rept 8
		move.l	(a1)+,(a2)+
	endr

		dbf	d1,.bcopy
		rts

		restore

; ---------------------------------------------------------------------------

LevelSelect_LoadSpecialStageText: offsetTable
		offsetTableEntry.w LevelSelect_SS1		; 0
		offsetTableEntry.w LevelSelect_SS2		; 2
		offsetTableEntry.w LevelSelect_SS3		; 4
		offsetTableEntry.w LevelSelect_SS4		; 6
		offsetTableEntry.w LevelSelect_SS5		; 8
		offsetTableEntry.w LevelSelect_SS6		; A
		offsetTableEntry.w LevelSelect_SS7		; C
; ---------------------------------------------------------------------------

LevelSelect_LoadCharacterText1: offsetTable
		offsetTableEntry.w LevelSelect_SonicAndTails	; 0
		offsetTableEntry.w LevelSelect_SonicAlone	; 2
		offsetTableEntry.w LevelSelect_TailsAlone	; 4
		offsetTableEntry.w LevelSelect_KnuxAlone	; 6
		offsetTableEntry.w LevelSelect_KnuxAndTails	; 8
LevelSelect_LoadCharacterText2: offsetTable
		offsetTableEntry.w LevelSelect_SonicAndMiles	; 0
		offsetTableEntry.w LevelSelect_SonicAlone	; 2
		offsetTableEntry.w LevelSelect_MilesAlone	; 4
		offsetTableEntry.w LevelSelect_KnuxAlone	; 6
		offsetTableEntry.w LevelSelect_KnuxAndMiles	; 8
; ---------------------------------------------------------------------------

LevelSelect_ActTextIndex: offsetTable
		offsetTableEntry.w LevelSelect_LoadAct1		; GHZ1
		offsetTableEntry.w LevelSelect_LoadAct2		; GHZ2
		offsetTableEntry.w LevelSelect_LoadAct3		; GHZ3
		offsetTableEntry.w LevelSelect_LoadAct4		; GHZ4
		offsetTableEntry.w LevelSelect_LoadAct1		; MZ1
		offsetTableEntry.w LevelSelect_LoadAct2		; MZ2
		offsetTableEntry.w LevelSelect_LoadAct3		; MZ3
		offsetTableEntry.w LevelSelect_LoadAct4		; MZ4
		offsetTableEntry.w LevelSelect_LoadAct1		; SYZ1
		offsetTableEntry.w LevelSelect_LoadAct2		; SYZ2
		offsetTableEntry.w LevelSelect_LoadAct3		; SYZ3
		offsetTableEntry.w LevelSelect_LoadAct4		; SYZ4
		offsetTableEntry.w LevelSelect_LoadAct1		; LZ1
		offsetTableEntry.w LevelSelect_LoadAct2		; LZ2
		offsetTableEntry.w LevelSelect_LoadAct3		; LZ3
		offsetTableEntry.w LevelSelect_LoadAct4		; LZ4
		offsetTableEntry.w LevelSelect_LoadAct1		; SLZ1
		offsetTableEntry.w LevelSelect_LoadAct2		; SLZ2
		offsetTableEntry.w LevelSelect_LoadAct3		; SLZ3
		offsetTableEntry.w LevelSelect_LoadAct4		; SLZ4
		offsetTableEntry.w LevelSelect_LoadAct1		; SBZ1
		offsetTableEntry.w LevelSelect_LoadAct2		; SBZ2
		offsetTableEntry.w LevelSelect_LoadFinal	; SBZ3
		offsetTableEntry.w LevelSelect_LoadAct4		; SBZ4

		zonewarning LevelSelect_ActTextIndex,(2*4)
; --------------------------------------------------------------------------

; special stage
LevelSelect_SS1:		levselstr "STAGE 1"
LevelSelect_SS2:		levselstr "STAGE 2"
LevelSelect_SS3:		levselstr "STAGE 3"
LevelSelect_SS4:		levselstr "STAGE 4"
LevelSelect_SS5:		levselstr "STAGE 5"
LevelSelect_SS6:		levselstr "STAGE 6"
LevelSelect_SS7:		levselstr "STAGE 7"

; players
LevelSelect_SonicAndMiles:	levselstr "SONIC AND MILES"
LevelSelect_SonicAndTails:	levselstr "SONIC AND TAILS"
LevelSelect_SonicAlone:		levselstr "SONIC ALONE"
LevelSelect_MilesAlone:		levselstr "MILES ALONE"
LevelSelect_TailsAlone:		levselstr "TAILS ALONE"
LevelSelect_KnuxAlone:		levselstr "KNUX ALONE"
LevelSelect_KnuxAndMiles:	levselstr "KNUX AND MILES"
LevelSelect_KnuxAndTails:	levselstr "KNUX AND TAILS"

; level act
LevelSelect_LoadAct1:		levselstr "ACT 1"
LevelSelect_LoadAct2:		levselstr "ACT 2"
LevelSelect_LoadAct3:		levselstr "ACT 3"
LevelSelect_LoadAct4:		levselstr "ACT 4"
LevelSelect_LoadFinal:		levselstr "FINAL"
LevelSelect_HeaderText:		levselstr "SONIC THE HEDGEHOG - *** LEVEL SELECT ***                       "

; main text
LevelSelect_MainText:
		levselstr "   GREEN HILL         - ACT 1"
		levselstr "   MARBLE             - ACT 1"
		levselstr "   SPRING YARD        - ACT 1"
		levselstr "   LABYRINTH          - ACT 1"
		levselstr "   STAR LIGHT         - ACT 1"
		levselstr "   SCRAP BRAIN        - ACT 1"
		levselstr "   SPECIAL STAGE      -"
		levselstr "   CHARACTER:         -"
		levselstr "   MUSIC TEST:        -"
		levselstr "   SOUND TEST:        -"
		levselstr "   SAMPLE TEST:       -"
	even
; ---------------------------------------------------------------------------

		; scroll data

LSScroll_Data: HScroll_Header
		HScroll_Data 8, 8, -$100, FG	; start pos, size, velocity, plane
		HScroll_End

; ---------------------------------------------------------------------------
; Debug Mode and Chaos emeralds code
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_Code:
		adda.w	(a2),a1								; get cheat counter
		cmp.b	(a1)+,d0							; compare it to the cheat
		bne.s	.fail								; if they're different, branch
		addq.w	#1,(a2)								; add 1 to the number of correct entries
		tst.b	(a1)								; is the next entry -1?
		bpl.s	.return								; if not, branch
		jsr	(a3)								; jmp to activation

.fail
		clr.w	(a2)								; clear the number of correct entries

.return
		rts
; ---------------------------------------------------------------------------

.debugcheat
		st	(Debug_cheat_flag).w						; enable debug mode cheat
		sfx	sfx_RingRight,1							; play ring sound
; ---------------------------------------------------------------------------

.emeraldcheat
		move.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w			; give emeralds to the player

		; set 'got emeralds'
		lea	(Collected_emeralds_array).w,a2

	if ChaosEmeralds_Count=7
		move.l	#words_to_long($101,$101),(a2)+					; set 'got emerald' flags
		move.l	#words_to_long($101,$100),(a2)+
	elseif ChaosEmeralds_Count=6
		move.l	#words_to_long($101,$101),(a2)+					; set 'got emerald' flags
		move.l	#words_to_long($101,0),(a2)+
	else
		fatal "Warning! It needs to be fixed here too!"
	endif

		music	mus_Emerald,1							; play emerald music
; ---------------------------------------------------------------------------

.dcodedat

		; June 23th, which was Sonic 1's release date
		dc.b 1, 9, 9, 1, 0, 6, 2, 3						; sound id
		dc.b -1									; stop

.ecodedat

		; book of Genesis, 41:26, which makes frequent reference to the
		; number 7. 7 happens to be the number of chaos emeralds.
		; the Mega Drive is known as the Genesis in the US.
		dc.b 4, 1, 2, 6
		dc.b -1									; stop
	even
