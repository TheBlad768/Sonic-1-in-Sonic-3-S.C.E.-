; ---------------------------------------------------------------------------
; Object XX - animated scenery
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_AnimatedStillSprite:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		move.l	#Map_AnimatedStillSprites,mappings_addr(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates

		; get
		move.w	subtype(a0),d0
		move.b	d0,anim(a0)							; set animation script id
		lsl.w	#3,d0								; multiply by 8
		lea	.index(pc,d0.w),a1
		move.l	(a1)+,priority(a0)						; set priority and VRAM
		move.w	(a1)+,height_pixels(a0)						; set height and width

		; check collision type
		move.l	#.anim,code_addr(a0)						; normal draw
		move.w	(a1)+,d0							; get collision type
		beq.s	.anim								; if it doesn't have collision, branch
		move.b	d0,collision_type(a0)						; set collision type
		move.w	(a1),collision_height(a0)					; set collision height and width
		move.l	#.anim_col,code_addr(a0)					; collision draw

.anim_col
		lea	Ani_AnimatedStillSprites(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

.anim
		lea	Ani_AnimatedStillSprites(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.index

		; object priority, VRAM, palette, priority, height, width, collision type, collision height, collision width

		; empty yet...								; 0
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Main/Still Sprites/Object Data/Anim - Still Sprites (Animated).asm"
		include "Objects/Main/Still Sprites/Object Data/Map - Still Sprites (Animated).asm"
