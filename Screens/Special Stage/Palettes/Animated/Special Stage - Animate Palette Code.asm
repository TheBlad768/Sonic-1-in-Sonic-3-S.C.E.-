; ---------------------------------------------------------------------------
; Animated palette routine - Special Stage (VInt)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PalCycle_SS:

		; check
		tst.b	(Game_paused).w							; is the game paused?
		bne.s	.return								; if yes, branch

		; wait
		subq.w	#1,(v_palss_time).w
		bpl.s	.return

		; cycle
		moveq	#$1F,d0
		and.w	(v_palss_num).w,d0
		addq.w	#1,(v_palss_num).w
		add.w	d0,d0
		add.w	d0,d0
		lea	byte_4A3C(pc),a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	.loc_4992
		move.w	#$200-1,d0

.loc_4992
		move.w	d0,(v_palss_time).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,(v_ssbganim).w
		lea	byte_4ABC(pc),a1
		adda.w	d0,a1
		move.w	#$8200,d0							; set foreground nametable address
		move.b	(a1)+,d0
		move.w	d0,VDP_control_port-VDP_control_port(a5)
		move.b	(a1),(V_scroll_value).w
		move.w	#$8400,d0							; set background nametable address
		move.b	(a0)+,d0
		move.w	d0,VDP_control_port-VDP_control_port(a5)
		move.l	#vdpComm(0,VSRAM,WRITE),VDP_control_port-VDP_control_port(a5)
		move.l	(V_scroll_value).w,VDP_data_port-VDP_data_port(a6)		; send screen ypos to VSRAM
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	.loc_49E8

		; process
		lea	(Pal_SSCyc1).l,a1
		adda.w	d0,a1
		lea	(Normal_palette_line_3+$C).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

.return
		rts
; ---------------------------------------------------------------------------

.loc_49E8
		lea	(Pal_SSCyc2).l,a1
		cmpi.w	#$8A,d0
		blo.s	.loc_49F4
		lea	$2A(a1),a1							; palette size is $2A(21 colors) bytes (multiply by 0 or 1)

.loc_49F4

		; process
		andi.w	#$7F,d0
		bclr	#0,d0
		beq.s	.loc_4A18
		lea	(Normal_palette_line_4+$C).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

.loc_4A18
		lea	$C(a1),a1
		lea	(Normal_palette_line_3+$18).w,a2
		cmpi.w	#10,d0
		blo.s	.loc_4A2E
		subi.w	#10,d0
		lea	(Normal_palette_line_4+$18).w,a2

.loc_4A2E
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------

byte_4A3C:

		; palss time(-1 = $1FF), v_ssbganim, background nametable address, BG palette update flag(>$80 = branch)
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 18, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 16, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 14, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 12, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 10, TRUE, TRUE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 0, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 2, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 4, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 6, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_B_Name_Table, 8, TRUE, FALSE
		SSBGData 7, 8, VRAM_Plane_B_Name_Table, 0, FALSE, FALSE
		SSBGData 7, 10, VRAM_Plane_B_Name_Table, 1, FALSE, FALSE
		SSBGData -1, 12, VRAM_Plane_B_Name_Table, 2, FALSE, FALSE
		SSBGData -1, 12, VRAM_Plane_B_Name_Table, 2, FALSE, FALSE
		SSBGData 7, 10, VRAM_Plane_B_Name_Table, 1, FALSE, FALSE
		SSBGData 7, 8, VRAM_Plane_B_Name_Table, 0, FALSE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 8, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 6, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 4, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 2, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 0, TRUE, TRUE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 10, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 12, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 14, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 16, TRUE, FALSE
		SSBGData 3, 0, VRAM_Plane_A_Name_Table, 18, TRUE, FALSE
		SSBGData 7, 2, VRAM_Plane_A_Name_Table, 3, FALSE, FALSE
		SSBGData 7, 4, VRAM_Plane_A_Name_Table, 4, FALSE, FALSE
		SSBGData -1, 6, VRAM_Plane_A_Name_Table, 5, FALSE, FALSE
		SSBGData -1, 6, VRAM_Plane_A_Name_Table, 5, FALSE, FALSE
		SSBGData 7, 4, VRAM_Plane_A_Name_Table, 4, FALSE, FALSE
		SSBGData 7, 2, VRAM_Plane_A_Name_Table, 3, FALSE, FALSE

byte_4ABC:

		; set foreground nametable address, V_scroll_value
		SSFGData $4000, $100
		SSFGData $6000, 0
		SSFGData $6000, $100
		SSFGData $8000, 0
		SSFGData $8000, $100
		SSFGData $A000, 0
		SSFGData $A000, $100
