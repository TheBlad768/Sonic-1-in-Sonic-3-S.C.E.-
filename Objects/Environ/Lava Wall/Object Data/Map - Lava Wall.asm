; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------

Map_LWall:
		dc.w Map_LWall_A-Map_LWall		; 0 (duplicate)
		dc.w Map_LWall_A-Map_LWall		; 1 (duplicate)
		dc.w Map_LWall_42-Map_LWall		; 2
		dc.w Map_LWall_7A-Map_LWall		; 3
		dc.w Map_LWall_B2-Map_LWall		; 4
		dc.w Map_LWall_EA-Map_LWall		; 5
Map_LWall_A:	dc.b 0, 9
		dc.b $E0, $F, 0, $60, 0, $20
		dc.b 0, $F, 0, $70, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LWall_42:	dc.b 0, 9
		dc.b $E0, $F, 0, $70, 0, $20
		dc.b 0, $F, 0, $80, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LWall_7A:	dc.b 0, 9
		dc.b $E0, $F, 0, $80, 0, $20
		dc.b 0, $F, 0, $70, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LWall_B2:	dc.b 0, 9
		dc.b $E0, $F, 0, $70, 0, $20
		dc.b 0, $F, 0, $60, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LWall_EA:	dc.b 0, 8
		dc.b $E0, $F, $FF, $65, 0, $20
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
		even