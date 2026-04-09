; ---------------------------------------------------------------------------
; Dynamic Water level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LZ3_WaterResize:
		move.w	(Camera_X_pos).w,d0
		move.w	#$900,d1
		cmpi.w	#$800,d0							; has screen reached position?
		blo.s	.set_waterlz3							; if not, branch
		cmpi.w	#$3C0,(Player_1+y_pos).w
		blo.s	.set_waterlz3
		cmpi.w	#$600,(Player_1+y_pos).w					; is Sonic in a y-axis range?
		bhs.s	.set_waterlz3							; if not, branch
		move.w	#$4C8,d1							; set new water height
		pea	Redraw_LZ3Chunks(pc)						; modify level layout
		move.l	#Obj_WaveSplash,(Wave_Splash+code_addr).w			; create wave splash object
		move.l	#.routine2,(Level_data_addr_RAM.WaterResize).w			; use second routine next
		sfx	sfx_Rumbling							; play sound $B7 (rumbling)
		move.w	#$3F,(Screen_shaking_flag).w					; screen shake

.set_waterlz3
		move.w	d1,(Target_water_level).w
		move.w	d1,(Mean_water_level).w						; change water height instantly
		rts
; ---------------------------------------------------------------------------

.routine2
		move.w	(Camera_X_pos).w,d0
		move.w	#$4C8,d1
		cmpi.w	#$970,d0
		blo.s	.set_water2
		move.w	#$308,d1
		cmpi.w	#$1600,d0
		blo.s	.set_water2
		cmpi.w	#$508,(Target_water_level).w
		beq.s	.Sonic_is_low
		cmpi.w	#$600,(Player_1+y_pos).w					; is Sonic below $600 y-axis?
		bhs.s	.Sonic_is_low							; if yes, branch
		cmpi.w	#$280,(Player_1+y_pos).w
		bhs.s	.set_water2

.Sonic_is_low
		move.w	#$508,d1
		move.w	d1,(Mean_water_level).w
		cmpi.w	#$1970,d0
		blo.s	.set_water2
		move.l	#.routine3,(Level_data_addr_RAM.WaterResize).w			; use third routine next

.set_water2
		move.w	d1,(Target_water_level).w
		rts
; ---------------------------------------------------------------------------

.routine3
		move.w	(Camera_X_pos).w,d0
		move.w	#$508,d1
		cmpi.w	#$1A60,d0
		blo.s	.set_water3
		move.w	#$188,d1
		cmpi.w	#$1CF0,d0
		bhs.s	.skipX
		cmp.w	(Mean_water_level).w,d1
		bne.s	.set_water3

.skipX
		move.l	#.routine4,(Level_data_addr_RAM.WaterResize).w			; use fourth routine next

.set_water3
		move.w	d1,(Target_water_level).w
		rts
; ---------------------------------------------------------------------------

.routine4
		move.w	(Camera_X_pos).w,d0
		move.w	#$188,d1
		cmpi.w	#$1C70,d0
		blo.s	.set_water4
		cmpi.w	#$600,(Camera_Y_pos).w
		blo.s	.skipY
		move.w	#$900,d1

.skipY
		cmpi.w	#$1DC0,d0
		blo.s	.set_water4
		move.l	#.routine5,(Level_data_addr_RAM.WaterResize).w			; use fifth routine next
		move.w	#$608,(Target_water_level).w
		move.w	#$7C0,(Mean_water_level).w
		move.b	#1,(Level_trigger_array+8).w
		rts
; ---------------------------------------------------------------------------

.set_water4
		move.w	d1,(Target_water_level).w
		move.w	d1,(Mean_water_level).w
		rts
; ---------------------------------------------------------------------------

.routine5
		move.w	(Camera_X_pos).w,d0
		cmpi.w	#$2000,d0							; has screen passed final position?
		blo.s	.dont_set							; if not, branch
		move.w	#$128,(Target_water_level).w

.dont_set
		rts
