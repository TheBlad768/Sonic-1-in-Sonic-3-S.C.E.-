; ---------------------------------------------------------------------------
; Object 59 - platforms that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

elevator.origX				ds.w 1						; original x-axis position (2 bytes)
elevator.origY				ds.w 1						; original y-axis position (2 bytes)
elevator.copyY				ds.l 1						; copy y-axis position (2 bytes)
elevator.velocity			ds.w 1						; (2 bytes)
elevator.flag				ds.b 1						; (1 byte)
					ds.b 1						; (1 byte)
elevator.dist =				*						; (2 bytes)
elevator.timer				ds.w 1						; (2 bytes)
elevator.delay				ds.w 1						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

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
		move.w	d0,elevator.timer(a0)						; set wait time
		move.w	d0,elevator.delay(a0)
		move.l	#Elevator_MakeMulti,address(a0)
		rts
; ---------------------------------------------------------------------------

.var1
		dc.b 80/2, 0		; width, frame number
.var2
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
		lea	.var1(pc,d0.w),a2
		move.b	(a2),height_pixels(a0)						; set height
		move.b	(a2)+,width_pixels(a0)						; set width
		move.b	(a2)+,mapping_frame(a0)						; set frame
		move.b	subtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	.var2(pc,d0.w),a2
		move.b	(a2)+,d0
		add.w	d0,d0								; multiply by 4
		add.w	d0,d0
		move.w	d0,elevator.dist(a0)						; set distance to move
		move.b	(a2)+,subtype(a0)						; set type

		; init
		move.l	#Map_Elev,mappings(a0)
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_4, \
			make_art_tile(0,2,FALSE) \
		),priority(a0)

		move.w	x_pos(a0),elevator.origX(a0)
		move.w	y_pos(a0),elevator.origY(a0)
		move.l	#.main,address(a0)

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
		and.w	elevator.origX(a0),d0						; get object position
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
		bsr.w	Elevator_Move
		move.w	elevator.copyY(a0),d0
		neg.w	d0
		add.w	elevator.origY(a0),d0
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
		bsr.s	Elevator_Move
		move.w	elevator.copyY(a0),d0
		neg.w	d0
		add.w	elevator.origY(a0),d0
		move.w	d0,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type04
		bsr.s	Elevator_Move
		move.w	elevator.copyY(a0),d0
		add.w	elevator.origY(a0),d0
		move.w	d0,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type06
		bsr.s	Elevator_Move
		move.w	elevator.copyY(a0),d0
		asr.w	d0
		neg.w	d0
		add.w	elevator.origY(a0),d0
		move.w	d0,y_pos(a0)
		move.w	elevator.copyY(a0),d0
		add.w	elevator.origX(a0),d0
		move.w	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type08
		bsr.s	Elevator_Move
		move.w	elevator.copyY(a0),d0
		asr.w	d0
		add.w	elevator.origY(a0),d0
		move.w	d0,y_pos(a0)
		move.w	elevator.copyY(a0),d0
		neg.w	d0
		add.w	elevator.origX(a0),d0
		move.w	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.typereset

		; clear player standing
		jsr	(Displace_PlayerOffObject).w					; release player from object

		; delete object
		move.w	#$7F00,d0
		move.w	d0,x_pos(a0)
		move.w	d0,elevator.origX(a0)
		rts

; =============== S U B R O U T I N E =======================================

Elevator_Move:
		move.w	elevator.velocity(a0),d0
		tst.b	elevator.flag(a0)
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
		move.w	d0,elevator.velocity(a0)
		ext.l	d0
		asl.l	#8,d0								; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	elevator.copyY(a0),d0						; add speed to position
		move.l	d0,elevator.copyY(a0)
		swap	d0
		move.w	elevator.dist(a0),d2
		cmp.w	d2,d0
		bls.s	loc_10CF0
		st	elevator.flag(a0)

loc_10CF0:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_10CFA
		clr.b	subtype(a0)

locret_10CFA:
		rts

; ---------------------------------------------------------------------------
; Make multiple platforms
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Elevator_MakeMulti:

		; wait
		subq.w	#1,elevator.timer(a0)
		bne.s	.chkdel
		move.w	elevator.delay(a0),elevator.timer(a0)

		; create
		jsr	(Create_New_Object_3).w
		bne.s	.chkdel
		move.l	#Obj_Elevator,address(a1)					; duplicate the object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#$E,subtype(a1)							; set $E subtype

.chkdel
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Elevators/Object Data/Map - Elevators.asm"
