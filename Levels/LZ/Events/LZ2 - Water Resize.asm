; ---------------------------------------------------------------------------
; Dynamic Water level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LZ2_WaterResize:

		; check camera
		lea	LZ2_WaterResizeDat(pc),a1
		jmp	(WaterResize_MaxYFromX).w
; ---------------------------------------------------------------------------

LZ2_WaterResizeDat:	; water pos, xcamera
		dc.w $328, $700
		dc.w $3C8, $D00
		dc.w $428, -1
