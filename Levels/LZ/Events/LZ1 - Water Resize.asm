; ---------------------------------------------------------------------------
; Dynamic Water level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LZ1_WaterResize:
		move.w	(Camera_X_pos).w,d0
		move.w	#$B8,d1								; water height
		cmpi.w	#$800,d0							; has screen reached next position?
		blo.s	.setwater							; if not, branch
		move.w	#$108,d1
		cmpi.w	#$200,(Player_1+y_pos).w					; is Sonic above $200 y-axis?
		blo.s	.Sonicishigh							; if yes, branch
		cmpi.w	#$E00,d0
		blo.s	.setwater
		move.w	#$318,d1
		cmpi.w	#$1280,d0
		blo.s	.setwater
		move.b	#$80,(Level_trigger_array+5).w
		move.w	#$5C8,d1
		cmpi.w	#$1580,d0
		blo.s	.setwater
		move.w	#$3A8,d1
		cmp.w	(Mean_water_level).w,d1						; has water reached last height?
		bne.s	.setwater							; if not, branch
		move.l	#.routine2,(Level_data_addr_RAM.WaterResize).w			; use second routine next

.setwater
		move.w	d1,(Target_water_level).w
		rts
; ---------------------------------------------------------------------------

.Sonicishigh
		cmpi.w	#$E80,d0
		blo.s	.setwater
		move.w	#$E8,d1
		cmpi.w	#$1700,d0
		blo.s	.setwater
		move.w	#$108,d1
		bra.s	.setwater
; ---------------------------------------------------------------------------

.routine2
		move.w	(Camera_X_pos).w,d0
		cmpi.w	#$2E0,(Player_1+y_pos).w					; is Sonic above $2E0 y-axis?
		bhs.s	.skip								; if not, branch
		move.w	#$3A8,d1
		cmpi.w	#$1500,d0
		blo.s	.setwater2
		move.w	#$108,d1
		move.l	#.skip,(Level_data_addr_RAM.WaterResize).w

.setwater2
		move.w	d1,(Target_water_level).w

.skip
		rts
