; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

burrobot.timer				ds.w 1						; time between direction changes (2 bytes)
burrobot.mode				ds.b 1						; (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Burrobot:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_Burrobot(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#bytes_to_word(38/2,16/2),y_radius(a0)				; set y_radius and x_radius
		move.b	#2,anim(a0)
		move.l	#.Burrobot_ChkSonic,wait_addr(a0)
		move.l	#.action,code_addr(a0)

.action
		cmpi.w	#-$100,(Camera_min_Y_pos).w					; is vertical wrapping enabled?
		bne.s	.notwrapping							; if not, branch
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,y_pos(a0)							; perform wrapping of Burrobot's y position

.notwrapping

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)
		lea	Ani_Burrobot(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.changedir
		subq.w	#1,burrobot.timer(a0)
		bpl.s	.nochg
		move.l	#.Burrobot_Move,wait_addr(a0)
		move.w	#256-1,burrobot.timer(a0)
		move.w	#$80,x_vel(a0)
		move.b	#1,anim(a0)
		bchg	#status.npc.x_flip,status(a0)					; change direction the Burrobot is facing
		beq.s	.nochg
		neg.w	x_vel(a0)							; change direction the Burrobot is moving

.nochg
		rts
; ---------------------------------------------------------------------------

.Burrobot_Move
		subq.w	#1,burrobot.timer(a0)
		bmi.s	.loc_AD84
		MoveSpriteXOnly
		bchg	#0,burrobot.mode(a0)
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
		btst	#2,(V_int_run_count.byte).w					; 0 or 4
		beq.s	.loc_ADA4
		move.l	#.changedir,wait_addr(a0)
		move.w	#60-1,burrobot.timer(a0)
		clr.w	x_vel(a0)
		clr.b	anim(a0)
		rts
; ---------------------------------------------------------------------------

.loc_ADA4
		move.l	#.Burrobot_Jump,wait_addr(a0)
		move.w	#-$400,y_vel(a0)
		move.b	#2,anim(a0)
		rts
; ---------------------------------------------------------------------------

.Burrobot_Jump
		MoveSprite , $18							; make obj fall

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
		move.w	#256-1,burrobot.timer(a0)
		move.l	#.Burrobot_Move,wait_addr(a0)
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)

.return
		rts
; ---------------------------------------------------------------------------

.Burrobot_ChkSonic
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)
		cmpi.w	#96,d2
		bhs.s	.return
		tst.w	d1								; is Sonic below?
		bne.s	.return								; if yes, branch
		cmpi.w	#128,d3
		bhs.s	.return

		; check debug mode
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.return								; if yes, branch
		move.l	#.Burrobot_Jump,wait_addr(a0)
		move.w	#-$400,y_vel(a0)
		moveq	#-$80,d0
		jmp	(Change_VelocityWithFlipX).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Burrobot:	subObjData Map_Burrobot, $510, 0, FALSE, 38, 16, 4, 0, collision_type.npc.touch, 36, 24
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Enemies/Burrobot/Object Data/Anim - Burrobot.asm"
		include "Objects/Enemies/Burrobot/Object Data/Map - Burrobot.asm"
