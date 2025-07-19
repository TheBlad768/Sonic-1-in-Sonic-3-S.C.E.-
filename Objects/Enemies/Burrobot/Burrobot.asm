; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
burro_flag			= objoff_39	; chg
burro_timedelay			= objoff_3C	; time between direction changes

; =============== S U B R O U T I N E =======================================

Obj_Burrobot:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_Burrobot(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#bytes_to_word(38/2,16/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#2,anim(a0)
		move.l	#.Burro_ChkSonic,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		bne.s	.notwrapping							; if not, branch
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)							; perform wrapping of Burrobot's y position

.notwrapping
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Burro(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.changedir
		subq.w	#1,burro_timedelay(a0)
		bpl.s	.nochg
		move.l	#.Burro_Move,objoff_34(a0)
		move.w	#256-1,burro_timedelay(a0)
		move.w	#$80,x_vel(a0)
		move.b	#1,anim(a0)
		bchg	#status.npc.x_flip,status(a0)					; change direction the Burrobot is facing
		beq.s	.nochg
		neg.w	x_vel(a0)							; change direction the Burrobot is moving

.nochg
		rts
; ---------------------------------------------------------------------------

.Burro_Move
		subq.w	#1,burro_timedelay(a0)
		bmi.s	.loc_AD84
		jsr	(MoveSprite2).w
		bchg	#0,burro_flag(a0)
		bne.s	.loc_AD78
		move.b	x_radius(a0),d3
		ext.w	d3
		btst	#status.npc.x_flip,status(a0)
		bne.s	.loc_AD6A
		neg.w	d3

.loc_AD6A
		add.w	x_pos(a0),d3
		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#12,d1
		bge.s	.loc_AD84
		rts
; ---------------------------------------------------------------------------

.loc_AD78
		jsr	(ObjCheckFloorDist).w
		add.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

.loc_AD84
		btst	#2,(V_int_run_count+3).w
		beq.s	.loc_ADA4
		move.l	#.changedir,objoff_34(a0)
		move.w	#60-1,burro_timedelay(a0)
		clr.w	x_vel(a0)
		clr.b	anim(a0)
		rts
; ---------------------------------------------------------------------------

.loc_ADA4
		move.l	#.Burro_Jump,objoff_34(a0)
		move.w	#-$400,y_vel(a0)
		move.b	#2,anim(a0)
		rts
; ---------------------------------------------------------------------------

.Burro_Jump
		MoveSprite a0, $18							; make obj fall

		; check jump
		tst.w	y_vel(a0)
		bmi.s	.return
		move.b	#3,anim(a0)
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.return
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		move.b	#1,anim(a0)
		move.w	#256-1,burro_timedelay(a0)
		move.l	#.Burro_Move,objoff_34(a0)
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)

.return
		rts
; ---------------------------------------------------------------------------

.Burro_ChkSonic
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)
		cmpi.w	#96,d2
		bhs.s	.return
		tst.w	d1								; is Sonic below?
		bne.s	.return								; if yes, branch
		cmpi.w	#128,d3
		bhs.s	.return
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.return								; if yes, branch
		move.l	#.Burro_Jump,objoff_34(a0)
		move.w	#-$400,y_vel(a0)
		moveq	#-$80,d0
		jmp	(Change_VelocityWithFlipX).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Burrobot:	subObjData Map_Burro, $510, 0, 0, 38, 16, 4, 0, 5|collision_flags.npc.touch
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Burrobot/Object Data/Anim - Burrobot.asm"
		include "Objects/Enemies/Burrobot/Object Data/Map - Burrobot.asm"
