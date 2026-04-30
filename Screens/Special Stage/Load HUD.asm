; ---------------------------------------------------------------------------
; Render HUD (Special Stage)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Render_SSHUD:
		lea	(HUD_RAM).w,a1
		move.b	HUD_RAM.status-HUD_RAM(a1),d0
		beq.s	.return								; if 0, branch

	if ~~HUDScroll
		subq.b	#1,d0
		bne.s	.process							; if 2, branch
		move.w	#spriteScreenPositionX(16),HUD_RAM.xpos-HUD_RAM(a1)
		move.w	#spriteScreenPositionY(screen_height/2+(block_height+tile_height)),HUD_RAM.ypos-HUD_RAM(a1)
		addq.b	#1,HUD_RAM.status-HUD_RAM(a1)					; set 2
	else
		bmi.s	.left								; if -1, branch
		cmpi.b	#3,d0
		beq.s	.process							; if 3, branch
		subq.b	#1,d0
		bne.s	.right								; if 2, branch

.init
		move.w	#block_width,HUD_RAM.xpos-HUD_RAM(a1)
		move.w	#spriteScreenPositionY(screen_height/2+(block_height+tile_height)),HUD_RAM.ypos-HUD_RAM(a1)
		addq.b	#1,HUD_RAM.status-HUD_RAM(a1)					; set 2

.right
		addq.w	#2,HUD_RAM.xpos-HUD_RAM(a1)
		cmpi.w	#spriteScreenPositionX(16),HUD_RAM.xpos-HUD_RAM(a1)
		bne.s	.process
		addq.b	#1,HUD_RAM.status-HUD_RAM(a1)					; set 3
		bra.s	.process
; ---------------------------------------------------------------------------

.left
		subq.w	#2,HUD_RAM.xpos-HUD_RAM(a1)
		cmpi.w	#block_width,HUD_RAM.xpos-HUD_RAM(a1)
		bhs.s	.process
		clr.b	HUD_RAM.status-HUD_RAM(a1)
	endif

.process
		moveq	#6*2,d4								; frame #6
		movem.w	HUD_RAM.xpos-HUD_RAM(a1),d0-d1					; xpos and ypos
		move.w	#make_art_tile(ArtTile_SpecialStage_HUD,0,TRUE),d5		; VRAM
		lea	Map_HUD(pc),a1
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	.return
		jmp	(loc_1AF76).w							; draw
; ---------------------------------------------------------------------------

.return
		rts
