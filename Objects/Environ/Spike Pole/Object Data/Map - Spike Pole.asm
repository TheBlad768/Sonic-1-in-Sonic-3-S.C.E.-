; ---------------------------------------------------------------------------
; Sprite mappings - helix of spikes on a pole (GHZ)
; ---------------------------------------------------------------------------

Map_SpikePole:
		dc.w Map_SpikePole_10-Map_SpikePole, Map_SpikePole_18-Map_SpikePole
		dc.w Map_SpikePole_20-Map_SpikePole, Map_SpikePole_28-Map_SpikePole
		dc.w Map_SpikePole_30-Map_SpikePole, Map_SpikePole_38-Map_SpikePole
		dc.w Map_SpikePole_40-Map_SpikePole, Map_SpikePole_42-Map_SpikePole
Map_SpikePole_10:	dc.b 0, 1
		dc.b $F0, 1, 0, 0, $FF, $FC
Map_SpikePole_18:	dc.b 0, 1
		dc.b $F5, 5, 0, 2, $FF, $F8
Map_SpikePole_20:	dc.b 0, 1
		dc.b $F8, 5, 0, 6, $FF, $F8
Map_SpikePole_28:	dc.b 0, 1
		dc.b $FB, 5, 0, $A, $FF, $F8
Map_SpikePole_30:	dc.b 0, 1
		dc.b 0, 1, 0, $E, $FF, $FC
Map_SpikePole_38:	dc.b 0, 1
		dc.b 4, 0, 0, $10, $FF, $FD
Map_SpikePole_40:	dc.b 0, 0
Map_SpikePole_42:	dc.b 0, 1
		dc.b $F4, 0, 0, $11, $FF, $FD
		even
