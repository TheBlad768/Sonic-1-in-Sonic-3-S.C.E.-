; ---------------------------------------------------------------------------
; Sprite mappings - harpoon (LZ)
; ---------------------------------------------------------------------------

Map_Harpoon:
		dc.w Map_Harpoon_C-Map_Harpoon, Map_Harpoon_14-Map_Harpoon
		dc.w Map_Harpoon_1C-Map_Harpoon, Map_Harpoon_2A-Map_Harpoon
		dc.w Map_Harpoon_32-Map_Harpoon, Map_Harpoon_3A-Map_Harpoon
Map_Harpoon_C:	dc.b 0, 1
		dc.b $FC, 4, 0, 0, $FF, $F8
Map_Harpoon_14:	dc.b 0, 1
		dc.b $FC, $C, 0, 2, $FF, $F8
Map_Harpoon_1C:	dc.b 0, 2
		dc.b $FC, 8, 0, 6, $FF, $F8
		dc.b $FC, 8, 0, 3, 0, $10
Map_Harpoon_2A:	dc.b 0, 1
		dc.b $F8, 1, 0, 9, $FF, $FC
Map_Harpoon_32:	dc.b 0, 1
		dc.b $E8, 3, 0, $B, $FF, $FC
Map_Harpoon_3A:	dc.b 0, 2
		dc.b $D8, 2, 0, $B, $FF, $FC
		dc.b $F0, 2, 0, $F, $FF, $FC
		even
