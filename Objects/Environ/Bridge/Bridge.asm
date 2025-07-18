; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TensionBridge:

		; init
		move.l	#sub_387E0,address(a0)						; normal bridge
		move.l	#Map_TensionBridge,mappings(a0)
		move.w	#make_art_tile($33E,2,0),art_tile(a0)
		tst.b	subtype(a0)
		bpl.s	.plus
		move.l	#sub_387B6,address(a0)						; bridge explosion
		andi.b	#$7F,subtype(a0)

.plus
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(16/2,256/2,priority_3),height_pixels(a0)	; set height, width and priority
		move.w	y_pos(a0),d2
		move.w	d2,objoff_3C(a0)
		move.w	x_pos(a0),d3
		lea	subtype(a0),a2							; copy bridge subtype to a2
		moveq	#0,d1
		move.b	(a2),d1								; d1 = subtype
		move.w	d1,d0
		lsr.w	d0
		lsl.w	#4,d0								; (d0 div 2) * 16
		sub.w	d0,d3								; x position of left half
		swap	d1								; store subtype in high word for later
		move.w	#8,d1
		bsr.s	sub_38756
		move.w	sub6_x_pos(a1),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)							; center of first subsprite object
		move.w	a1,objoff_30(a0)						; pointer to first subsprite object
		swap	d1								; retrieve subtype
		subq.w	#8,d1
		bls.s	loc_38752							; branch, if subtype <= 8 (bridge has no more than 8 logs)

		; else, create a second subsprite object for the rest of the bridge
		move.w	d1,d4
		bsr.s	sub_38756
		move.w	a1,objoff_34(a0)						; pointer to second subsprite object
		move.w	d4,d0
		add.w	d0,d0
		add.w	d4,d0								; d0*3
		move.w	sub2_x_pos(a1,d0.w),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)							; center of second subsprite object

loc_38752:
		bra.s	sub_387E0

; =============== S U B R O U T I N E =======================================

sub_38756:
		jsr	(Create_New_Sprite3).w
		bne.s	.return
		move.l	#Draw_Sprite,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	priority(a0),priority(a1)
		bset	#render_flags.multi_sprite,render_flags(a1)			; set multi-draw flag
		move.w	#bytes_to_word(16/2,128/2),height_pixels(a1)			; set height and width
		move.w	d1,mainspr_childsprites(a1)
		subq.b	#1,d1
		lea	sub2_x_pos(a1),a2						; starting address for subsprite data

.loop
		move.w	d3,(a2)+							; xpos
		move.w	d2,(a2)+							; ypos
		clr.w	(a2)+								; mapping frame
		addi.w	#16,d3								; width of a log, x_pos for next log
		dbf	d1,.loop

.return
		rts

; =============== S U B R O U T I N E =======================================

sub_387B6:										; check bridge explosion
		moveq	#$F,d0
		and.b	subtype(a0),d0
		lea	(Level_trigger_array).w,a3
		tst.b	(a3,d0.w)
		beq.s	sub_387E0							; bridge not explode

loc_387BE:
		move.l	#loc_388E4,d4
		bsr.w	sub_389C8

		; set wait
		move.b	#$E,objoff_34(a0)

		; next
		lea	loc_3890C(pc),a1						; bridge explode
		move.l	a1,address(a0)
		jmp	(a1)

; =============== S U B R O U T I N E =======================================

sub_387E0:
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	loc_387F6							; if yes, branch
		tst.b	objoff_3E(a0)
		beq.s	loc_38822
		subq.b	#4,objoff_3E(a0)
		bra.s	loc_3881E
; ---------------------------------------------------------------------------

loc_387F6:
		andi.b	#p2_standing,d0
		beq.s	loc_38812
		move.b	objoff_3F(a0),d0						; Sonic
		sub.b	objoff_3B(a0),d0						; Tails
		beq.s	loc_38812
		bhs.s	loc_3880E
		addq.b	#1,objoff_3F(a0)
		bra.s	loc_38812
; ---------------------------------------------------------------------------

loc_3880E:
		subq.b	#1,objoff_3F(a0)

loc_38812:
		cmpi.b	#$40,objoff_3E(a0)
		beq.s	loc_3881E
		addq.b	#4,objoff_3E(a0)

loc_3881E:
		bsr.w	sub_38CC2

loc_38822:
		moveq	#0,d1
		move.b	subtype(a0),d1
		lsl.w	#3,d1								; multiply by 8
		move.w	d1,d2								; width
		addq.w	#8,d1
		add.w	d2,d2
		moveq	#16/2,d3							; height
		move.w	x_pos(a0),d4
		bsr.w	SolidObject_TensionBridge
		out_of_xrange.s	.chkdel
		rts
; ---------------------------------------------------------------------------

.chkdel
		movea.w	objoff_30(a0),a1						; a1=object
		jsr	(Delete_Referenced_Sprite).w
		cmpi.b	#8,subtype(a0)
		bls.s	.offscreen							; if bridge has more than 8 logs, delete second subsprite object
		movea.w	objoff_34(a0),a1						; a1=object
		jsr	(Delete_Referenced_Sprite).w

.offscreen
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#7,(a2)

.delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

loc_388E4:
		tst.b	objoff_34(a0)
		beq.s	loc_388F4
		subq.b	#1,objoff_34(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_388F4:
		jsr	(MoveSprite).w
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_38906							; if not, branch
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_38906:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

loc_3890C:
		tst.b	objoff_34(a0)
		beq.s	loc_38918
		subq.b	#1,objoff_34(a0)

locret_38916:
		rts
; ---------------------------------------------------------------------------

loc_38918:

		; clear player standing
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object

		; delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_389C8:
		movea.w	objoff_30(a0),a3						; a3=object
		bsr.s	sub_389DE
		cmpi.b	#8,subtype(a0)
		bls.s	locret_38916
		movea.w	objoff_34(a0),a3						; a3=object

sub_389DE:
		lea	byte_38A78(pc),a4
		lea	sub2_x_pos(a3),a2
		move.w	mainspr_childsprites(a3),d6
		subq.w	#1,d6
		bclr	#render_flags.multi_sprite,render_flags(a3)			; clear multi-draw flag
		movea.w	a3,a1								; load object to a1
		bra.s	loc_38A00
; ---------------------------------------------------------------------------

loc_389F8:
		jsr	(Create_New_Sprite3).w
		bne.s	loc_38A64

loc_38A00:
		move.l	d4,address(a1)
		move.l	mappings(a3),mappings(a1)
		move.b	render_flags(a3),render_flags(a1)
		move.w	art_tile(a3),art_tile(a1)
		move.w	height_pixels(a3),height_pixels(a1)				; set height and width
		move.w	priority(a3),priority(a1)
		move.w	(a2)+,x_pos(a1)
		move.w	(a2)+,y_pos(a1)
		move.w	(a2)+,d0
		move.b	d0,mapping_frame(a1)
		move.b	(a4)+,objoff_34(a1)
		movea.w	a1,a5								; load object to a5

		; create
		jsr	(Create_New_Sprite3).w
		bne.s	loc_38A64
		move.l	#Obj_TensionBridge_Explosion,address(a1)			; explosion
		move.w	x_pos(a5),x_pos(a1)
		move.w	y_pos(a5),y_pos(a1)
		move.b	-1(a4),anim_frame_timer(a1)
		dbf	d6,loc_389F8

loc_38A64:
		clr.l	x_vel(a3)
		sfx	sfx_BridgeCollapse,1
; ---------------------------------------------------------------------------

byte_38A78:
		dc.b 8, $10, $C, $E, 6, $A, 4, 2
		dc.b 8, $10, $C, $E, 6, $A, 4, 2

; ---------------------------------------------------------------------------
; Subroutine to check solid the tension bridge object
; These check for solidity even if the object is off-screen

; input variables:
; d1 = object width / 2
; d2 = object height / 2 (when jumping)
; d3 = object height / 2 (when walking)
; d4 = object x-axis position

; address registers:
; a0 = the object to check collision with
; a1 = Sonic (set inside these subroutines)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SolidObject_TensionBridge:

		; player 2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is the player RAM empty?
		beq.s	.p1								; if yes, branch
		moveq	#p2_standing_bit,d6
		moveq	#objoff_3B,d5
		movem.l	d1-d4,-(sp)
		bsr.s	.check
		movem.l	(sp)+,d1-d4

.p1

		; player 1
		lea	(Player_1).w,a1							; a1=character
		moveq	#p1_standing_bit,d6
		moveq	#objoff_3F,d5

.check
		btst	d6,status(a0)							; is the player standing on the current object?
		beq.s	SolidObjCheck_TensionBridge					; if not, branch
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		bne.s	.release							; if yes, branch
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	.release
		cmp.w	d2,d0
		blo.s	.stand

.release
		bclr	#status.player.on_object,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

.stand

		; inlined call to MvSonicOnPtfm
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)
		movea.w	objoff_30(a0),a2						; a2=object
		cmpi.w	#8,d0
		blo.s	.skip
		movea.w	objoff_34(a0),a2						; a2=object
		subq.w	#8,d0

.skip
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	sub2_y_pos(a2,d0.w),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	y_radius(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		moveq	#0,d4
		rts

; =============== S U B R O U T I N E =======================================

SolidObjCheck_TensionBridge:
		move.w	d1,-(sp)
		jsr	(sub_1E410).w
		move.w	(sp)+,d1

		; check
		btst	d6,status(a0)							; is the player standing on the current object?
		beq.s	.return								; if not, branch
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)

.return
		rts

; =============== S U B R O U T I N E =======================================

sub_38CC2:
		move.b	objoff_3E(a0),d0
		jsr	(GetSineCosine).w
		move.w	d0,d4
		lea	BridgeBendData(pc),a4
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	BridgeDepression(pc),a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		movea.w	objoff_30(a0),a1						; a1=object
		lea	next_object(a1),a2
		lea	sub2_y_pos(a1),a1

loc_38D08:
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a0),d0
		move.w	d0,(a1)
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	loc_38D28
		movea.w	objoff_34(a0),a1						; a1=object
		lea	sub2_y_pos(a1),a1

loc_38D28:
		dbf	d2,loc_38D08
		moveq	#0,d0
		move.b	subtype(a0),d0
		moveq	#1,d3
		add.b	objoff_3F(a0),d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_38D72
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		blo.s	locret_38D72

loc_38D4E:
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a0),d0
		move.w	d0,(a1)
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	loc_38D6E
		movea.w	objoff_34(a0),a1						; a1=object
		lea	sub2_y_pos(a1),a1

loc_38D6E:
		dbf	d2,loc_38D4E

locret_38D72:
		rts
; ---------------------------------------------------------------------------

BridgeDepression:	binclude "Objects/Environ/Bridge/Object Data/Depression.bin"
	even
BridgeBendData:		binclude "Objects/Environ/Bridge/Object Data/Bend.bin"
	even
; ---------------------------------------------------------------------------

		include "Objects/Environ/Bridge/Object Data/Map - Tension Bridge.asm"
