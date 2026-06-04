; ---------------------------------------------------------------------------
; DPLC mappings - signpost
; ---------------------------------------------------------------------------

DPLC_Signpost:	mappingsTable
	mappingsTableEntry.w DPLC_Signpost_10
	mappingsTableEntry.w DPLC_Signpost_16
	mappingsTableEntry.w DPLC_Signpost_1C
	mappingsTableEntry.w DPLC_Signpost_22
	mappingsTableEntry.w DPLC_Signpost_28
	mappingsTableEntry.w DPLC_Signpost_2E
	mappingsTableEntry.w DPLC_Signpost_32
	mappingsTableEntry.w DPLC_Signpost_36

DPLC_Signpost_10:	dplcHeader
	dplcEntry	$C, 0
	dplcEntry	$C, $C
DPLC_Signpost_10_End

DPLC_Signpost_16:	dplcHeader
	dplcEntry	$C, $18
	dplcEntry	$C, $24
DPLC_Signpost_16_End

DPLC_Signpost_1C:	dplcHeader
	dplcEntry	$C, $30
	dplcEntry	$C, $3C
DPLC_Signpost_1C_End

DPLC_Signpost_22:	dplcHeader
	dplcEntry	$C, $48
	dplcEntry	$C, $48
DPLC_Signpost_22_End

DPLC_Signpost_28:	dplcHeader
	dplcEntry	$C, $54
	dplcEntry	$C, $60
DPLC_Signpost_28_End

DPLC_Signpost_2E:	dplcHeader
	dplcEntry	$10, $6C
DPLC_Signpost_2E_End

DPLC_Signpost_32:	dplcHeader
	dplcEntry	4, $7C
DPLC_Signpost_32_End

DPLC_Signpost_36:	dplcHeader
	dplcEntry	$10, $6C
DPLC_Signpost_36_End

	even
