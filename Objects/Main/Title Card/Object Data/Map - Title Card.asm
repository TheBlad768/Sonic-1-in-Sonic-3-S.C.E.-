; ---------------------------------------------------------------------------
; Sprite mappings - title card
; ---------------------------------------------------------------------------

Map_TitleCard:
		dc.w 0						; null
		dc.w Map_TitleCard_Banner-Map_TitleCard		; red banner
		dc.w Map_TitleCard_Act-Map_TitleCard		; ACT
		dc.w Map_TitleCard_Zone-Map_TitleCard		; ZONE
		dc.w Map_TitleCard_GHZ-Map_TitleCard		; GREEN HILL
		dc.w Map_TitleCard_MZ-Map_TitleCard		; MARBLE
		dc.w Map_TitleCard_SYZ-Map_TitleCard		; SPRING YARD
		dc.w Map_TitleCard_LZ-Map_TitleCard		; LABYRINTH
		dc.w Map_TitleCard_SLZ-Map_TitleCard		; STAR LIGHT
		dc.w Map_TitleCard_SBZ-Map_TitleCard		; SCRAP BRAIN
		dc.w Map_TitleCard_FZ-Map_TitleCard		; FINAL
Map_TitleCard_Banner:
		dc.w $10
		dc.b $58, 9, $80, $10, $FF, $E8
		dc.b $58, 9, $80, $16, 0, 0
		dc.b $90, $F, $80, 0, $FF, $E0
		dc.b $90, $F, $80, 0, 0, 0
		dc.b $B0, $F, $80, 0, $FF, $E0
		dc.b $B0, $F, $80, 0, 0, 0
		dc.b $D0, $F, $80, 0, $FF, $E0
		dc.b $D0, $F, $80, 0, 0, 0
		dc.b $F0, $F, $80, 0, $FF, $E0
		dc.b $F0, $F, $80, 0, 0, 0
		dc.b $10, $F, $80, 0, $FF, $E0
		dc.b $10, $F, $80, 0, 0, 0
		dc.b $30, $F, $80, 0, $FF, $E0
		dc.b $30, $F, $80, 0, 0, 0
		dc.b $50, $F, $80, 0, $FF, $E0
		dc.b $50, $F, $80, 0, 0, 0
Map_TitleCard_Act:
		dc.w 2
		dc.b $10, 9, $80, $37, $FF, $E4
		dc.b 0, $F, $80, $3D, $FF, $F5
Map_TitleCard_Zone:
		dc.w 4
		dc.b 0, 6, $80, $31, $FF, $DC			; Z
		dc.b 0, $A, $80, $28, $FF, $EC			; O
		dc.b 0, 6, $80, $22, 0, 4			; N
		dc.b 0, 6, $80, $1C, 0, $14			; E
Map_TitleCard_GHZ:
		dc.w 6
		dc.b 0, $E, $80, $4D, 0, 0			; GR
		dc.b 0, 6, $80, $1C, 0, $20			; E
		dc.b 0, 6, $80, $1C, 0, $30			; E
		dc.b 0, 6, $80, $22, 0, $40			; N
		dc.b 0, $E, $80, $59, 0, $58			; HIL
		dc.b 0, 2, $80, $62, 0, $78			; L
Map_TitleCard_MZ:
		dc.w 4
		dc.b 0, $E, $80, $4D, 0, $20			; MA
		dc.b 0, $E, $80, $59, 0, $40			; RB
		dc.b 0, 6, $80, $65, 0, $60			; L
		dc.b 0, 6, $80, $1C, 0, $70			; E
Map_TitleCard_SYZ:
		dc.w 7
		dc.b 0, $E, $80, $4D, $FF, $E0			; SP
		dc.b 0, $A, $80, $59, 0, 0			; RI
		dc.b 0, 6, $80, $22, 0, $18			; N
		dc.b 0, 6, $80, $62, 0, $28			; G
		dc.b 0, $E, $80, $68, 0, $40			; YA
		dc.b 0, 6, $80, $59, 0, $60			; R
		dc.b 0, 6, $80, $74, 0, $70			; D
Map_TitleCard_LZ:
		dc.w 5
		dc.b 0, $E, $80, $4D, 0, 0			; LAB
		dc.b 0, $E, $80, $59, 0, $20			; BYR
		dc.b 0, 6, $80, $65, 0, $40			; RI
		dc.b 0, 6, $80, $22, 0, $50			; N
		dc.b 0, $E, $80, $6B, 0, $60			; TH
Map_TitleCard_SLZ:
		dc.w 5
		dc.b 0, $E, $80, $4D, $FF, $F8			; ST
		dc.b 0, $E, $80, $59, 0, $18			; AR
		dc.b 0, $E, $80, $65, 0, $40			; LIG
		dc.b 0, 6, $80, $71, 0, $60			; H
		dc.b 0, 6, $80, $53, 0, $70			; T
Map_TitleCard_SBZ:
		dc.w 7
		dc.b 0, $E, $80, $4D, $FF, $E0			; SC
		dc.b 0, $E, $80, $59, 0, 0			; RA
		dc.b 0, 6, $80, $65, 0, $20			; P
		dc.b 0, 6, $80, $6B, 0, $38			; B
		dc.b 0, $E, $80, $59, 0, $48			; RA
		dc.b 0, 2, $80, $71, 0, $68			; I
		dc.b 0, 6, $80, $22, 0, $70			; N
Map_TitleCard_FZ:
		dc.w 3
		dc.b 0, $A, $80, $4D, 0, $40			; FI
		dc.b 0, 6, $80, $22, 0, $58			; N
		dc.b 0, $A, $80, $56, 0, $68			; AL
	even
