; ---------------------------------------------------------------------------
; Object 65 - waterfalls (LZ)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_Waterfall:

		; init
		lea	ObjDat_Waterfalls(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.chkdel,code_addr(a0)

		; set
		move.b	subtype.byte(a0),d0						; get object type
		bpl.s	.under80							; branch if $00-$7F
		bset	#high_priority_bit,art_tile(a0)					; high priority

.under80
		andi.b	#$F,d0								; read only the 2nd digit
		move.b	d0,mapping_frame(a0)						; set frame number
		cmpi.b	#9,d0								; is object type $x9?
		bne.s	.chkdel								; if not, branch
		clr.w	priority(a0)							; object is in front of Sonic
		move.l	#.anim,code_addr(a0)
		btst	#6,subtype.byte(a0)						; is object type $49?
		beq.s	.not49								; if not, branch
		move.l	#.onwater,code_addr(a0)

.not49
		btst	#5,subtype.byte(a0)						; is object type $A9?
		beq.s	.anim								; if not, branch
		move.l	#.checkchunk,code_addr(a0)

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

.checkchunk

		; check
		bclr	#high_priority_bit,art_tile(a0)					; low priority
		tst.l	(Chunk_table+($73*$80+$20)).l					; is empty block? ($73 chunk)
		bne.s	.anim								; if not, branch
		bset	#high_priority_bit,art_tile(a0)					; high priority
		bra.s	.anim

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Waterfalls:	subObjData Map_Waterfall, $259, 2, FALSE, 48, 48, 1, 0, collision_type.npc.none, 0, 0

AniRaw_WFall:	dc.b 5, 9, $A, $B, arfEnd
	even
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Labyrinth Waterfall/Object Data/Map - Labyrinth Waterfall.asm"
