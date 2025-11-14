; ---------------------------------------------------------------------------
; Sega (Prototype)
; ---------------------------------------------------------------------------

Sega_VDP:
		dc.w $8004								; disable HInt, HV counter, 8-colour mode
		dc.w $8200+(VRAM_Plane_A_Name_Table>>10)				; set foreground nametable address
		dc.w $8300+(VRAM_Plane_B_Name_Table>>10)				; set window nametable address
		dc.w $8400+(VRAM_Plane_B_Name_Table>>13)				; set background nametable address
		dc.w $8700+(0<<4)							; set background colour (line 3; colour 0)
		dc.w $8B00								; full-screen horizontal and vertical scrolling
		dc.w $8C81								; set 40cell screen size, no interlacing, no s/h
		dc.w $9001								; 64x32 cell nametable area
		dc.w $9100								; set window H position at default
		dc.w $9200								; set window V position at default
		dc.w 0									; end marker

; =============== S U B R O U T I N E =======================================

SegaScreen:
		music	mus_Stop							; stop music
		jsr	(Clear_KosPlus_Module_Queue).w					; clear KosPlusM PLCs
		ResetDMAQueue								; clear DMA queue
		disableInts
		move.l	#VInt,(V_int_addr).w
		move.l	#HInt,(H_int_addr).w
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	Sega_VDP(pc),a1
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
		move.b	d0,(SBZ2_player_roll).w
		move.b	d0,(Japan_credits_flag).w

		; load main art
		QueueKosPlusModule	ArtKosPM_SegaProto, 1

		; load mapping
		EniDecomp	MapEni_SegaProto, RAM_start, 0, 0, FALSE		; decompress Enigma mappings

		; check console region
		tst.b	(Graphics_flags).w
		bpl.s	.skipTM
		move.l	#$300031,$14(a1)						; set 'TM' tiles

.skipTM
		copyTilemap	(VRAM_Plane_A_Name_Table+$61A), 96, 32

		; load main palette
		lea	(Pal_SegaProto).l,a1
		lea	(Normal_palette).w,a2
		jsr	(PalLoad_Line16).w

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
		move.l	#VInt_Main,(V_int_ptr).w					; set VInt pointer
		jsr	(Wait_VSync).w
		enableScreen

		; set
		move.w	#$28,(Palette_cycle_counters+2).w
		move.w	#3*60,(Demo_timer).w						; set to wait for 3 seconds

.loop
		jsr	(Wait_VSync).w
		bsr.s	AnPal_SegaProto

		; check exit
		tst.b	(Ctrl_1_pressed).w
		bmi.s	.exit								; if start was pressed, skip ahead
		tst.w	(Demo_timer).w
		bne.s	.loop

.exit

		; credits cheat
		moveq	#btnDir+btnABC,d0						; don't check Start
		and.b	(Ctrl_1_held).w,d0
		cmpi.b	#btnAC,d0							; is button A and C held?
		seq	(Japan_credits_flag).w						; if yes, set flag

		; exit
		move.b	#GameModeID_TitleScreen,(Game_mode).w				; set screen mode to Title Screen
		rts

; ---------------------------------------------------------------------------
; Palette cycling
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AnPal_SegaProto:
		lea	(Palette_cycle_counters).w,a0

		; wait
		subq.w	#1,(a0)								; decrement timer
		bpl.s	.return
		addq.w	#3+1,(a0)							; reset timer to 3 frames

		; cycle
		move.w	2(a0),d0
		bmi.s	.return
		subq.w	#2,2(a0)

		lea	(Pal_AniSegaProto).l,a0
		lea	(Normal_palette_line_1+4).w,a1
		adda.w	d0,a0

	rept 10/2
		move.l	(a0)+,(a1)+
	endr

		; last
		move.w	(a0)+,(a1)+

.return
		rts
