; ---------------------------------------------------------------------------
; Object 47 - pinball bumper (SYZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Bumper:

		; init
		movem.l	ObjDat_Bumper(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.b	#$17|collision_flags.npc.special,collision_flags(a0)

.hit
		tst.b	collision_property(a0)
		beq.s	.display
		lea	(Player_1).w,a1							; a1=character
		bclr	#0,collision_property(a0)					; has Sonic touched the bumper?
		beq.s	.p2								; if not, branch
		bsr.s	.bounce

.p2
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.reset								; if yes, branch
		bclr	#1,collision_property(a0)					; has Tails touched the bumper?
		beq.s	.reset								; if not, branch
		bsr.s	.bounce

.reset
		clr.b	collision_property(a0)

.display
		lea	Ani_Bump(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

.bounce
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		moveq	#3,d1
		and.b	(Level_frame_counter).w,d1
		add.w	d1,d0
		jsr	(GetSineCosine).w
		move.w	#-$700,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a1)

		; check
		cmpa.w	#Player_2,a1							; is this the second character?
		bne.s	.notcarry							; if not, branch
		tst.b	(Flying_carrying_Sonic_flag).w
		beq.s	.notcarry
		lea	(Player_1).w,a2							; a2=character
		clr.b	object_control(a2)
		clr.b	anim_frame(a2)
		clr.b	anim_frame_timer(a2)
		bset	#status.player.in_air,status(a2)
		clr.w	(Flying_carrying_Sonic_flag).w

.notcarry
		bset	#status.player.in_air,status(a1)
		bclr	#status.player.pushing,status(a1)
		btst	#status.player.rolling,status(a1)				; is the player rolling?
		bne.s	.notroll							; if yes, branch
		clr.b	anim(a1)							; AniIDSonAni_Walk

.notroll
		clr.b	jumping(a1)
		clr.b	double_jump_flag(a1)
		move.b	#1,anim(a0)							; use "hit" animation
		sfx	sfx_Bumper							; play bumper sound

		; add score
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.addscore							; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		cmpi.b	#10+$80,(a2)							; has bumper been hit 10 times? ($80(bit 7) = draw flag)
		bhs.s	.return								; if yes, Sonic gets no points
		addq.b	#1,(a2)

.addscore
		moveq	#1,d0
		jsr	(HUD_AddToScore).w						; add 10 to score

		; draw score
		lea	Child6_EndSignScore(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.return
		move.b	#4,mapping_frame(a1)

.return
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Bumper:		subObjMainData Obj_Bumper.hit, setBit(render_flags.level), 0, 32, 32, 1, $372, 0, 0, Map_Bump
; ---------------------------------------------------------------------------

		include "Objects/Environ/Bumper/Object Data/Anim - Bumper.asm"
		include "Objects/Environ/Bumper/Object Data/Map - Bumper.asm"
