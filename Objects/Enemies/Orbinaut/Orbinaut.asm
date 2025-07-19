; ---------------------------------------------------------------------------
; Object 60 - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
orb_count			= objoff_39
orb_rotation			= objoff_40

; =============== S U B R O U T I N E =======================================

Obj_Orbinaut:

		; set
		move.w	#-$40,x_vel(a0)							; move orbinaut to the left
		btst	#status.npc.x_flip,status(a0)					; is orbinaut facing left??
		beq.s	.rot								; if not, branch
		neg.w	x_vel(a0)							; move orbinaut to the right

.rot
		moveq	#1,d0
		btst	#status.npc.x_flip,status(a0)					; is orbinaut facing left?
		beq.s	.noflip								; if not, branch
		neg.b	d0

.noflip
		move.b	d0,orb_rotation(a0)

		; init
		lea	ObjDat_Orbinaut(pc),a1						; LZ specific code
		jsr	(SetUp_ObjAttributes).w

		; check level
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; check if level is SBZ
		bne.s	.notscrap
		move.w	#make_art_tile($429,0,0),art_tile(a0)				; SBZ specific code

.notscrap

		; check level
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; check if level is SLZ
		bne.s	.notslz
		move.w	#make_art_tile($55B,1,0),art_tile(a0)				; SLZ specific code

.notslz

		; set
		move.l	#.chksonic,address(a0)
		tst.b	subtype(a0)
		beq.s	.load
		move.l	#.move,address(a0)

.load
		lea	Child6_Orbinaut_Orb(pc),a2
		move.b	1(a2),orb_count(a0)						; set number of orbs
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

.chksonic
		jsr	(Find_SonicTails).w
		cmpi.w	#160,d2								; is Sonic within $A0 pixels of orbinaut?
		bhs.s	.draw								; if not, branch
		cmpi.w	#80,d3								; is Sonic within $50 pixels of orbinaut?
		bhs.s	.draw								; if not, branch
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.draw								; if yes, branch
		addq.b	#1,anim(a0)							; use "angry" animation
		move.l	#.draw,address(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.move
		MoveSpriteXOnly a0

.draw
		lea	Ani_Orb(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; ---------------------------------------------------------------------------
; Orbinaut enemy (Orb)
; ---------------------------------------------------------------------------

; Dynamic object variables
orbo_angle			= objoff_3C	; .b

; =============== S U B R O U T I N E =======================================

Obj_Orbinaut_Orb:

		; set pos
		move.b	subtype(a0),d0
		lsl.b	#5,d0								; multiply by $20
		move.b	d0,orbo_angle(a0)

		; init
		move.l	#Map_Orb_Orb,mappings(a0)
		lea	ObjDat3_Orbinaut_Orb(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#render_flags.static_mappings,render_flags(a0)			; set flag to "static mappings flag"
		move.l	#.main,address(a0)

.main
		movea.w	parent3(a0),a1							; load orbinaut address
		cmpi.b	#2,mapping_frame(a1)						; is orbinaut angry?
		bne.s	.circle								; if not, branch
		tst.b	orbo_angle(a0)							; is spikeorb directly under the orbinaut?
		bne.s	.circle								; if not, branch
		bset	#shield_reaction.all_shields,shield_reaction(a0)		; bounce off all shields
		move.l	#.move,address(a0)
		subq.b	#1,orb_count(a1)
		bpl.s	.fire
		move.l	#Obj_Orbinaut.move,address(a1)

.fire
		move.w	#-$200,x_vel(a0)						; move orb to the left (quickly)
		btst	#status.npc.x_flip,status(a1)
		beq.s	.move
		neg.w	x_vel(a0)

.move
		MoveSpriteXOnly a0

		; draw
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

.circle
		move.b	orb_rotation(a1),d0						; angle
		sub.b	d0,orbo_angle(a0)
		moveq	#4,d2								; radius
		jsr	(MoveSprite_CircularSimple).w

		; draw
		jmp	(Child_DrawTouch_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Orbinaut:		subObjData Map_Orb, $55B, 0, 0, 24, 24, 4, 0, $B|collision_flags.npc.touch
ObjDat3_Orbinaut_Orb:		subObjData FALSE, FALSE, 0, 0, 16, 16, 4, 0, $18|collision_flags.npc.hurt

Child6_Orbinaut_Orb:
		dc.w 4-1
		dc.l Obj_Orbinaut_Orb
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Orbinaut/Object Data/Anim - Orbinaut.asm"
		include "Objects/Enemies/Orbinaut/Object Data/Map - Orbinaut.asm"
		include "Objects/Enemies/Orbinaut/Object Data/Map - Orbinaut Orb.asm"
