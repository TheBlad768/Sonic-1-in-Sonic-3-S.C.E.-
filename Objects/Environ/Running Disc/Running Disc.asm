; ---------------------------------------------------------------------------
; Object 67 - disc that you run around (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

; players
runningdisc_p1_attached =		*
runningdisc_p1_attached.touch		ds.b 1						; (1 byte)
runningdisc_p2_attached =		*
runningdisc_p2_attached.touch		ds.b 1						; (1 byte)

; main
runningdisc.origX			ds.w 1						; original x-axis position (2 bytes)
runningdisc.origY			ds.w 1						; original y-axis position (2 bytes)
runningdisc.distance			ds.w 1						; distance (2 bytes)
runningdisc.speed			ds.w 1						; speed (2 bytes)
runningdisc.radius			ds.w 1						; radius of circle, square radius (2 bytes)
runningdisc.radius_circle		ds.l 1						; radius of circle, circle radius  (4 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_RunningDisc:

		; set circular
		move.b	#24,runningdisc.distance(a0)					; set radius circular
		moveq	#144/2,d2							; radius of circle
		move.b	subtype.byte(a0),d0						; get object type
		move.b	d0,d1								; save object type
		andi.b	#$F,d0								; read only the 2nd digit
		beq.s	.typeis0							; branch if 0
		move.b	#16,runningdisc.distance(a0)					; set radius circular
		moveq	#112/2,d2							; radius of circle

.typeis0
		andi.b	#$F0,d1								; read only the 1st digit
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,runningdisc.speed(a0)
		move.b	status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,angle(a0)

		; set radius of circle, circle radius
		move.b	d2,runningdisc.radius(a0)
		subq.w	#1,d2
		mulu.w	d2,d2
		move.l	d2,runningdisc.radius_circle(a0)

		; init
		movem.l	ObjDat_RunningDisc(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	x_pos(a0),runningdisc.origX(a0)
		move.w	y_pos(a0),runningdisc.origY(a0)

.action

		; player 1
		lea	runningdisc_p1_attached(a0),a2
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.p2								; if yes, branch
		lea	(Player_1).w,a1							; a1=character
		bsr.s	Disc_MovePlayer

.p2

		; player 2
		addq.w	#runningdisc_p2_attached-runningdisc_p1_attached,a2
		lea	(Player_2).w,a1							; a1=character
		tst.l	code_addr(a1)							; is player RAM empty?
		beq.s	.notp2								; if yes, branch
		bsr.s	Disc_MovePlayer

.notp2

		; circular
		move.w	runningdisc.speed(a0),d0
		add.w	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	runningdisc.distance(a0),d2
		move.w	d2,d3
		muls.w	d0,d2
		swap	d2
		muls.w	d1,d3
		swap	d3
		move.w	runningdisc.origY(a0),d0
		add.w	d2,d0
		move.w	d0,y_pos(a0)							; move object circularly
		move.w	runningdisc.origX(a0),d1
		add.w	d3,d1
		move.w	d1,x_pos(a0)

		; draw and delete
		moveq	#-$80,d0							; round down to nearest $80
		and.w	runningdisc.origX(a0),d0					; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

Disc_MovePlayer:
		move.w	runningdisc.radius(a0),d2
		move.w	d2,d3
		add.w	d3,d3								; multiply by 2

		; check square radius
		move.w	x_pos(a1),d0
		sub.w	runningdisc.origX(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bhs.s	.loc_3291A
		move.w	y_pos(a1),d1
		sub.w	runningdisc.origY(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1
		bhs.s	.loc_3291A

		; check circle radius
		sub.w	d2,d0								; fix by Flamewing
		sub.w	d2,d1
		muls.w	d0,d0
		muls.w	d1,d1
		add.l	d0,d1
		cmp.l	runningdisc.radius_circle(a0),d1
		bhs.s	.loc_3291A
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		beq.s	.loc_32926							; if not, branch

.loc_3291A
		tst.b	runningdisc_p1_attached.touch-runningdisc_p1_attached(a2)
		beq.s	.locret_32924
		clr.b	stick_to_convex(a1)
		clr.b	runningdisc_p1_attached.touch-runningdisc_p1_attached(a2)

.locret_32924
		rts
; ---------------------------------------------------------------------------

.loc_32926
		tst.b	runningdisc_p1_attached.touch-runningdisc_p1_attached(a2)
		bne.s	.loc_3294C
		st	runningdisc_p1_attached.touch-runningdisc_p1_attached(a2)

		; check rolling
		btst	#status.player.rolling,status(a1)
		bne.s	.loc_3293A
		clr.b	anim(a1)							; AniIDSonAni_Walk

.loc_3293A
		bclr	#status.player.pushing,status(a1)
		move.b	#AniIDSonAni_Run,prev_anim(a1)
		st	stick_to_convex(a1)

.loc_3294C
		move.w	ground_vel(a1),d0
		tst.w	runningdisc.speed(a0)
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

; init
ObjDat_RunningDisc:	subObjMainData \
				Obj_RunningDisc.action, \
					setBit(render_flags.level) | \
					setBit(render_flags.static_mappings), \
				0, 16, 16, 4, 0, 0, FALSE, Map_RunningDisc
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Running Disc/Object Data/Map - Running Disc.asm"
