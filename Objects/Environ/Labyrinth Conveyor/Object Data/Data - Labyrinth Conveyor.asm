; ---------------------------------------------------------------------------
; Labyrinth Zone - Conveyor positions
; ---------------------------------------------------------------------------

setLZPlatformPos =			512

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_Data: offsetTable
		offsetTableEntry.w word_125F4						; 0
		offsetTableEntry.w word_12610						; 2
		offsetTableEntry.w word_12628						; 4
		offsetTableEntry.w word_1263C						; 6
		offsetTableEntry.w word_12650						; 8
		offsetTableEntry.w word_12668						; A

word_125F4:
		dc.w (.end-.start)							; header
		dc.w $1070+setLZPlatformPos						; main x-axis position

.start
		dc.w $1078+setLZPlatformPos, $21A					; xpos, ypos
		dc.w $10BE+setLZPlatformPos, $260
		dc.w $10BE+setLZPlatformPos, $393
		dc.w $108C+setLZPlatformPos, $3C5
		dc.w $1022+setLZPlatformPos, $390
		dc.w $1022+setLZPlatformPos, $244
.end

word_12610:
		dc.w (.end-.start)							; header
		dc.w $1280+setLZPlatformPos						; main x-axis position

.start
		dc.w $127E+setLZPlatformPos, $280					; xpos, ypos
		dc.w $12CE+setLZPlatformPos, $2D0
		dc.w $12CE+setLZPlatformPos, $46E
		dc.w $1232+setLZPlatformPos, $420
		dc.w $1232+setLZPlatformPos, $2CC
.end

word_12628:
		dc.w (.end-.start)							; header
		dc.w $D68+setLZPlatformPos						; main x-axis position

.start
		dc.w $D22+setLZPlatformPos, $482					; xpos, ypos
		dc.w $D22+setLZPlatformPos, $5DE
		dc.w $DAE+setLZPlatformPos, $5DE
		dc.w $DAE+setLZPlatformPos, $482
.end

word_1263C:
		dc.w (.end-.start)							; header
		dc.w $DA0+setLZPlatformPos						; main x-axis position

.start
		dc.w $D62+setLZPlatformPos, $3A2					; xpos, ypos
		dc.w $DEE+setLZPlatformPos, $3A2
		dc.w $DEE+setLZPlatformPos, $4DE
		dc.w $D62+setLZPlatformPos, $4DE
.end

word_12650:
		dc.w (.end-.start)							; header
		dc.w $D00+setLZPlatformPos						; main x-axis position

.start
		dc.w $CAC+setLZPlatformPos, $242					; xpos, ypos
		dc.w $DDE+setLZPlatformPos, $242
		dc.w $DDE+setLZPlatformPos, $3DE
		dc.w $C52+setLZPlatformPos, $3DE
		dc.w $C52+setLZPlatformPos, $29C
.end

word_12668:
		dc.w (.end-.start)							; header
		dc.w $1300+setLZPlatformPos						; main x-axis position

.start
		dc.w $1252+setLZPlatformPos, $20A					; xpos, ypos
		dc.w $13DE+setLZPlatformPos, $20A
		dc.w $13DE+setLZPlatformPos, $2BE
		dc.w $1252+setLZPlatformPos, $2BE
.end

; ---------------------------------------------------------------------------
; Labyrinth Zone - Platform positions
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LabyrinthConveyor_Platform_Index: offsetTable
		offsetTableEntry.w ObjPos_LZ1pf1					; 0
		offsetTableEntry.w ObjPos_LZ1pf2					; 2
		offsetTableEntry.w ObjPos_LZ2pf1					; 4
		offsetTableEntry.w ObjPos_LZ2pf2					; 6
		offsetTableEntry.w ObjPos_LZ3pf1					; 8
		offsetTableEntry.w ObjPos_LZ3pf2					; A
		offsetTableEntry.w ObjPos_LZ1pf1					; C
		offsetTableEntry.w ObjPos_LZ1pf2					; E

ObjPos_LZ1pf1:
		dc.w 8-1								; header
		dc.w $1078+setLZPlatformPos, $21A, 0					; xpos, ypos, subtype
		dc.w $10BE+setLZPlatformPos, $291, 2
		dc.w $10BE+setLZPlatformPos, $307, 2
		dc.w $10BE+setLZPlatformPos, $37E, 2
		dc.w $105C+setLZPlatformPos, $390, 4
		dc.w $1022+setLZPlatformPos, $352, 5
		dc.w $1022+setLZPlatformPos, $2DB, 5
		dc.w $1022+setLZPlatformPos, $265, 5

ObjPos_LZ1pf2:
		dc.w 8-1								; header
		dc.w $127E+setLZPlatformPos, $280, $10					; xpos, ypos, subtype
		dc.w $12CE+setLZPlatformPos, $305, $12
		dc.w $12CE+setLZPlatformPos, $38A, $12
		dc.w $12CE+setLZPlatformPos, $40F, $12
		dc.w $12A7+setLZPlatformPos, $46E, $13
		dc.w $1232+setLZPlatformPos, $40F, $14
		dc.w $1232+setLZPlatformPos, $38A, $14
		dc.w $1232+setLZPlatformPos, $305, $14

ObjPos_LZ2pf1:
		dc.w 8-1								; header
		dc.w $D22+setLZPlatformPos, $483, $21					; xpos, ypos, subtype
		dc.w $D9C+setLZPlatformPos, $482, $20
		dc.w $DAE+setLZPlatformPos, $4EA, $23
		dc.w $DAE+setLZPlatformPos, $564, $23
		dc.w $DAE+setLZPlatformPos, $5DD, $23
		dc.w $D34+setLZPlatformPos, $5DE, $22
		dc.w $D22+setLZPlatformPos, $576, $21
		dc.w $D22+setLZPlatformPos, $4FC, $21

ObjPos_LZ2pf2:
		dc.w 8-1								; header
		dc.w $D62+setLZPlatformPos, $3A2, $30					; xpos, ypos, subtype
		dc.w $DD4+setLZPlatformPos, $3A2, $31
		dc.w $DEE+setLZPlatformPos, $3FA, $32
		dc.w $DEE+setLZPlatformPos, $46C, $32
		dc.w $DEE+setLZPlatformPos, $4DD, $32
		dc.w $D7C+setLZPlatformPos, $4DE, $33
		dc.w $D62+setLZPlatformPos, $486, $30
		dc.w $D62+setLZPlatformPos, $414, $30

ObjPos_LZ3pf1:
		dc.w 12-1								; header
		dc.w $CAD+setLZPlatformPos, $242, $41					; xpos, ypos, subtype
		dc.w $D2D+setLZPlatformPos, $242, $41
		dc.w $DAC+setLZPlatformPos, $242, $41
		dc.w $DDE+setLZPlatformPos, $28F, $42
		dc.w $DDE+setLZPlatformPos, $30E, $42
		dc.w $DDE+setLZPlatformPos, $38D, $42
		dc.w $DB0+setLZPlatformPos, $3DE, $43
		dc.w $D31+setLZPlatformPos, $3DE, $43
		dc.w $CB2+setLZPlatformPos, $3DE, $43
		dc.w $C52+setLZPlatformPos, $3BF, $44
		dc.w $C52+setLZPlatformPos, $340, $44
		dc.w $C52+setLZPlatformPos, $2C1, $44

ObjPos_LZ3pf2:
		dc.w 9-1								; header
		dc.w $1252+setLZPlatformPos, $20A, $50					; xpos, ypos, subtype
		dc.w $12D2+setLZPlatformPos, $20A, $51
		dc.w $1352+setLZPlatformPos, $20A, $51
		dc.w $13D2+setLZPlatformPos, $20A, $51
		dc.w $13DE+setLZPlatformPos, $27E, $52
		dc.w $139E+setLZPlatformPos, $2BE, $53
		dc.w $131E+setLZPlatformPos, $2BE, $53
		dc.w $129E+setLZPlatformPos, $2BE, $53
		dc.w $1252+setLZPlatformPos, $28A, $50
