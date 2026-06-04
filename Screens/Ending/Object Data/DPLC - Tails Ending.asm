; ---------------------------------------------------------------------------
; DPLC mappings - Tails ending
; ---------------------------------------------------------------------------

DPLC_TailsEnding:	mappingsTable
	mappingsTableEntry.w DPLC_TailsEnding_14
	mappingsTableEntry.w DPLC_TailsEnding_18
	mappingsTableEntry.w DPLC_TailsEnding_1E
	mappingsTableEntry.w DPLC_TailsEnding_22
	mappingsTableEntry.w DPLC_TailsEnding_28
	mappingsTableEntry.w DPLC_TailsEnding_2E
	mappingsTableEntry.w DPLC_TailsEnding_34
	mappingsTableEntry.w DPLC_TailsEnding_3A
	mappingsTableEntry.w DPLC_TailsEnding_40
	mappingsTableEntry.w DPLC_TailsEnding_46

DPLC_TailsEnding_14:	dplcHeader
	dplcEntry	$10, 0
DPLC_TailsEnding_14_End

DPLC_TailsEnding_18:	dplcHeader
	dplcEntry	8, $10
	dplcEntry	$10, 0
DPLC_TailsEnding_18_End

DPLC_TailsEnding_1E:	dplcHeader
	dplcEntry	$10, $18
DPLC_TailsEnding_1E_End

DPLC_TailsEnding_22:	dplcHeader
	dplcEntry	$10, $28
	dplcEntry	1, $38
DPLC_TailsEnding_22_End

DPLC_TailsEnding_28:	dplcHeader
	dplcEntry	$10, $39
	dplcEntry	1, $49
DPLC_TailsEnding_28_End

DPLC_TailsEnding_2E:	dplcHeader
	dplcEntry	$10, $4A
	dplcEntry	1, $5A
DPLC_TailsEnding_2E_End

DPLC_TailsEnding_34:	dplcHeader
	dplcEntry	$10, $5B
	dplcEntry	1, $6B
DPLC_TailsEnding_34_End

DPLC_TailsEnding_3A:	dplcHeader
	dplcEntry	$10, $6C
	dplcEntry	2, $7C
DPLC_TailsEnding_3A_End

DPLC_TailsEnding_40:	dplcHeader
	dplcEntry	$10, $7E
	dplcEntry	8, $8E
DPLC_TailsEnding_40_End

DPLC_TailsEnding_46:	dplcHeader
	dplcEntry	$10, $96
	dplcEntry	$10, $A6
	dplcEntry	$10, $B6
	dplcEntry	$10, $C6
	dplcEntry	$10, $D6
	dplcEntry	$10, $E6
	dplcEntry	4, $F6
DPLC_TailsEnding_46_End

	even
