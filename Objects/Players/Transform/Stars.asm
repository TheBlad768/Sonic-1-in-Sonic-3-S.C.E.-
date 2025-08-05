; ---------------------------------------------------------------------------
; Super Stars (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SuperSonicKnux_Stars:

.artsize	:= (ArtUnc_SuperSonic_Stars_end-ArtUnc_SuperSonic_Stars)&$FFFF

		; load stars art
		QueueStaticDMA ArtUnc_SuperSonic_Stars,.artsize,tiles_to_bytes(ArtTile_Shield)

		; init
		move.l	#Map_SuperSonic_Stars,mappings(a0)

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_1, \
			make_art_tile(ArtTile_Shield,0,0) \
		),priority(a0)

		; set screen coordinates flag and height and width
		move.l	#bytes_to_long( \
			setBit(render_flags.level), \
		0,48/2,48/2 \
		),render_flags(a0)

		; check priority
		btst	#high_priority_bit,(Player_1+art_tile).w			; is Sonic has high priority?
		beq.s	.nothighpriority						; if not, branch
		bset	#high_priority_bit,art_tile(a0)					; stars have same priority as Sonic (high priority)

.nothighpriority
		move.l	#.main,address(a0)

.main

		; check
		tst.b	(Super_Sonic_Knux_flag).w
		beq.s	loc_19230
		tst.b	objoff_34(a0)
		beq.s	loc_19200

		; wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	loc_191E8
		addq.b	#1+1,anim_frame_timer(a0)

		; next
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#6,mapping_frame(a0)
		blo.s	loc_191E8
		clr.b	mapping_frame(a0)

		; set
		move.w	#bytes_to_word(0,1),objoff_34(a0)
		rts
; ---------------------------------------------------------------------------

loc_191E8:
		tst.b	objoff_35(a0)
		bne.s	loc_191FA

loc_191EE:
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)

loc_191FA:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_19200:
		tst.b	(Player_1+object_control).w
		bne.s	loc_19222
		mvabs.w	(Player_1+ground_vel).w,d0
		cmpi.w	#$800,d0
		blo.s	loc_19222
		clr.b	mapping_frame(a0)
		move.b	#1,objoff_34(a0)
		bra.s	loc_191EE
; ---------------------------------------------------------------------------

loc_19222:
		clr.w	objoff_34(a0)
		rts
; ---------------------------------------------------------------------------

loc_19230:
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Hyper Stars (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_HyperSonic_Stars:

.artsize	:= (ArtUnc_HyperSonicStars_end-ArtUnc_HyperSonicStars)&$FFFF

		; load stars art
		QueueStaticDMA ArtUnc_HyperSonicStars,.artsize,tiles_to_bytes(ArtTile_Shield)

		; load
		lea	(a0),a1
		moveq	#0,d0
		moveq	#0,d2
		moveq	#4-1,d1

.createObject
		move.l	#Obj_HyperSonic_Stars_Init,address(a1)
		move.b	d0,angle(a1)
		addi.b	#256/4,d0							; 90 degrees
		addq.b	#1,d2
		move.b	d2,anim_frame_timer(a1)
		lea	next_object(a1),a1
		dbf	d1,.createObject

Obj_HyperSonic_Stars_Init:

		; wait for art to finish loading before we display
		tst.w	(KosPlus_modules_left).w
		beq.s	.artDoneLoading

.return
		rts
; ---------------------------------------------------------------------------

.artDoneLoading

		; wait
		subq.b	#1,anim_frame_timer(a0)
		bne.s	.return

		; init
		move.l	#Map_HyperSonicStars,mappings(a0)

		; set priority and art_tile
		move.l	#words_to_long( \
		priority_1, \
			make_art_tile(ArtTile_Shield,0,0) \
		),priority(a0)

		; set screen coordinates flag and height and width
		move.l	#bytes_to_long( \
			setBit(render_flags.level), \
		0,48/2,48/2 \
		),render_flags(a0)

		move.b	#6,mapping_frame(a0)
		cmpa.w	#Invincibility_stars,a0
		beq.s	.isParent
		move.l	#Obj_HyperSonic_Stars_Main.child,address(a0)
		bra.s	Obj_HyperSonic_Stars_Main.child
; ---------------------------------------------------------------------------

.isParent
		move.l	#Obj_HyperSonic_Stars_Main,address(a0)

Obj_HyperSonic_Stars_Main:
		tst.b	anim(a0)
		beq.s	.child
		clr.b	anim(a0)
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)
		moveq	#2,d2
		bsr.w	Obj_LightningShield_Create_Spark.part2
		move.b	#4,(Hyper_Sonic_flash_timer).w

.child
		tst.b	(Super_Sonic_Knux_flag).w
		beq.w	loc_19486

		; wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	loc_1941C
		addq.b	#1+1,anim_frame_timer(a0)

		; next
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		blo.s	loc_1941C
		moveq	#0,d0
		move.b	d0,mapping_frame(a0)
		move.w	d0,objoff_30(a0)
		move.w	d0,objoff_34(a0)

loc_1941C:
		move.b	angle(a0),d0
		addi.b	#-$10,angle(a0)
		jsr	(GetSineCosine).w
		asl.w	#3,d0
		asl.w	#3,d1
		move.w	d0,x_vel(a0)
		move.w	d1,y_vel(a0)
		move.w	x_vel(a0),d0
		add.w	d0,objoff_30(a0)
		move.w	y_vel(a0),d1
		add.w	d1,objoff_34(a0)
		move.b	objoff_30(a0),d2
		ext.w	d2
		btst	#status.player.x_flip,(Player_1+status).w
		beq.s	loc_19458
		neg.w	d2

loc_19458:
		move.b	objoff_34(a0),d3
		ext.w	d3
		add.w	(Player_1+x_pos).w,d2
		add.w	(Player_1+y_pos).w,d3
		move.w	d2,x_pos(a0)
		move.w	d3,y_pos(a0)
		andi.w	#drawing_mask,art_tile(a0)
		tst.b	(Player_1+art_tile).w
		bpl.s	loc_19480
		ori.w	#high_priority,art_tile(a0)

loc_19480:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_19486:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

		include "Objects/Players/Transform/Object Data/Map - Super Sonic Stars.asm"
		include "Objects/Players/Transform/Object Data/Map - Hyper Sonic Stars.asm"
