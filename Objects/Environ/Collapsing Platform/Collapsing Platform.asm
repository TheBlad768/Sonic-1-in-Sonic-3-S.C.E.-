; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

collapsingplatform.time_ptr		ds.l 1						; collapsing floor time (4 bytes)
collapsingplatform.delay		ds.b 1						; (1 byte)
collapsingplatform.flag			ds.b 1						; (1 byte)
collapsingplatform.slope_ptr		ds.l 1						; solid object slope pointer (4 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_CollapsingPlatform:

		; init
		move.l	#Map_CollapsingPlatform,mappings(a0)
		move.w	#make_art_tile(0,2,FALSE),art_tile(a0)
		move.l	#CollapseFloor_Data1,collapsingplatform.time_ptr(a0)
		move.l	#CollapsingPlatform_Data,collapsingplatform.slope_ptr(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(112/2,96/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.b	#7,collapsingplatform.delay(a0)
		move.b	subtype.byte(a0),mapping_frame(a0)
		ori.b	#$80,status(a0)
		move.l	#.check,code_addr(a0)

.check
		tst.b	collapsingplatform.flag(a0)					; has Sonic touched the	object?
		beq.s	.stand								; if not, branch
		tst.b	collapsingplatform.delay(a0)					; has time delay reached zero?
		beq.w	ObjPlatformCollapse_CreateFragments				; if yes, branch
		subq.b	#1,collapsingplatform.delay(a0)					; subtract 1 from time

.stand
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		beq.s	.solid								; if not, branch
		st	collapsingplatform.flag(a0)					; set object as	"touched"

.solid
		moveq	#96/2,d1
		movea.l	collapsingplatform.slope_ptr(a0),a2
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTopSloped2).w
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

CollapsingPlatform_PlayerRelease:
		bsr.s	Obj_CollapsingPlatform.solid

		; check wait
		tst.b	collapsingplatform.delay(a0)
		beq.s	.return
		subq.b	#1,collapsingplatform.delay(a0)
		bne.s	.return

		; start fall
		move.l	#Obj_PlatformCollapseFall,code_addr(a0)
		lea	(Player_1).w,a1							; a1=character
		moveq	#p1_standing_bit,d6
		bsr.s	.check
		lea	(Player_2).w,a1							; a1=character
		moveq	#p2_standing_bit,d6

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
		move.l	#CollapsingPlatform_PlayerRelease,code_addr(a0)
		move.l	#Obj_PlatformCollapseWait,d4
		addq.b	#2,mapping_frame(a0)

ObjPlatformCollapse_CreateFragments2:
		movea.l	collapsingplatform.time_ptr(a0),a4

ObjPlatformCollapse_SmashObject:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		move.w	(a3)+,d1
		subq.w	#1,d1								; fix dbf
		bset	#render_flags.static_mappings,render_flags(a0)			; set flag to "static mappings flag"
		move.b	render_flags(a0),d5						; get render type
		movea.w	a0,a1								; load current object to a1

		; get current RAM slot in d0
		getobjectSlot a2
		bra.s	.load
; ---------------------------------------------------------------------------

.create

		; create break pieces object
		addq.w	#6,a3								; next mappings
		move.l	d4,code_addr(a1)
		move.b	d5,render_flags(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	height_pixels(a0),height_pixels(a1)				; set height, width and priority

.load
		move.l	a3,mappings(a1)
		move.b	(a4)+,collapsingplatform.delay(a1)

		; create next object
		jsr	(Create_New_Object_4).w						; find next free object slot
		dbne	d1,.create

		; next
		pea	(Draw_Sprite).w

		; function when object isnt spawned by layout (plays sound anyway)
		move.w	respawn_addr(a0),d0						; get address in respawn table
		beq.s	.playsfx							; if it's zero, it isn't remembered
		movea.w	d0,a1								; load address into a1
		bclr	#respawn_addr.state,(a1)					; turn on the slot
		clr.w	respawn_addr(a0)						; clear the object respawn address (do not create this object again)

.playsfx
		sfx	sfx_Collapse,1

; =============== S U B R O U T I N E =======================================

Obj_PlatformCollapseWait:
		subq.b	#1,collapsingplatform.delay(a0)
		bne.s	.draw
		move.l	#Obj_PlatformCollapseFall,code_addr(a0)

.draw
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_PlatformCollapseFall:
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.delete								; if not, branch

		MoveSpriteYOnly								; make obj fall

		; draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

		; data
		incfile.ba	CollapsingPlatform_Data, "Objects/Environ/Collapsing Platform/Object Data/Heightmap.bin"
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Collapsing Platform/Object Data/Map - Collapsing Platform.asm"
