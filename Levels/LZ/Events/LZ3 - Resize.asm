; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LZ3_Resize:

		; check button
		tst.b	(Level_trigger_array+$F).w					; has switch number $0F been pressed?
		beq.s	.normal								; if not, branch

		; change chunk
		bsr.w	Redraw_LZ3Chunks.alt_chunks					; modify level layout
		move.l	#.normal,(Level_data_addr_RAM.Resize).w
		sfx	sfx_Rumbling							; play sound $B7 (rumbling)
		move.w	#$3F,(Screen_shaking_flag).w					; screen shake

.normal

		; check camera
		cmpi.w	#$1EA0,(Camera_X_pos).w
		blo.s	.return
		cmpi.w	#$600,(Camera_Y_pos).w
		bhs.s	.return

		; load boss
		moveq	#0,d0
		move.l	d0,(Level_data_addr_RAM.Resize).w
		move.l	d0,(Level_data_addr_RAM.AnimateTiles).w				; disable animate tiles

		; load boss art
		lea	(PLC_BossWater).l,a5
		jsr	(LoadPLC_Raw_KosPlusM).w

		; load boss palette
		lea	(Pal_Robotnik).l,a1
		lea	(Normal_palette_line_2).w,a2
		jsr	(PalLoad_Line16).w

		; load boss water palette
		lea	(Pal_WaterRobotnikLZ).l,a1
		lea	(Water_palette_line_2).w,a2
		jsr	(PalLoad_Line16).w

		; create boss
		music	mus_ZoneBoss
		move.b	d0,(Current_music+1).w						; save music
		jsr	(Create_New_Object).w
		bne.s	.return
		move.l	#Obj_BossWater,code_addr(a1)
		move.w	#$2010,x_pos(a1)
		move.w	#$5C0,y_pos(a1)

.return
		rts
; ---------------------------------------------------------------------------

.after_boss
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmpi.w	#$2230,(Camera_X_pos).w
		bne.s	.check_end
		move.l	#.check_end,(Level_data_addr_RAM.Resize).w

.check_end

		; check end level flag
		tst.b	(End_of_level_flag).w
		beq.s	.return

		; next zone
		move.w	#bytes_to_word(LevelID_SLZ,ACT_1),d0
		jmp	(StartNewLevel).w

; ---------------------------------------------------------------------------
; Redraw chunks
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Redraw_LZ3Chunks:

		; normal chunks
		lea	(Chunk_table+($C9*$80)).l,a1					; get $C9-$CA chunks
		lea	-($C9*$80-$72*$80)(a1),a2					; get $72-$73 chunks
		bra.s	.redraw
; ---------------------------------------------------------------------------

.alt_chunks
		lea	(Chunk_table+($C9*$80)).l,a1					; get $C9-$CA chunks
		lea	-($C9*$80-$BE*$80)(a1),a2					; get $BE-$BF chunks

.redraw

		set	.a,0

	rept 4*2									; replace 2 chunks
		movem.l	(a2)+,d0-d7
		movem.l	d0-d7,.a(a1)							; copy $20 bytes
		set	.a,.a + $20
	endr

		rts
