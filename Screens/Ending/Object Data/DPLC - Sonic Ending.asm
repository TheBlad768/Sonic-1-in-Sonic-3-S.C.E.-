; ---------------------------------------------------------------------------
; DPLC mappings - Sonic ending
; ---------------------------------------------------------------------------

DPLC_SonicEnding:
DPLC_SonicEnding_0: 	dc.w DPLC_SonicEnding_14-DPLC_SonicEnding
DPLC_SonicEnding_2: 	dc.w DPLC_SonicEnding_1A-DPLC_SonicEnding
DPLC_SonicEnding_4: 	dc.w DPLC_SonicEnding_22-DPLC_SonicEnding
DPLC_SonicEnding_6: 	dc.w DPLC_SonicEnding_28-DPLC_SonicEnding
DPLC_SonicEnding_8: 	dc.w DPLC_SonicEnding_2E-DPLC_SonicEnding
DPLC_SonicEnding_A: 	dc.w DPLC_SonicEnding_34-DPLC_SonicEnding
DPLC_SonicEnding_C: 	dc.w DPLC_SonicEnding_3A-DPLC_SonicEnding
DPLC_SonicEnding_E: 	dc.w DPLC_SonicEnding_40-DPLC_SonicEnding
DPLC_SonicEnding_10: 	dc.w DPLC_SonicEnding_44-DPLC_SonicEnding
DPLC_SonicEnding_12: 	dc.w DPLC_SonicEnding_4C-DPLC_SonicEnding
DPLC_SonicEnding_14: 	dc.b $0, $1
	dc.b $0, $F
	dc.b $1, $1
DPLC_SonicEnding_1A: 	dc.b $0, $2
	dc.b $1, $27
	dc.b $0, $F
	dc.b $1, $1
DPLC_SonicEnding_22: 	dc.b $0, $1
	dc.b $1, $AF
	dc.b $2, $A1
DPLC_SonicEnding_28: 	dc.b $0, $1
	dc.b $2, $CF
	dc.b $3, $C1
DPLC_SonicEnding_2E: 	dc.b $0, $1
	dc.b $2, $CF
	dc.b $3, $C1
DPLC_SonicEnding_34: 	dc.b $0, $1
	dc.b $3, $EF
	dc.b $4, $E2
DPLC_SonicEnding_3A: 	dc.b $0, $1
	dc.b $5, $1F
	dc.b $6, $14
DPLC_SonicEnding_40: 	dc.b $0, $0
	dc.b $6, $6F
DPLC_SonicEnding_44: 	dc.b $0, $2
	dc.b $7, $6F
	dc.b $8, $6F
	dc.b $9, $66
DPLC_SonicEnding_4C: 	dc.b $0, $4
	dc.b $9, $DF
	dc.b $A, $DF
	dc.b $B, $DF
	dc.b $C, $DF
	dc.b $D, $DE
	even
