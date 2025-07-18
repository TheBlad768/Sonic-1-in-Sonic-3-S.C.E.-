; ---------------------------------------------------------------------------
; Object 84 - cylinder Eggman hides in (FZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
obBFZEC_Enable				= objoff_2D	; .b ; move cylinder
obBFZEC_Timer				= objoff_2E	; .w
obBFZEC_OrigY				= objoff_30	; .l ; original y-axis position
obBFZEC_YVel				= objoff_34	; .l
obBFZEC_Grab				= objoff_3C	; .b ; grab Eggman

; =============== S U B R O U T I N E =======================================

Obj_EggmanCylinder:

		; get boss data
		moveq	#0,d0
		lea	(Boss_events).w,a2
		lea	EggmanCylinder_PosData(pc),a1
		move.b	subtype(a0),d0
		adda.w	d0,a2
		move.w	a0,(a2)								; save cylinder address for boss
		add.w	d0,d0
		adda.w	d0,a1

		; get xypos
		move.w	(Camera_max_X_pos).w,d0
		add.w	(a1)+,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_min_Y_pos).w,d0
		add.w	(a1),d0
		move.w	d0,y_pos(a0)
		move.w	d0,obBFZEC_OrigY(a0)						; backup ypos

		; init
		lea	ObjDat_BossCylinder(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#status.npc.no_balancing,status(a0)				; disable player's balance animation
		move.w	#bytes_to_word(64/2,128/2),objoff_3A(a0)			; set explosion radius
		move.l	#.main,address(a0)

		; check flipy
		cmpi.b	#2,subtype(a0)
		ble.s	.main
		bset	#render_flags.y_flip,render_flags(a0)				; 4 and 6 only (flipy sprite)

.main
		clr.l	obBFZEC_YVel(a0)
		tst.b	obBFZEC_Enable(a0)
		beq.s	.move
		move.l	#EggmanCylinder_Movement,address(a0)

.move
		move.l	obBFZEC_YVel(a0),d0
		move.l	obBFZEC_OrigY(a0),d1						; saved y_pos
		add.l	d0,d1
		swap	d1
		move.w	d1,y_pos(a0)

		; check
		cmpi.l	#EggmanCylinder_Movement,address(a0)				; check "EggmanCylinder_Movement"
		bne.s	.solid
		tst.b	obBFZEC_Grab(a0)						; check Eggman flag
		beq.s	.solid

		; load address
		movea.w	parent3(a0),a1							; load Eggman address
		moveq	#-10,d0								; 0 and 2 (down pos)
		cmpi.b	#2,subtype(a0)
		ble.s	.downcyl
		moveq	#14,d0								; 4 and 6 (up pos)

.downcyl
		add.w	d0,d1
		move.w	d1,y_pos(a1)							; grab Eggman (ypos)
		move.w	x_pos(a0),x_pos(a1)						; grab Eggman (xpos)

.solid

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; fix Knuckles getting stuck
		swap	d6
		andi.w	#p1_touch_bottom,d6						; Knuckles touch bottom?
		beq.s	.fset								; if not, branch

		; check Knuckles
		lea	(Player_1).w,a1							; a1=character
		cmpi.b	#PlayerID_Knuckles,character_id(a1)				; is player Knuckles?
		bne.s	.fset								; if not, return
		cmpi.b	#1,double_jump_flag(a1)						; is Knuckles gliding?
		bne.s	.fset								; if not, return
		clr.b	double_jump_flag(a1)						; make him stop gliding
		move.b	#AniIDSonAni_Roll,anim(a1)					; put Knuckles in his roll animation
		move.w	#bytes_to_word(28/2,14/2),y_radius(a1)				; set y_radius and x_radius

.fset

		; set frame
		moveq	#0,d0								; frame #0
		moveq	#$27,d2
		move.w	obBFZEC_YVel(a0),d1
		bpl.s	.abs
		neg.w	d1								; absolute
		moveq	#8,d2

.abs
		sub.w	d2,d1
		blo.s	.setframe
		addq.b	#1,d0								; add frame
		asr.w	#4,d1
		add.w	d1,d0

.setframe
		move.b	d0,mapping_frame(a0)

		; check draw
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

EggmanCylinder_Movement:

		; set jmp
		lea	.moveup(pc),a1							; move up
		cmpi.b	#2,subtype(a0)
		ble.s	.downcyl
		lea	.movedown(pc),a1						; move down

.downcyl
		jsr	(a1)

		; return
		bra.w	Obj_EggmanCylinder.move
; ---------------------------------------------------------------------------

.moveup

		; check boss defeated
		movea.w	parent3(a0),a1							; load Eggman address
		btst	#status.npc.defeated,status(a1)
		beq.s	.movechkup

		; create explosions
		subq.b	#1,objoff_39(a0)
		bpl.s	.movechkup
		move.b	#3,objoff_39(a0)
		jsr	(sub_83E84).l

.movechkup
		tst.b	obBFZEC_Enable(a0)						; 0 and 2
		bne.s	.enabledup

		; check boss defeated
		movea.w	parent3(a0),a1							; load Eggman address
		btst	#status.npc.defeated,status(a1)
		beq.s	.notdefeatedup
		subq.w	#1,obBFZEC_YVel(a0)

.notdefeatedup
		addq.w	#2,obBFZEC_YVel(a0)
		bhs.s	.returnup
		clr.l	obBFZEC_YVel(a0)
		move.l	#Obj_EggmanCylinder.main,address(a0)

		; load Eggman address
		movea.w	parent3(a0),a1
		subq.b	#1,obBFZ_Count(a1)

.returnup
		rts
; ---------------------------------------------------------------------------

.enabledup

		; enabled
		cmpi.w	#-$10,obBFZEC_YVel(a0)
		bge.s	.skipup
		subi.l	#$28000,obBFZEC_YVel(a0)

.skipup
		subi.l	#$8000,obBFZEC_YVel(a0)
		cmpi.w	#-$A0,obBFZEC_YVel(a0)
		bgt.s	.returnup2
		clr.w	obBFZEC_YVel+2(a0)
		move.w	#-$A0,obBFZEC_YVel(a0)

		; disable
		clr.b	obBFZEC_Enable(a0)
		move.w	#$14,(Screen_shaking_flag).w

.returnup2
		rts
; ---------------------------------------------------------------------------

.movedown

		; check boss defeated
		movea.w	parent3(a0),a1							; load Eggman address
		btst	#status.npc.defeated,status(a1)
		beq.s	.movechkdown

		; create explosions
		subq.b	#1,objoff_39(a0)
		bpl.s	.movechkdown
		move.b	#3,objoff_39(a0)
		jsr	(sub_83E84).l

.movechkdown
		tst.b	obBFZEC_Enable(a0)						; 4 and 6
		bne.s	.enableddown

		; check boss defeated
		movea.w	parent3(a0),a1							; load Eggman address
		btst	#status.npc.defeated,status(a1)
		beq.s	.notdefeateddown
		addq.w	#1,obBFZEC_YVel(a0)

.notdefeateddown
		subq.w	#2,obBFZEC_YVel(a0)
		bhs.s	.returndown
		clr.l	obBFZEC_YVel(a0)
		move.l	#Obj_EggmanCylinder.main,address(a0)

		; load Eggman address
		movea.w	parent3(a0),a1
		subq.b	#1,obBFZ_Count(a1)

.returndown
		rts
; ---------------------------------------------------------------------------

.enableddown

		; enabled
		cmpi.w	#$10,obBFZEC_YVel(a0)
		blt.s	.skipdown
		addi.l	#$28000,obBFZEC_YVel(a0)

.skipdown
		addi.l	#$8000,obBFZEC_YVel(a0)
		cmpi.w	#$A0,obBFZEC_YVel(a0)
		blt.s	.returndown2
		clr.w	obBFZEC_YVel+2(a0)
		move.w	#$A0,obBFZEC_YVel(a0)

		; disable
		clr.b	obBFZEC_Enable(a0)
		move.w	#$14,(Screen_shaking_flag).w

.returndown2
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BossCylinder:		subObjData Map_EggCyl, $300, 0, 0, 192, 64, 3, 0, 0

Child6_EggmanCylinder:
		dc.w 4-1
		dc.l Obj_EggmanCylinder

EggmanCylinder_PosData:			; $2660 (xcam main), $510 (ycam main)
		dc.w $70, $110		; 0 (down pos)
		dc.w $F0, $110		; 4 (down pos)
		dc.w $30, -$50		; 8 (up pos)
		dc.w $B0, -$50		; C (up pos)
; ---------------------------------------------------------------------------

		include "Objects/Bosses/FZ/Object Data/Map - Cylinders.asm"
