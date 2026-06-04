; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER" and "TIME OVER"
; ---------------------------------------------------------------------------

Map_GameOver:

	; GAME
	spritePiece	-$48, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$28, -8, 4, 2, 8, 0, 0, 0, 0

	; OVER
	spritePiece	8, -8, 4, 2, $14, 0, 0, 0, 0
	spritePiece	$28, -8, 4, 2, $C, 0, 0, 0, 0
	even

Map_TimeOver:

	; TIME
	spritePiece	-$46, -8, 3, 2, $1C, 0, 0, 0, 0
	spritePiece	-$2E, -8, 4, 2, 8, 0, 0, 0, 0

	; OVER
	spritePiece	2, -8, 4, 2, $14, 0, 0, 0, 0
	spritePiece	$22, -8, 4, 2, $C, 0, 0, 0, 0
	even
