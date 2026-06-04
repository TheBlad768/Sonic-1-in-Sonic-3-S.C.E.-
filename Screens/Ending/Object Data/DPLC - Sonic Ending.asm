; ---------------------------------------------------------------------------
; DPLC mappings - Sonic ending
; ---------------------------------------------------------------------------

DPLC_SonicEnding:	mappingsTable
	mappingsTableEntry.w DPLC_SonicEnding_14
	mappingsTableEntry.w DPLC_SonicEnding_1A
	mappingsTableEntry.w DPLC_SonicEnding_22
	mappingsTableEntry.w DPLC_SonicEnding_28
	mappingsTableEntry.w DPLC_SonicEnding_2E
	mappingsTableEntry.w DPLC_SonicEnding_34
	mappingsTableEntry.w DPLC_SonicEnding_3A
	mappingsTableEntry.w DPLC_SonicEnding_40
	mappingsTableEntry.w DPLC_SonicEnding_44
	mappingsTableEntry.w DPLC_SonicEnding_4C

DPLC_SonicEnding_14:	dplcHeader
	dplcEntry	$10, 0
	dplcEntry	2, $10
DPLC_SonicEnding_14_End

DPLC_SonicEnding_1A:	dplcHeader
	dplcEntry	8, $12
	dplcEntry	$10, 0
	dplcEntry	2, $10
DPLC_SonicEnding_1A_End

DPLC_SonicEnding_22:	dplcHeader
	dplcEntry	$10, $1A
	dplcEntry	2, $2A
DPLC_SonicEnding_22_End

DPLC_SonicEnding_28:	dplcHeader
	dplcEntry	$10, $2C
	dplcEntry	2, $3C
DPLC_SonicEnding_28_End

DPLC_SonicEnding_2E:	dplcHeader
	dplcEntry	$10, $2C
	dplcEntry	2, $3C
DPLC_SonicEnding_2E_End

DPLC_SonicEnding_34:	dplcHeader
	dplcEntry	$10, $3E
	dplcEntry	3, $4E
DPLC_SonicEnding_34_End

DPLC_SonicEnding_3A:	dplcHeader
	dplcEntry	$10, $51
	dplcEntry	5, $61
DPLC_SonicEnding_3A_End

DPLC_SonicEnding_40:	dplcHeader
	dplcEntry	$10, $66
DPLC_SonicEnding_40_End

DPLC_SonicEnding_44:	dplcHeader
	dplcEntry	$10, $76
	dplcEntry	$10, $86
	dplcEntry	7, $96
DPLC_SonicEnding_44_End

DPLC_SonicEnding_4C:	dplcHeader
	dplcEntry	$10, $9D
	dplcEntry	$10, $AD
	dplcEntry	$10, $BD
	dplcEntry	$10, $CD
	dplcEntry	$F, $DD
DPLC_SonicEnding_4C_End

	even
