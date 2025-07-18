; ---------------------------------------------------------------------------
; Object 5A - platforms moving in circles (SLZ)
; ---------------------------------------------------------------------------

; Options
_CPLATFORM_VER_				= 0		; S1 or S2/S3K version

; Dynamic object variables
circ_origX				= objoff_32	; original x-axis position
circ_origY				= objoff_30	; original y-axis position

; =============== S U B R O U T I N E =======================================

Obj_CirclingPlatform:

		; init
		movem.l	ObjDat_CirclingPlatform(pc),d0-d3				; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	x_pos(a0),circ_origX(a0)
		move.w	y_pos(a0),circ_origY(a0)

.main
		move.w	x_pos(a0),-(sp)
		moveq	#$C,d0
		and.b	subtype(a0),d0
		lsr.w	d0								; division by 2
		jsr	.index(pc,d0.w)
		move.w	(sp)+,d4

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height_pixels
		jsr	(SolidObjectTop).w

.chkdel
		moveq	#-$80,d0							; round down to nearest $80
		and.w	circ_origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

.index
		bra.s	.type00								; 0
; ---------------------------------------------------------------------------

		; type04								; 2

	if ~~_CPLATFORM_VER_
		moveq	#-$50,d1							; set radius of circle
		add.b	(Oscillating_Data+$40).w,d1					; get rotating value (S1)
		ext.w	d1
		moveq	#-$50,d2
		add.b	(Oscillating_Data+$44).w,d2
		ext.w	d2
	else
		moveq	#-$40,d1							; set radius of circle
		add.b	(Oscillating_Data+$38).w,d1					; get rotating value (S2/S3K)
		ext.w	d1
		moveq	#-$40,d2
		add.b	(Oscillating_Data+$3C).w,d2
		ext.w	d2
	endif

		btst	#0,subtype(a0)
		beq.s	.noshift04a
		neg.w	d1
		neg.w	d2

.noshift04a
		btst	#1,subtype(a0)
		beq.s	.noshift04b
		neg.w	d1
		exg	d1,d2

.noshift04b
		neg.w	d1
		add.w	circ_origX(a0),d1
		move.w	d1,x_pos(a0)
		add.w	circ_origY(a0),d2
		move.w	d2,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type00

	if ~~_CPLATFORM_VER_
		moveq	#-$50,d1							; set radius of circle
		add.b	(Oscillating_Data+$40).w,d1					; get rotating value (S1)
		ext.w	d1
		moveq	#-$50,d2
		add.b	(Oscillating_Data+$44).w,d2
		ext.w	d2
	else
		moveq	#-$40,d1							; set radius of circle
		add.b	(Oscillating_Data+$38).w,d1					; get rotating value (S2/S3K)
		ext.w	d1
		moveq	#-$40,d2
		add.b	(Oscillating_Data+$3C).w,d2
		ext.w	d2
	endif

		btst	#0,subtype(a0)
		beq.s	.noshift00a
		neg.w	d1
		neg.w	d2

.noshift00a
		btst	#1,subtype(a0)
		beq.s	.noshift00b
		neg.w	d1
		exg	d1,d2

.noshift00b
		add.w	circ_origX(a0),d1
		move.w	d1,x_pos(a0)
		add.w	circ_origY(a0),d2
		move.w	d2,y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_CirclingPlatform:	subObjMainData Obj_CirclingPlatform.main, setBit(render_flags.level), 0, 32, 48, 4, 0, 2, 0, Map_Circ
; ---------------------------------------------------------------------------

		include "Objects/Environ/Circling Platform/Object Data/Map - Circling Platform.asm"
