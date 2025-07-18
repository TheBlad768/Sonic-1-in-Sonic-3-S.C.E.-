; ---------------------------------------------------------------------------
; Object 70 - large girder block (SBZ)
; Don't forget to turn "Load at any Y position" flag on
; ---------------------------------------------------------------------------

; Dynamic object variables
gird_delay			= objoff_2E	; delay for movement
gird_origX			= objoff_32	; original x-axis position
gird_origY			= objoff_30	; original y-axis position
gird_time			= objoff_34	; duration for movement in a direction
gird_set			= objoff_38	; which movement settings to use (0/8/$10/$18)

; =============== S U B R O U T I N E =======================================

Obj_Girder:

		; init
		move.l	#Map_Gird,mappings(a0)
		move.w	#make_art_tile($2DA,2,0),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(48/2,192/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.w	x_pos(a0),gird_origX(a0)
		move.w	y_pos(a0),gird_origY(a0)
		move.l	#.action,address(a0)
		bsr.s	Gird_ChgMove

.action
		move.w	x_pos(a0),-(sp)

		; wait
		tst.w	gird_delay(a0)
		beq.s	.beginmove
		subq.w	#1,gird_delay(a0)
		bne.s	.solid

.beginmove
		jsr	(MoveSprite2).w
		subq.w	#1,gird_time(a0)						; decrement movement duration
		bne.s	.solid								; if time remains, branch
		bsr.s	Gird_ChgMove							; if time is zero, branch

.solid
		move.w	(sp)+,d4
		tst.b	render_flags(a0)						; is the object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		jsr	(SolidObjectFull).w

.chkdel
		moveq	#-$80,d0							; round down to nearest $80
		and.w	gird_origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

Gird_ChgMove:
		moveq	#$18,d0
		and.b	gird_set(a0),d0
		addq.b	#8,gird_set(a0)							; use next settings

		; get par
		lea	.settings(pc,d0.w),a1
		move.l	(a1)+,x_vel(a0)
		move.w	(a1),gird_time(a0)
		move.w	#7,gird_delay(a0)
		rts
; ---------------------------------------------------------------------------

.settings	; x-speed, y-speed, duration, unused
		dc.w $100, 0, $60, 0			; right		; 0
		dc.w 0, $100, $30, 0			; down		; 8
		dc.w -$100, -$40, $60, 0		; up/left	; $10
		dc.w 0, -$100, $18, 0			; up		; $18
; ---------------------------------------------------------------------------

		include "Objects/Environ/Girder Block/Object Data/Map - Girder Block.asm"
