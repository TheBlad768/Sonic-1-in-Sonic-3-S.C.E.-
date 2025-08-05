; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
SStom_xpos				= objoff_30	; .w ; copy xpos
SStom_32				= objoff_32	; .w
SStom_34				= objoff_34	; .w
SStom_fall_flag				= objoff_36	; .b
SStom_timedelay				= objoff_38	; .w
SStom_xpos2				= objoff_3A	; .w ; copy xpos
SStom_x_vel				= objoff_3C	; .w
SStom_childy1				= objoff_3E	; .w
SStom_childy2				= objoff_40	; .w

; =============== S U B R O U T I N E =======================================

SStom_Len:
		dc.b $38	; short ($00)
		dc.b $A0	; long ($01)
		dc.b $50	; medium ($02)
	even
; ---------------------------------------------------------------------------

Obj_SideStomp:

		; set length
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.b	SStom_Len(pc,d0.w),objoff_34(a0)

		; init
		movem.l	ObjDat_SideStomp(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.b	#1,mapping_frame(a0)

		; set sub objects
		move.w	#2,mainspr_childsprites(a0)					; wall bracket, pole

		; set xpos
		move.w	x_pos(a0),d0
		move.w	d0,SStom_xpos(a0)
		move.w	d0,SStom_xpos2(a0)

		; sub object 1
		lea	sub2_x_pos(a0),a1						; $16-$29 bytes reserved
		move.w	d0,d1
		addi.w	#40,d1
		move.w	d1,(a1)+							; xpos
		move.w	y_pos(a0),(a1)+							; ypos
		move.w	#3,(a1)+							; frame (wall bracket)

		; sub object 2
		move.w	d0,d1
		addi.w	#52,d1
		move.w	d1,(a1)+							; xpos
		move.w	d1,objoff_3E(a0)
		move.w	y_pos(a0),(a1)+							; ypos
		move.b	#4,1(a1)							; frame (pole) ; skip $22 byte (mapping_frame)

		; object 3 (spikes)
		move.w	d0,d1
		subi.w	#28,d1
		move.w	d1,objoff_40(a0)

		; create spikes
		lea	Child6_SideStomp_Spikes(pc),a2
		jsr	(CreateChild6_Simple).w

.action

		; solid
		move.w	x_pos(a0),-(sp)
		moveq	#$F,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		move.w	SStom_TypeIndex(pc,d0.w),d0
		jsr	SStom_TypeIndex(pc,d0.w)
		move.w	(sp)+,d4

		; solid
		moveq	#(24/2)+$B,d1							; width
		moveq	#64/2,d2							; height
		moveq	#(64/2)+1,d3							; height+1
		jsr	(SolidObjectFull).w

		; sub objects 2 (pole)
		moveq	#$10,d0
		add.b	objoff_32(a0),d0
		lsr.b	#5,d0
		addq.b	#4,d0
		move.b	d0,sub3_mapframe(a0)
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		neg.w	d0
		add.w	objoff_3E(a0),d0
		move.w	d0,sub3_x_pos(a0)

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	SStom_xpos2(a0),d0						; get object position
		jmp	(Sprite_CheckDelete.skipxpos).w

; =============== S U B R O U T I N E =======================================

SStom_TypeIndex: offsetTable
		offsetTableEntry.w SStom_Type00						; 0
		offsetTableEntry.w SStom_Type00						; 1
		offsetTableEntry.w SStom_Type00						; 2
; ---------------------------------------------------------------------------

SStom_Type00:
		tst.b	objoff_36(a0)
		beq.s	loc_BB08
		tst.w	objoff_38(a0)
		beq.s	loc_BAEC
		subq.w	#1,objoff_38(a0)
		bra.s	loc_BB3C
; ---------------------------------------------------------------------------

loc_BAEC:
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.skipsfx							; if not, branch

		; play continuous sfx
		sfxcont	sfx_ChainRise,$F						; play rising chain sound every 16th frame

.skipsfx
		subi.w	#$80,objoff_32(a0)
		bhs.s	loc_BB3C
		moveq	#0,d0
		move.w	d0,objoff_32(a0)
		move.w	d0,SStom_x_vel(a0)
		move.b	d0,objoff_36(a0)
		bra.s	loc_BB3E
; ---------------------------------------------------------------------------

loc_BB08:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	loc_BB3C
		move.w	SStom_x_vel(a0),d0
		addi.w	#$70,SStom_x_vel(a0)
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	loc_BB3C
		move.w	d1,objoff_32(a0)
		clr.w	SStom_x_vel(a0)
		st	objoff_36(a0)
		move.w	#1*60,objoff_38(a0)
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_BB3C							; if not, branch
		sfx	sfx_ChainStomp							; play stomping sound

loc_BB3C:
		moveq	#0,d0

loc_BB3E:
		move.b	objoff_32(a0),d0
		neg.w	d0
		add.w	objoff_30(a0),d0
		move.w	d0,x_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SideStomp_Spikes:

		; init
		lea	ObjDat_SideStomp_Spikes(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.solid,address(a0)

.solid
		move.w	x_pos(a0),-(sp)
		bsr.s	.move
		moveq	#32/2,d1							; width
		moveq	#48/2,d2							; height
		moveq	#(48/2)+1,d3							; height+1
		move.w	(sp)+,d4
		jsr	(SolidObjectFull).w

		; check players
		swap	d6
		andi.w	#touch_side_mask,d6						; Sonic(1) or Tails(2) push object?
		beq.s	.draw								; if not, branch
		move.b	d6,d0
		andi.b	#p1_touch_side,d0						; Sonic/Knux push object?
		beq.s	.notp1								; if not, branch
		lea	(Player_1).w,a1							; a1=character
		jsr	(Touch_ChkHurt3).l						; hurt character
		bclr	#p1_pushing_bit,status(a0)

.notp1
		andi.b	#p2_touch_side,d6						; Tails push object?
		beq.s	.draw								; if not, branch
		lea	(Player_2).w,a1							; a1=character
		jsr	(Touch_ChkHurt3).l						; hurt character
		bclr	#p2_pushing_bit,status(a0)

.draw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

.move
		moveq	#0,d0
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	objoff_32(a1),d0
		neg.w	d0
		add.w	objoff_40(a1),d0
		move.w	d0,x_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_SideStomp:		subObjMainData Obj_SideStomp.action, setBit(render_flags.level)|setBit(render_flags.multi_sprite), 0, 64, 256, 3, $328, 0, 0, Map_SStom
ObjDat_SideStomp_Spikes:	subObjData FALSE, FALSE, 0, 0, 40, 32, 4, 2, 0

Child6_SideStomp_Spikes:
		dc.w 1-1
		dc.l Obj_SideStomp_Spikes
; ---------------------------------------------------------------------------

		include "Objects/Environ/Chained Stompers/Object Data/Map - Sideways Stomp.asm"
