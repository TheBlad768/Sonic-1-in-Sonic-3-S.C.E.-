; ---------------------------------------------------------------------------
; Sprite mappings - title card
; ---------------------------------------------------------------------------

Map_TitleCard:
		dc.w 0						; null
		dc.w Map_TitleCard_Banner-Map_TitleCard		; red banner
		dc.w Map_TitleCard_Act-Map_TitleCard		; ACT
		dc.w Map_TitleCard_ZONE-Map_TitleCard		; ZONE

.levels
		dc.w Map_TitleCard_GHZ-Map_TitleCard		; GREEN HILL
		dc.w Map_TitleCard_MZ-Map_TitleCard		; MARBLE
		dc.w Map_TitleCard_SYZ-Map_TitleCard		; SPRING YARD
		dc.w Map_TitleCard_LZ-Map_TitleCard		; LABYRINTH
		dc.w Map_TitleCard_SLZ-Map_TitleCard		; STAR LIGHT
		dc.w Map_TitleCard_SBZ-Map_TitleCard		; SCRAP BRAIN

		zonewarning Map_TitleCard.levels,(1*2)

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
		dc.b $10, 9, $80, $1C, $FF, $E4
		dc.b 0, $F, $80, $3D, $FF, $F5
	even
