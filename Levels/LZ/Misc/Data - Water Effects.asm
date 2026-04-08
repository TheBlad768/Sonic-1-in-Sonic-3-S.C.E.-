; ---------------------------------------------------------------------------
; Labyrinth Zone - Water tunnels
; ---------------------------------------------------------------------------

WaterTunPos		= 512

; =============== S U B R O U T I N E =======================================

LZ_WaterTunLocs_Index: offsetTable
		offsetTableEntry.w LZ1_WaterTunLocs					; 0
		offsetTableEntry.w LZ2_WaterTunLocs					; 2
		offsetTableEntry.w LZ3_WaterTunLocs					; 4
		offsetTableEntry.w SBZ3_WaterTunLocs					; 6

LZ1_WaterTunLocs:									; min x, min y, max x, max y, x velo, y velo, player can influence which axis flag (set = x, clear = y)
		dc.w 2-1
		dc.w $A80+WaterTunPos, $300, $C10+WaterTunPos, $380
		dc.w $F80+WaterTunPos, $100, $1410+WaterTunPos, $180
LZ1_WaterTunLocs_end

LZ2_WaterTunLocs:									; min x, min y, max x, max y, x velo, y velo, player can influence which axis flag (set = x, clear = y)
		dc.w 1-1
		dc.w $460+WaterTunPos, $400, $710+WaterTunPos, $480
LZ2_WaterTunLocs_end

LZ3_WaterTunLocs:									; min x, min y, max x, max y, x velo, y velo, player can influence which axis flag (set = x, clear = y)
		dc.w 1-1
		dc.w $A20+WaterTunPos, $600, $1610+WaterTunPos, $6E0
LZ3_WaterTunLocs_end

SBZ3_WaterTunLocs:									; min x, min y, max x, max y, x velo, y velo, player can influence which axis flag (set = x, clear = y)
		dc.w 1-1
		dc.w $C80, $600, $13D0, $680
SBZ3_WaterTunLocs_end

; ---------------------------------------------------------------------------
; Labyrinth Zone - Slide speeds
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Slide_Speeds_Index: offsetTable
		offsetTableEntry.w Slide_Speeds1					; 0 ; act 1
		offsetTableEntry.w Slide_Speeds2					; 2 ; act 2
		offsetTableEntry.w Slide_Speeds3					; 4 ; act 3
		offsetTableEntry.w Slide_Speeds1					; 6 ; act 4 (unused)

Slide_Speeds1:
		dc.b $A, $A								; right
Slide_Speeds2:
		dc.b $A, $A, $A, $A, $A, $A						; right
		dc.b -$A, -$A, -$A, -$A							; left
Slide_Speeds3:
		dc.b $A, $A, $A, $A, $A, $A, $B, $B, $B, $B, $B				; right
		dc.b -$C, -$C, -$C, -$C, -$B, -$B, -$B, -$B, -$B, -$B, -$B		; left
	even

; ---------------------------------------------------------------------------
; Labyrinth Zone - Slide chunks
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Slide_Chunks_Index: offsetTable
		offsetTableEntry.w Slide_Chunks1_start					; act 1
		offsetTableEntry.w Slide_Chunks2_start					; act 2
		offsetTableEntry.w Slide_Chunks3_start					; act 3
		offsetTableEntry.w Slide_Chunks1_start					; act 4 (unused)

Slide_Chunks1:
		dc.w $7B, $7C								; right
Slide_Chunks1_end
		dc.w ((Slide_Chunks1_end-Slide_Chunks1)/2)-1
Slide_Chunks1_start

Slide_Chunks2:
		dc.w $5F, $60, $64, $65, $66, $67					; right
		dc.w $68, $69, $6A, $6B							; left
Slide_Chunks2_end
		dc.w ((Slide_Chunks2_end-Slide_Chunks2)/2)-1
Slide_Chunks2_start

Slide_Chunks3:
		dc.w $54, $55, $58, $59, $5A, $5B, $5F, $61, $62, $63, $64		; right
		dc.w $65, $66, $67, $68, $70, $71, $72, $73, $BF, $C9, $CA		; left
Slide_Chunks3_end
		dc.w ((Slide_Chunks3_end-Slide_Chunks3)/2)-1
Slide_Chunks3_start
