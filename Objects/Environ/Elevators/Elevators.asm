; ---------------------------------------------------------------------------
; Object 59 - platforms that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
elev_origX			= objoff_32	; original x-axis position
elev_origY			= objoff_30	; original y-axis position
elev_dist			= objoff_3C	; distance to move (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_Elevator:

		; check
		move.b	subtype(a0),d0
		bpl.s	.normal								; branch for types 00-7F

		; set alt
		andi.w	#$7F,d0
		add.w	d0,d0								; multiply by 6
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,elev_dist(a0)
		move.w	d0,objoff_3E(a0)
		move.l	#Elev_MakeMulti,address(a0)					; goto Elev_MakeMulti next
		rts
; ---------------------------------------------------------------------------

.Elev_Var1
		dc.b 80/2, 0		; width, frame number
.Elev_Var2
		dc.b $10, 1	; 0	; distance to move, action type
		dc.b $20, 1	; 1
		dc.b $34, 1	; 2
		dc.b $10, 3	; 3
		dc.b $20, 3	; 4
		dc.b $34, 3	; 5
		dc.b $14, 1	; 6
		dc.b $24, 1	; 7
		dc.b $2C, 1	; 8
		dc.b $14, 3	; 9
		dc.b $24, 3	; A
		dc.b $2C, 3	; B
		dc.b $20, 5	; C
		dc.b $20, 7	; D
		dc.b $30, 9	; E
; ---------------------------------------------------------------------------

.normal

		; set
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	.Elev_Var1(pc,d0.w),a2
		move.b	(a2),height_pixels(a0)						; set height
		move.b	(a2)+,width_pixels(a0)						; set width
		move.b	(a2)+,mapping_frame(a0)						; set frame
		move.b	subtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	.Elev_Var2(pc,d0.w),a2
		move.b	(a2)+,d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	d0,elev_dist(a0)						; set distance to move
		move.b	(a2)+,subtype(a0)						; set type

		; init
		move.l	#Map_Elev,mappings(a0)
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_4, \
			make_art_tile(0,2,0) \
		),priority(a0)

		move.w	x_pos(a0),elev_origX(a0)
		move.w	y_pos(a0),elev_origY(a0)
		move.l	#.main,address(a0)						; goto Elev_Platform next

.main
		move.w	x_pos(a0),-(sp)
		moveq	#$F,d0
		and.b	subtype(a0),d0
		beq.s	.skipt								; if zero, branch
		add.w	d0,d0
		jsr	.index-2(pc,d0.w)

.skipt
		move.w	(sp)+,d4
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height_pixels
		jsr	(SolidObjectTop).w

.chkdel
		moveq	#-$80,d0							; round down to nearest $80
		and.w	elev_origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

.index
		bra.s	.type01								; 1
		bra.s	.type02								; 2
		bra.s	.type01								; 3
		bra.s	.type04								; 4
		bra.s	.type01								; 5
		bra.s	.type06								; 6
		bra.s	.type01								; 7
		bra.s	.type08								; 8
; ---------------------------------------------------------------------------

		; type09								; 9
		bsr.w	Elev_Move
		move.w	objoff_34(a0),d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,y_pos(a0)
		tst.b	subtype(a0)
		beq.s	.typereset
		rts
; ---------------------------------------------------------------------------

.type01
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; check if Sonic or Tails is standing on the object
		beq.s	.return
		addq.b	#1,subtype(a0)							; if yes, add 1 to type

.return
		rts
; ---------------------------------------------------------------------------

.type02
		bsr.s	Elev_Move
		move.w	objoff_34(a0),d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type04
		bsr.s	Elev_Move
		move.w	objoff_34(a0),d0
		add.w	elev_origY(a0),d0
		move.w	d0,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type06
		bsr.s	Elev_Move
		move.w	objoff_34(a0),d0
		asr.w	d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,y_pos(a0)
		move.w	objoff_34(a0),d0
		add.w	elev_origX(a0),d0
		move.w	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type08
		bsr.s	Elev_Move
		move.w	objoff_34(a0),d0
		asr.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,y_pos(a0)
		move.w	objoff_34(a0),d0
		neg.w	d0
		add.w	elev_origX(a0),d0
		move.w	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.typereset

		; clear player standing
		jsr	(Displace_PlayerOffObject).w					; release player from object

		; delete object
		move.w	#$7F00,d0
		move.w	d0,x_pos(a0)
		move.w	d0,elev_origX(a0)
		rts

; =============== S U B R O U T I N E =======================================

Elev_Move:
		move.w	objoff_38(a0),d0
		tst.b	objoff_3A(a0)
		bne.s	loc_10CC8
		cmpi.w	#$800,d0
		bhs.s	loc_10CD0
		addi.w	#16,d0
		bra.s	loc_10CD0
; ---------------------------------------------------------------------------

loc_10CC8:
		tst.w	d0
		beq.s	loc_10CD0
		subi.w	#16,d0

loc_10CD0:
		move.w	d0,objoff_38(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	objoff_34(a0),d0
		move.l	d0,objoff_34(a0)
		swap	d0
		move.w	elev_dist(a0),d2
		cmp.w	d2,d0
		bls.s	loc_10CF0
		move.b	#1,objoff_3A(a0)

loc_10CF0:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_10CFA
		clr.b	subtype(a0)

locret_10CFA:
		rts

; =============== S U B R O U T I N E =======================================

Elev_MakeMulti:

		; wait
		subq.w	#1,elev_dist(a0)
		bne.s	.chkdel
		move.w	objoff_3E(a0),elev_dist(a0)

		; create
		jsr	(Create_New_Sprite3).w
		bne.s	.chkdel
		move.l	#Obj_Elevator,address(a1)					; duplicate the object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#$E,subtype(a1)							; set $E subtype

.chkdel
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

		include "Objects/Environ/Elevators/Object Data/Map - Elevators.asm"
