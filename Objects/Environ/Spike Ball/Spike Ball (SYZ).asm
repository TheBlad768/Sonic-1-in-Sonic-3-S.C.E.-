; ---------------------------------------------------------------------------
; Object 57 - spiked balls (SYZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

spikeball_syz.speed			ds.w 1						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall_SYZ:

		; init
		movem.l	ObjDat_SpikeBall_SYZ(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set spike ball collision type
		move.w	#bytes_to_word(8/2,8/2),collision_height(a0)			; set height and width collision

		; subtype
		moveq	#signextendB($F0),d1						; read only the 1st digit
		and.b	subtype.byte(a0),d1						; get object type
		ext.w	d1
		asl.w	#3,d1								; multiply by 8
		move.w	d1,spikeball_syz.speed(a0)					; set object twirl speed
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,circular_angle(a0)

		; get number of spike balls for CreateChild8_TreeListRepeated
		moveq	#7,d6								; read only the 2nd digit
		and.b	subtype.byte(a0),d6						; get object type
		subq.w	#1,d6								; set chain length (type-1)
		blo.s	.main
		btst	#3,subtype.byte(a0)						; 8?
		beq.s	.create
		subq.w	#1,d6
		blo.s	.main

.create

		; create spike balls object tree list
		pea	Obj_SpikeBall_SYZ_Child(pc)					; push address to the stack
		lea	(sp),a2								; load stack to a2
		moveq	#0,d2								; set subtype
		jsr	(CreateChild8_TreeListRepeated.create).w			; "
		addq.w	#4,sp								; return stack

.main

		; move
		move.w	spikeball_syz.speed(a0),d0
		sub.w	d0,circular_angle(a0)

		; draw
		jmp	(Sprite_CheckDeleteTouch).w

; ---------------------------------------------------------------------------
; Spiked ball (child)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall_SYZ_Child:

		; init
		movea.w	parent4(a0),a1							; a1=parent object
		move.b	render_flags(a1),render_flags(a0)				; copy render flags
		move.l	height_pixels(a1),height_pixels(a0)				; copy height, width and priority
		move.b	collision_type(a1),collision_type(a0)				; copy collision type
		move.w	collision_height(a1),collision_height(a0)			; copy collision height and width
		move.l	#.main,code_addr(a0)

.main

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
