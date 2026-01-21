; ---------------------------------------------------------------------------
; Animation script - Eggman boss (FZ)
; ---------------------------------------------------------------------------

Ani_EggmanFZ: offsetTable
		offsetTableEntry.w .stand	; 0
		offsetTableEntry.w .laugh	; 1
		offsetTableEntry.w .hurt	; 2
		offsetTableEntry.w .defeated	; 3
		offsetTableEntry.w .run1	; 4
		offsetTableEntry.w .run2	; 5
		offsetTableEntry.w .jump	; 6
		offsetTableEntry.w .defrun1	; 7
		offsetTableEntry.w .defrun2	; 8
		offsetTableEntry.w .defjump	; 9

.stand		dc.b 0, 7, 1, $17, 0, 7, 1, $F, 0, $3F, 1, 7, afEnd
.laugh		dc.b 2, 6, 3, 6, afEnd
.hurt		dc.b 4, 0, 5, 0, afEnd
.defeated	dc.b 7, $7F, afEnd
.run1		dc.b 8, $7F, afEnd
.run2		dc.b 8, 5, 9, 5, $A, 5, 9, 5, afEnd
.jump		dc.b $B, $7F, afEnd
.defrun1	dc.b $C, $7F, afEnd
.defrun2	dc.b $C, 5, $D, 5, $E, 5, $D, 5, afEnd
.defjump	dc.b $F, $7F, afEnd
	even
