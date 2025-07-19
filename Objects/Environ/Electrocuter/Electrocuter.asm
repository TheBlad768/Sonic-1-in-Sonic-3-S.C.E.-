; ---------------------------------------------------------------------------
; Object 6E - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
elec_freq			= objoff_2E	; frequency

; =============== S U B R O U T I N E =======================================

Obj_Electro:

		; set freq
		moveq	#0,d0
		move.b	subtype(a0),d0							; read object type
		lsl.w	#4,d0								; multiply by $10
		subq.w	#1,d0
		move.w	d0,elec_freq(a0)

		; init
		lea	ObjDat_Electro(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#shield_reaction.lightning_shield,shield_reaction(a0)
		move.l	#.shock,address(a0)

.shock
		move.w	(Level_frame_counter).w,d0
		and.w	elec_freq(a0),d0						; is it time to zap?
		bne.s	.animate							; if not, branch
		move.b	#1,anim(a0)							; run "zap" animation
		tst.b	render_flags(a0)						; object visible on the screen?
		bpl.s	.animate							; if not, branch
		sfx	sfx_Electric							; play electricity sound

.animate
		lea	Ani_Elec(pc),a1
		jsr	(Animate_Sprite).w
		cmpi.b	#4,mapping_frame(a0)						; is 4th frame displayed?
		beq.s	.col								; if yes, branch

.display
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.col
		jmp	(Sprite_OnScreen_Test_Collision).w

; =============== S U B R O U T I N E =======================================

; mapping
ObjDat_Electro:		subObjData Map_Elec, $529, 0, 0, 32, 80, 1, 0, $24|collision_flags.npc.hurt
; ---------------------------------------------------------------------------

		include "Objects/Environ/Electrocuter/Object Data/Anim - Electrocuter.asm"
		include "Objects/Environ/Electrocuter/Object Data/Map - Electrocuter.asm"
