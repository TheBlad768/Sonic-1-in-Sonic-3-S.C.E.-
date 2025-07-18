; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ, LZ, SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
MBorigX:			= objoff_30	; .w
MBorigY:			= objoff_32	; .w

; =============== S U B R O U T I N E =======================================

MBlock_Var:

		; object width, frame number
		dc.b 32/2, 0		; 0
		dc.b 64/2, 1		; 2 ($10 subtype)
		dc.b 64/2, 2		; 4 ($20 subtype)
		dc.b 128/2, 3		; 6 ($30 subtype)
		dc.b 96/2, 4		; 8 ($40 subtype)
; ---------------------------------------------------------------------------

Obj_MovingBlock:

		; init
		move.l	#Map_MBlock,d2
		move.w	#make_art_tile($562,2,0),d1
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		moveq	#48/2,d0							; height and y_radius

		; check level
		cmpi.b	#LevelID_LZ,(Current_zone).w					; check if level is LZ
		bne.s	.notLZ								; if not, branch
		move.l	#Map_MBlockLZ,d2						; LZ specific code
		move.w	#make_art_tile($3BC,2,0),d1
		bset	#render_flags.static_mappings,render_flags(a0)			; set static mapping flag
		moveq	#14/2,d0							; height and y_radius

.notLZ
		move.b	d0,height_pixels(a0)
		move.b	d0,y_radius(a0)
		move.l	d2,mappings(a0)

		; check level
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; check if level is SBZ
		bne.s	.notSBZ								; if not, branch
		move.w	#make_art_tile($2B2,1,0),d1					; SBZ specific code (object 5228)
		cmpi.b	#$28,subtype(a0)						; is object 5228?
		beq.s	.notSBZ								; if yes, branch
		move.w	#make_art_tile($380,2,0),d1					; SBZ specific code (object 523x)

.notSBZ
		move.w	d1,art_tile(a0)
		move.b	subtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	MBlock_Var(pc,d0.w),a2
		move.b	(a2),x_radius(a0)
		move.b	(a2)+,width_pixels(a0)
		move.b	(a2)+,mapping_frame(a0)
		move.w	#priority_4,priority(a0)
		move.w	x_pos(a0),MBorigX(a0)
		move.w	y_pos(a0),MBorigY(a0)
		andi.b	#$F,subtype(a0)
		move.l	#.platform,address(a0)

.platform
		move.w	x_pos(a0),-(sp)
		moveq	#$F,d0
		and.b	subtype(a0),d0
		beq.s	.skipt								; if zero, branch
		add.w	d0,d0
		move.w	MBlock_TypeIndex-2(pc,d0.w),d0
		jsr	MBlock_TypeIndex(pc,d0.w)

.skipt
		move.w	(sp)+,d4

		; check
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.chkdel								; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		jsr	(SolidObjectTop).w

.chkdel
		moveq	#-$80,d0							; round down to nearest $80
		and.w	MBorigX(a0),d0							; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

MBlock_TypeIndex: offsetTable
		offsetTableEntry.w MBlock_Type01					; 1
		offsetTableEntry.w MBlock_Type02					; 2
		offsetTableEntry.w MBlock_Type03					; 3
		offsetTableEntry.w MBlock_Type02					; 4
		offsetTableEntry.w MBlock_Type05					; 5
		offsetTableEntry.w MBlock_Type06					; 6
		offsetTableEntry.w MBlock_Type07					; 7
		offsetTableEntry.w MBlock_Type08					; 8
		offsetTableEntry.w MBlock_Type02					; 9
		offsetTableEntry.w MBlock_Type0A					; A

		; extra
		offsetTableEntry.w MBlock_Type02					; B (move and sinking)
		offsetTableEntry.w MBlock_Type05					; C
		offsetTableEntry.w MBlock_Type0D					; D
		offsetTableEntry.w MBlock_Type02					; E (move and sinking extra)
		offsetTableEntry.w MBlock_Type0F					; F
; ---------------------------------------------------------------------------

MBlock_Type01:
		move.b	(Oscillating_Data+$C).w,d0
		moveq	#$60,d1
		btst	#status.npc.x_flip,status(a0)
		beq.s	loc_FF26
		neg.w	d0
		add.w	d1,d0

loc_FF26:
		move.w	MBorigX(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

MBlock_Type02:
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic standing on the platform?
		beq.s	MBlock_02_Wait
		addq.b	#1,subtype(a0)							; if yes, add 1 to type

MBlock_02_Wait:
		rts
; ---------------------------------------------------------------------------

MBlock_Type03:
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1								; has the platform hit a wall?
		bmi.s	MBlock_03_End							; if yes, branch
		addq.w	#1,x_pos(a0)							; move platform to the right
		move.w	x_pos(a0),MBorigX(a0)
		rts
; ---------------------------------------------------------------------------

MBlock_03_End:
		clr.b	subtype(a0)							; change to type 00 (non-moving	type)
		rts
; ---------------------------------------------------------------------------

MBlock_Type05:
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1								; has the platform hit a wall?
		bmi.s	MBlock_05_End							; if yes, branch
		addq.w	#1,x_pos(a0)							; move platform to the right
		move.w	x_pos(a0),MBorigX(a0)
		rts
; ---------------------------------------------------------------------------

MBlock_05_End:
		addq.b	#1,subtype(a0)							; change to type 06 (falling)
		rts
; ---------------------------------------------------------------------------

MBlock_Type06:
		moveq	#$18,d1
		jsr	(MoveSprite_CustomGravity).w					; make the platform fall
		jsr	(ObjCheckFloorDist).w
		tst.w	d1								; has platform hit the floor?
		bpl.s	locret_FFA0							; if not, branch
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)							; stop platform falling
		clr.b	subtype(a0)							; change to type 00 (non-moving)

locret_FFA0:
		rts
; ---------------------------------------------------------------------------

MBlock_Type07:
		tst.b	(Level_trigger_array+2).w					; has switch number 02 been pressed?
		beq.s	MBlock_07_ChkDel
		subq.b	#3,subtype(a0)							; if yes, change object type to 04

MBlock_07_ChkDel:
		addq.w	#4+2,sp								; x_pos from (sp)+

		; check delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	MBorigX(a0),d0							; get object position
		jmp	(Delete_Sprite_If_Not_In_Range2).w
; ---------------------------------------------------------------------------

MBlock_Type08:
		move.b	(Oscillating_Data+$1C).w,d0
		move.w	#$80,d1
		btst	#status.npc.x_flip,status(a0)
		beq.s	loc_FFE2
		neg.w	d0
		add.w	d1,d0

loc_FFE2:
		move.w	MBorigY(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

MBlock_Type0A:
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		add.w	d3,d3
		moveq	#8,d1
		btst	#status.npc.x_flip,status(a0)
		beq.s	loc_10004
		neg.w	d1
		neg.w	d3

loc_10004:
		tst.b	objoff_36(a0)							; is platform set to move back?
		bne.s	MBlock_0A_Back							; if yes, branch
		move.w	x_pos(a0),d0
		sub.w	MBorigX(a0),d0
		cmp.w	d3,d0
		beq.s	MBlock_0A_Wait
		add.w	d1,x_pos(a0)							; move platform
		move.w	#5*60,objoff_34(a0)						; set time delay to 5 seconds
		rts
; ---------------------------------------------------------------------------

MBlock_0A_Wait:
		subq.w	#1,objoff_34(a0)						; subtract 1 from time delay
		bne.s	locret_1002E							; if time remains, branch
		st	objoff_36(a0)							; set platform to move back to its original position

locret_1002E:
		rts
; ---------------------------------------------------------------------------

MBlock_0A_Back:
		move.w	x_pos(a0),d0
		sub.w	MBorigX(a0),d0
		beq.s	MBlock_0A_Reset
		sub.w	d1,x_pos(a0)							; return platform to its original position
		rts
; ---------------------------------------------------------------------------

MBlock_0A_Reset:
		clr.b	objoff_36(a0)
		subq.b	#1,subtype(a0)
		rts
; ---------------------------------------------------------------------------

MBlock_Type0D:
		addi.l	#$2001,y_pos(a0)
		cmpi.b	#$C0,y_pos+3(a0)						; block is sinking in lava ; $A0 - original
		bhs.s	.clearf
		rts
; ---------------------------------------------------------------------------

.clearf
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object

		; delete
		addq.w	#4+2,sp								; x_pos from (sp)+
		jmp	(Sprite_CheckDeleteTouch3.offscreen).w
; ---------------------------------------------------------------------------

MBlock_Type0F:
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		add.w	y_pos(a0),d2
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		add.w	x_pos(a0),d3
		jsr	(ObjCheckRightWallDist_Part3).w
		tst.w	d1								; has the platform hit a wall?
		bmi.s	MBlock_0F_End							; if yes, branch
		addq.w	#1,x_pos(a0)							; move platform to the right
		move.w	x_pos(a0),MBorigX(a0)
		rts
; ---------------------------------------------------------------------------

MBlock_0F_End:
		subq.b	#2,subtype(a0)							; MBlock_Type0D
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Moving Blocks/Object Data/Map - Moving Blocks (LZ).asm"
		include "Objects/Environ/Moving Blocks/Object Data/Map - Moving Blocks (MZ and SBZ).asm"
