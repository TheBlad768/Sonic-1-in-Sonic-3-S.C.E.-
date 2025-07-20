; ---------------------------------------------------------------------------
; Object 3C - smashable wall (GHZ, SLZ)
; ---------------------------------------------------------------------------

; Options
_BWALL_KNUX_			= 0	; if 1, change the animation of Knuckles after breaking the wall

; =============== S U B R O U T I N E =======================================

Obj_BreakableWall:

		; init
		movem.l	ObjDat_BreakableWall(pc),d0-d3					; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; is level Star Light Zone?
		bne.s	.notSLZ								; if not, branch
		move.w	#make_art_tile($414,2,0),art_tile(a0)

.notSLZ
		move.b	subtype(a0),mapping_frame(a0)
		move.l	#BreakableWall_FragSpd1,objoff_34(a0)				; right
		move.l	#BreakableWall_FragSpd2,objoff_38(a0)				; left

.main
		move.w	(Player_1+x_vel).w,objoff_30(a0)
		move.w	(Player_2+x_vel).w,objoff_32(a0)
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		swap	d6
		andi.w	#touch_side_mask,d6
		bne.s	loc_215B2

loc_215AC:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

loc_215B2:
		lea	(Player_1).w,a1							; a1=character
		move.w	objoff_30(a0),d1
		move.w	d6,d0
		andi.w	#p1_touch_side,d0
		beq.s	loc_2162A
		tst.b	(Super_Sonic_Knux_flag).w
		bne.s	loc_215F4
		cmpi.b	#PlayerID_Knuckles,character_id(a1)				; is player Knuckles?
		beq.s	loc_215F4							; if yes, branch
		btst	#shield_reaction.fire_shield,shield_reaction(a1)
		bne.s	loc_215E0
		btst	#p1_pushing_bit,status(a0)
		beq.s	loc_2162A

loc_215E0:
		cmpi.b	#AniIDSonAni_Roll,anim(a1)
		bne.s	loc_2162A
		mvabs.w	d1,d0
		cmpi.w	#$480,d0
		blo.s	loc_2162A

loc_215F4:
		bclr	#p1_pushing_bit,status(a0)
		bsr.s	Obj_BreakableWall_CreateFragments
		btst	#p2_pushing_bit,status(a0)
		beq.s	loc_215AC
		lea	(Player_2).w,a1							; a1=character
		cmpi.b	#AniIDSonAni_Roll,anim(a1)
		bne.s	loc_215AC
		move.w	objoff_32(a0),x_vel(a1)
		move.w	x_vel(a1),ground_vel(a1)
		bclr	#p2_pushing_bit,status(a0)
		bclr	#status.player.pushing,status(a1)
		bra.s	loc_215AC
; ---------------------------------------------------------------------------

loc_2162A:
		btst	#p2_pushing_bit,status(a0)
		beq.w	loc_215AC
		lea	(Player_2).w,a1							; a1=character
		move.w	objoff_32(a0),d1
		cmpi.b	#AniIDSonAni_Roll,anim(a1)
		bne.w	loc_215AC
		mvabs.w	d1,d0
		cmpi.w	#$480,d0
		blo.w	loc_215AC
		bclr	#p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

Obj_BreakableWall_CreateFragments:
		move.w	d1,x_vel(a1)
		addq.w	#4,x_pos(a1)
		movea.l	objoff_34(a0),a4						; BreakableWall_FragSpd1 (right)
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		blo.s	.isleft								; if Sonic is left of the object, branch
		subq.w	#4*2,x_pos(a1)
		movea.l	objoff_38(a0),a4						; BreakableWall_FragSpd2 (left)

.isleft
		move.w	x_vel(a1),ground_vel(a1)
		bclr	#status.player.pushing,status(a1)				; set sonic as not pushing an object

	if _BWALL_KNUX_
		; check Knuckles
		cmpi.b	#PlayerID_Knuckles,character_id(a1)				; is player Knuckles?
		bne.s	.notKnux							; if not, branch
		cmpi.b	#1,double_jump_flag(a1)						; is Knuckles gliding?
		bne.s	.notKnux							; if not, branch
		move.b	#2,double_jump_flag(a1)						; make him stop gliding
		move.b	#$21,anim(a1)							; put Knuckles in his falling animation

		; decide which direction to make Knuckles face
		bclr	#status.player.x_flip,status(a1)
		tst.w	x_vel(a1)
		bpl.s	.notKnux
		bset	#status.player.x_flip,status(a1)

.notKnux
	endif

		move.l	#Obj_BreakableWallFall,address(a0)
		bsr.s	BreakObjectToPieces

; =============== S U B R O U T I N E =======================================

Obj_BreakableWallFall:
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.delete								; if not, branch

		MoveSprite a0, $70							; make obj fall

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

BreakObjectToPieces:
		sfx	sfx_Collapse							; play smashing sound
		move.w	#priority_1,priority(a0)					; set priority again when being smashed

BreakObjectToPieces2:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3							; get mapping pointer
		adda.w	(a3,d0.w),a3
		move.w	(a3)+,d1
		subq.w	#1,d1								; fix dbf
		bset	#render_flags.static_mappings,render_flags(a0)			; set flag to "static mappings flag"
		move.l	address(a0),d4							; get object address
		move.b	render_flags(a0),d5						; get render type
		movea.w	a0,a1								; load current object to a1

		; get RAM slot
		getobjectRAMslot a2
		bra.s	.load
; ---------------------------------------------------------------------------

.create

		; create break pieces object

.find
		lea	next_object(a1),a1						; goto next object RAM slot
		tst.l	address(a1)							; is object RAM slot empty?
		dbeq	d0,.find							; if not, branch
		bne.s	.return								; branch, if object RAM slot is not empty
		subq.w	#1,d0								; subtract from sprite table
		addq.w	#6,a3								; add to mappings

		; load object
		move.l	d4,address(a1)							; set object address
		move.b	d5,render_flags(a1)						; set render type
		move.w	art_tile(a0),art_tile(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)

		; this is not a bug because the design of this object is that priority is set to $200
		; copying priority as a byte would lead to $8 being 0x02 and $9 being 00 by default would still end up as $200 anyway but if you
		; change priority to something like $280 it would bug up so using a word here is a better case

		move.b	priority(a0),priority(a1)
		move.w	height_pixels(a0),height_pixels(a1)				; set height and width

.load
		move.l	a3,mappings(a1)							; get mappings pointer
		ori.w	#high_priority,art_tile(a1)					; change fragments priority
		move.l	(a4)+,x_vel(a1)							; set xyvel
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.create							; if not, loop

.return
		rts
; ---------------------------------------------------------------------------

BreakableWall_FragSpd1:

		; x-speed, y-speed
		dc.w $400, -$500
		dc.w $600, -$600
		dc.w $600, -$100
		dc.w $800, -$200
		dc.w $600, $100
		dc.w $800, $200
		dc.w $400, $500
		dc.w $600, $600
BreakableWall_FragSpd2:

		; x-speed, y-speed
		dc.w -$600, -$600
		dc.w -$400, -$500
		dc.w -$800, -$200
		dc.w -$600, -$100
		dc.w -$800, $200
		dc.w -$600, $100
		dc.w -$600, $600
		dc.w -$400, $500

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BreakableWall:	subObjMainData Obj_BreakableWall.main, setBit(render_flags.level), 0, 64, 32, 5, $398, 2, 0, Map_BreakableWall
; ---------------------------------------------------------------------------

		include "Objects/Environ/Breakable Wall/Object Data/Map - Breakable Wall.asm"
