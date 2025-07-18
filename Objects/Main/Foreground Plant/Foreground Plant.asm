; ---------------------------------------------------------------------------
; Foreground Plant (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ForegroundPlant:

		; init
		move.l	#Map_ForegroundPlant,mappings(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.w	x_pos(a0),objoff_30(a0)
		move.w	y_pos(a0),objoff_32(a0)

		; get
		moveq	#$F,d0
		and.b	subtype(a0),d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0								; multiply by 6
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	.index(pc,d0.w),a1
		move.l	(a1)+,priority(a0)						; set priority and VRAM
		move.w	(a1),height_pixels(a0)						; set height and width

		; load
		move.b	subtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$3C,d0
		move.l	.load(pc,d0.w),address(a0)
		rts
; ---------------------------------------------------------------------------

.load
		dc.l sub_2C26A	; 0
		dc.l sub_2C270	; 4
		dc.l sub_2C2A6	; 8
		dc.l sub_2C2DC	; C
		dc.l sub_2C312	; 10
		dc.l sub_2C348	; 14
		dc.l sub_2C37A	; 18

.index

		; empty yet...								; 0

; =============== S U B R O U T I N E =======================================

sub_2C26A:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_2C270:
		move.w	objoff_30(a0),d1
		move.w	d1,d2
		subi.w	#320/2,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#4,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)
		move.w	objoff_32(a0),d1
		move.w	d1,d2
		subi.w	#224/2,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#4,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_30(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_2C2A6:
		move.w	objoff_30(a0),d1
		move.w	d1,d2
		subi.w	#320/2,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#3,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)
		move.w	objoff_32(a0),d1
		move.w	d1,d2
		subi.w	#224/2,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#3,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_30(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_2C2DC:
		move.w	objoff_30(a0),d1
		move.w	d1,d2
		subi.w	#320/2,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#2,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)
		move.w	objoff_32(a0),d1
		move.w	d1,d2
		subi.w	#224/2,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#2,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_30(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_2C312:
		move.w	objoff_30(a0),d1
		move.w	d1,d2
		subi.w	#320/2,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#1,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)
		move.w	objoff_32(a0),d1
		move.w	d1,d2
		subi.w	#224/2,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#1,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_30(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_2C348:
		move.w	objoff_30(a0),d1
		move.w	d1,d2
		subi.w	#320/2,d1
		sub.w	(Camera_X_pos).w,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)
		move.w	objoff_32(a0),d1
		move.w	d1,d2
		subi.w	#224/2,d1
		sub.w	(Camera_Y_pos).w,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_30(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_2C37A:
		move.w	objoff_30(a0),d1
		move.w	d1,d2
		subi.w	#320/2,d1
		sub.w	(Camera_X_pos).w,d1
		add.w	d1,d1
		add.w	d2,d1
		move.w	d1,x_pos(a0)
		move.w	objoff_32(a0),d1
		move.w	d1,d2
		subi.w	#224/2,d1
		sub.w	(Camera_Y_pos).w,d1
		add.w	d2,d1
		move.w	d1,y_pos(a0)

		; draw
		moveq	#-$80,d0							; round down to nearest $80
		and.w	objoff_30(a0),d0						; get object position
		jmp	(Sprite_OnScreen_Test2).w
; ---------------------------------------------------------------------------

		include "Objects/Main/Foreground Plant/Object Data/Map - Foreground Plant.asm"
