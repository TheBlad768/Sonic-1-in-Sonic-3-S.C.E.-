; ---------------------------------------------------------------------------
; Object 53 - collapsing floors (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

; Dynamic object variables
cflo_timepointer			= objoff_30	; .l
cflo_timedelay				= objoff_38	; .b
cflo_collapse_flag			= objoff_3A	; .b

; =============== S U B R O U T I N E =======================================

Obj_CollapseFloor:

		; init
		move.l	#CFlo_Data2,d0
		btst	#0,subtype(a0)
		beq.s	.set
		move.l	#CFlo_Data3,d0

.set
		move.l	d0,objoff_30(a0)
		move.l	#Map_CFlo,mappings(a0)
		move.w	#make_art_tile($562,2,0),d0
		cmpi.b	#LevelID_SLZ,(Current_zone).w					; is level Star Light Zone?
		bne.s	.notSLZ								; if not, branch
		move.w	#make_art_tile($41C,2,0),d0
		addq.b	#2,mapping_frame(a0)

.notSLZ
		cmpi.b	#LevelID_SBZ,(Current_zone).w					; is level Scrap Brain Zone?
		bne.s	.notSBZ								; if not, branch
		move.w	#make_art_tile($2AA,2,0),d0

.notSBZ
		move.w	d0,art_tile(a0)
		ori.b	#setBit(render_flags.level),render_flags(a0)			; use screen coordinates
		move.l	#bytes_word_to_long(48/2,64/2,priority_4),height_pixels(a0)	; set height, width and priority
		move.b	#7,cflo_timedelay(a0)
		ori.b	#$80,status(a0)
		move.l	#.check,address(a0)

.check
		tst.b	cflo_collapse_flag(a0)						; has Sonic touched the	object?
		beq.s	.stand								; if not, branch
		tst.b	cflo_timedelay(a0)						; has time delay reached zero?
		beq.s	.collapse							; if yes, branch
		subq.b	#1,cflo_timedelay(a0)						; subtract 1 from time

.stand
		moveq	#standing_mask,d0
		and.b	status(a0),d0							; is Sonic or Tails standing on the object?
		beq.s	.solid								; if not, branch
		st	cflo_collapse_flag(a0)						; set object as	"touched"

.solid
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#(16/2)+1,d3							; height+1
		move.w	x_pos(a0),d4
		jsr	(SolidObjectTop).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.collapse
		move.l	#CollapseFloor_PlayerRelease,address(a0)
		move.l	#Obj_PlatformCollapseWait,d4
		addq.b	#1,mapping_frame(a0)
		bra.w	ObjPlatformCollapse_CreateFragments2

; =============== S U B R O U T I N E =======================================

CollapseFloor_PlayerRelease:
		bsr.s	Obj_CollapseFloor.solid

		; check wait
		tst.b	cflo_timedelay(a0)
		beq.s	.return
		subq.b	#1,cflo_timedelay(a0)
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
		bclr	#status.player.on_object,status(a1)
		bclr	#status.player.pushing,status(a1)
		bset	#status.player.in_air,status(a1)

		; set anim
		tst.b	spin_dash_flag(a1)
		bne.s	.return
		cmpi.b	#AniIDSonAni_Roll,anim(a1)					; is player in his rolling animation?
		beq.s	.return								; if so, branch
		move.b	#AniIDSonAni_Hurt,anim(a1)					; set falling animation

.return
		rts

; ---------------------------------------------------------------------------
; Disintegration data for collapsing ledges (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CFlo_Data1:	; timer
		dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18, $14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C, 0
CFlo_Data2:	; timer
		dc.b $1E, $16, $E, 6, $1A, $12, $A, 2
CFlo_Data3:	; timer
		dc.b $16, $1E, $1A, $12, 6, $E, $A, 2
	even
; ---------------------------------------------------------------------------

		include "Objects/Environ/Collapsing Floor/Object Data/Map - Collapsing Floor.asm"
