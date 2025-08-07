; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Pause_Game:
		tst.b	(Life_count).w							; do you have any lives left?
		beq.w	.unpause							; if not, branch
		tst.b	(Time_over_flag).w						; is time over?
		bne.w	.unpause							; if yes, branch

.ending
		tst.b	(Game_paused).w							; is game already paused?
		bne.s	.paused								; if yes, branch
		tst.b	(Ctrl_1_pressed).w						; is Start button pressed?

	if LevelSelectCheat
		ifndef __DEBUG__
			bpl.w	.nopause						; if not, branch
		else
			bpl.s	.nopause						; if not, branch
		endif
	else
		bpl.s	.nopause							; if not, branch
	endif

.paused
		st	(Game_paused).w							; pause the game
		SMPS_PauseMusic								; pause the music

.loop
		move.b	#VintID_Pause,(V_int_routine).w
		bsr.s	Wait_VSync

    if GameDebug

	if LevelSelectCheat
		ifndef __DEBUG__
			tst.b	(Level_select_flag).w
			beq.s	.chkstart
		endif
	endif

		btst	#button_A,(Ctrl_1_pressed).w					; is button A pressed?
		beq.s	.chkframeadvance						; if not, branch

	ifdef __DEBUG__
		move.b	#GameModeID_LevelSelectScreen,(Game_mode).w			; set screen mode to Level Select (SCE)
	else
		move.b	#GameModeID_TitleScreen,(Game_mode).w				; set screen mode to Title Screen
	endif

		addq.w	#4,sp								; exit from current screen
		bra.s	.resumemusic
; ---------------------------------------------------------------------------

.chkframeadvance
		btst	#button_B,(Ctrl_1_held).w					; is button B held?
		bne.s	.frameadvance							; if yes, branch
		btst	#button_C,(Ctrl_1_pressed).w					; is button C pressed?
		bne.s	.frameadvance							; if yes, branch

.chkstart
    endif

		tst.b	(Ctrl_1_pressed).w						; is Start pressed?
		bpl.s	.loop								; if not, branch

.resumemusic
		SMPS_UnpauseMusic							; unpause the music

.unpause
		clr.b	(Game_paused).w							; unpause the game

.nopause
		rts
; ---------------------------------------------------------------------------

	if GameDebug
.frameadvance
		st	(Game_paused).w
		SMPS_UnpauseMusic							; unpause the music
		rts									; advance by a single frame
	endif
