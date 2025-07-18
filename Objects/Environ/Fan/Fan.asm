; ---------------------------------------------------------------------------
; Object 5D - fans (SLZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
fan_time			= objoff_30	; time between switching on/off
fan_switch			= objoff_32	; on/off switch

; =============== S U B R O U T I N E =======================================

Obj_Fan:

		; init
		move.l	#Map_Fan,mappings(a0)
		move.w	#make_art_tile($3E8,2,0),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(32/2,32/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.l	#.main,address(a0)

.main
		btst	#1,subtype(a0)							; is object type 02/03 (always on)?
		bne.s	.blow								; if yes, branch

		; wait
		subq.w	#1,fan_time(a0)							; subtract 1 from time delay
		bpl.s	.blow								; if time remains, branch
		move.w	#2*60,fan_time(a0)						; set delay to 2 seconds

		bchg	#0,fan_switch(a0)						; switch fan on/off
		beq.s	.blow								; if fan is off, branch
		move.w	#3*60,fan_time(a0)						; set delay to 3 seconds

.blow
		tst.b	fan_switch(a0)							; is fan switched on?
		bne.s	.chkdel								; if not, branch
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.p2								; if yes, branch

		; check player
		lea	(Player_1).w,a1							; a1=character
		bsr.s	Fan_Check

.p2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.notp2								; if yes, branch
		bsr.s	Fan_Check

.notp2

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.chkdel								; if time remains, branch
		clr.b	anim_frame_timer(a0)						; reset timer

		; next frame
		addq.b	#1,anim_frame(a0)
		cmpi.b	#3,anim_frame(a0)
		blo.s	.noreset
		clr.b	anim_frame(a0)							; reset after 4 frames

.noreset
		moveq	#0,d0
		btst	#0,subtype(a0)
		beq.s	.noflip
		addq.b	#2,d0

.noflip
		add.b	anim_frame(a0),d0
		move.b	d0,mapping_frame(a0)

.chkdel
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Fan_Check:
		cmpi.b	#PlayerID_Hurt,routine(a1)					; is Sonic falling back from getting hurt?
		bhs.s	.return								; if yes, branch
		tst.b	object_control(a1)
		bne.s	.return
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		btst	#status.npc.x_flip,status(a0)					; is fan facing right?
		bne.s	.chksonic							; if yes, branch
		neg.w	d0

.chksonic
		addi.w	#80,d0
		cmpi.w	#240,d0								; is Sonic more than $F0 pixels from the fan?
		bhs.s	.return								; if yes, branch
		moveq	#96,d1
		add.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		blo.s	.return								; branch if Sonic is too low
		cmpi.w	#112,d1
		bhs.s	.return								; branch if Sonic is too high
		subi.w	#80,d0								; is Sonic more than $50 pixels from the fan?
		bhs.s	.faraway							; if yes, branch
		not.w	d0
		add.w	d0,d0

.faraway
		addi.w	#96,d0
		btst	#status.npc.x_flip,status(a0)					; is fan facing right?
		bne.s	.right								; if yes, branch
		neg.w	d0

.right
		neg.b	d0
		asr.w	#4,d0
		btst	#0,subtype(a0)
		beq.s	.movesonic
		neg.w	d0

.movesonic
		add.w	d0,x_pos(a1)							; push Sonic away from the fan

.return
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Fan/Object Data/Map - Fan.asm"
