; ---------------------------------------------------------------------------
; Object XX - animated scenery
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_AnimatedStillSprite:

		; init
		move.l	#Map_AnimatedStillSprites,mappings(a0)
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
		move.l	#.anim,address(a0)

.anim
		lea	Ani_AnimatedStillSprites(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.index

		; empty yet...								; 0
; ---------------------------------------------------------------------------

		include "Objects/Main/Still Sprites/Object Data/Anim - Still Sprites(Animated).asm"
		include "Objects/Main/Still Sprites/Object Data/Map - Still Sprites(Animated).asm"