; ---------------------------------------------------------------------------
; Object 33 - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------

; Fixes
_PUSHB_XPOS_			= $200	; add pixels

; Dynamic object variables
pushb_origXvel			= objoff_30	; (2 bytes)
pushb_floatflag			= objoff_32	; (1 byte)
pushb_sound			= objoff_33	; (1 byte)
pushb_origX			= objoff_34	; original x-axis position (2 bytes)
pushb_origY			= objoff_36	; original y-axis position (2 bytes)
pushb_p1			= objoff_3A	; (1 byte)
pushb_p2			= objoff_3B	; (1 byte)
pushb_jump			= objoff_3C	; (4 bytes)

; =============== S U B R O U T I N E =======================================

PushableBlock_Var:

		; object width, frame number
		dc.b 32/2, 0
		dc.b 128/2, 1
; ---------------------------------------------------------------------------

Obj_PushableBlock:

		; init
		move.l	#Map_Push,mappings(a0)
		move.w	#make_art_tile($562,2,0),d0					; MZ specific code
		cmpi.b	#LevelID_LZ,(Current_zone).w					; check if level is LZ
		bne.s	.notLZ								; if not, branch
		move.w	#make_art_tile($3DE,2,0),d0					; LZ specific code

.notLZ
		move.w	d0,art_tile(a0)
		move.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(32/2,32/2,priority_3),height_pixels(a0)	; set height, width and priority
		move.w	#bytes_to_word(30/2,32/2),y_radius(a0)				; set y_radius and x_radius
		move.w	x_pos(a0),pushb_origX(a0)
		move.w	y_pos(a0),pushb_origY(a0)
		move.l	#PushableBlock_MovePush,pushb_jump(a0)
		move.l	#.action,address(a0)

		; set
		move.b	subtype(a0),d0
		add.w	d0,d0
		andi.w	#$E,d0
		lea	PushableBlock_Var(pc,d0.w),a2
		move.b	(a2),x_radius(a0)
		move.b	(a2)+,width_pixels(a0)
		move.b	(a2),mapping_frame(a0)
		tst.b	subtype(a0)
		beq.s	.chkgone
		move.w	#make_art_tile($562,2,1),art_tile(a0)

.chkgone
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.action								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bset	#0,(a2)
		bne.w	.delete2
		move.w	a0,(Push_block_addr).w						; save push block address

.action
		tst.b	pushb_floatflag(a0)
		bne.w	PushableBlock_Floating

		; normal push
		move.w	x_pos(a0),-(sp)
		movea.l	pushb_jump(a0),a1
		jsr	(a1)
		move.b	(Player_1+status).w,pushb_p1(a0)
		move.b	(Player_2+status).w,pushb_p2(a0)
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#32/2,d2							; height
		moveq	#(32/2)+1,d3							; height+1
		move.w	(sp)+,d4
		jsr	(SolidObjectFull).w

		; check act
		cmpi.w	#bytes_to_word(LevelID_MZ,0),(Current_zone_and_act).w		; is the level MZ act 1?
		bne.s	.draw								; if not, branch

		; clr bit
		moveq	#7,d1								; 7 bit
		bclr	d1,subtype(a0)							; clr $80

		; check xpos (chain stomper range)
		move.w	x_pos(a0),d0
		cmpi.w	#$A1F+_PUSHB_XPOS_,d0
		blo.s	.draw
		cmpi.w	#$AA1+_PUSHB_XPOS_,d0
		bhs.s	.draw

		; set bit
		bset	d1,subtype(a0)							; set $80 for block

		; set ypos
		moveq	#-28,d0
		add.w	(Chain_stomp_addr).w,d0						; get chain stomper ypos
		move.w	d0,y_pos(a0)							; set block ypos
		bset	d1,(Chain_stomp_addr).w						; set $80 for chain stomper

.draw
		out_of_xrange.s	.check
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.check
		out_of_xrange.s	.offscreen, pushb_origX(a0)
		move.w	pushb_origX(a0),x_pos(a0)
		move.w	pushb_origY(a0),y_pos(a0)
		move.l	#.restore,address(a0)
		bra.s	.restore
; ---------------------------------------------------------------------------

.offscreen
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.delete								; if it's zero, it isn't remembered
		movea.w	d0,a2								; load address into a2
		bclr	#0,(a2)
		clr.w	(Push_block_addr).w						; clear push block address

.delete2
		bclr	#7,(a2)

.delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.restore
		jsr	(Chk_WidthOffScreen).w						; object visible on the screen?
		beq.s	.return								; if yes, branch
		move.l	#.action,address(a0)
		clr.b	pushb_floatflag(a0)
		clr.l	x_vel(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Block floating on lava
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PushableBlock_Floating:									; floating block on lava
		move.w	x_pos(a0),-(sp)
		cmpi.l	#PushableBlock_EdgeFix,pushb_jump(a0)
		beq.s	.smove
		cmpi.l	#PushableBlock_Fall,pushb_jump(a0)
		beq.s	.smove
		jsr	(MoveSprite2).w

.smove
		btst	#status.npc.y_flip,status(a0)					; geyser flag set?
		beq.s	.checkxvel							; if not, branch

		; geyser move
		addi.w	#$18,y_vel(a0)

		; check floor
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	.push
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		bclr	#status.npc.y_flip,status(a0)					; clr geyser flag

		; check lava
		move.w	(a1),d0								; get id of the 16x16 block
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0							; block has touched the lava?
		blo.s	.push								; if not, branch
		move.w	pushb_origXvel(a0),d0
		asr.w	#3,d0
		move.w	d0,x_vel(a0)
		st	pushb_floatflag(a0)
		clr.w	y_pos+2(a0)
		bra.s	.push
; ---------------------------------------------------------------------------

.checkxvel
		tst.w	x_vel(a0)							; check x velocity
		beq.s	.sinking							; stop move
		bmi.s	.leftm								; left move

		; right move
		move.b	x_radius(a0),d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1								; has block touched a wall?
		bmi.s	.stoppushr							; if yes, branch
		bra.s	.push
; ---------------------------------------------------------------------------

.stoppushr
		add.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop block moving (right)
		bra.s	.push
; ---------------------------------------------------------------------------

.leftm
		move.b	x_radius(a0),d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1								; has block touched a wall?
		bmi.s	.stoppushl							; if yes, branch
		bra.s	.push
; ---------------------------------------------------------------------------

.stoppushl
		sub.w	d1,x_pos(a0)
		clr.w	x_vel(a0)							; stop block moving (left)
		bra.s	.push
; ---------------------------------------------------------------------------

.sinking
		addi.l	#$2001,y_pos(a0)
		cmpi.b	#$C0,y_pos+3(a0)						; block is sinking in lava ; $A0 - original
		bhs.s	.clearf

.push

		; normal push
		movea.l	pushb_jump(a0),a1
		jsr	(a1)
		move.b	(Player_1+status).w,pushb_p1(a0)
		move.b	(Player_2+status).w,pushb_p2(a0)
		moveq	#$B,d1
		add.b	width_pixels(a0),d1
		moveq	#32/2,d2							; height
		moveq	#(32/2)+1,d3							; height+1
		move.w	(sp)+,d4
		jsr	(SolidObjectFull).w
		bsr.s	PushableBlock_ChkLava
		bra.w	Obj_PushableBlock.draw
; ---------------------------------------------------------------------------

.clearf
		move.w	(sp)+,d4
		jsr	(Displace_PlayerOffObject).w					; release Sonic from object
		bra.w	Obj_PushableBlock.check

; ---------------------------------------------------------------------------
; Create geysers
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PushableBlock_ChkLava:

		; check act
		cmpi.w	#bytes_to_word(LevelID_MZ,1),(Current_zone_and_act).w		; is the level MZ act 2?
		bne.s	.notact2							; if not, branch

		; start
		moveq	#-32,d2								; sub xpos

		; check xpos
		cmpi.w	#$DD0+_PUSHB_XPOS_,x_pos(a0)
		beq.s	.createlava
		cmpi.w	#$CC0+_PUSHB_XPOS_,x_pos(a0)
		beq.s	.createlava
		cmpi.w	#$BA0+_PUSHB_XPOS_,x_pos(a0)
		beq.s	.createlava
		rts
; ---------------------------------------------------------------------------

.notact2

		; check act
		cmpi.w	#bytes_to_word(LevelID_MZ,2),(Current_zone_and_act).w		; is the level MZ act 3?
		bne.s	.return								; if not, branch

		; start
		moveq	#32,d2								; add xpos

		; check xpos
		cmpi.w	#$560+_PUSHB_XPOS_,x_pos(a0)
		beq.s	.createlava
		cmpi.w	#$5C0+_PUSHB_XPOS_,x_pos(a0)
		bne.s	.return

.createlava
		jsr	(Create_New_Sprite3).w
		bne.s	.return
		move.l	#Obj_GeyserMaker,address(a1)					; load lava geyser object
		move.w	a0,parent3(a1)							; save block address for geyser
		move.w	x_pos(a0),d0
		add.w	d2,d0
		move.w	d0,x_pos(a1)
		moveq	#16,d0
		add.w	y_pos(a0),d0
		move.w	d0,y_pos(a1)

.return
		rts

; ---------------------------------------------------------------------------
; Edge fix
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PushableBlock_EdgeFix:									; fix fall block
		jsr	(MoveSprite2).w
		moveq	#$C,d0
		and.w	x_pos(a0),d0
		bne.s	PushableBlock_ChkLava.return
		andi.w	#-$10,x_pos(a0)							; align xpos (16 pixels)
		move.w	x_vel(a0),pushb_origXvel(a0)
		clr.w	x_vel(a0)

		; next
		move.l	#PushableBlock_Fall,pushb_jump(a0)

		; fix player pos
		jmp	(Displace_PlayerOffObject).w					; release player from object

; ---------------------------------------------------------------------------
; Block fall
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PushableBlock_Fall:
		moveq	#$18,d1
		jsr	(MoveSprite_CustomGravity).w

		; check floor
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	PushableBlock_ChkLava.return
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)

		; next
		move.l	#PushableBlock_MovePush,pushb_jump(a0)

		; check lava
		move.w	(a1),d0								; get id of the 16x16 block
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0							; block has touched the lava?
		blo.s	.cpush								; if not, branch
		move.w	pushb_origXvel(a0),d0
		asr.w	#3,d0
		move.w	d0,x_vel(a0)
		st	pushb_floatflag(a0)
		clr.w	y_pos+2(a0)

.cpush
		jmp	(Release_PlayerFromObject).w					; release player from object

; ---------------------------------------------------------------------------
; Block push move
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

PushableBlock_MovePush:									; push block normal
		tst.b	pushb_floatflag(a0)
		bne.s	PushableBlock_ChkLava.return

		; check solid
		moveq	#0,d5								; push flag (cleared)

		; check push
		moveq	#pushing_mask,d3						; p1_pushing + p2_pushing
		and.b	status(a0),d3
		beq.s	PushableBlock_ChkLava.return

		; Sonic/Knux
		lea	(Player_1).w,a1							; a1=character
		move.b	pushb_p1(a0),d0							; p1 status
		moveq	#p1_pushing_bit,d6						; 5
		bsr.s	.main

		; check push flag
		tst.w	d5
		bne.s	.return

		; Tails
		lea	(Player_2).w,a1							; a1=character
		tst.l	address(a1)							; is player RAM empty?
		beq.s	.return								; if yes, branch
		move.b	pushb_p2(a0),d0							; p2 status
		moveq	#p2_pushing_bit,d6						; 6

.main
		btst	d6,d3								; check status
		beq.s	.return

		move.w	x_pos(a0),d2
		cmp.w	x_pos(a1),d2
		bhs.s	.mright								; right move

		; left move
		btst	#status.player.pushing,d0					; player is pushing the block?
		beq.s	.return								; if not, branch
		btst	#status.player.x_flip,d0					; player is looking at the block?
		beq.s	.return								; if not, branch

		; wait
		subq.b	#1,pushb_sound(a0)
		bpl.s	.endl
		move.b	#4,pushb_sound(a0)
		sfx	sfx_PushBlock							; play sfx

		; move block and player
		subq.w	#1,x_pos(a0)							; left move for block
		subq.w	#1,x_pos(a1)							; left move for player

		; check wall
		move.b	x_radius(a0),d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	.pushl
		sub.w	d1,x_pos(a0)							; stop move

.pushl

		; check press button block
		tst.b	subtype(a0)							; is that a special block for the button?
		bmi.s	.endl								; if yes, branch

		; check floor
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#4,d1								; did the block cross the edge of the floor?
		ble.s	.notedgel							; if not, branch

		; next
		move.l	#PushableBlock_EdgeFix,pushb_jump(a0)
		move.w	#-$400,x_vel(a0)

.endl
		moveq	#1,d5								; set push flag

.return
		rts
; ---------------------------------------------------------------------------

.notedgel
		add.w	d1,y_pos(a0)
		moveq	#1,d5								; set push flag
		rts
; ---------------------------------------------------------------------------

.mright

		; right move
		btst	#status.player.pushing,d0					; player is pushing the block?
		beq.s	.return								; if not, branch
		btst	#status.player.x_flip,d0					; player is looking at the block?
		bne.s	.return								; if not, branch

		; wait
		subq.b	#1,pushb_sound(a0)
		bpl.s	.endr
		move.b	#4,pushb_sound(a0)
		sfx	sfx_PushBlock							; play sfx

		; move block and player
		addq.w	#1,x_pos(a0)							; right move for block
		addq.w	#1,x_pos(a1)							; right move for player

		; check wall
		move.b	x_radius(a0),d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.pushr
		add.w	d1,x_pos(a0)							; stop move

.pushr

		; check press button block
		tst.b	subtype(a0)							; is that a special block for the button?
		bmi.s	.endr								; if yes, branch

		; check floor
		jsr	(ObjCheckFloorDist).w
		cmpi.w	#4,d1								; did the block cross the edge of the floor?
		ble.s	.notedger							; if not, branch

		; next
		move.l	#PushableBlock_EdgeFix,pushb_jump(a0)
		move.w	#$400,x_vel(a0)

.endr
		moveq	#1,d5								; set push flag
		rts
; ---------------------------------------------------------------------------

.notedger
		add.w	d1,y_pos(a0)
		moveq	#1,d5								; set push flag
		rts
; ---------------------------------------------------------------------------

		include "Objects/Environ/Pushable Blocks/Object Data/Map - Pushable Blocks.asm"
