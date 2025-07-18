; ---------------------------------------------------------------------------
; Object 5B - blocks that form a staircase (SLZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
stair_parent			= objoff_3E ; address of parent object (2 bytes)

stair_origX			= objoff_44 ; original x-axis position (2 bytes)
stair_origY			= objoff_46 ; original y-axis position (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_Staircase:

		; init
		ori.b	#setBit(render_flags.level)|setBit(render_flags.static_mappings),render_flags(a0)	; set static mapping and screen coordinates flag
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
		moveq	#$34,d3
		moveq	#2,d4
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		moveq	#$3A,d3
		moveq	#-2,d4

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
		move.l	#Map_Stair,mappings(a1)
		move.w	#make_art_tile(0,2,0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	#bytes_word_to_long(32/2,32/2,priority_3),height_pixels(a1)	; set height, width and priority
		move.b	subtype(a0),subtype(a1)
		move.w	d2,x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	x_pos(a0),objoff_44(a1)
		move.w	y_pos(a1),objoff_46(a1)
		addi.w	#32,d2
		move.b	d3,objoff_33(a1)
		move.w	a0,objoff_3E(a1)						; parent
		add.b	d4,d3
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.create							; if not, loop

.notfree
		move.l	#.move,address(a0)

.move
		moveq	#7,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		move.w	Stair_TypeIndex(pc,d0.w),d0
		jsr	Stair_TypeIndex(pc,d0.w)

.solid
		movea.w	objoff_3E(a0),a2						; a2=object
		moveq	#0,d0
		move.b	objoff_33(a0),d0
		move.w	(a2,d0.w),d0
		add.w	objoff_46(a0),d0
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
		or.b	d6,objoff_32(a2)						; save status

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_44(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w
; ---------------------------------------------------------------------------

Stair_TypeIndex: offsetTable
		offsetTableEntry.w Stair_Type00						; 0
		offsetTableEntry.w Stair_Type01						; 1
		offsetTableEntry.w Stair_Type02						; 2
		offsetTableEntry.w Stair_Type01						; 3
		offsetTableEntry.w Stair_Type00						; 4
		offsetTableEntry.w Stair_Type03						; 5
		offsetTableEntry.w Stair_Type02						; 6
		offsetTableEntry.w Stair_Type03						; 7
; ---------------------------------------------------------------------------

Stair_Type00:
		tst.w	objoff_30(a0)
		bne.s	loc_47762
		moveq	#touch_top_mask,d0
		and.b	objoff_32(a0),d0
		beq.s	locret_47760
		move.w	#(1*60)/2,objoff_30(a0)

locret_47760:
		rts
; ---------------------------------------------------------------------------

loc_47762:
		subq.w	#1,objoff_30(a0)
		bne.s	locret_47760
		addq.b	#1,subtype(a0)
		rts
; ---------------------------------------------------------------------------

Stair_Type02:
		tst.w	objoff_30(a0)
		bne.s	loc_4778C
		moveq	#touch_bottom_mask,d0
		and.b	objoff_32(a0),d0
		beq.s	locret_4778A
		move.w	#1*60,objoff_30(a0)

locret_4778A:
		rts
; ---------------------------------------------------------------------------

loc_4778C:
		subq.w	#1,objoff_30(a0)
		bne.s	loc_4779E
		addq.b	#1,subtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_4779E:
		lea	objoff_34(a0),a1						; a1=object
		move.w	objoff_30(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.w	d0,(a1)+
		eori.b	#1,d0
		move.w	d0,(a1)+
		eori.b	#1,d0
		move.w	d0,(a1)+
		eori.b	#1,d0
		move.w	d0,(a1)+
		rts
; ---------------------------------------------------------------------------

Stair_Type01:
		lea	objoff_34(a0),a1						; a1=object
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

Stair_Type03:
		lea	objoff_34(a0),a1						; a1=object
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

		include "Objects/Environ/Staircase/Object Data/Map - Staircase.asm"
