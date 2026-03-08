; ---------------------------------------------------------------------------
; Object 5B - blocks that form a staircase (SLZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

staircase.origX				ds.w 1						; original x-axis position (2 bytes)
staircase.origY				ds.w 1						; original y-axis position (2 bytes)
staircase.timer				ds.w 1						; (2 bytes)
staircase.status			ds.b 1						; (1 byte)
staircase.offset			ds.b 1						; (1 byte)
staircase.height			ds.w 4						; (8 bytes)
staircase.height_end =			*

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Staircase:

		; init
		; set static mapping and screen coordinates flag
		ori.b	#( \
			setBit(render_flags.level) | \
			setBit(render_flags.static_mappings) \
		),render_flags(a0)

		; check
		moveq	#7,d0
		and.b	subtype(a0),d0
		cmpi.w	#4,d0
		blo.s	.skip
		bchg	#render_flags.x_flip,render_flags(a0)

.skip
		btst	#render_flags.y_flip,render_flags(a0)
		beq.s	.notflipy
		bchg	#render_flags.x_flip,render_flags(a0)

.notflipy
		moveq	#staircase.height,d3						; set height start RAM address
		moveq	#2,d4								; next RAM address
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		moveq	#staircase.height_end,d3					; set height end RAM address
		moveq	#-2,d4								; previous RAM address

.notflipx
		moveq	#4-1,d1								; create 4 staircase object
		move.w	x_pos(a0),d2
		movea.w	a0,a1								; load current object to a1

		; get RAM slot
		getobjectRAMslot a2
		bra.s	.load
; ---------------------------------------------------------------------------

.create

		; create staircase object

.find
		lea	next_object(a1),a1						; goto next object RAM slot
		tst.l	address(a1)							; is object RAM slot empty?
		dbeq	d0,.find							; if not, branch
		bne.s	.notfree							; branch, if object RAM slot is not empty
		subq.w	#1,d0								; subtract from sprite table

		; load object
		move.l	#.solid,address(a1)

.load
		move.l	#Map_Staircase,mappings(a1)
		move.w	#make_art_tile(0,2,FALSE),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	#bytes_word_to_long(32/2,32/2,priority_3),height_pixels(a1)	; set height, width and priority
		move.b	subtype(a0),subtype(a1)
		move.w	d2,x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	x_pos(a0),staircase.origX(a1)
		move.w	y_pos(a1),staircase.origY(a1)
		addi.w	#32,d2
		move.b	d3,staircase.offset(a1)
		move.w	a0,parent3(a1)
		add.b	d4,d3
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.create							; if not, loop

.notfree
		move.l	#.move,address(a0)

.move
		moveq	#7,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		move.w	Staircase_TypeIndex(pc,d0.w),d0
		jsr	Staircase_TypeIndex(pc,d0.w)

.solid
		movea.w	parent3(a0),a2							; a2=object
		moveq	#0,d0
		move.b	staircase.offset(a0),d0
		move.w	(a2,d0.w),d0
		add.w	staircase.origY(a0),d0
		move.w	d0,y_pos(a0)

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		swap	d6
		or.b	d6,staircase.status(a2)						; save status

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	staircase.origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w
; ---------------------------------------------------------------------------

Staircase_TypeIndex: offsetTable
		offsetTableEntry.w Staircase_Type00					; 0
		offsetTableEntry.w Staircase_Type01					; 1
		offsetTableEntry.w Staircase_Type02					; 2
		offsetTableEntry.w Staircase_Type01					; 3
		offsetTableEntry.w Staircase_Type00					; 4
		offsetTableEntry.w Staircase_Type03					; 5
		offsetTableEntry.w Staircase_Type02					; 6
		offsetTableEntry.w Staircase_Type03					; 7
; ---------------------------------------------------------------------------

Staircase_Type00:

		; wait
		tst.w	staircase.timer(a0)						; is timer over?
		bne.s	.wait								; if not, branch

		; check touch
		moveq	#touch_top_mask,d0
		and.b	staircase.status(a0),d0
		beq.s	.return
		move.w	#(1*60)/2,staircase.timer(a0)					; set wait

.return
		rts
; ---------------------------------------------------------------------------

.wait

		; wait
		subq.w	#1,staircase.timer(a0)						; is timer over?
		bne.s	.return								; if not, branch
		addq.b	#1,subtype(a0)							; next type
		rts
; ---------------------------------------------------------------------------

Staircase_Type02:

		; wait
		tst.w	staircase.timer(a0)						; is timer over?
		bne.s	.wait								; if not, branch

		; check touch
		moveq	#touch_bottom_mask,d0
		and.b	staircase.status(a0),d0
		beq.s	.return
		move.w	#1*60,staircase.timer(a0)					; set wait

.return
		rts
; ---------------------------------------------------------------------------

.wait

		; wait
		subq.w	#1,staircase.timer(a0)						; is timer over?
		bne.s	.shaking							; if not, branch
		addq.b	#1,subtype(a0)							; next type
		rts
; ---------------------------------------------------------------------------

.shaking

		; set blocks shaking
		lea	staircase.height(a0),a1						; a1=object
		move.w	staircase.timer(a0),d0
		lsr.b	#2,d0								; division by 4
		andi.b	#1,d0
		move.w	d0,(a1)+

	rept 3
		eori.b	#1,d0
		move.w	d0,(a1)+
	endr

		rts
; ---------------------------------------------------------------------------

Staircase_Type01:
		lea	staircase.height(a0),a1						; a1=object
		cmpi.w	#$80,(a1)
		beq.s	.return
		addq.w	#1,(a1)
		moveq	#0,d1
		move.w	(a1)+,d1
		swap	d1
		lsr.l	d1
		move.l	d1,d2
		lsr.l	d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.w	d3,(a1)+
		move.w	d2,(a1)+
		move.w	d1,(a1)+

.return
		rts
; ---------------------------------------------------------------------------

Staircase_Type03:
		lea	staircase.height(a0),a1						; a1=object
		cmpi.w	#-$80,(a1)
		beq.s	.return
		subq.w	#1,(a1)
		moveq	#0,d1
		move.w	(a1)+,d1
		swap	d1
		asr.l	d1
		move.l	d1,d2
		asr.l	d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.w	d3,(a1)+
		move.w	d2,(a1)+
		move.w	d1,(a1)+

.return
		rts
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Staircase/Object Data/Map - Staircase.asm"
