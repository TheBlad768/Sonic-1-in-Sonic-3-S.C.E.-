; ---------------------------------------------------------------------------
; Scrap Brain Zone - Conveyor positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SCon_Data: offsetTable
		offsetTableEntry.w word_164B2						; 0
		offsetTableEntry.w word_164C6						; 2
		offsetTableEntry.w word_164DA						; 4
		offsetTableEntry.w word_164EE						; 6
		offsetTableEntry.w word_16502						; 8
		offsetTableEntry.w word_16516						; A

setSBZPlatformPos =	512

word_164B2:		; ypos, xpos, xpos, ypos, xpos, ypos, xpos, ypos, xpos, ypos
		dc.w $10, $E80+setSBZPlatformPos, $E14+setSBZPlatformPos, $370, $EEF+setSBZPlatformPos, $302, $EEF+setSBZPlatformPos, $340, $E14+setSBZPlatformPos, $3AE
word_164C6:
		dc.w $10, $F80+setSBZPlatformPos, $F14+setSBZPlatformPos, $2E0, $FEF+setSBZPlatformPos, $272, $FEF+setSBZPlatformPos, $2B0, $F14+setSBZPlatformPos, $31E
word_164DA:
		dc.w $10, $1080+setSBZPlatformPos, $1014+setSBZPlatformPos, $270, $10EF+setSBZPlatformPos, $202, $10EF+setSBZPlatformPos, $240, $1014+setSBZPlatformPos, $2AE
word_164EE:
		dc.w $10, $F80+setSBZPlatformPos, $F14+setSBZPlatformPos, $570, $FEF+setSBZPlatformPos, $502, $FEF+setSBZPlatformPos, $540, $F14+setSBZPlatformPos, $5AE
word_16502:
		dc.w $10, $1B80+setSBZPlatformPos, $1B14+setSBZPlatformPos, $670, $1BEF+setSBZPlatformPos, $602, $1BEF+setSBZPlatformPos, $640, $1B14+setSBZPlatformPos, $6AE
word_16516:
		dc.w $10, $1C80+setSBZPlatformPos, $1C14+setSBZPlatformPos, $5E0, $1CEF+setSBZPlatformPos, $572, $1CEF+setSBZPlatformPos, $5B0, $1C14+setSBZPlatformPos, $61E

; ---------------------------------------------------------------------------
; Scrap Brain Zone - Platform positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

ObjPosSBZPlatform_Index: offsetTable
		offsetTableEntry.w ObjPos_SBZ1pf1					; 0
		offsetTableEntry.w ObjPos_SBZ1pf2					; 2
		offsetTableEntry.w ObjPos_SBZ1pf3					; 4
		offsetTableEntry.w ObjPos_SBZ1pf4					; 6
		offsetTableEntry.w ObjPos_SBZ1pf5					; 8
		offsetTableEntry.w ObjPos_SBZ1pf6					; A
		offsetTableEntry.w ObjPos_SBZ1pf1					; C
		offsetTableEntry.w ObjPos_SBZ1pf2					; E

ObjPos_SBZ1pf1:		; xpos, ypos, subtype
		dc.w 8-1
		dc.w $E14+setSBZPlatformPos, $370, 0
		dc.w $E5A+setSBZPlatformPos, $34D, 1
		dc.w $EA0+setSBZPlatformPos, $32A, 1
		dc.w $EE7+setSBZPlatformPos, $307, 1
		dc.w $EEF+setSBZPlatformPos, $340, 2
		dc.w $EA9+setSBZPlatformPos, $363, 3
		dc.w $E63+setSBZPlatformPos, $386, 3
		dc.w $E1C+setSBZPlatformPos, $3A9, 3
ObjPos_SBZ1pf2:
		dc.w 8-1
		dc.w $F14+setSBZPlatformPos, $2E0, $10
		dc.w $F5A+setSBZPlatformPos, $2BD, $11
		dc.w $FA0+setSBZPlatformPos, $29A, $11
		dc.w $FE7+setSBZPlatformPos, $277, $11
		dc.w $FEF+setSBZPlatformPos, $2B0, $12
		dc.w $FA9+setSBZPlatformPos, $2D3, $13
		dc.w $F63+setSBZPlatformPos, $2F6, $13
		dc.w $F1C+setSBZPlatformPos, $319, $13
ObjPos_SBZ1pf3:
		dc.w 8-1
		dc.w $1014+setSBZPlatformPos, $270, $20
		dc.w $105A+setSBZPlatformPos, $24D, $21
		dc.w $10A0+setSBZPlatformPos, $22A, $21
		dc.w $10E7+setSBZPlatformPos, $207, $21
		dc.w $10EF+setSBZPlatformPos, $240, $22
		dc.w $10A9+setSBZPlatformPos, $263, $23
		dc.w $1063+setSBZPlatformPos, $286, $23
		dc.w $101C+setSBZPlatformPos, $2A9, $23
ObjPos_SBZ1pf4:
		dc.w 8-1
		dc.w $F14+setSBZPlatformPos, $570, $30
		dc.w $F5A+setSBZPlatformPos, $54D, $31
		dc.w $FA0+setSBZPlatformPos, $52A, $31
		dc.w $FE7+setSBZPlatformPos, $507, $31
		dc.w $FEF+setSBZPlatformPos, $540, $32
		dc.w $FA9+setSBZPlatformPos, $563, $33
		dc.w $F63+setSBZPlatformPos, $586, $33
		dc.w $F1C+setSBZPlatformPos, $5A9, $33
ObjPos_SBZ1pf5:
		dc.w 8-1
		dc.w $1B14+setSBZPlatformPos, $670, $40
		dc.w $1B5A+setSBZPlatformPos, $64D, $41
		dc.w $1BA0+setSBZPlatformPos, $62A, $41
		dc.w $1BE7+setSBZPlatformPos, $607, $41
		dc.w $1BEF+setSBZPlatformPos, $640, $42
		dc.w $1BA9+setSBZPlatformPos, $663, $43
		dc.w $1B63+setSBZPlatformPos, $686, $43
		dc.w $1B1C+setSBZPlatformPos, $6A9, $43
ObjPos_SBZ1pf6:
		dc.w 8-1
		dc.w $1C14+setSBZPlatformPos, $5E0, $50
		dc.w $1C5A+setSBZPlatformPos, $5BD, $51
		dc.w $1CA0+setSBZPlatformPos, $59A, $51
		dc.w $1CE7+setSBZPlatformPos, $577, $51
		dc.w $1CEF+setSBZPlatformPos, $5B0, $52
		dc.w $1CA9+setSBZPlatformPos, $5D3, $53
		dc.w $1C63+setSBZPlatformPos, $5F6, $53
		dc.w $1C1C+setSBZPlatformPos, $619, $53
