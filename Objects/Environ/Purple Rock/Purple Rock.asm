; ---------------------------------------------------------------------------
; Object 3B - purple rock (GHZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_PurpleRock:

		; init
		movem.l	ObjDat_PurpleRock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

.solid
		moveq	#(32/2)+$B,d1							; width
		moveq	#32/2,d2							; height
		move.w	d2,d3
		addq.w	#1,d3								; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; draw
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_PurpleRock:	subObjMainData Obj_PurpleRock.solid, setBit(render_flags.level), 0, 40, 48, 4, $380, 3, 0, Map_PRock
; ---------------------------------------------------------------------------

		include "Objects/Environ/Purple Rock/Object Data/Map - Purple Rock.asm"