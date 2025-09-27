; ---------------------------------------------------------------------------
; Object 69 - spinning platforms and trapdoors (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
spin_timer			= objoff_30	; time counter until change (2 bytes)
spin_timelen			= objoff_32	; time between changes (general) (2 bytes)
spin_flag			= objoff_34	; (1 byte)
spin_counter			= objoff_36	; (2 bytes)

; =============== S U B R O U T I N E =======================================

Obj_SpinPlatform:

		; check
		tst.b	subtype(a0)							; is subtype $8x? (Spinner)
		bmi.s	.alt								; if yes, branch

		; set time
		moveq	#$F,d0
		and.b	subtype(a0),d0
		add.w	d0,d0								; multiply by 60 (1 second)
		add.w	d0,d0
		move.w	d0,d1
		lsl.w	#4,d0
		sub.w	d1,d0
		move.w	d0,spin_timelen(a0)

		; init
		lea	ObjDat_Trapdoor(pc),a1
		jsr	(SetUp_ObjAttributes).w

		; next
		move.l	#.trapdoor,address(a0)
		bra.s	.trapdoor
; ---------------------------------------------------------------------------

.alt

		; set time
		move.b	subtype(a0),d0							; get object type
		move.b	d0,d1
		andi.w	#$F,d0								; read only the 2nd digit
		add.w	d0,d0								; multiply by 6
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		move.w	d0,spin_timer(a0)
		move.w	d0,spin_timelen(a0)						; set time delay
		andi.w	#$70,d1
		addi.w	#$10,d1
		add.w	d1,d1
		add.w	d1,d1
		subq.w	#1,d1
		move.w	d1,spin_counter(a0)

		; init
		lea	ObjDat_Spinner(pc),a1
		jsr	(SetUp_ObjAttributes).w

		; next
		move.l	#.spinner,address(a0)
		bra.s	.spinner

; =============== S U B R O U T I N E =======================================

.trapdoor

		; wait
		subq.w	#1,spin_timer(a0)						; decrement timer
		bpl.s	.tanimate							; if time remains, branch
		move.w	spin_timelen(a0),spin_timer(a0)
		bchg	#0,anim(a0)							; open/close door
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.tanimate							; if not, branch
		sfx	sfx_Door							; play door sound

.tanimate
		lea	Ani_Trap(pc),a1
		jsr	(Animate_Sprite).w

		; draw
		pea	(Sprite_OnScreen_Test).w

		; check frame
		tst.b	mapping_frame(a0)						; is frame number 0 displayed?
		bne.s	.tnotsolid							; if not, branch

		; solid
		moveq	#(128/2)+$B,d1							; width
		moveq	#24/2,d2							; height
		move.w	d2,d3
		addq.w	#1,d3								; height+1
		move.w	x_pos(a0),d4
		jmp	(SolidObjectFull).w
; ---------------------------------------------------------------------------

.tnotsolid
		jmp	(Displace_PlayerOffObject).w					; release player from object

; =============== S U B R O U T I N E =======================================

.spinner
		move.w	(Level_frame_counter).w,d0
		and.w	spin_counter(a0),d0
		bne.s	.delay
		st	spin_flag(a0)

.delay
		tst.b	spin_flag(a0)
		beq.s	.sanimate

		; wait
		subq.w	#1,spin_timer(a0)
		bpl.s	.sanimate
		move.w	spin_timelen(a0),spin_timer(a0)
		clr.b	spin_flag(a0)
		move.b	#1,prev_anim(a0)						; reset animation

.sanimate
		lea	Ani_Spin(pc),a1
		jsr	(Animate_Sprite).w

		; draw
		pea	(Sprite_OnScreen_Test).w

		; check frame
		tst.b	mapping_frame(a0)						; check if frame number 0 is displayed
		bne.s	.snotsolid							; if not, branch

		; solid
		moveq	#(32/2)+$B,d1							; width
		moveq	#14/2,d2							; height
		move.w	d2,d3
		addq.w	#1,d3								; height+1
		move.w	x_pos(a0),d4
		jmp	(SolidObjectFull).w
; ---------------------------------------------------------------------------

.snotsolid
		jmp	(Displace_PlayerOffObject).w					; release player from object

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Trapdoor:	subObjData Map_Trap, $43F8, 2, FALSE, 128, 128, 1, 0, 0
ObjDat_Spinner:		subObjData Map_Spin, $3C8, 0, FALSE, 14, 32, 1, 0, 0
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Spinning Platforms/Object Data/Anim - Spinning Platforms.asm"
		include "Objects/Environ/Spinning Platforms/Object Data/Anim - Trapdoor.asm"
		include "Objects/Environ/Spinning Platforms/Object Data/Map - Spinning Platforms.asm"
		include "Objects/Environ/Spinning Platforms/Object Data/Map - Trapdoor.asm"
