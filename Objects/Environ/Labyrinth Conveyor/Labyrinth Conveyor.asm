; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
conv_subtype			= objoff_2F	; .b ; save subtype
conv_origX			= objoff_30	; .w ; original x-axis position

conv_saveX			= objoff_34	; .w
conv_saveY			= objoff_36	; .w
conv_origY			= objoff_38	; .w ; original y-axis position
conv_flag			= objoff_3E	; .b
conv_flag2			= objoff_3F	; .b
conv_pointer			= objoff_40	; .l ; save address

; =============== S U B R O U T I N E =======================================

Obj_LabyrinthConvey:

		; check
		move.b	subtype(a0),d0
		move.b	d0,conv_subtype(a0)
		andi.w	#$7F,d0
		lea	(Convey_rev_buffer).w,a2
		bset	#0,(a2,d0.w)
		bne.w	LCon_CheckDelete.offscreen

		; create
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	ObjPosLZPlatform_Index(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d1
		movea.w	a0,a1								; load current object to a1

		; get RAM slot
		getobjectRAMslot a3
		bra.s	.load
; ---------------------------------------------------------------------------

.create

		; create LZ platform object

.find
		lea	next_object(a1),a1						; goto next object RAM slot
		tst.l	address(a1)							; is object RAM slot empty?
		dbeq	d0,.find							; if not, branch
		bne.s	.return								; branch, if object RAM slot is not empty
		subq.w	#1,d0								; subtract from sprite table

.load
		move.l	#Obj_LabyrinthConvey_Platforms,address(a1)
		move.w	(a2)+,x_pos(a1)
		move.w	(a2)+,y_pos(a1)
		move.w	(a2)+,d2
		move.b	d2,subtype(a1)
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.create							; if not, loop

.return
		rts

; =============== S U B R O U T I N E =======================================

Obj_LabyrinthConvey_Platforms:

		; init
		move.l	#Map_LConv_Platform,mappings(a0)
		move.w	#make_art_tile($406,2,0),art_tile(a0)
		ori.b	#setBit(render_flags.level)|setBit(render_flags.static_mappings),render_flags(a0)	; set static mapping and screen coordinates flag
		move.l	#bytes_word_to_long(32/2,32/2,priority_4),height_pixels(a0)	; set height, width and priority
		addq.b	#1,mapping_frame(a0)						; platform frame
		move.l	#sub_124B2,address(a0)

		; set
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	LCon_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,conv_origY(a0)
		move.w	(a2)+,conv_origX(a0)
		move.l	a2,conv_pointer(a0)
		andi.w	#$F,d1
		add.w	d1,d1
		add.w	d1,d1
		move.b	d1,conv_origY(a0)
		move.b	#4,conv_flag(a0)
		tst.b	(Convey_rev_flag).w
		beq.s	loc_1244C
		move.b	#1,conv_flag2(a0)
		neg.b	conv_flag(a0)
		moveq	#0,d1
		move.b	conv_origY(a0),d1
		add.b	conv_flag(a0),d1
		cmp.b	conv_origY+1(a0),d1
		blo.s	loc_12448
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_12448
		move.b	conv_origY+1(a0),d1
		subq.b	#4,d1

loc_12448:
		move.b	d1,conv_origY(a0)

loc_1244C:
		move.l	(a2,d1.w),conv_saveX(a0)
		bsr.w	LCon_ChangeDir

; =============== S U B R O U T I N E =======================================

sub_124B2:
		move.w	x_pos(a0),-(sp)
		bsr.s	sub_12502
		move.w	(sp)+,d4
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		jsr	(SolidObjectTop).w

LCon_CheckDelete:
		out_of_xrange.s	.loc_1236A,conv_origX(a0)

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.loc_1236A
		cmpi.b	#2,(Current_act).w						; check if act is 3
		bne.s	.loc_12378							; if not, branch
		cmpi.w	#-$80,d0
		bhs.s	.draw

.loc_12378
		move.b	conv_subtype(a0),d0
		bpl.s	.offscreen
		andi.w	#$7F,d0
		lea	(Convey_rev_buffer).w,a2
		bclr	#0,(a2,d0.w)

.offscreen
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#7,(a2)

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_12502:
		tst.b	(Level_trigger_array+$E).w
		beq.s	loc_12520
		tst.b	conv_flag2(a0)
		bne.s	loc_12520
		move.b	#1,conv_flag2(a0)
		move.b	#1,(Convey_rev_flag).w
		neg.b	conv_flag(a0)
		bra.s	loc_12534
; ---------------------------------------------------------------------------

loc_12520:
		move.w	x_pos(a0),d0
		cmp.w	conv_saveX(a0),d0
		bne.s	loc_1256A
		move.w	y_pos(a0),d0
		cmp.w	conv_saveY(a0),d0
		bne.s	loc_1256A

loc_12534:
		moveq	#0,d1
		move.b	conv_origY(a0),d1
		add.b	conv_flag(a0),d1
		cmp.b	conv_origY+1(a0),d1
		blo.s	loc_12552
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_12552
		move.b	conv_origY+1(a0),d1
		subq.b	#4,d1

loc_12552:
		move.b	d1,conv_origY(a0)
		movea.l	conv_pointer(a0),a1
		move.l	(a1,d1.w),conv_saveX(a0)
		bsr.s	LCon_ChangeDir

loc_1256A:
		jmp	(MoveSprite2).w

; =============== S U B R O U T I N E =======================================

LCon_ChangeDir:
		moveq	#0,d0
		move.w	#-$100,d2
		move.w	x_pos(a0),d0
		sub.w	conv_saveX(a0),d0
		bhs.s	loc_12584
		neg.w	d0
		neg.w	d2

loc_12584:
		moveq	#0,d1
		move.w	#-$100,d3
		move.w	y_pos(a0),d1
		sub.w	conv_saveY(a0),d1
		bhs.s	loc_12598
		neg.w	d1
		neg.w	d3

loc_12598:
		cmp.w	d0,d1
		blo.s	loc_125C2
		move.w	x_pos(a0),d0
		sub.w	conv_saveX(a0),d0
		beq.s	loc_125AE
		ext.l	d0
		asl.l	#8,d0
		divs.w	d1,d0
		neg.w	d0

loc_125AE:
		movem.w	d0/d3,x_vel(a0)
		swap	d0
		move.w	d0,x_pos+2(a0)
		clr.w	y_pos+2(a0)
		rts
; ---------------------------------------------------------------------------

loc_125C2:
		move.w	y_pos(a0),d1
		sub.w	conv_saveY(a0),d1
		beq.s	loc_125D4
		ext.l	d1
		asl.l	#8,d1
		divs.w	d0,d1
		neg.w	d1

loc_125D4:
		move.w	d1,y_vel(a0)
		move.w	d2,x_vel(a0)
		swap	d1
		move.w	d1,y_pos+2(a0)
		clr.w	x_pos+2(a0)
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Labyrinth Conveyor/Object Data/Data - Labyrinth Conveyor.asm"
		include "Objects/Environ/Labyrinth Conveyor/Object Data/Map - Labyrinth Conveyor Platform.asm"
