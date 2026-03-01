; ---------------------------------------------------------------------------
; Scrap Brain Zone - Teleport positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Teleport_Data: offsetTable
		offsetTableEntry.w Tele_Type00
		offsetTableEntry.w Tele_Type01
		offsetTableEntry.w Tele_Type02
		offsetTableEntry.w Tele_Type03
		offsetTableEntry.w Tele_Type04
		offsetTableEntry.w Tele_Type05
		offsetTableEntry.w Tele_Type06
		offsetTableEntry.w Tele_Type07

Tele_Type00: objTeleportSize
		dc.w $994, $98C			; start xypos => end xypos
Tele_Type00_end

Tele_Type01: objTeleportSize
		dc.w $294, $38C			; start xypos => end xypos
Tele_Type01_end

Tele_Type02: objTeleportSize
		dc.w $994, $2E8			; start xypos => end xypos
		dc.w $9A4, $2C0			; start xypos => end xypos
		dc.w $9D0, $2AC			; start xypos => end xypos
		dc.w $A58, $2AC			; start xypos => end xypos
		dc.w $A84, $298			; start xypos => end xypos
		dc.w $A94, $270			; start xypos => end xypos
		dc.w $A94, $190			; start xypos => end xypos
Tele_Type02_end

Tele_Type03: objTeleportSize
		dc.w $A94, $690			; start xypos => end xypos
Tele_Type03_end

Tele_Type04: objTeleportSize
		dc.w $1394, $470		; start xypos => end xypos
		dc.w $1384, $498		; start xypos => end xypos
		dc.w $1358, $4AC		; start xypos => end xypos
		dc.w $11D0, $4AC		; start xypos => end xypos
		dc.w $11A4, $4C0		; start xypos => end xypos
		dc.w $1194, $4E8		; start xypos => end xypos
		dc.w $1194, $590		; start xypos => end xypos
Tele_Type04_end

Tele_Type05: objTeleportSize
		dc.w $1494, $490		; start xypos => end xypos
Tele_Type05_end

Tele_Type06: objTeleportSize
		dc.w $1794, $FFE8		; start xypos => end xypos
		dc.w $1784, $FFC0		; start xypos => end xypos
		dc.w $1760, $FFAC		; start xypos => end xypos
		dc.w $16D0, $FFAC		; start xypos => end xypos
		dc.w $16A4, $FF98		; start xypos => end xypos
		dc.w $1694, $FF70		; start xypos => end xypos
		dc.w $1694, $FD90		; start xypos => end xypos
Tele_Type06_end

Tele_Type07: objTeleportSize
		dc.w $A94, $90			; start xypos => end xypos
Tele_Type07_end
