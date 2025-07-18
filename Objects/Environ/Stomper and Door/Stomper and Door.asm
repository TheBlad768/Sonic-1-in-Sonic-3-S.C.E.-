; ---------------------------------------------------------------------------
; Object 6B - stomper and sliding door (LZ4/SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
sto_origX			= objoff_34	; original x-axis position (2 bytes)
sto_origY			= objoff_30	; original y-axis position (2 bytes)
sto_time			= objoff_36	; time (2 bytes)
sto_active			= objoff_38	; flag set when a switch is pressed (1 byte)
;				= objoff_3A	; (2 bytes)
;				= objoff_3C	; (2 bytes)
;				= objoff_3E	; (1 byte)

; =============== S U B R O U T I N E =======================================

Sto_Var:

		; height, width, ????, type number
		dc.b 24/2, 128/2, $80, 1
		dc.b 64/2, 56/2, $38, 3
		dc.b 64/2, 56/2, $40, 4
		dc.b 64/2, 56/2, $60, 4
		dc.b 128/2, 256/2, 0, 5
; ---------------------------------------------------------------------------

Obj_ScrapStomp:

		; set
		move.b	subtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0
		lea	Sto_Var(pc,d0.w),a3
		move.w	(a3)+,height_pixels(a0)
		lsr.w	#2,d0								; division by 4
		move.b	d0,mapping_frame(a0)
		move.l	#.action,address(a0)
		move.l	#Map_Stomp,mappings(a0)
		move.w	#make_art_tile($2B2,1,0),art_tile(a0)

		; check level
		cmpi.b	#LevelID_LZ,(Current_zone).w					; check if level is LZ/SBZ3
		bne.s	.isSBZ12							; if not, branch
		bset	#0,(Scrap_stomp_flag).w						; is flag already set?
		beq.s	.isSBZ3								; if not, branch

		; delete
		jmp	(Sprite_CheckDeleteTouch3.offscreen).w
; ---------------------------------------------------------------------------

.isSBZ3
		move.w	#make_art_tile($41F0,2,0),art_tile(a0)				; LZ4
		cmpi.w	#$A80,x_pos(a0)
		bne.s	.isSBZ12

		; check delete
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.isSBZ12							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		btst	#0,(a2)
		beq.s	.isSBZ12
		clr.b	(Scrap_stomp_flag).w

		; delete
		bclr	#7,(a2)
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.isSBZ12
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.w	#priority_4,priority(a0)
		move.w	x_pos(a0),sto_origX(a0)
		move.w	y_pos(a0),sto_origY(a0)

		; set
		moveq	#0,d0
		move.b	(a3)+,d0
		move.w	d0,objoff_3C(a0)
		move.b	subtype(a0),d0
		bpl.s	.action
		andi.b	#$F,d0
		move.b	d0,objoff_3E(a0)
		move.b	(a3),subtype(a0)

.action
		move.w	x_pos(a0),-(sp)
		moveq	#$F,d0
		and.b	subtype(a0),d0
		beq.s	.skipt								; if zero, branch
		add.w	d0,d0
		move.w	ScrapStomp_TypeIndex-2(pc,d0.w),d0
		jsr	ScrapStomp_TypeIndex(pc,d0.w)

.skipt
		move.w	(sp)+,d4
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel2							; if not, branch

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		jsr	(SolidObjectFull).w

.chkdel2
		out_of_xrange.s	.chkgone2,sto_origX(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.chkgone2

		; check level
		cmpi.b	#LevelID_LZ,(Current_zone).w					; check if level is LZ
		bne.s	.offscreen2							; if not, branch
		clr.b	(Scrap_stomp_flag).w
		clr.b	(Screen_shaking_flag).w

.offscreen2
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete2							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#7,(a2)

.delete2
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

ScrapStomp_TypeIndex: offsetTable
		offsetTableEntry.w .type01						; 1
		offsetTableEntry.w .type02						; 2
		offsetTableEntry.w .type03						; 3
		offsetTableEntry.w .type04						; 4
		offsetTableEntry.w .type05						; 5
; ---------------------------------------------------------------------------

.type01
		tst.b	sto_active(a0)
		bne.s	.isactive01
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	objoff_3E(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.loc_15DC2
		st	sto_active(a0)

.isactive01
		move.w	objoff_3C(a0),d0
		cmp.w	objoff_3A(a0),d0
		beq.s	.loc_15DE0
		addq.w	#2,objoff_3A(a0)

.loc_15DC2
		move.w	objoff_3A(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip01
		neg.w	d0
		addi.w	#$80,d0

.noflip01
		move.w	sto_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_15DE0
		addq.b	#1,subtype(a0)
		move.w	#3*60,objoff_36(a0)
		clr.b	sto_active(a0)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.loc_15DC2							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bset	#0,(a2)
		bra.s	.loc_15DC2
; ---------------------------------------------------------------------------

.type02
		tst.b	sto_active(a0)
		bne.s	.isactive02
		subq.w	#1,objoff_36(a0)
		bne.s	.loc_15E1E
		st	sto_active(a0)

.isactive02
		tst.w	objoff_3A(a0)
		beq.s	.loc_15E3C
		subq.w	#2,objoff_3A(a0)

.loc_15E1E
		move.w	objoff_3A(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip02
		neg.w	d0
		addi.w	#$80,d0

.noflip02
		move.w	sto_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_15E3C
		subq.b	#1,subtype(a0)
		clr.b	sto_active(a0)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.loc_15E1E							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#0,(a2)
		bra.s	.loc_15E1E
; ---------------------------------------------------------------------------

.type03
		tst.b	sto_active(a0)
		bne.s	.isactive03
		tst.w	objoff_3A(a0)
		beq.s	.loc_15E6A
		subq.w	#1,objoff_3A(a0)
		bra.s	.loc_15E8E
; ---------------------------------------------------------------------------

.loc_15E6A
		subq.w	#1,objoff_36(a0)
		bpl.s	.loc_15E8E
		move.w	#1*60,objoff_36(a0)
		st	sto_active(a0)

.isactive03
		addq.w	#8,objoff_3A(a0)
		move.w	objoff_3A(a0),d0
		cmp.w	objoff_3C(a0),d0
		bne.s	.loc_15E8E
		clr.b	sto_active(a0)

.loc_15E8E
		move.w	objoff_3A(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip03
		neg.w	d0
		addi.w	#$38,d0

.noflip03
		move.w	sto_origY(a0),d1
		add.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type04
		tst.b	sto_active(a0)
		bne.s	.isactive04
		tst.w	objoff_3A(a0)
		beq.s	.loc_15EBE
		subq.w	#8,objoff_3A(a0)
		bra.s	.loc_15EF0
; ---------------------------------------------------------------------------

.loc_15EBE
		subq.w	#1,objoff_36(a0)
		bpl.s	.loc_15EF0
		move.w	#1*60,objoff_36(a0)
		st	sto_active(a0)

.isactive04
		move.w	objoff_3A(a0),d0
		cmp.w	objoff_3C(a0),d0
		beq.s	.loc_15EE0
		addq.w	#8,objoff_3A(a0)
		bra.s	.loc_15EF0
; ---------------------------------------------------------------------------

.loc_15EE0
		subq.w	#1,objoff_36(a0)
		bpl.s	.loc_15EF0
		move.w	#1*60,objoff_36(a0)
		clr.b	sto_active(a0)

.loc_15EF0
		move.w	objoff_3A(a0),d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip04
		neg.w	d0
		addi.w	#$38,d0

.noflip04
		move.w	sto_origY(a0),d1
		add.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.type05
		tst.b	sto_active(a0)
		bne.s	.loc_15F3E
		lea	(Level_trigger_array).w,a2
		moveq	#0,d0
		move.b	objoff_3E(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.locret_15F5C
		st	sto_active(a0)
		st	(Screen_shaking_flag).w
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.loc_15F3E							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bset	#0,(a2)

.loc_15F3E
		subq.w	#1,x_pos(a0)
		addi.l	#$8000,y_pos(a0)
		move.w	x_pos(a0),sto_origX(a0)
		cmpi.w	#$980,x_pos(a0)							; LZ4
		beq.s	.loc_15F5E

		; play sfx
		move.w	(Level_frame_counter).w,d0
		subq.w	#1,d0
		andi.w	#$F,d0
		bne.s	.locret_15F5C
		sfx	sfx_Rumble2,1
; ---------------------------------------------------------------------------

.locret_15F5C
		rts
; ---------------------------------------------------------------------------

.loc_15F5E
		clr.b	subtype(a0)
		clr.b	sto_active(a0)
		move.w	#$14,(Screen_shaking_flag).w
		sfx	sfx_Crash,1
; ---------------------------------------------------------------------------

		include "Objects/Environ/Stomper and Door/Object Data/Map - Stomper and Door.asm"
