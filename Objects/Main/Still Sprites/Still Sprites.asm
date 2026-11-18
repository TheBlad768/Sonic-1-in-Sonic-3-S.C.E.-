; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump, MZ brick, SYZ siren, LZ wheel, SLZ lava thrower)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_StillSprite:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		move.l	#Map_StillSprites,mappings_addr(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates

		; get
		move.w	subtype(a0),d0
		move.b	d0,mapping_frame(a0)						; set mapping frame
		lsl.w	#3,d0								; multiply by 8
		lea	.index(pc,d0.w),a1
		move.l	(a1)+,priority(a0)						; set priority and VRAM
		move.w	(a1)+,height_pixels(a0)						; set height and width

		; check collision type
		lea	(Sprite_OnScreen_Test).w,a2					; normal draw
		move.w	(a1)+,d0							; get collision type
		beq.s	.set								; if it doesn't have collision, branch
		move.b	d0,collision_type(a0)						; set collision type
		move.w	(a1),collision_height(a0)					; set collision height and width
		lea	(Sprite_OnScreen_Test_Collision).w,a2				; collision draw

.set

		; draw
		move.l	a2,code_addr(a0)
		jmp	(a2)
; ---------------------------------------------------------------------------

.index

		; object priority, VRAM, palette, priority, height, width, collision type, collision height, collision width

		; 0 ; GHZ (Bridge)
		stillspritesobjdata	1, $342, 2, FALSE, 16, 32, collision_type.npc.none, 0, 0

		; 1 ; MZ (Brick)
		stillspritesobjdata	1, 1, 2, FALSE, 32, 32, collision_type.npc.none, 0, 0

		; 2 ; SYZ (Siren)
		stillspritesobjdata	6, $11, 0, FALSE, 16, 32, collision_type.npc.none, 0, 0

		; 3 ; LZ (Wheel)
		stillspritesobjdata	1, $3F6, 0, FALSE, 32, 32, collision_type.npc.none, 0, 0

		; 4 ; SLZ (Cannon)
		stillspritesobjdata	2, $42C, 2, FALSE, 32, 16, collision_type.npc.none, 0, 0
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Main/Still Sprites/Object Data/Map - Still Sprites.asm"
