; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump, MZ brick, SYZ siren, LZ wheel, SLZ lava thrower)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_StillSprite:

		; init
		move.l	#Map_StillSprites,mappings(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates

		; get
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0								; multiply by 6
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	.index(pc,d0.w),a1
		move.l	(a1)+,priority(a0)						; set priority and VRAM
		move.w	(a1),height_pixels(a0)						; set height and width

		; draw
		lea	(Sprite_OnScreen_Test).w,a1
		move.l	a1,address(a0)
		jmp	(a1)
; ---------------------------------------------------------------------------

.index

		; GHZ (Bridge)								; 0
		StillSpritesEntry	1, $342, 2, 0, 32, 16

		; MZ (Brick)								; 1
		StillSpritesEntry	1, 1, 2, 0, 32, 32

		; SYZ (Siren)								; 2
		StillSpritesEntry	6, $11, 0, 0, 16, 32

		; LZ (Wheel)								; 3
		StillSpritesEntry	1, $3F6, 0, 0, 32, 32

		; SLZ (Cannon)								; 4
		StillSpritesEntry	2, $42C, 2, 0, 32, 16
; ---------------------------------------------------------------------------

		include "Objects/Main/Still Sprites/Object Data/Map - Still Sprites.asm"
