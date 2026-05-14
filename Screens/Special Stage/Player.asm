; ---------------------------------------------------------------------------
; Object 09 - Player (Special Stage)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

playerspecial.touched_block		ds.b 1						; (1 byte)
playerspecial.ghost_state		ds.b 1						; (1 byte)
playerspecial.item_addr			ds.l 1						; (4 bytes)
playerspecial.updown_timer		ds.b 1						; (1 byte)
playerspecial.reverse_timer		ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SpecialStagePlayer:
		move.w	(Ctrl_1).w,(Ctrl_1_logical).w					; copy new held buttons, to enable joypad control

	if GameDebug
		tst.w	(Debug_placement_mode).w					; is debug mode being used?
		beq.s	SpecialStagePlayer_Normal					; if not, branch
		bsr.w	Debug_Mode
		bra.w	SpecialStage_FixCamera
; ---------------------------------------------------------------------------

SpecialStagePlayer_Normal:
	endif

		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	SpecialStagePlayer_Index(pc,d0.w),d0
		jsr	SpecialStagePlayer_Index(pc,d0.w)

		; draw
		bsr.s	SpecialStagePlayer_Animate
		moveq	#0,d0
		movea.w	a0,a1								; a1=character
		move.b	mapping_frame(a1),d0
		jsr	(Perform_Player_DPLC).l
		bsr.w	SpecialStage_FixCamera
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Player animation
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_Animate:
		move.b	#AniIDSonAni_Roll,anim(a0)

		; check character
		move.b	character_id(a0),d0						; is Sonic?
		bne.s	.isTails							; if not, branch
		jmp	(Sonic_Animate).l
; ---------------------------------------------------------------------------

.isTails
		cmpi.b	#PlayerID_Tails,d0						; is Tails?
		bne.s	.isKnux								; if not, branch
		jmp	(Tails_Animate).l
; ---------------------------------------------------------------------------

.isKnux
		jmp	(Knuckles_Animate).l

; ---------------------------------------------------------------------------
; Player index
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_Index: offsetTable
		offsetTableEntry.w SpecialStagePlayer_Init				; 0
		offsetTableEntry.w SpecialStagePlayer_Control				; 2
		offsetTableEntry.w SpecialStagePlayer_ExitStage				; 4
; ---------------------------------------------------------------------------

SpecialStagePlayer_MapIndex:
		dc.l Map_Sonic								; 0/1 (player mode)
		dc.l Map_Tails								; 2 (player mode)
		dc.l Map_Knuckles							; 3/4 (player mode)
; ---------------------------------------------------------------------------

SpecialStagePlayer_Init:								; Routine 0
		addq.b	#2,routine(a0)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a0)				; set y_radius and x_radius (rolling)
		move.l	#bytes_word_to_long(48/2,48/2,priority_2),height_pixels(a0)	; set height, width and priority

		; player mode to character id
		move.w	(Player_mode).w,d0
		subq.w	#1,d0								; is Sonic Alone?
		bhs.s	.check								; if not, branch
		moveq	#0,d0

.check
		cmpi.b	#PlayerModeID_KnucklesTails-1,d0				; is Knuckles and Tails?
		bne.s	.notKnuxTails							; if not, branch
		subq.w	#1,d0

.notKnuxTails
		move.b	d0,character_id(a0)						; set character id

		; check Tails
		cmpi.b	#PlayerModeID_Tails-1,d0					; is Tails?
		bne.s	.notTails							; if not, branch
		move.l	#Obj_Tails_Tail,(Tails_tails+code_addr).w
		move.w	a0,(Tails_tails+parent).w

.notTails
		add.w	d0,d0								; multiply by 4
		add.w	d0,d0
		move.l	SpecialStagePlayer_MapIndex(pc,d0.w),mappings_addr(a0)

		; init
		move.w	#make_art_tile($79C,0,FALSE),art_tile(a0)
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.b	#AniIDSonAni_Roll,anim(a0)
		bset	#status.player.rolling,status(a0)
		bset	#status.player.in_air,status(a0)

SpecialStagePlayer_Control:								; Routine 2

	if GameDebug
		tst.b	(Debug_mode_flag).w						; is debug mode cheat enabled?
		beq.s	.nodebug							; if not, branch
		btst	#button_B,(Ctrl_1_pressed).w					; is button B pressed?
		beq.s	.nodebug							; if not, branch
		move.w	#1,(Debug_placement_mode).w					; change player into a ring

.nodebug
	endif

		clr.b	playerspecial.touched_block(a0)
		btst	#status.player.in_air,status(a0)				; is the player in the air?
		bne.s	SpecialStagePlayer_InAir					; if yes, branch

SpecialStagePlayer_OnWall:
		bsr.w	SpecialStagePlayer_Jump

SpecialStagePlayer_InAir:
		bsr.s	SpecialStagePlayer_Move
		bsr.w	SpecialStagePlayer_Fall
		bsr.w	SpecialStagePlayer_ChkItems
		bsr.w	SpecialStagePlayer_ChkItems2
		move.w	(SpecialStage.speed).w,d0
		add.w	d0,(SpecialStage.angle).w
		jmp	(MoveSprite2).w

; ---------------------------------------------------------------------------
; Player move
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_Move:
		btst	#button_left,(Ctrl_1_held_logical).w				; is left being pressed?
		beq.s	.chkright							; if not, branch
		bsr.w	SpecialStagePlayer_MoveLeft

.chkright
		btst	#button_right,(Ctrl_1_held_logical).w				; is right being pressed?
		beq.s	loc_1BA78							; if not, branch
		bsr.w	SpecialStagePlayer_MoveRight

loc_1BA78:
		moveq	#btnLR,d0
		and.b	(Ctrl_1_held_logical).w,d0
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
		add.b	(SpecialStage.angle).w,d0
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

; ---------------------------------------------------------------------------
; Player move left
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_MoveLeft:
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

; ---------------------------------------------------------------------------
; Player move right
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_MoveRight:
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

; ---------------------------------------------------------------------------
; Player jump
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_Jump:
		moveq	#btnABC,d0
		and.b	(Ctrl_1_pressed_logical).w,d0					; is A, B or C pressed?
		beq.s	locret_1BB54							; if not, branch

	if ~~SpecialStageRotation
		moveq	#-4,d0
		and.b	(SpecialStage.angle).w,d0					; original rotation
	else
		move.b	(SpecialStage.angle).w,d0					; smooth rotation
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
		sfx	sfx_Jump, 1							; play jumping sound

; ---------------------------------------------------------------------------
; Subroutine to fix the camera on player's position
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStage_FixCamera:
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		move.w	(Camera_X_pos).w,d0
		subi.w	#screen_width/2,d3
		blo.s	.checky
		sub.w	d3,d0
		sub.w	d0,(Camera_X_pos).w

.checky
		move.w	(Camera_Y_pos).w,d0
		subi.w	#screen_height/2,d2
		blo.s	.return
		sub.w	d2,d0
		sub.w	d0,(Camera_Y_pos).w

.return
		rts

; ---------------------------------------------------------------------------
; Subroutine to exit from Special Stage
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_ExitStage:
		addi.w	#$40,(SpecialStage.speed).w
		cmpi.w	#$1800,(SpecialStage.speed).w
		bne.s	loc_1BBF4
		st	(SpecialStage.exit_flag).w

loc_1BBF4:
		move.w	(SpecialStage.speed).w,d0
		add.w	d0,(SpecialStage.angle).w
		rts

; ---------------------------------------------------------------------------
; Player fall
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_Fall:
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3

	if ~~SpecialStageRotation
		moveq	#-4,d0
		and.b	(SpecialStage.angle).w,d0					; original rotation
	else
		move.b	(SpecialStage.angle).w,d0					; smooth rotation
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

		; get block pos
		lea	(SpecialStage.buffer).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		move.w	d4,d5
		moveq	#0,d4
		move.w	d5,d4
		lsl.l	#7,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1

		; check block
		moveq	#0,d5								; set flag to 0
		move.b	(a1)+,d4							; get block id to d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4							; get block id to d4
		bsr.s	sub_1BD30
		lea	$80-2(a1),a1
		move.b	(a1)+,d4							; get block id to d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4							; get block id to d4
		bsr.s	sub_1BD30

		; check flag
		tst.b	d5
		rts

; =============== S U B R O U T I N E =======================================

sub_1BD30:
		beq.s	.return								; if zero, branch
		cmpi.b	#$28,d4								; is the item an extra life?
		beq.s	.return								; if yes, branch

		; check emeralds
		cmpi.b	#$4F,d4								; is the item an emerald?
		beq.s	.return								; if yes, branch
		cmpi.b	#$3A,d4								; is the item an emerald?
		blo.s	.set								; if not, branch
		cmpi.b	#$4B,d4								; is the item an emerald?
		bhs.s	.set								; if not, branch

.return
		rts
; ---------------------------------------------------------------------------

.set
		move.b	d4,playerspecial.touched_block(a0)
		move.l	a1,playerspecial.item_addr(a0)
		moveq	#-1,d5								; set flag to -1
		rts

; ---------------------------------------------------------------------------
; Player check items
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_ChkItems:

		; get block pos
		lea	(SpecialStage.buffer).l,a1
		moveq	#$50,d4
		add.w	y_pos(a0),d4
		divu.w	#$18,d4
		move.w	d4,d5
		moveq	#0,d4
		move.w	d5,d4
		lsl.l	#7,d4
		adda.l	d4,a1
		moveq	#$20,d4
		add.w	x_pos(a0),d4
		divu.w	#$18,d4
		adda.w	d4,a1

		; check touch
		move.b	(a1),d4								; get block id to d4
		bne.s	SpecialStagePlayer_ChkContinue					; if player is touch the block, branch

		; check ghost block
		tst.b	playerspecial.ghost_state(a0)
		bne.w	SpecialStagePlayer_MakeGhostSolid
		moveq	#0,d4								; set flag to 0
		rts
; ---------------------------------------------------------------------------

SpecialStagePlayer_ChkContinue:

		; check ring
		cmpi.b	#$3A,d4								; is the item a	ring?
		bne.s	SpecialStagePlayer_Chk1Up					; if not, branch

		; check
		bsr.w	SpecialStage_RemoveCollectedItem
		bne.s	.addring
		move.b	#1,(a2)
		move.l	a1,4(a2)

.addring
		addq.w	#1,(SpecialStage.ring_count).w					; add 1 to rings
		sfx	sfx_RingRight							; play ring sound

		; check continue
		cmpi.w	#50,(SpecialStage.ring_count).w					; does Sonic have at least 50 rings?
		blo.s	.perfect							; if not, branch
		bset	#0,(Extra_life_flags).w
		bne.s	.perfect
		addq.b	#1,(Continue_count).w						; add 1 to number of continues
		sfx	sfx_Continue							; play extra continue sound

.perfect

		; check perfect
		tst.w	(SpecialStage.rings_left).w
		beq.s	.nocontinue

		; update
		ori.b	#1,(Update_HUD_ring_count).w					; update ring counter
		cmpi.w	#1,(SpecialStage.rings_left).w
		beq.s	.resetHUD
		cmpi.w	#10,(SpecialStage.rings_left).w
		beq.s	.resetHUD
		cmpi.w	#100,(SpecialStage.rings_left).w
		bne.s	.updateHUD

.resetHUD
		move.b	#$80,(Update_HUD_ring_count).w					; update ring counter

.updateHUD
		subq.w	#1,(SpecialStage.rings_left).w
		bne.s	.nocontinue
		st	(HUD_RAM.status).w
		sfx	sfx_Perfect							; play perfect sound

.nocontinue
		moveq	#0,d4								; set flag to 0
		rts
; ---------------------------------------------------------------------------

SpecialStagePlayer_Chk1Up:

		; check "Extra Life" block
		cmpi.b	#$28,d4								; is the item an extra life?
		bne.s	SpecialStagePlayer_ChkEmerald					; if not, branch

		; check
		bsr.w	SpecialStage_RemoveCollectedItem
		bne.s	.get1up
		move.b	#3,(a2)
		move.l	a1,4(a2)

.get1up
		addq.b	#1,(Life_count).w						; add 1 to number of lives
		addq.b	#1,(Update_HUD_life_count).w					; update the lives counter
		music	mus_ExtraLife							; play the 1up song
		moveq	#0,d4								; set flag to 0
		rts
; ---------------------------------------------------------------------------

SpecialStagePlayer_ChkEmerald:

		; check emeralds
		cmpi.b	#$4F,d4								; is the item an emerald?
		beq.s	.emerald							; if yes, branch
		cmpi.b	#$3B,d4								; is the item an emerald?
		blo.s	SpecialStagePlayer_ChkGhost					; if not, branch
		cmpi.b	#$40,d4								; is the item an emerald?
		bhi.s	SpecialStagePlayer_ChkGhost					; if not, branch

.emerald

		; check
		bsr.w	SpecialStage_RemoveCollectedItem
		bne.s	.getemerald
		move.b	#5,(a2)
		move.l	a1,4(a2)

.getemerald

		; check
		cmpi.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w			; do you have all the emeralds?
		beq.s	.noemerald							; if yes, branch

		; get emerald
		moveq	#0,d0
		move.w	d0,(SpecialStage.spheres_left).w				; set 'Got'
		lea	(Collected_emeralds_array).w,a2
		move.b	(SpecialStage.saved_special_stage).w,d0
		bset	#0,(a2,d0.w)
		addq.b	#1,(Chaos_emerald_count).w					; add 1 to number of emeralds

.noemerald
		st	(HUD_RAM.status).w
		music	mus_Emerald							; play emerald music
		moveq	#0,d4								; set flag to 0
		rts
; ---------------------------------------------------------------------------

SpecialStagePlayer_ChkGhost:

		; check ghost block
		cmpi.b	#$41,d4								; is the item a	ghost block?
		bne.s	SpecialStagePlayer_ChkGhostTag					; if not, branch
		move.b	#1,playerspecial.ghost_state(a0)				; mark the ghost block as "passed"

SpecialStagePlayer_ChkGhostTag:

		; check ghost tag
		cmpi.b	#$4A,d4								; is the item a	switch for ghost blocks?
		bne.s	.noghost							; if not, branch

		; check
		cmpi.b	#1,playerspecial.ghost_state(a0)				; have the ghost blocks	been passed?
		bne.s	.noghost							; if not, branch
		move.b	#2,playerspecial.ghost_state(a0)				; mark the ghost blocks	as "solid"

.noghost
		moveq	#-1,d4								; set flag to -1
		rts
; ---------------------------------------------------------------------------

SpecialStagePlayer_MakeGhostSolid:

		; check ghost state
		cmpi.b	#2,playerspecial.ghost_state(a0)				; is the ghost marked as "solid"?
		bne.s	.ghostnotsolid							; if not, branch

		; find ghost solid
		lea	(SpecialStage.ghost_buffer).l,a2
		moveq	#-1,d0								; set RAM_start

.ghostloop
		move.w	(a2),d0								; get ghost solid address
		beq.s	.ghostnotsolid							; if there are no ghost solids, branch
		clr.w	(a2)+								; clear address

		; load ghost solid
		movea.l	d0,a1								; get address (RAM_start+$XXXX)

		; set
		move.b	#$2C,(a1)							; replace ghost block with a solid block

		; back
		bra.s	.ghostloop
; ---------------------------------------------------------------------------

.ghostnotsolid
		clr.b	playerspecial.ghost_state(a0)
		moveq	#0,d4								; set flag to 0
		rts

; ---------------------------------------------------------------------------
; Player check items 2
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpecialStagePlayer_ChkItems2:

		; check touch
		move.b	playerspecial.touched_block(a0),d0				; get block id to d0
		bne.s	SpecialStagePlayer_ChkBumper					; if player is touch the block, branch

		; check timer
		subq.b	#1,playerspecial.updown_timer(a0)				; decrement timer
		bpl.s	.next								; if time remains, branch
		clr.b	playerspecial.updown_timer(a0)					; no negative values allowed

.next
		subq.b	#1,playerspecial.reverse_timer(a0)				; decrement timer
		bpl.s	.return								; if time remains, branch
		clr.b	playerspecial.reverse_timer(a0)					; no negative values allowed

.return
		rts
; ---------------------------------------------------------------------------

SpecialStagePlayer_ChkBumper:

		; check bumper
		cmpi.b	#$25,d0								; is the item a bumper?
		bne.s	SpecialStagePlayer_GOAL						; if not, branch

		; player bounce
		move.l	playerspecial.item_addr(a0),d1
		subi.l	#(SpecialStage.buffer+1)&$FFFFFF,d1
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

		; check
		bsr.w	SpecialStage_RemoveCollectedItem
		bne.s	.sfx
		move.b	#2,(a2)
		move.l	playerspecial.item_addr(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

.sfx
		sfx	sfx_Bumper, 1							; play bumper sound
; ---------------------------------------------------------------------------

SpecialStagePlayer_GOAL:

		; check "GOAL"
		cmpi.b	#$27,d0								; is the item a	"GOAL"?
		bne.s	SpecialStagePlayer_UPblock					; if not, branch

		; exit from Special Stage
		addq.b	#2,routine(a0)							; run routine "SpecialStagePlayer_ExitStage"
		st	(HUD_RAM.status).w
		sfx	sfx_SSGoal, 1							; play "GOAL" sound
; ---------------------------------------------------------------------------

SpecialStagePlayer_UPblock:

		; check "UP" block
		cmpi.b	#$29,d0								; is the item an "UP" block?
		bne.s	SpecialStagePlayer_DOWNblock					; if not, branch

		; check timer
		tst.b	playerspecial.updown_timer(a0)					; is timer over?
		bne.w	SpecialStagePlayer_ChkGlass.return				; if not, branch
		move.b	#30,playerspecial.updown_timer(a0)				; reset timer

		; check
		btst	#6,(SpecialStage.speed+1).w
		beq.s	.sfx
		asl.w	(SpecialStage.speed).w						; increase stage rotation speed
		movea.l	playerspecial.item_addr(a0),a1
		subq.w	#1,a1
		move.b	#$2A,(a1)							; change item to a "DOWN" block

.sfx
		sfx	sfx_SSItem, 1							; play up/down sound
; ---------------------------------------------------------------------------

SpecialStagePlayer_DOWNblock:

		; check "DOWN" block
		cmpi.b	#$2A,d0								; is the item a	"DOWN" block?
		bne.s	SpecialStagePlayer_Rblock					; if not, branch

		; check timer
		tst.b	playerspecial.updown_timer(a0)					; is timer over?
		bne.w	SpecialStagePlayer_ChkGlass.return				; if not, branch
		move.b	#30,playerspecial.updown_timer(a0)				; reset timer

		; check
		btst	#6,(SpecialStage.speed+1).w
		bne.s	.sfx
		asr.w	(SpecialStage.speed).w						; reduce stage rotation speed
		movea.l	playerspecial.item_addr(a0),a1
		subq.w	#1,a1
		move.b	#$29,(a1)							; change item to an "UP" block

.sfx
		sfx	sfx_SSItem, 1							; play up/down sound
; ---------------------------------------------------------------------------

SpecialStagePlayer_Rblock:

		; check "R" block
		cmpi.b	#$2B,d0								; is the item an "R" block?
		bne.s	SpecialStagePlayer_ChkGlass					; if not, branch

		; check timer
		tst.b	playerspecial.reverse_timer(a0)					; is timer over?
		bne.s	SpecialStagePlayer_ChkGlass.return				; if not, branch
		move.b	#30,playerspecial.reverse_timer(a0)				; reset timer

		; check
		bsr.w	SpecialStage_RemoveCollectedItem
		bne.s	.revstage
		move.b	#4,(a2)
		move.l	playerspecial.item_addr(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

.revstage
		neg.w	(SpecialStage.speed).w						; reverse stage rotation
		sfx	sfx_SSItem, 1							; play sound
; ---------------------------------------------------------------------------

SpecialStagePlayer_ChkGlass:

		; check glass block
		cmpi.b	#$2D,d0								; is the item a	glass block?
		beq.s	.glass								; if yes, branch
		cmpi.b	#$2E,d0								; is the item a	glass block?
		beq.s	.glass								; if yes, branch
		cmpi.b	#$2F,d0								; is the item a	glass block?
		beq.s	.glass								; if yes, branch
		cmpi.b	#$30,d0								; is the item a	glass block?
		bne.s	.return								; if not, branch

.glass
		bsr.w	SpecialStage_RemoveCollectedItem
		bne.s	.sfx
		move.b	#6,(a2)
		movea.l	playerspecial.item_addr(a0),a1
		subq.w	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0								; change glass type when touched
		cmpi.b	#$30,d0
		bls.s	.glassupdate							; if glass is still there, branch
		clr.b	d0								; remove the glass block when it's destroyed

.glassupdate
		move.b	d0,4(a2)							; update the stage layout

.sfx
		sfx	sfx_SSGlass, 1							; play glass block sound
; ---------------------------------------------------------------------------

.return
		rts
