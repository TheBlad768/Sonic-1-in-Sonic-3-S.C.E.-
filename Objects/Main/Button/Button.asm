; ---------------------------------------------------------------------------
; Object 32 - buttons (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Button:

		; init
		movem.l	ObjDat_Button(pc),d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)						; set data from d0-d3 to current object

		; check level
		cmpi.b	#LevelID_MZ,(Current_zone).w					; is level Marble Zone?
		bne.s	.notMZ								; if not, branch
		ori.w	#palette_line_2,art_tile(a0)					; MZ specific code

.notMZ
		addq.w	#4,y_pos(a0)

		; check
		btst	#5,subtype(a0)							; $20?
		bne.s	Button_Alternate

.main
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch

		; solid
		moveq	#(32/2)+$B,d1							; width
		moveq	#(10/2)+1,d3							; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop).w
		clr.b	mapping_frame(a0)

		; check
		moveq	#$F,d0
		and.b	subtype(a0),d0
		lea	(Level_trigger_array).w,a3
		adda.w	d0,a3

		; set
		moveq	#0,d3								; bit 0
		btst	#6,subtype(a0)							; $40?
		beq.s	.checkMZ
		moveq	#7,d3								; bit 7

.checkMZ
		tst.b	subtype(a0)
		bpl.s	.skip

		; check pushable block
		bsr.w	But_MZBlock							; is block touch the button?
		bne.s	.press								; if yes, branch

.skip
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	.press								; if yes, branch

		; check
		btst	#4,subtype(a0)							; $10?
		bne.s	.draw
		bclr	d3,(a3)								; set as unpressed
		bra.s	.draw
; ---------------------------------------------------------------------------

.press
		tst.b	(a3)
		bne.s	.set
		sfx	sfx_Switch

.set
		bset	d3,(a3)								; set as pressed
		move.b	#1,mapping_frame(a0)

.draw
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Button_Alternate:

		; alt
		move.l	#.main,address(a0)

.main
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.draw								; if not, branch

		; solid
		moveq	#32/2,d1							; width
		moveq	#(10/2)+1,d3							; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop).w
		clr.b	mapping_frame(a0)

		; check
		moveq	#$F,d0
		and.b	subtype(a0),d0
		lea	(Level_trigger_array).w,a3
		adda.w	d0,a3

		; set
		moveq	#0,d3								; bit 0
		btst	#6,subtype(a0)							; $40?
		beq.s	.skip
		moveq	#7,d3								; bit 7

.skip
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		bne.s	.press								; if yes, branch

		; check
		btst	#4,subtype(a0)							; $10?
		bne.s	.draw
		bclr	d3,(a3)								; set as unpressed
		bra.s	.draw
; ---------------------------------------------------------------------------

.press
		tst.b	(a3)
		bne.s	.set
		sfx	sfx_Switch

.set
		bset	d3,(a3)								; set as pressed
		move.b	#1,mapping_frame(a0)

.draw
		jmp	(Sprite_OnScreen_Test).w

; ---------------------------------------------------------------------------
; Check pushable block (MZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

But_MZBlock:
		move.w	(Push_block_addr).w,d0
		beq.s	.fail								; if zero, branch

		; load pushable block address
		movea.w	d0,a1
		lea	.data(pc),a2
		jmp	(Check_InTheirRange).w
; ---------------------------------------------------------------------------

.data
		dc.w -32, 64	; xpos	; xpos (32x32)
		dc.w -24, 48	; ypos	; ypos (24x24)
; ---------------------------------------------------------------------------

.fail
		rts

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Button:		subObjMainData Obj_Button.main, setBit(render_flags.level), 0, 24, 32, 4, $47C, 0, 0, Map_Button
; ---------------------------------------------------------------------------

		include "Objects/Main/Button/Object Data/Map - Button.asm"
