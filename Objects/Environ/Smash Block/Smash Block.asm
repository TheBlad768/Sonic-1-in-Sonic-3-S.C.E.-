; ---------------------------------------------------------------------------
; Object 51 - smashable green block (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

; players
smashblock.p1_anim			ds.b 1						; Sonic's animation (1 byte)
smashblock.p2_anim			ds.b 1						; Tails's animation (1 byte)

; main
smashblock.bonus			ds.w 1						; bonus counter (2 bytes)
smashblock.frag_ptr			ds.l 1						; (4 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SmashBlock:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		movem.l	ObjDat_SmashBlock(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.l	#Smab_Speeds,smashblock.frag_ptr(a0)				; fragments that move
		move.b	subtype.byte(a0),mapping_frame(a0)

.solid
		move.w	(Chain_bonus_counter).w,smashblock.bonus(a0)			; copy chain bonus counter
		move.b	(Player_1+anim).w,smashblock.p1_anim(a0)			; copy Sonic's animation
		move.b	(Player_2+anim).w,smashblock.p2_anim(a0)			; copy Tails's animation

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; check standing
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	.smash								; if yes, branch

.draw
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.smash
		cmpi.b	#standing_mask,d0						; is Sonic and Tails standing on the object?
		bne.s	.checkTails							; if not, branch
		cmpi.b	#AniIDSonAni_Roll,smashblock.p1_anim(a0)			; is Sonic rolling?
		beq.s	.checkroll							; if yes, branch
		cmpi.b	#AniIDSonAni_Roll,smashblock.p2_anim(a0)			; is Tails rolling?
		bne.s	.draw								; if not, branch

.checkroll
		lea	(Player_1).w,a1							; a1=character
		move.b	smashblock.p1_anim(a0),d0
		bsr.s	.checkroll2
		lea	(Player_2).w,a1							; a1=character
		move.b	smashblock.p2_anim(a0),d0
		bsr.s	.checkroll2
		bra.s	.getbonus
; ---------------------------------------------------------------------------

.checkTails
		move.b	d0,d1
		andi.b	#p1_standing,d1
		beq.s	.getbonus2
		cmpi.b	#AniIDSonAni_Roll,smashblock.p1_anim(a0)			; is Tails rolling?
		bne.s	.draw								; if not, branch
		lea	(Player_1).w,a1							; a1=character
		bsr.s	.setroll
		bra.s	.getbonus

; =============== S U B R O U T I N E =======================================

.checkroll2
		cmpi.b	#AniIDSonAni_Roll,d0
		bne.s	.notroll

.setroll
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
		cmpi.b	#AniIDSonAni_Roll,smashblock.p2_anim(a0)
		bne.w	.draw
		lea	(Player_2).w,a1							; a1=character
		bsr.s	.setroll

.getbonus
		move.w	smashblock.bonus(a0),(Chain_bonus_counter).w
		andi.b	#~(standing_mask)&$FF,status(a0)
		movea.l	smashblock.frag_ptr(a0),a4					; use fragments that move
		addq.b	#1,mapping_frame(a0)
		move.l	#.fall,code_addr(a0)
		jsr	(BreakObjectToPieces).l

		; draw score
		lea	(Child6_EnemyScore).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.fall
		move.w	(Chain_bonus_counter).w,d2					; get copy of chain bonus counter
		addq.w	#2,(Chain_bonus_counter).w					; add 2 to item bonus counter
		cmpi.w	#(Enemy_Points_end-Enemy_Points)-2,d2				; has the counter already surpassed 5?
		blo.s	.notreachedlimit						; if not, branch
		moveq	#(Enemy_Points_end-Enemy_Points)-2,d2				; cap counter at 6

.notreachedlimit
		lea	(Enemy_Points).l,a2
		moveq	#0,d0								; clear d0 for HUD_AddToScore
		move.w	(a2,d2.w),d0							; get appropriate number of points
		cmpi.w	#16*2,(Chain_bonus_counter).w					; have 16 enemies been destroyed?
		blo.s	.notreachedlimit2						; if not, branch
		move.w	#1000,d0							; fix bonus to 10000 points
		moveq	#10,d2

.notreachedlimit2
		jsr	(HUD_AddToScore).w
		lsr.w	d2								; division by 2
		move.b	d2,mapping_frame(a1)

.fall
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.delete								; if not, branch

		MoveSprite , $18							; make obj fall

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

Smab_Speeds:

		; x-speed, y-speed
		dc.w -$200, -$200
		dc.w  $200, -$200
		dc.w -$100, -$100
		dc.w  $100, -$100

; =============== S U B R O U T I N E =======================================

; init
ObjDat_SmashBlock:	subObjMainData Obj_SmashBlock.solid, setBit(render_flags.level), 0, 32, 32, 5, $562, 2, FALSE, Map_SmashBlock
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Smash Block/Object Data/Map - Smash Block.asm"
