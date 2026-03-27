; ---------------------------------------------------------------------------
; DPLC mappings - signpost
; ---------------------------------------------------------------------------

DPLC_Signpost:
DPLC_Signpost_0: 	dc.w DPLC_Signpost_10-DPLC_Signpost
DPLC_Signpost_2: 	dc.w DPLC_Signpost_16-DPLC_Signpost
DPLC_Signpost_4: 	dc.w DPLC_Signpost_1C-DPLC_Signpost
DPLC_Signpost_6: 	dc.w DPLC_Signpost_22-DPLC_Signpost
DPLC_Signpost_8: 	dc.w DPLC_Signpost_28-DPLC_Signpost
DPLC_Signpost_A: 	dc.w DPLC_Signpost_2E-DPLC_Signpost
DPLC_Signpost_C: 	dc.w DPLC_Signpost_32-DPLC_Signpost
DPLC_Signpost_E: 	dc.w DPLC_Signpost_36-DPLC_Signpost
DPLC_Signpost_10: 	dc.b $0, $1
	dc.b $0, $B
	dc.b $0, $CB
DPLC_Signpost_16: 	dc.b $0, $1
	dc.b $1, $8B
	dc.b $2, $4B
DPLC_Signpost_1C: 	dc.b $0, $1
	dc.b $3, $B
	dc.b $3, $CB
DPLC_Signpost_22: 	dc.b $0, $1
	dc.b $4, $8B
	dc.b $4, $8B
DPLC_Signpost_28: 	dc.b $0, $1
	dc.b $5, $4B
	dc.b $6, $B
DPLC_Signpost_2E: 	dc.b $0, $0
	dc.b $6, $CF
DPLC_Signpost_32: 	dc.b $0, $0
	dc.b $7, $C3
DPLC_Signpost_36: 	dc.b $0, $0
	dc.b $6, $CF
	even
