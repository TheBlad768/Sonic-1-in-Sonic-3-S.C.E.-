; ---------------------------------------------------------------------------
; Render Game Over
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Render_GameOver:
		lea	(GameOver_RAM).w,a4
		move.b	GameOver_RAM.status-GameOver_RAM(a4),d0
		bmi.s	.wait
		bne.s	.xpos

		; wait for KosPlusM queue to clear
		tst.w	(KosPlus_modules_left).w
		beq.s	.endplc
		rts
; ---------------------------------------------------------------------------

.endplc
		addq.b	#1,GameOver_RAM.status-GameOver_RAM(a4)				; set 1

		; 1
		move.w	#$80-48,GameOver_RAM.xpos-GameOver_RAM(a4)
		move.w	#$80+(224/2),GameOver_RAM.ypos-GameOver_RAM(a4)

		; 2
		move.w	#$80+(320+48),GameOver_RAM.xpos2-GameOver_RAM(a4)

		; set mapping
		move.l	#Map_GameOver,d0
		tst.b	(Time_over_flag).w
		beq.s	.mset
		move.l	#Map_TimeOver,d0

.mset
		move.l	d0,GameOver_RAM.mappings-GameOver_RAM(a4)

.xpos

		; check center
		move.w	GameOver_RAM.xpos-GameOver_RAM(a4),d0
		sub.w	GameOver_RAM.xpos2-GameOver_RAM(a4),d0				; is center position xpos?
		beq.s	.settime							; if yes, branch

		; move sprites
		moveq	#16,d1
		add.w	d1,GameOver_RAM.xpos-GameOver_RAM(a4)
		sub.w	d1,GameOver_RAM.xpos2-GameOver_RAM(a4)

		; draw
		bra.s	.draw
; ---------------------------------------------------------------------------

.settime
		move.w	#9*60,GameOver_RAM.timer-GameOver_RAM(a4)
		st	GameOver_RAM.status-GameOver_RAM(a4)

.wait
		move.b	(Ctrl_1_pressed).w,d0
		or.b	(Ctrl_2_pressed).w,d0
		andi.b	#btnABCS,d0							; is A/B/C/Start pressed?
		bne.s	.end								; if yes, branch

		; wait
		tst.w	GameOver_RAM.timer-GameOver_RAM(a4)
		beq.s	.end
		subq.w	#1,GameOver_RAM.timer-GameOver_RAM(a4)

		; draw
		bra.s	.draw
; ---------------------------------------------------------------------------

.end
		tst.b	(Time_over_flag).w
		bne.s	.restart
		addq.w	#4*2,sp								; exit from object and current screen
		move.b	#GameModeID_ContinueScreen,(Game_mode).w			; set screen mode to Continue
		tst.b	(Continue_count).w
		bne.s	.draw
		move.b	#GameModeID_SegaScreen,(Game_mode).w				; set screen mode to Level Select
		bra.s	.draw
; ---------------------------------------------------------------------------

.restart
		clr.l	(Saved_timer).w
		st	(Restart_level_flag).w

.draw
		move.w	GameOver_RAM.ypos-GameOver_RAM(a4),d1				; ypos
		move.w	#make_art_tile(ArtTile_Shield,0,TRUE),d5			; VRAM
		movea.l	GameOver_RAM.mappings-GameOver_RAM(a4),a1			; mappings

		; GAME/TIME
		move.w	GameOver_RAM.xpos-GameOver_RAM(a4),d0				; xpos
		moveq	#2-1,d4								; tile count
		jsr	(loc_1AF76).w							; draw

		; OVER
		move.w	GameOver_RAM.xpos2-GameOver_RAM(a4),d0				; xpos
		moveq	#2-1,d4								; tile count
		jmp	(loc_1AF76).w							; draw
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Renders/Game Over/Object Data/Map - Game Over.asm"
