; ---------------------------------------------------------------------------
; Object 65 - waterfalls (LZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Waterfall:

		; init
		lea	ObjDat_Waterfalls(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.chkdel,address(a0)

		; set
		move.b	subtype(a0),d0							; get object type
		bpl.s	.under80							; branch if $00-$7F
		bset	#high_priority_bit,art_tile(a0)					; high priority

.under80
		andi.b	#$F,d0								; read only the 2nd digit
		move.b	d0,mapping_frame(a0)						; set frame number
		cmpi.b	#9,d0								; is object type $x9?
		bne.s	.chkdel								; if not, branch
		clr.w	priority(a0)							; object is in front of Sonic
		move.l	#.anim,address(a0)
		btst	#6,subtype(a0)							; is object type $49?
		beq.s	.not49								; if not, branch
		move.l	#.onwater,address(a0)

.not49
		btst	#5,subtype(a0)							; is object type $A9?
		beq.s	.anim								; if not, branch
		move.l	#.loc_12B36,address(a0)

.anim
		lea	AniRaw_WFall(pc),a1
		jsr	(Animate_RawNoSST).w

.chkdel
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.onwater
		moveq	#-16,d0
		add.w	(Water_level).w,d0
		move.w	d0,y_pos(a0)							; match object position to water height
		bra.s	.anim
; ---------------------------------------------------------------------------

.loc_12B36
		bclr	#high_priority_bit,art_tile(a0)					; low priority
		tst.l	(Chunk_table+($32*$80+$20)).l					; is empty block?
		bne.s	.anim								; if not, branch
		bset	#high_priority_bit,art_tile(a0)					; high priority
		bra.s	.anim

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Waterfalls:	subObjData Map_WFall, $259, 2, 0, 48, 48, 1, 0, 0

AniRaw_WFall:	dc.b 5, 9, $A, $B, arfEnd
	even
; ---------------------------------------------------------------------------

		include "Objects/Environ/Labyrinth Waterfalls/Object Data/Map - Waterfalls.asm"
