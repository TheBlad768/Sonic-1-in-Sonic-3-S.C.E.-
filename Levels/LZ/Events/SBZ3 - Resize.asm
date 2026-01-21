; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SBZ3_Resize:
		cmpi.w	#$D00,(Camera_X_pos).w
		blo.s	.return
		cmpi.w	#$18,(Player_1+y_pos).w						; has Sonic reached the top of the level?
		bhs.s	.return								; if not, branch

		; start new level
		clr.b	(Game_mode_last).w						; clear last Game mode (unlock FZ spawn)
		move.b	#1,(Player_1+object_control).w

		; next zone
		move.w	#bytes_to_word(LevelID_SBZ,2),d0
		jmp	(StartNewLevel).w
; ---------------------------------------------------------------------------

.return
		rts
