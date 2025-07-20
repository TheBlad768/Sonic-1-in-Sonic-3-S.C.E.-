; ---------------------------------------------------------------------------
; Object 4E - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
lwall_x_vel			= objoff_30	; .w
lwall_child_dx			= objoff_32	; .w

lwall_flag			= objoff_39	; .b ; flag to start wall moving

; =============== S U B R O U T I N E =======================================

Obj_LavaWall:

		; init
		lea	ObjDat_LavaWall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.fire_shield,shield_reaction(a0)
		bset	#render_flags.multi_sprite,render_flags(a0)			; set multi-draw flag
		move.w	#1,mainspr_childsprites(a0)					; set sub objects

		; set sub object xpos
		moveq	#signextendB(128),d1						; subtract 128 pixels
		move.w	d1,lwall_child_dx(a0)

		; sub object
		lea	sub2_x_pos(a0),a1						; $16-$1D bytes reserved
		move.w	x_pos(a0),d0
		add.w	d1,d0								; subtract 128 pixels
		move.w	d0,(a1)+							; xpos
		move.w	y_pos(a0),(a1)+							; ypos
		move.w	#5,(a1)								; frame

.restart
		move.l	#.action,address(a0)

.action
		jsr	(Find_SonicObject).w
		cmpi.w	#192,d2								; is Sonic within $C0 pixels (x-axis)?
		bhs.s	.solid								; if not, branch
		cmpi.w	#96,d3								; is Sonic within $60 pixels (y-axis)?
		bhs.s	.solid								; if not, branch
		move.l	#.movewall,address(a0)
		bra.s	.solid
; ---------------------------------------------------------------------------

.movewall
		jsr	(Find_SonicObject).w
		cmpi.w	#96,d3								; is Sonic within $60 pixels (y-axis)?
		bhs.s	.restart							; if not, branch
		cmpi.w	#192,d2								; is Sonic within $C0 pixels (x-axis)?
		blo.s	.solid								; if not, branch

		; set move flag
		st	lwall_flag(a0)

		; play sound
		sfx	sfx_BossMagma
		move.w	#$180,lwall_x_vel(a0)						; set object speed
		move.l	#.checkmove,address(a0)

.checkmove
		cmpi.w	#$8A0,x_pos(a0)							; has object reached $6A0 on the x-axis?
		bne.s	.solid								; if not, branch
		move.l	#.solid,address(a0)

		; stop object moving
		clr.w	lwall_x_vel(a0)

		; clear move flag
		clr.b	lwall_flag(a0)

.solid
		moveq	#(64/2)+$B,d1							; width
		moveq	#48/2,d2							; height
		move.w	d2,d3
		addq.w	#1,d3								; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

.anim

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.check								; if time remains, branch
		move.b	#9,anim_frame_timer(a0)						; reset timer to 9 frames

		; next frame
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		bne.s	.check
		move.b	#1,mapping_frame(a0)

.check
		cmpi.b	#PlayerID_Hurt,(Player_1+routine).w				; is Sonic falling back from getting hurt?
		bhs.s	.Sonichurt							; if yes, branch

		; move lava
		move.w	lwall_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,x_pos(a0)

		; move sub object
		move.w	x_pos(a0),d0
		add.w	lwall_child_dx(a0),d0
		move.w	d0,sub2_x_pos(a0)

.Sonichurt
		tst.b	lwall_flag(a0)							; is object set to move?
		bne.s	.draw								; if yes, branch
		jmp	(Sprite_CheckDeleteTouch3).w
; ---------------------------------------------------------------------------

.draw
		jmp	(Draw_And_Touch_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_LavaWall:	subObjData Map_LWall, $36D, 3, 0, 64, 180, 1, 1, $14|collision_flags.npc.hurt
; ---------------------------------------------------------------------------

		include "Objects/Environ/Lava Wall/Object Data/Map - Lava Wall.asm"
