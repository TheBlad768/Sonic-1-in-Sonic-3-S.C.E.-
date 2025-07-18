; ---------------------------------------------------------------------------
; Tails tail (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Tails_Tail:

		; init
		move.l	#Map_Tails_Tail,mappings(a0)
		move.w	#make_art_tile(ArtTile_Player_2_Tail,0,0),d0			; normal
		cmpi.b	#GameModeID_SpecialStageScreen,(Game_mode).w			; is game mode Special Stage?
		bne.s	.notspecial							; if not, branch
		move.w	#make_art_tile($7AC,0,0),d0					; Special Stage

.notspecial
		move.w	d0,art_tile(a0)
		move.l	#bytes_to_long(setBit(render_flags.level),0,48/2,48/2),render_flags(a0)		; set screen coordinates flag and height and width
		move.l	#.main,address(a0)

.main

		; here, several SSTs are inheritied from the parent, normally Tails
		movea.w	objoff_30(a0),a2						; a2=character
		move.b	angle(a2),angle(a0)
		move.b	status(a2),status(a0)
		move.w	x_pos(a2),x_pos(a0)
		move.w	y_pos(a2),y_pos(a0)
		move.w	priority(a2),priority(a0)
		andi.w	#drawing_mask,art_tile(a0)
		tst.w	art_tile(a2)
		bpl.s	.nothighpriority
		ori.w	#high_priority,art_tile(a0)

.nothighpriority
		moveq	#0,d0
		move.b	anim(a2),d0
		btst	#status.player.pushing,status(a2)
		beq.s	.check
		tst.b	(WindTunnel_flag_P2).w
		bne.s	.check

		; this is checking if parent (Tails) is in its pushing animation
		cmpi.b	#$A9,mapping_frame(a2)
		blo.s	.check
		cmpi.b	#$AC,mapping_frame(a2)
		bhi.s	.check
		moveq	#4,d0

.check
		cmp.b	objoff_34(a0),d0						; has the input parent anim changed since last check?
		beq.s	.prev								; if not, branch and skip setting a matching Tails' Tails anim
		move.b	d0,objoff_34(a0)						; store d0 for the above comparision
		move.b	.aniselection(pc,d0.w),anim(a0)					; load anim relative to parent's

.prev
		lea	(AniTails_Tail).l,a1
		bsr.w	Animate_Tails_Part2
		tst.b	(Reverse_gravity_flag).w
		beq.s	.dplc
		cmpi.b	#3,anim(a0)							; is this the Directional animation?
		beq.s	.dplc								; if so, skip the mirroring
		eori.b	#setBit(render_flags.y_flip),render_flags(a0)			; reverse the vertical mirror render_flag bit (On if Off beforehand and vice versa)

.dplc
		bsr.w	Tails_Tail_Load_PLC
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; animation master script table for the tails
; chooses which animation script to run depending on what Tails is doing
; ---------------------------------------------------------------------------

.aniselection
		dc.b 0		; TailsAni_Walk		->				; 0
		dc.b 0		; Run			->				; 1
		dc.b 3		; TailsAni_Roll		-> Directional			; 2
		dc.b 3		; TailsAni_Roll2	-> Directional			; 3
		dc.b 9		; TailsAni_Push		-> Pushing			; 4
		dc.b 1		; TailsAni_Wait		-> Swish			; 5
		dc.b 0		; TailsAni_Balance	-> Blank			; 6
		dc.b 2		; TailsAni_LookUp	-> Flick			; 7
		dc.b 1		; TailsAni_Duck		-> Swish			; 8
		dc.b 7		; TailsAni_Spindash	-> Spindash			; 9
		dc.b 0		; TailsAni_Dummy1	->				; A
		dc.b 0		; TailsAni_Dummy2	->				; B
		dc.b 0		; TailsAni_Dummy3	->				; C
		dc.b 8		; TailsAni_Stop		-> Skidding			; D
		dc.b 0		; TailsAni_Float1	->				; E
		dc.b 0		; TailsAni_Float2	->				; F
		dc.b 0		; TailsAni_Spring	->				; 10
		dc.b 0		; TailsAni_Hang		->				; 11
		dc.b 0		; (Unused?)						; 12
		dc.b 0		; TailsAni_Victory	->				; 13
		dc.b $A		; TailsAni_Hang2	-> Hanging			; 14
		dc.b 0		; TailsAni_Bubble	->				; 15
		dc.b 0		; TailsAni_Death1	->				; 16
		dc.b 0		; TailsAni_Death2	->				; 17
		dc.b 0		; TailsAni_Death3	->				; 18
		dc.b 0		; TailsAni_Hurt		->				; 19
		dc.b 0		; TailsAni_Hurt2	->				; 1A
		dc.b 0		; TailsAni_Slide	->				; 1B
		dc.b 0		; TailsAni_Blank	->				; 1C
		dc.b 0		; TailsAni_Dummy4	->				; 1D
		dc.b 0		; TailsAni_Dummy5	->				; 1E
		dc.b 0		; TailsAni_HaulAss	->				; 1F
		dc.b $B		; TailsAni_Fly		-> Fly1				; 20
		dc.b $C		; TailsAni_Fly2		-> Fly2				; 21
		dc.b $B		; TailsAni_Carry	-> Fly1				; 22
		dc.b $C		; TailsAni_Ascend	-> Fly2				; 23
		dc.b $B		; TailsAni_Tired	-> Fly1				; 24
		dc.b 0		; TailsAni_Swim		->				; 25
		dc.b 0		; TailsAni_Swim2	->				; 26
		dc.b 0		; TailsAni_Tired2	->				; 27
		dc.b 0		; TailsAni_Tired3	->				; 28
		dc.b 0									; 29
		dc.b 0									; 2A
		dc.b 0									; 2B
		dc.b 0									; 2C
		dc.b 0									; 2D
		dc.b 0									; 2E
		dc.b 0									; 2F
		dc.b 0									; 30
		dc.b 0									; 31
	even
