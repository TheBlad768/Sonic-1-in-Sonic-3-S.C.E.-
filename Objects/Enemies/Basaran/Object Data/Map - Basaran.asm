; ---------------------------------------------------------------------------
; Sprite mappings - Basaran enemy (MZ)
; ---------------------------------------------------------------------------

Map_Bas:
		dc.w SME_u9kpk_8-Map_Bas, SME_u9kpk_10-Map_Bas
		dc.w SME_u9kpk_24-Map_Bas, SME_u9kpk_3E-Map_Bas
SME_u9kpk_8:	dc.b 0, 1
		dc.b $F4, 6, 0, 0, $FF, $F8
SME_u9kpk_10:	dc.b 0, 3
		dc.b $F2, $E, 0, 6, $FF, $F4
		dc.b $A, 4, 0, $12, $FF, $FC
		dc.b 2, 0, 0, $27, 0, $C
SME_u9kpk_24:	dc.b 0, 4
		dc.b $F8, 4, 0, $14, $FF, $F8
		dc.b 0, $C, 0, $16, $FF, $F0
		dc.b 8, 4, 0, $1A, 0, 0
		dc.b 0, 0, 0, $28, 0, $C
SME_u9kpk_3E:	dc.b 0, 4
		dc.b $F6, 9, 0, $1C, $FF, $F5
		dc.b 6, 8, 0, $22, $FF, $F4
		dc.b $E, 4, 0, $25, $FF, $F4
		dc.b $FE, 0, 0, $27, 0, $C
		even
