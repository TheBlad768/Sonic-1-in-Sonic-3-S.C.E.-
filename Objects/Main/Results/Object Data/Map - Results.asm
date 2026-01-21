; ---------------------------------------------------------------------------
; Sprite mappings - results
; ---------------------------------------------------------------------------

Map_Results:
		dc.w 0					; 0 Null
		dc.w word_2F2E2-Map_Results		; 1 (Number 0)
		dc.w word_2F2EA-Map_Results		; 2 (Number 1)
		dc.w word_2F2F2-Map_Results		; 3 (Number 2)
		dc.w word_2F2FA-Map_Results		; 4 (Number 3)
		dc.w word_2F302-Map_Results		; 5 (Number 4)
		dc.w word_2F30A-Map_Results		; 6 (Number 5)
		dc.w word_2F312-Map_Results		; 7 (Number 6)
		dc.w word_2F31A-Map_Results		; 8 (Number 7)
		dc.w word_2F322-Map_Results		; 9 (Number 8)
		dc.w word_2F32A-Map_Results		; A (Number 9)
		dc.w word_2F332-Map_Results		; B (Total)
		dc.w word_2F346-Map_Results		; C (Bonus)
		dc.w word_2F35A-Map_Results		; D (Ring)
		dc.w word_2F362-Map_Results		; E (Time)
		dc.w word_2F36A-Map_Results		; F (ACT)
		dc.w word_2F378-Map_Results		; 10
		dc.w word_2F39E-Map_Results		; 11
		dc.w word_2F3B2-Map_Results		; 12 (SUPER/HYPER)
		dc.w word_2F3C6-Map_Results		; 13 (SONIC)
		dc.w word_2F3DA-Map_Results		; 14 (MILES)
		dc.w word_2F3EE-Map_Results		; 15 (TAILS)
		dc.w word_2F3FC-Map_Results		; 16 (KNUCKLES)
		dc.w word_2F416-Map_Results		; 17 (Score Special Stage)
		dc.w word_2F436-Map_Results		; 18 (Bonus Special Stage)
		dc.w word_2F450-Map_Results		; 19 (Perfect Special Stage)
		dc.w word_2F464-Map_Results		; 1A (Continue Special Stage)
		dc.w word_2F478-Map_Results		; 1B (Emerald 1 Art)
		dc.w word_2F480-Map_Results		; 1C (Emerald 2 Art)
		dc.w word_2F488-Map_Results		; 1D (Emerald 3 Art)
		dc.w word_2F490-Map_Results		; 1E (Emerald 4 Art)
		dc.w word_2F498-Map_Results		; 1F (Emerald 5 Art)
		dc.w word_2F4A0-Map_Results		; 20 (Emerald 6 Art)
		dc.w word_2F4A8-Map_Results		; 21 (Emerald 7 Art)
		dc.w word_2F4B0-Map_Results		; 22
		dc.w word_2F4FA-Map_Results		; 23
		dc.w word_2F514-Map_Results		; 24
		dc.w word_2F55E-Map_Results		; 25
		dc.w word_2F56C-Map_Results		; 26
		dc.w word_2F574-Map_Results		; 27
		dc.w word_2F59C-Map_Results		; 28
		dc.w word_2F5AA-Map_Results		; 29 (Continue Sonic Icon)
		dc.w word_2F5B2-Map_Results		; 2A (Continue Tails Icon)
		dc.w word_2F5BA-Map_Results		; 2B (Continue Knuckles Icon)
		dc.w word_2F6E4-Map_Results		; 2C
		dc.w word_2F6F8-Map_Results		; 2D
		dc.w word_2F5C2-Map_Results		; 2E
		dc.w word_2F5EE-Map_Results		; 2F
		dc.w word_2F638-Map_Results		; 30
		dc.w word_2F682-Map_Results		; 31
		dc.w word_2F6A2-Map_Results		; 32
		dc.w word_2F6BC-Map_Results		; 33
		dc.w word_2F6D0-Map_Results		; 34
		dc.w word_2F70C-Map_Results		; 35
		dc.w word_2F71A-Map_Results		; 36
		dc.w word_2F73A-Map_Results		; 37
		dc.w word_2F754-Map_Results		; 38
		dc.w word_2F768-Map_Results		; 39
		dc.w word_2F588-Map_Results		; 3A
word_2F2E2:
		dc.w 1
		dc.b 0, 1, $A0, 0, 0, 0
word_2F2EA:
		dc.w 1
		dc.b 0, 1, $A0, 2, 0, 0
word_2F2F2:
		dc.w 1
		dc.b 0, 1, $A0, 4, 0, 0
word_2F2FA:
		dc.w 1
		dc.b 0, 1, $A0, 6, 0, 0
word_2F302:
		dc.w 1
		dc.b 0, 1, $A0, 8, 0, 0
word_2F30A:
		dc.w 1
		dc.b 0, 1, $A0, $A, 0, 0
word_2F312:
		dc.w 1
		dc.b 0, 1, $A0, $C, 0, 0
word_2F31A:
		dc.w 1
		dc.b 0, 1, $A0, $E, 0, 0
word_2F322:
		dc.w 1
		dc.b 0, 1, $A0, $10, 0, 0
word_2F32A:
		dc.w 1
		dc.b 0, 1, $A0, $12, 0, 0
word_2F332:
		dc.w 3					; Total
		dc.b 0, 1, $A0, $24, 0, 0
		dc.b 0, $D, $A0, $22, 0, 8
		dc.b $F6, 6, $80, $14, 0, $24		; (Drop Art)
word_2F346:						; Bonus
		dc.w 3
		dc.b 0, $D, $A0, $1A, $FF, $FF
		dc.b 0, 1, $A1, $C8, 0, $20		; HUD address
		dc.b $F6, 6, $80, $14, 0, $24		; (Drop Art)
word_2F35A:
		dc.w 1					; Ring
		dc.b 0, $D, $A1, $CE, 0, 0		; HUD address
word_2F362:
		dc.w 1					; Time
		dc.b 0, $D, $A1, $D6, 0, 0		; HUD address
word_2F36A:						; ACT
		dc.w 2
		dc.b $10, 9, $80, $2A, 0, 0		; ACT
		dc.b 0, $F, $80, $66, 0, $11		; (Number)
word_2F378:
		dc.w 6
		dc.b 0, 5, $80, $40, 0, 0
		dc.b 0, 5, $80, $34, 0, $10
		dc.b 0, 5, $80, $3C, 0, $20
		dc.b 0, 5, $80, $38, 0, $30
		dc.b 0, 5, $80, $44, 0, $40
		dc.b 0, $D, $80, $30, 0, $50
word_2F39E:
		dc.w 3
		dc.b 0, 5, $80, $30, 0, 0
		dc.b 0, 5, $80, $38, 0, $10
		dc.b 0, 5, $80, $40, 0, $1E
word_2F3B2:						; SUPER/HYPER
		dc.w 3
		dc.b 0, $D, $7F, -$20, 0, 0
		dc.b 0, $D, $7F, -$18, 0, $20
		dc.b 0, 5, $7F, -$10, 0, $40
word_2F3C6:						; SONIC
		dc.w 3
		dc.b 0, $D, $80, $48, 0, 1
		dc.b 0, $D, $80, $50, 0, $21
		dc.b 0, 1, $80, $58, 0, $41
word_2F3DA:						; MILES
		dc.w 3
		dc.b 0, $D, $80, $48, 0, 6
		dc.b 0, $D, $80, $50, 0, $26
		dc.b 0, 1, $80, $58, 0, $46
word_2F3EE:						; TAILS
		dc.w 2
		dc.b 0, $D, $80, $48, 0, 1
		dc.b 0, $D, $80, $50, 0, $21
word_2F3FC:						; KNUCKLES
		dc.w 4
		dc.b 0, $D, $80, $48, 0, 4
		dc.b 0, $D, $80, $50, 0, $24
		dc.b 0, $D, $80, $58, 0, $44
		dc.b 0, 9, $80, $60, 0, $64
word_2F416:	dc.w 5						; Score (Special Stage)
		dc.b 0, $D, $E1, $C8, $FF, $A0			; SCOR
		dc.b 0, 1, $E1, $DC, $FF, $C0		; E
		dc.b 0, 9, $A1, $DE, 0, $28
		dc.b 0, $D, $A1, $E4, 0, $40
		dc.b $F6, 6, $80, $14, $FF, $C4		; (Drop Art)
word_2F436:						; Bonus (Special Stage)
		dc.w 4
		dc.b 0, $D, $E1, $CE, 0, 0		; RING
		dc.b 0, $D, $E0, $1A, 0, $28		; BONU
		dc.b 0, 1, $E1, $C8, 0, $48		; S
		dc.b $F6, 6, $80, $14, 0, $4C		; (Drop Art)
word_2F450:						; Perfect (Special Stage)
		dc.w 3
		dc.b 0, $D, $E0, $CC, 0, 0
		dc.b 0, 9, $E0, $D4, 0, $20
		dc.b $F6, 6, $80, $14, 0, $34		; (Drop Art)
word_2F464:						; Continue (Special Stage)
		dc.w 3
		dc.b 0, $D, $E0, $DA, 0, 0
		dc.b 0, $D, $E0, $E2, 0, $20
		dc.b $F6, 6, $80, $14, 0, $3C		; (Drop Art)
word_2F478:
		dc.w 1
		dc.b $F8, 5, $C0, $BC, $FF, $F8		; (Emerald 1 Art)
word_2F480:
		dc.w 1
		dc.b $F8, 5, $C0, $B8, $FF, $F8		; (Emerald 2 Art)
word_2F488:
		dc.w 1
		dc.b $F8, 5, $C0, $C0, $FF, $F8		; (Emerald 3 Art)
word_2F490:
		dc.w 1
		dc.b $F8, 5, $A0, $B8, $FF, $F8		; (Emerald 4 Art)
word_2F498:
		dc.w 1
		dc.b $F8, 5, $80, $C8, $FF, $F8		; (Emerald 5 Art)
word_2F4A0:
		dc.w 1
		dc.b $F8, 5, $80, $C4, $FF, $F8		; (Emerald 6 Art)
word_2F4A8:
		dc.w 1
		dc.b $F8, 5, $A0, $BC, $FF, $F8		; (Emerald 7 Art)
word_2F4B0:
		dc.w $C
		dc.b 0, 5, $80, $A6, $FF, $A0		; S
		dc.b 0, 5, $80, $9E, $FF, $B0		; P
		dc.b 0, 5, $80, $80, $FF, $C0		; E
		dc.b 0, 5, $80, $78, $FF, $D0		; C
		dc.b 0, 1, $80, $8C, $FF, $E0		; I
		dc.b 0, 5, $80, $70, $FF, $E8		; A
		dc.b 0, 5, $80, $8E, $FF, $F8		; L
		dc.b 0, 5, $80, $A6, 0, $10		; S
		dc.b 0, 5, $80, $AA, 0, $20		; T
		dc.b 0, 5, $80, $70, 0, $30		; A
		dc.b 0, 5, $80, $84, 0, $40		; G
		dc.b 0, 5, $80, $80, 0, $50		; E
word_2F4FA:
		dc.w 4
		dc.b 0, 5, $80, $84, 0, 0		; G
		dc.b 0, 5, $80, $9A, 0, $11		; O
		dc.b 0, 5, $80, $AA, 0, $20		; T
		dc.b 0, 5, $80, $70, 0, $38		; A
word_2F514:
		dc.w $C
		dc.b 0, 5, $80, $78, $FF, $9C		; C
		dc.b 0, 5, $80, $88, $FF, $AC		; H
		dc.b 0, 5, $80, $70, $FF, $BC		; A
		dc.b 0, 5, $80, $9A, $FF, $CC		; O
		dc.b 0, 5, $80, $A6, $FF, $DC		; S
		dc.b 0, 5, $80, $80, $FF, $F4		; E
		dc.b 0, 5, $80, $92, 0, 4		; M
		dc.b 0, 5, $80, $80, 0, $14		; E
		dc.b 0, 5, $80, $A2, 0, $24		; R
		dc.b 0, 5, $80, $70, 0, $34		; A
		dc.b 0, 5, $80, $8E, 0, $44		; L
		dc.b 0, 5, $80, $7C, 0, $54		; D
word_2F55E:
		dc.w 2
		dc.b 0, 5, $80, $8E, 0, $48		; L
		dc.b 0, 5, $80, $8E, 0, $56		; L
word_2F56C:
		dc.w 1
		dc.b 0, 5, $80, $A6, 0, $64		; S
word_2F574:
		dc.w 3
		dc.b 0, 5, $E0, $96, 0, 0		; N
		dc.b 0, 5, $E0, $9A, 0, $11		; O
		dc.b 0, 9, $E0, $B2, 0, $20		; W
word_2F588:
		dc.w 3
		dc.b 0, 5, $E0, $78, 0, 0		; C
		dc.b 0, 5, $E0, $70, 0, $10		; A
		dc.b 0, 5, $E0, $96, 0, $20		; N
word_2F59C:
		dc.w 2
		dc.b 0, 5, $E0, $74, 0, 0		; B
		dc.b 0, 5, $E0, $80, 0, $F		; E
word_2F5AA:
		dc.w 1
		dc.b $E8, $A, $80, $EA, $FF, $F4	; (Sonic Icon)
word_2F5B2:
		dc.w 1
		dc.b $E8, $A, $81, $80, $FF, $F4	; (Tails Icon)
word_2F5BA:
		dc.w 1
		dc.b $E8, $A, $81, $89, $FF, $F4	; (Knuckles Icon)
word_2F5C2:	dc.w 7
		dc.b 0, 5, $E5, $2B, $FF, $C0
		dc.b 0, 5, $E5, $23, $FF, $D0
		dc.b 0, 5, $E5, $49, $FF, $E0
		dc.b 0, 5, $E5, $37, $FF, $F8
		dc.b 0, 5, $E5, $4D, 0, 9
		dc.b 0, 5, $E5, $5D, 0, $20
		dc.b 0, 5, $E5, $4D, 0, $30
word_2F5EE:	dc.w $C
		dc.b 0, 5, $E5, $3B, $FF, $A0
		dc.b 0, 1, $E5, $3F, $FF, $B0
		dc.b 0, 5, $E5, $2F, $FF, $B9
		dc.b 0, 5, $E5, $2F, $FF, $CA
		dc.b 0, 5, $E5, $33, $FF, $DA
		dc.b 0, 5, $E5, $49, $FF, $E9
		dc.b 0, 5, $E5, $51, 0, 1
		dc.b 0, 5, $E5, $23, 0, $10
		dc.b 0, 5, $E5, $41, 0, $20
		dc.b 0, 5, $E5, $23, 0, $30
		dc.b 0, 5, $E5, $2B, 0, $40
		dc.b 0, 5, $E5, $33, 0, $50
word_2F638:	dc.w $C
		dc.b 0, 5, $85, $59, $FF, $9C
		dc.b 0, 5, $85, $61, $FF, $AC
		dc.b 0, 5, $85, $51, $FF, $BC
		dc.b 0, 5, $85, $33, $FF, $CC
		dc.b 0, 5, $85, $55, $FF, $DC
		dc.b 0, 5, $85, $33, $FF, $F4
		dc.b 0, 5, $85, $45, 0, 4
		dc.b 0, 5, $85, $33, 0, $14
		dc.b 0, 5, $85, $55, 0, $24
		dc.b 0, 5, $85, $23, 0, $34
		dc.b 0, 5, $85, $41, 0, $44
		dc.b 0, 5, $85, $2F, 0, $54
word_2F682:	dc.w 5
		dc.b 0, $D, $A1, $CA, $FF, $A0
		dc.b 0, 1, $A1, $E2, $FF, $C0
		dc.b 0, 9, $A1, $E4, 0, $28
		dc.b 0, $D, $A1, $EA, 0, $40
		dc.b $F6, 6, $80, $14, $FF, $C4
word_2F6A2:	dc.w 4
		dc.b 0, $D, $A1, $D2, 0, 0
		dc.b 0, $D, $A5, $D2, 0, $28
		dc.b 0, 1, $26, $CA, 0, $48
		dc.b $F6, 6, $80, $14, 0, $4C
word_2F6BC:	dc.w 3
		dc.b 0, $D, $A5, $7F, 0, 0
		dc.b 0, 9, $A5, $87, 0, $20
		dc.b $F6, 6, $80, $14, 0, $34
word_2F6D0:	dc.w 3
		dc.b 0, $D, $A5, $8D, 0, 0
		dc.b 0, $D, $A5, $95, 0, $20
		dc.b $F6, 6, $80, $14, 0, $3C
word_2F6E4:	dc.w 3
		dc.b 0, 5, $85, $49, 0, 0
		dc.b 0, 5, $85, $4D, 0, $11
		dc.b 0, 9, $85, $65, 0, $20
word_2F6F8:	dc.w 3
		dc.b 0, 5, $85, $2B, 0, 0
		dc.b 0, 5, $85, $23, 0, $10
		dc.b 0, 5, $85, $49, 0, $20
word_2F70C:	dc.w 2
		dc.b 0, 5, $85, $27, 0, 0
		dc.b 0, 5, $85, $33, 0, $F
word_2F71A:	dc.w 5
		dc.b 0, $D, $81, $CA, $FF, $A0
		dc.b 0, 1, $81, $E2, $FF, $C0
		dc.b 0, 9, $81, $E4, 0, $28
		dc.b 0, $D, $81, $EA, 0, $40
		dc.b $F6, 6, $80, $14, $FF, $C4
word_2F73A:	dc.w 4
		dc.b 0, $D, $81, $D2, 0, 0
		dc.b 0, $D, $85, $D2, 0, $28
		dc.b 0, 1, 6, $CA, 0, $48
		dc.b $F6, 6, $80, $14, 0, $4C
word_2F754:	dc.w 3
		dc.b 0, $D, $85, $7F, 0, 0
		dc.b 0, 9, $85, $87, 0, $20
		dc.b $F6, 6, $80, $14, 0, $34
word_2F768:	dc.w 3
		dc.b 0, $D, $85, $8D, 0, 0
		dc.b 0, $D, $85, $95, 0, $20
		dc.b $F6, 6, $80, $14, 0, $3C
	even
