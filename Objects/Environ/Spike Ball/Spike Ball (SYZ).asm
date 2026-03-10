; ---------------------------------------------------------------------------
; Object 57 - spiked balls (SYZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

spikeball_syz.speed			ds.w 1						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall_SYZ:

		; init
		movem.l	ObjDat_SpikeBall_SYZ(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; subtype
		moveq	#signextendB($F0),d1						; read only the 1st digit
		and.b	subtype(a0),d1							; get object type
		ext.w	d1
		asl.w	#3,d1								; multiply by 8
		move.w	d1,spikeball_syz.speed(a0)					; set object twirl speed
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,circular_angle(a0)

		; get current RAM slot in d0
		getobjectSlot a2

		; get current object address
		movea.w	a0,a1								; load current object to a1
		movea.w	a0,a3								; creates a linked object list

		; get number of spike balls
		moveq	#7,d1								; read only the 2nd digit
		and.b	subtype(a0),d1							; get object type
		subq.w	#1,d1								; set chain length (type-1)
		blo.s	.main
		btst	#3,subtype(a0)							; 8?
		beq.s	.create
		subq.w	#1,d1
		blo.s	.main

.create

		; create spike balls object tree list
		move.w	a3,parent3(a1)							; parent RAM address into parent3
;		move.w	a0,parent4(a1)							; parent RAM address into parent4
		movea.w	a1,a3								; next parent RAM address
		move.l	#Obj_SpikeBall_SYZ_Child,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	priority(a0),priority(a1)
		move.w	height_pixels(a0),height_pixels(a1)				; set height and width
		move.b	#$18|collision_flags.npc.hurt,collision_flags(a1)		; SYZ specific code (chain hurts Sonic)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d1,.create

.main
		move.w	spikeball_syz.speed(a0),d0
		sub.w	d0,circular_angle(a0)
		jmp	(Sprite_CheckDeleteTouch).w

; ---------------------------------------------------------------------------
; Spiked ball (child)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall_SYZ_Child:

		; move
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	circular_angle(a1),circular_angle(a0)				; angle
		moveq	#4,d2								; radius
		jsr	(MoveSprite_CircularSimple).w

		; draw
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_SpikeBall_SYZ:	subObjMainData \
				Obj_SpikeBall_SYZ.main, \
					setBit(render_flags.level) | \
					setBit(render_flags.static_mappings), \
				0, 16, 16, 4, $3BA, 0, FALSE, Map_SpikeBall_SYZ
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Spike Ball/Object Data/Map - Spike Ball (SYZ).asm"
