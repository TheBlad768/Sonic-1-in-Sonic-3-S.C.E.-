; ---------------------------------------------------------------------------
; Super Stars (Object)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

superSonicKnux_stars =			*

.flag1				ds.b 1							; (1 byte)
.flag2				ds.b 1							; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SuperSonicKnux_Stars:

.artsize :=	(ArtUnc_SuperSonic_Stars_end-ArtUnc_SuperSonic_Stars)&$FFFF

		; load stars art
		QueueStaticDMA ArtUnc_SuperSonic_Stars,.artsize,tiles_to_bytes(ArtTile_Shield)

		; init
		movem.l	ObjDat_SuperSonicKnux_Stars(pc),d0-d3			; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; check priority
		btst	#high_priority_bit,(Player_1+art_tile).w			; is Sonic has high priority?
		beq.s	.main							; if not, branch
		bset	#high_priority_bit,art_tile(a0)					; stars have same priority as Sonic (high priority)

.main

		; check Super Sonic
		tst.b	(Super_Sonic_Knux_flag).w					; is Sonic Super/Hyper?
		beq.s	.delete								; if not, delete
		tst.b	superSonicKnux_stars.flag1(a0)
		beq.s	.checkspeed

		; wait
		subq.b	#1,anim_frame_timer(a0)						; subtract 1 from frame duration
		bpl.s	.check								; if time remains, branch
		addq.b	#1+1,anim_frame_timer(a0)					; set frame duration

		; next
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#6,mapping_frame(a0)
		blo.s	.check

		; set
		clr.b	mapping_frame(a0)
		move.w	#bytes_to_word(0,1),superSonicKnux_stars.flag1(a0)		; clear superSonicKnux_stars.flag1 and set superSonicKnux_stars.flag2
		rts
; ---------------------------------------------------------------------------

.check
		tst.b	superSonicKnux_stars.flag2(a0)
		bne.s	.draw

.copyxypos

		; get xypos
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

.checkspeed

		; check player move
		tst.b	(Player_1+object_control).w
		bne.s	.reset
		mvabs.w	(Player_1+ground_vel).w,d0
		cmpi.w	#$800,d0							; is the player moving slowly?
		blo.s	.reset								; if he is, branch

		; set
		clr.b	mapping_frame(a0)
		move.b	#1,superSonicKnux_stars.flag1(a0)				; set superSonicKnux_stars.flag1
		bra.s	.copyxypos
; ---------------------------------------------------------------------------

.reset
		clr.w	superSonicKnux_stars.flag1(a0)					; clear superSonicKnux_stars.flag1 and superSonicKnux_stars.flag2
		rts

; ---------------------------------------------------------------------------
; Hyper Stars (Object)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset aniraw_ptr								; pretend we're in the RAM

hyperSonic_stars =			*

.xdiff				ds.w 1							; (2 bytes)
.ydiff				ds.w 1							; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_HyperSonic_Stars:

.artsize :=	(ArtUnc_HyperSonicStars_end-ArtUnc_HyperSonicStars)&$FFFF

		; load stars art
		QueueStaticDMA ArtUnc_HyperSonicStars,.artsize,tiles_to_bytes(ArtTile_Shield)

.scount =	4										; number of stars

		; load
		lea	(a0),a1
		moveq	#0,d0
		moveq	#0,d2
		moveq	#.scount-1,d1

.createObject
		move.l	#.init,address(a1)
		move.b	d0,angle(a1)
		addi.b	#256/.scount,d0							; 90 degrees
		addq.b	#1,d2
		move.b	d2,anim_frame_timer(a1)
		lea	next_object(a1),a1
		dbf	d1,.createObject

.init

		; wait
		subq.b	#1,anim_frame_timer(a0)						; subtract 1 from frame duration
		beq.s	.load								; if timer has run out, branch
		rts
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

.load

		; init
		movem.l	ObjDat_HyperSonic_Stars(pc),d0-d3			; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		move.b	#6,mapping_frame(a0)

		; check main object
		cmpa.w	#Invincibility_stars,a0
		bne.s	.child
		move.l	#.main,address(a0)

.main

		; check Hyper Sonic Jump Dash
		tst.b	anim(a0)							; did Sonic use a Jump Dash?
		beq.s	.child								; if not, branch
		clr.b	anim(a0)

		; get xypos
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)
		moveq	#2,d2
		bsr.w	Obj_LightningShield_Create_Spark.part2
		move.b	#4,(Hyper_Sonic_flash_timer).w					; set screen flash time

.child

		; check Super Sonic
		tst.b	(Super_Sonic_Knux_flag).w					; is Sonic Super/Hyper?
		beq.s	.delete								; if not, delete

		; wait
		subq.b	#1,anim_frame_timer(a0)						; subtract 1 from frame duration
		bpl.s	.move								; if time remains, branch
		addq.b	#1+1,anim_frame_timer(a0)					; set frame duration

		; next
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		blo.s	.move

		; reset
		moveq	#0,d0
		move.b	d0,mapping_frame(a0)
		move.w	d0,hyperSonic_stars.xdiff(a0)
		move.w	d0,hyperSonic_stars.ydiff(a0)

.move
		move.b	angle(a0),d0							; angle
		addi.b	#-$10,angle(a0)
		jsr	(GetSineCosine).w
		asl.w	#3,d0
		asl.w	#3,d1
		movem.w	d0-d1,x_vel(a0)							; set xvel and yvel

		move.w	x_vel(a0),d0
		add.w	d0,hyperSonic_stars.xdiff(a0)
		move.w	y_vel(a0),d1
		add.w	d1,hyperSonic_stars.ydiff(a0)

		move.b	hyperSonic_stars.xdiff(a0),d2
		ext.w	d2

		; check player xflip
		btst	#status.player.x_flip,(Player_1+status).w
		beq.s	.notflipx
		neg.w	d2

.notflipx
		move.b	hyperSonic_stars.ydiff(a0),d3
		ext.w	d3
		add.w	(Player_1+x_pos).w,d2
		add.w	(Player_1+y_pos).w,d3
		move.w	d2,x_pos(a0)
		move.w	d3,y_pos(a0)

		; check
		andi.w	#drawing_mask,art_tile(a0)
		tst.b	(Player_1+art_tile).w
		bpl.s	.draw
		ori.w	#high_priority,art_tile(a0)

.draw
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_SuperSonicKnux_Stars:		subObjMainData \
				Obj_SuperSonicKnux_Stars.main, \
					setBit(render_flags.level), \
				0, 48, 48, 1, ArtTile_Shield, 0, FALSE, Map_SuperSonic_Stars

ObjDat_HyperSonic_Stars:		subObjMainData \
				Obj_HyperSonic_Stars.child, \
					setBit(render_flags.level), \
				0, 48, 48, 1, ArtTile_Shield, 0, FALSE, Map_HyperSonicStars
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Players/Transform/Object Data/Map - Super Sonic Stars.asm"
		include "Objects/Players/Transform/Object Data/Map - Hyper Sonic Stars.asm"
