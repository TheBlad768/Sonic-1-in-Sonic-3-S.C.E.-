; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
CStom_ypos				= objoff_30	; .w ; copy ypos
CStom_32				= objoff_32	; .w
CStom_34				= objoff_34	; .w
CStom_timedelay				= objoff_36	; .b
CStom_spike_flag			= objoff_37	; .b
CStom_fall_flag				= objoff_38	; .b
CStom_switch				= objoff_3A	; .b ; switch number for the current stomper
CStom_childy1				= objoff_3C	; .w
CStom_childy2				= objoff_3E	; .w
CStom_childy3				= objoff_40	; .w
CStom_y_vel				= objoff_42	; .w

; =============== S U B R O U T I N E =======================================

CStom_Length:	dc.b $70, $A0, $50, $78, $38, $58, $B8, $70	; length
	even
CStom_Var2:
		dc.b 112/2, 1								; width, frame number
		dc.b 96/2, $A
		dc.b 32/2, $B
; ---------------------------------------------------------------------------

Obj_ChainStomp:

		; set
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d1
		cmpi.w	#$20,d1
		seq	objoff_37(a0)

		; check
		tst.b	d0
		bpl.s	.plus
		clr.b	subtype(a0)
		andi.w	#$7F,d0
		beq.s	.plus
		addq.b	#1,CStom_switch(a0)						; set 1

.plus
		andi.w	#$F,d0
		move.b	CStom_Length(pc,d0.w),d2
		tst.w	d0
		bne.s	.notzero
		move.b	d2,objoff_32(a0)
;		clr.b	objoff_33(a0)

.notzero
		move.b	d2,objoff_34(a0)
;		clr.b	objoff_35(a0)

		; init
		movem.l	ObjDat_ChainStomp(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; set
		move.b	subtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		lea	CStom_Var2(pc,d0.w),a1
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,mapping_frame(a0)

		; get ypos
		move.w	y_pos(a0),d0
		move.w	d0,objoff_30(a0)

		; set cap ypos
		moveq	#-16,d1
		add.w	d0,d1
		move.w	d1,objoff_3C(a0)

		; set chain ypos
		moveq	#-52,d1
		add.w	d0,d1
		move.w	d1,objoff_3E(a0)

		; set sub objects
		move.w	#2,mainspr_childsprites(a0)					; chain and cap

		; sub object 1
		lea	sub2_x_pos(a0),a1						; $16-$29 bytes reserved
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	objoff_3C(a0),(a1)+						; ypos
		move.w	#3,(a1)+							; frame (cap)

		; sub object 2
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	objoff_3E(a0),(a1)+						; ypos
		move.b	#4,1(a1)							; frame (chain) ; skip $22 byte (mapping_frame)

		; check
		tst.b	objoff_37(a0)
		bne.s	.action

		; create spikes
		lea	Child6_ChainStomp_Spikes(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.action

		; spikes ypos
		moveq	#28,d0
		add.w	y_pos(a0),d0
		move.w	d0,objoff_40(a1)

.action
		moveq	#$F,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		move.w	CStom_TypeIndex(pc,d0.w),d0
		jsr	CStom_TypeIndex(pc,d0.w)

		; sub objects 2 (chain)
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		move.w	d0,d1
		lsr.b	#5,d0
		addq.b	#4,d0
		move.b	d0,sub3_mapframe(a0)
		add.w	objoff_3E(a0),d1
		move.w	d1,sub3_y_pos(a0)

		; solid
		move.w	y_pos(a0),(Chain_stomp_addr).w
		moveq	#$B,d1								; width
		add.b	width_pixels(a0),d1
		moveq	#24/2,d2							; height
		moveq	#(24/2)+1,d3							; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; draw
		jmp	(Sprite_CheckDelete).w

; =============== S U B R O U T I N E =======================================

CStom_TypeIndex: offsetTable
		offsetTableEntry.w CStom_Type00						; 0
		offsetTableEntry.w CStom_Type01						; 1
		offsetTableEntry.w CStom_Type01						; 2
		offsetTableEntry.w CStom_Type03						; 3
		offsetTableEntry.w CStom_Type01						; 4
		offsetTableEntry.w CStom_Type03						; 5
		offsetTableEntry.w CStom_Type01						; 6
		offsetTableEntry.w CStom_Type03						; 7
		offsetTableEntry.w CStom_Type01						; 8
; ---------------------------------------------------------------------------

CStom_Type00:
		moveq	#0,d0
		move.b	CStom_switch(a0),d0						; move number 0 or 1 to d0
		lea	(Level_trigger_array).w,a2					; load switch statuses
		tst.b	(a2,d0.w)							; has switch (d0) been pressed?
		beq.s	loc_B8A8							; if not, branch
		tst.w	(Chain_stomp_addr).w
		bpl.s	loc_B872
		cmpi.b	#$10,objoff_32(a0)
		beq.s	loc_B8A0

loc_B872:
		tst.w	objoff_32(a0)
		beq.s	loc_B8A0

		; check Sonic
		jsr	(Find_SonicObject).w
		cmpi.w	#192,d2								; is Object within $C0 pixels of Sonic?
		bhs.s	loc_B892							; if not, branch
		cmpi.w	#256,d3								; is Object within $100 pixels of Sonic?
		bhs.s	loc_B892							; if not, branch

		; check visible
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_B892							; if not, branch

		; play continuous sfx
		sfxcont	sfx_ChainRise,$F						; play rising chain sound every 16th frame

loc_B892:
		subi.w	#$80,objoff_32(a0)
		bhs.s	CStom_Restart
		clr.w	objoff_32(a0)

loc_B8A0:
		clr.w	objoff_42(a0)
		bra.s	CStom_Restart
; ---------------------------------------------------------------------------

loc_B8A8:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	CStom_Restart
		move.w	objoff_42(a0),d0
		addi.w	#$70,objoff_42(a0)						; make object fall
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	CStom_Restart
		move.w	d1,objoff_32(a0)
		clr.w	objoff_42(a0)							; stop object falling
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	CStom_Restart							; if not, branch
		sfx	sfx_ChainStomp							; play stomping sound

CStom_Restart:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

CStom_Type01:
		tst.b	objoff_36(a0)
		beq.s	loc_B938
		tst.b	objoff_38(a0)
		beq.s	loc_B902
		subq.b	#1,objoff_38(a0)
		bra.s	CStom_Restart
; ---------------------------------------------------------------------------

loc_B902:

		; check Sonic
		jsr	(Find_SonicObject).w
		cmpi.w	#192,d2								; is Object within $C0 pixels of Sonic?
		bhs.s	loc_B91C							; if not, branch
		cmpi.w	#256,d3								; is Object within $100 pixels of Sonic?
		bhs.s	loc_B91C							; if not, branch

		; check visible
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_B91C							; if not, branch

		; play continuous sfx
		sfxcont	sfx_ChainRise,$F						; play rising chain sound every 16th frame

loc_B91C:
		subi.w	#$80,objoff_32(a0)
		bhs.s	CStom_Restart
		clr.w	objoff_42(a0)
		clr.w	objoff_32(a0)
		clr.b	objoff_36(a0)
		bra.s	CStom_Restart
; ---------------------------------------------------------------------------

loc_B938:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	loc_B97C
		move.w	objoff_42(a0),d0
		addi.w	#$70,objoff_42(a0)						; make object fall
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	loc_B97C
		move.w	d1,objoff_32(a0)
		clr.w	objoff_42(a0)							; stop object falling
		st	objoff_36(a0)
		move.b	#1*60,objoff_38(a0)
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_B97C							; if not, branch
		sfx	sfx_ChainStomp							; play stomping sound

loc_B97C:
		bra.s	loc_B996
; ---------------------------------------------------------------------------

CStom_Type03:

		; check Sonic
		jsr	(Find_SonicObject).w
		cmpi.w	#144,d2								; is Object within $90 pixels of Sonic?
		bhs.s	loc_B996							; if not, branch
		addq.b	#1,subtype(a0)

loc_B996:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ChainStomp_Spikes:

		; init
		lea	ObjDat_ChainStomp_Spikes(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.main,address(a0)

.main
		moveq	#0,d0
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	objoff_32(a1),d0
		add.w	objoff_40(a0),d0
		move.w	d0,y_pos(a0)

		; solid
		moveq	#112/2,d1							; width
		moveq	#32/2,d2							; height
		moveq	#(32/2)+1,d3							; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; check players
		swap	d6
		andi.w	#touch_bottom_mask,d6						; is Sonic or Tails touch bottom?
		beq.s	.draw								; if not, branch
		move.b	d6,d0
		andi.b	#p1_touch_bottom,d0						; Sonic/Knux touch bottom?
		beq.s	.notp1								; if not, branch
		lea	(Player_1).w,a1							; a1=character
		jsr	(Touch_ChkHurt3).l						; hurt character

.notp1
		andi.b	#p2_touch_bottom,d6						; Tails touch bottom?
		beq.s	.draw								; if not, branch
		lea	(Player_2).w,a1							; a1=character
		jsr	(Touch_ChkHurt3).l						; hurt character

.draw
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_ChainStomp:		subObjMainData Obj_ChainStomp.action, setBit(render_flags.level)|setBit(render_flags.multi_sprite), 0, 424, 112, 4, $328, 0, 0, Map_CStom
ObjDat_ChainStomp_Spikes:	subObjData FALSE, FALSE, 0, 0, 32, 96, 5, 2, 0

Child6_ChainStomp_Spikes:
		dc.w 1-1
		dc.l Obj_ChainStomp_Spikes
; ---------------------------------------------------------------------------

		include "Objects/Environ/Chained Stompers/Object Data/Map - Chain Stomp.asm"
