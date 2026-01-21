; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER" and "TIME OVER"
; ---------------------------------------------------------------------------

Map_GameOver:

		; GAME
		dc.b $F8, $D, 0, 0, $FF, $B8
		dc.b $F8, $D, 0, 8, $FF, $D8

		; OVER
		dc.b $F8, $D, 0, $14, 0, 8
		dc.b $F8, $D, 0, $C, 0, $28
	even

Map_TimeOver:

		; TIME
		dc.b $F8, 9, 0, $1C, $FF, $BA
		dc.b $F8, $D, 0, 8, $FF, $D2

		; OVER
		dc.b $F8, $D, 0, $14, 0, 2
		dc.b $F8, $D, 0, $C, 0, $22
	even
