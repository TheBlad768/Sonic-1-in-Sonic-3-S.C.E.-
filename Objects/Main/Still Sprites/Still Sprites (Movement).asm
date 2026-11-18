; ---------------------------------------------------------------------------
; Object XX - movement scenery
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

movementstillsprite.origX		ds.w 1						; original x-axis position (2 bytes)
movementstillsprite.origY		ds.w 1						; original y-axis position (2 bytes)
movementstillsprite.speedX		ds.w 1						; (2 bytes)
movementstillsprite.speedY		ds.w 1						; (2 bytes)
movementstillsprite.draw_pointer	ds.w 1						; save address (4 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_MovementStillSprite:

		; init
		move.l	#Map_MovementStillSprite,mappings_addr(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.w	x_pos(a0),movementstillsprite.origX(a0)
		move.w	y_pos(a0),movementstillsprite.origY(a0)

		; get
		move.w	subtype(a0),d0
		move.b	d0,mapping_frame(a0)						; set mapping frame
		move.w	d0,d1								; multiply by 14
		add.w	d1,d1
		add.w	d1,d0
		add.w	d1,d0
		add.w	d1,d0
		add.w	d0,d0
		lea	.index(pc,d0.w),a1
		move.l	(a1)+,priority(a0)						; set priority and VRAM
		move.w	(a1)+,height_pixels(a0)						; set height and width
		move.l	(a1)+,movementstillsprite.speedX(a0)				; set speedXY

		; check collision type
		lea	(Sprite_OnScreen_Test2).w,a2					; normal draw
		move.w	(a1)+,d0							; get collision type
		beq.s	.set								; if it doesn't have collision, branch
		move.b	d0,collision_type(a0)						; set collision type
		move.w	(a1),collision_height(a0)					; set collision height and width
		lea	(Sprite_OnScreen_Test2_Collision).w,a2				; collision draw

.set
		move.l	a2,movementstillsprite.draw_pointer(a0)

		; draw
		lea	MovementStillSprite_Move(pc),a1
		move.l	a1,code_addr(a0)
		jmp	(a1)
; ---------------------------------------------------------------------------

.index

		; object priority, VRAM, palette, priority, height, width, speedx, speedy, collision type, collision height, collision width

		; empty yet...								; 0

; ---------------------------------------------------------------------------
; Still Sprite movement
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MovementStillSprite_Move:

		; xpos
		move.w	movementstillsprite.origX(a0),d1
		move.w	d1,d2
		subi.w	#screen_width/2,d1
		sub.w	(Camera_X_pos).w,d1
		muls.w	movementstillsprite.speedX(a0),d1
		asr.l	#8,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)

		; ypos
		move.w	movementstillsprite.origY(a0),d1
		move.w	d1,d2
		subi.w	#screen_height/2,d1
		sub.w	(Camera_Y_pos).w,d1
		muls.w	movementstillsprite.speedY(a0),d1
		asr.l	#8,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	movementstillsprite.origX(a0),d0				; get object position
		movea.l	movementstillsprite.draw_pointer(a0),a1
		jmp	(a1)
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Main/Still Sprites/Object Data/Map - Still Sprites (Movement).asm"
