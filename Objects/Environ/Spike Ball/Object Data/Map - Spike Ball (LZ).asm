; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball on a chain (LZ)
; ---------------------------------------------------------------------------

Map_SpikeBall_LZ:
		dc.w Map_SpikeBall_LZ_6-Map_SpikeBall_LZ, Map_SpikeBall_LZ_E-Map_SpikeBall_LZ
		dc.w Map_SpikeBall_LZ_16-Map_SpikeBall_LZ
Map_SpikeBall_LZ_6:	dc.b 0, 1
		dc.b $F8, 5, 0, 0, $FF, $F8
Map_SpikeBall_LZ_E:	dc.b 0, 1
		dc.b $F0, $F, 0, 4, $FF, $F0
Map_SpikeBall_LZ_16:	dc.b 0, 1
		dc.b $F8, 5, 0, $14, $FF, $F8
		even
