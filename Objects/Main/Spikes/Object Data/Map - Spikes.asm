; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------

Map_Spikes:
		dc.w SME_TXTT9_C-Map_Spikes, SME_TXTT9_20-Map_Spikes
		dc.w SME_TXTT9_34-Map_Spikes, SME_TXTT9_3C-Map_Spikes
		dc.w SME_TXTT9_50-Map_Spikes, SME_TXTT9_76-Map_Spikes
SME_TXTT9_C:	dc.b 0, 3
		dc.b $F0, 3, 0, 8, $FF, $EC
		dc.b $F0, 3, 0, $C, $FF, $FC
		dc.b $F0, 3, 0, 8, 0, $C
SME_TXTT9_20:	dc.b 0, 3
		dc.b $EC, $C, 8, 0, $FF, $F0
		dc.b $FC, $C, 8, 4, $FF, $F0
		dc.b $C, $C, 8, 0, $FF, $F0
SME_TXTT9_34:	dc.b 0, 1
		dc.b $F0, 3, 0, 8, $FF, $FC
SME_TXTT9_3C:	dc.b 0, 3
		dc.b $F0, 3, 0, 8, $FF, $E4
		dc.b $F0, 3, 0, $C, $FF, $FC
		dc.b $F0, 3, 0, 8, 0, $14
SME_TXTT9_50:	dc.b 0, 6
		dc.b $F0, 3, 0, 8, $FF, $C0
		dc.b $F0, 3, 0, $C, $FF, $D8
		dc.b $F0, 3, 0, 8, $FF, $F0
		dc.b $F0, 3, 0, $C, 0, 8
		dc.b $F0, 3, 0, 8, 0, $20
		dc.b $F0, 3, 0, $C, 0, $38
SME_TXTT9_76:	dc.b 0, 1
		dc.b $FC, $C, 8, 0, $FF, $F0
		even