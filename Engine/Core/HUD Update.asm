; ---------------------------------------------------------------------------
; Add points subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_AddToScore:
		move.b	#1,(Update_HUD_score).w							; set score counter to update

.main
		move.l	(Score).w,d1								; get current score
		add.l	d0,d1									; add d0*10 to the score
		move.l	#999999,d0								; 9999990 maximum points
		cmp.l	d1,d0									; is score below 999999?
		bhi.s	.set									; if yes, branch
		move.l	d0,d1									; reset score to 999999

.set
		move.l	d1,(Score).w								; save score

		; check bonus
		cmp.l	(Next_extra_life_score).w,d1						; if score is greater than next 50000 point increment
		blo.s	.return
		addi.l	#5000,(Next_extra_life_score).w						; set next 50000
		addq.b	#1,(Life_count).w							; give an additional extra life
		addq.b	#1,(Update_HUD_life_count).w
		music	mus_ExtraLife,1								; play the 1up song
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Subroutine to update the HUD
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

UpdateHUD:
		lea	(VDP_data_port).l,a6							; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5					; load VDP control address to a5

	if GameDebug
		tst.w	(Debug_placement_mode).w						; is debug mode on?
		bne.w	HUDDebug								; if yes, branch
	endif

		tst.b	(Update_HUD_score).w							; does the score need updating?
		beq.s	.chkrings								; if not, branch
		clr.b	(Update_HUD_score).w
		locVRAM	tiles_to_bytes(ArtTile_HUD+$1A),d0					; set VRAM address
		move.l	(Score).w,d1								; load score
		bsr.w	DrawSixDigitNumber

.chkrings
		tst.b	(Update_HUD_ring_count).w						; does the ring counter	need updating?
		beq.s	.chktime								; if not, branch
		bpl.s	.notzero
		bsr.w	HUD_DrawZeroRings							; reset rings to 0 if Sonic is hit

.notzero
		clr.b	(Update_HUD_ring_count).w
		locVRAM	tiles_to_bytes(ArtTile_HUD+$36),d0					; set VRAM address
		moveq	#0,d1
		move.w	(Ring_count).w,d1							; load number of rings
		bsr.w	DrawThreeDigitNumber

.chktime
		tst.b	(Update_HUD_timer).w							; does the time need updating?
		bpl.s	.skiptimer								; if not, branch
		move.b	#1,(Update_HUD_timer).w
		bra.s	.drawtimer
; ---------------------------------------------------------------------------

.skiptimer
		beq.s	.chklives
		tst.b	(Game_paused).w								; is the game paused?
		bne.s	.chklives								; if yes, branch
		lea	(Timer).w,a1
		cmpi.l	#(9*$10000)+(59*$100)+59,(a1)+						; is the time 9:59:59?
		beq.s	UpdateHUD_TimeOver							; if yes, branch

		addq.b	#1,-(a1)								; increment 1/60s counter
		cmpi.b	#60,(a1)								; check if passed 60
		blo.s	.drawtimer
		clr.b	(a1)
		addq.b	#1,-(a1)								; increment second counter
		cmpi.b	#60,(a1)								; check if passed 60
		blo.s	.drawtimer
		clr.b	(a1)
		addq.b	#1,-(a1)								; increment minute counter
		cmpi.b	#9,(a1)									; check if passed 9
		blo.s	.drawtimer
		move.b	#9,(a1)									; keep as 9

.drawtimer
		locVRAM	tiles_to_bytes(ArtTile_HUD+$28),d0
		moveq	#0,d1
		move.b	(Timer_minute).w,d1							; load minutes
		bsr.w	DrawSingleDigitNumber
		locVRAM	tiles_to_bytes(ArtTile_HUD+$2C),d0
		moveq	#0,d1
		move.b	(Timer_second).w,d1							; load seconds
		bsr.w	DrawTwoDigitNumber
		locVRAM	tiles_to_bytes(ArtTile_HUD+$32),d0
		moveq	#0,d1
		move.b	(Timer_frame).w,d1							; load centiseconds
		move.b	LUT_HUDCentiseconds(pc,d1.w),d1
		cmpi.l	#(9*$10000)+(59*$100)+59,(Timer).w
		bne.s	.skipt
		moveq	#99,d1

.skipt
		bsr.w	DrawTwoDigitNumber

.chklives
		tst.b	(Update_HUD_life_count).w
		beq.s	UpdateHUD_TimeOver.return
		clr.b	(Update_HUD_life_count).w
		bra.w	HUD_Lives
; ---------------------------------------------------------------------------

UpdateHUD_TimeOver:
		clr.b	(Update_HUD_timer).w
		lea	(Player_1).w,a0								; a0=character
		cmpi.b	#PlayerID_Death,routine(a0)						; has player just died?
		bhs.s	.finish									; if yes, branch
		movea.w	a0,a2									; load player to a0
		bsr.w	Kill_Character

.finish
		st	(Time_over_flag).w

.return
		rts
; ---------------------------------------------------------------------------

LUT_HUDCentiseconds:

		set	.a,0

	rept 60
		dc.b .a * 100 / 60
		set	.a,.a + 1
	endr

	even

	if GameDebug

; ---------------------------------------------------------------------------
; Subroutine to update the HUD Debug
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUDDebug:
		bsr.w	HUD_Debug
		tst.b	(Update_HUD_ring_count).w						; does the ring counter need updating?
		beq.s	.objcounter								; if not, branch
		bpl.s	.notzero
		bsr.s	HUD_DrawZeroRings							; reset rings to 0 if Sonic is hit

.notzero
		clr.b	(Update_HUD_ring_count).w
		locVRAM	tiles_to_bytes(ArtTile_HUD+$36),d0					; set VRAM address
		moveq	#0,d1
		move.w	(Ring_count).w,d1							; load number of rings
		bsr.w	DrawThreeDigitNumber

.objcounter
		locVRAM	tiles_to_bytes(ArtTile_HUD+$28),d0					; set VRAM address
		moveq	#0,d1
		move.w	(Lag_frame_count).w,d1
		bsr.w	DrawSingleDigitNumber
		locVRAM	tiles_to_bytes(ArtTile_HUD+$2C),d0					; set VRAM address
		moveq	#0,d1
		move.b	(Sprites_drawn).w,d1							; load "number of objects" counter
		bsr.w	DrawTwoDigitNumber
		tst.b	(Update_HUD_life_count).w
		beq.s	.chkbonus
		clr.b	(Update_HUD_life_count).w
		bsr.w	HUD_Lives

.chkbonus
		tst.b	(Game_paused).w								; is the game paused?
		bne.s	.return									; if yes, branch
		lea	(Timer+4).w,a1
		addq.b	#1,-(a1)								; increment 1/60s counter
		cmpi.b	#60,(a1)								; check if passed 60
		blo.s	.return
		clr.b	(a1)
		addq.b	#1,-(a1)								; increment second counter
		cmpi.b	#60,(a1)								; check if passed 60
		blo.s	.return
		clr.b	(a1)
		addq.b	#1,-(a1)								; increment minute counter
		cmpi.b	#9,(a1)									; check if passed 9
		blo.s	.return
		move.b	#9,(a1)									; keep as 9

.return
		rts

	endif

; ---------------------------------------------------------------------------
; Subroutine to load "0" on the HUD
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRings:
		locVRAM	tiles_to_bytes(ArtTile_HUD+$36),VDP_control_port-VDP_control_port(a5)
		lea	HUD_Zero_Rings(pc),a2
		moveq	#3-1,d2
		bra.s	HUD_DrawInitial.main

; ---------------------------------------------------------------------------
; Subroutine to load "0" on the HUD (Special Stage)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRingsSS:
		lea	(VDP_data_port).l,a6							; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5					; load VDP control address to a5

HUD_DrawZeroRingsSS2:
		locVRAM	tiles_to_bytes(ArtTile_SS_HUD+$18),VDP_control_port-VDP_control_port(a5)
		lea	HUD_Zero_Rings(pc),a2
		moveq	#3-1,d2
		bra.s	HUD_DrawInitial.main

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
		lea	(VDP_data_port).l,a6							; load VDP data address to a6
		lea	VDP_control_port-VDP_data_port(a6),a5					; load VDP control address to a5
		bsr.w	HUD_Lives
		locVRAM	tiles_to_bytes(ArtTile_HUD+$18),VDP_control_port-VDP_control_port(a5)
		lea	HUD_Initial_Parts(pc),a2
		moveq	#(HUD_Initial_Parts_end-HUD_Initial_Parts)-1,d2

.main
		lea	(ArtUnc_HUDDigits).l,a1

.loop
		move.b	(a2)+,d0
		bmi.s	.clear
		ext.w	d0
		lsl.w	#5,d0									; multiply by $20
		lea	(a1,d0.w),a3

	rept 8*2
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endr

.next
		dbf	d2,.loop
		rts
; ---------------------------------------------------------------------------

.clear
		moveq	#0,d0

	rept 8*2
		move.l	d0,VDP_data_port-VDP_data_port(a6)
	endr

		bra.s	.next
; ---------------------------------------------------------------------------

		; set the character
		save
		codepage HUD

HUD_Initial_Parts:
		dc.b "E      0"
		dc.b "0*00:00"
HUD_Zero_Rings:
		dc.b "  0"									; (zero rings)
HUD_Initial_Parts_end
	even

		restore	; reset character set

	if GameDebug

; ---------------------------------------------------------------------------
; Subroutine to load debug mode numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_Debug:
		locVRAM	tiles_to_bytes(ArtTile_HUD+$18),VDP_control_port-VDP_control_port(a5)	; set VRAM address
		move.w	(Camera_X_pos).w,d1	; load camera x-position
		swap	d1
		move.w	(Player_1+x_pos).w,d1	; load Sonic's x-position
		bsr.s	.main
		move.w	(Camera_Y_pos).w,d1	; load camera y-position
		swap	d1
		move.w	(Player_1+y_pos).w,d1	; load Sonic's y-position

.main
		moveq	#8-1,d6
		lea	(ArtUnc_DebugDigits).l,a1

.loop
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		lsl.w	#5,d2									; multiply by $20
		lea	(a1,d2.w),a3

	rept 8
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endr

		swap	d1
		dbf	d6,.loop								; repeat 7 more times
		rts

	endif

; ---------------------------------------------------------------------------
; Subroutine to load rings numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
		lea	HUD_100(pc),a2
		moveq	#3-1,d6
		bra.s	DrawSixDigitNumber.loadart

; ---------------------------------------------------------------------------
; Subroutine to load score numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
		moveq	#6-1,d6
		lea	HUD_100000(pc),a2

.loadart
		moveq	#0,d4									; set clr flag
		lea	(ArtUnc_HUDDigits).l,a1

.loop
		moveq	#-1,d2

.finddigit
		addq.w	#1,d2
		sub.l	(a2),d1
		bhs.s	.finddigit
		add.l	(a2)+,d1
		tst.w	d2									; is zero?
		beq.s	.zero									; if yes, branch
		moveq	#1,d4									; set draw flag

.zero
		tst.b	d4
		beq.s	.next
		lsl.w	#6,d2									; multiply by $40
		move.l	d0,VDP_control_port-VDP_control_port(a5)
		lea	(a1,d2.w),a3

	rept 8*2
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endr

.next
		addi.l	#vdpCommDelta(tiles_to_bytes(2)),d0
		dbf	d6,.loop
		rts

; ---------------------------------------------------------------------------
; HUD counter sizes
; ---------------------------------------------------------------------------

HUD_100000:	dc.l 100000
HUD_10000:		dc.l 10000
HUD_1000:		dc.l 1000
HUD_100:		dc.l 100
HUD_10:		dc.l 10
HUD_1:			dc.l 1

; ---------------------------------------------------------------------------
; Subroutine to load time numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawSingleDigitNumber:
		lea	HUD_1(pc),a2
		moveq	#1-1,d6
		bra.s	DrawTwoDigitNumber.loadart

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
		lea	HUD_10(pc),a2
		moveq	#2-1,d6

.loadart
		lea	(ArtUnc_HUDDigits).l,a1

.loop
		moveq	#-1,d2

.finddigit
		addq.w	#1,d2
		sub.l	(a2),d1
		bhs.s	.finddigit
		add.l	(a2)+,d1
		lsl.w	#6,d2									; multiply by $40
		move.l	d0,VDP_control_port-VDP_control_port(a5)
		lea	(a1,d2.w),a3

	rept 8*2
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endr

		addi.l	#vdpCommDelta(tiles_to_bytes(2)),d0
		dbf	d6,.loop
		rts

; ---------------------------------------------------------------------------
; Subroutine to update the HUD Lives
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_Lives:
		locVRAM	tiles_to_bytes(ArtTile_LifeIcon+9),d0					; set VRAM address
		moveq	#0,d1
		move.b	(Life_count).w,d1
		cmpi.b	#99,d1
		bhs.s	.return

		; draw
		lea	HUD_10(pc),a2
		moveq	#2-1,d6

		; load art
		moveq	#0,d4									; set clr flag
		lea	(ArtUnc_LivesDigits).l,a1

.loop
		move.l	d0,VDP_control_port-VDP_control_port(a5)
		moveq	#-1,d2

.finddigit
		addq.w	#1,d2
		sub.l	(a2),d1
		bhs.s	.finddigit
		add.l	(a2)+,d1
		tst.w	d2									; is zero?
		beq.s	.zero									; if yes, branch
		moveq	#1,d4									; set draw flag

.zero
		tst.b	d4
		beq.s	.clr

.load
		lsl.w	#5,d2									; multiply by $20
		lea	(a1,d2.w),a3

	rept 8
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endr

.next
		addi.l	#vdpCommDelta(tiles_to_bytes(2)),d0
		dbf	d6,.loop

.return
		rts
; ---------------------------------------------------------------------------

.clr
		tst.w	d6
		beq.s	.load
		moveq	#0,d5

	rept 8
		move.l	d5,VDP_data_port-VDP_data_port(a6)
	endr

		bra.s	.next

; ---------------------------------------------------------------------------
; Subroutine to update the HUD (Special Stage)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

UpdateHUD_SS:
		tst.b	(Update_HUD_ring_count).w						; does the ring counter	need updating?
		beq.s	HUD_Lives.return							; if not, branch
		bpl.s	.notzero
		bsr.w	HUD_DrawZeroRingsSS2							; reset rings to 0 if Sonic is hit

.notzero
		clr.b	(Update_HUD_ring_count).w
		locVRAM	tiles_to_bytes(ArtTile_SS_HUD+$18),d0					; set VRAM address
		moveq	#0,d1
		move.w	(Special_stage_rings_left).w,d1						; load number of rings
		bra.w	DrawThreeDigitNumber
