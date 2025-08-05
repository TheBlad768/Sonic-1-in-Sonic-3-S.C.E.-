; ---------------------------------------------------------------------------
; Robotnik head 3
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikHead3:

		; init
		lea	ObjDat_RobotnikHead(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,address(a0)
		move.l	#Ani_RobotnikHead,objoff_30(a0)
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w
		bne.s	.notKnux
		bsr.s	sub_67B14							; load Egg Robo art

.notKnux
		movea.w	parent3(a0),a1							; a1=parent object
		move.w	art_tile(a1),d0
		andi.w	#$87FF,d0
		or.w	d0,art_tile(a0)							; set VRAM

		; check
		btst	#high_priority_bit,art_tile(a1)					; is parent object has high priority?
		beq.s	.main								; if not, branch
		bset	#high_priority_bit,art_tile(a0)					; high priority

.main
		movea.w	parent3(a0),a1							; a1=parent object

		; check defeated flag
		btst	#status.npc.defeated,status(a1)
		bne.s	.defeated

		move.b	#2,anim(a0)							; hurt animate

		; check touch flag
		btst	#status.npc.touch,status(a1)
		bne.s	.draw

		; check laugh flag
		move.b	#1,anim(a0)							; laugh animate
		btst	#6,objoff_38(a1)
		bne.s	.draw
		moveq	#PlayerID_Hurt-1,d0
		cmp.b	(Player_1+routine).w,d0
		blo.s	.draw
		cmp.b	(Player_2+routine).w,d0
		blo.s	.draw

		; head anim
		clr.b	anim(a0)							; normal animate

.draw
		jsr	(Refresh_ChildPositionAdjusted_Animate2).w
		movea.l	objoff_30(a0),a1
		jsr	(Animate_Sprite).w
		jmp	(Child_Draw_Sprite2).w
; ---------------------------------------------------------------------------

.defeated
		move.b	#3,anim(a0)							; defeated animate
		move.l	#.draw,address(a0)
		bra.s	.draw

; =============== S U B R O U T I N E =======================================

sub_67B14:
		move.l	#Map_EggRoboHead,mappings(a0)					; if player is Knuckles, use Egg Robo head

loc_67B1C:
		move.l	#Ani_EggRoboHead,objoff_30(a0)

		; load art
		movea.w	parent3(a0),a1							; a1=parent object
		move.w	art_tile(a1),d2
		andi.w	#$7FF,d2
		lsl.w	#5,d2
		lea	(ArtKosPM_EggRoboHead).l,a1
		jmp	(Queue_KosPlus_Module).w

; ---------------------------------------------------------------------------
; Robotnik head 4
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikHead4:

		; init
		lea	ObjDat_RobotnikHead(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#.main,address(a0)
		move.l	#Ani_RobotnikHead,objoff_30(a0)
		cmpi.b	#PlayerID_Knuckles,(Player_1+character_id).w
		bne.s	.notKnux
		bsr.s	sub_67B14							; load Egg Robo art

.notKnux
		movea.w	parent3(a0),a1							; a1=parent object
		move.w	art_tile(a1),d0
		andi.w	#$87FF,d0
		or.w	d0,art_tile(a0)							; set VRAM

.main
		movea.w	parent3(a0),a1							; a1=parent object

		; check defeated flag
		btst	#status.npc.defeated,status(a1)
		bne.s	.defeated

		move.b	#2,anim(a0)							; hurt animate

		; check touch flag
		btst	#status.npc.touch,status(a1)
		bne.s	.draw

		; check laugh flag
		move.b	#1,anim(a0)							; laugh animate
		btst	#6,objoff_38(a1)
		bne.s	.draw
		moveq	#PlayerID_Hurt-1,d0
		cmp.b	(Player_1+routine).w,d0
		blo.s	.draw
		cmp.b	(Player_2+routine).w,d0
		blo.s	.draw

		; head anim
		clr.b	anim(a0)							; normal animate

.draw
		jsr	(Refresh_ChildPositionAdjusted_Animate2).w
		jsr	(Child_GetPriority.skipp).w
		movea.l	objoff_30(a0),a1
		jsr	(Animate_Sprite).w

		; check delete flag
		movea.w	parent3(a0),a1							; a1=parent object
		btst	#5,objoff_38(a1)
		bne.s	.delete

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.defeated
		move.b	#3,anim(a0)							; defeated animate
		move.l	#.draw,address(a0)
		bra.s	.draw
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Robotnik ship flame
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikShipFlame:

		; init
		lea	ObjDat2_RoboShipFlame(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		andi.w	#$87FF,art_tile(a0)
		move.l	#.main,address(a0)

.main
		movea.w	parent3(a0),a1							; a1=parent object
		btst	#5,objoff_38(a1)						; 4
		bne.s	Obj_RobotnikHead4.delete
		jsr	(Refresh_ChildPositionAdjusted).w
		btst	#0,(V_int_run_count+3).w
		bne.s	.return
		tst.w	x_vel(a1)
		beq.s	.return

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Robotnik ship pieces
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_RobotnikShipPieces:

		; init
		lea	ObjDat_RobotnikShipPieces(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#Obj_FlickerMove,address(a0)
		move.b	subtype(a0),d0
		lsr.b	d0								; division by 2
		move.b	d0,mapping_frame(a0)
		moveq	#2<<2,d0							; set index velocity
		jsr	(Set_IndexedVelocity).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_RobotnikShip:		subObjData Map_RobotnikShip, $380, 0, 0, 64, 64, 4, $C, $F|collision_flags.npc.touch
ObjDat_RobotnikShip_Glass:	subObjData Map_RobotnikShip, $380, 0, 0, 64, 64, 4, 7, $F|collision_flags.npc.touch
ObjDat_RobotnikShip2:		subObjData Map_RobotnikShip, $380, 1, 0, 64, 64, 4, $C, $F|collision_flags.npc.touch
ObjDat_RobotnikShip2_Glass:	subObjData Map_RobotnikShip, $380, 1, 0, 64, 64, 4, 7, $F|collision_flags.npc.touch
ObjDat_RobotnikHead:		subObjData Map_RobotnikShip, 0, 0, 0, 16, 32, 5, 0, 0
ObjDat2_RoboShipFlame:		subObjData FALSE, FALSE, 0, 0, 8, 16, 5, 8, 0
ObjDat_RobotnikShipPieces:	subObjData Map_RobotnikShipPieces, $380, 0, 1, 64, 64, 0, 0, 0

Child1_MakeRoboHead3:
		dc.w 1-1
		dc.l Obj_RobotnikHead3
		dc.b 0, -28
Child1_MakeRoboHead4:
		dc.w 1-1
		dc.l Obj_RobotnikHead4
		dc.b 0, -28
Child1_MakeRoboShipFlame:
		dc.w 1-1
		dc.l Obj_RobotnikShipFlame
		dc.b 30, 0
Child6_MakeRobotnikShipPieces:
		dc.w 4-1
		dc.l Obj_RobotnikShipPieces

AngleLookup_1:	binclude "Objects/Bosses/Robotnik/Object Data/AngleLookup1.bin"
	even
AngleLookup_2:	binclude "Objects/Bosses/Robotnik/Object Data/AngleLookup2.bin"
	even
AngleLookup_3:	binclude "Objects/Bosses/Robotnik/Object Data/AngleLookup3.bin"
	even
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Robotnik/Object Data/Anim - Robotnik.asm"
		include "Objects/Bosses/Robotnik/Object Data/Anim - Egg Robo.asm"
		include "Objects/Bosses/Robotnik/Object Data/Map - Robotnik Ship.asm"
		include "Objects/Bosses/Robotnik/Object Data/Map - Robotnik Ship Pieces.asm"
		include "Objects/Bosses/Robotnik/Object Data/Map - Egg Robo Head.asm"
		include "Objects/Bosses/Robotnik/Object Data/Map - Robotnik Ship Stand.asm"
