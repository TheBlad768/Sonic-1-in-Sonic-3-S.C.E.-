; ---------------------------------------------------------------------------
; Object 6E - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations								; pretend we're in the RAM

electrocuter.freq			ds.w 1						; frequency (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_Electrocuter:

		; set freq
		move.w	subtype(a0),d0							; read object type
		lsl.w	#4,d0								; multiply by $10
		subq.w	#1,d0
		move.w	d0,electrocuter.freq(a0)

		; init
		lea	ObjDat_Electrocuter(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.lightning_shield,shield_reaction(a0)
		move.l	#.shock,code_addr(a0)

.shock
		move.w	(Level_frame_counter).w,d0
		and.w	electrocuter.freq(a0),d0					; is it time to zap?
		bne.s	.animate							; if not, branch
		move.b	#1,anim(a0)							; run "zap" animation
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.animate							; if not, branch
		sfx	sfx_Electric							; play electricity sound

.animate
		lea	Ani_Electrocuter(pc),a1
		jsr	(Animate_SpriteNoSST).w

		; check
		cmpi.b	#4,mapping_frame(a0)						; is 4th frame displayed?
		beq.s	.col								; if yes, branch

.display
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.col
		jmp	(Sprite_OnScreen_Test_Collision).w

; =============== S U B R O U T I N E =======================================

; init
ObjDat_Electrocuter:		subObjData Map_Electrocuter, $529, 0, FALSE, 32, 80, 1, 0, collision_type.npc.hurt, 16, 144
; ---------------------------------------------------------------------------

		; mappings
		include "Objects/Environ/Electrocuter/Object Data/Anim - Electrocuter.asm"
		include "Objects/Environ/Electrocuter/Object Data/Map - Electrocuter.asm"
