DPLC_ebcb: mappingsTable
	mappingsTableEntry.w	DPLC_ebcb_0
	mappingsTableEntry.w	DPLC_ebcb_1

DPLC_ebcb_0:	dplcHeader
DPLC_ebcb_0_End

DPLC_ebcb_1:	dplcHeader
 dplcEntry $10, 0
 dplcEntry 8, $10
DPLC_ebcb_1_End

	even