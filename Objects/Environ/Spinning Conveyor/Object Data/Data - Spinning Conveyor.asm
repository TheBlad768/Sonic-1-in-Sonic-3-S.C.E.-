; ---------------------------------------------------------------------------
; Scrap Brain Zone - Conveyor positions
; ---------------------------------------------------------------------------

SpinningConveyorXpos =			512

; =============== S U B R O U T I N E =======================================

SpinningConveyor_Data: offsetTable
		offsetTableEntry.w SpinningConveyor_Group00				; 0
		offsetTableEntry.w SpinningConveyor_Group01				; 2
		offsetTableEntry.w SpinningConveyor_Group02				; 4
		offsetTableEntry.w SpinningConveyor_Group03				; 6
		offsetTableEntry.w SpinningConveyor_Group04				; 8
		offsetTableEntry.w SpinningConveyor_Group05				; A

SpinningConveyor_Group00: conveyorheader $E80+SpinningConveyorXpos, $358

		; xpos, ypos
		conveyorobjdata -$6C, $18
		conveyorobjdata $6F, -$56
		conveyorobjdata $6F, -$18
		conveyorobjdata -$6C, $56
		conveyorend

SpinningConveyor_Group01: conveyorheader $F80+SpinningConveyorXpos, $2C8

		; xpos, ypos
		conveyorobjdata -$6C, $18
		conveyorobjdata $6F, -$56
		conveyorobjdata $6F, -$18
		conveyorobjdata -$6C, $56
		conveyorend

SpinningConveyor_Group02: conveyorheader $1080+SpinningConveyorXpos, $228

		; xpos, ypos
		conveyorobjdata -$6C, $48
		conveyorobjdata $6F, -$26
		conveyorobjdata $6F, $18
		conveyorobjdata -$6C, $86
		conveyorend

SpinningConveyor_Group03: conveyorheader $F80+SpinningConveyorXpos, $558

		; xpos, ypos
		conveyorobjdata -$6C, $18
		conveyorobjdata $6F, -$56
		conveyorobjdata $6F, -$18
		conveyorobjdata -$6C, $56
		conveyorend

SpinningConveyor_Group04: conveyorheader $1B80+SpinningConveyorXpos, $658

		; xpos, ypos
		conveyorobjdata -$6C, $18
		conveyorobjdata $6F, -$56
		conveyorobjdata $6F, -$18
		conveyorobjdata -$6C, $56
		conveyorend

SpinningConveyor_Group05: conveyorheader $1C80+SpinningConveyorXpos, $5C8

		; xpos, ypos
		conveyorobjdata -$6C, $18
		conveyorobjdata $6F, -$56
		conveyorobjdata $6F, -$18
		conveyorobjdata -$6C, $56
		conveyorend

; ---------------------------------------------------------------------------
; Scrap Brain Zone - Platform positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpinningConveyor_Platform_Index: offsetTable
		offsetTableEntry.w SpinningConveyor_Platform_SBZ101			; 0 (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ102			; 2 (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ103			; 4 (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ104			; 6 (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ105			; 8 (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ106			; A (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ101			; C (SBZ1)
		offsetTableEntry.w SpinningConveyor_Platform_SBZ102			; E (SBZ1)

SpinningConveyor_Platform_SBZ101: conveyorplatformheader $E80+SpinningConveyorXpos, $358

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $18, 0
		conveyorplatformobjdata -$26, -$B, 1
		conveyorplatformobjdata $20, -$2E, 1
		conveyorplatformobjdata $67, -$51, 1
		conveyorplatformobjdata $6F, -$18, 2
		conveyorplatformobjdata $29, $B, 3
		conveyorplatformobjdata -$1D, $2E, 3
		conveyorplatformobjdata -$64, $51, 3
		conveyorplatformend

SpinningConveyor_Platform_SBZ102: conveyorplatformheader $F80+SpinningConveyorXpos, $2C8

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $18, $10
		conveyorplatformobjdata -$26, -$B, $11
		conveyorplatformobjdata $20, -$2E, $11
		conveyorplatformobjdata $67, -$51, $11
		conveyorplatformobjdata $6F, -$18, $12
		conveyorplatformobjdata $29, $B, $13
		conveyorplatformobjdata -$1D, $2E, $13
		conveyorplatformobjdata -$64, $51, $13
		conveyorplatformend

SpinningConveyor_Platform_SBZ103: conveyorplatformheader $1080+SpinningConveyorXpos, $228

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $48, $20
		conveyorplatformobjdata -$26, $25, $21
		conveyorplatformobjdata $20, $2, $21
		conveyorplatformobjdata $67, -$21, $21
		conveyorplatformobjdata $6F, $18, $22
		conveyorplatformobjdata $29, $3B, $23
		conveyorplatformobjdata -$1D, $5E, $23
		conveyorplatformobjdata -$64, $81, $23
		conveyorplatformend

SpinningConveyor_Platform_SBZ104: conveyorplatformheader $F80+SpinningConveyorXpos, $558

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $18, $30
		conveyorplatformobjdata -$26, -$B, $31
		conveyorplatformobjdata $20, -$2E, $31
		conveyorplatformobjdata $67, -$51, $31
		conveyorplatformobjdata $6F, -$18, $32
		conveyorplatformobjdata $29, $B, $33
		conveyorplatformobjdata -$1D, $2E, $33
		conveyorplatformobjdata -$64, $51, $33
		conveyorplatformend

SpinningConveyor_Platform_SBZ105: conveyorplatformheader $1B80+SpinningConveyorXpos, $658

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $18, $40
		conveyorplatformobjdata -$26, -$B, $41
		conveyorplatformobjdata $20, -$2E, $41
		conveyorplatformobjdata $67, -$51, $41
		conveyorplatformobjdata $6F, -$18, $42
		conveyorplatformobjdata $29, $B, $43
		conveyorplatformobjdata -$1D, $2E, $43
		conveyorplatformobjdata -$64, $51, $43
		conveyorplatformend

SpinningConveyor_Platform_SBZ106: conveyorplatformheader $1C80+SpinningConveyorXpos, $5C8

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $18, $50
		conveyorplatformobjdata -$26, -$B, $51
		conveyorplatformobjdata $20, -$2E, $51
		conveyorplatformobjdata $67, -$51, $51
		conveyorplatformobjdata $6F, -$18, $52
		conveyorplatformobjdata $29, $B, $53
		conveyorplatformobjdata -$1D, $2E, $53
		conveyorplatformobjdata -$64, $51, $53
		conveyorplatformend
