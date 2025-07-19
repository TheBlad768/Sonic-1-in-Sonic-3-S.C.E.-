; ---------------------------------------------------------------------------
; Object 16 - harpoon (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
harp_time			= objoff_2E	; time between stabbing/retracting

; =============== S U B R O U T I N E =======================================

Obj_Harpoon:

		; init
		lea	ObjDat_Harpoon(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.l	#.move,address(a0)

		; set
		move.b	subtype(a0),anim(a0)						; get type (vert/horiz)
		move.w	#1*60,harp_time(a0)						; set time to 1 second

.move
		lea	Ani_Harp(pc),a1
		jsr	(Animate_Sprite).w
		moveq	#0,d0
		move.b	mapping_frame(a0),d0						; get frame number
		move.b	.types(pc,d0.w),collision_flags(a0)				; get collision type
		tst.b	routine(a0)							; changed by Animate_Sprite
		bne.s	.routine
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

.types
		dc.b $1B|collision_flags.npc.hurt, $1C|collision_flags.npc.hurt, $1D|collision_flags.npc.hurt	; horizontal
		dc.b $1E|collision_flags.npc.hurt, $1F|collision_flags.npc.hurt, $20|collision_flags.npc.hurt	; vertical
	even
; ---------------------------------------------------------------------------

.routine
		clr.b	routine(a0)
		move.l	#.wait,address(a0)

.wait
		subq.w	#1,harp_time(a0)						; decrement timer
		bpl.s	.chkdel								; branch if time remains
		move.w	#1*60,harp_time(a0)						; reset timer
		move.l	#.move,address(a0)						; run "Harp_Move" subroutine
		bchg	#0,anim(a0)							; extending/retracting harpoon
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch
		sfx	sfx_Harpoon							; play harpoon sound

.chkdel
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

Obj_Harpoon_end

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Harpoon:		subObjData Map_Harp, $3CC, 0, 0, 40, 16, 4, 0, 0
; ---------------------------------------------------------------------------

		include "Objects/Environ/Harpoon/Object Data/Anim - Harpoon.asm"
		include "Objects/Environ/Harpoon/Object Data/Map - Harpoon.asm"
