; ---------------------------------------------------------------------------
; Object 51 - smashable green block (MZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SmashBlock:

		; init
		movem.l	ObjDat_SmashBlock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.l	#Smab_Speeds,objoff_3C(a0)
		move.b	subtype(a0),mapping_frame(a0)

.solid
		move.w	(Chain_bonus_counter).w,objoff_38(a0)
		move.b	(Player_1+anim).w,objoff_34(a0)
		move.b	(Player_2+anim).w,objoff_36(a0)
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		moveq	#standing_mask,d0
		and.b	status(a0),d0
		bne.s	.smash

.draw
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.smash
		cmpi.b	#standing_mask,d0						; is Sonic and Tails standing on the object?
		bne.s	.checkroll2							; if not, branch
		cmpi.b	#AniIDSonAni_Roll,objoff_34(a0)					; check player 1
		beq.s	.checkroll
		cmpi.b	#AniIDSonAni_Roll,objoff_36(a0)					; check player 2
		bne.s	.draw

.checkroll
		lea	(Player_1).w,a1							; a1=character
		move.b	objoff_34(a0),d0
		bsr.s	.Sonicroll
		lea	(Player_2).w,a1							; a1=character
		move.b	objoff_36(a0),d0
		bsr.s	.Sonicroll
		bra.s	.getbonus
; ---------------------------------------------------------------------------

.checkroll2
		move.b	d0,d1
		andi.b	#p1_standing,d1
		beq.s	.getbonus2
		cmpi.b	#AniIDSonAni_Roll,objoff_34(a0)
		bne.s	.draw
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.Tailsroll
		bra.s	.getbonus

; =============== S U B R O U T I N E =======================================

.Sonicroll
		cmpi.b	#AniIDSonAni_Roll,d0
		bne.s	.notroll

.Tailsroll
		bset	#status.player.rolling,status(a1)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a1)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a1)
		move.w	#-$300,y_vel(a1)

.notroll
		bset	#status.player.in_air,status(a1)
		bclr	#status.player.on_object,status(a1)
		move.b	#PlayerID_Control,routine(a1)
		rts

; =============== S U B R O U T I N E =======================================

.getbonus2
		andi.b	#p2_standing,d0
		beq.s	.draw
		cmpi.b	#AniIDSonAni_Roll,objoff_36(a0)
		bne.w	.draw
		lea	(Player_2).w,a1							; a1=character
		bsr.s	.Tailsroll

.getbonus
		move.w	objoff_38(a0),(Chain_bonus_counter).w
		andi.b	#~(standing_mask)&$FF,status(a0)
		movea.l	objoff_3C(a0),a4						; Smab_Speeds
		addq.b	#1,mapping_frame(a0)
		move.l	#.fall,address(a0)
		jsr	(BreakObjectToPieces).l

		; draw score
		lea	(Child6_EndSignScore).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fall
		move.w	(Chain_bonus_counter).w,d2
		addq.w	#2,(Chain_bonus_counter).w					; add 2 to item bonus counter
		cmpi.w	#6,d2
		blo.s	.notreachedlimit
		moveq	#6,d2								; max bonus is lvl6

.notreachedlimit
		lea	(Enemy_Points).l,a2
		moveq	#0,d0
		move.w	(a2,d2.w),d0
		cmpi.w	#16*2,(Chain_bonus_counter).w					; have 16 enemies been destroyed?
		blo.s	.notreachedlimit2						; if not, branch
		move.w	#1000,d0							; fix bonus to 10000
		moveq	#10,d2

.notreachedlimit2
		jsr	(HUD_AddToScore).w
		lsr.w	d2								; division by 2
		move.b	d2,mapping_frame(a1)

.fall
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.delete								; if not, branch

		MoveSprite a0, $18							; make obj fall

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

Smab_Speeds:

		; x-speed, y-speed
		dc.w -$200, -$200
		dc.w  $200, -$200
		dc.w -$100, -$100
		dc.w  $100, -$100

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_SmashBlock:	subObjMainData Obj_SmashBlock.solid, setBit(render_flags.level), 0, 32, 32, 5, $562, 2, 0, Map_Smab
; ---------------------------------------------------------------------------

		include "Objects/Environ/Smash Block/Object Data/Map - Smash Block.asm"
