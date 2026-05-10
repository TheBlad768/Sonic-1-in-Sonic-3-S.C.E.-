; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

labyrinthconveyor.origX			ds.w 1						; original x-axis position (2 bytes)
labyrinthconveyor.origY			ds.w 1						; original y-axis position (2 bytes)
labyrinthconveyor.saveX			ds.w 1						; save x-axis position (2 bytes)
labyrinthconveyor.saveY			ds.w 1						; save y-axis position (2 bytes)
labyrinthconveyor.save_ptr		ds.l 1						; (4 bytes)
labyrinthconveyor.index			ds.b 1						; (1 byte)
labyrinthconveyor.limit			ds.b 1						; (1 byte)
labyrinthconveyor.offset		ds.b 1						; (1 byte)
labyrinthconveyor.rev_flag		ds.b 1						; (1 byte)
labyrinthconveyor.subtype.byte		ds.b 1						; save subtype (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_LabyrinthConveyor:

		; set
		move.b	subtype.byte(a0),d0
		move.b	d0,labyrinthconveyor.subtype.byte(a0)
		andi.w	#$7F,d0

		; check same object subtype
		lea	(Convey_rev_buffer).w,a2
		bset	#0,(a2,d0.w)
		bne.w	Obj_LabyrinthConveyor_Platforms.chkdel				; if the same object subtype already exists, delete it

		; create platforms
		add.w	d0,d0								; multiply by 2
		lea	LabyrinthConveyor_Platform_Index(pc),a3
		adda.w	(a3,d0.w),a3

		; set
		move.w	(a3)+,d1							; get count
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		move.l	#Obj_LabyrinthConveyor_Platforms,d4
		movea.w	a0,a1								; load current object to a1

		; get current RAM slot in d0
		getobjectSlot a2

.create

		; create LZ platform object
		move.l	d4,code_addr(a1)
		move.w	(a3)+,d0
		add.w	d2,d0
		move.w	d0,x_pos(a1)
		move.w	(a3)+,d0
		add.w	d3,d0
		move.w	d0,y_pos(a1)
		movem.w	d2-d3,labyrinthconveyor.origX(a1)
		move.w	(a3)+,d5
		move.b	d5,subtype.byte(a1)
		move.b	status(a0),status(a1)

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d1,.create
		rts

; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_LabyrinthConveyor_Platforms:

		; init
		move.l	#Map_LabyrinthConveyor_Platform,mappings(a0)
		move.w	#make_art_tile($406,2,FALSE),art_tile(a0)

		; set static mapping and screen coordinates flag
		ori.b	#( \
			setBit(render_flags.level) | \
			setBit(render_flags.static_mappings) \
		),render_flags(a0)

		move.l	#bytes_word_to_long(32/2,32/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.l	#.main,code_addr(a0)

		; set
		move.b	subtype.byte(a0),d0
		move.b	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	LabyrinthConveyor_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,labyrinthconveyor.index(a0)
		move.l	a2,labyrinthconveyor.save_ptr(a0)				; save ROM address
		andi.w	#$F,d1
		add.w	d1,d1								; multiply by 4
		add.w	d1,d1
		move.b	d1,labyrinthconveyor.index(a0)
		move.b	#4,labyrinthconveyor.offset(a0)					; set next conveyor positions

		; check reverse flag
		lea	LabyrinthConveyor_Platforms_Move.load(pc),a1
		tst.b	(Convey_rev_flag).w
		beq.s	.jump
		st	labyrinthconveyor.rev_flag(a0)
		neg.b	labyrinthconveyor.offset(a0)					; change direction
		lea	LabyrinthConveyor_Platforms_Move.main(pc),a1

.jump
		jsr	(a1)

.main

		; move
		move.w	x_pos(a0),-(sp)
		bsr.s	LabyrinthConveyor_Platforms_Move
		jsr	(MoveSprite2).w
		move.w	(sp)+,d4

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.checkdelete							; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		jsr	(SolidObjectTop).w

		; play continuous sfx
		sfxcont	sfx_ChainTick, $F						; play chain tick sound every 16th frame

.checkdelete
		out_of_xrange.s	.offscreen,labyrinthconveyor.origX(a0)

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen
		cmpi.b	#ACT_3,(Current_act).w						; check if act is 3
		bne.s	.checkbuffer							; if not, branch
		cmpi.w	#-$80,d0
		bhs.s	.draw

.checkbuffer
		move.b	labyrinthconveyor.subtype.byte(a0),d0
		bpl.s	.chkdel
		andi.w	#$7F,d0
		lea	(Convey_rev_buffer).w,a2
		bclr	#0,(a2,d0.w)

.chkdel
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#respawn_addr.state,(a2)					; turn on the slot

.delete
		jmp	(Delete_Current_Object).w

; ---------------------------------------------------------------------------
; Labyrinth conveyor platforms move
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_Platforms_Move:

		; check button flag
		tst.b	(Level_trigger_array+$E).w					; has switch number $0E been pressed?
		beq.s	.check								; if not, branch

		; check reverse flag
		tst.b	labyrinthconveyor.rev_flag(a0)
		bne.s	.check
		st	labyrinthconveyor.rev_flag(a0)
		st	(Convey_rev_flag).w
		neg.b	labyrinthconveyor.offset(a0)
		bra.s	.main
; ---------------------------------------------------------------------------

.check

		; check xypos
		move.w	x_pos(a0),d0
		sub.w	labyrinthconveyor.saveX(a0),d0
		move.w	y_pos(a0),d1
		sub.w	labyrinthconveyor.saveY(a0),d1
		or.w	d0,d1
		beq.s	.main
		rts
; ---------------------------------------------------------------------------

.main

		; set
		moveq	#0,d1
		move.b	labyrinthconveyor.index(a0),d1
		add.b	labyrinthconveyor.offset(a0),d1					; next conveyor positions
		cmp.b	labyrinthconveyor.limit(a0),d1					; are there still conveyor positions left here?
		blo.s	.set								; if so, branch
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	.set
		move.b	labyrinthconveyor.limit(a0),d1
		subq.b	#4,d1

.set
		move.b	d1,labyrinthconveyor.index(a0)

.load
		movea.l	labyrinthconveyor.save_ptr(a0),a1
		movem.w	(a1,d1.w),d0/d2
		add.w	labyrinthconveyor.origX(a0),d0
		add.w	labyrinthconveyor.origY(a0),d2
		movem.w	d0/d2,labyrinthconveyor.saveX(a0)

; ---------------------------------------------------------------------------
; Labyrinth conveyor change direction
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_ChangeDirection:
		moveq	#0,d0
		move.w	#-$100,d2
		move.w	x_pos(a0),d0
		sub.w	labyrinthconveyor.saveX(a0),d0
		bhs.s	.absx
		neg.w	d0
		neg.w	d2

.absx
		moveq	#0,d1
		move.w	#-$100,d3
		move.w	y_pos(a0),d1
		sub.w	labyrinthconveyor.saveY(a0),d1
		bhs.s	.absy
		neg.w	d1
		neg.w	d3

.absy
		cmp.w	d0,d1
		blo.s	.move_xaxis
		move.w	x_pos(a0),d0
		sub.w	labyrinthconveyor.saveX(a0),d0
		beq.s	.set_yvel							; if zero, skip
		ext.l	d0
		asl.l	#8,d0
		divs.w	d1,d0
		neg.w	d0

.set_yvel
		movem.w	d0/d3,x_vel(a0)
		swap	d0
		move.w	d0,x_sub(a0)
		clr.w	y_sub(a0)
		rts
; ---------------------------------------------------------------------------

.move_xaxis
		move.w	y_pos(a0),d1
		sub.w	labyrinthconveyor.saveY(a0),d1
		beq.s	.set_xvel							; if zero, skip
		ext.l	d1
		asl.l	#8,d1
		divs.w	d0,d1
		neg.w	d1

.set_xvel
		move.w	d1,y_vel(a0)
		move.w	d2,x_vel(a0)
		swap	d1
		move.w	d1,y_sub(a0)
		clr.w	x_sub(a0)
		rts
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Labyrinth Conveyor/Object Data/Data - Labyrinth Conveyor.asm"
		include "Objects/Environ/Labyrinth Conveyor/Object Data/Map - Labyrinth Conveyor Platform.asm"
