; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

chainedstomper.origY			ds.w 1						; original y-axis position (2 bytes)
chainedstomper.yoffset			ds.w 1						; (2 bytes)
chainedstomper.length			ds.w 1						; (2 bytes)
chainedstomper.delay_flag		ds.b 1						; (1 byte)
chainedstomper.spike_flag		ds.b 1						; (1 byte)
chainedstomper.wait			ds.b 1						; (1 byte)
chainedstomper.switch			ds.b 1						; switch number for the current stomper (1 byte)
chainedstomper.cap_yoffset		ds.w 1						; (2 bytes)
chainedstomper.chain_yoffset		ds.w 1						; (2 bytes)
chainedstomper.yvel			ds.w 1						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

ChainedStomper_Length:	dc.b $70, $A0, $50, $78, $38, $58, $B8, $70			; length
	even
ChainedStomper_Var2:
		dc.b 112/2, 1								; width, frame number
		dc.b 96/2, $A
		dc.b 32/2, $B
; ---------------------------------------------------------------------------

Obj_ChainedStomper:

		; set
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d1
		cmpi.w	#$20,d1
		seq	chainedstomper.spike_flag(a0)

		; check
		tst.b	d0
		bpl.s	.plus
		clr.b	subtype(a0)
		andi.w	#$7F,d0
		beq.s	.plus
		addq.b	#1,chainedstomper.switch(a0)					; set 1

.plus
		andi.w	#$F,d0
		move.b	ChainedStomper_Length(pc,d0.w),d2
		tst.w	d0
		bne.s	.notzero
		move.b	d2,chainedstomper.yoffset(a0)
;		clr.b	chainedstomper.yoffset+1(a0)

.notzero
		move.b	d2,chainedstomper.length(a0)
;		clr.b	chainedstomper.length+1(a0)

		; init
		movem.l	ObjDat_ChainedStomper(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object

		; set
		move.b	subtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		lea	ChainedStomper_Var2(pc,d0.w),a1
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,mapping_frame(a0)

		; get ypos
		move.w	y_pos(a0),d0
		move.w	d0,chainedstomper.origY(a0)

		; set cap ypos
		moveq	#-16,d1
		add.w	d0,d1
		move.w	d1,chainedstomper.cap_yoffset(a0)

		; set chain ypos
		moveq	#-52,d1
		add.w	d0,d1
		move.w	d1,chainedstomper.chain_yoffset(a0)

		; set sub objects
		move.w	#2,mainspr_childsprites(a0)					; chain and cap

		; sub object 1
		lea	sub2_x_pos(a0),a1						; $16-$29 bytes reserved
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	chainedstomper.cap_yoffset(a0),(a1)+				; ypos
		move.w	#3,(a1)+							; frame (cap)

		; sub object 2
		move.w	x_pos(a0),(a1)+							; xpos
		move.w	chainedstomper.chain_yoffset(a0),(a1)+				; ypos
		move.b	#4,1(a1)							; frame (chain) ; skip $22 byte (mapping_frame)

		; check
		tst.b	chainedstomper.spike_flag(a0)
		bne.s	.action

		; create spikes
		lea	Child6_ChainedStomper_Spikes(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.action

		; spikes ypos
		moveq	#28,d0
		add.w	y_pos(a0),d0
		move.w	d0,chainedstomper_spikes.spike_yoffset(a1)

.action
		moveq	#$F,d0
		and.b	subtype(a0),d0
		add.w	d0,d0
		move.w	ChainedStomper_TypeIndex(pc,d0.w),d0
		jsr	ChainedStomper_TypeIndex(pc,d0.w)

		; sub objects 2 (chain)
		moveq	#0,d0
		move.b	chainedstomper.yoffset(a0),d0
		move.w	d0,d1
		lsr.b	#5,d0
		addq.b	#4,d0
		move.b	d0,sub3_mapframe(a0)
		add.w	chainedstomper.chain_yoffset(a0),d1
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

ChainedStomper_TypeIndex: offsetTable
		offsetTableEntry.w ChainedStomper_Type00				; 0
		offsetTableEntry.w ChainedStomper_Type01				; 1
		offsetTableEntry.w ChainedStomper_Type01				; 2
		offsetTableEntry.w ChainedStomper_Type03				; 3
		offsetTableEntry.w ChainedStomper_Type01				; 4
		offsetTableEntry.w ChainedStomper_Type03				; 5
		offsetTableEntry.w ChainedStomper_Type01				; 6
		offsetTableEntry.w ChainedStomper_Type03				; 7
		offsetTableEntry.w ChainedStomper_Type01				; 8
; ---------------------------------------------------------------------------

ChainedStomper_Type00:
		moveq	#0,d0
		move.b	chainedstomper.switch(a0),d0					; move number 0 or 1 to d0
		lea	(Level_trigger_array).w,a2					; load switch statuses

		; check
		tst.b	(a2,d0.w)							; has switch (d0) been pressed?
		beq.s	loc_B8A8							; if not, branch
		tst.w	(Chain_stomp_addr).w
		bpl.s	loc_B872
		cmpi.b	#$10,chainedstomper.yoffset(a0)
		beq.s	loc_B8A0

loc_B872:
		tst.w	chainedstomper.yoffset(a0)
		beq.s	loc_B8A0

		; check Sonic
		jsr	(Find_SonicObject).w
		cmpi.w	#192,d2								; is object within $C0 pixels of Sonic?
		bhs.s	loc_B892							; if not, branch
		cmpi.w	#256,d3								; is object within $100 pixels of Sonic?
		bhs.s	loc_B892							; if not, branch

		; check visible
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_B892							; if not, branch

		; play continuous sfx
		sfxcont	sfx_ChainRise, $F						; play rising chain sound every 16th frame

loc_B892:
		subi.w	#$80,chainedstomper.yoffset(a0)
		bhs.s	ChainedStomper_Restart
		clr.w	chainedstomper.yoffset(a0)

loc_B8A0:
		clr.w	chainedstomper.yvel(a0)
		bra.s	ChainedStomper_Restart
; ---------------------------------------------------------------------------

loc_B8A8:
		move.w	chainedstomper.length(a0),d1
		cmp.w	chainedstomper.yoffset(a0),d1
		beq.s	ChainedStomper_Restart
		move.w	chainedstomper.yvel(a0),d0
		addi.w	#$70,chainedstomper.yvel(a0)					; make object fall
		add.w	d0,chainedstomper.yoffset(a0)
		cmp.w	chainedstomper.yoffset(a0),d1
		bhi.s	ChainedStomper_Restart
		move.w	d1,chainedstomper.yoffset(a0)
		clr.w	chainedstomper.yvel(a0)						; stop object falling
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	ChainedStomper_Restart							; if not, branch
		sfx	sfx_ChainStomp							; play stomping sound

ChainedStomper_Restart:
		moveq	#0,d0
		move.b	chainedstomper.yoffset(a0),d0
		add.w	chainedstomper.origY(a0),d0
		move.w	d0,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

ChainedStomper_Type01:
		tst.b	chainedstomper.delay_flag(a0)
		beq.s	loc_B938
		tst.b	chainedstomper.wait(a0)
		beq.s	loc_B902
		subq.b	#1,chainedstomper.wait(a0)
		bra.s	ChainedStomper_Restart
; ---------------------------------------------------------------------------

loc_B902:

		; check Sonic
		jsr	(Find_SonicObject).w
		cmpi.w	#192,d2								; is object within $C0 pixels of Sonic?
		bhs.s	loc_B91C							; if not, branch
		cmpi.w	#256,d3								; is object within $100 pixels of Sonic?
		bhs.s	loc_B91C							; if not, branch

		; check visible
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_B91C							; if not, branch

		; play continuous sfx
		sfxcont	sfx_ChainRise, $F						; play rising chain sound every 16th frame

loc_B91C:
		subi.w	#$80,chainedstomper.yoffset(a0)
		bhs.s	ChainedStomper_Restart
		clr.w	chainedstomper.yvel(a0)
		clr.w	chainedstomper.yoffset(a0)
		clr.b	chainedstomper.delay_flag(a0)
		bra.s	ChainedStomper_Restart
; ---------------------------------------------------------------------------

loc_B938:
		move.w	chainedstomper.length(a0),d1
		cmp.w	chainedstomper.yoffset(a0),d1
		beq.s	loc_B97C
		move.w	chainedstomper.yvel(a0),d0
		addi.w	#$70,chainedstomper.yvel(a0)					; make object fall
		add.w	d0,chainedstomper.yoffset(a0)
		cmp.w	chainedstomper.yoffset(a0),d1
		bhi.s	loc_B97C
		move.w	d1,chainedstomper.yoffset(a0)
		clr.w	chainedstomper.yvel(a0)						; stop object falling
		st	chainedstomper.delay_flag(a0)
		move.b	#1*60,chainedstomper.wait(a0)
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_B97C							; if not, branch
		sfx	sfx_ChainStomp							; play stomping sound

loc_B97C:
		bra.s	loc_B996
; ---------------------------------------------------------------------------

ChainedStomper_Type03:

		; check Sonic
		jsr	(Find_SonicObject).w
		cmpi.w	#144,d2								; is object within $90 pixels of Sonic?
		bhs.s	loc_B996							; if not, branch
		addq.b	#1,subtype(a0)

loc_B996:
		moveq	#0,d0
		move.b	chainedstomper.yoffset(a0),d0
		add.w	chainedstomper.origY(a0),d0
		move.w	d0,y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

chainedstomper_spikes.spike_yoffset	ds.w 1						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_ChainedStomper_Spikes:

		; init
		lea	ObjDat_ChainedStomper_Spikes(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.main,code_addr(a0)

.main
		moveq	#0,d0
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	chainedstomper.yoffset(a1),d0
		add.w	chainedstomper_spikes.spike_yoffset(a0),d0
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

; init
ObjDat_ChainedStomper:	subObjMainData \
				Obj_ChainedStomper.action, \
					setBit(render_flags.level) | \
					setBit(render_flags.multi_sprite), \
				0, 424, 112, 4, $328, 0, FALSE, Map_ChainedStomper

ObjDat_ChainedStomper_Spikes:	subObjData FALSE, FALSE, 0, FALSE, 32, 96, 5, 2, collision_type.npc.none, 0, 0

Child6_ChainedStomper_Spikes:
		dc.w 1-1
		dc.l Obj_ChainedStomper_Spikes
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Chained Stomper/Object Data/Map - Chained Stomper.asm"
