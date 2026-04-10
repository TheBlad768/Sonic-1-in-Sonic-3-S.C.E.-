; ---------------------------------------------------------------------------
; Object 55 - Basaran enemy (MZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

basaran.sypos				ds.w 1						; copy Sonic ypos (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Basaran:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_Basaran(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.dropcheck,wait_addr(a0)
		move.l	#.action,code_addr(a0)

.action

		; jump
		movea.l	wait_addr(a0),a1
		jsr	(a1)
		lea	Ani_Basaran(pc),a1
		jsr	(Animate_SpriteNoSST).w
		jmp	(Sprite_CheckDeleteTouch).w

; =============== S U B R O U T I N E =======================================

.dropcheck

		; check players
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)
		cmpi.w	#128,d2								; is Basaran within $80 pixels of Sonic?
		bhs.s	.nodrop								; if not, branch
		tst.w	d1								; is Sonic above?
		beq.s	.nodrop								; if yes, branch
		move.w	y_pos(a1),basaran.sypos(a0)
		cmpi.w	#128,d3								; is Basaran height $80 pixels of Sonic?
		bhs.s	.nodrop								; if not, branch

		; check debug mode
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.nodrop								; if yes, branch
		move.b	(V_int_run_count+3).w,d0
		add.b	d7,d0								; d7 - object count (Process_Objects)
		andi.b	#7,d0
		bne.s	.nodrop
		move.b	#1,anim(a0)
		move.l	#.dropfly,wait_addr(a0)

.nodrop
		rts
; ---------------------------------------------------------------------------

.dropfly
		MoveSpriteYOnly , $18							; make basaran fall

		; check players
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)
		move.w	basaran.sypos(a0),d3
		sub.w	y_pos(a0),d3
		blo.s	.chkdel
		cmpi.w	#16,d3								; is basaran close to Sonic vertically?
		bhs.s	.dropmore							; if not, branch
		move.w	#-$100,d0							; make basaran fly horizontally
		jsr	(Change_VelocityWithFlipX).w
		clr.w	y_vel(a0)							; stop basaran falling
		move.b	#2,anim(a0)
		move.l	#.flapsound,wait_addr(a0)

.dropmore
		rts
; ---------------------------------------------------------------------------

.chkdel
		tst.b	render_flags(a0)						; object visible on the screen?
		bmi.s	.dropmore							; if yes, branch

		; delete object
		move.l	#Sprite_CheckDelete.offscreen,code_addr(a0)
		rts
; ---------------------------------------------------------------------------

.flapsound

		; play continuous sfx
		sfxcont	sfx_Basaran, $F							; play flapping sound every 16th frame
		MoveSpriteXOnly

		; check players
		jsr	(Find_SonicTails).w
		cmpi.w	#128,d2								; is Basaran within $80 pixels of Sonic?
		blo.s	.dontflyup							; if yes, branch
		move.b	(V_int_run_count+3).w,d0
		add.b	d7,d0								; d7 - object count (Process_Objects)
		andi.b	#7,d0
		bne.s	.dontflyup
		move.l	#.flyup,wait_addr(a0)

.dontflyup
		rts
; ---------------------------------------------------------------------------

.flyup
		MoveSprite , -$18							; make basaran fly upwards
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1								; has basaran hit the ceiling?
		bpl.s	.noceiling							; if not, branch
		sub.w	d1,y_pos(a0)
		andi.w	#-8,x_pos(a0)							; align xpos (8 pixels)
		clr.l	x_vel(a0)							; stop basaran moving
		clr.b	anim(a0)
		move.l	#.dropcheck,wait_addr(a0)

.noceiling
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Basaran:		subObjData Map_Basaran, $529, 0, TRUE, 24, 32, 2, 0, $B|collision_flags.npc.touch
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Enemies/Basaran/Object Data/Anim - Basaran.asm"
		include "Objects/Enemies/Basaran/Object Data/Map - Basaran.asm"
