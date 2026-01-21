; ---------------------------------------------------------------------------
; DPLC mappings - Tails ending
; ---------------------------------------------------------------------------

DPLC_TailsEnding:
DPLC_TailsEnding_0: 	dc.w DPLC_TailsEnding_14-DPLC_TailsEnding
DPLC_TailsEnding_2: 	dc.w DPLC_TailsEnding_18-DPLC_TailsEnding
DPLC_TailsEnding_4: 	dc.w DPLC_TailsEnding_1E-DPLC_TailsEnding
DPLC_TailsEnding_6: 	dc.w DPLC_TailsEnding_22-DPLC_TailsEnding
DPLC_TailsEnding_8: 	dc.w DPLC_TailsEnding_28-DPLC_TailsEnding
DPLC_TailsEnding_A: 	dc.w DPLC_TailsEnding_2E-DPLC_TailsEnding
DPLC_TailsEnding_C: 	dc.w DPLC_TailsEnding_34-DPLC_TailsEnding
DPLC_TailsEnding_E: 	dc.w DPLC_TailsEnding_3A-DPLC_TailsEnding
DPLC_TailsEnding_10: 	dc.w DPLC_TailsEnding_40-DPLC_TailsEnding
DPLC_TailsEnding_12: 	dc.w DPLC_TailsEnding_46-DPLC_TailsEnding
DPLC_TailsEnding_14: 	dc.b $0, $0
	dc.b $0, $F
DPLC_TailsEnding_18: 	dc.b $0, $1
	dc.b $1, $7
	dc.b $0, $F
DPLC_TailsEnding_1E: 	dc.b $0, $0
	dc.b $1, $8F
DPLC_TailsEnding_22: 	dc.b $0, $1
	dc.b $2, $8F
	dc.b $3, $80
DPLC_TailsEnding_28: 	dc.b $0, $1
	dc.b $3, $9F
	dc.b $4, $90
DPLC_TailsEnding_2E: 	dc.b $0, $1
	dc.b $4, $AF
	dc.b $5, $A0
DPLC_TailsEnding_34: 	dc.b $0, $1
	dc.b $5, $BF
	dc.b $6, $B0
DPLC_TailsEnding_3A: 	dc.b $0, $1
	dc.b $6, $CF
	dc.b $7, $C1
DPLC_TailsEnding_40: 	dc.b $0, $1
	dc.b $7, $EF
	dc.b $8, $E7
DPLC_TailsEnding_46: 	dc.b $0, $6
	dc.b $9, $6F
	dc.b $A, $6F
	dc.b $B, $6F
	dc.b $C, $6F
	dc.b $D, $6F
	dc.b $E, $6F
	dc.b $F, $63
	even
