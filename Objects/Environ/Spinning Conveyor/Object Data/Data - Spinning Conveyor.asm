; ---------------------------------------------------------------------------
; Scrap Brain Zone - Conveyor positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SpinningConveyor_Data: offsetTable
		offsetTableEntry.w SpinningConveyor_Group00				; 0
		offsetTableEntry.w SpinningConveyor_Group01				; 2
		offsetTableEntry.w SpinningConveyor_Group02				; 4
		offsetTableEntry.w SpinningConveyor_Group03				; 6
		offsetTableEntry.w SpinningConveyor_Group04				; 8
		offsetTableEntry.w SpinningConveyor_Group05				; A

SpinningConveyor_Group00: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, -$10
		conveyorobjdata $6F, -$7E
		conveyorobjdata $6F, -$40
		conveyorobjdata -$6C, $2E
		conveyorend

SpinningConveyor_Group01: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, -$20
		conveyorobjdata $6F, -$8E
		conveyorobjdata $6F, -$50
		conveyorobjdata -$6C, $1E
		conveyorend

SpinningConveyor_Group02: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, -$10
		conveyorobjdata $6F, -$7E
		conveyorobjdata $6F, -$40
		conveyorobjdata -$6C, $2E
		conveyorend

SpinningConveyor_Group03: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, $70
		conveyorobjdata $6F, 2
		conveyorobjdata $6F, $40
		conveyorobjdata -$6C, $AE
		conveyorend

SpinningConveyor_Group04: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, $70
		conveyorobjdata $6F, 2
		conveyorobjdata $6F, $40
		conveyorobjdata -$6C, $AE
		conveyorend

SpinningConveyor_Group05: conveyorheader

		; xpos, ypos
		conveyorobjdata -$6C, $60
		conveyorobjdata $6F, -$E
		conveyorobjdata $6F, $30
		conveyorobjdata -$6C, $9E
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

SpinningConveyor_Platform_SBZ101: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, -$10, 0
		conveyorplatformobjdata -$26, -$33, 1
		conveyorplatformobjdata $20, -$56, 1
		conveyorplatformobjdata $67, -$79, 1
		conveyorplatformobjdata $6F, -$40, 2
		conveyorplatformobjdata $29, -$1D, 3
		conveyorplatformobjdata -$1D, 6, 3
		conveyorplatformobjdata -$64, $29, 3
		conveyorplatformend

SpinningConveyor_Platform_SBZ102: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, -$20, $10
		conveyorplatformobjdata -$26, -$43, $11
		conveyorplatformobjdata $20, -$66, $11
		conveyorplatformobjdata $67, -$89, $11
		conveyorplatformobjdata $6F, -$50, $12
		conveyorplatformobjdata $29, -$2D, $13
		conveyorplatformobjdata -$1D, -$A, $13
		conveyorplatformobjdata -$64, $19, $13
		conveyorplatformend

SpinningConveyor_Platform_SBZ103: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, -$10, $20
		conveyorplatformobjdata -$26, -$33, $21
		conveyorplatformobjdata $20, -$56, $21
		conveyorplatformobjdata $67, -$79, $21
		conveyorplatformobjdata $6F, -$40, $22
		conveyorplatformobjdata $29, -$1D, $23
		conveyorplatformobjdata -$1D, 6, $23
		conveyorplatformobjdata -$64, $29, $23
		conveyorplatformend

SpinningConveyor_Platform_SBZ104: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $70, $30
		conveyorplatformobjdata -$26, $4D, $31
		conveyorplatformobjdata $20, $2A, $31
		conveyorplatformobjdata $67, 7, $31
		conveyorplatformobjdata $6F, $40, $32
		conveyorplatformobjdata $29, $63, $33
		conveyorplatformobjdata -$1D, $86, $33
		conveyorplatformobjdata -$64, $A9, $33
		conveyorplatformend

SpinningConveyor_Platform_SBZ105: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $70, $40
		conveyorplatformobjdata -$26, $4D, $41
		conveyorplatformobjdata $20, $2A, $41
		conveyorplatformobjdata $67, 7, $41
		conveyorplatformobjdata $6F, $40, $42
		conveyorplatformobjdata $29, $63, $43
		conveyorplatformobjdata -$1D, $86, $43
		conveyorplatformobjdata -$64, $A9, $43
		conveyorplatformend

SpinningConveyor_Platform_SBZ106: conveyorplatformheader

		; xpos, ypos, subtype
		conveyorplatformobjdata -$6C, $60, $50
		conveyorplatformobjdata -$26, $3D, $51
		conveyorplatformobjdata $20, $1A, $51
		conveyorplatformobjdata $67, -9, $51
		conveyorplatformobjdata $6F, $30, $52
		conveyorplatformobjdata $29, $53, $53
		conveyorplatformobjdata -$1D, $76, $53
		conveyorplatformobjdata -$64, $99, $53
		conveyorplatformend
