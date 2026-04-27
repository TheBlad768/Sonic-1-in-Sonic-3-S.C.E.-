; ---------------------------------------------------------------------------
; Object 6A - ground saws and pizza cutters (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

saw.origX				ds.w 1						; original x-axis position (2 bytes)
saw.origY				ds.w 1						; original y-axis position (2 bytes)
saw.flag				ds.b 1						; flag set when the ground saw appears (1 byte)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Saw:

		; init
		movem.l	ObjDat_Saw(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,code_addr(a0)						; set data from d0-d3 to current object
		move.w	x_pos(a0),saw.origX(a0)
		move.w	y_pos(a0),saw.origY(a0)

		; check
		cmpi.b	#3,subtype.byte(a0)						; is object a ground saw?
		bhs.s	.action								; if yes, branch
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set saw collision type
		move.w	#bytes_to_word(48/2,48/2),collision_height(a0)			; set height and width collision

.action
		moveq	#7,d0
		and.b	subtype.byte(a0),d0
		beq.s	.draw								; if zero, branch
		add.w	d0,d0
		move.w	Saw_TypeIndex-2(pc,d0.w),d0
		jsr	Saw_TypeIndex(pc,d0.w)

.draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	saw.origX(a0),d0						; get object position
		jmp	(Sprite_CheckDeleteTouch3.skipxpos).w
; ---------------------------------------------------------------------------

Saw_TypeIndex: offsetTable
		offsetTableEntry.w .type01
		offsetTableEntry.w .type02						; pizza cutters
		offsetTableEntry.w .type03
		offsetTableEntry.w .type04						; ground saws
; ---------------------------------------------------------------------------

.type01
		moveq	#$60,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+$C).w,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip01
		neg.w	d0
		add.w	d1,d0

.noflip01
		move.w	saw.origX(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)							; move saw sideways

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.sameframe01							; if time remains, branch
		addq.b	#2+1,anim_frame_timer(a0)					; reset timer to 2 frames
		bchg	#0,mapping_frame(a0)						; change frame

.sameframe01
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.return								; if not, branch

		; play sfx
		moveq	#$F,d0
		and.w	(Level_frame_counter).w,d0
		bne.s	.return
		sfx	sfx_Saw,1							; play saw sound
; ---------------------------------------------------------------------------

.return
		rts									; doesn't move
; ---------------------------------------------------------------------------

.type02
		moveq	#$30,d1
		moveq	#0,d0
		move.b	(Oscillating_Data+4).w,d0
		btst	#status.npc.x_flip,status(a0)
		beq.s	.noflip02
		neg.w	d0
		addi.w	#$80,d0

.noflip02
		move.w	saw.origY(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)							; move saw vertically

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.sameframe02							; if time remains, branch
		addq.b	#2+1,anim_frame_timer(a0)					; reset timer to 2 frames
		bchg	#0,mapping_frame(a0)						; change frame

.sameframe02
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.nosaw03y							; if not, branch
		cmpi.b	#$18,(Oscillating_Data+4).w
		bne.s	.nosaw03y
		sfx	sfx_Saw,1							; play saw sound
; ---------------------------------------------------------------------------

.type03
		tst.b	saw.flag(a0)							; has the saw appeared already?
		bne.s	.here03								; if yes, branch

		; check
		move.w	(Player_1+x_pos).w,d0
		subi.w	#$C0,d0
		blo.s	.nosaw03x
		sub.w	x_pos(a0),d0
		blo.s	.nosaw03x
		moveq	#-$80,d0
		add.w	(Player_1+y_pos).w,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.nosaw03y
		addi.w	#$100,d0
		cmp.w	y_pos(a0),d0
		blo.s	.nosaw03y

		; set
		st	saw.flag(a0)
		move.w	#$600,x_vel(a0)							; move object to the right
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set saw collision type
		move.w	#bytes_to_word(48/2,48/2),collision_height(a0)			; set height and width collision
		move.b	#2,mapping_frame(a0)
		sfx	sfx_Saw								; play saw sound

.nosaw03x
		addq.w	#4,sp								; exit from object

.nosaw03y
		rts
; ---------------------------------------------------------------------------

.here03
		MoveSpriteXOnly
		move.w	x_pos(a0),saw.origX(a0)

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.sameframe03							; if time remains, branch
		addq.b	#2+1,anim_frame_timer(a0)					; reset timer to 2 frames
		bchg	#0,mapping_frame(a0)						; change frame

.sameframe03
		rts
; ---------------------------------------------------------------------------

.type04
		tst.b	saw.flag(a0)
		bne.s	.here04

		; check
		move.w	(Player_1+x_pos).w,d0
		addi.w	#$E0,d0
		sub.w	x_pos(a0),d0
		bhs.s	.nosaw04x
		moveq	#-$80,d0
		add.w	(Player_1+y_pos).w,d0
		cmp.w	y_pos(a0),d0
		bhs.s	.nosaw04y
		addi.w	#$100,d0
		cmp.w	y_pos(a0),d0
		blo.s	.nosaw04y

		; set
		st	saw.flag(a0)
		move.w	#-$600,x_vel(a0)						; move object to the left
		move.b	#collision_type.npc.hurt,collision_type(a0)			; set saw collision type
		move.w	#bytes_to_word(48/2,48/2),collision_height(a0)			; set height and width collision
		move.b	#2,mapping_frame(a0)
		sfx	sfx_Saw								; play saw sound

.nosaw04x
		addq.w	#4,sp								; exit from object

.nosaw04y
		rts
; ---------------------------------------------------------------------------

.here04
		MoveSpriteXOnly
		move.w	x_pos(a0),saw.origX(a0)

		; wait
		subq.b	#1,anim_frame_timer(a0)						; decrement timer
		bpl.s	.sameframe04							; if time remains, branch
		addq.b	#2+1,anim_frame_timer(a0)					; reset timer to 2 frames
		bchg	#0,mapping_frame(a0)						; change frame

.sameframe04
		rts

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Saw:	subObjMainData Obj_Saw.action, setBit(render_flags.level), 0, 64, 64, 4, $3A4, 2, FALSE, Map_Saw
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Saw/Object Data/Map - Saw.asm"
