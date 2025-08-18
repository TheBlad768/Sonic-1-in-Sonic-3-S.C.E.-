; ---------------------------------------------------------------------------
; Subroutine to move player in demo mode
; Uses Sonic & Knuckles format
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GetDemoPtr:
		tst.b	(Demo_mode_flag).w						; is demo mode enabled?
		beq.s	.return								; if not, branch

		; get demo data
		move.w	(Demo_number).w,d0
		add.w	d0,d0								; multiply by $14
		add.w	d0,d0
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	(Player_mode).w,d1
		add.w	d1,d1								; multiply by 4
		add.w	d1,d1
		add.w	d1,d0

		; load demo data
		movea.l	DemoPtrs(pc,d0.w),a0
		move.b	(a0)+,(Demo_hold_counter).w
		move.l	a0,(Demo_data_addr).w						; save DemoDat+1
		clr.b	(Demo_hold_buttons).w
		move.w	#$8000,(Ctrl_1).w
		move.w	#$8000,(Ctrl_2).w
		st	(Demo_start_button).w
		move.w	#30*60,(Demo_timer).w						; set demo timer
		clr.l	(RNG_seed).w							; reset RNG seed

.return
		rts
; ---------------------------------------------------------------------------

DemoPtrs:
		dc.l DemoDat_SonicTailsGHZ1, DemoDat_SonicGHZ1, DemoDat_TailsGHZ1, DemoDat_KnucklesGHZ1, DemoDat_KnucklesTailsGHZ1	; 0
		dc.l DemoDat_SonicTailsMZ1, DemoDat_SonicMZ1, DemoDat_TailsMZ1, DemoDat_KnucklesMZ1, DemoDat_KnucklesTailsMZ1		; 1
		dc.l DemoDat_SonicTailsSYZ1, DemoDat_SonicSYZ1, DemoDat_TailsSYZ1, DemoDat_KnucklesSYZ1, DemoDat_KnucklesTailsSYZ1	; 2
		dc.l DemoDat_SS, DemoDat_SS, DemoDat_SS, DemoDat_SS, DemoDat_SS														; 3

; =============== S U B R O U T I N E =======================================

Demo_PlayRecord:
		tst.b	(Demo_mode_flag).w						; is demo mode enabled?
		beq.s	.return								; if not, branch
		tst.b	(Ctrl_1_pressed).w						; is Start pressed?
		bpl.s	.notstart							; if not, branch

		; exit from demo
		move.b	#GameModeID_SegaScreen,(Game_mode).w				; set screen mode to Sega
		addq.w	#4,sp								; exit from current screen

.notstart
		movea.l	(Demo_data_addr).w,a0						; load DemoPtrs+1
		move.b	(a0),d2								; load button press
		subq.b	#1,(Demo_hold_counter).w					; decrement counter until next press
		bhs.s	.skip								; if it isn't 0 yet, branch
		addq.w	#2,a0								; advance to next button press
		move.b	-1(a0),(Demo_hold_counter).w					; reset counter to length of next press

.skip
		moveq	#signextendB($80),d1
		and.b	(Demo_start_button).w,d1
		or.b	(Demo_hold_buttons).w,d1
		move.b	d2,(Demo_hold_buttons).w
		moveq	#signextendB($80),d0
		and.b	(Ctrl_1).w,d0
		sne	(Demo_start_button).w
		or.b	d2,d0
		move.b	d0,(Ctrl_1).w
		eor.b	d0,d1
		and.b	d0,d1
		move.b	d1,(Ctrl_1_pressed).w
		move.w	#$8080,d0
		and.w	d0,(Ctrl_2).w
		move.l	a0,(Demo_data_addr).w

.return
		rts

; ---------------------------------------------------------------------------
; Subroutine to record player in demo mode
; Uses Sonic & Knuckles format
; ---------------------------------------------------------------------------

.enable	= 0

	if .enable

; =============== S U B R O U T I N E =======================================

Demo_Record:

		; calculate output location of recorded player 1 demo?
		lea	(Demo_Record_P1).w,a0						; $400 bytes buffer
		move.w	(Demo_button_index).w,d0
		adda.w	d0,a0

		; save length and button
		moveq	#$7F,d0
		and.b	(Ctrl_1).w,d0							; load input of player 1
		cmp.b	1(a0),d0							; is same button held?
		bne.s	.next								; if not, branch
		addq.b	#1,(a0)								; increment press length counter
		cmpi.b	#-1,(a0)							; is button held too long?
		bne.s	.return								; if yes, branch

.next
		clr.b	2(a0)								; reset hold length counter
		move.b	d0,3(a0)							; store last button press

		; next data
		addq.w	#2,(Demo_button_index).w					; advance to next button press
		andi.w	#$3FF,(Demo_button_index).w					; wrap at max button press changes 1024

.return
		rts

	endif
