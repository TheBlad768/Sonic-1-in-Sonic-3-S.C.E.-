; ---------------------------------------------------------------------------
; LZ events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LZ3_ScreenInit:

		; restore wave splash object
		tst.b	(Last_star_post_hit).w						; have any starpost been hit?
		beq.s	.first								; if not, branch
		move.l	#Obj_WaveSplash,(Wave_Splash+address).w				; create wave splash object

.first

		; set
		move.w	#$7FF,(Screen_Y_wrap_value).w
		move.w	#$7F0,(Camera_Y_pos_mask).w
		move.w	#$3C,(Layout_row_index_mask).w					; set level y size: $7FF

LZ1_ScreenInit:

		; update FG
		jsr	(Reset_TileOffsetPositionActual).w
		jmp	(Refresh_PlaneFull).w

; =============== S U B R O U T I N E =======================================

LZ1_ScreenEvent:
		move.w	(Screen_shaking_offset).w,d0					; shake foreground
		add.w	d0,(Camera_Y_pos_copy).w

		; update FG
		jmp	(DrawTilesAsYouMove).w

; =============== S U B R O U T I N E =======================================

LZ1_BackgroundInit:
		bsr.s	LZ1_Deform

		; update BG
		jsr	(Reset_TileOffsetPositionEff).w
		moveq	#0,d1								; Camera_X_pos_BG_copy
		jsr	(Refresh_PlaneFull).w

		; deform
		bra.s	LZ1_ApplyDeformWater

; =============== S U B R O U T I N E =======================================

LZ1_BackgroundEvent:
		tst.b	(Background_event_flag).w
		bne.s	LZ1_Transition
		bsr.s	LZ1_Deform

		; update BG
		lea	(Camera_Y_pos_BG_copy).w,a6
		lea	(Camera_Y_pos_BG_rounded).w,a5
		moveq	#0,d1								; Camera_X_pos_BG_copy
		moveq	#512/16,d6
		jsr	(Draw_TileRow).w
		bsr.s	LZ1_ApplyDeformWater
		jmp	(ShakeScreen_Setup).w
; ---------------------------------------------------------------------------

LZ1_Transition:
		clr.b	(Background_event_flag).w
		rts

; =============== S U B R O U T I N E =======================================

LZ1_Deform:

		; yscroll
		move.w	(Camera_Y_pos_copy).w,d0					; 100% to d0 ($1000)
		move.w	(Screen_shaking_offset).w,d1					; shake data to d1
		sub.w	d1,d0
		and.w	(Screen_Y_wrap_value).w,d0					; camera limit 50% ($800)
		asr.w	d0								; get 25% ($400)
		add.w	d1,d0
		andi.w	#$3FF,d0							; size limit 25% (BG = $400 pixels)
		move.w	d0,(Camera_Y_pos_BG_copy).w					; save 25%

		; xscroll
		move.w	(Camera_X_pos_copy).w,d0					; 100% to d0 ($1000)
		asr.w	d0								; get 50% ($800)
		move.w	d0,(Camera_X_pos_BG_copy).w					; save 50.0%
		rts

; =============== S U B R O U T I N E =======================================

LZ1_ApplyDeformWater:

		; water scroll
		move.w	(Camera_Y_pos_copy).w,d0
		bmi.s	.normal								; vertical wrapping fix
		move.w	(Water_level).w,d1
		sub.w	d0,d1
		bls.s	.waterfull							; if completely underwater, only do water deformation
		cmpi.w	#224,d1
		blt.s	.water

.normal

		; if water isn't showing at all, only do non-water deformation
		jmp	(PlainDeformation).w
; ---------------------------------------------------------------------------

.water

		; write normal scroll before meeting water position
		lea	LZ1_DeformArray(pc),a4
		lea	(Camera_X_pos_BG_copy).w,a5
		subq.w	#1,d1								; 223-1
		jsr	(ApplyDeformation3).w
		pea	(a1)								; save H_scroll_buffer+normal position

		; foreground deformation
		lea	(H_scroll_table).w,a1						; load water buffer
		lea	LZ1_FGDeformDelta(pc),a6
		move.w	(Water_level).w,d0
		subi.w	#224-2,d1
		neg.w	d1
		move.w	(Level_frame_counter).w,d2
		add.w	d0,d2
		add.w	d0,d2
		andi.w	#$1FE,d2
		adda.w	d2,a6
		move.w	(Camera_X_pos_copy).w,d6
		neg.w	d6
		jsr	(MakeFGDeformArray).w
		movea.l	(sp)+,a1							; load H_scroll_buffer+normal position

		; background deformation
		lea	(H_scroll_table).w,a2						; load water buffer
		lea	LZ1_DeformArray(pc),a4
		lea	(Camera_X_pos_BG_copy).w,a5
		lea	LZ1_BGDeformDelta(pc),a6
		move.w	(Water_level).w,d0
		sub.w	(Camera_Y_pos_copy).w,d0
		add.w	(Camera_Y_pos_BG_copy).w,d0
		move.w	(Level_frame_counter).w,d2
		add.w	d0,d2
		add.w	d0,d2
		andi.w	#$1FE,d2
		adda.w	d2,a6
		jmp	(ApplyFGandBGDeformation).w
; ---------------------------------------------------------------------------

.waterfull

		; foreground deformation
		lea	(H_scroll_table).w,a1						; load water buffer
		lea	LZ1_FGDeformDelta(pc),a6
		move.w	#224-1,d1							; set screen size
		move.w	(Level_frame_counter).w,d2
		add.w	d0,d2
		add.w	d0,d2
		andi.w	#$1FE,d2
		adda.w	d2,a6
		move.w	(Camera_X_pos_copy).w,d6
		neg.w	d6
		jsr	(MakeFGDeformArray).w

		; background deformation
		lea	(H_scroll_table).w,a2						; load water buffer
		lea	LZ1_DeformArray(pc),a4
		lea	(Camera_X_pos_BG_copy).w,a5
		lea	LZ1_BGDeformDelta(pc),a6
		move.w	(Camera_Y_pos_BG_copy).w,d0
		move.w	(Level_frame_counter).w,d2
		add.w	d0,d2
		add.w	d0,d2
		andi.w	#$1FE,d2
		adda.w	d2,a6
		jmp	(ApplyFGandBGDeformation3).w
; ---------------------------------------------------------------------------

LZ1_DeformArray:		dc.w $7FFF	; FG and BG

		incfile.b	LZ1_FGDeformDelta, "Levels/LZ/Misc/LZ Scroll FG Data.bin"
		incfile.b	LZ1_BGDeformDelta, "Levels/LZ/Misc/LZ Scroll BG Data.bin"
