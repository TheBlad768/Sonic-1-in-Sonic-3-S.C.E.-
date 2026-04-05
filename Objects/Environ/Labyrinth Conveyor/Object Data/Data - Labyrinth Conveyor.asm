; ---------------------------------------------------------------------------
; Labyrinth Zone - Conveyor positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_Data: offsetTable
		offsetTableEntry.w LabyrinthConveyor_Group00				; 0
		offsetTableEntry.w LabyrinthConveyor_Group01				; 2
		offsetTableEntry.w LabyrinthConveyor_Group02				; 4
		offsetTableEntry.w LabyrinthConveyor_Group03				; 6
		offsetTableEntry.w LabyrinthConveyor_Group04				; 8
		offsetTableEntry.w LabyrinthConveyor_Group05				; A

LabyrinthConveyor_Group00: conveyorheader

		; xpos, ypos
		conveyorobjdata 8, -$66
		conveyorobjdata $4E, -$20
		conveyorobjdata $4E, $113
		conveyorobjdata $1C, $145
		conveyorobjdata -$4E, $110
		conveyorobjdata -$4E, -$3C
		conveyorend

LabyrinthConveyor_Group01: conveyorheader

		; xpos, ypos
		conveyorobjdata -2, -$80
		conveyorobjdata $4E, -$30
		conveyorobjdata $4E, $16E
		conveyorobjdata -$4E, $120
		conveyorobjdata -$4E, -$34
		conveyorend

LabyrinthConveyor_Group02: conveyorheader

		; xpos, ypos
		conveyorobjdata -$46, 2
		conveyorobjdata -$46, $15E
		conveyorobjdata $46, $15E
		conveyorobjdata $46, 2
		conveyorend

LabyrinthConveyor_Group03: conveyorheader

		; xpos, ypos
		conveyorobjdata -$3E, $22
		conveyorobjdata $4E, $22
		conveyorobjdata $4E, $15E
		conveyorobjdata -$3E, $15E
		conveyorend

LabyrinthConveyor_Group04: conveyorheader

		; xpos, ypos
		conveyorobjdata -$54, -$3E
		conveyorobjdata $DE, -$3E
		conveyorobjdata $DE, $15E
		conveyorobjdata -$AE, $15E
		conveyorobjdata -$AE, $1C
		conveyorend

LabyrinthConveyor_Group05: conveyorheader

		; xpos, ypos
		conveyorobjdata -$AE, -$76
		conveyorobjdata $DE, -$76
		conveyorobjdata $DE, $3E
		conveyorobjdata -$AE, $3E
		conveyorend

; ---------------------------------------------------------------------------
; Labyrinth Zone - Platform positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_Platform_Index: offsetTable
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ101			; 0 (LZ1)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ102			; 2 (LZ1)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ201			; 4 (LZ2)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ202			; 6 (LZ2)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ301			; 8 (LZ3)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ302			; A (LZ3)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ101			; C (LZ1)
		offsetTableEntry.w LabyrinthConveyor_Platform_LZ102			; E (LZ1)

LabyrinthConveyor_Platform_LZ101: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata 8, -$66, 0
		conveyorplatformobjdata $4E, $11, 2
		conveyorplatformobjdata $4E, $87, 2
		conveyorplatformobjdata $4E, $FE, 2
		conveyorplatformobjdata -$14, $100, 4
		conveyorplatformobjdata -$4E, $D2, 5
		conveyorplatformobjdata -$4E, $5B, 5
		conveyorplatformobjdata -$4E, -$1B, 5
		conveyorplatformend

LabyrinthConveyor_Platform_LZ102: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -2, -$80, $10
		conveyorplatformobjdata $4E, 5, $12
		conveyorplatformobjdata $4E, $8A, $12
		conveyorplatformobjdata $4E, $10F, $12
		conveyorplatformobjdata $27, $16E, $13
		conveyorplatformobjdata -$4E, $10F, $14
		conveyorplatformobjdata -$4E, $8A, $14
		conveyorplatformobjdata -$4E, 5, $14
		conveyorplatformend

LabyrinthConveyor_Platform_LZ201: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$46, 3, $21
		conveyorplatformobjdata $34, 2, $20
		conveyorplatformobjdata $46, $6A, $23
		conveyorplatformobjdata $46, $E4, $23
		conveyorplatformobjdata $46, $15D, $23
		conveyorplatformobjdata -$34, $15E, $22
		conveyorplatformobjdata -$46, $F6, $21
		conveyorplatformobjdata -$46, $7C, $21
		conveyorplatformend

LabyrinthConveyor_Platform_LZ202: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$3E, $22, $30
		conveyorplatformobjdata $34, $22, $31
		conveyorplatformobjdata $4E, $7A, $32
		conveyorplatformobjdata $4E, $EC, $32
		conveyorplatformobjdata $4E, $15D, $32
		conveyorplatformobjdata -$24, $15E, $33
		conveyorplatformobjdata -$3E, $106, $30
		conveyorplatformobjdata -$3E, $94, $30
		conveyorplatformend

LabyrinthConveyor_Platform_LZ301: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$53, -$3E, $41
		conveyorplatformobjdata $2D, -$3E, $41
		conveyorplatformobjdata $AC, -$3E, $41
		conveyorplatformobjdata $DE, $F, $42
		conveyorplatformobjdata $DE, $8E, $42
		conveyorplatformobjdata $DE, $10D, $42
		conveyorplatformobjdata $B0, $15E, $43
		conveyorplatformobjdata $31, $15E, $43
		conveyorplatformobjdata -$4E, $15E, $43
		conveyorplatformobjdata -$AE, $13F, $44
		conveyorplatformobjdata -$AE, $C0, $44
		conveyorplatformobjdata -$AE, $41, $44
		conveyorplatformend

LabyrinthConveyor_Platform_LZ302: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$AE, -$76, $50
		conveyorplatformobjdata -$2E, -$76, $51
		conveyorplatformobjdata $52, -$76, $51
		conveyorplatformobjdata $D2, -$76, $51
		conveyorplatformobjdata $DE, -2, $52
		conveyorplatformobjdata $9E, $3E, $53
		conveyorplatformobjdata $1E, $3E, $53
		conveyorplatformobjdata -$62, $3E, $53
		conveyorplatformobjdata -$AE, $A, $50
		conveyorplatformend
