; ---------------------------------------------------------------------------
; Object 55 - Basaran enemy (MZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
bas_sypos			= objoff_30	; copy Sonic ypos

; =============== S U B R O U T I N E =======================================

Obj_Basaran:

		; wait
		jsr	(Obj_WaitOffscreen).w

		; init
		lea	ObjDat_Basaran(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.dropcheck,objoff_34(a0)
		move.l	#.action,address(a0)

.action
		movea.l	objoff_34(a0),a1
		jsr	(a1)
		lea	Ani_Bas(pc),a1
		jsr	(Animate_Sprite).w
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
		move.w	y_pos(a1),bas_sypos(a0)
		cmpi.w	#128,d3								; is Basaran height $80 pixels of Sonic?
		bhs.s	.nodrop								; if not, branch

		; check Debug
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.nodrop								; if yes, branch
		move.b	(V_int_run_count+3).w,d0
		add.b	d7,d0								; d7 - object count (Process_Sprites)
		andi.b	#7,d0
		bne.s	.nodrop
		move.b	#1,anim(a0)
		move.l	#.dropfly,objoff_34(a0)

.nodrop
		rts
; ---------------------------------------------------------------------------

.dropfly
		MoveSprite a0, $18							; make basaran fall

		; check players
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.b	render_flags(a0),status(a0)
		move.w	bas_sypos(a0),d3
		sub.w	y_pos(a0),d3
		blo.s	.chkdel
		cmpi.w	#16,d3								; is basaran close to Sonic vertically?
		bhs.s	.dropmore							; if not, branch
		move.w	#-$100,d0							; make basaran fly horizontally
		jsr	(Change_VelocityWithFlipX).w
		clr.w	y_vel(a0)							; stop basaran falling
		move.b	#2,anim(a0)
		move.l	#.flapsound,objoff_34(a0)

.dropmore
		rts
; ---------------------------------------------------------------------------

.chkdel
		tst.b	render_flags(a0)						; object visible on the screen?
		bmi.s	.dropmore							; if yes, branch

		; delete object
		move.l	#Sprite_CheckDelete.offscreen,address(a0)
		rts
; ---------------------------------------------------------------------------

.flapsound

		; play continuous sfx
		sfxcont	sfx_Basaran,$F							; play flapping sound every 16th frame
		jsr	(MoveSprite2).w

		; check players
		jsr	(Find_SonicTails).w
		cmpi.w	#128,d2								; is Basaran within $80 pixels of Sonic?
		blo.s	.dontflyup							; if yes, branch
		move.b	(V_int_run_count+3).w,d0
		add.b	d7,d0								; d7 - object count (Process_Sprites)
		andi.b	#7,d0
		bne.s	.dontflyup
		move.l	#.flyup,objoff_34(a0)

.dontflyup
		rts
; ---------------------------------------------------------------------------

.flyup
		MoveSprite a0, -$18							; make basaran fly upwards
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1								; has basaran hit the ceiling?
		bpl.s	.noceiling							; if not, branch
		sub.w	d1,y_pos(a0)
		andi.w	#-8,x_pos(a0)							; align xpos (8 pixels)
		clr.l	x_vel(a0)							; stop basaran moving
		clr.b	anim(a0)
		move.l	#.dropcheck,objoff_34(a0)

.noceiling
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Basaran:		subObjData Map_Bas, $529, 0, 1, 24, 32, 2, 0, $B|collision_flags.npc.touch
; ---------------------------------------------------------------------------

		include "Objects/Enemies/Basaran/Object Data/Anim - Basaran.asm"
		include "Objects/Enemies/Basaran/Object Data/Map - Basaran.asm"
