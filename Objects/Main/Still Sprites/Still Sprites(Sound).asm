; ---------------------------------------------------------------------------
; Object XX - sound scenery
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SoundStillSprite:

		; get
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	.index(pc,d0.w),objoff_30(a0)
		move.l	#.main,address(a0)

.main

		; play sound
		move.b	objoff_30(a0),d0
		move.b	objoff_31(a0),d1
		jsr	(Play_SFX_Continuous).w

		; check delete
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

.index

		; GHZ (Waterfall)							; 0
		dc.b sfx_Waterfall, $F							; play water sound every 16th frame