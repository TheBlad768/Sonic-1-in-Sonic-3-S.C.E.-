; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge
; ---------------------------------------------------------------------------

; constants
tensionbridge.logcount		= 8							; number of logs

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

tensionbridge			= *

.origY				ds.w 1							; original y-axis position (2 bytes)
.wait				ds.b 1							; wait timer (1 byte)
.bend				ds.b 1							; bridge bend (1 byte)
.indexP1			ds.b 1							; Sonic log index (1 byte)
.indexP2			ds.b 1							; Tails log index (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_TensionBridge:

		; init
		move.l	#TensionBridge_Nudge,address(a0)				; normal bridge
		move.l	#Map_TensionBridge,mappings(a0)
		move.w	#make_art_tile($33E,2,FALSE),art_tile(a0)

		; check
		tst.b	subtype(a0)
		bpl.s	.normal
		andi.b	#$7F,subtype(a0)
		move.l	#TensionBridge_CheckExplosion,address(a0)			; bridge explosion

.normal
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(16/2,256/2,priority_3),height_pixels(a0)	; set height, width and priority
		move.w	y_pos(a0),d2
		move.w	d2,tensionbridge.origY(a0)					; save ypos
		move.w	x_pos(a0),d3
		lea	subtype(a0),a2							; copy bridge subtype to a2
		moveq	#0,d1
		move.b	(a2),d1								; d1 = subtype
		move.w	d1,d0
		lsr.w	d0
		lsl.w	#4,d0								; (d0 div 2) * 16
		sub.w	d0,d3								; x position of left half
		swap	d1								; store subtype in high word for later
		move.w	#tensionbridge.logcount,d1
		bsr.s	TensionBridge_CreateSegments
		move.w	sub6_x_pos(a1),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)							; center of first subsprite object
		move.w	a1,parent3(a0)							; pointer to first subsprite object
		swap	d1								; retrieve subtype
		subq.w	#tensionbridge.logcount,d1
		bls.s	.next								; branch, if subtype <= 8 (bridge has no more than 8 logs)

		; else, create a second subsprite object for the rest of the bridge
		move.w	d1,d4
		bsr.s	TensionBridge_CreateSegments
		move.w	a1,parent4(a0)							; pointer to second subsprite object
		move.w	d4,d0
		add.w	d0,d0
		add.w	d4,d0								; d0*3
		move.w	sub2_x_pos(a1,d0.w),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)							; center of second subsprite object

.next
		bra.s	TensionBridge_Nudge

; =============== S U B R O U T I N E =======================================

TensionBridge_CreateSegments:

		; create
		jsr	(Create_New_Object_3).w
		bne.s	.return
		move.l	#Draw_Sprite,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		moveq	#setBit(render_flags.multi_sprite),d0				; set multi-draw flag
		or.b	render_flags(a0),d0
		move.b	d0,render_flags(a1)
		move.w	priority(a0),priority(a1)
		move.w	#bytes_to_word(16/2,128/2),height_pixels(a1)			; set height and width
		move.w	d1,mainspr_childsprites(a1)
		subq.w	#1,d1								; fix dbf
		lea	sub2_x_pos(a1),a2						; starting address for subsprite data

.loop
		move.w	d3,(a2)+							; xpos
		move.w	d2,(a2)+							; ypos
		addq.w	#next_subspr-4,a2						; mapping frame
		addi.w	#16,d3								; width of a log, x_pos for next log
		dbf	d1,.loop

.return
		rts

; =============== S U B R O U T I N E =======================================

TensionBridge_Nudge:

		; check standing
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	.stand								; if yes, branch

		; check
		tst.b	tensionbridge.bend(a0)
		beq.s	.solid
		subq.b	#4,tensionbridge.bend(a0)					; log up
		bra.s	.bend
; ---------------------------------------------------------------------------

.stand
		andi.b	#p2_standing,d0							; is Tails standing on the object?
		beq.s	.down								; if not, branch

		; check player
		move.b	tensionbridge.indexP1(a0),d0					; Sonic log index
		sub.b	tensionbridge.indexP2(a0),d0					; Tails log index
		beq.s	.down
		bhs.s	.prevlog
		addq.b	#1,tensionbridge.indexP1(a0)					; next log index
		bra.s	.down
; ---------------------------------------------------------------------------

.prevlog
		subq.b	#1,tensionbridge.indexP1(a0)					; prev log index

.down
		cmpi.b	#$40,tensionbridge.bend(a0)
		beq.s	.bend
		addq.b	#4,tensionbridge.bend(a0)					; log down

.bend
		bsr.w	TensionBridge_Bend

.solid
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
		movea.w	parent3(a0),a1							; a1=object
		jsr	(Delete_Referenced_Object).w

		; check second subsprite object
		cmpi.b	#tensionbridge.logcount,subtype(a0)
		bls.s	.offscreen							; if bridge has more than 8 logs, delete second subsprite object
		movea.w	parent4(a0),a1							; a1=object
		jsr	(Delete_Referenced_Object).w

.offscreen
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#respawn_addr.state,(a2)					; turn on the slot

.delete
		jmp	(Delete_Current_Object).w

; =============== S U B R O U T I N E =======================================

Obj_TensionBridge_LogFall:

		; wait
		tst.b	tensionbridge.wait(a0)						; check timer
		beq.s	.setfall							; if time is zero, branch
		subq.b	#1,tensionbridge.wait(a0)					; subtract 1 from frame duration
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.setfall
		move.l	#.fall,address(a0)

.fall
		MoveSprite , $18
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	TensionBridge_CheckExplosion.delete				; if not, branch
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

TensionBridge_CheckExplosion:								; check bridge explosion
		moveq	#$F,d0
		and.b	subtype(a0),d0
		lea	(Level_trigger_array).w,a3

		; check
		tst.b	(a3,d0.w)							; was the button pressed?
		beq.w	TensionBridge_Nudge						; if not, branch

		; set bridge explode
		move.l	#Obj_TensionBridge_LogFall,d4
		bsr.s	TensionBridge_BreakObjectToPieces

		; set wait
		move.b	#$E,tensionbridge.wait(a0)

		; bridge explode
		move.l	#.wait,address(a0)

.wait

		; wait
		tst.b	tensionbridge.wait(a0)						; check timer
		beq.s	.delete								; if time is zero, branch
		subq.b	#1,tensionbridge.wait(a0)					; subtract 1 from frame duration

.return
		rts
; ---------------------------------------------------------------------------

.delete

		; clear player standing
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object

		; delete
		jmp	(Delete_Current_Object).w

; =============== S U B R O U T I N E =======================================

TensionBridge_BreakObjectToPieces:
		movea.w	parent3(a0),a3							; a3=object
		bsr.s	.main

		; check second subsprite object
		cmpi.b	#tensionbridge.logcount,subtype(a0)
		bls.s	TensionBridge_CheckExplosion.return				; if bridge has more than 8 logs, create second subsprite object pieces
		movea.w	parent4(a0),a3							; a3=object

.main
		lea	TensionBridge_TimeData(pc),a4					; load wait time
		lea	sub2_x_pos(a3),a2
		move.w	mainspr_childsprites(a3),d6
		subq.w	#1,d6								; fix dbf
		bclr	#render_flags.multi_sprite,render_flags(a3)			; clear multi-draw flag
		movea.w	a3,a1								; load object address to a1
		bra.s	.load
; ---------------------------------------------------------------------------

.create
		jsr	(Create_New_Object_3).w
		bne.s	.notfree

.load
		move.l	d4,address(a1)
		move.l	mappings(a3),mappings(a1)
		move.b	render_flags(a3),render_flags(a1)
		move.w	art_tile(a3),art_tile(a1)
		move.l	height_pixels(a3),height_pixels(a1)				; set height, width and priority
		move.w	(a2)+,x_pos(a1)
		move.w	(a2)+,y_pos(a1)
		move.w	(a2)+,d0
		move.b	d0,mapping_frame(a1)
		move.b	(a4)+,tensionbridge.wait(a1)					; set wait time
		movea.w	a1,a5								; load object address to a5

		; create
		jsr	(Create_New_Object_3).w
		bne.s	.notfree
		move.l	#Obj_TensionBridge_Explosion,address(a1)			; explosion
		move.w	x_pos(a5),x_pos(a1)
		move.w	y_pos(a5),y_pos(a1)
		move.b	-1(a4),anim_frame_timer(a1)
		dbf	d6,.create

.notfree
		clr.l	x_vel(a3)
		sfx	sfx_BridgeCollapse, 1
; ---------------------------------------------------------------------------

TensionBridge_TimeData:
		dc.b 8, $10, $C, $E, 6, $A, 4, 2	; 0
		dc.b 8, $10, $C, $E, 6, $A, 4, 2	; 8
	even

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
		moveq	#tensionbridge.indexP2,d5					; set RAM address
		movem.l	d1-d4,-(sp)
		bsr.s	.check
		movem.l	(sp)+,d1-d4

.p1

		; player 1
		lea	(Player_1).w,a1							; a1=character
		moveq	#p1_standing_bit,d6
		moveq	#tensionbridge.indexP1,d5					; set RAM address

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
		lsr.w	#4,d0								; divide by $10
		move.b	d0,(a0,d5.w)
		movea.w	parent3(a0),a2							; a2=object

		; check second subsprite object
		cmpi.w	#tensionbridge.logcount,d0
		blo.s	.skip								; if bridge has more than 8 logs, check second subsprite object pieces
		movea.w	parent4(a0),a2							; a2=object
		subq.w	#tensionbridge.logcount,d0

.skip
		add.w	d0,d0								; multiply by 6
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
		lsr.w	#4,d0								; divide by $10
		move.b	d0,(a0,d5.w)

.return
		rts

; =============== S U B R O U T I N E =======================================

TensionBridge_Bend:
		move.b	tensionbridge.bend(a0),d0
		jsr	(GetSineCosine).w
		move.w	d0,d4
		lea	BridgeBendData(pc),a4

		; first block
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#4,d0								; multiply by $10
		moveq	#0,d3
		move.b	tensionbridge.indexP1(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	BridgeDepression(pc),a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3								; multiply by $10
		lea	(a4,d3.w),a3
		movea.w	parent3(a0),a1							; a1=object
		lea	next_object(a1),a2						; set end current object slot
		lea	sub2_y_pos(a1),a1

.loop
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	tensionbridge.origY(a0),d0
		move.w	d0,(a1)								; set sub_y_pos
		addq.w	#next_subspr,a1							; next subsprite
		cmpa.w	a2,a1								; is the current object slot ended?
		bne.s	.next								; if not, branch
		movea.w	parent4(a0),a1							; a1=object
		lea	sub2_y_pos(a1),a1						; load next object

.next
		dbf	d2,.loop

		; second block
		moveq	#0,d0
		move.b	subtype(a0),d0
		moveq	#1,d3
		add.b	tensionbridge.indexP1(a0),d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	.return
		move.w	d3,d2
		lsl.w	#4,d3								; multiply by $10
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2								; fix dbf
		blo.s	.return

.loop2
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	tensionbridge.origY(a0),d0
		move.w	d0,(a1)								; set sub_y_pos
		addq.w	#next_subspr,a1							; next subsprite
		cmpa.w	a2,a1								; is the current object slot ended?
		bne.s	.next2								; if not, branch
		movea.w	parent4(a0),a1							; a1=object
		lea	sub2_y_pos(a1),a1						; load next object

.next2
		dbf	d2,.loop2

.return
		rts
; ---------------------------------------------------------------------------

		; data
		incfile.b	BridgeDepression, "Objects/Environ/Bridge/Object Data/Depression.bin"
		incfile.b	BridgeBendData, "Objects/Environ/Bridge/Object Data/Bend.bin"
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Bridge/Object Data/Map - Tension Bridge.asm"
