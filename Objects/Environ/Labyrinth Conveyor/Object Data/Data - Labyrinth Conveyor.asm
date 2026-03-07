; ---------------------------------------------------------------------------
; Labyrinth Zone - Conveyor positions
; ---------------------------------------------------------------------------

LabyrinthConveyorXpos =			512

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_Data: offsetTable
		offsetTableEntry.w LabyrinthConveyor_Group00				; 0
		offsetTableEntry.w LabyrinthConveyor_Group01				; 2
		offsetTableEntry.w LabyrinthConveyor_Group02				; 4
		offsetTableEntry.w LabyrinthConveyor_Group03				; 6
		offsetTableEntry.w LabyrinthConveyor_Group04				; 8
		offsetTableEntry.w LabyrinthConveyor_Group05				; A

LabyrinthConveyor_Group00: conveyorheader $1070+LabyrinthConveyorXpos, $2F0

		; xpos, ypos
		conveyorobjdata 8, -$D6
		conveyorobjdata $4E, -$90
		conveyorobjdata $4E, $A3
		conveyorobjdata $1C, $D5
		conveyorobjdata -$4E, $A0
		conveyorobjdata -$4E, -$AC
		conveyorend

LabyrinthConveyor_Group01: conveyorheader $1280+LabyrinthConveyorXpos, $377

		; xpos, ypos
		conveyorobjdata -2, -$F7
		conveyorobjdata $4E, -$A7
		conveyorobjdata $4E, $F7
		conveyorobjdata -$4E, $A9
		conveyorobjdata -$4E, -$AB
		conveyorend

LabyrinthConveyor_Group02: conveyorheader $D68+LabyrinthConveyorXpos, $530

		; xpos, ypos
		conveyorobjdata -$46, -$AE
		conveyorobjdata -$46, $AE
		conveyorobjdata $46, $AE
		conveyorobjdata $46, -$AE
		conveyorend

LabyrinthConveyor_Group03: conveyorheader $DA0+LabyrinthConveyorXpos, $440

		; xpos, ypos
		conveyorobjdata -$3E, -$9E
		conveyorobjdata $4E, -$9E
		conveyorobjdata $4E, $9E
		conveyorobjdata -$3E, $9E
		conveyorend

LabyrinthConveyor_Group04: conveyorheader $D00+LabyrinthConveyorXpos, $310

		; xpos, ypos
		conveyorobjdata -$54, -$CE
		conveyorobjdata $DE, -$CE
		conveyorobjdata $DE, $CE
		conveyorobjdata -$AE, $CE
		conveyorobjdata -$AE, -$74
		conveyorend

LabyrinthConveyor_Group05: conveyorheader $1300+LabyrinthConveyorXpos, $264

		; xpos, ypos
		conveyorobjdata -$AE, -$5A
		conveyorobjdata +$DE, -$5A
		conveyorobjdata +$DE, +$5A
		conveyorobjdata -$AE, +$5A
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

LabyrinthConveyor_Platform_LZ101: conveyorplatformheader $1070+LabyrinthConveyorXpos, $2F0

		; xpos, ypos, subtype
		conveyorplatformobjdata 8, -$D6, 0
		conveyorplatformobjdata $4E, -$5F, 2
		conveyorplatformobjdata $4E, $17, 2
		conveyorplatformobjdata $4E, $8E, 2
		conveyorplatformobjdata -$14, $A0, 4
		conveyorplatformobjdata -$4E, $62, 5
		conveyorplatformobjdata -$4E, -$15, 5
		conveyorplatformobjdata -$4E, -$8B, 5
		conveyorplatformend

LabyrinthConveyor_Platform_LZ102: conveyorplatformheader $1280+LabyrinthConveyorXpos, $377

		; xpos, ypos, subtype
		conveyorplatformobjdata -2, -$F7, $10
		conveyorplatformobjdata $4E, -$72, $12
		conveyorplatformobjdata $4E, $13, $12
		conveyorplatformobjdata $4E, $98, $12
		conveyorplatformobjdata $27, $F7, $13
		conveyorplatformobjdata -$4E, $98, $14
		conveyorplatformobjdata -$4E, $13, $14
		conveyorplatformobjdata -$4E, -$72, $14
		conveyorplatformend

LabyrinthConveyor_Platform_LZ201: conveyorplatformheader $D68+LabyrinthConveyorXpos, $530

		; xpos, ypos, subtype
		conveyorplatformobjdata -$46, -$AD, $21
		conveyorplatformobjdata $34, -$AE, $20
		conveyorplatformobjdata $46, -$46, $23
		conveyorplatformobjdata $46, $34, $23
		conveyorplatformobjdata $46, $AD, $23
		conveyorplatformobjdata -$34, $AE, $22
		conveyorplatformobjdata -$46, $46, $21
		conveyorplatformobjdata -$46, -$34, $21
		conveyorplatformend

LabyrinthConveyor_Platform_LZ202: conveyorplatformheader $DA0+LabyrinthConveyorXpos, $440

		; xpos, ypos, subtype
		conveyorplatformobjdata -$3E, -$9E, $30
		conveyorplatformobjdata $34, -$9E, $31
		conveyorplatformobjdata $4E, -$46, $32
		conveyorplatformobjdata $4E, $2C, $32
		conveyorplatformobjdata $4E, $9D, $32
		conveyorplatformobjdata -$24, $9E, $33
		conveyorplatformobjdata -$3E, $46, $30
		conveyorplatformobjdata -$3E, -$2C, $30
		conveyorplatformend

LabyrinthConveyor_Platform_LZ301: conveyorplatformheader $D00+LabyrinthConveyorXpos, $310

		; xpos, ypos, subtype
		conveyorplatformobjdata -$53, -$CE, $41
		conveyorplatformobjdata $2D, -$CE, $41
		conveyorplatformobjdata $AC, -$CE, $41
		conveyorplatformobjdata $DE, -$81, $42
		conveyorplatformobjdata $DE, -$2, $42
		conveyorplatformobjdata $DE, $7D, $42
		conveyorplatformobjdata $B0, $CE, $43
		conveyorplatformobjdata $31, $CE, $43
		conveyorplatformobjdata -$4E, $CE, $43
		conveyorplatformobjdata -$AE, $AF, $44
		conveyorplatformobjdata -$AE, $30, $44
		conveyorplatformobjdata -$AE, -$4F, $44
		conveyorplatformend

LabyrinthConveyor_Platform_LZ302: conveyorplatformheader $1300+LabyrinthConveyorXpos, $264

		; xpos, ypos, subtype
		conveyorplatformobjdata -$AE, -$5A, $50
		conveyorplatformobjdata -$2E, -$5A, $51
		conveyorplatformobjdata $52, -$5A, $51
		conveyorplatformobjdata $D2, -$5A, $51
		conveyorplatformobjdata $DE, $1A, $52
		conveyorplatformobjdata $9E, $5A, $53
		conveyorplatformobjdata $1E, $5A, $53
		conveyorplatformobjdata -$62, $5A, $53
		conveyorplatformobjdata -$AE, $26, $50
		conveyorplatformend
