; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
; - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

; Options
_SPLATFORM_POS_			= 1		; sonic 1 version

; Dynamic object variables
swing_origX			= objoff_42	; original x-axis position (2 bytes)
swing_origY			= objoff_44	; original y-axis position (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_SwingingPlatform:

		; init
		move.l	#Map_Swing_GHZ,d1
		move.w	#make_art_tile($3C2,0,0),d0

		; check level
		cmpi.b	#LevelID_MZ,(Current_zone).w					; is level Marble Zone?
		bne.s	.notMZ								; if not, branch
		move.w	#make_art_tile($31A,0,0),d0

.notMZ
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(16/2,48/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.w	x_pos(a0),swing_origX(a0)
		move.w	y_pos(a0),swing_origY(a0)

		; check level
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; is level Star Light Zone?
		bne.s	.notSLZ								; if not, branch
		move.l	#Map_Swing_SLZ,d1
		move.w	#make_art_tile($3A6,2,0),d0
		move.w	#bytes_to_word(32/2,64/2),height_pixels(a0)			; set height and width
		move.b	#$19|collision_flags.npc.hurt,collision_flags(a0)

.notSLZ

		; check level
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		bne.s	.notSBZ								; if not, branch
		move.l	#Map_Swing_SBZ,d1
		move.w	#make_art_tile($448,0,0),d0
		move.w	#bytes_to_word(48/2,48/2),height_pixels(a0)			; set height and width
		move.b	#6|collision_flags.npc.hurt,collision_flags(a0)

.notSBZ
		move.w	d0,art_tile(a0)
		move.l	d1,mappings(a0)

		; create chain
		jsr	(Create_New_Sprite3).w
		bne.w	.offscreen
		move.l	#Draw_Sprite,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	#priority_5,priority(a1)
		bset	#render_flags.multi_sprite,render_flags(a1)			; set multi-draw flag
		move.w	a1,parent3(a0)							; save chain address
		move.w	x_pos(a0),d2
		move.w	d2,x_pos(a1)
		move.w	y_pos(a0),d3
		move.w	d3,y_pos(a1)
		moveq	#$F,d1
		and.b	subtype(a0),d1
		move.b	d1,d0
		addq.b	#1,d0
		lsl.b	#4,d0								; multiply by $10
		move.b	d0,width_pixels(a1)						; set width
		move.b	d0,height_pixels(a1)						; set height
		move.w	d1,mainspr_childsprites(a1)
		subq.w	#1,d1
		blo.s	.offscreen
		lea	sub2_x_pos(a1),a2

.loop
		move.w	d2,(a2)+							; xpos
		move.w	d3,(a2)+							; ypos
		move.w	#1,(a2)+							; mapping frame
		dbf	d1,.loop
		move.b	#2,mapping_frame(a1)

		; check level
		move.l	#.mainghz,address(a0)						; set GHZ
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; is level Star Light Zone?
		bne.s	.notSLZ2							; if not, branch
		move.l	#.mainslz,address(a0)						; set SLZ
		bra.s	.mainslz
; ---------------------------------------------------------------------------

.notSLZ2
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		bne.s	.mainghz							; if not, branch
		move.l	#.mainsbz,address(a0)						; set SBZ
		bra.s	.mainsbz
; ---------------------------------------------------------------------------

.mainghz
		move.w	x_pos(a0),-(sp)
		bsr.s	SwingingPlatform_Move
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#1,d3
		add.b	height_pixels(a0),d3
		move.w	(sp)+,d4
		jsr	(SolidObjectTop).w

		; check delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	swing_origX(a0),d0						; get object position
		out_of_xrange2.s	.offscreen
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#7,(a2)

.delete
		movea.w	parent3(a0),a1							; load chain address into a1
		jsr	(Delete_Referenced_Sprite).w
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.mainsbz
		bsr.s	SwingingPlatform_Move

.checkdeletesbz
		moveq	#-$80,d0							; round down to nearest $80
		and.w	swing_origX(a0),d0						; get object position
		out_of_xrange2.s	.offscreen
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

.mainslz
		move.w	x_pos(a0),-(sp)
		bsr.s	SwingingPlatform_Move
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#1,d3
		add.b	height_pixels(a0),d3
		move.w	(sp)+,d4
		jsr	(SolidObjectTop).w
		bra.s	.checkdeletesbz

; =============== S U B R O U T I N E =======================================

SwingingPlatform_Move:
		move.b	(Oscillating_Data+$18).w,d0
		tst.b	subtype(a0)
		bpl.s	.normal
		move.b	(AIZ_vine_angle).w,d0

.normal
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflipx
		neg.b	d0
		addi.b	#$80,d0

.notflipx
		btst	#status.npc.y_flip,status(a0)
		beq.s	.notflipy
		neg.b	d0

.notflipy
		jsr	(GetSineCosine).w
		move.w	swing_origY(a0),d2
		move.w	swing_origX(a0),d3
		movea.w	parent3(a0),a1							; load chain address into a1
		move.w	mainspr_childsprites(a1),d6
		subq.w	#1,d6
		blo.s	.return
		swap	d0
		clr.w	d0
		swap	d1
		clr.w	d1
		asr.l	#4,d0
		asr.l	#4,d1
		move.l	d0,d4
		move.l	d1,d5
		lea	sub2_x_pos(a1),a2

.loop
		movem.l	d4-d5,-(sp)
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,(a2)+							; x_pos
		move.w	d4,(a2)+							; y_pos
		movem.l	(sp)+,d4-d5
		add.l	d0,d4
		add.l	d1,d5
		addq.w	#next_subspr-4,a2						; skip mapping frame
		dbf	d6,.loop

	if _SPLATFORM_POS_
		; sonic 1 fix pos
		asr.l	d0
		asr.l	d1
		sub.l	d0,d4
		sub.l	d1,d5
	endif

		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,x_pos(a0)
		move.w	d4,y_pos(a0)

.return
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Swinging Platform/Object Data/Map - Swinging Platforms(GHZ).asm"
		include "Objects/Environ/Swinging Platform/Object Data/Map - Swinging Platforms(SLZ).asm"
		include "Objects/Environ/Swinging Platform/Object Data/Map - Swinging Platforms(SBZ).asm"
