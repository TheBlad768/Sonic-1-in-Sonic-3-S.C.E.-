; ---------------------------------------------------------------------------
; Object 2A - small vertical door (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_AutoDoor:

		; init
		move.l	#Map_ADoor,mappings(a0)
		move.w	#make_art_tile($470,2,0),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(64/2,16/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.l	#.openshut,address(a0)

.openshut
		clr.b	anim(a0)							; use "closing" animation
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.check
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.skipp2								; if yes, branch
		bsr.s	.check

.skipp2

		; animate
		lea	Ani_ADoor(pc),a1
		jsr	(Animate_Sprite).w
		tst.b	mapping_frame(a0)						; is the door open?
		bne.s	.chkdel								; if yes, branch
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

.chkdel
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

.check
		moveq	#64,d1								; set range for door detection
		move.w	x_pos(a1),d0
		add.w	d1,d0
		cmp.w	x_pos(a0),d0
		blo.s	.return
		sub.w	d1,d0
		sub.w	d1,d0
		cmp.w	x_pos(a0),d0							; is Sonic > $40 pixels from door?
		bhs.s	.return								; close door
		add.w	d1,d0
		cmp.w	x_pos(a0),d0							; is Sonic left of the door?
		bhs.s	.loc_899A							; if yes, branch
		btst	#status.npc.x_flip,status(a0)
		bne.s	.return
		bra.s	.open
; ---------------------------------------------------------------------------

.loc_899A
		btst	#status.npc.x_flip,status(a0)
		beq.s	.return

.open
		move.b	#1,anim(a0)							; use "opening" animation

.return
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Small Door/Object Data/Anim - Small Door.asm"
		include "Objects/Environ/Small Door/Object Data/Map - Small Door.asm"
