; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

spinconvey.origX			ds.w 1						; original x-axis position (2 bytes)
spinconvey.origY			ds.w 1						; original y-axis position (2 bytes)
spinconvey.copyX			ds.w 1						; copy x-axis position (2 bytes)
spinconvey.copyY			ds.w 1						; copy y-axis position (2 bytes)
spinconvey.pointer			ds.l 1						; (4 bytes)
spinconvey.flag				ds.b 1						; (1 byte)
spinconvey.flag2			ds.b 1						; (1 byte)
spinconvey.subtype			ds.b 1						; save subtype (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SpinConvey:

		; check
		move.b	subtype(a0),d0
		bmi.w	sub_16380

.platform

		; init
		move.l	#Map_Spin,mappings(a0)
		move.w	#make_art_tile($3C8,0,FALSE),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(14/2,32/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.l	#sub_163D8,address(a0)

		; set
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	SCon_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,spinconvey.origY(a0)
		move.w	(a2)+,spinconvey.origX(a0)
		move.l	a2,spinconvey.pointer(a0)
		andi.w	#$F,d1
		add.w	d1,d1
		add.w	d1,d1
		move.b	d1,spinconvey.origY(a0)
		move.b	#4,spinconvey.flag(a0)
		tst.b	(Convey_rev_flag).w
		beq.s	loc_16356
		move.b	#1,spinconvey.flag2(a0)
		neg.b	spinconvey.flag(a0)
		moveq	#0,d1
		move.b	spinconvey.origY(a0),d1
		add.b	spinconvey.flag(a0),d1
		cmp.b	spinconvey.origY+1(a0),d1
		blo.s	loc_16352
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16352
		move.b	spinconvey.origY+1(a0),d1
		subq.b	#4,d1

loc_16352:
		move.b	d1,spinconvey.origY(a0)

loc_16356:
		move.l	(a2,d1.w),spinconvey.copyX(a0)
		tst.w	d1
		bne.s	loc_1636C
		move.b	#1,anim(a0)

loc_1636C:
		cmpi.w	#8,d1
		bne.s	loc_16378
		clr.b	anim(a0)

loc_16378:
		bsr.w	LCon_ChangeDir
		bra.s	sub_163D8

; =============== S U B R O U T I N E =======================================

sub_16380:
		move.b	d0,spinconvey.subtype(a0)
		andi.w	#$7F,d0
		lea	(Convey_rev_buffer).w,a2
		bset	#0,(a2,d0.w)
		bne.w	SpinC_CheckDelete.chkdel

		; create
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	ObjPosSBZPlatform_Index(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d1
		movea.w	a0,a1								; load current object to a1

		; get RAM slot
		getobjectRAMslot a3
		bra.s	.load
; ---------------------------------------------------------------------------

.create

		; create SBZ platform object

.find
		lea	next_object(a1),a1						; goto next object RAM slot
		tst.l	address(a1)							; is object RAM slot empty?
		dbeq	d0,.find							; if not, branch
		bne.s	.return								; branch, if object RAM slot is not empty
		subq.w	#1,d0								; subtract from sprite table

.load
		move.l	#Obj_SpinConvey.platform,address(a1)
		move.w	(a2)+,x_pos(a1)
		move.w	(a2)+,y_pos(a1)
		move.w	(a2)+,d2
		move.b	d2,subtype(a1)
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.create							; if not, loop

.return
		rts

; =============== S U B R O U T I N E =======================================

sub_163D8:
		lea	Ani_SpinConvey(pc),a1
		jsr	(Animate_Sprite).w
		tst.b	anim(a0)							; is spin anim?
		beq.s	SpinC_NotSolid							; if yes, branch

		; move
		move.w	x_pos(a0),-(sp)
		bsr.s	sub_16424
		move.w	(sp)+,d4

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	SpinC_CheckDelete						; if not, branch

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		jsr	(SolidObjectFull).w

SpinC_CheckDelete:
		out_of_xrange.s	.offscreen,spinconvey.origX(a0)

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen
		cmpi.b	#2,(Current_act).w						; check if act is 3
		bne.s	.checkbuffer							; if not, branch
		cmpi.w	#-$80,d0
		bhs.s	.draw

.checkbuffer
		move.b	spinconvey.subtype(a0),d0
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

; =============== S U B R O U T I N E =======================================

SpinC_NotSolid:
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object
		bsr.s	sub_16424
		bra.s	SpinC_CheckDelete

; =============== S U B R O U T I N E =======================================

sub_16424:
		move.w	x_pos(a0),d0
		cmp.w	spinconvey.copyX(a0),d0
		bne.s	loc_16484
		move.w	y_pos(a0),d0
		cmp.w	spinconvey.copyY(a0),d0
		bne.s	loc_16484
		moveq	#0,d1
		move.b	spinconvey.origY(a0),d1
		add.b	spinconvey.flag(a0),d1
		cmp.b	spinconvey.origY+1(a0),d1
		blo.s	loc_16456
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16456
		move.b	spinconvey.origY+1(a0),d1
		subq.b	#4,d1

loc_16456:
		move.b	d1,spinconvey.origY(a0)
		movea.l	spinconvey.pointer(a0),a1
		move.l	(a1,d1.w),spinconvey.copyX(a0)
		tst.w	d1
		bne.s	loc_16474
		move.b	#1,anim(a0)

loc_16474:
		cmpi.w	#8,d1
		bne.s	loc_16480
		clr.b	anim(a0)

loc_16480:
		bsr.w	LCon_ChangeDir

loc_16484:
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Spin Platform Conveyor/Object Data/Data - Spin Platform Conveyor.asm"
		include "Objects/Environ/Spin Platform Conveyor/Object Data/Anim - Spin Platform Conveyor.asm"
