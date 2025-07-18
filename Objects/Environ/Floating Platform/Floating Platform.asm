; ---------------------------------------------------------------------------
; Object 18 - platforms (GHZ, SYZ, SLZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FloatingPlatform:

		; init
		move.l	#Map_Plat_GHZ,d0
		move.w	#make_art_tile(0,2,0),art_tile(a0)
		cmpi.b	#LevelID_SYZ,(Current_zone).w					; check if level is SYZ
		bne.s	.notSYZ								; if not, branch
		move.l	#Map_Plat_SYZ,d0

.notSYZ
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; check if level is SLZ
		bne.s	.notSLZ								; if not, branch
		move.l	#Map_Plat_SLZ,d0
		move.b	#3,subtype(a0)

.notSLZ
		move.l	d0,mappings(a0)
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(34/2,64/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.w	x_pos(a0),objoff_30(a0)
		move.w	x_pos(a0),objoff_32(a0)
		move.w	y_pos(a0),objoff_34(a0)
		move.b	status(a0),objoff_2E(a0)
		move.w	#$80+320+$40+$80,objoff_42(a0)					; out_of_xrange
		move.w	x_pos(a0),objoff_44(a0)						; out_of_xrange
		moveq	#$F,d0
		and.b	subtype(a0),d0
		cmpi.b	#10,d0
		bne.s	.skip
		move.b	#1,mapping_frame(a0)						; large platform

.skip
		add.b	d0,d0
		move.b	d0,subtype(a0)
		move.l	#loc_255F4,address(a0)

loc_255F4:
		move.w	x_pos(a0),-(sp)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	FloatingPlatform_TypeIndex(pc,d0.w),d0
		jsr	FloatingPlatform_TypeIndex(pc,d0.w)
		move.w	(sp)+,d4
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	loc_25628							; if not, branch

		; solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		jsr	(SolidObjectTop).w

loc_25628:
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_44(a0),d0						; get object position
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmp.w	objoff_42(a0),d0
		bhi.s	loc_25642
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_25642:
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#7,(a2)

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

FloatingPlatform_TypeIndex: offsetTable
		offsetTableEntry.w FloatingPlatform_Nudge				; 0
		offsetTableEntry.w FloatingPlatform_LeftRight				; 1
		offsetTableEntry.w FloatingPlatform_UpDown				; 2
		offsetTableEntry.w FloatingPlatform_CheckFalling			; 3
		offsetTableEntry.w FloatingPlatform_Falling				; 4
		offsetTableEntry.w FloatingPlatform_LeftRight				; 5
		offsetTableEntry.w FloatingPlatform_UpDown				; 6
		offsetTableEntry.w FloatingPlatform_Button				; 7
		offsetTableEntry.w FloatingPlatform_Raise				; 8
		offsetTableEntry.w FloatingPlatform_Nudge				; 9
		offsetTableEntry.w FloatingPlatform_Large				; A
		offsetTableEntry.w FloatingPlatform_UpDown2				; B
		offsetTableEntry.w FloatingPlatform_UpDown2				; C

; =============== S U B R O U T I N E =======================================

FloatingPlatform_UpDown2:								; type0B(Up/Down) and type0C(Down/Up)
		moveq	#$30,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$C).w,d0
		bra.s	FloatingPlatform_UpDown.main

; =============== S U B R O U T I N E =======================================

FloatingPlatform_LeftRight:								; type01(Left/Right) and type05(Right/Left)
		moveq	#$40,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$18).w,d0

.main
		sub.w	d1,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflip
		neg.w	d0

.notflip
		move.w	objoff_30(a0),d1
		add.w	d0,d1
		move.w	d1,x_pos(a0)

; =============== S U B R O U T I N E =======================================

FloatingPlatform_Nudge:									; type00
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	loc_24FA6							; if yes, branch
		tst.b	objoff_3A(a0)
		beq.s	loc_24FB2
		subq.b	#4,objoff_3A(a0)
		bra.s	loc_24FB2
; ---------------------------------------------------------------------------

loc_24FA6:
		cmpi.b	#$40,objoff_3A(a0)
		beq.s	loc_24FB2
		addq.b	#4,objoff_3A(a0)

loc_24FB2:
		move.b	objoff_3A(a0),d0
		jsr	(GetSineCosine).w
		asr.w	#6,d0
		add.w	objoff_34(a0),d0
		move.w	d0,y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

FloatingPlatform_UpDown:								; type02(Up/Down) and type06(Down/Up)
		moveq	#$40,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$18).w,d0

.main
		sub.w	d1,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflip
		neg.w	d0

.notflip
		move.w	objoff_34(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

FloatingPlatform_CheckFalling:								; type03
		tst.w	objoff_3C(a0)
		bne.s	.wait
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; check if players is standing on platform
		beq.s	.return
		move.w	#60/2,objoff_3C(a0)

.return
		bra.s	FloatingPlatform_Nudge
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,objoff_3C(a0)
		bne.s	.return
		move.w	#32,objoff_3C(a0)
		addq.b	#2,subtype(a0)
		rts
; ---------------------------------------------------------------------------

FloatingPlatform_Falling:								; type04
		tst.w	objoff_3C(a0)
		beq.s	.fall
		subq.w	#1,objoff_3C(a0)
		bne.s	.fall

		; set player falling
		bclr	#p1_standing_bit,status(a0)
		beq.s	.notp1
		lea	(Player_1).w,a1							; a1=character
		bsr.s	FloatingPlatform_SetPlayerFalling

.notp1
		bclr	#p2_standing_bit,status(a0)
		beq.s	.notp2
		lea	(Player_2).w,a1							; a1=character
		bsr.s	FloatingPlatform_SetPlayerFalling

.notp2
		move.l	#Obj_FallingPlatformIntangible,address(a0)

.fall
		move.l	y_pos(a0),d3
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,y_pos(a0)
		addi.w	#$38,y_vel(a0)
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$120,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.return

		; delete object
		move.w	#$7F00,d0
		move.w	d0,x_pos(a0)
		move.w	d0,objoff_44(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

FloatingPlatform_SetPlayerFalling:
		move.w	#$200,y_vel(a1)
		move.b	#1,prev_anim(a1)
		move.b	#PlayerID_Control,routine(a1)
		bclr	#status.player.on_object,status(a1)
		bclr	#status.player.pushing,status(a1)
		bset	#status.player.in_air,status(a1)
		bne.s	.return								; if the player is already in the air, branch

		; set anim
		tst.b	spin_dash_flag(a1)
		bne.s	.return
		cmpi.b	#AniIDSonAni_Roll,anim(a1)					; is player in his rolling animation?
		beq.s	.return								; if so, branch
		move.b	#AniIDSonAni_Hurt,anim(a1)					; set falling animation

.return
		rts

; =============== S U B R O U T I N E =======================================

Obj_FallingPlatformIntangible:
		move.l	y_pos(a0),d3
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,y_pos(a0)
		addi.w	#$38,y_vel(a0)
		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#$120,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.draw

		; delete object
		move.w	#$7F00,d0
		move.w	d0,x_pos(a0)
		move.w	d0,objoff_44(a0)

.draw
		bra.w	loc_25628

; =============== S U B R O U T I N E =======================================

FloatingPlatform_Button:								; type07
		tst.w	objoff_3C(a0)
		bne.s	.wait
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsr.w	#4,d0
		lea	(Level_trigger_array).w,a3
		tst.b	(a3,d0.w)
		beq.s	.return
		move.w	#60,objoff_3C(a0)

.return
		bra.w	FloatingPlatform_Nudge
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,objoff_3C(a0)
		bne.s	.return
		addq.b	#2,subtype(a0)
		rts

; =============== S U B R O U T I N E =======================================

FloatingPlatform_Raise:									; type08
		subq.w	#2,y_pos(a0)
		move.w	objoff_34(a0),d1
		subi.w	#512,d1
		cmp.w	y_pos(a0),d1
		bne.s	.return
		move.w	y_pos(a0),objoff_34(a0)
		clr.b	subtype(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

FloatingPlatform_Large:									; type0A
		moveq	#$40,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$18).w,d0
		sub.w	d1,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.notflip
		neg.w	d0

.notflip
		move.w	objoff_34(a0),d1
		ext.w	d0
		asr.w	d0
		sub.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Floating Platform/Object Data/Map - Floating Platform(GHZ).asm"
		include "Objects/Environ/Floating Platform/Object Data/Map - Floating Platform(SYZ).asm"
		include "Objects/Environ/Floating Platform/Object Data/Map - Floating Platform(SLZ).asm"
