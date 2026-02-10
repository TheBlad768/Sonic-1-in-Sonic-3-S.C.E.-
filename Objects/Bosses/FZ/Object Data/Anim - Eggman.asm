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

.stand

		; frame, timer
		dc.b 0, 7
		dc.b 1, $17
		dc.b 0, 7
		dc.b 1, $F
		dc.b 0, $3F
		dc.b 1, 7
		dc.b afEnd

.laugh

		; frame, timer
		dc.b 2, 6
		dc.b 3, 6
		dc.b afEnd

.hurt

		; frame, timer
		dc.b 4, 0
		dc.b 5, 0
		dc.b afEnd

.defeated

		; frame, timer
		dc.b 7, $7F
		dc.b afEnd

.run1

		; frame, timer
		dc.b 8, $7F
		dc.b afEnd

.run2

		; frame, timer
		dc.b 8, 5
		dc.b 9, 5
		dc.b $A, 5
		dc.b 9, 5
		dc.b afEnd

.jump

		; frame, timer
		dc.b $B, $7F
		dc.b afEnd

.defrun1

		; frame, timer
		dc.b $C, $7F
		dc.b afEnd

.defrun2

		; frame, timer
		dc.b $C, 5
		dc.b $D, 5
		dc.b $E, 5
		dc.b $D, 5
		dc.b afEnd

.defjump

		; frame, timer
		dc.b $F, $7F
		dc.b afEnd
	even
