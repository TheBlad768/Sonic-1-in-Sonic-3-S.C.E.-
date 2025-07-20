; ---------------------------------------------------------------------------
; Hyper Trail (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_HyperSonicKnux_Trail:

		; init
		movem.l	ObjDat_HyperSonicKnux_Trail(pc),d0-d3				; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; check player
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w				; are we playing as Knuckles?
		bhs.s	.main								; if so, branch
		move.l	#Map_SuperSonic,mappings(a0)					; if not, you must be Hyper Sonic, load Super/Hyper Sonic mappings

.main

		; check
		tst.b	(Super_Sonic_Knux_flag).w					; are we in non-Super/Hyper state?
		beq.s	.delete								; if so, branch and delete
		tst.w	(Debug_placement_mode).w					; is debug mode on?
		bne.s	.return								; if yes, branch

		; set
		moveq	#4*3,d1								; this will be subtracted from Pos_table_index, giving the object an older entry
		btst	#0,(Level_frame_counter+1).w					; even frame? (Think of it as 'every other number' logic)
		beq.s	.evenframe							; if so, branch
		moveq	#4*5,d1								; on every other frame, use a different number to subtract, giving the object an even older entry

.evenframe
		move.w	(Pos_table_index).w,d0
		lea	(Pos_table).w,a1
		sub.b	d1,d0
		adda.w	d0,a1
		move.w	(a1)+,x_pos(a0)							; use previous player x_pos
		move.w	(a1)+,y_pos(a0)							; use previous player y_pos
		lea	(Stat_table).w,a1
		move.b	3(a1,d0.w),art_tile(a0)
		move.b	(Player_1+mapping_frame).w,mapping_frame(a0)			; use player's current mapping_frame
		move.b	(Player_1+render_flags).w,render_flags(a0)			; use player's current render_flags
		move.w	(Player_1+priority).w,priority(a0)				; use player's current priority

		; draw
		lea	(Sprite_table_input+priority_2).w,a1
		jmp	(Draw_Sprite.find).w
; ---------------------------------------------------------------------------

.return
		rts
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_HyperSonicKnux_Trail:		subObjMainData \
					Obj_HyperSonicKnux_Trail.main, \
						setBit(render_flags.level), \
					0, 48, 48, 0, ArtTile_Player_1, 0, 0, Map_Knuckles
