; ---------------------------------------------------------------------------
; Object 5F - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
bom_time			= objoff_3C ; time of fuse
bom_origY			= objoff_32 ; original y-axis position

; =============== S U B R O U T I N E =======================================

Obj_BombBadnik:

		; init
		lea	ObjDat_Bomb(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bchg	#status.npc.x_flip,status(a0)
		move.l	#.action,address(a0)
		move.l	#.walk,objoff_34(a0)

.action
		jsr	(Obj_Wait).w
		lea	Ani_Bomb(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.walk
		bsr.s	.chksonic
		subq.w	#1,bom_time(a0)							; subtract 1 from time delay
		bpl.s	.noflip								; if time remains, branch
		move.l	#.wait,objoff_34(a0)
		move.w	#((25*60)+36)-1,bom_time(a0)					; set time delay to 25 seconds
		move.w	#$10,x_vel(a0)
		move.b	#1,anim(a0)							; use walking animation
		bchg	#status.npc.x_flip,status(a0)
		beq.s	.noflip
		neg.w	x_vel(a0)							; change direction

.noflip
		rts
; ---------------------------------------------------------------------------

.wait
		bsr.s	.chksonic
		subq.w	#1,bom_time(a0)							; subtract 1 from time delay
		bmi.s	.stopwalking							; if time expires, branch
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

.stopwalking
		move.l	#.walk,objoff_34(a0)
		move.w	#180-1,bom_time(a0)						; set time delay to 3 seconds
		clr.w	x_vel(a0)							; stop walking
		clr.b	anim(a0)							; use waiting animation
		rts
; ---------------------------------------------------------------------------

.chksonic
		jsr	(Find_SonicTails).w
		moveq	#96,d0
		cmp.w	d0,d2								; is Sonic within $60 pixels of orbinaut?
		bhs.s	.outofrange							; if not, branch
		cmp.w	d0,d3								; is Sonic within $60 pixels of orbinaut?
		bhs.s	.outofrange							; if not, branch
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.outofrange							; if yes, branch

		; set explode
		move.l	#.explode,objoff_34(a0)						; goto .explode next
		move.w	#143,bom_time(a0)						; set fuse time
		clr.w	x_vel(a0)
		move.b	#2,anim(a0)							; use activated animation

		; create fuse object
		lea	Child6_BombBadnik_Fuse(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.outofrange
		move.w	y_pos(a0),bom_origY(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	bom_time(a0),bom_time(a1)					; set fuse time
		move.w	#$10,y_vel(a1)
		btst	#status.npc.y_flip,status(a0)					; is bomb upside-down?
		beq.s	.outofrange							; if not, branch
		neg.w	y_vel(a1)							; reverse direction for fuse

.outofrange
		rts
; ---------------------------------------------------------------------------

.explode
		subq.w	#1,bom_time(a0)							; subtract 1 from time delay
		bpl.s	.noexplode							; if time remains, branch

		; remove
		bset	#status.npc.defeated,status(a0)
		move.l	#Obj_Explosion.skipanimal,address(a0)				; change object to explosion

.noexplode
		rts

; ---------------------------------------------------------------------------
; Object 5F - walking bomb enemy (fuse)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BombBadnik_Fuse:

		; init
		lea	ObjDat3_Bomb_Fuse(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#.action,address(a0)

.action
		bsr.s	.wait

		; animate
		moveq	#8,d0
		btst	#2,(V_int_run_count+3).w					; 0 or 4
		beq.s	.setframe
		addq.b	#1,d0

.setframe
		move.b	d0,mapping_frame(a0)
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,bom_time(a0)
		bmi.s	.create
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

.create
		clr.w	bom_time(a0)
		move.w	bom_origY(a0),y_pos(a0)

		; create shrapnel objects
		lea	Child6_BombBadnik_Shrapnel(pc),a2
		jsr	(CreateChild6_Simple).w

		; delete
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Object 5F - walking bomb enemy (shrapnel)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Bom_ShrSpeed:				; xyvel
		dc.w -$200, -$300	; 0
		dc.w -$100, -$200	; 4
		dc.w $200, -$300	; 8
		dc.w $100, -$200	; C
; ---------------------------------------------------------------------------

Obj_BombBadnik_Shrapnel:

		; set xyvel
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.l	Bom_ShrSpeed(pc,d0.w),x_vel(a0)

		; init
		lea	ObjDat3_Bomb_Shrapnel(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#shield_reaction.all_shields,shield_reaction(a0)		; bounce off all shields
		move.l	#.action,address(a0)
		bset	#render_flags.on_screen,render_flags(a0)

.action
		MoveSprite a0, $18							; make obj fall

		; animate
		moveq	#$A,d0
		btst	#2,(V_int_run_count+3).w					; 0 or 4
		beq.s	.setframe
		addq.b	#1,d0

.setframe
		move.b	d0,mapping_frame(a0)
		jmp	(Sprite_CheckDeleteTouchXY).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Bomb:			subObjData Map_Bomb, $500, 0, 0, 40, 24, 3, 0, $1A|collision_flags.npc.hurt
ObjDat3_Bomb_Fuse:		subObjData FALSE, FALSE, 0, 0, 16, 8, 3, 8, 0
ObjDat3_Bomb_Shrapnel:		subObjData FALSE, FALSE, 0, 0, 8, 8, 3, $A, $18|collision_flags.npc.hurt

Child6_BombBadnik_Fuse:
		dc.w 1-1
		dc.l Obj_BombBadnik_Fuse
Child6_BombBadnik_Shrapnel:
		dc.w 4-1
		dc.l Obj_BombBadnik_Shrapnel
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Bomb/Object Data/Anim - Bomb.asm"
		include "Objects/Enemies/Bomb/Object Data/Map - Bomb.asm"
