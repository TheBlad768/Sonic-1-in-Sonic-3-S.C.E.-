; ---------------------------------------------------------------------------
; Object 67 - disc that you run around (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
disc_origX			= objoff_32	; original x-axis position (2 bytes)
disc_origY			= objoff_30	; original y-axis position (2 bytes)
disc_radius			= objoff_34	; radius of circle (2 bytes)
disc_player_attached		= objoff_36	; (2 bytes)
disc_spot_distance		= objoff_3A	; radius circular (2 bytes)
disc_speed			= objoff_40	; speed (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_RunningDisc:

		; set circular
		move.b	#24,disc_spot_distance(a0)					; set radius circular
		move.b	#144/2,disc_radius(a0)
		move.b	subtype(a0),d0							; get object type
		move.b	d0,d1								; save object type
		andi.b	#$F,d0								; read only the 2nd digit
		beq.s	.typeis0							; branch if 0
		move.b	#16,disc_spot_distance(a0)					; set radius circular
		move.b	#112/2,disc_radius(a0)

.typeis0
		andi.b	#$F0,d1								; read only the 1st digit
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,disc_speed(a0)
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,angle(a0)

		; init
		movem.l	ObjDat_RunningDisc(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	x_pos(a0),disc_origX(a0)
		move.w	y_pos(a0),disc_origY(a0)

.action

		; player 1
		lea	disc_player_attached(a0),a2
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.p2								; if yes, branch
		lea	(Player_1).w,a1							; a1=character
		bsr.s	Disc_MovePlayer

.p2

		; player 2
		addq.w	#1,a2								; disc_player_attached+1
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.notp2								; if yes, branch
		bsr.s	Disc_MovePlayer

.notp2

		; circular
		move.w	disc_speed(a0),d0
		add.w	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	disc_spot_distance(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	disc_origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)							; move object circularly
		move.w	disc_origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	disc_origX(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

Disc_MovePlayer:
		moveq	#0,d2
		move.b	disc_radius(a0),d2
		move.w	d2,d3
		add.w	d3,d3
		move.w	x_pos(a1),d0
		sub.w	disc_origX(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bhs.s	.loc_3291A
		move.w	y_pos(a1),d1
		sub.w	disc_origY(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1
		bhs.s	.loc_3291A
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		beq.s	.loc_32926							; if not, branch
		clr.b	(a2)
		rts
; ---------------------------------------------------------------------------

.loc_3291A
		tst.b	(a2)
		beq.s	.locret_32924
		clr.b	stick_to_convex(a1)
		clr.b	(a2)

.locret_32924
		rts
; ---------------------------------------------------------------------------

.loc_32926
		tst.b	(a2)
		bne.s	.loc_3294C
		move.b	#1,(a2)
		btst	#status.player.rolling,status(a1)
		bne.s	.loc_3293A
		clr.b	anim(a1)							; AniIDSonAni_Walk

.loc_3293A
		bclr	#status.player.pushing,status(a1)
		move.b	#AniIDSonAni_Run,prev_anim(a1)
		st	stick_to_convex(a1)

.loc_3294C
		move.w	ground_vel(a1),d0
		tst.w	disc_speed(a0)
		bpl.s	.loc_32974
		cmpi.w	#-$400,d0
		ble.s	.loc_32966
		move.w	#-$400,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------

.loc_32966
		cmpi.w	#-$F00,d0
		bge.s	.locret_32972
		move.w	#-$F00,ground_vel(a1)

.locret_32972
		rts
; ---------------------------------------------------------------------------

.loc_32974
		cmpi.w	#$400,d0
		bge.s	.loc_32982
		move.w	#$400,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------

.loc_32982
		cmpi.w	#$F00,d0
		ble.s	.locret_3298E
		move.w	#$F00,ground_vel(a1)

.locret_3298E
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_RunningDisc:	subObjMainData Obj_RunningDisc.action, setBit(render_flags.level)|setBit(render_flags.static_mappings), 0, 16, 16, 4, 0, 0, 0, Map_Disc
; ---------------------------------------------------------------------------

		include "Objects/Environ/Running Disc/Object Data/Map - Running Disc.asm"
