; ---------------------------------------------------------------------------
; Sprite mappings - results
; ---------------------------------------------------------------------------

Map_Results:	mappingsTable
	dc.w 0		; 0 Null
	mappingsTableEntry.w word_2F2E2		; 1 (Number 0)
	mappingsTableEntry.w word_2F2EA		; 2 (Number 1)
	mappingsTableEntry.w word_2F2F2		; 3 (Number 2)
	mappingsTableEntry.w word_2F2FA		; 4 (Number 3)
	mappingsTableEntry.w word_2F302		; 5 (Number 4)
	mappingsTableEntry.w word_2F30A		; 6 (Number 5)
	mappingsTableEntry.w word_2F312		; 7 (Number 6)
	mappingsTableEntry.w word_2F31A		; 8 (Number 7)
	mappingsTableEntry.w word_2F322		; 9 (Number 8)
	mappingsTableEntry.w word_2F32A		; A (Number 9)
	mappingsTableEntry.w word_2F332		; B (Total)
	mappingsTableEntry.w word_2F346		; C (Bonus)
	mappingsTableEntry.w word_2F35A		; D (Ring)
	mappingsTableEntry.w word_2F362		; E (Time)
	mappingsTableEntry.w word_2F36A		; F (ACT)
	mappingsTableEntry.w word_2F378		; 10
	mappingsTableEntry.w word_2F39E		; 11
	mappingsTableEntry.w word_2F3B2		; 12 (SUPER/HYPER)
	mappingsTableEntry.w word_2F3C6		; 13 (SONIC)
	mappingsTableEntry.w word_2F3DA		; 14 (MILES)
	mappingsTableEntry.w word_2F3EE		; 15 (TAILS)
	mappingsTableEntry.w word_2F3FC		; 16 (KNUCKLES)
	mappingsTableEntry.w word_2F416		; 17 (Score Special Stage)
	mappingsTableEntry.w word_2F436		; 18 (Bonus Special Stage)
	mappingsTableEntry.w word_2F450		; 19 (Perfect Special Stage)
	mappingsTableEntry.w word_2F464		; 1A (Continue Special Stage)
	mappingsTableEntry.w word_2F478		; 1B (Emerald 1 Art)
	mappingsTableEntry.w word_2F480		; 1C (Emerald 2 Art)
	mappingsTableEntry.w word_2F488		; 1D (Emerald 3 Art)
	mappingsTableEntry.w word_2F490		; 1E (Emerald 4 Art)
	mappingsTableEntry.w word_2F498		; 1F (Emerald 5 Art)
	mappingsTableEntry.w word_2F4A0		; 20 (Emerald 6 Art)
	mappingsTableEntry.w word_2F4A8		; 21 (Emerald 7 Art)
	mappingsTableEntry.w word_2F4B0		; 22
	mappingsTableEntry.w word_2F4FA		; 23
	mappingsTableEntry.w word_2F514		; 24
	mappingsTableEntry.w word_2F55E		; 25
	mappingsTableEntry.w word_2F56C		; 26
	mappingsTableEntry.w word_2F574		; 27
	mappingsTableEntry.w word_2F59C		; 28
	mappingsTableEntry.w word_2F5AA		; 29 (Continue Sonic Icon)
	mappingsTableEntry.w word_2F5B2		; 2A (Continue Tails Icon)
	mappingsTableEntry.w word_2F5BA		; 2B (Continue Knuckles Icon)
	mappingsTableEntry.w word_2F6E4		; 2C
	mappingsTableEntry.w word_2F6F8		; 2D
	mappingsTableEntry.w word_2F5C2		; 2E
	mappingsTableEntry.w word_2F5EE		; 2F
	mappingsTableEntry.w word_2F638		; 30
	mappingsTableEntry.w word_2F682		; 31
	mappingsTableEntry.w word_2F6A2		; 32
	mappingsTableEntry.w word_2F6BC		; 33
	mappingsTableEntry.w word_2F6D0		; 34
	mappingsTableEntry.w word_2F70C		; 35
	mappingsTableEntry.w word_2F71A		; 36
	mappingsTableEntry.w word_2F73A		; 37
	mappingsTableEntry.w word_2F754		; 38
	mappingsTableEntry.w word_2F768		; 39
	mappingsTableEntry.w word_2F588		; 3A

word_2F2E2:	spriteHeader
	spritePiece	0, 0, 1, 2, 0, 0, 0, 1, 1
word_2F2E2_End

word_2F2EA:	spriteHeader
	spritePiece	0, 0, 1, 2, 2, 0, 0, 1, 1
word_2F2EA_End

word_2F2F2:	spriteHeader
	spritePiece	0, 0, 1, 2, 4, 0, 0, 1, 1
word_2F2F2_End

word_2F2FA:	spriteHeader
	spritePiece	0, 0, 1, 2, 6, 0, 0, 1, 1
word_2F2FA_End

word_2F302:	spriteHeader
	spritePiece	0, 0, 1, 2, 8, 0, 0, 1, 1
word_2F302_End

word_2F30A:	spriteHeader
	spritePiece	0, 0, 1, 2, $A, 0, 0, 1, 1
word_2F30A_End

word_2F312:	spriteHeader
	spritePiece	0, 0, 1, 2, $C, 0, 0, 1, 1
word_2F312_End

word_2F31A:	spriteHeader
	spritePiece	0, 0, 1, 2, $E, 0, 0, 1, 1
word_2F31A_End

word_2F322:	spriteHeader
	spritePiece	0, 0, 1, 2, $10, 0, 0, 1, 1
word_2F322_End

word_2F32A:	spriteHeader
	spritePiece	0, 0, 1, 2, $12, 0, 0, 1, 1
word_2F32A_End

word_2F332:	spriteHeader
	spritePiece	0, 0, 1, 2, $24, 0, 0, 1, 1
	spritePiece	8, 0, 4, 2, $22, 0, 0, 1, 1
	spritePiece	$24, -$A, 2, 3, $14, 0, 0, 0, 1		; (Drop Art)
word_2F332_End

word_2F346:	spriteHeader
	spritePiece	-1, 0, 4, 2, $1A, 0, 0, 1, 1
	spritePiece	$20, 0, 1, 2, $1C8, 0, 0, 1, 1		; HUD address
	spritePiece	$24, -$A, 2, 3, $14, 0, 0, 0, 1		; (Drop Art)
word_2F346_End

word_2F35A:	spriteHeader
	spritePiece	0, 0, 4, 2, $1CE, 0, 0, 1, 1		; HUD address
word_2F35A_End

word_2F362:	spriteHeader
	spritePiece	0, 0, 4, 2, $1D6, 0, 0, 1, 1		; HUD address
word_2F362_End

word_2F36A:	spriteHeader
	spritePiece	0, $10, 3, 2, $2A, 0, 0, 0, 1		; ACT
	spritePiece	$11, 0, 4, 4, $66, 0, 0, 0, 1		; (Number)
word_2F36A_End

word_2F378:	spriteHeader
	spritePiece	0, 0, 2, 2, $40, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $34, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $3C, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $38, 0, 0, 0, 1
	spritePiece	$40, 0, 2, 2, $44, 0, 0, 0, 1
	spritePiece	$50, 0, 4, 2, $30, 0, 0, 0, 1
word_2F378_End

word_2F39E:	spriteHeader
	spritePiece	0, 0, 2, 2, $30, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $38, 0, 0, 0, 1
	spritePiece	$1E, 0, 2, 2, $40, 0, 0, 0, 1
word_2F39E_End

word_2F3B2:	spriteHeader
	spritePiece	0, 0, 4, 2, $7E0, 1, 1, 3, 0
	spritePiece	$20, 0, 4, 2, $7E8, 1, 1, 3, 0
	spritePiece	$40, 0, 2, 2, $7F0, 1, 1, 3, 0
word_2F3B2_End

word_2F3C6:	spriteHeader
	spritePiece	1, 0, 4, 2, $48, 0, 0, 0, 1
	spritePiece	$21, 0, 4, 2, $50, 0, 0, 0, 1
	spritePiece	$41, 0, 1, 2, $58, 0, 0, 0, 1
word_2F3C6_End

word_2F3DA:	spriteHeader
	spritePiece	6, 0, 4, 2, $48, 0, 0, 0, 1
	spritePiece	$26, 0, 4, 2, $50, 0, 0, 0, 1
	spritePiece	$46, 0, 1, 2, $58, 0, 0, 0, 1
word_2F3DA_End

word_2F3EE:	spriteHeader
	spritePiece	1, 0, 4, 2, $48, 0, 0, 0, 1
	spritePiece	$21, 0, 4, 2, $50, 0, 0, 0, 1
word_2F3EE_End

word_2F3FC:	spriteHeader
	spritePiece	4, 0, 4, 2, $48, 0, 0, 0, 1
	spritePiece	$24, 0, 4, 2, $50, 0, 0, 0, 1
	spritePiece	$44, 0, 4, 2, $58, 0, 0, 0, 1
	spritePiece	$64, 0, 3, 2, $60, 0, 0, 0, 1
word_2F3FC_End

word_2F416:	spriteHeader		; Score (Special Stage)
	spritePiece	-$60, 0, 4, 2, $1C8, 0, 0, 3, 1		; SCOR
	spritePiece	-$40, 0, 1, 2, $1DC, 0, 0, 3, 1		; E
	spritePiece	$28, 0, 3, 2, $1DE, 0, 0, 1, 1
	spritePiece	$40, 0, 4, 2, $1E4, 0, 0, 1, 1
	spritePiece	-$3C, -$A, 2, 3, $14, 0, 0, 0, 1		; (Drop Art)
word_2F416_End

word_2F436:	spriteHeader
	spritePiece	0, 0, 4, 2, $1CE, 0, 0, 3, 1		; RING
	spritePiece	$28, 0, 4, 2, $1A, 0, 0, 3, 1		; BONU
	spritePiece	$48, 0, 1, 2, $1C8, 0, 0, 3, 1		; S
	spritePiece	$4C, -$A, 2, 3, $14, 0, 0, 0, 1		; (Drop Art)
word_2F436_End

word_2F450:	spriteHeader
	spritePiece	0, 0, 4, 2, $CC, 0, 0, 3, 1
	spritePiece	$20, 0, 3, 2, $D4, 0, 0, 3, 1
	spritePiece	$34, -$A, 2, 3, $14, 0, 0, 0, 1		; (Drop Art)
word_2F450_End

word_2F464:	spriteHeader
	spritePiece	0, 0, 4, 2, $DA, 0, 0, 3, 1
	spritePiece	$20, 0, 4, 2, $E2, 0, 0, 3, 1
	spritePiece	$3C, -$A, 2, 3, $14, 0, 0, 0, 1		; (Drop Art)
word_2F464_End

word_2F478:	spriteHeader
	spritePiece	-8, -8, 2, 2, $BC, 0, 0, 2, 1		; (Emerald 1 Art)
word_2F478_End

word_2F480:	spriteHeader
	spritePiece	-8, -8, 2, 2, $B8, 0, 0, 2, 1		; (Emerald 2 Art)
word_2F480_End

word_2F488:	spriteHeader
	spritePiece	-8, -8, 2, 2, $C0, 0, 0, 2, 1		; (Emerald 3 Art)
word_2F488_End

word_2F490:	spriteHeader
	spritePiece	-8, -8, 2, 2, $B8, 0, 0, 1, 1		; (Emerald 4 Art)
word_2F490_End

word_2F498:	spriteHeader
	spritePiece	-8, -8, 2, 2, $C8, 0, 0, 0, 1		; (Emerald 5 Art)
word_2F498_End

word_2F4A0:	spriteHeader
	spritePiece	-8, -8, 2, 2, $C4, 0, 0, 0, 1		; (Emerald 6 Art)
word_2F4A0_End

word_2F4A8:	spriteHeader
	spritePiece	-8, -8, 2, 2, $BC, 0, 0, 1, 1		; (Emerald 7 Art)
word_2F4A8_End

word_2F4B0:	spriteHeader
	spritePiece	-$60, 0, 2, 2, $A6, 0, 0, 0, 1		; S
	spritePiece	-$50, 0, 2, 2, $9E, 0, 0, 0, 1		; P
	spritePiece	-$40, 0, 2, 2, $80, 0, 0, 0, 1		; E
	spritePiece	-$30, 0, 2, 2, $78, 0, 0, 0, 1		; C
	spritePiece	-$20, 0, 1, 2, $8C, 0, 0, 0, 1		; I
	spritePiece	-$18, 0, 2, 2, $70, 0, 0, 0, 1		; A
	spritePiece	-8, 0, 2, 2, $8E, 0, 0, 0, 1		; L
	spritePiece	$10, 0, 2, 2, $A6, 0, 0, 0, 1		; S
	spritePiece	$20, 0, 2, 2, $AA, 0, 0, 0, 1		; T
	spritePiece	$30, 0, 2, 2, $70, 0, 0, 0, 1		; A
	spritePiece	$40, 0, 2, 2, $84, 0, 0, 0, 1		; G
	spritePiece	$50, 0, 2, 2, $80, 0, 0, 0, 1		; E
word_2F4B0_End

word_2F4FA:	spriteHeader
	spritePiece	0, 0, 2, 2, $84, 0, 0, 0, 1		; G
	spritePiece	$11, 0, 2, 2, $9A, 0, 0, 0, 1		; O
	spritePiece	$20, 0, 2, 2, $AA, 0, 0, 0, 1		; T
	spritePiece	$38, 0, 2, 2, $70, 0, 0, 0, 1		; A
word_2F4FA_End

word_2F514:	spriteHeader
	spritePiece	-$64, 0, 2, 2, $78, 0, 0, 0, 1		; C
	spritePiece	-$54, 0, 2, 2, $88, 0, 0, 0, 1		; H
	spritePiece	-$44, 0, 2, 2, $70, 0, 0, 0, 1		; A
	spritePiece	-$34, 0, 2, 2, $9A, 0, 0, 0, 1		; O
	spritePiece	-$24, 0, 2, 2, $A6, 0, 0, 0, 1		; S
	spritePiece	-$C, 0, 2, 2, $80, 0, 0, 0, 1		; E
	spritePiece	4, 0, 2, 2, $92, 0, 0, 0, 1		; M
	spritePiece	$14, 0, 2, 2, $80, 0, 0, 0, 1		; E
	spritePiece	$24, 0, 2, 2, $A2, 0, 0, 0, 1		; R
	spritePiece	$34, 0, 2, 2, $70, 0, 0, 0, 1		; A
	spritePiece	$44, 0, 2, 2, $8E, 0, 0, 0, 1		; L
	spritePiece	$54, 0, 2, 2, $7C, 0, 0, 0, 1		; D
word_2F514_End

word_2F55E:	spriteHeader
	spritePiece	$48, 0, 2, 2, $8E, 0, 0, 0, 1		; L
	spritePiece	$56, 0, 2, 2, $8E, 0, 0, 0, 1		; L
word_2F55E_End

word_2F56C:	spriteHeader
	spritePiece	$64, 0, 2, 2, $A6, 0, 0, 0, 1		; S
word_2F56C_End

word_2F574:	spriteHeader
	spritePiece	0, 0, 2, 2, $96, 0, 0, 3, 1		; N
	spritePiece	$11, 0, 2, 2, $9A, 0, 0, 3, 1		; O
	spritePiece	$20, 0, 3, 2, $B2, 0, 0, 3, 1		; W
word_2F574_End

word_2F588:	spriteHeader
	spritePiece	0, 0, 2, 2, $78, 0, 0, 3, 1		; C
	spritePiece	$10, 0, 2, 2, $70, 0, 0, 3, 1		; A
	spritePiece	$20, 0, 2, 2, $96, 0, 0, 3, 1		; N
word_2F588_End

word_2F59C:	spriteHeader
	spritePiece	0, 0, 2, 2, $74, 0, 0, 3, 1		; B
	spritePiece	$F, 0, 2, 2, $80, 0, 0, 3, 1		; E
word_2F59C_End

word_2F5AA:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $EA, 0, 0, 0, 1		; (Sonic Icon)
word_2F5AA_End

word_2F5B2:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $180, 0, 0, 0, 1		; (Tails Icon)
word_2F5B2_End

word_2F5BA:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $189, 0, 0, 0, 1		; (Knuckles Icon)
word_2F5BA_End

word_2F5C2:	spriteHeader
	spritePiece	-$40, 0, 2, 2, $52B, 0, 0, 3, 1
	spritePiece	-$30, 0, 2, 2, $523, 0, 0, 3, 1
	spritePiece	-$20, 0, 2, 2, $549, 0, 0, 3, 1
	spritePiece	-8, 0, 2, 2, $537, 0, 0, 3, 1
	spritePiece	9, 0, 2, 2, $54D, 0, 0, 3, 1
	spritePiece	$20, 0, 2, 2, $55D, 0, 0, 3, 1
	spritePiece	$30, 0, 2, 2, $54D, 0, 0, 3, 1
word_2F5C2_End

word_2F5EE:	spriteHeader
	spritePiece	-$60, 0, 2, 2, $53B, 0, 0, 3, 1
	spritePiece	-$50, 0, 1, 2, $53F, 0, 0, 3, 1
	spritePiece	-$47, 0, 2, 2, $52F, 0, 0, 3, 1
	spritePiece	-$36, 0, 2, 2, $52F, 0, 0, 3, 1
	spritePiece	-$26, 0, 2, 2, $533, 0, 0, 3, 1
	spritePiece	-$17, 0, 2, 2, $549, 0, 0, 3, 1
	spritePiece	1, 0, 2, 2, $551, 0, 0, 3, 1
	spritePiece	$10, 0, 2, 2, $523, 0, 0, 3, 1
	spritePiece	$20, 0, 2, 2, $541, 0, 0, 3, 1
	spritePiece	$30, 0, 2, 2, $523, 0, 0, 3, 1
	spritePiece	$40, 0, 2, 2, $52B, 0, 0, 3, 1
	spritePiece	$50, 0, 2, 2, $533, 0, 0, 3, 1
word_2F5EE_End

word_2F638:	spriteHeader
	spritePiece	-$64, 0, 2, 2, $559, 0, 0, 0, 1
	spritePiece	-$54, 0, 2, 2, $561, 0, 0, 0, 1
	spritePiece	-$44, 0, 2, 2, $551, 0, 0, 0, 1
	spritePiece	-$34, 0, 2, 2, $533, 0, 0, 0, 1
	spritePiece	-$24, 0, 2, 2, $555, 0, 0, 0, 1
	spritePiece	-$C, 0, 2, 2, $533, 0, 0, 0, 1
	spritePiece	4, 0, 2, 2, $545, 0, 0, 0, 1
	spritePiece	$14, 0, 2, 2, $533, 0, 0, 0, 1
	spritePiece	$24, 0, 2, 2, $555, 0, 0, 0, 1
	spritePiece	$34, 0, 2, 2, $523, 0, 0, 0, 1
	spritePiece	$44, 0, 2, 2, $541, 0, 0, 0, 1
	spritePiece	$54, 0, 2, 2, $52F, 0, 0, 0, 1
word_2F638_End

word_2F682:	spriteHeader
	spritePiece	-$60, 0, 4, 2, $1CA, 0, 0, 1, 1
	spritePiece	-$40, 0, 1, 2, $1E2, 0, 0, 1, 1
	spritePiece	$28, 0, 3, 2, $1E4, 0, 0, 1, 1
	spritePiece	$40, 0, 4, 2, $1EA, 0, 0, 1, 1
	spritePiece	-$3C, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F682_End

word_2F6A2:	spriteHeader
	spritePiece	0, 0, 4, 2, $1D2, 0, 0, 1, 1
	spritePiece	$28, 0, 4, 2, $5D2, 0, 0, 1, 1
	spritePiece	$48, 0, 1, 2, $6CA, 0, 0, 1, 0
	spritePiece	$4C, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F6A2_End

word_2F6BC:	spriteHeader
	spritePiece	0, 0, 4, 2, $57F, 0, 0, 1, 1
	spritePiece	$20, 0, 3, 2, $587, 0, 0, 1, 1
	spritePiece	$34, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F6BC_End

word_2F6D0:	spriteHeader
	spritePiece	0, 0, 4, 2, $58D, 0, 0, 1, 1
	spritePiece	$20, 0, 4, 2, $595, 0, 0, 1, 1
	spritePiece	$3C, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F6D0_End

word_2F6E4:	spriteHeader
	spritePiece	0, 0, 2, 2, $549, 0, 0, 0, 1
	spritePiece	$11, 0, 2, 2, $54D, 0, 0, 0, 1
	spritePiece	$20, 0, 3, 2, $565, 0, 0, 0, 1
word_2F6E4_End

word_2F6F8:	spriteHeader
	spritePiece	0, 0, 2, 2, $52B, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $523, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $549, 0, 0, 0, 1
word_2F6F8_End

word_2F70C:	spriteHeader
	spritePiece	0, 0, 2, 2, $527, 0, 0, 0, 1
	spritePiece	$F, 0, 2, 2, $533, 0, 0, 0, 1
word_2F70C_End

word_2F71A:	spriteHeader
	spritePiece	-$60, 0, 4, 2, $1CA, 0, 0, 0, 1
	spritePiece	-$40, 0, 1, 2, $1E2, 0, 0, 0, 1
	spritePiece	$28, 0, 3, 2, $1E4, 0, 0, 0, 1
	spritePiece	$40, 0, 4, 2, $1EA, 0, 0, 0, 1
	spritePiece	-$3C, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F71A_End

word_2F73A:	spriteHeader
	spritePiece	0, 0, 4, 2, $1D2, 0, 0, 0, 1
	spritePiece	$28, 0, 4, 2, $5D2, 0, 0, 0, 1
	spritePiece	$48, 0, 1, 2, $6CA, 0, 0, 0, 0
	spritePiece	$4C, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F73A_End

word_2F754:	spriteHeader
	spritePiece	0, 0, 4, 2, $57F, 0, 0, 0, 1
	spritePiece	$20, 0, 3, 2, $587, 0, 0, 0, 1
	spritePiece	$34, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F754_End

word_2F768:	spriteHeader
	spritePiece	0, 0, 4, 2, $58D, 0, 0, 0, 1
	spritePiece	$20, 0, 4, 2, $595, 0, 0, 0, 1
	spritePiece	$3C, -$A, 2, 3, $14, 0, 0, 0, 1
word_2F768_End

	even
