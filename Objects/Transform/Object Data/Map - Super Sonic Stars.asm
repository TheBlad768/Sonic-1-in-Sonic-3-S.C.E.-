Map_SuperSonic_Stars:
		dc.w word_192F2-Map_SuperSonic_Stars
		dc.w word_192F4-Map_SuperSonic_Stars
		dc.w word_192FC-Map_SuperSonic_Stars
		dc.w word_19316-Map_SuperSonic_Stars
		dc.w word_192FC-Map_SuperSonic_Stars
		dc.w word_192F4-Map_SuperSonic_Stars
word_192F2:	dc.w 0
word_192F4:	dc.w 1
		dc.b $F8, 5, 0, 0, $FF, $F8
word_192FC:	dc.w 4
		dc.b $F0, 5, 0, 4, $FF, $F0
		dc.b $F0, 5, 8, 4, 0, 0
		dc.b 0, 5, $10, 4, $FF, $F0
		dc.b 0, 5, $18, 4, 0, 0
word_19316:	dc.w 4
		dc.b $E8, $A, 0, 8, $FF, $E8
		dc.b $E8, $A, 8, 8, 0, 0
		dc.b 0, $A, $10, 8, $FF, $E8
		dc.b 0, $A, $18, 8, 0, 0
	even