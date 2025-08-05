; ---------------------------------------------------------------------------
; Object 4B - big ring for entry to special stage
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BigRing:

		; wait
		jsr	(Obj_WaitOffscreen).w						; don't start anything until the ring is explicitly onscreen

		; init
		lea	ObjSlot_BigRing(pc),a1
		jsr	(SetUp_ObjAttributesSlotted).w					; only one special stage ring can be loaded at one time, period
		move.l	#.main,address(a0)
		move.l	#AniRaw_BigRing,objoff_30(a0)

		; check
		tst.b	subtype(a0)
		bpl.s	.main								; if positive, then ALWAYS make this a normal Emerald ring

		; set cycle
		bset	#6,objoff_38(a0)						; make this a Super Emerald ring
		lea	PalSPtr_BigRing(pc),a1
		lea	(Palette_rotation_data).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		lea	PalSPtr_BigRing2(pc),a1
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		clr.w	(a2)								; set up the palette script pointers

.main
		jsr	(Animate_Raw).w

		; check
		tst.w	(Debug_placement_mode).w
		bne.s	.draw								; if in debug mode, don't allow collision
		cmpi.b	#8,mapping_frame(a0)
		blo.s	.draw								; if ring hasn't finished forming, don't allow collision

		; check range
		lea	BigRing_Range(pc),a1
		jsr	(Check_PlayerInRange).w
		tst.w	d0
		bne.s	.check

.draw
		bra.w	BigRing_Display
; ---------------------------------------------------------------------------

.check

		; check player death
		lea	(Player_1).w,a1							; if collision was made
		cmpi.b	#PlayerID_Death,routine(a1)
		bhs.s	.draw								; if player has died for whatever reason, don't do anything
		sfx	sfx_BigRing							; play the ring swish sound

		; check
		bra.s	.alt

;		tst.b	subtype(a0)
;		bmi.s	.alt

		; check emeralds
		cmpi.b	#7,(Chaos_emerald_count).w
		beq.s	.alt								; if chaos emeralds are collected, branch

		; next
		move.l	#BigRing_Animate,address(a0)

		; p1
		lea	(Player_1).w,a1
		st	(Player_prev_frame).w						; make the player disappear and lock input
		clr.b	mapping_frame(a1)
		move.b	#AniIDSonAni_Blank,anim(a1)
		move.b	#$53,object_control(a1)

		; check fly
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	.create
		clr.w	(Flying_carrying_Sonic_flag).w

		; p2
		lea	(Player_2).w,a1
		tst.l	address(a1)							; is the player RAM empty?
		beq.s	.create								; if yes, branch
		st	(Player_prev_frame_P2).w
		clr.b	mapping_frame(a1)
		move.b	#AniIDSonAni_Blank,anim(a1)
		move.b	#$53,object_control(a1)						; lock both players, etc

.create

		; create flash
		jsr	(Create_New_Sprite).w
		bne.s	BigRing_Display
		move.l	#Obj_BigRing_Flash,address(a1)
		move.w	a0,parent3(a1)							; set ring as parent

		; next
		bra.s	BigRing_Display
; ---------------------------------------------------------------------------

.alt
		sfx	sfx_BigRing
		bset	#5,objoff_38(a0)						; set delete
		moveq	#50,d0								; add 50 rings
		jsr	(AddRings).w

		; next
		bra.s	BigRing_Display
; ---------------------------------------------------------------------------

BigRing_Animate:
		jsr	(Animate_Raw).w

; =============== S U B R O U T I N E =======================================

BigRing_Display:

		; check
		btst	#5,objoff_38(a0)
		bne.s	.delete
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.offscreen							; if not, branch
		btst	#6,objoff_38(a0)						; is Super Emerald ring?
		beq.s	.draw								; if not, branch
		jsr	(Run_PalRotationScript).w					; only run the rotation script if this is a Super Emerald ring

.draw
		lea	DPLCPtr_BigRing(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen
		out_of_xrange.s	.delete							; if off-screen
		out_of_yrange.s	.delete							; jump below when far enough off-screen

		; set
		move.l	#$00440088,(Normal_palette_line_2+$A).w
		move.w	#$EE,(Normal_palette_line_2+$E).w

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete

		; set
		move.l	#$00440088,(Normal_palette_line_2+$A).w
		move.w	#$EE,(Normal_palette_line_2+$E).w				; restore the part of the palette that was changed

		; restore explosion art
		QueueKosPlusModule	ArtKosPM_Explosion, ArtTile_Explosion		; restore the overwritten badnik explosion art

		; delete
		jmp	(Go_Delete_SpriteSlotted).w

; ---------------------------------------------------------------------------
; Big Ring (Flash)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BigRing_Flash:

		; init
		lea	ObjSlot_BigRingFlash(pc),a1
		jsr	(SetUp_ObjAttributesSlotted).w
		move.l	#.main,address(a0)
		move.l	#.finished,objoff_34(a0)
		move.l	#AniRaw_BigRingFlash,objoff_30(a0)

		; copy
		movea.w	parent3(a0),a1							; a1=parent object
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	subtype(a1),subtype(a0)						; copy positional data from parent ring

		; check
		move.w	(Player_1+x_pos).w,d0
		cmp.w	x_pos(a0),d0
		blo.s	.draw
		bset	#render_flags.x_flip,render_flags(a1)				; set direction based on where player approached
		bra.s	.draw
; ---------------------------------------------------------------------------

.main
		move.b	mapping_frame(a0),d6
		jsr	(Animate_RawAdjustFlipX).w
		cmp.b	mapping_frame(a0),d6
		beq.s	.draw
		cmpi.b	#3,anim_frame(a0)
		bne.s	.draw
		movea.w	parent3(a0),a1							; set parent to be deleted in the middle of the animation
		bset	#5,objoff_38(a1)

.draw
		lea	DPLCPtr_BigRingFlash(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.finished
		move.l	#Obj_Wait,address(a0)						; this is performed when animation is finished
		move.w	#$20,objoff_2E(a0)
		move.l	#.goSS,objoff_34(a0)
		rts
; ---------------------------------------------------------------------------

.goSS
		sfx	sfx_EnterSS							; play the special stage entry sound (you know the one)

		; takes 50 rings from the player
		moveq	#50,d0
		move.w	(Ring_count).w,d1
		sub.w	d0,d1								; subtract 50 rings
		bhs.s	.setrings							; if the player has rings left, branch
		moveq	#0,d1								; set 0 rings

.setrings
		move.w	d1,(Saved_ring_count).w

		; calc rings bonus
		add.w	d0,d0								; multiply by 10
		move.w	d0,d1
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d0								; set 5000 rings score

		; add to the score
		move.l	(Score).w,d1							; get current score
		add.l	d0,d1								; add d0*10 to the score
		move.l	#999999,d0							; 9999990 maximum points
		cmp.l	d1,d0								; is score below 999999?
		bhi.s	.sset								; if yes, branch
		move.l	d0,d1								; reset score to 999999

.sset
		move.l	d1,(Score).w							; save score

		; check bonus
		cmp.l	(Next_extra_life_score).w,d1					; if score is greater than next 50000 point increment
		blo.s	.fset
		addi.l	#5000,(Next_extra_life_score).w					; set next 50000
		addq.b	#1,(Life_count).w						; give an additional extra life

.fset
		move.b	(Extra_life_flags).w,(Saved_extra_life_flags).w

		; load special stage
		addq.w	#4*2,sp								; exit from object and current screen
		move.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; set screen mode to Special Stage
		move.b	#1,(Special_bonus_entry_flag).w					; set special stage flag

		; set status
		moveq	#signextendB( \
			setBit(status_secondary.shield) | \
			setBit(status_secondary.fire_shield) | \
			setBit(status_secondary.lightning_shield) | \
			setBit(status_secondary.bubble_shield) \
		),d0

		and.b	(Player_1+status_secondary).w,d0
		move.b	d0,(Saved2_status_secondary).w
		st	(Respawn_table_keep).w
		jsr	(Save_Level_Data2).l
		jsr	(Clear_SpriteRingMem).w

		; delete
		jmp	(Go_Delete_SpriteSlotted2).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjSlot_BigRing:		subObjSlotData 1-1, ArtTile_Explosion, 1, 0, $40, 4, Map_BigRing, 64, 64, 5, 0, 0
ObjSlot_BigRingFlash:		subObjSlotData 1-1, ArtTile_Player_1, 1, 0, $18, 6, Map_BigRingFlash, 64, 64, 4, 0, 0

; dplc
DPLCPtr_BigRing:		dc.l dmaSource(ArtUnc_BigRing), DPLC_BigRing
DPLCPtr_BigRingFlash:		dc.l dmaSource(ArtUnc_BigRingFlash), DPLC_BigRingFlash

AniRaw_BigRing:			dc.b 4, 0, 0, 1, 2, 3, 4, 5, 6, 7, arfChange, $C, 6, $A, 9, 8, $B, arfEnd
AniRaw_BigRingFlash:		dc.b 0, 0, 0, 1, 2, 3|$40, 3, 2, 1, 0, arfJump
	even

BigRing_Range:
		dc.w -24, 48	; xpos (24x24)
		dc.w -40, 80	; ypos (40x40)
; ---------------------------------------------------------------------------

		include "Objects/Main/Big Ring/Object Data/Palette Script - Big Ring.asm"
		include "Objects/Main/Big Ring/Object Data/Map - Big Ring.asm"
		include "Objects/Main/Big Ring/Object Data/DPLC - Big Ring.asm"
		include "Objects/Main/Big Ring/Object Data/Map - Big Ring Flash.asm"
		include "Objects/Main/Big Ring/Object Data/DPLC - Big Ring Flash.asm"
