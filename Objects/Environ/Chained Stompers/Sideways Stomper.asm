; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

sidestomp			= *

.origX				ds.w 1							; original x-axis position (2 bytes)
.xoffset			ds.w 1							; (2 bytes)
.length				ds.w 1							; (2 bytes)
.delay_flag			ds.b 1							; (1 byte)
.spike_flag			ds.b 1							; (1 byte)
.wait				ds.w 1							; (2 bytes)
.copyX				ds.w 1							; copy x-axis position (2 bytes)
.xvel				ds.w 1							; (2 bytes)
.pole_xoffset			ds.w 1							; (2 bytes)
.spikes_xoffset			ds.w 1							; (2 bytes)


	dsreset										; stop pretending and reset the program counter

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
		move.b	SStom_Len(pc,d0.w),sidestomp.length(a0)

		; init
		movem.l	ObjDat_SideStomp(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.b	#1,mapping_frame(a0)

		; set sub objects
		move.w	#2,mainspr_childsprites(a0)					; wall bracket, pole

		; set xpos
		move.w	x_pos(a0),d0
		move.w	d0,sidestomp.origX(a0)
		move.w	d0,sidestomp.copyX(a0)

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
		move.w	d1,sidestomp.pole_xoffset(a0)
		move.w	y_pos(a0),(a1)+							; ypos
		move.b	#4,1(a1)							; frame (pole) ; skip $22 byte (mapping_frame)

		; object 3 (spikes)
		move.w	d0,d1
		subi.w	#28,d1
		move.w	d1,sidestomp.spikes_xoffset(a0)

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
		add.b	sidestomp.xoffset(a0),d0
		lsr.b	#5,d0
		addq.b	#4,d0
		move.b	d0,sub3_mapframe(a0)
		moveq	#0,d0
		move.b	sidestomp.xoffset(a0),d0
		neg.w	d0
		add.w	sidestomp.pole_xoffset(a0),d0
		move.w	d0,sub3_x_pos(a0)

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	sidestomp.copyX(a0),d0						; get object position
		jmp	(Sprite_CheckDelete.skipxpos).w

; =============== S U B R O U T I N E =======================================

SStom_TypeIndex: offsetTable
		offsetTableEntry.w SStom_Type00						; 0
		offsetTableEntry.w SStom_Type00						; 1
		offsetTableEntry.w SStom_Type00						; 2
; ---------------------------------------------------------------------------

SStom_Type00:
		tst.b	sidestomp.delay_flag(a0)
		beq.s	loc_BB08
		tst.w	sidestomp.wait(a0)
		beq.s	loc_BAEC
		subq.w	#1,sidestomp.wait(a0)
		bra.s	loc_BB3C
; ---------------------------------------------------------------------------

loc_BAEC:
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.skipsfx							; if not, branch

		; play continuous sfx
		sfxcont	sfx_ChainRise, $F						; play rising chain sound every 16th frame

.skipsfx
		subi.w	#$80,sidestomp.xoffset(a0)
		bhs.s	loc_BB3C
		moveq	#0,d0
		move.w	d0,sidestomp.xoffset(a0)
		move.w	d0,sidestomp.xvel(a0)
		move.b	d0,sidestomp.delay_flag(a0)
		bra.s	loc_BB3E
; ---------------------------------------------------------------------------

loc_BB08:
		move.w	sidestomp.length(a0),d1
		cmp.w	sidestomp.xoffset(a0),d1
		beq.s	loc_BB3C
		move.w	sidestomp.xvel(a0),d0
		addi.w	#$70,sidestomp.xvel(a0)
		add.w	d0,sidestomp.xoffset(a0)
		cmp.w	sidestomp.xoffset(a0),d1
		bhi.s	loc_BB3C
		move.w	d1,sidestomp.xoffset(a0)
		clr.w	sidestomp.xvel(a0)
		st	sidestomp.delay_flag(a0)
		move.w	#1*60,sidestomp.wait(a0)
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_BB3C							; if not, branch
		sfx	sfx_ChainStomp							; play stomping sound

loc_BB3C:
		moveq	#0,d0

loc_BB3E:
		move.b	sidestomp.xoffset(a0),d0
		neg.w	d0
		add.w	sidestomp.origX(a0),d0
		move.w	d0,x_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

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
		move.b	sidestomp.xoffset(a1),d0
		neg.w	d0
		add.w	sidestomp.spikes_xoffset(a1),d0
		move.w	d0,x_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_SideStomp:	subObjMainData \
				Obj_SideStomp.action, \
					setBit(render_flags.level) | \
					setBit(render_flags.multi_sprite), \
				0, 64, 256, 3, $328, 0, FALSE, Map_SStom

ObjDat_SideStomp_Spikes:	subObjData FALSE, FALSE, 0, FALSE, 40, 32, 4, 2, 0

Child6_SideStomp_Spikes:
		dc.w 1-1
		dc.l Obj_SideStomp_Spikes
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Chained Stompers/Object Data/Map - Sideways Stomp.asm"
