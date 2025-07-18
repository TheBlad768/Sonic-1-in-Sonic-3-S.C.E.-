; ---------------------------------------------------------------------------
; Object 44 - edge walls (GHZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_EdgeWalls:

		; init
		move.l	#Map_EdgeWalls,mappings(a0)
		move.w	#make_art_tile($3A4,2,0),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(64/2,16/2,priority_6),height_pixels(a0)	; set height, width and priority
		move.b	subtype(a0),mapping_frame(a0)

		; check
		move.l	#Sprite_OnScreen_Test,address(a0)
		bclr	#4,mapping_frame(a0)
		bne.s	.draw
		move.l	#.solid,address(a0)

.solid
		moveq	#(16/2)+$B,d1							; width
		moveq	#80/2,d2							; height
		move.w	d2,d3
		addq.w	#1,d3								; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

.draw
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

		include "Objects/Environ/Edge Walls/Object Data/Map - Edge Walls.asm"