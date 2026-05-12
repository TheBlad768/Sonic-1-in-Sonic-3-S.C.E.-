; ---------------------------------------------------------------------------
; Object 82 - Eggman (SBZ2)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset count									; pretend we're in the RAM

scrapeggman.block			ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_ScrapEggman:

		; set control desk palette
		lea	(Normal_palette_line_2+$14).w,a1
		move.l	#words_to_long($CAA,$A88),(a1)+
		move.l	#words_to_long($866,$644),(a1)+
		move.w	#$20,(a1)

		; init
		lea	ObjDat_ScrapEggman(pc),a1
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w			; is Knuckles?
		bne.s	.notKnux							; if not, branch
		lea	ObjDat_ScrapEggRobo(pc),a1

.notKnux
		jsr	(SetUp_ObjAttributes).w
		st	ros_prev_frame(a0)						; reset DPLC frame
		move.l	#.checkxcam,code_addr(a0)
		move.w	#$4F,wait_timer(a0)
		move.l	#.wait,wait_addr(a0)
		move.l	#AniRaw_ScrapEggman_Stand,animations_addr(a0)

		; load control desk
		lea	Child1_ScrapEggman_ControlDesk(pc),a2
		jsr	(CreateChild1_Normal).w

		; load blocks
		lea	Child6_ScrapEggman_Block(pc),a2
		jsr	(CreateChild6_Simple).w

.checkxcam
		cmpi.w	#$2240,(Camera_X_pos).w
		blo.s	.anim
		move.l	#.main,code_addr(a0)

.main
		jsr	(Obj_Wait).w

.anim

		; animate
		jsr	(Animate_RawMultiDelay).w

		; DPLC
		lea	PLCPtr_ScrapEggman(pc),a2
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w			; is Knuckles?
		bne.s	.notKnux2							; if not, branch
		lea	PLCPtr_ScrapEggRobo(pc),a2

.notKnux2
		jsr	(Perform_DPLC).w

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.wait
		move.w	#$4F,wait_timer(a0)
		move.l	#.fset,wait_addr(a0)
		lea	AniRaw_ScrapEggman_Laugh(pc),a1
		jmp	(Set_Raw_Animation).w
; ---------------------------------------------------------------------------

.fset
		st	scrapeggman.block(a0)
		move.l	#.return,wait_addr(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Object 82 - control desk (SBZ2)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_ScrapEggman_ControlDesk:

		; init
		lea	ObjDat_ScrapEggman_ControlDesk(pc),a1
		jsr	(SetUp_ObjAttributes).w

		; draw
		lea	(Child_Draw_Sprite).w,a1
		move.l	a1,code_addr(a0)
		jmp	(a1)

; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate Eggman presses a switch (SBZ2)
; ---------------------------------------------------------------------------

; dynamic object variables

; =============== S U B R O U T I N E =======================================

Obj_ScrapEggman_Block:

		; set xypos
		move.w	#$2210,x_pos(a0)
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$C0,d0
		move.w	d0,y_pos(a0)

		; calc xpos
		move.w	subtype(a0),d0
		move.w	d0,d1
		addq.w	#2,d1
		asl.w	#4,d0
		add.w	d0,x_pos(a0)							; +32 pixels

		; set wait
		lsl.w	#3,d1								; multiply by 8
		move.w	d1,wait_timer(a0)

		; init
		lea	ObjDat_ScrapEggman_Block(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#render_flags.static_mappings,render_flags(a0)			; set static mapping flag
		bset	#status.npc.no_balancing,status(a0)				; disable player's balance animation
		move.l	#.fwait,code_addr(a0)

.fwait

		; check flag
		movea.w	parent3(a0),a1							; a1=parent object
		tst.b	scrapeggman.block(a1)
		beq.w	.solid
		move.l	#.twait,code_addr(a0)

.twait
		subq.w	#1,wait_timer(a0)
		bpl.s	.solid

		; release player from object
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		beq.s	.notrelease							; if not, branch

		; check p1
		bclr	#p1_standing_bit,status(a0)
		beq.s	.notp1
		lea	(Player_1).w,a1							; a1=character
		move.b	#1,prev_anim(a1)
		bclr	#status.player.on_object,status(a1)
		bclr	#status.player.pushing,status(a1)
		bset	#status.player.in_air,status(a1)
		bne.s	.notp1								; if the player is already in the air, branch

	if ~~PlayerFallAnim
		move.b	#AniIDSonAni_Hurt,anim(a1)
	endif

		clr.b	spin_dash_flag(a1)						; clear spin dash flag

.notp1

		; check p2
		bclr	#p2_standing_bit,status(a0)
		beq.s	.notrelease
		lea	(Player_2).w,a1							; a1=character
		move.b	#1,prev_anim(a1)
		bclr	#status.player.on_object,status(a1)
		bclr	#status.player.pushing,status(a1)
		bset	#status.player.in_air,status(a1)
		bne.s	.notrelease							; if the player is already in the air, branch

	if ~~PlayerFallAnim
		move.b	#AniIDSonAni_Hurt,anim(a1)
	endif

		clr.b	spin_dash_flag(a1)						; clear spin dash flag

.notrelease

		; create blocks pieces
		sfx	sfx_Collapse							; play smashing sound
		lea	Child1_ScrapEggman_BlockPieces(pc),a2
		jsr	(CreateChild1_Normal).w

		; delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

.solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; draw
		jmp	(Child_Draw_Sprite).w

; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate Eggman presses a switch (SBZ2)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ScrapEggman_BlockPieces:

		; init
		lea	ObjDat_ScrapEggman_BlockPieces(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.fall,code_addr(a0)

		; get subtype
		move.w	subtype(a0),d0

		; set yvel
		move.w	.speed(pc,d0.w),y_vel(a0)

		; set frame
		lsr.w	d0								; division by 2
		move.b	d0,mapping_frame(a0)

.fall
		jsr	(MoveSprite).w
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

.speed	dc.w $80, 0, $120, $C0

; =============== S U B R O U T I N E =======================================

; init
ObjDat_ScrapEggman:			subObjData Map_ScrapEggman, $320, 0, TRUE, 56, 40, 4, 0, collision_type.npc.none, 0, 0
ObjDat_ScrapEggRobo:			subObjData Map_ScrapEggRobo, $320, 0, TRUE, 56, 32, 4, 0, collision_type.npc.none, 0, 0
ObjDat_ScrapEggman_ControlDesk:		subObjData Map_ScrapControlDesk, $340, 1, TRUE, 56, 32, 3, 0, collision_type.npc.none, 0, 0
ObjDat_ScrapEggman_Block:		subObjData Map_FFloor, $364, 2, TRUE, 32, 32, 3, 0, collision_type.npc.none, 0, 0
ObjDat_ScrapEggman_BlockPieces:		subObjData Map_FFloor_Pieces, $364, 2, TRUE, 16, 16, 3, 0, collision_type.npc.none, 0, 0

; dplc
PLCPtr_ScrapEggman:			DPLCEntry ArtUnc_ScrapEggman, DPLC_ScrapEggman
PLCPtr_ScrapEggRobo:			DPLCEntry ArtUnc_ScrapEggRobo, DPLC_ScrapEggRobo

Child1_ScrapEggman_ControlDesk:
		dc.w 1-1
		dc.l Obj_ScrapEggman_ControlDesk
		dc.b -12, 8
Child6_ScrapEggman_Block:
		dc.w 8-1
		dc.l Obj_ScrapEggman_Block
Child1_ScrapEggman_BlockPieces:
		dc.w 4-1
		dc.l Obj_ScrapEggman_BlockPieces
		dc.b -8, -8
		dc.l Obj_ScrapEggman_BlockPieces
		dc.b 8, -8
		dc.l Obj_ScrapEggman_BlockPieces
		dc.b -8, 8
		dc.l Obj_ScrapEggman_BlockPieces
		dc.b 8, 8

AniRaw_ScrapEggman_Stand:
		dc.b 0, 7	; frame, wait
		dc.b 1, $17
		dc.b 0, 7
		dc.b 1, $F
		dc.b 0, $3F
		dc.b 1, 7
		dc.b arfEnd
AniRaw_ScrapEggman_Laugh:
		dc.b 2, 6	; frame, wait
		dc.b 3, 6
		dc.b arfEnd
	even

PLC_SE_ControlDesk: plrlistheader
		plreq $340, ArtKosPlusM_SE_ControlDesk
		plrlistend
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Bosses/Scrap Eggman/Object Data/Map - Scrap Eggman.asm"
		include "Objects/Bosses/Scrap Eggman/Object Data/DPLC - Scrap Eggman.asm"
		include "Objects/Bosses/Scrap Eggman/Object Data/Map - Scrap Egg Robo.asm"
		include "Objects/Bosses/Scrap Eggman/Object Data/DPLC - Scrap Egg Robo.asm"
		include "Objects/Bosses/Scrap Eggman/Object Data/Map - Control Desk.asm"
		include "Objects/Bosses/Scrap Eggman/Object Data/Map - Block.asm"
		include "Objects/Bosses/Scrap Eggman/Object Data/Map - Block Pieces.asm"
