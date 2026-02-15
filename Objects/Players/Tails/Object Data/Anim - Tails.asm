; ---------------------------------------------------------------------------
; Tails Animation Script
; ---------------------------------------------------------------------------

AniTails: offsetTable
		ptrTableEntry.w TailsAni_Walk		; 0
		ptrTableEntry.w TailsAni_Run		; 1
		ptrTableEntry.w TailsAni_Roll		; 2
		ptrTableEntry.w TailsAni_Roll2		; 3
		ptrTableEntry.w TailsAni_Push		; 4
		ptrTableEntry.w TailsAni_Wait		; 5
		ptrTableEntry.w TailsAni_Balance	; 6
		ptrTableEntry.w TailsAni_LookUp		; 7
		ptrTableEntry.w TailsAni_Duck		; 8
		ptrTableEntry.w TailsAni_SpinDash	; 9
		ptrTableEntry.w AniTails0A		; A (Unused)
		ptrTableEntry.w AniTails0B		; B (Unused?)
		ptrTableEntry.w TailsAni_Balance2	; C
		ptrTableEntry.w TailsAni_Stop		; D
		ptrTableEntry.w TailsAni_Float1		; E
		ptrTableEntry.w TailsAni_Float2		; F
		ptrTableEntry.w TailsAni_Spring		; 10
		ptrTableEntry.w TailsAni_Hang		; 11
		ptrTableEntry.w TailsAni_HurtBW		; 12
		ptrTableEntry.w TailsAni_Landing	; 13
		ptrTableEntry.w TailsAni_Hang2		; 14
		ptrTableEntry.w TailsAni_GetAir		; 15
		ptrTableEntry.w TailsAni_DeathBW	; 16 (Unused)
		ptrTableEntry.w TailsAni_Drown		; 17
		ptrTableEntry.w TailsAni_Death		; 18
		ptrTableEntry.w TailsAni_Hurt		; 19
		ptrTableEntry.w TailsAni_Hurt2		; 1A
		ptrTableEntry.w TailsAni_Slide		; 1B
		ptrTableEntry.w TailsAni_Blank		; 1C
		ptrTableEntry.w TailsAni_Hurt3		; 1D
		ptrTableEntry.w TailsAni_Float3		; 1E
		ptrTableEntry.w TailsAni_Run2		; 1F
		ptrTableEntry.w AniTails20		; 20
		ptrTableEntry.w AniTails21		; 21 (Unused?)
		ptrTableEntry.w AniTails22		; 22
		ptrTableEntry.w AniTails23		; 23
		ptrTableEntry.w AniTails24		; 24
		ptrTableEntry.w AniTails25		; 25
		ptrTableEntry.w AniTails26		; 26
		ptrTableEntry.w AniTails27		; 27
		ptrTableEntry.w AniTails28		; 28
		ptrTableEntry.w TailsAni_Transform	; 29
		ptrTableEntry.w AniTails2A		; 2A

TailsAni_Walk:		dc.b $FF, 7, 8, 1, 2, 3, 4, 5, 6, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
TailsAni_Run:		dc.b $FF, $21, $22, $23, $24, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
TailsAni_Run2:		dc.b $FF, $C3, $C4, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
TailsAni_Roll:		dc.b 1, $96, $97, $98, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
TailsAni_Roll2:		dc.b 0, $96, $97, $98, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
TailsAni_Push:		dc.b $FD, $A9, $AA, $AB, $AC, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
TailsAni_Wait:		dc.b 7, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AF, $AE, $AD, $AD, $AD, $AD, $AD, $AD, $AD
			dc.b $AD, $AF, $AE, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B1
			dc.b $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B2, $B3, $B4, $B3, $B4, $B3, $B4, $B3, $B4, $B3, $B4, $B2
			dc.b afBack, $1C
TailsAni_Balance:	dc.b 9, $9A, $9A, $9B, $9B, $9A, $9A, $9B, $9B, $9A, $9A, $9B, $9B, $9A, $9A, $9B, $9B, $9A, $9A, $9B
			dc.b $9B, $9A, $9B, afEnd
TailsAni_LookUp:	dc.b $3F, $B0, afEnd
TailsAni_Duck:		dc.b $3F, $99, afEnd
TailsAni_SpinDash:	dc.b 0, $86, $87, $88, afEnd
AniTails0A:		dc.b $3F, $82, afEnd
AniTails0B:		dc.b $F, $8D, afEnd
TailsAni_Balance2:	dc.b 9, $A4, $9B, afEnd
TailsAni_Stop:		dc.b 3, $8E, $8F, $8E, $8F, afChange, 0
TailsAni_Float1:	dc.b 9, $B5, afEnd
TailsAni_Float2:	dc.b 9, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, afEnd
TailsAni_Spring:	dc.b 3, $8B, $8C, $8B, $8C, $8B, $8C, $8B, $8C, $8B, $8C, $8B, $8C, afChange, 0
TailsAni_Hang:		dc.b 1, $9D, $9E, afEnd
TailsAni_HurtBW:	dc.b $40, $F5, afEnd
TailsAni_Landing:	dc.b $F, $A5, $A6, afBack, 1
TailsAni_Hang2:		dc.b $13, $91, afEnd
TailsAni_GetAir:	dc.b $B, $9F, $9F, 3, 4, afChange, 0
TailsAni_DeathBW:	dc.b $20, $F3, afEnd
TailsAni_Drown:		dc.b $20, $9C, afEnd
TailsAni_Death:		dc.b $20, $9C, afEnd
TailsAni_Hurt:		dc.b 9, $CB, $CC, afEnd
TailsAni_Hurt2:		dc.b $40, $8A, afEnd
TailsAni_Slide:		dc.b 9, $89, $8A, afEnd
TailsAni_Blank:		dc.b $77, 0, afEnd
TailsAni_Hurt3:		dc.b 3, 1, 2, 3, 4, 5, 6, 7, 8, afEnd
TailsAni_Float3:	dc.b 3, 1, 2, 3, 4, 5, 6, 7, 8, afEnd
AniTails20:		dc.b $1F, $A0, afEnd
AniTails21:		dc.b $1F, $A0, afEnd
AniTails22:		dc.b $1F, $A2, afEnd
AniTails23:		dc.b $1F, $A1, afEnd
AniTails24:		dc.b $B, $A3, $A4, afEnd
AniTails25:		dc.b 7, $BD, $BE, $BF, $C0, $C1, afEnd
AniTails26:		dc.b 3, $BD, $BE, $BF, $C0, $C1, afEnd
AniTails27:		dc.b 4, $CF, $D0, afEnd
AniTails28:		dc.b $B, $C2, $CD, $CE, afEnd
TailsAni_Transform:	dc.b 2, $EB, $EB, $EC, $ED, $EC, $ED, $EC, $ED, $EC, $ED, $EC, $ED, afChange, 0
AniTails2A:		dc.b 5, $F0, $F0, $EF, $F0, $EF, $F0, $F1, $F2, afBack, 1
	even
