; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------

Map_LavaWall:
		dc.w Map_LavaWall_A-Map_LavaWall		; 0 (duplicate)
		dc.w Map_LavaWall_A-Map_LavaWall		; 1 (duplicate)
		dc.w Map_LavaWall_42-Map_LavaWall		; 2
		dc.w Map_LavaWall_7A-Map_LavaWall		; 3
		dc.w Map_LavaWall_B2-Map_LavaWall		; 4
		dc.w Map_LavaWall_EA-Map_LavaWall		; 5
Map_LavaWall_A:	dc.b 0, 9
		dc.b $E0, $F, 0, $60, 0, $20
		dc.b 0, $F, 0, $70, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LavaWall_42:	dc.b 0, 9
		dc.b $E0, $F, 0, $70, 0, $20
		dc.b 0, $F, 0, $80, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LavaWall_7A:	dc.b 0, 9
		dc.b $E0, $F, 0, $80, 0, $20
		dc.b 0, $F, 0, $70, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LavaWall_B2:	dc.b 0, 9
		dc.b $E0, $F, 0, $70, 0, $20
		dc.b 0, $F, 0, $60, 0, $3C
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
Map_LavaWall_EA:	dc.b 0, 8
		dc.b $E0, $F, $FF, $65, 0, $20
		dc.b 0, $F, $FF, $65, 0, $20
		dc.b $E0, $F, $FF, $65, 0, 0
		dc.b 0, $F, $FF, $65, 0, 0
		dc.b $E0, $F, $FF, $65, $FF, $E0
		dc.b 0, $F, $FF, $65, $FF, $E0
		dc.b $E0, $F, $FF, $65, $FF, $C0
		dc.b 0, $F, $FF, $65, $FF, $C0
		even
