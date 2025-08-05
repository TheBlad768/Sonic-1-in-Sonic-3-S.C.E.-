; ---------------------------------------------------------------------------
; Object 4C - lava geyser / lavafall producer (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
gmake_timer			= objoff_32 ; current time remaining (2 bytes)
gmake_time			= objoff_34 ; time delay (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_GeyserMaker:

		; init
		lea	ObjDat_GeyserMaker(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.w	#2*60,gmake_time(a0)						; set time delay to 2 seconds
		move.l	#.wait,address(a0)

.wait
		subq.w	#1,gmake_timer(a0)						; decrement timer
		bpl.s	.cancel								; if time remains, branch
		move.w	gmake_time(a0),gmake_timer(a0)					; reset timer

		; find Sonic
		move.w	(Player_1+y_pos).w,d0
		move.w	y_pos(a0),d1
		cmp.w	d1,d0
		bhs.s	.cancel
		subi.w	#$170,d1
		cmp.w	d1,d0
		blo.s	.cancel
		move.l	#.chktype,address(a0)						; if Sonic is within range, goto GMake_ChkType

.cancel
		bra.s	.range
; ---------------------------------------------------------------------------

.chktype
		move.l	#.checkanim,address(a0)
		tst.b	subtype(a0)							; is object type 00 (geyser) ?
		beq.s	.draw								; if yes, branch
		move.l	#.makelava,address(a0)
		bra.s	.range
; ---------------------------------------------------------------------------

.checkanim
		tst.b	routine(a0)
		beq.s	.draw
		clr.b	routine(a0)

.makelava
		move.l	#.checkdelete,address(a0)
		lea	Child6_LavaGeyser(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail
		move.b	subtype(a0),subtype(a1)

.fail
		move.b	#1,anim(a0)							; bubble2 anim
		tst.b	subtype(a0)							; is object type 0 (geyser) ?
		beq.s	.isgeyser							; if yes, branch
		move.b	#4,anim(a0)							; null frame
		bra.s	.draw
; ---------------------------------------------------------------------------

.isgeyser
		movea.w	parent3(a0),a1							; a1=parent object (pushable blocks)
		bset	#status.npc.y_flip,status(a1)					; set geyser flag
		move.w	#-$580,y_vel(a1)

.checkdelete
		tst.b	routine(a0)
		beq.s	.draw
		clr.b	routine(a0)
		move.l	#.delete,address(a0)

.range
		jmp	(Delete_Sprite_If_Not_In_Range_Check).w
; ---------------------------------------------------------------------------

.draw
		lea	Ani_Geyser(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDelete).w
; ---------------------------------------------------------------------------

.delete
		clr.b	anim(a0)							; bubble1 anim
		move.l	#.wait,address(a0)
		tst.b	subtype(a0)
		bne.s	.range
		jmp	(Sprite_CheckDelete.offscreen).w				; Delete_Sprite_If_Not_In_RangeCheck.offscreen

; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
lgeyser_ypos			= objoff_30

; =============== S U B R O U T I N E =======================================

Geyser_Speeds:	dc.w -$500, 0
; ---------------------------------------------------------------------------

Obj_LavaGeyser:

		; get y velocity
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	Geyser_Speeds(pc,d0.w),y_vel(a0)

		; init
		lea	ObjDat_LavaGeyser(pc),a1
		jsr	(SetUp_ObjAttributes).w
;		sfx	sfx_Burning							; play flame sound
		move.l	#.action,address(a0)

		move.w	y_pos(a0),lgeyser_ypos(a0)
		move.b	#5,anim(a0)							; bubble4 anim
		tst.b	subtype(a0)
		beq.s	.isgeyser
		move.b	#2,anim(a0)							; end anim
		subi.w	#$250,y_pos(a0)

.isgeyser
		lea	Child6_LavaGeyser_Extra(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail
		move.b	subtype(a0),subtype(a1)
		addi.w	#$60,y_pos(a1)
		move.w	lgeyser_ypos(a0),lgeyser_ypos(a1)
		addi.w	#$60,lgeyser_ypos(a1)
		move.b	#5,anim(a1)							; bubble4 anim
		tst.b	subtype(a0)
		beq.s	.fail
		move.b	#2,anim(a1)							; end anim

.fail
		tst.b	subtype(a0)
		beq.s	.action
		lea	Child6_LavaGeyser_Extra2(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fail2
		move.b	subtype(a0),subtype(a1)
		bset	#flip_bit_y,art_tile(a1)					; flipy
		addi.w	#$100,y_pos(a1)
		move.w	lgeyser_ypos(a0),lgeyser_ypos(a1)
		move.w	parent3(a0),parent3(a1)
		move.b	#5,anim(a1)							; bubble4 anim
		tst.b	subtype(a0)
		beq.s	.fail2
		move.b	#2,anim(a1)							; end anim

.fail2
		clr.b	subtype(a0)

.action
		moveq	#7,d0								; read only the 1st digit
		and.b	subtype(a0),d0							; get object type
		add.w	d0,d0
		jsr	.index(pc,d0.w)
		MoveSprite2YOnly a0
		lea	Ani_Geyser(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

.index
		bra.s	.type00								; 0
; ---------------------------------------------------------------------------

		; type01								; 1
		addi.w	#$18,y_vel(a0)							; increase object's falling speed
		move.w	lgeyser_ypos(a0),d0
		cmp.w	y_pos(a0),d0
		bhs.s	.return
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	#1,anim(a1)							; bubble2 anim
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.type00
		addi.w	#$18,y_vel(a0)							; increase object's falling speed
		move.w	lgeyser_ypos(a0),d0
		cmp.w	y_pos(a0),d0
		bhs.s	.return
		movea.w	parent3(a0),a1							; a1=parent object
		move.b	#3,anim(a1)							; bubble3 anim
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ) (Extra2)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_LavaGeyser_Extra2:

		; init
		lea	ObjDat3_LavaGeyser2(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#Obj_LavaGeyser.action,address(a0)
		bra.s	Obj_LavaGeyser.action

; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ) (Extra)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_LavaGeyser_Extra:

		; init
		lea	ObjDat3_LavaGeyser(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		move.l	#.loc_EFFC,address(a0)

.loc_EFFC
		movea.w	parent3(a0),a1							; a1=parent object
		moveq	#$60,d0
		add.w	y_pos(a1),d0
		move.w	d0,y_pos(a0)
		sub.w	lgeyser_ypos(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	.loc_F026
		moveq	#$B,d1

.loc_F026
		cmpi.w	#$80,d0
		ble.s	.loc_F02E
		moveq	#$E,d1

.loc_F02E

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.loc_F04C							; if time remains, branch
		addq.b	#7+1,anim_frame_timer(a0)					; reset timer to 7 frames

		; next
		bchg	#0,anim_frame(a0)						; chg 0 or 1
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.loc_F04C							; if not, branch
		sfx	sfx_LavaFall

.loc_F04C
		move.b	anim_frame(a0),d0
		add.b	d1,d0
		move.b	d0,mapping_frame(a0)
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_GeyserMaker:		subObjData Map_Geyser, $36D, 3, 1, 112, 112, 1, 0, 0
ObjDat_LavaGeyser:		subObjData Map_Geyser, $36D, 3, 0, 64, 64, 1, 0, 0
ObjDat3_LavaGeyser:		subObjData FALSE, FALSE, 0, 0, 256, 64, 1, 0, $13|collision_flags.npc.hurt
ObjDat3_LavaGeyser2:		subObjData FALSE, FALSE, 0, 0, 64, 64, 0, 0, 0

Child6_LavaGeyser:
		dc.w 1-1
		dc.l Obj_LavaGeyser
Child6_LavaGeyser_Extra:
		dc.w 1-1
		dc.l Obj_LavaGeyser_Extra
Child6_LavaGeyser_Extra2:
		dc.w 1-1
		dc.l Obj_LavaGeyser_Extra2
; ---------------------------------------------------------------------------

		include "Objects/Environ/Lava Geyser/Object Data/Anim - Lava Geyser.asm"
		include "Objects/Environ/Lava Geyser/Object Data/Map - Lava Geyser.asm"
