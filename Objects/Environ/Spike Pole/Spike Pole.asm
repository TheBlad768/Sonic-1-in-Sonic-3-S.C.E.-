; ---------------------------------------------------------------------------
; Object 17 - helix of spikes on a pole (GHZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SpikePole:

		; init
		movem.l	ObjDat_SpikePole(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; create sub objects
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d1
		sub.w	d0,d1								; move spikes back
		moveq	#16,d2								; +16 pixels

		; load 8 spike pole spikes
		move.w	#8,mainspr_childsprites(a0)
		lea	sub2_x_pos(a0),a1
		lea	y_pos(a0),a2

	rept 7
		move.w	d1,(a1)+							; set xpos
		move.w	(a2),(a1)							; set ypos
		addq.w	#next_subspr-2,a1						; skip frame
		add.w	d2,d1								; +16 pixels
	endr

		; last spike
		move.w	d1,(a1)+							; set xpos
		move.w	(a2),(a1)							; set ypos

.action
		move.b	(Spikes_frame).w,d0
		moveq	#7,d1								; max spikes frames (8-1)

		set	.a,sub2_mapframe

	rept 7
		move.b	d0,.a(a0)							; set frame
		addq.b	#1,d0								; next frame
		and.b	d1,d0								; max spikes frames
		set	.a,.a + next_subspr
	endr

		; last spike
		move.b	d0,.a(a0)							; set frame

		; collision move
		move.b	(Spikes_frame).w,d3						; spike frame
		neg.b	d3								; change direction of movement
		and.w	d1,d3								; max spikes
		asl.w	#4,d3								; +16 pixels
		add.w	sub2_x_pos(a0),d3						; set xpos for "Check_PlayerInRange"

		; check players
		lea	.range(pc),a1
		jsr	(Check_PlayerInRange.skipx).w
		tst.l	d0								; check Tails and Sonic address
		beq.s	.draw								; if neither player is in range, don't do anything
		tst.w	d0								; is Sonic?
		beq.s	.notp1								; if it's not Sonic, branch
		movea.w	d0,a1								; get Sonic address
		move.l	d0,-(sp)							; save players address
		jsr	(HurtCharacter_Directly2).w					; hurt character
		move.l	(sp)+,d0							; restore players address

.notp1
		swap	d0								; get Tails address
		tst.w	d0								; is Tails?
		beq.s	.draw								; if it's not Tails, branch
		movea.w	d0,a1								; get Tails address
		jsr	(HurtCharacter_Directly2).w					; hurt character

.draw
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.range
		dc.w -8, 16	; xpos (8x8)
		dc.w -32, 64	; ypos (32x32)

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_SpikePole:	subObjMainData Obj_SpikePole.action, setBit(render_flags.level)|setBit(render_flags.multi_sprite), 0, 16, (16*8), 3, $3B0, 2, 0, Map_SpikePole
; ---------------------------------------------------------------------------

		include "Objects/Environ/Spike Pole/Object Data/Map - Spike Pole.asm"
