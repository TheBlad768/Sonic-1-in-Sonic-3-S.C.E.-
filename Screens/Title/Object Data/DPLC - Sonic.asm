; ---------------------------------------------------------------------------
; Sprite DPLC mappings - Sonic on the title screen
; ---------------------------------------------------------------------------

DPLC_TSon:	mappingsTable
	mappingsTableEntry.w DPLC_TSon_10
	mappingsTableEntry.w DPLC_TSon_1C
	mappingsTableEntry.w DPLC_TSon_2E
	mappingsTableEntry.w DPLC_TSon_44
	mappingsTableEntry.w DPLC_TSon_52
	mappingsTableEntry.w DPLC_TSon_60
	mappingsTableEntry.w DPLC_TSon_72
	mappingsTableEntry.w DPLC_TSon_88

DPLC_TSon_10:	dplcHeader
	dplcEntry	$10, 0
	dplcEntry	$10, $10
	dplcEntry	$10, $20
	dplcEntry	$10, $30
	dplcEntry	$F, $40
DPLC_TSon_10_End

DPLC_TSon_1C:	dplcHeader
	dplcEntry	$10, $1BD
	dplcEntry	3, $1CD
	dplcEntry	$10, $4F
	dplcEntry	$10, $5F
	dplcEntry	$10, $6F
	dplcEntry	$10, $7F
	dplcEntry	$10, $8F
	dplcEntry	4, $9F
DPLC_TSon_1C_End

DPLC_TSon_2E:	dplcHeader
	dplcEntry	$10, $1BD
	dplcEntry	3, $1CD
	dplcEntry	$10, $1A9
	dplcEntry	4, $1B9
	dplcEntry	$10, $4F
	dplcEntry	$10, $5F
	dplcEntry	$10, $6F
	dplcEntry	$10, $7F
	dplcEntry	$10, $8F
	dplcEntry	4, $9F
DPLC_TSon_2E_End

DPLC_TSon_44:	dplcHeader
	dplcEntry	$10, $A3
	dplcEntry	$10, $B3
	dplcEntry	$10, $C3
	dplcEntry	$10, $D3
	dplcEntry	$10, $E3
	dplcEntry	3, $F3
DPLC_TSon_44_End

DPLC_TSon_52:	dplcHeader
	dplcEntry	$10, $F6
	dplcEntry	$10, $106
	dplcEntry	$10, $116
	dplcEntry	$10, $126
	dplcEntry	$10, $136
	dplcEntry	4, $146
DPLC_TSon_52_End

DPLC_TSon_60:	dplcHeader
	dplcEntry	$10, $1E4
	dplcEntry	5, $1F4
	dplcEntry	$10, $14A
	dplcEntry	$10, $15A
	dplcEntry	$10, $16A
	dplcEntry	$10, $17A
	dplcEntry	$10, $18A
	dplcEntry	$F, $19A
DPLC_TSon_60_End

DPLC_TSon_72:	dplcHeader
	dplcEntry	$10, $1E4
	dplcEntry	5, $1F4
	dplcEntry	$10, $1D0
	dplcEntry	4, $1E0
	dplcEntry	$10, $14A
	dplcEntry	$10, $15A
	dplcEntry	$10, $16A
	dplcEntry	$10, $17A
	dplcEntry	$10, $18A
	dplcEntry	$F, $19A
DPLC_TSon_72_End

DPLC_TSon_88:	dplcHeader
	dplcEntry	$10, $1F9
	dplcEntry	4, $209
	dplcEntry	$10, $1D0
	dplcEntry	4, $1E0
	dplcEntry	$10, $14A
	dplcEntry	$10, $15A
	dplcEntry	$10, $16A
	dplcEntry	$10, $17A
	dplcEntry	$10, $18A
	dplcEntry	$F, $19A
DPLC_TSon_88_End

	even
