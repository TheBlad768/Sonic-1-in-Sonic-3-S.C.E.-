; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ/SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

platformconveyor.origX			ds.w 1						; original x-axis position (2 bytes)
platformconveyor.origY			ds.w 1						; original y-axis position (2 bytes)
platformconveyor.saveX			ds.w 1						; save x-axis position (2 bytes)
platformconveyor.saveY			ds.w 1						; save y-axis position (2 bytes)
platformconveyor.save_ptr		ds.l 1						; (4 bytes)
platformconveyor.index			ds.b 1						; (1 byte)
platformconveyor.limit			ds.b 1						; (1 byte)
platformconveyor.offset			ds.b 1						; (1 byte)
platformconveyor.rev_flag		ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_PlatformConveyorMaker:

		; set
		moveq	#$7F,d0
		and.b	subtype.byte(a0),d0

		; create platforms
		lea	LabyrinthPlatformConveyor_Platform_Index(pc),a3
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		bne.s	.load								; if not, branch
		lea	SpinningPlatformConveyor_Platform_Index(pc),a3

.load
		add.w	d0,d0								; multiply by 2
		adda.w	(a3,d0.w),a3

		; set
		move.w	(a3)+,d1							; get count
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		move.l	#Obj_PlatformConveyor_Platforms,d4
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
		movem.w	d2-d3,platformconveyor.origX(a1)
		move.w	(a3)+,d5
		move.b	d5,subtype.byte(a1)
		move.b	status(a0),status(a1)

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d1,.create
		rts

; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ/SBZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_PlatformConveyor_Platforms:

		; init
		lea	ObjDat_LabyrinthPlatformConveyor(pc),a1
		lea	LabyrinthPlatformConveyor_Data(pc),a2
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		bne.s	.load								; if not, branch
		lea	ObjDat_SpinningPlatformConveyor(pc),a1
		lea	SpinningPlatformConveyor_Data(pc),a2

.load
		movem.l	(a1),d0-d3							; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object

		; set
		move.b	subtype.byte(a0),d0
		move.b	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,platformconveyor.index(a0)
		move.l	a2,platformconveyor.save_ptr(a0)				; save ROM address
		andi.w	#$F,d1
		add.w	d1,d1								; multiply by 4
		add.w	d1,d1
		move.b	d1,platformconveyor.index(a0)
		move.b	#4,platformconveyor.offset(a0)					; set next conveyor positions

		; check level
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		beq.s	SpinningPlatformConveyor_Platforms				; if yes, branch

; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

		; check reverse flag
		lea	PlatformConveyor_Platforms_Move.load(pc),a1
		tst.b	(Conveyor_reverse_flag).w
		beq.s	.jump
		st	platformconveyor.rev_flag(a0)
		neg.b	platformconveyor.offset(a0)					; change direction
		lea	PlatformConveyor_Platforms_Move.main(pc),a1

.jump
		jsr	(a1)

.main

		; move
		move.w	x_pos(a0),-(sp)
		bsr.w	PlatformConveyor_Platforms_LabyrinthMove
		jsr	(MoveSprite2).w
		move.w	(sp)+,d4

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	SpinningPlatformConveyor_Platforms.checkdelete			; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		jsr	(SolidObjectTop).w

		; play sfx and check delete
		bra.s	SpinningPlatformConveyor_Platforms.sfx

; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpinningPlatformConveyor_Platforms:

		; check
		lea	PlatformConveyor_Platforms_Move.load(pc),a1
		btst	#status.npc.x_flip,status(a0)
		beq.s	.jump
		neg.b	platformconveyor.offset(a0)					; change direction
		lea	PlatformConveyor_Platforms_Move.main(pc),a1

.jump
		jsr	(a1)

.main
		lea	Ani_SpinningPlatformConveyor(pc),a1
		jsr	(Animate_SpriteNoSST).w

		; check animation
		tst.b	anim(a0)							; is spin anim?
		beq.s	.notsolid							; if yes, branch

		; move
		move.w	x_pos(a0),-(sp)
		bsr.s	PlatformConveyor_Platforms_Move
		jsr	(MoveSprite2).w
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

.sfx

		; play continuous sfx
		sfxcont	sfx_ChainTick, $F						; play chain tick sound every 16th frame

.checkdelete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	platformconveyor.origX(a0),d0					; get object position
		jmp	(Sprite_OnScreen_Test2).w
; ---------------------------------------------------------------------------

.notsolid
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object
		bsr.s	PlatformConveyor_Platforms_Move
		jsr	(MoveSprite2).w
		bra.s	.checkdelete

; ---------------------------------------------------------------------------
; Labyrinth conveyor platforms move
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PlatformConveyor_Platforms_LabyrinthMove:

		; check button flag
		tst.b	(Level_trigger_array+$E).w					; has switch number $0E been pressed?
		beq.s	PlatformConveyor_Platforms_Move					; if not, branch

		; check reverse flag
		tst.b	platformconveyor.rev_flag(a0)
		bne.s	PlatformConveyor_Platforms_Move
		st	platformconveyor.rev_flag(a0)
		st	(Conveyor_reverse_flag).w
		neg.b	platformconveyor.offset(a0)
		bra.s	PlatformConveyor_Platforms_Move.main
; ---------------------------------------------------------------------------

PlatformConveyor_Platforms_Move:

		; check xypos
		move.w	x_pos(a0),d0
		sub.w	platformconveyor.saveX(a0),d0
		move.w	y_pos(a0),d1
		sub.w	platformconveyor.saveY(a0),d1
		or.w	d0,d1
		beq.s	.main
		rts
; ---------------------------------------------------------------------------

.main

		; set
		moveq	#0,d1
		move.b	platformconveyor.index(a0),d1
		add.b	platformconveyor.offset(a0),d1					; next conveyor positions
		bpl.s	.checkmax
		move.b	platformconveyor.limit(a0),d1
		subq.b	#4,d1
		bra.s	.set
; ---------------------------------------------------------------------------

.framearray	dc.b 1, 1, 0, 0
	even
; ---------------------------------------------------------------------------

.checkmax
		cmp.b	platformconveyor.limit(a0),d1					; are there still conveyor positions left here?
		blo.s	.set								; if so, branch
		moveq	#0,d1

.set
		move.b	d1,platformconveyor.index(a0)

.load

		; load pointer
		movea.l	platformconveyor.save_ptr(a0),a1
		movem.w	(a1,d1.w),d0/d2
		add.w	platformconveyor.origX(a0),d0
		add.w	platformconveyor.origY(a0),d2
		movem.w	d0/d2,platformconveyor.saveX(a0)

		; check level
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		bne.s	PlatformConveyor_ChangeDirection				; if not, branch

		; set frame
		lsr.w	#2,d1								; division by 4
		move.b	.framearray(pc,d1.w),anim(a0)

; ---------------------------------------------------------------------------
; Labyrinth conveyor change direction
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PlatformConveyor_ChangeDirection:
		moveq	#0,d0
		move.w	#-$100,d2
		move.w	x_pos(a0),d0
		sub.w	platformconveyor.saveX(a0),d0
		bhs.s	.absx
		neg.w	d0
		neg.w	d2

.absx
		moveq	#0,d1
		move.w	#-$100,d3
		move.w	y_pos(a0),d1
		sub.w	platformconveyor.saveY(a0),d1
		bhs.s	.absy
		neg.w	d1
		neg.w	d3

.absy
		cmp.w	d0,d1
		blo.s	.move_xaxis
		move.w	x_pos(a0),d0
		sub.w	platformconveyor.saveX(a0),d0
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
		sub.w	platformconveyor.saveY(a0),d1
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

; =============== S U B R O U T I N E =======================================

; init
ObjDat_LabyrinthPlatformConveyor:	subObjMainData \
				Obj_PlatformConveyor_Platforms.main, \
					setBit(render_flags.level) | \
					setBit(render_flags.static_mappings), \
				0, 32, 32, 4, $406, 2, FALSE, Map_LabyrinthPlatformConveyor_Platform

ObjDat_SpinningPlatformConveyor:	subObjMainData SpinningPlatformConveyor_Platforms.main, setBit(render_flags.level), 0, 14, 32, 4, $3C8, 0, FALSE, Map_SpinningPlatform
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Platform Conveyor/Object Data/Anim - Spinning Platform Conveyor.asm"
		include "Objects/Environ/Platform Conveyor/Object Data/Map - Labyrinth Platform Conveyor Platform.asm"
		include "Objects/Environ/Platform Conveyor/Object Data/Data - Labyrinth Platform Conveyor.asm"
		include "Objects/Environ/Platform Conveyor/Object Data/Data - Spinning Platform Conveyor.asm"

