; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

spinningconveyor.origX			ds.w 1						; original x-axis position (2 bytes)
spinningconveyor.origY			ds.w 1						; original y-axis position (2 bytes)
spinningconveyor.saveX			ds.w 1						; save x-axis position (2 bytes)
spinningconveyor.saveY			ds.w 1						; save y-axis position (2 bytes)
spinningconveyor.save_ptr		ds.l 1						; (4 bytes)
spinningconveyor.index			ds.b 1						; (1 byte)
spinningconveyor.limit			ds.b 1						; (1 byte)
spinningconveyor.offset			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SpinningConveyor:

		; check
		move.b	subtype(a0),d0
		andi.w	#$7F,d0

		; create platforms
		add.w	d0,d0								; multiply by 2
		lea	SpinningConveyor_Platform_Index(pc),a3
		adda.w	(a3,d0.w),a3

		; set
		move.w	(a3)+,d1							; get count
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		move.l	#Obj_SpinningConveyor_Platforms,d4
		movea.w	a0,a1								; load current object to a1

		; get current RAM slot in d0
		getobjectSlot a2

.create

		; create SBZ platform object
		move.l	d4,code_addr(a1)
		move.w	(a3)+,d0
		add.w	d2,d0
		move.w	d0,x_pos(a1)
		move.w	(a3)+,d0
		add.w	d3,d0
		move.w	d0,y_pos(a1)
		move.w	d2,spinningconveyor.origX(a1)
		move.w	d3,spinningconveyor.origY(a1)
		move.w	(a3)+,d5
		move.b	d5,subtype(a1)
		move.b	status(a0),status(a1)

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d1,.create
		rts

; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SpinningConveyor_Platforms:

		; init
		move.l	#Map_SpinningPlatform,mappings(a0)
		move.w	#make_art_tile($3C8,0,FALSE),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(14/2,32/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.l	#.main,code_addr(a0)

		; set
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	SpinningConveyor_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,spinningconveyor.index(a0)
		move.l	a2,spinningconveyor.save_ptr(a0)				; save ROM address
		andi.w	#$F,d1
		add.w	d1,d1								; multiply by 4
		add.w	d1,d1
		move.b	d1,spinningconveyor.index(a0)
		move.b	#4,spinningconveyor.offset(a0)					; set next conveyor positions

		; check
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_16356
		neg.b	spinningconveyor.offset(a0)						; change direction

		; set
		moveq	#0,d1
		move.b	spinningconveyor.index(a0),d1
		add.b	spinningconveyor.offset(a0),d1					; next conveyor positions
		cmp.b	spinningconveyor.limit(a0),d1					; are there still conveyor positions left here?
		blo.s	.loc_16352							; if so, branch
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	.loc_16352
		move.b	spinningconveyor.limit(a0),d1
		subq.b	#4,d1

.loc_16352
		move.b	d1,spinningconveyor.index(a0)

.loc_16356
		move.w	(a2,d1.w),d0
		add.w	spinningconveyor.origX(a0),d0
		move.w	d0,spinningconveyor.saveX(a0)
		move.w	2(a2,d1.w),d0
		add.w	spinningconveyor.origY(a0),d0
		move.w	d0,spinningconveyor.saveY(a0)

		; check
		tst.w	d1
		bne.s	.loc_1636C
		move.b	#1,anim(a0)

.loc_1636C
		cmpi.w	#8,d1
		bne.s	.loc_16378
		clr.b	anim(a0)

.loc_16378
		bsr.w	LCon_ChangeDir

.main
		lea	Ani_SpinningConveyor(pc),a1
		jsr	(Animate_SpriteNoSST).w

		; check animation
		tst.b	anim(a0)							; is spin anim?
		beq.s	.notsolid							; if yes, branch

		; move
		move.w	x_pos(a0),-(sp)
		bsr.s	sub_16424
		move.w	(sp)+,d4

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.checkdelete							; if not, branch

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		jsr	(SolidObjectFull).w

		; play continuous sfx
		sfxcont	sfx_ChainTick, $F						; play chain tick sound every 16th frame

.checkdelete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	spinningconveyor.origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w
; ---------------------------------------------------------------------------

.notsolid
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object
		bsr.s	sub_16424
		bra.s	.checkdelete

; =============== S U B R O U T I N E =======================================

sub_16424:
		move.w	x_pos(a0),d0
		cmp.w	spinningconveyor.saveX(a0),d0
		bne.s	.loc_16484
		move.w	y_pos(a0),d0
		cmp.w	spinningconveyor.saveY(a0),d0
		bne.s	.loc_16484
		moveq	#0,d1
		move.b	spinningconveyor.index(a0),d1
		add.b	spinningconveyor.offset(a0),d1					; next conveyor positions
		cmp.b	spinningconveyor.limit(a0),d1					; are there still conveyor positions left here?
		blo.s	.loc_16456							; if so, branch
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	.loc_16456
		move.b	spinningconveyor.limit(a0),d1
		subq.b	#4,d1

.loc_16456
		move.b	d1,spinningconveyor.index(a0)
		movea.l	spinningconveyor.save_ptr(a0),a1
		move.w	(a1,d1.w),d0
		add.w	spinningconveyor.origX(a0),d0
		move.w	d0,spinningconveyor.saveX(a0)
		move.w	2(a1,d1.w),d0
		add.w	spinningconveyor.origY(a0),d0
		move.w	d0,spinningconveyor.saveY(a0)
		tst.w	d1
		bne.s	.loc_16474
		move.b	#1,anim(a0)

.loc_16474
		cmpi.w	#8,d1
		bne.s	.loc_16480
		clr.b	anim(a0)

.loc_16480
		bsr.w	LCon_ChangeDir

.loc_16484
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Spinning Conveyor/Object Data/Data - Spinning Conveyor.asm"
		include "Objects/Environ/Spinning Conveyor/Object Data/Anim - Spinning Conveyor.asm"
