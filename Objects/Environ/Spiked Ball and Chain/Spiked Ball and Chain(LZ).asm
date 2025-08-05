; ---------------------------------------------------------------------------
; Object 57 - spiked balls (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
sball2_speed			= objoff_3E ; rate of spin (2 bytes)
sball2_origX			= objoff_42 ; original x-axis position (2 bytes)
sball2_origY			= objoff_44 ; original y-axis position (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_SpikeBall2:

		; init
		movem.l	ObjDat_SpikeBall2(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.b	#1,mapping_frame(a0)
		move.b	#$B|collision_flags.npc.hurt,collision_flags(a0)
		move.w	x_pos(a0),sball2_origX(a0)
		move.w	y_pos(a0),sball2_origY(a0)

		; subtype
		moveq	#signextendB($F0),d1						; read only the 1st digit
		and.b	subtype(a0),d1							; get object type
		ext.w	d1
		asl.w	#3,d1								; multiply by 8
		move.w	d1,sball2_speed(a0)						; set object twirl speed
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,angle(a0)

		; create chain
		jsr	(Create_New_Sprite3).w
		bne.s	.main
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
		move.w	d1,d0
		lsl.w	#4,d0								; multiply by $10
		move.b	d0,width_pixels(a1)						; set width
		move.b	d0,height_pixels(a1)						; set height
		subq.w	#1,d1
		blo.s	.delete
		move.w	d1,mainspr_childsprites(a1)
		lea	sub2_x_pos(a1),a2

.loop
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		clr.w	(a2)+
		dbf	d1,.loop
		move.b	#2,mapping_frame(a1)

.main
		bsr.s	SpikeBall2_Move

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	sball2_origX(a0),d0						; get object position
		out_of_xrange2.s	.offscreen
		jmp	(Draw_And_Touch_Sprite).w
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

; =============== S U B R O U T I N E =======================================

SpikeBall2_Move:
		move.w	sball2_speed(a0),d0
		add.w	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	sball2_origY(a0),d2
		move.w	sball2_origX(a0),d3
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
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,x_pos(a0)
		move.w	d4,y_pos(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_SpikeBall2:	subObjMainData Obj_SpikeBall2.main, setBit(render_flags.level), 0, 48, 48, 4, $310, 0, 0, Map_SBall2
; ---------------------------------------------------------------------------

		include "Objects/Environ/Spiked Ball and Chain/Object Data/Map - Spiked Ball and Chain (LZ).asm"
