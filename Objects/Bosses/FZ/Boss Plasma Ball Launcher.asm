; ---------------------------------------------------------------------------
; Object 86 - energy balls (FZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
obBFZBP_Enable				= objoff_2D	; .b
obBFZBP_Timer				= objoff_2E	; .w
obBFZBP_Count				= objoff_30	; .b
obBFZBP_Count2				= objoff_31	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossPlasma:

		; init
		lea	ObjDat_BossPlasma(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.checkattack,address(a0)

.checkattack
		clr.b	anim(a0)
		tst.b	obBFZBP_Enable(a0)
		beq.s	.solid
		addq.b	#1,anim(a0)
		move.l	#.makeballs,address(a0)
		bra.s	.solid
; ---------------------------------------------------------------------------

.makeballs
		clr.b	obBFZBP_Enable(a0)
		move.l	#.checkpend,address(a0)

		; create plasma balls
		lea	Child6_BossPlasmaBall(pc),a2
		jsr	(CreateChild6_Simple).w

		; save plasma balls count
		lsr.w	d2								; subtype
		move.b	d2,obBFZBP_Count(a0)
		move.b	d2,obBFZBP_Count2(a0)

.checkpend
		tst.b	obBFZBP_Count(a0)						; plasma create wait
		bne.s	.solid
		move.l	#.setanim,address(a0)
		bra.s	.solid
; ---------------------------------------------------------------------------

.setanim
		move.b	#2,anim(a0)
		move.l	#.checkpbend,address(a0)

.checkpbend
		tst.b	obBFZBP_Count2(a0)						; plasma ball wait
		bne.s	.solid
		move.l	#Obj_BossPlasma.checkattack,address(a0)				; return

		; load Eggman address
		movea.w	parent3(a0),a1
		subq.b	#1,obBFZ_Count(a1)

.solid

		; solid
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w

		; anim
		lea	Ani_PLaunch(pc),a1
		jsr	(Animate_Sprite).w

		; check draw
		movea.w	parent3(a0),a1							; load Eggman address
		btst	#4,objoff_38(a1)
		bne.s	.defeated
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.defeated
		move.w	#bytes_to_word(16/2,16/2),objoff_3A(a0)				; set explosion radius

		; create explosions
		jsr	(sub_83E84).l

		; delete
		jmp	(Go_Delete_Sprite_2).w

; ---------------------------------------------------------------------------
; Object 86 - energy balls (FZ)
; ---------------------------------------------------------------------------

obBFZBPB_Timer				= objoff_2E ; .w
obBFZBPB_Xpos				= objoff_30 ; .w

; =============== S U B R O U T I N E =======================================

Obj_BossPlasma_Ball:

		; calc xpos
		jsr	(Random_Number).w
		moveq	#0,d1
		move.b	subtype(a0),d1
		lsr.w	d1								; division by 2
		muls.w	#-$59,d1							; devon fix
		move.w	(Camera_max_X_pos).w,d2
		addi.w	#$118,d2
		add.w	d2,d1
		andi.w	#$1F,d0
		subi.w	#16,d0
		add.w	d1,d0
		move.w	d0,obBFZBPB_Xpos(a0)						; save x_pos
		sub.w	x_pos(a0),d0
		asl.w	#4,d0
		move.w	d0,x_vel(a0)

		; init
		lea	ObjDat_BossPlasmaBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#3*60,obBFZBPB_Timer(a0)					; timer
		move.l	#.main,address(a0)

.main
		tst.w	x_vel(a0)
		beq.s	.skip
		jsr	(MoveSprite2).w

		move.w	x_pos(a0),d0
		sub.w	obBFZBPB_Xpos(a0),d0
		bhs.s	.skip
		sub.w	d0,x_pos(a0)							; devon fix
		clr.w	x_vel(a0)

		; load Plasma address
		movea.w	parent3(a0),a1
		subq.b	#1,obBFZBP_Count(a1)

.skip
		clr.b	anim(a0)
		subq.w	#1,obBFZBPB_Timer(a0)
		bne.s	.draw
		addq.b	#1,anim(a0)

		move.w	#3*60,obBFZBPB_Timer(a0)					; timer
		move.l	#.chkdel,address(a0)

		; set xyvel
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		move.w	d0,x_vel(a0)
		move.w	#$140,y_vel(a0)

.draw
		lea	Ani_Plasma(pc),a1
		jsr	(Animate_Sprite).w

		; draw and check plasma ball launcher
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

.chkdel
		jsr	(MoveSprite2).w

		; check delete
		move.w	(Camera_min_Y_pos).w,d0
		addi.w	#$D0,d0
		cmp.w	y_pos(a0),d0
		blo.s	.delete
		subq.w	#1,obBFZBPB_Timer(a0)						; timer
		beq.s	.delete

		; draw
		lea	Ani_Plasma(pc),a1
		jsr	(Animate_Sprite).w

		; draw and check plasma ball launcher
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

.delete

		; load Plasma address
		movea.w	parent3(a0),a1
		subq.b	#1,obBFZBP_Count2(a1)

		; delete
		jmp	(Go_Delete_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_BossPlasma:		subObjData Map_PLaunch, $300, 0, 0, 16, 16, 3, 0, 0
ObjDat_BossPlasmaBall:		subObjData Map_Plasma, $300, 1, 0, 24, 24, 3, 0, $1A|collision_flags.npc.hurt

Child6_BossPlasma:
		dc.w 1-1
		dc.l Obj_BossPlasma
Child6_BossPlasmaBall:
		dc.w 4-1
		dc.l Obj_BossPlasma_Ball
; ---------------------------------------------------------------------------

		include "Objects/Bosses/FZ/Object Data/Anim - Plasma Ball Launcher.asm"
		include "Objects/Bosses/FZ/Object Data/Anim - Plasma Balls.asm"
		include "Objects/Bosses/FZ/Object Data/Map - Plasma Ball Launcher.asm"
		include "Objects/Bosses/FZ/Object Data/Map - Plasma Balls.asm"
