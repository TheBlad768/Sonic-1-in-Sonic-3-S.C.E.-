; ---------------------------------------------------------------------------
; Object 6C - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
vanp_timer			= objoff_30	; counter for time until event (2 bytes)
vanp_timelen			= objoff_32	; time between events (general) (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_VanishPlatform:

		; init
		move.l	#Map_VanP,mappings(a0)
		move.w	#make_art_tile($364,2,0),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(32/2,32/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.l	#.main,address(a0)

		; set wait
		moveq	#$F,d0								; read only the 2nd digit
		and.b	subtype(a0),d0							; get object type
		addq.w	#1,d0								; add 1
		lsl.w	#7,d0								; multiply by $80
		move.w	d0,d1
		subq.w	#1,d0
		move.w	d0,vanp_timer(a0)
		move.w	d0,vanp_timelen(a0)
		moveq	#0,d0								; clear d0 for mul
		move.b	subtype(a0),d0							; get object type
		andi.w	#$F0,d0								; read only the 1st digit
		addi.w	#$80,d1
		mulu.w	d1,d0
		lsr.l	#8,d0
		move.w	d0,objoff_36(a0)
		subq.w	#1,d1
		move.w	d1,objoff_38(a0)

.main
		move.w	(Level_frame_counter).w,d0
		sub.w	objoff_36(a0),d0
		and.w	objoff_38(a0),d0
		beq.s	.jvanish

.draw
		lea	Ani_Van(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.jvanish
		move.l	#.vanish,address(a0)

.vanish

		; wait
		subq.w	#1,vanp_timer(a0)
		bpl.s	.wait
		move.w	#128-1,vanp_timer(a0)

		tst.b	anim(a0)							; is platform vanishing?
		beq.s	.isvanishing							; if yes, branch
		move.w	vanp_timelen(a0),vanp_timer(a0)

.isvanishing
		bchg	#0,anim(a0)

.wait
		lea	Ani_Van(pc),a1
		jsr	(Animate_Sprite).w
		pea	(Sprite_OnScreen_Test).w

		; check
		tst.b	anim(a0)							; has platform vanished?
		beq.s	.notsolid							; if yes, branch
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		move.w	x_pos(a0),d4
		jmp	(SolidObjectTop).w
; ---------------------------------------------------------------------------

.chkdel
		rts
; ---------------------------------------------------------------------------

.notsolid
		jmp	(Displace_PlayerOffObject).w					; release Sonic from object
; ---------------------------------------------------------------------------

		include "Objects/Environ/Vanishing Platforms/Object Data/Anim - Vanishing Platforms.asm"
		include "Objects/Environ/Vanishing Platforms/Object Data/Map - Vanishing Platforms.asm"
