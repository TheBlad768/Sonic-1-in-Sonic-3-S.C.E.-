DPLC_BigRingFlash:	mappingsTable
	mappingsTableEntry.w word_61C02
	mappingsTableEntry.w word_61C0A
	mappingsTableEntry.w word_61C12
	mappingsTableEntry.w word_61C1C

word_61C02:	dplcHeader
	dplcEntry	3, 0
	dplcEntry	6, 3
	dplcEntry	1, 9
word_61C02_End

word_61C0A:	dplcHeader
	dplcEntry	4, $A
	dplcEntry	8, $E
	dplcEntry	2, $16
word_61C0A_End

word_61C12:	dplcHeader
	dplcEntry	3, $18
	dplcEntry	$C, $1B
	dplcEntry	4, $27
	dplcEntry	2, $2B
word_61C12_End

word_61C1C:	dplcHeader
	dplcEntry	3, $18
	dplcEntry	$C, $1B
word_61C1C_End

	even
