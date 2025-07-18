; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge
; ---------------------------------------------------------------------------

; Dynamic object variables
cplat_timepointer			= objoff_30	; .l
cplat_timedelay				= objoff_38	; .b
cplat_collapse_flag			= objoff_3A	; .b

; =============== S U B R O U T I N E =======================================

Obj_CollapsingPlatform:

		; init
		move.l	#Map_CollapsingPlatform,mappings(a0)
		move.w	#make_art_tile(0,2,0),art_tile(a0)
		move.l	#CFlo_Data1,objoff_30(a0)
		move.l	#CPlat_Data,objoff_3C(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(112/2,200/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.b	#7,cplat_timedelay(a0)
		move.b	subtype(a0),mapping_frame(a0)
		ori.b	#$80,status(a0)
		move.l	#.check,address(a0)

.check
		tst.b	cplat_collapse_flag(a0)						; has Sonic touched the	object?
		beq.s	.stand								; if not, branch
		tst.b	cplat_timedelay(a0)						; has time delay reached zero?
		beq.w	ObjPlatformCollapse_CreateFragments				; if yes, branch
		subq.b	#1,cplat_timedelay(a0)						; subtract 1 from time

.stand
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		beq.s	.solid								; if not, branch
		st	cplat_collapse_flag(a0)						; set object as	"touched"

.solid
		moveq	#96/2,d1
		movea.l	objoff_3C(a0),a2						; CPlat_Data
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTopSloped2).w
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

CollapsingPlatform_PlayerRelease:
		bsr.s	Obj_CollapsingPlatform.solid

		; check wait
		tst.b	cplat_timedelay(a0)
		beq.s	.return
		subq.b	#1,cplat_timedelay(a0)
		bne.s	.return

		; start fall
		move.l	#Obj_PlatformCollapseFall,address(a0)
		lea	(Player_1).w,a1							; a1=character
		moveq	#p1_standing_bit,d6
		bsr.s	.check
		lea	(Player_2).w,a1							; a1=character
		addq.b	#1,d6

.check
		btst	d6,status(a0)
		beq.s	.return
		bclr	d6,status(a0)
		move.b	#1,prev_anim(a1)
		move.b	#PlayerID_Control,routine(a1)
		bclr	#status.player.on_object,status(a1)
		bclr	#status.player.pushing,status(a1)
		bset	#status.player.in_air,status(a1)
		bne.s	.return								; if the player is already in the air, branch

		; set anim
		tst.b	spin_dash_flag(a1)
		bne.s	.return
		cmpi.b	#AniIDSonAni_Roll,anim(a1)					; is player in his rolling animation?
		beq.s	.return								; if so, branch
		move.b	#AniIDSonAni_Hurt,anim(a1)					; set falling animation

.return
		rts

; =============== S U B R O U T I N E =======================================

ObjPlatformCollapse_CreateFragments:
		move.l	#CollapsingPlatform_PlayerRelease,address(a0)
		move.l	#Obj_PlatformCollapseWait,d4
		addq.b	#2,mapping_frame(a0)

ObjPlatformCollapse_CreateFragments2:
		movea.l	objoff_30(a0),a4

ObjPlatformCollapse_SmashObject:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		move.w	(a3)+,d1
		subq.w	#1,d1
		bset	#render_flags.static_mappings,render_flags(a0)			; set flag to "static mappings flag"
		move.b	render_flags(a0),d5						; get render type
		movea.w	a0,a1								; load current object to a1

		; get RAM slot
		getobjectRAMslot a2
		bra.s	.load
; ---------------------------------------------------------------------------

.create

		; create break pieces object

.find
		lea	next_object(a1),a1						; goto next object RAM slot
		tst.l	address(a1)							; is object RAM slot empty?
		dbeq	d0,.find							; if not, branch
		bne.s	.notfree							; branch, if object RAM slot is not empty
		subq.w	#1,d0								; dbeq didn't subtract sprite table so we'll do it ourselves
		addq.w	#6,a3								; add to mappings

		; load object
		move.l	d4,address(a1)
		move.b	d5,render_flags(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	priority(a0),priority(a1)
		move.w	height_pixels(a0),height_pixels(a1)				; set height and width

.load
		move.l	a3,mappings(a1)
		move.b	(a4)+,cplat_timedelay(a1)
		tst.w	d0								; object RAM slots ended?
		dbmi	d1,.create							; if not, loop

.notfree
		pea	(Draw_Sprite).w

		; function when object isnt spawned by layout (plays sound anyway)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.playsfx							; if it's zero, it isn't remembered
		movea.w	d0,a1								; load address into a1
		bclr	#7,(a1)
		clr.w	respawn_addr(a0)

.playsfx
		sfx	sfx_Collapse,1

; =============== S U B R O U T I N E =======================================

Obj_PlatformCollapseWait:
		subq.b	#1,cplat_timedelay(a0)
		bne.s	.draw
		move.l	#Obj_PlatformCollapseFall,address(a0)

.draw
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_PlatformCollapseFall:
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.delete								; if not, branch

		MoveSpriteYOnly a0							; make obj fall

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

CPlat_Data:		binclude "Objects/Environ/Collapsing Platform/Object Data/Heightmap.bin"
	even
; ---------------------------------------------------------------------------

		include "Objects/Environ/Collapsing Platform/Object Data/Map - Collapsing Platform.asm"
