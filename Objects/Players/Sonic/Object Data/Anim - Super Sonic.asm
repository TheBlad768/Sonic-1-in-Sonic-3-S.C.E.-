; ---------------------------------------------------------------------------
; Sonic Animation Script
; ---------------------------------------------------------------------------

AniSuperSonic: offsetTable
		ptrTableEntry.w SuperSonAni_Walk	; 0
		ptrTableEntry.w SuperSonAni_Run		; 1
		offsetTableEntry.w SonAni_Roll		; 2
		offsetTableEntry.w SonAni_Roll2		; 3
		ptrTableEntry.w SuperSonAni_Push	; 4
		ptrTableEntry.w SuperSonAni_Wait	; 5
		ptrTableEntry.w SuperSonAni_Balance	; 6
		offsetTableEntry.w SonAni_LookUp	; 7
		ptrTableEntry.w SuperSonAni_Duck	; 8
		offsetTableEntry.w SonAni_SpinDash	; 9
		offsetTableEntry.w SonAni_Whistle	; A (Unused)
		offsetTableEntry.w AniSonic0B		; B (Unused?)
		offsetTableEntry.w SonAni_Balance2	; C
		offsetTableEntry.w SonAni_Stop		; D
		offsetTableEntry.w SonAni_Float1	; E
		offsetTableEntry.w SonAni_Float2	; F
		offsetTableEntry.w SonAni_Spring	; 10
		offsetTableEntry.w SonAni_Hang		; 11
		offsetTableEntry.w SonAni_HurtBW	; 12
		offsetTableEntry.w SonAni_Landing	; 13
		offsetTableEntry.w SonAni_Hang2		; 14
		offsetTableEntry.w SonAni_GetAir	; 15
		offsetTableEntry.w SonAni_DeathBW	; 16 (Unused)
		offsetTableEntry.w SonAni_Drown		; 17
		offsetTableEntry.w SonAni_Death		; 18
		offsetTableEntry.w SonAni_Hurt		; 19
		offsetTableEntry.w SonAni_Hurt2		; 1A
		offsetTableEntry.w SonAni_Slide		; 1B
		offsetTableEntry.w SonAni_Blank		; 1C
		offsetTableEntry.w SonAni_Hurt3		; 1D
		offsetTableEntry.w SonAni_Float3	; 1E
		offsetTableEntry.w SonAni_Transform	; 1F
		offsetTableEntry.w AniSonic20		; 20 (Unused?)
		offsetTableEntry.w AniSonic21		; 21 (Unused?)
		offsetTableEntry.w SonAni_Carry		; 22
		offsetTableEntry.w SonAni_Carry2	; 23

SuperSonAni_Walk:		dc.b $FF, 1, 2, 3, 4, 5, 6, 7, 8, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
SuperSonAni_Run:		dc.b $FF, $21, $22, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
SuperSonAni_Push:		dc.b $FD, $B6, $B7, $B8, $B9, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
SuperSonAni_Wait:		dc.b 7, $BA, $BB, afEnd
SuperSonAni_Balance:		dc.b 9, $A1, $A2, $A3, afEnd
SuperSonAni_Duck:		dc.b 5, $9B, afEnd
	even
