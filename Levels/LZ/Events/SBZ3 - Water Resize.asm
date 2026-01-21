; ---------------------------------------------------------------------------
; Dynamic Water level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SBZ3_WaterResize:

		; check camera
		lea	SBZ3_WaterResizeDat(pc),a1
		jmp	(WaterResize_MaxYFromX).w
; ---------------------------------------------------------------------------

SBZ3_WaterResizeDat:	; water pos, xcamera
		dc.w $228, $F00
		dc.w $4C8, -1
