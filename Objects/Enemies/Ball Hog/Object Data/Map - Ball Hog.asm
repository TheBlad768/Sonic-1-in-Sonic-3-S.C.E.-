; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------

Map_BallHog:
		dc.w Map_BallHog_C-Map_BallHog, Map_BallHog_1A-Map_BallHog
		dc.w Map_BallHog_28-Map_BallHog, Map_BallHog_36-Map_BallHog
		dc.w Map_BallHog_44-Map_BallHog, Map_BallHog_4C-Map_BallHog
Map_BallHog_C:	dc.b 0, 2
		dc.b $EF, 9, 0, 0, $FF, $F4
		dc.b $FF, $A, 0, 6, $FF, $F4
Map_BallHog_1A:	dc.b 0, 2
		dc.b $EF, 9, 0, 0, $FF, $F4
		dc.b $FF, $A, 0, $F, $FF, $F4
Map_BallHog_28:	dc.b 0, 2
		dc.b $F4, 9, 0, 0, $FF, $F4
		dc.b 4, 9, 0, $18, $FF, $F4
Map_BallHog_36:	dc.b 0, 2
		dc.b $E4, 9, 0, 0, $FF, $F4
		dc.b $F4, $A, 0, $1E, $FF, $F4
Map_BallHog_44:	dc.b 0, 1
		dc.b $F8, 5, 0, $27, $FF, $F8
Map_BallHog_4C:	dc.b 0, 1
		dc.b $F8, 5, 0, $2B, $FF, $F8
		even
