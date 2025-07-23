; ---------------------------------------------------------------------------
; Water Splash (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_WaterSplash:

		; init
		st	objoff_31(a0)
		movem.l	ObjDat_WaterSplash(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		move.w	#2,mainspr_childsprites(a0)

		; set
		lea	sub2_x_pos(a0),a2						; $16-$23 bytes reserved
		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)+
		move.w	#bytes_to_word(0,5),(a2)+
		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)+
		move.w	#bytes_to_word(5,5),(a2)+

.main
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Water_level).w,y_pos(a0)
		bsr.s	sub_38534
		tst.b	status(a0)
		beq.s	loc_384F8
		move.b	(Level_frame_counter+1).w,d0
		addq.b	#2,d0
		andi.b	#$F,d0
		bne.s	loc_384DA
		sfx	sfx_WaterSkid							; play water skid sound

loc_384DA:

		; wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	loc_384F8
		addq.b	#2+1,anim_frame_timer(a0)

		; next
		addq.b	#1,objoff_30(a0)
		cmpi.b	#5,objoff_30(a0)
		blo.s	loc_384F8
		clr.b	objoff_30(a0)

loc_384F8:
		moveq	#0,d1
		move.b	objoff_30(a0),d1
		cmp.b	objoff_31(a0),d1
		beq.s	.draw
		move.b	d1,objoff_31(a0)
		lsl.w	#6,d1								; multiply by $180/2
		move.w	d1,d0
		add.w	d0,d0
		add.w	d0,d1
		addi.l	#dmaSource(ArtUnc_WaterSplash),d1				; get next frame
		move.w	#tiles_to_bytes($36E),d2					; load art destination

		; size of art (in words) ; we only need one frame
		move.w	#tiles_to_bytes( \
		dmaLength(12) \
		),d3

		jsr	(Add_To_DMA_Queue).w

.draw
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_38534:

		; check the player's running on water
		lea	(Player_1).w,a1							; a1=character
		lea	sub2_x_pos(a0),a2
		moveq	#p1_standing_bit,d6
		move.w	(Ctrl_1_logical).w,d5
		bsr.s	.control

		; check
		bclr	#render_flags.x_flip,render_flags(a0)
		btst	#status.player.x_flip,status(a1)
		beq.s	.notflipx
		bset	#render_flags.x_flip,render_flags(a0)

.notflipx
		lea	(Player_2).w,a1							; a1=character
		lea	sub3_x_pos(a0),a2
		moveq	#p2_standing_bit,d6
		move.w	(Ctrl_2_logical).w,d5
		bsr.s	.control

		; check
		move.b	render_flags(a0),d0
		add.b	status(a1),d0
		andi.b	#1,d0
		beq.s	.return
		move.b	#5,sub3_mapframe-sub3_x_pos(a2)

.return
		rts

; =============== S U B R O U T I N E =======================================

.control
		btst	d6,status(a0)
		bne.s	loc_385D2
		tst.w	y_vel(a1)
		bne.s	locret_385D0
		moveq	#0,d1
		move.b	y_radius(a1),d1
		add.w	y_pos(a1),d1
		addq.w	#1,d1
		cmp.w	(Water_level).w,d1
		bne.s	locret_385D0
		mvabs.w	x_vel(a1),d0
		cmpi.w	#$700,d0
		blo.s	locret_385D0
		bset	d6,status(a0)
		move.w	x_pos(a1),sub2_x_pos-sub2_x_pos(a2)
		move.w	(Water_level).w,sub2_y_pos-sub2_x_pos(a2)
		clr.b	sub2_mapframe-sub2_x_pos(a2)
		bclr	#status.player.x_flip,status(a1)
		tst.w	x_vel(a1)
		bpl.s	locret_385D0
		bset	#status.player.x_flip,status(a1)

locret_385D0:
		rts
; ---------------------------------------------------------------------------

loc_385D2:
		move.w	d5,d0
		andi.w	#btnABC,d0
		bne.s	loc_38652
		move.w	(Water_level).w,d0
		moveq	#0,d1
		move.b	y_radius(a1),d1
		sub.w	d1,d0
		subq.w	#1,d0
		cmp.w	y_pos(a1),d0
		bhi.s	loc_38646
		mvabs.w	x_vel(a1),d1
		cmpi.w	#$700,d1
		blo.s	loc_38646
		move.w	d0,y_pos(a1)
		clr.w	y_vel(a1)
		move.w	x_pos(a1),sub2_x_pos-sub2_x_pos(a2)
		move.w	(Water_level).w,sub2_y_pos-sub2_x_pos(a2)

		; check
		btst	#status.player.in_air,status(a1)				; is the player in the air?
		beq.s	locret_38636							; if not, branch
		andi.w	#bytes_to_word(btnLR,0),d5
		bne.s	locret_38636

		; player move
		moveq	#$C,d1
		move.w	x_vel(a1),d0
		beq.s	loc_38646
		bmi.s	loc_38638
		sub.w	d1,d0
		bhs.s	loc_38632
		moveq	#0,d0

loc_38632:
		move.w	d0,x_vel(a1)

locret_38636:
		rts
; ---------------------------------------------------------------------------

loc_38638:
		add.w	d1,d0
		bhs.s	loc_38640
		moveq	#0,d0

loc_38640:
		move.w	d0,x_vel(a1)
		rts
; ---------------------------------------------------------------------------

loc_38646:
		bclr	d6,status(a0)
		move.b	#5,sub2_mapframe-sub2_x_pos(a2)
		rts
; ---------------------------------------------------------------------------

loc_38652:
		bclr	d6,status(a0)
		move.b	#5,sub2_mapframe-sub2_x_pos(a2)
		move.w	#-$680,y_vel(a1)
		bset	#status.player.in_air,status(a1)
		move.b	#1,jumping(a1)
		move.w	#bytes_to_word(28/2,14/2),y_radius(a1)				; set y_radius and x_radius
		move.b	#AniIDSonAni_Roll,anim(a1)
		bset	#status.player.rolling,status(a1)
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_WaterSplash:	subObjMainData \
			Obj_WaterSplash.main, \
				setBit(render_flags.level) | \
				setBit(render_flags.multi_sprite), \
			0, 256, 320, 6, $36E, 0, 0, Map_WaterSplash
; ---------------------------------------------------------------------------

		include "Objects/Main/Water Splash/Object Data/Map - Water Splash.asm"
