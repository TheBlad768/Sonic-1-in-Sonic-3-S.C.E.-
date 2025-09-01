; ---------------------------------------------------------------------------
; Sega
; ---------------------------------------------------------------------------

Sega_VDP:
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

SegaScreen:
		music	mus_Stop									; stop music
		jsr	(Clear_KosPlus_Module_Queue).w							; clear KosPlusM PLCs
		ResetDMAQueue										; clear DMA queue
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	Sega_VDP(pc),a1
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
		move.b	d0,(SBZ2_player_roll).w
		move.b	d0,(Japan_credits_flag).w

		; load main art
		QueueKosPlusModule	ArtKosPM_Sega, 0

		; load mapping
		EniDecomp	MapEni_Sega, RAM_start, 0, 0, FALSE					; decompress Enigma mappings

		; check console region
		tst.b	(Graphics_flags).w
		bmi.s	.skipTM
		lea	$A40(a1),a2
		lea	$4DA(a1),a3
		move.l	(a2)+,(a3)+									; remove the TM from the Sega logo if on a japan console
		move.w	(a2)+,(a3)+
		lea	$50-6(a3),a3
		move.l	(a2)+,(a3)+
		move.w	(a2)+,(a3)+

.skipTM
		copyTilemap	VRAM_Plane_B_Name_Table+$510, 192, 64
		copyTilemap	VRAM_Plane_A_Name_Table, 320, 224

		; init palette
		lea	(Palette_cycle_counters+2).w,a0
		move.w	#-$A,(a0)+
		move.l	#PalCycle_Sega,(a0)

		; load palette
		lea	(Target_palette).w,a1
		move.l	#words_to_long(cWhite,cWhite),d0
		moveq	#bytesToXcnt(64,(2*4)),d1

.lpal

	rept 4
		move.l	d0,(a1)+
	endr

		dbf	d1,.lpal

.waitplc
		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Process_KosPlus_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_KosPlus_Module_Queue).w
		tst.w	(KosPlus_modules_left).w
		bne.s	.waitplc									; wait for KosPlusM queue to clear

		; next
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.anipal
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w

		; palette cycle process
		movea.l	(Palette_cycle_counters+4).w,a0
		jsr	(a0)

		; check done
		bne.s	.anipal

		; next
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		music	mus_SEGA									; play SEGA sound
		move.w	#3*60,(Demo_timer).w								; set to wait for 3 seconds

.loop
		move.b	#VintID_Sega,(V_int_routine).w
		jsr	(Wait_VSync).w

		; check exit
		tst.b	(Ctrl_1_pressed).w
		bmi.s	.exit										; if start was pressed, skip ahead
		tst.w	(Demo_timer).w
		bne.s	.loop

.exit
		music	mus_StopSEGA									; stop SEGA sound

		; wait stop SEGA sound
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w

		; credits cheat
		moveq	#btnDir+btnABC,d0								; don't check Start
		and.b	(Ctrl_1_held).w,d0
		cmpi.b	#btnAC,d0									; is button A and C held?
		seq	(Japan_credits_flag).w								; if yes, set flag

		; exit
		move.b	#GameModeID_TitleScreen,(Game_mode).w						; set screen mode to Title Screen
		rts

; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PalCycle_Sega:
		lea	(Palette_cycle_counters).w,a0

		; get
		lea	(Pal_AniSega2_1).l,a1
		lea	(Normal_palette_line_2).w,a2
		moveq	#6-1,d1
		move.w	2(a0),d0

.find
		bpl.s	.found
		addq.w	#2,a1
		subq.w	#1,d1
		addq.w	#2,d0
		bra.s	.find
; ---------------------------------------------------------------------------

.found
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	.skip
		addq.w	#2,d0

.skip
		cmpi.w	#$30*2,d0
		bhs.s	.skip2
		move.w	(a1)+,(a2,d0.w)

.skip2
		addq.w	#2,d0
		dbf	d1,.found

		; set
		move.w	2(a0),d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	.skip3
		addq.w	#2,d0

.skip3
		cmpi.w	#($30*2)+2+2,d0
		blt.s	.skip4
		move.b	#4,(a0)										; decrement timer
		move.l	#PalCycle_Sega2,4(a0)
		moveq	#-12,d0

.skip4
		move.w	d0,2(a0)

.ndone

		; set not done flag
		moveq	#1,d0
		rts

; =============== S U B R O U T I N E =======================================

PalCycle_Sega2:
		lea	(Palette_cycle_counters).w,a0

		; check
		subq.b	#1,(a0)										; decrement timer
		bpl.s	PalCycle_Sega.ndone								; if time remains, branch
		addq.b	#4+1,(a0)									; reset timer to 4 frames

		; check
		move.w	2(a0),d0
		addi.w	#12,d0
		cmpi.w	#12*4,d0
		blo.s	.set

		; set done flag
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

.set
		move.w	d0,2(a0)

		; set
		lea	(Pal_AniSega2_2).l,a1
		adda.w	d0,a1
		lea	(Normal_palette_line_1+4).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)
		move.w	(a1),d0

		; set
		lea	(Normal_palette_line_2+2).w,a2

	rept 2

		rept 15
			move.w  d0,(a2)+
		endr

		addq.w  #2,a2
	endr

	; last
	rept 15
		move.w  d0,(a2)+
	endr

		; set not done flag
		moveq	#1,d0
		rts
