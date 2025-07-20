; ---------------------------------------------------------------------------
; Object 09 - Player (Special Stage)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_PlayerSpecial:
		move.w	(Ctrl_1).w,(Ctrl_1_logical).w					; copy new held buttons, to enable joypad control

	if GameDebug
		tst.w	(Debug_placement_mode).w					; is debug mode being used?
		beq.s	Obj09_Normal							; if not, branch
		bsr.w	Debug_Mode
		bra.w	SS_FixCamera
; ---------------------------------------------------------------------------

Obj09_Normal:
	endif

		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj09_Index(pc,d0.w),d0
		jsr	Obj09_Index(pc,d0.w)

loc_4B97C:
		move.b	#2,anim(a0)
		bsr.s	sub_4B99E
		moveq	#0,d0
		lea	(Player_1).w,a1							; a1=character
		move.b	mapping_frame(a1),d0
		jsr	(Perform_Player_DPLC).l
		bsr.w	SS_FixCamera
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_4B99E:
		move.b	character_id(a0),d0
		bne.s	loc_4B9AA
		jmp	(Animate_Sonic).l
; ---------------------------------------------------------------------------

loc_4B9AA:
		cmpi.b	#1,d0
		bne.s	loc_4B9B6
		jmp	(Animate_Tails).l
; ---------------------------------------------------------------------------

loc_4B9B6:
		jmp	(Animate_Knuckles).l
; ---------------------------------------------------------------------------

Obj09_Index: offsetTable
		offsetTableEntry.w Obj09_Main						; 0
		offsetTableEntry.w Obj09_ChkDebug					; 2
		offsetTableEntry.w Obj09_ExitStage					; 4
		offsetTableEntry.w Obj09_Exit2						; 6
; ---------------------------------------------------------------------------

off_4B9C2:
		dc.l Map_Sonic		; 0/1
		dc.l Map_Tails		; 2
		dc.l Map_Knuckles	; 3/4
; ---------------------------------------------------------------------------

Obj09_Main:										; Routine 0
		addq.b	#2,routine(a0)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius (rolling)
		move.l	#bytes_word_to_long(48/2,48/2,priority_2),height_pixels(a0)	; set height, width and priority

		; check player
		move.w	(Player_mode).w,d0
		subq.w	#1,d0
		bhs.s	loc_4B9E8
		moveq	#0,d0

loc_4B9E8:
		cmpi.b	#PlayerModeID_KnucklesTails-1,d0
		bne.s	.notKnuxTails
		subq.w	#1,d0

.notKnuxTails
		move.b	d0,character_id(a0)
		cmpi.b	#PlayerModeID_Tails-1,d0
		bne.s	.notTails
		move.l	#Obj_Tails_Tail,(Tails_tails+address).w
		move.w	a0,(Tails_tails+objoff_30).w

.notTails
		add.w	d0,d0
		add.w	d0,d0
		move.l	off_4B9C2(pc,d0.w),mappings(a0)

		; init
		move.w	#make_art_tile($79C,0,0),art_tile(a0)
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.b	#AniIDSonAni_Roll,anim(a0)
		bset	#status.player.rolling,status(a0)
		bset	#status.player.in_air,status(a0)

Obj09_ChkDebug:										; Routine 2

	if GameDebug
		tst.b	(Debug_mode_flag).w						; is debug mode cheat enabled?
		beq.s	Obj09_NoDebug							; if not, branch
		btst	#button_B,(Ctrl_1_pressed).w					; is button B pressed?
		beq.s	Obj09_NoDebug							; if not, branch
		move.w	#1,(Debug_placement_mode).w					; change player into a ring

Obj09_NoDebug:
	endif

		clr.b	objoff_30(a0)
		btst	#status.player.in_air,status(a0)				; is the player in the air?
		bne.s	Obj09_InAir							; if yes, branch

Obj09_OnWall:
		bsr.w	Obj09_Jump

Obj09_InAir:
		bsr.s	Obj09_Move
		bsr.w	Obj09_Fall
		bsr.w	Obj09_ChkItems
		bsr.w	Obj09_ChkItems2
		move.w	(SStage_scalar_index_1).w,d0
		add.w	d0,(SStage_scalar_index_0).w
		jmp	(MoveSprite2).w

; =============== S U B R O U T I N E =======================================

Obj09_Move:
		btst	#button_left,(Ctrl_1_logical).w					; is left being pressed?
		beq.s	Obj09_ChkRight							; if not, branch
		bsr.w	Obj09_MoveLeft

Obj09_ChkRight:
		btst	#button_right,(Ctrl_1_logical).w				; is right being pressed?
		beq.s	loc_1BA78							; if not, branch
		bsr.w	Obj09_MoveRight

loc_1BA78:
		moveq	#btnLR,d0
		and.b	(Ctrl_1_logical).w,d0
		bne.s	loc_1BAA8
		move.w	ground_vel(a0),d0
		beq.s	loc_1BAA8
		bmi.s	loc_1BA9A
		subi.w	#$C,d0
		bhs.s	loc_1BA94
		moveq	#0,d0

loc_1BA94:
		move.w	d0,ground_vel(a0)
		bra.s	loc_1BAA8
; ---------------------------------------------------------------------------

loc_1BA9A:
		addi.w	#$C,d0
		bhs.s	loc_1BAA4
		moveq	#0,d0

loc_1BAA4:
		move.w	d0,ground_vel(a0)

loc_1BAA8:
		moveq	#$20,d0
		add.b	(SStage_scalar_index_0).w,d0
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(GetSineCosine).w
		muls.w	ground_vel(a0),d1
		add.l	d1,x_pos(a0)
		muls.w	ground_vel(a0),d0
		add.l	d0,y_pos(a0)
		movem.l	d0-d1,-(sp)
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3
		bsr.w	sub_1BCE8
		beq.s	loc_1BAF2
		movem.l	(sp)+,d0-d1
		sub.l	d1,x_pos(a0)
		sub.l	d0,y_pos(a0)
		clr.w	ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1BAF2:
		movem.l	(sp)+,d0-d1
		rts

; =============== S U B R O U T I N E =======================================

Obj09_MoveLeft:
		bset	#status.player.x_flip,status(a0)
		move.w	ground_vel(a0),d0
		beq.s	loc_1BB06
		bpl.s	loc_1BB1A

loc_1BB06:
		subi.w	#$C,d0
		cmpi.w	#-$800,d0
		bgt.s	loc_1BB14
		move.w	#-$800,d0

loc_1BB14:
		move.w	d0,ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1BB1A:
		subi.w	#$40,d0
		move.w	d0,ground_vel(a0)
		rts

; =============== S U B R O U T I N E =======================================

Obj09_MoveRight:
		bclr	#status.player.x_flip,status(a0)
		move.w	ground_vel(a0),d0
		bmi.s	loc_1BB48
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_1BB42
		move.w	#$800,d0

loc_1BB42:
		move.w	d0,ground_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1BB48:
		addi.w	#$40,d0
		move.w	d0,ground_vel(a0)

locret_1BB54:
		rts

; =============== S U B R O U T I N E =======================================

Obj09_Jump:
		moveq	#btnABC,d0							; is A, B or C pressed?
		and.b	(Ctrl_1_pressed_logical).w,d0
		beq.s	locret_1BB54							; if not, branch

	if ~~SpecialStageRotation
		moveq	#-4,d0
		and.b	(SStage_scalar_index_0).w,d0					; original rotation
	else
		move.b	(SStage_scalar_index_0).w,d0					; smooth rotation
	endif

		neg.b	d0
		subi.b	#$40,d0
		jsr	(GetSineCosine).w
		move.w	#$680,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		bset	#status.player.in_air,status(a0)
		sfx	sfx_Jump,1							; play jumping sound

; ---------------------------------------------------------------------------
; Subroutine to fix the camera on player's position (Special Stage)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SS_FixCamera:
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		move.w	(Camera_X_pos).w,d0
		subi.w	#320/2,d3
		blo.s	loc_1BBCE
		sub.w	d3,d0
		sub.w	d0,(Camera_X_pos).w

loc_1BBCE:
		move.w	(Camera_Y_pos).w,d0
		subi.w	#224/2,d2
		blo.s	locret_1BBDE
		sub.w	d2,d0
		sub.w	d0,(Camera_Y_pos).w

locret_1BBDE:
		rts

; =============== S U B R O U T I N E =======================================

Obj09_ExitStage:
		addi.w	#$40,(SStage_scalar_index_1).w
		cmpi.w	#$1800,(SStage_scalar_index_1).w
		bne.s	loc_1BBF4
		st	(Special_stage_flag).w

loc_1BBF4:
		cmpi.w	#$3000,(SStage_scalar_index_1).w
		blt.s	loc_1BC16
		addq.b	#2,routine(a0)
		clr.w	(SStage_scalar_index_1).w
		move.w	#$4000,(SStage_scalar_index_0).w
		move.w	#1*60,objoff_3C(a0)

loc_1BC16:
		move.w	(SStage_scalar_index_1).w,d0
		add.w	d0,(SStage_scalar_index_0).w
		rts
; ---------------------------------------------------------------------------

Obj09_Exit2:
		addi.w	#$40,(SStage_scalar_index_1).w
		move.w	(SStage_scalar_index_1).w,d0
		add.w	d0,(SStage_scalar_index_0).w
		subq.w	#1,objoff_3C(a0)
		bne.s	loc_1BC40
		move.l	#loc_4B97C,address(a0)

loc_1BC40:
		bra.w	loc_4B97C

; =============== S U B R O U T I N E =======================================

Obj09_Fall:
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3

	if ~~SpecialStageRotation
		moveq	#-4,d0
		and.b	(SStage_scalar_index_0).w,d0					; original rotation
	else
		move.b	(SStage_scalar_index_0).w,d0					; smooth rotation
	endif

		jsr	(GetSineCosine).w
		muls.w	#$2A,d0
		muls.w	#$2A,d1
		movem.w	x_vel(a0),d4-d5							; load xy speed
		asl.l	#8,d4
		asl.l	#8,d5
		add.l	d4,d0
		add.l	d5,d1
		add.l	d0,d3
		bsr.s	sub_1BCE8
		beq.s	loc_1BCB0
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,x_vel(a0)
		bclr	#status.player.in_air,status(a0)
		add.l	d1,d2
		bsr.s	sub_1BCE8
		beq.s	loc_1BCC6
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1BCB0:
		add.l	d1,d2
		bsr.s	sub_1BCE8
		beq.s	loc_1BCD4
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,y_vel(a0)
		bclr	#status.player.in_air,status(a0)

loc_1BCC6:
		asr.l	#8,d0
		asr.l	#8,d1
		movem.w	d0-d1,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1BCD4:
		asr.l	#8,d0
		asr.l	#8,d1
		movem.w	d0-d1,x_vel(a0)
		bset	#status.player.in_air,status(a0)
		rts

; =============== S U B R O U T I N E =======================================

sub_1BCE8:
		lea	(SStage_Buffer1).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		lea	$7E(a1),a1
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		tst.b	d5
		rts

; =============== S U B R O U T I N E =======================================

sub_1BD30:
		beq.s	locret_1BD44
		cmpi.b	#$28,d4								; is the item an extra life?
		beq.s	locret_1BD44							; if yes, branch
		cmpi.b	#$4F,d4								; is the item an emerald?
		beq.s	locret_1BD44							; if yes, branch
		cmpi.b	#$3A,d4
		blo.s	loc_1BD46
		cmpi.b	#$4B,d4
		bhs.s	loc_1BD46

locret_1BD44:
		rts
; ---------------------------------------------------------------------------

loc_1BD46:
		move.b	d4,objoff_30(a0)
		move.l	a1,objoff_32(a0)
		moveq	#-1,d5
		rts

; =============== S U B R O U T I N E =======================================

Obj09_ChkItems:
		lea	(SStage_Buffer1).l,a1
		moveq	#$50,d4
		add.w	y_pos(a0),d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#$20,d4
		add.w	x_pos(a0),d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	Obj09_ChkCont
		tst.b	objoff_3A(a0)
		bne.w	Obj09_MakeGhostSolid
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Obj09_ChkCont:
		cmpi.b	#$3A,d4								; is the item a	ring?
		bne.s	Obj09_Chk1Up
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GetCont
		move.b	#1,(a2)
		move.l	a1,4(a2)

Obj09_GetCont:
		addq.w	#1,(Special_stage_ring_count).w					; add 1 to rings
		sfx	sfx_RingRight							; play ring sound

		; check
		cmpi.w	#50,(Special_stage_ring_count).w				; check if you have 50 rings
		blo.s	.perfect
		bset	#0,(Extra_life_flags).w
		bne.s	.perfect
		addq.b	#1,(Continue_count).w						; add 1 to number of continues
		sfx	sfx_Continue							; play extra continue sound

.perfect
		tst.w	(Special_stage_rings_left).w
		beq.s	Obj09_NoCont

		; update
		ori.b	#1,(Update_HUD_ring_count).w					; update ring counter
		cmpi.w	#1,(Special_stage_rings_left).w
		beq.s	.resetHUD
		cmpi.w	#10,(Special_stage_rings_left).w
		beq.s	.resetHUD
		cmpi.w	#100,(Special_stage_rings_left).w
		bne.s	.updateHUD

.resetHUD
		move.b	#$80,(Update_HUD_ring_count).w					; update ring counter

.updateHUD
		subq.w	#1,(Special_stage_rings_left).w
		bne.s	Obj09_NoCont
		st	(HUD_RAM.status).w
		sfx	sfx_Perfect							; play perfect sound

Obj09_NoCont:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Obj09_Chk1Up:
		cmpi.b	#$28,d4								; is the item an extra life?
		bne.s	Obj09_ChkEmer
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_Get1Up
		move.b	#3,(a2)
		move.l	a1,4(a2)

Obj09_Get1Up:
		addq.b	#1,(Life_count).w						; add 1 to number of lives
		addq.b	#1,(Update_HUD_life_count).w					; update the lives counter
		music	mus_ExtraLife							; play the 1up song
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Obj09_ChkEmer:
		cmpi.b	#$4F,d4								; is the item an emerald?
		beq.s	.emerald							; if yes, branch
		cmpi.b	#$3B,d4								; is the item an emerald?
		blo.s	Obj09_ChkGhost							; if not, branch
		cmpi.b	#$40,d4								; is the item an emerald?
		bhi.s	Obj09_ChkGhost							; if not, branch

.emerald
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GetEmer
		move.b	#5,(a2)
		move.l	a1,4(a2)

Obj09_GetEmer:
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		beq.s	Obj09_NoEmer							; if yes, branch

		; get emerald
		moveq	#0,d0
		move.w	d0,(Special_stage_spheres_left).w				; set 'Got'
		lea	(Collected_emeralds_array).w,a2
		move.b	(Saved_special_stage).w,d0
		bset	#0,(a2,d0.w)
		addq.b	#1,(Chaos_emerald_count).w					; add 1 to number of emeralds

Obj09_NoEmer:
		st	(HUD_RAM.status).w
		music	mus_Emerald							; play emerald music
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Obj09_ChkGhost:
		cmpi.b	#$41,d4								; is the item a	ghost block?
		bne.s	Obj09_ChkGhostTag
		move.b	#1,objoff_3A(a0)						; mark the ghost block as "passed"

Obj09_ChkGhostTag:
		cmpi.b	#$4A,d4								; is the item a	switch for ghost blocks?
		bne.s	Obj09_NoGhost
		cmpi.b	#1,objoff_3A(a0)						; have the ghost blocks	been passed?
		bne.s	Obj09_NoGhost							; if not, branch
		move.b	#2,objoff_3A(a0)						; mark the ghost blocks	as "solid"

Obj09_NoGhost:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

Obj09_MakeGhostSolid:
		cmpi.b	#2,objoff_3A(a0)						; is the ghost marked as "solid"?
		bne.s	Obj09_GhostNotSolid						; if not, branch

		; find ghost solid
		lea	(SStage_Ghost_Buffer).l,a2

.ghostloop
		moveq	#-1,d0								; set RAM_start
		move.w	(a2),d0								; get ghost solid address
		beq.s	Obj09_GhostNotSolid						; if there are no ghost solids, branch
		clr.w	(a2)+								; clear address

		; load ghost solid
		movea.l	d0,a1								; get address (RAM_start+$XXXX)

		; set
		move.b	#$2C,(a1)							; replace ghost block with a solid block

		; back
		bra.s	.ghostloop
; ---------------------------------------------------------------------------

Obj09_GhostNotSolid:
		clr.b	objoff_3A(a0)
		moveq	#0,d4
		rts

; =============== S U B R O U T I N E =======================================

Obj09_ChkItems2:
		move.b	objoff_30(a0),d0
		bne.s	Obj09_ChkBumper
		subq.b	#1,objoff_36(a0)
		bpl.s	loc_1BEA0
		clr.b	objoff_36(a0)

loc_1BEA0:
		subq.b	#1,objoff_37(a0)
		bpl.s	locret_1BEAC
		clr.b	objoff_37(a0)

locret_1BEAC:
		rts
; ---------------------------------------------------------------------------

Obj09_ChkBumper:
		cmpi.b	#$25,d0								; is the item a bumper?
		bne.s	Obj09_GOAL
		move.l	objoff_32(a0),d1
		subi.l	#$FF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(CalcAngle).w
		jsr	(GetSineCosine).w
		move.w	#-$700,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		bset	#status.player.in_air,status(a0)
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_BumpSnd
		move.b	#2,(a2)
		move.l	objoff_32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

Obj09_BumpSnd:
		sfx	sfx_Bumper,1							; play bumper sound
; ---------------------------------------------------------------------------

Obj09_GOAL:
		cmpi.b	#$27,d0								; is the item a	"GOAL"?
		bne.s	Obj09_UPblock
		addq.b	#2,routine(a0)							; run routine "Obj09_ExitStage"
		st	(HUD_RAM.status).w
		sfx	sfx_SSGoal,1							; play "GOAL" sound
; ---------------------------------------------------------------------------

Obj09_UPblock:
		cmpi.b	#$29,d0								; is the item an "UP" block?
		bne.s	Obj09_DOWNblock
		tst.b	objoff_36(a0)
		bne.w	Obj09_NoGlass
		move.b	#30,objoff_36(a0)
		btst	#6,(SStage_scalar_index_1+1).w
		beq.s	Obj09_UPsnd
		asl.w	(SStage_scalar_index_1).w					; increase stage rotation speed
		movea.l	objoff_32(a0),a1
		subq.w	#1,a1
		move.b	#$2A,(a1)							; change item to a "DOWN" block

Obj09_UPsnd:
		sfx	sfx_SSItem,1							; play up/down sound
; ---------------------------------------------------------------------------

Obj09_DOWNblock:
		cmpi.b	#$2A,d0								; is the item a	"DOWN" block?
		bne.s	Obj09_Rblock
		tst.b	objoff_36(a0)
		bne.w	Obj09_NoGlass
		move.b	#30,objoff_36(a0)
		btst	#6,(SStage_scalar_index_1+1).w
		bne.s	Obj09_DOWNsnd
		asr.w	(SStage_scalar_index_1).w					; reduce stage rotation speed
		movea.l	objoff_32(a0),a1
		subq.w	#1,a1
		move.b	#$29,(a1)							; change item to an "UP" block

Obj09_DOWNsnd:
		sfx	sfx_SSItem,1							; play up/down sound
; ---------------------------------------------------------------------------

Obj09_Rblock:
		cmpi.b	#$2B,d0								; is the item an "R" block?
		bne.s	Obj09_ChkGlass
		tst.b	objoff_37(a0)
		bne.s	Obj09_NoGlass
		move.b	#30,objoff_37(a0)
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_RevStage
		move.b	#4,(a2)
		move.l	objoff_32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

Obj09_RevStage:
		neg.w	(SStage_scalar_index_1).w					; reverse stage rotation
		sfx	sfx_SSItem,1							; play sound
; ---------------------------------------------------------------------------

Obj09_ChkGlass:
		cmpi.b	#$2D,d0								; is the item a	glass block?
		beq.s	Obj09_Glass							; if yes, branch
		cmpi.b	#$2E,d0
		beq.s	Obj09_Glass
		cmpi.b	#$2F,d0
		beq.s	Obj09_Glass
		cmpi.b	#$30,d0
		bne.s	Obj09_NoGlass							; if not, branch

Obj09_Glass:
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GlassSnd
		move.b	#6,(a2)
		movea.l	objoff_32(a0),a1
		subq.w	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0								; change glass type when touched
		cmpi.b	#$30,d0
		bls.s	Obj09_GlassUpdate						; if glass is still there, branch
		clr.b	d0								; remove the glass block when it's destroyed

Obj09_GlassUpdate:
		move.b	d0,4(a2)							; update the stage layout

Obj09_GlassSnd:
		sfx	sfx_SSGlass,1							; play glass block sound
; ---------------------------------------------------------------------------

Obj09_NoGlass:
		rts
