; ---------------------------------------------------------------------------
; DPLC mappings - Blue Shield
; ---------------------------------------------------------------------------

DPLC_BlueShield:	mappingsTable
	mappingsTableEntry.w DPLC_BlueShield_C
	mappingsTableEntry.w DPLC_BlueShield_10
	mappingsTableEntry.w DPLC_BlueShield_14
	mappingsTableEntry.w DPLC_BlueShield_18
	mappingsTableEntry.w DPLC_BlueShield_1C
	mappingsTableEntry.w DPLC_BlueShield_20

DPLC_BlueShield_C:	dplcHeader
	dplcEntry	4, 0
DPLC_BlueShield_C_End

DPLC_BlueShield_10:	dplcHeader
	dplcEntry	4, 4
DPLC_BlueShield_10_End

DPLC_BlueShield_14:	dplcHeader
	dplcEntry	4, 8
DPLC_BlueShield_14_End

DPLC_BlueShield_18:	dplcHeader
	dplcEntry	4, $C
DPLC_BlueShield_18_End

DPLC_BlueShield_1C:	dplcHeader
	dplcEntry	4, $10
DPLC_BlueShield_1C_End

DPLC_BlueShield_20:	dplcHeader
	dplcEntry	$C, $14
DPLC_BlueShield_20_End

	even
