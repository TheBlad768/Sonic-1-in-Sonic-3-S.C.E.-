; ---------------------------------------------------------------------------
; Sprite mappings - stomper and platforms (SBZ)
; ---------------------------------------------------------------------------

Map_Stomp:
		dc.w Map_Stomp_A-Map_Stomp
		dc.w Map_Stomp_24-Map_Stomp
		dc.w Map_Stomp_24-Map_Stomp
		dc.w Map_Stomp_24-Map_Stomp
		dc.w Map_Stomp_BA-Map_Stomp
Map_Stomp_A:
		dc.b 0, 4
		dc.b $F4, $E, $20, $DD, $FF, $C0
		dc.b $F4, $E, $20, $E0, $FF, $E0
		dc.b $F4, $E, $20, $E0, 0, 0
		dc.b $F4, $E, $28, $DD, 0, $20
Map_Stomp_24:
		dc.b 0, 8
		dc.b $E0, $C, 0, $C, $FF, $E4
		dc.b $E0, 8, 0, $10, 0, 4
		dc.b $E8, $E, $20, $13, $FF, $E4
		dc.b $E8, $A, $20, $1F, 0, 4
		dc.b 0, $E, $20, $13, $FF, $E4
		dc.b 0, $A, $20, $1F, 0, 4
		dc.b $18, $C, 0, $C, $FF, $E4
		dc.b $18, 8, 0, $10, 0, 4
Map_Stomp_BA:
		dc.b 0, $E
		dc.b $C0, $F, 0, 0, $FF, $80
		dc.b $C0, $F, 0, $10, $FF, $A0
		dc.b $C0, $F, 0, $20, $FF, $C0
		dc.b $C0, $F, 0, $10, $FF, $E0
		dc.b $C0, $F, 0, $20, 0, 0
		dc.b $C0, $F, 0, $10, 0, $20
		dc.b $C0, $F, 0, $30, 0, $40
		dc.b $C0, $D, 0, $40, 0, $60
		dc.b $E0, $F, 0, $48, $FF, $80
		dc.b $E0, $F, 0, $48, $FF, $C0
		dc.b $E0, $F, 0, $58, 0, 0
		dc.b 0, $F, 0, $48, $FF, $80
		dc.b 0, $F, 0, $58, $FF, $C0
		dc.b $20, $F, 0, $58, $FF, $80
		even
