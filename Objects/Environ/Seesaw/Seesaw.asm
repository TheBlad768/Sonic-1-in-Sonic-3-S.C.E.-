; ---------------------------------------------------------------------------
; Object 5E - seesaws (SLZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
see_origX			= objoff_30	; original x-axis position (2 bytes)
see_origY			= objoff_34	; original y-axis position (2 bytes)
see_speed			= objoff_38	; speed of collision (2 bytes)
see_frame			= objoff_3A	; frame (1 byte)

; =============== S U B R O U T I N E =======================================

Obj_Seesaw:

		; init
		move.l	#Map_Seesaw,mappings(a0)
		move.w	#make_art_tile($37A,0,0),art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(96/2,96/2,priority_3),height_pixels(a0)	; set height, width and priority
		move.w	x_pos(a0),see_origX(a0)
		move.l	#.main,address(a0)

		; check boss
		move.b	subtype(a0),d0							; is object type $80-$FF?
		bpl.s	.noboss								; if not, branch

		; SLZ boss
		lea	(Boss_events).w,a1
		andi.w	#$7F,d0
		add.w	d0,d0
		adda.w	d0,a1
		move.w	a0,(a1)								; save address for boss
		bra.s	.noball
; ---------------------------------------------------------------------------

.noboss

		; load spikeball object
		lea	Child6_See_Spikeball(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.noball
		move.b	status(a0),status(a1)

.noball
		btst	#status.npc.x_flip,status(a0)					; is seesaw flipped?
		beq.s	.noflip								; if not, branch
		move.b	#2,mapping_frame(a0)						; use different frame

.noflip
		move.b	mapping_frame(a0),see_frame(a0)

.main
		move.b	see_frame(a0),d1
		btst	#p1_standing_bit,status(a0)
		beq.s	.notplayer1

		; check side (Sonic/Knuckles and Tails)
		moveq	#2,d1
		lea	(Player_1).w,a1							; a1=character
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0							; is Sonic/Knuckles on the left side of the seesaw?
		bhs.s	.leftside1							; if yes, branch
		neg.w	d0
		moveq	#0,d1

.leftside1
		cmpi.w	#8,d0
		bhs.s	.checkTails
		moveq	#1,d1

.checkTails
		btst	#p2_standing_bit,status(a0)
		beq.s	.slope
		moveq	#2,d2
		lea	(Player_2).w,a1							; a1=character
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0							; is Tails on the left side of the seesaw?
		bhs.s	.leftside2							; if yes, branch
		neg.w	d0
		moveq	#0,d2

.leftside2
		cmpi.w	#8,d0
		bhs.s	.checkplayers
		moveq	#1,d2

.checkplayers
		add.w	d2,d1
		cmpi.w	#3,d1
		bne.s	.skip
		addq.w	#1,d1

.skip
		lsr.w	d1
		bra.s	.slope
; ---------------------------------------------------------------------------

.notplayer1
		btst	#p2_standing_bit,status(a0)
		beq.s	.savespeed

		; Tails
		moveq	#2,d1
		lea	(Player_2).w,a1							; a1=character
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0							; is Tails on the left side of the seesaw?
		bhs.s	.leftside3							; if yes, branch
		neg.w	d0
		moveq	#0,d1

.leftside3
		cmpi.w	#8,d0
		bhs.s	.slope
		moveq	#1,d1
		bra.s	.slope
; ---------------------------------------------------------------------------

.savespeed
		move.w	(Player_1+y_vel).w,d0
		move.w	(Player_2+y_vel).w,d2
		cmp.w	d0,d2
		blt.s	.setspeed
		move.w	d2,d0

.setspeed
		move.w	d0,see_speed(a0)

.slope

		; change frame
		bsr.s	See_ChgFrame

		; load slope data
		lea	See_DataSlope(pc),a2
		btst	#0,mapping_frame(a0)						; is seesaw flat?
		beq.s	.notflat							; if not, branch
		lea	See_DataFlat(pc),a2

.notflat
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTopSloped2).w

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	see_origX(a0),d0						; get object position
		jmp	(Sprite_CheckDelete.skipxpos).w

; =============== S U B R O U T I N E =======================================

See_ChgFrame:
		move.b	mapping_frame(a0),d0
		cmp.b	d1,d0								; does frame need to change?
		beq.s	.noflip								; if not, branch
		bhs.s	.loc_11772
		addq.b	#2,d0

.loc_11772
		subq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		move.b	d1,see_frame(a0)
		bclr	#render_flags.x_flip,render_flags(a0)
		btst	#1,mapping_frame(a0)
		beq.s	.noflip
		bset	#render_flags.x_flip,render_flags(a0)

.noflip
		rts

; ---------------------------------------------------------------------------
; Object 5E - seesaws ball (SLZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_See_Spikeball:

		; init
		lea	ObjDat_See_SpikeBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,address(a0)
		move.w	x_pos(a0),see_origX(a0)
		addi.w	#40,x_pos(a0)
		move.w	y_pos(a0),see_origY(a0)
		btst	#status.npc.x_flip,status(a0)					; is seesaw flipped?
		beq.s	.main								; if not, branch
		subi.w	#80,x_pos(a0)							; move spikeball to the other side
		move.b	#2,see_frame(a0)

.main
		pea	.draw(pc)
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		moveq	#0,d0
		move.b	see_frame(a0),d0
		sub.b	see_frame(a1),d0
		beq.s	.loc_1183E
		bhs.s	.loc_117FC
		neg.b	d0

.loc_117FC
		move.l	#words_to_long(-$114,-$818),d1					; x_vel + y_vel
		cmpi.b	#1,d0
		beq.s	.loc_11822
		move.l	#words_to_long(-$CC,-$AF0),d1					; x_vel + y_vel
		cmpi.w	#$A00,see_speed(a1)
		blt.s	.loc_11822
		move.l	#words_to_long(-$A0,-$E00),d1					; x_vel + y_vel

.loc_11822
		move.l	d1,x_vel(a0)
		move.w	x_pos(a0),d0
		sub.w	see_origX(a0),d0
		bhs.s	.leftside1
		neg.w	x_vel(a0)

.leftside1
		move.l	#.spikefall,address(a0)
		bra.s	.spikefallskip
; ---------------------------------------------------------------------------

.loc_1183E
		lea	See_Speeds(pc),a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		moveq	#$28,d2
		move.w	x_pos(a0),d1
		sub.w	see_origX(a0),d1
		bhs.s	.leftside2
		neg.w	d2
		addq.w	#2,d0

.leftside2
		add.w	d0,d0
		move.w	see_origY(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,y_pos(a0)
		add.w	see_origX(a0),d2
		move.w	d2,x_pos(a0)
		clr.w	y_pos+2(a0)
		clr.w	x_pos+2(a0)

.return
		rts
; ---------------------------------------------------------------------------

.spikefall
		pea	.draw(pc)

.spikefallskip
		tst.w	y_vel(a0)							; is spikeball falling down?
		bpl.s	.loc_1189A							; if yes, branch
		jsr	(MoveSprite).w
		moveq	#-47,d0
		add.w	see_origY(a0),d0
		cmp.w	y_pos(a0),d0
		bgt.s	.return
		jmp	(MoveSprite).w
; ---------------------------------------------------------------------------

.loc_1189A
		jsr	(MoveSprite).w
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		lea	See_Speeds(pc),a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	x_pos(a0),d1
		sub.w	see_origX(a0),d1
		bhs.s	.loc_118BA
		addq.w	#2,d0

.loc_118BA
		add.w	d0,d0
		move.w	see_origY(a0),d1						; d1 = bottom of seesaw y position
		add.w	(a2,d0.w),d1							; + offset for current angle
		cmp.w	y_pos(a0),d1							; return if y position < d1
		bgt.s	.return2
		movea.w	parent3(a0),a1							; a1=parent object (seesaw)
		moveq	#2,d1
		tst.w	x_vel(a0)
		bmi.s	.spring
		moveq	#0,d1

.spring
		move.b	d1,see_frame(a1)
		move.b	d1,see_frame(a0)
		cmp.b	mapping_frame(a1),d1
		beq.s	.clear

		; launch main character if stood on seesaw
		lea	(Player_1).w,a2							; a2=character
		bclr	#p1_standing_bit,status(a1)
		beq.s	.notplayer1
		bsr.s	Seesaw_LaunchCharacter

.notplayer1

		; launch sidekick if stood on seesaw
		lea	(Player_2).w,a2							; a2=character
		bclr	#p2_standing_bit,status(a1)
		beq.s	.clear
		bsr.s	Seesaw_LaunchCharacter

.clear
		clr.l	x_vel(a0)							; clear ball velocity
		move.l	#.main,address(a0)

.return2
		rts
; ---------------------------------------------------------------------------

.draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	see_origX(a0),d0						; get object position
		jmp	(Sprite_CheckDeleteTouch3.skipxpos).w

; =============== S U B R O U T I N E =======================================

Seesaw_LaunchCharacter:
		move.w	y_vel(a0),y_vel(a2)						; set character y velocity to inverse of sol
		neg.w	y_vel(a2)							; y velocity
		bset	#status.player.in_air,status(a2)				; set character airborne flag
		bclr	#status.player.on_object,status(a2)				; clear character on object flag
		clr.b	jumping(a2)							; clear character jumping flag
		clr.b	spin_dash_flag(a2)						; clear spin dash flag
		move.b	#AniIDSonAni_Spring,anim(a2)					; change Sonic's animation to "spring" ($10)
		move.b	#PlayerID_Control,routine(a2)					; set character to airborne state
		sfx	sfx_Spring,1							; play spring sound

; =============== S U B R O U T I N E =======================================

ObjDat_See_SpikeBall:	subObjData Map_SSawBall, $4EE, 0, 0, 24, 24, 4, 1, $B|collision_flags.npc.hurt

Child6_See_Spikeball:
		dc.w 1-1
		dc.l Obj_See_Spikeball

See_Speeds:		dc.w -8, -28, -47, -28, -8	; low, balanced, high, balanced, low

See_DataSlope:	binclude "Objects/Environ/Seesaw/Object Data/Slope.bin"
	even
See_DataFlat:	binclude "Objects/Environ/Seesaw/Object Data/Flat.bin"
	even
; ---------------------------------------------------------------------------

		include "Objects/Environ/Seesaw/Object Data/Map - Seesaw.asm"
		include "Objects/Environ/Seesaw/Object Data/Map - Seesaw Ball.asm"
