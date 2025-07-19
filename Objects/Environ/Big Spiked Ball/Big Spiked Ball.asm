; ---------------------------------------------------------------------------
; Object 58 - giant spiked balls (SYZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
bball_origX			= objoff_32	; original x-axis position (2 bytes)
bball_origY			= objoff_30	; original y-axis position (2 bytes)
bball_radius			= objoff_3A	; radius of circle (2 bytes)
bball_speed			= objoff_40	; speed (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_BigSpikeBall:

		; init
		movem.l	ObjDat_BigSpikeBall(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.b	#6|collision_flags.npc.hurt,collision_flags(a0)
		move.w	x_pos(a0),bball_origX(a0)
		move.w	y_pos(a0),bball_origY(a0)

		; subtype
		moveq	#signextendB($F0),d1						; read only the 1st digit
		and.b	subtype(a0),d1							; get object type
		ext.w	d1
		asl.w	#3,d1								; multiply by 8
		move.w	d1,bball_speed(a0)						; set object speed
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,angle(a0)
		move.b	#$50,bball_radius(a0)						; set radius of circle motion

.move

		; types
		moveq	#7,d0								; read only the 2nd digit
		and.b	subtype(a0),d0							; get object type
		beq.s	.draw								; if zero, branch
		add.w	d0,d0
		jsr	.index-2(pc,d0.w)

.draw

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	bball_origX(a0),d0						; get object position
		jmp	(Sprite_CheckDeleteTouch3.skipxpos).w

; =============== S U B R O U T I N E =======================================

.index
		bra.s	.type01								; 1
		bra.s	.type02								; 2
; ---------------------------------------------------------------------------

		; type03								; 3
		move.w	bball_speed(a0),d0
		add.w	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	bball_radius(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	bball_origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)							; move object circularly
		move.w	bball_origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type01
		moveq	#0,d0
		move.b	(Oscillating_Data+$C).w,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip1
		neg.w	d0
		addi.w	#$60,d0

.noflip1
		move.w	bball_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)							; move object horizontally

.type00
		rts
; ---------------------------------------------------------------------------

.type02
		moveq	#0,d0
		move.b	(Oscillating_Data+$C).w,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip2
		neg.w	d0
		addi.w	#$80,d0

.noflip2
		move.w	bball_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)							; move object vertically
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BigSpikeBall:		subObjMainData Obj_BigSpikeBall.move, setBit(render_flags.level), 0, 48, 48, 4, $396, 0, 0, Map_BBall
; ---------------------------------------------------------------------------

		include "Objects/Environ/Big Spiked Ball/Object Data/Map - Big Spiked Ball.asm"
