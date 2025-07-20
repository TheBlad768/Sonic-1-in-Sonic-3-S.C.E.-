; ---------------------------------------------------------------------------
; Object 56 - floating blocks (SYZ/SLZ), large doors (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
fb_origX			= objoff_34	; original x-axis position
fb_origY			= objoff_30	; original y-axis position
fb_height			= objoff_3A	; total object height
fb_type				= objoff_3C	; subtype (2nd digit only)

; =============== S U B R O U T I N E =======================================

FBlock_Var:				; height/2, width/2
		dc.b 32/2, 32/2		; subtype 0x/8x
		dc.b 64/2, 64/2		; subtype 1x/9x
		dc.b 64/2, 32/2		; subtype 2x/Ax
		dc.b 52/2, 64/2		; subtype 3x/Bx
		dc.b 78/2, 32/2		; subtype 4x/Cx
		dc.b 32/2, 32/2		; subtype 5x/Dx
		dc.b 64/2, 16/2		; subtype 6x/Ex
		dc.b 32/2, 128/2	; subtype 7x/Fx
; ---------------------------------------------------------------------------

Obj_FloatingBlock:

		; init
		movem.l	ObjDat_FloatingBlock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; check
		cmpi.b	#LevelID_LZ,(Current_zone).w					; check if level is LZ
		bne.s	.notLZ								; if not, branch
		move.w	#make_art_tile($3C4,2,0),art_tile(a0)				; LZ specific code

.notLZ

		; set
		move.b	subtype(a0),d0							; get subtype
		lsr.w	#3,d0
		andi.w	#$E,d0								; read only the 1st digit
		lea	FBlock_Var(pc,d0.w),a2						; get size data
		move.w	(a2),height_pixels(a0)						; set height and width
		lsr.b	d0								; division by 2
		move.b	d0,mapping_frame(a0)
		move.w	x_pos(a0),fb_origX(a0)
		move.w	y_pos(a0),fb_origY(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,fb_height(a0)
		cmpi.b	#$37,subtype(a0)
		bne.s	.dontdelete
		cmpi.w	#$1BB8+$200,x_pos(a0)
		bne.s	.notatpos
		tst.b	(Float_block_flag).w
		beq.s	.dontdelete
		bra.w	.delete
; ---------------------------------------------------------------------------

.notatpos
		clr.b	subtype(a0)
		tst.b	(Float_block_flag).w
		bne.s	.dontdelete
		bra.w	.delete
; ---------------------------------------------------------------------------

.dontdelete
		cmpi.b	#LevelID_LZ,(Current_zone).w					; check if level is LZ
		beq.s	.stillnotLZ							; if so, branch
		moveq	#$F,d0
		and.b	subtype(a0),d0							; SYZ/SLZ specific code
		subq.w	#8,d0
		blo.s	.stillnotLZ
		add.w	d0,d0
		add.w	d0,d0
		lea	(Oscillating_Data+$2A).w,a2
		tst.w	(a2,d0.w)
		bpl.s	.stillnotLZ
		bchg	#status.npc.x_flip,status(a0)

.stillnotLZ
		move.b	subtype(a0),d0
		bpl.s	.action
		andi.b	#$F,d0
		move.b	d0,fb_type(a0)
		move.b	#5,subtype(a0)
		cmpi.b	#7,mapping_frame(a0)
		bne.s	.chkstate
		move.b	#$C,subtype(a0)
		move.w	#$80,fb_height(a0)

.chkstate
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.action								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		btst	#0,(a2)
		beq.s	.action
		addq.b	#1,subtype(a0)
		clr.w	fb_height(a0)

.action
		move.w	x_pos(a0),-(sp)
		moveq	#$F,d0								; read only the 2nd digit
		and.b	subtype(a0),d0							; get object subtype
		beq.s	.skipt								; if zero, branch
		add.w	d0,d0
		move.w	BlocksDoors_TypeIndex-2(pc,d0.w),d0
		jsr	BlocksDoors_TypeIndex(pc,d0.w)					; move block subroutines

.skipt
		move.w	(sp)+,d4
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		jsr	(SolidObjectFull).w

.chkdel
		out_of_xrange.s	.chkdel2,fb_origX(a0)

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.chkdel2
		cmpi.b	#$37,subtype(a0)
		bne.s	.delete
		tst.b	objoff_38(a0)
		bne.s	.draw

.delete
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete2							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#7,(a2)

.delete2
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

BlocksDoors_TypeIndex: offsetTable
		offsetTableEntry.w .type01						; 1
		offsetTableEntry.w .type02						; 2
		offsetTableEntry.w .type03						; 3
		offsetTableEntry.w .type04						; 4
		offsetTableEntry.w .type05						; 5
		offsetTableEntry.w .type06						; 6
		offsetTableEntry.w .type07						; 7
		offsetTableEntry.w .type08						; 8
		offsetTableEntry.w .type09						; 9
		offsetTableEntry.w .type0A						; A
		offsetTableEntry.w .type0B						; B
		offsetTableEntry.w .type0C						; C
		offsetTableEntry.w .type0D						; D
; ---------------------------------------------------------------------------

.type01

		; moves side-to-side
		moveq	#$40,d1								; set move distance
		moveq	#0,d0
		move.b	(Oscillating_Data+8).w,d0
		bra.s	.moveLR
; ---------------------------------------------------------------------------

.type02

		; moves side-to-side
		move.w	#$80,d1								; set move distance
		moveq	#0,d0
		move.b	(Oscillating_Data+$1C).w,d0

.moveLR
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip
		neg.w	d0
		add.w	d1,d0

.noflip
		move.w	fb_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)							; move object horizontally
		rts
; ---------------------------------------------------------------------------

.type03

		; moves up/down
		moveq	#$40,d1								; set move distance
		moveq	#0,d0
		move.b	(Oscillating_Data+8).w,d0
		bra.s	.moveUD
; ---------------------------------------------------------------------------

.type04

		; moves up/down
		move.w	#$80,d1								; set move distance
		moveq	#0,d0
		move.b	(Oscillating_Data+$1C).w,d0

.moveUD
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip04
		neg.w	d0
		add.w	d1,d0

.noflip04
		move.w	fb_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)							; move object vertically
		rts
; ---------------------------------------------------------------------------

.type05

		; moves up when a switch is pressed
		tst.b	objoff_38(a0)
		bne.s	.loc_104A4
		cmpi.w	#bytes_to_word(LevelID_LZ,0),(Current_zone_and_act).w		; is level LZ1?
		bne.s	.aaa								; if not, branch
		cmpi.b	#3,fb_type(a0)
		bne.s	.aaa
		clr.b	(WindTunnel_holding_flag).w
		move.w	(Player_1+x_pos).w,d0
		cmp.w	x_pos(a0),d0
		bhs.s	.aaa

		; disable wind tunnel
		move.b	#( \
			setBit(WindTunnel_holding_flag.player_1) | \
			setBit(WindTunnel_holding_flag.player_2) \
		),(WindTunnel_holding_flag).w

.aaa
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.loc_104AE
		cmpi.w	#bytes_to_word(LevelID_LZ,0),(Current_zone_and_act).w		; is level LZ1?
		bne.s	.loc_1049E							; if not, branch
		cmpi.b	#3,d0
		bne.s	.loc_1049E
		clr.b	(WindTunnel_holding_flag).w

.loc_1049E
		move.b	#1,objoff_38(a0)

.loc_104A4
		tst.w	fb_height(a0)
		beq.s	.loc_104C8
		subq.w	#2,fb_height(a0)

.loc_104AE
		move.w	fb_height(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_104BC
		neg.w	d0

.loc_104BC
		move.w	fb_origY(a0),d1
		add.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_104C8
		addq.b	#1,subtype(a0)
		clr.b	objoff_38(a0)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.loc_104AE							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bset	#0,(a2)
		bra.s	.loc_104AE
; ---------------------------------------------------------------------------

.type06
		tst.b	objoff_38(a0)
		bne.s	.loc_10500
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	.loc_10512
		move.b	#1,objoff_38(a0)

.loc_10500
		moveq	#0,d0
		move.b	height_pixels(a0),d0
		add.w	d0,d0
		cmp.w	fb_height(a0),d0
		beq.s	.loc_1052C
		addq.w	#2,fb_height(a0)

.loc_10512
		move.w	fb_height(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_10520
		neg.w	d0

.loc_10520
		move.w	fb_origY(a0),d1
		add.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_1052C
		subq.b	#1,subtype(a0)
		clr.b	objoff_38(a0)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.loc_10512							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#0,(a2)
		bra.s	.loc_10512
; ---------------------------------------------------------------------------

.type07
		tst.b	objoff_38(a0)
		bne.s	.loc_1055E
		tst.b	(Level_trigger_array+$F).w					; has switch number $F been pressed?
		beq.s	.locret_10578
		move.b	#1,objoff_38(a0)
		clr.w	fb_height(a0)

.loc_1055E
		addq.w	#1,x_pos(a0)
		move.w	x_pos(a0),fb_origX(a0)
		addq.w	#1,fb_height(a0)
		cmpi.w	#$380,fb_height(a0)
		bne.s	.locret_10578
		st	(Float_block_flag).w
		clr.b	objoff_38(a0)
		clr.b	subtype(a0)

.locret_10578
		rts
; ---------------------------------------------------------------------------

.type0C
		tst.b	objoff_38(a0)
		bne.s	.loc_10598
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.loc_105A2
		move.b	#1,objoff_38(a0)

.loc_10598
		tst.w	fb_height(a0)
		beq.s	.loc_105C0
		subq.w	#2,fb_height(a0)

.loc_105A2
		move.w	fb_height(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_105B4
		neg.w	d0
		addi.w	#$80,d0

.loc_105B4
		move.w	fb_origX(a0),d1
		add.w	d0,d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_105C0
		addq.b	#1,subtype(a0)
		clr.b	objoff_38(a0)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.loc_105A2							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bset	#0,(a2)
		bra.s	.loc_105A2
; ---------------------------------------------------------------------------

.type0D
		tst.b	objoff_38(a0)
		bne.s	.loc_105F8
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	.wtf
		move.b	#1,objoff_38(a0)

.loc_105F8
		move.w	#$80,d0
		cmp.w	fb_height(a0),d0
		beq.s	.loc_10624
		addq.w	#2,fb_height(a0)

.wtf
		move.w	fb_height(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.loc_10618
		neg.w	d0
		addi.w	#$80,d0

.loc_10618
		move.w	fb_origX(a0),d1
		add.w	d0,d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_10624
		subq.b	#1,subtype(a0)
		clr.b	objoff_38(a0)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.wtf								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#0,(a2)
		bra.s	.wtf
; ---------------------------------------------------------------------------

.type08
		moveq	#$10,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$28).w,d0
		lsr.w	d0
		move.w	(Oscillating_Data+$2A).w,d3
		bra.s	.square
; ---------------------------------------------------------------------------

.type09
		moveq	#$30,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$2C).w,d0
		move.w	(Oscillating_Data+$2E).w,d3
		bra.s	.square
; ---------------------------------------------------------------------------

.type0A
		moveq	#$50,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$30).w,d0
		move.w	(Oscillating_Data+$32).w,d3
		bra.s	.square
; ---------------------------------------------------------------------------

.type0B
		moveq	#$70,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$34).w,d0
		move.w	(Oscillating_Data+$36).w,d3

.square
		tst.w	d3
		bne.s	.loc_1068E
		addq.b	#status.npc.y_flip,status(a0)

		andi.b	#( \
			setBit(status.npc.x_flip) | \
			setBit(status.npc.y_flip) \
		),status(a0)

.loc_1068E

		moveq	#signextendB( \
			setBit(status.npc.x_flip) | \
			setBit(status.npc.y_flip) \
		),d2

		and.b	status(a0),d2
		bne.s	.loc_106AE
		sub.w	d1,d0
		add.w	fb_origX(a0),d0
		move.w	d0,x_pos(a0)
		neg.w	d1
		add.w	fb_origY(a0),d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_106AE
		subq.b	#1,d2
		bne.s	.loc_106CC
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	fb_origY(a0),d0
		move.w	d0,y_pos(a0)
		addq.w	#1,d1
		add.w	fb_origX(a0),d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_106CC
		subq.b	#1,d2
		bne.s	.loc_106EA
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	fb_origX(a0),d0
		move.w	d0,x_pos(a0)
		addq.w	#1,d1
		add.w	fb_origY(a0),d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_106EA
		sub.w	d1,d0
		add.w	fb_origY(a0),d0
		move.w	d0,y_pos(a0)
		neg.w	d1
		add.w	fb_origX(a0),d1
		move.w	d1,x_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_FloatingBlock:		subObjMainData Obj_FloatingBlock.action, setBit(render_flags.level), 0, 0, 0, 3, 0, 2, 0, Map_FBlock
; ---------------------------------------------------------------------------

		include "Objects/Environ/Floating Blocks and Doors/Object Data/Map - Floating Blocks and Doors.asm"
