; ---------------------------------------------------------------------------
; Object 57 - spiked balls (SYZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
sball_angle			= objoff_3C	; angle (1 byte)
sball_speed			= objoff_3E	; rate of spin (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall:

		; init
		movem.l	ObjDat_SpikeBall(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; subtype
		moveq	#signextendB($F0),d1						; read only the 1st digit
		and.b	subtype(a0),d1							; get object type
		ext.w	d1
		asl.w	#3,d1								; multiply by 8
		move.w	d1,sball_speed(a0)						; set object twirl speed
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,sball_angle(a0)

		; get RAM slot
		getobjectRAMslot a2
		bmi.s	.main								; branch, if object RAM slots ended

		; get current object address
		movea.w	a0,a1								; load current object to a1
		movea.w	a0,a3								; creates a linked object list

		; get number of spike balls
		moveq	#7,d1								; read only the 2nd digit
		and.b	subtype(a0),d1							; get object type
		subq.w	#1,d1								; set chain length (type-1)
		blo.s	.main
		btst	#3,subtype(a0)							; 8?
		beq.s	.makechain
		subq.w	#1,d1
		blo.s	.main

.makechain

		; create spike balls object

.find
		lea	next_object(a1),a1						; goto next object RAM slot
		tst.l	address(a1)							; is object RAM slot empty?
		dbeq	d0,.find							; if not, branch
		bne.s	.main								; branch, if object RAM slot is not empty
		subq.w	#1,d0								; dbeq didn't subtract sprite table so we'll do it ourselves

		; load object
		move.w	a3,parent3(a1)
		movea.w	a1,a3
		move.l	#Obj_SpikeBall_Child,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	priority(a0),priority(a1)
		move.w	height_pixels(a0),height_pixels(a1)				; set height and width
		move.b	#$18|collision_flags.npc.hurt,collision_flags(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.makechain							; if not, repeat for length of chain

.main
		move.w	sball_speed(a0),d0
		sub.w	d0,sball_angle(a0)
		jmp	(Sprite_CheckDelete).w

; ---------------------------------------------------------------------------
; Spiked ball (child)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall_Child:
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	sball_angle(a1),sball_angle(a0)					; angle
		moveq	#4,d2								; radius
		jsr	(MoveSprite_CircularSimple).w

		; draw
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_SpikeBall:	subObjMainData Obj_SpikeBall.main, setBit(render_flags.level)|setBit(render_flags.static_mappings), 0, 16, 16, 4, $3BA, 0, 0, Map_SBall
; ---------------------------------------------------------------------------

		include "Objects/Environ/Spiked Ball and Chain/Object Data/Map - Spiked Ball and Chain (SYZ).asm"
