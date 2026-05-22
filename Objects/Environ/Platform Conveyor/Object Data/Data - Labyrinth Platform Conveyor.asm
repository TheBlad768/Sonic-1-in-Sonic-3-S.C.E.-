; ---------------------------------------------------------------------------
; Labyrinth Zone - Conveyor positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthPlatformConveyor_Data: offsetTable
		offsetTableEntry.w LabyrinthPlatformConveyor_Group00			; 0
		offsetTableEntry.w LabyrinthPlatformConveyor_Group01			; 2
		offsetTableEntry.w LabyrinthPlatformConveyor_Group02			; 4
		offsetTableEntry.w LabyrinthPlatformConveyor_Group03			; 6
		offsetTableEntry.w LabyrinthPlatformConveyor_Group04			; 8
		offsetTableEntry.w LabyrinthPlatformConveyor_Group05			; A
; ---------------------------------------------------------------------------

LabyrinthPlatformConveyor_Group00: conveyorheader

		; xpos, ypos
		conveyorobjdata 8, -$66
		conveyorobjdata $4E, -$20
		conveyorobjdata $4E, $113
		conveyorobjdata $1C, $145
		conveyorobjdata -$4E, $110
		conveyorobjdata -$4E, -$3C
		conveyorend								; end marker

LabyrinthPlatformConveyor_Group01: conveyorheader

		; xpos, ypos
		conveyorobjdata -2, -$80
		conveyorobjdata $4E, -$30
		conveyorobjdata $4E, $16E
		conveyorobjdata -$4E, $120
		conveyorobjdata -$4E, -$34
		conveyorend								; end marker

LabyrinthPlatformConveyor_Group02: conveyorheader

		; xpos, ypos
		conveyorobjdata -$46, 2
		conveyorobjdata -$46, $15E
		conveyorobjdata $46, $15E
		conveyorobjdata $46, 2
		conveyorend								; end marker

LabyrinthPlatformConveyor_Group03: conveyorheader

		; xpos, ypos
		conveyorobjdata -$3E, $22
		conveyorobjdata $4E, $22
		conveyorobjdata $4E, $15E
		conveyorobjdata -$3E, $15E
		conveyorend								; end marker

LabyrinthPlatformConveyor_Group04: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, -$3E
		conveyorobjdata $C6, -$3E
		conveyorobjdata $C6, $15E
		conveyorobjdata -$C6, $15E
		conveyorobjdata -$C6, $1C
		conveyorend								; end marker

LabyrinthPlatformConveyor_Group05: conveyorheader

		; xpos, ypos
		conveyorobjdata -$C6, -$76
		conveyorobjdata $C6, -$76
		conveyorobjdata $C6, $3E
		conveyorobjdata -$C6, $3E
		conveyorend								; end marker

; ---------------------------------------------------------------------------
; Labyrinth Zone - Platform positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthPlatformConveyor_Platform_Index: offsetTable
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ101		; 0 (LZ1)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ102		; 2 (LZ1)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ201		; 4 (LZ2)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ202		; 6 (LZ2)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ301		; 8 (LZ3)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ302		; A (LZ3)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ101		; C (LZ1)
		offsetTableEntry.w LabyrinthPlatformConveyor_Platform_LZ102		; E (LZ1)
; ---------------------------------------------------------------------------

LabyrinthPlatformConveyor_Platform_LZ101: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata 8, -$66, 0
		conveyorplatformobjdata $4E, $11, 2
		conveyorplatformobjdata $4E, $87, 2
		conveyorplatformobjdata $4E, $FE, 2
		conveyorplatformobjdata -$14, $100, 4
		conveyorplatformobjdata -$4E, $D2, 5
		conveyorplatformobjdata -$4E, $5B, 5
		conveyorplatformobjdata -$4E, -$1B, 5
		conveyorplatformend							; end marker

LabyrinthPlatformConveyor_Platform_LZ102: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -2, -$80, $10
		conveyorplatformobjdata $4E, 5, $12
		conveyorplatformobjdata $4E, $8A, $12
		conveyorplatformobjdata $4E, $10F, $12
		conveyorplatformobjdata $27, $16E, $13
		conveyorplatformobjdata -$4E, $10F, $14
		conveyorplatformobjdata -$4E, $8A, $14
		conveyorplatformobjdata -$4E, 5, $14
		conveyorplatformend							; end marker

LabyrinthPlatformConveyor_Platform_LZ201: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$46, 3, $21
		conveyorplatformobjdata $34, 2, $20
		conveyorplatformobjdata $46, $6A, $23
		conveyorplatformobjdata $46, $E4, $23
		conveyorplatformobjdata $46, $15D, $23
		conveyorplatformobjdata -$34, $15E, $22
		conveyorplatformobjdata -$46, $F6, $21
		conveyorplatformobjdata -$46, $7C, $21
		conveyorplatformend							; end marker

LabyrinthPlatformConveyor_Platform_LZ202: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$3E, $22, $30
		conveyorplatformobjdata $34, $22, $31
		conveyorplatformobjdata $4E, $7A, $32
		conveyorplatformobjdata $4E, $EC, $32
		conveyorplatformobjdata $4E, $15D, $32
		conveyorplatformobjdata -$24, $15E, $33
		conveyorplatformobjdata -$3E, $106, $30
		conveyorplatformobjdata -$3E, $94, $30
		conveyorplatformend							; end marker

LabyrinthPlatformConveyor_Platform_LZ301: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6B, -$3E, $41
		conveyorplatformobjdata $15, -$3E, $41
		conveyorplatformobjdata $94, -$3E, $41
		conveyorplatformobjdata $C6, $F, $42
		conveyorplatformobjdata $C6, $8E, $42
		conveyorplatformobjdata $C6, $10D, $42
		conveyorplatformobjdata $98, $15E, $43
		conveyorplatformobjdata $19, $15E, $43
		conveyorplatformobjdata -$66, $15E, $43
		conveyorplatformobjdata -$C6, $13F, $44
		conveyorplatformobjdata -$C6, $C0, $44
		conveyorplatformobjdata -$C6, $41, $44
		conveyorplatformend							; end marker

LabyrinthPlatformConveyor_Platform_LZ302: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$C6, -$76, $50
		conveyorplatformobjdata -$46, -$76, $51
		conveyorplatformobjdata $3A, -$76, $51
		conveyorplatformobjdata $BA, -$76, $51
		conveyorplatformobjdata $C6, -2, $52
		conveyorplatformobjdata $86, $3E, $53
		conveyorplatformobjdata 6, $3E, $53
		conveyorplatformobjdata -$7A, $3E, $53
		conveyorplatformobjdata -$C6, $A, $50
		conveyorplatformend							; end marker
