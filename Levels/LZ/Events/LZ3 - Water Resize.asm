; ---------------------------------------------------------------------------
; Dynamic Water level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LZ3_WaterResize:
		move.w	(Camera_X_pos).w,d0
		move.w	#$900,d1
		cmpi.w	#$800,d0							; has screen reached position?
		blo.s	.setwaterlz3							; if not, branch
		cmpi.w	#$3C0,(Player_1+y_pos).w
		blo.s	.setwaterlz3
		cmpi.w	#$600,(Player_1+y_pos).w					; is Sonic in a y-axis range?
		bhs.s	.setwaterlz3							; if not, branch
		move.w	#$4C8,d1							; set new water height
		pea	Redraw_LZ3NormalChunks(pc)					; modify level layout
		move.l	#Obj_WaveSplash,(Wave_Splash+address).w				; create wave splash object
		move.l	#.routine2,(Level_data_addr_RAM.WaterResize).w			; use second routine next
		sfx	sfx_Rumbling							; play sound $B7 (rumbling)
		move.w	#$3F,(Screen_shaking_flag).w					; screen shake

.setwaterlz3
		move.w	d1,(Target_water_level).w
		move.w	d1,(Mean_water_level).w						; change water height instantly
		rts
; ---------------------------------------------------------------------------

.routine2
		move.w	(Camera_X_pos).w,d0
		move.w	#$4C8,d1
		cmpi.w	#$970,d0
		blo.s	.setwater2
		move.w	#$308,d1
		cmpi.w	#$1600,d0
		blo.s	.setwater2
		cmpi.w	#$508,(Target_water_level).w
		beq.s	.Sonicislow
		cmpi.w	#$600,(Player_1+y_pos).w					; is Sonic below $600 y-axis?
		bhs.s	.Sonicislow							; if yes, branch
		cmpi.w	#$280,(Player_1+y_pos).w
		bhs.s	.setwater2

.Sonicislow
		move.w	#$508,d1
		move.w	d1,(Mean_water_level).w
		cmpi.w	#$1970,d0
		blo.s	.setwater2
		move.l	#.routine3,(Level_data_addr_RAM.WaterResize).w			; use third routine next

.setwater2
		move.w	d1,(Target_water_level).w
		rts
; ---------------------------------------------------------------------------

.routine3
		move.w	(Camera_X_pos).w,d0
		move.w	#$508,d1
		cmpi.w	#$1A60,d0
		blo.s	.setwater3
		move.w	#$188,d1
		cmpi.w	#$1CF0,d0
		bhs.s	.loc_3DC6
		cmp.w	(Mean_water_level).w,d1
		bne.s	.setwater3

.loc_3DC6
		move.l	#.routine4,(Level_data_addr_RAM.WaterResize).w			; use fourth routine next

.setwater3
		move.w	d1,(Target_water_level).w
		rts
; ---------------------------------------------------------------------------

.routine4
		move.w	(Camera_X_pos).w,d0
		move.w	#$188,d1
		cmpi.w	#$1C70,d0
		blo.s	.setwater4
		cmpi.w	#$600,(Camera_Y_pos).w
		blo.s	.skipY
		move.w	#$900,d1

.skipY
		cmpi.w	#$1DC0,d0
		blo.s	.setwater4
		move.l	#.routine5,(Level_data_addr_RAM.WaterResize).w			; use fifth routine next
		move.w	#$608,(Target_water_level).w
		move.w	#$7C0,(Mean_water_level).w
		move.b	#1,(Level_trigger_array+8).w
		rts
; ---------------------------------------------------------------------------

.setwater4
		move.w	d1,(Target_water_level).w
		move.w	d1,(Mean_water_level).w
		rts
; ---------------------------------------------------------------------------

.routine5
		move.w	(Camera_X_pos).w,d0
		cmpi.w	#$2000,d0							; has screen passed final position?
		blo.s	.dontset							; if not, branch
		move.w	#$128,(Target_water_level).w

.dontset
		rts
