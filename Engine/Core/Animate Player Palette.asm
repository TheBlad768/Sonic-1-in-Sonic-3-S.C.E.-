; ---------------------------------------------------------------------------
; Super/Hyper palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SuperHyper_PalCycle:
		move.b	(Super_palette_status).w,d0								; 0 = off | 1 = fading | -1 = fading done
		beq.s	.return											; return, if player isn't super
		bmi.w	SuperHyper_PalCycle_Normal								; branch, if fade-in is done
		subq.b	#1,d0
		bne.s	SuperHyper_PalCycle_Revert								; branch for values greater than 1

		; fade from Sonic's to Super Sonic's palette
		; run frame timer
		subq.b	#1,(Palette_timer).w
		bpl.s	.return
		addq.b	#1+1,(Palette_timer).w

		; Tails and Knuckles only
		; only Sonic has a fade-in; Tails and Knuckles just *pop* into their normal Super/Hyper palette cycle
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w
		blo.s	SuperHyper_PalCycle_FadeIn

		; set
		st	(Super_palette_status).w								; -1 = fading done

		; clear
		moveq	#0,d0
		move.w	d0,(Palette_frame).w									; used by Knuckles and Tails' Super Flickies
		move.b	d0,(Palette_frame_Tails).w								; used by Tails
		move.b	d0,(Player_1+object_control).w								; restore Player's movement

.return
		rts
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_FadeIn:

		; increment palette frame and update Sonic's palette
		lea	(PalCycle_SuperSonic).l,a0
		move.w	(Palette_frame).w,d0
		addq.w	#3*2,(Palette_frame).w									; 1 palette entry = 1 word, Sonic uses 3 shades of blue
		cmpi.w	#((PalCycle_SuperSonic_end-PalCycle_SuperSonic)-(12*2)),(Palette_frame).w		; has palette cycle reached the 6th frame?
		blo.s	SuperHyper_PalCycle_SonicApply								; if not, branch
		st	(Super_palette_status).w								; mark fade-in as done
		clr.b	(Player_1+object_control).w								; restore Sonic's movement

SuperHyper_PalCycle_SonicApply:
		lea	(Normal_palette+$04).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),(a1)										; write last palette entry

		; check water
		tst.b	(Water_flag).w
		beq.s	SuperHyper_PalCycle_ApplyUnderwater.return
		lea	(PalCycle_SuperSonicUnderwaterLZ).l,a0							; load alternate underwater fade-in palette

SuperHyper_PalCycle_ApplyUnderwater:
		lea	(Water_palette+$04).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),(a1)										; write last palette entry

.return
		rts
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_Revert:											; runs the fade in transition backwards
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w							; if Tails or Knuckles, branch, making this code Sonic-specific
		bhs.s	SuperHyper_PalCycle_RevertNotSonic

		; run frame timer
		subq.b	#1,(Palette_timer).w
		bpl.s	SuperHyper_PalCycle_ApplyUnderwater.return
		addq.b	#3+1,(Palette_timer).w

		; decrement palette frame and update Sonic's palette
		lea	(PalCycle_SuperSonic).l,a0
		move.w	(Palette_frame).w,d0
		subq.w	#3*2,(Palette_frame).w									; previous frame
		bhs.s	.skip											; branch, if it isn't the first frame

		; fade-ins to pull color values from PalCycle_SuperTails
		moveq	#0,d1
		move.w	d1,(Palette_frame).w
		move.b	d1,(Super_palette_status).w								; 0 = off

.skip
		bra.s	SuperHyper_PalCycle_SonicApply
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_RevertNotSonic:

		; clear
		moveq	#0,d0
		move.w	d0,(Palette_frame).w
		move.b	d0,(Super_palette_status).w								; 0 = off
		move.b	d0,(Palette_frame_Tails).w
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w							; if Knuckles, branch, making this code Tails-specific
		bhs.s	SuperHyper_PalCycle_RevertKnuckles

		; load
		lea	(PalCycle_SuperTails).l,a0								; used here because the first set of colours is Tails' normal palette
		bsr.w	SuperHyper_PalCycle_ApplyTails
		lea	(PalCycle_SuperSonic).l,a0								; why does Tails manipulate Sonic's palette? For his Super-form's Super Flickies
		bra.w	SuperHyper_PalCycle_Apply
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_RevertKnuckles:
		lea	(PalCycle_SuperHyperKnucklesRevert).l,a0
		bra.w	SuperHyper_PalCycle_Apply
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_Normal:
		cmpi.w	#PlayerModeID_Tails,(Player_mode).w							; if Tails...
		beq.s	SuperHyper_PalCycle_NormalTails
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w							; ...or Knuckles, branch, making this code Sonic-specific
		bhs.w	SuperHyper_PalCycle_NormalKnuckles
		tst.b	(Super_Sonic_Knux_flag).w								; if Hyper Sonic, branch
		bmi.s	SuperHyper_PalCycle_HyperSonic

SuperHyper_PalCycle_SuperSonic:

		; Tails' code falls back here so the Super Flickies' palette can update
		; run frame timer
		subq.b	#1,(Palette_timer).w
		bpl.s	SuperHyper_PalCycle_HyperSonicApply.return
		addq.b	#6+1,(Palette_timer).w

		; increment palette frame and update Sonic's palette
		lea	(PalCycle_SuperSonic).l,a0
		move.w	(Palette_frame).w,d0
		addq.w	#3*2,(Palette_frame).w									; next frame
		cmpi.w	#((PalCycle_SuperSonic_end-PalCycle_SuperSonic)-(3*2)),(Palette_frame).w		; is it the last frame?
		bls.s	.skip											; if not, branch
		move.w	#((PalCycle_SuperSonic_end-PalCycle_SuperSonic)-(12*2)),(Palette_frame).w		; reset frame counter (Super Sonic's normal palette cycle starts at $24. Everything before that is for the palette fade)

.skip
		bra.w	SuperHyper_PalCycle_SonicApply
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_HyperSonic:

		; run frame timer
		subq.b	#1,(Palette_timer).w
		bpl.s	SuperHyper_PalCycle_HyperSonicApply.return
		addq.b	#4+1,(Palette_timer).w

		; increment palette frame and update Sonic's palette
		lea	(PalCycle_HyperSonic).l,a0
		move.w	(Palette_frame).w,d0
		addq.w	#3*2,(Palette_frame).w									; next frame
		cmpi.w	#(PalCycle_HyperSonic_end-PalCycle_HyperSonic),(Palette_frame).w			; is it the last frame?
		blo.s	SuperHyper_PalCycle_HyperSonicApply							; if not, branch
		clr.w	(Palette_frame).w									; reset frame counter

SuperHyper_PalCycle_HyperSonicApply:

		; redundant. SuperHyper_PalCycle_Apply does the exact same thing
		; and other areas of code do branch to it instead of duplicating the code as seen here
		lea	(Normal_palette+4).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),(a1)										; write last palette entry

		; check water
		tst.b	(Water_flag).w
		beq.s	.return
		lea	(Water_palette+4).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),(a1)										; write last palette entry

.return
		rts
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_NormalTails:

		; run frame timer
		subq.b	#1,(Palette_timer_Tails).w
		bpl.s	SuperHyper_PalCycle_SuperSonic
		move.b	#$B,(Palette_timer_Tails).w

		; increment palette frame and update Tails' palette
		lea	(PalCycle_SuperTails).l,a0
		moveq	#0,d0
		move.b	(Palette_frame_Tails).w,d0
		addq.b	#6,(Palette_frame_Tails).w								; next frame
		cmpi.b	#(PalCycle_SuperTails_end-PalCycle_SuperTails),(Palette_frame_Tails).w			; is it the last frame?
		blo.s	SuperHyper_PalCycle_ApplyTails								; if not, branch
		clr.b	(Palette_frame_Tails).w									; reset frame counter

		; go straight to SuperHyper_PalCycle_ApplyTails...

SuperHyper_PalCycle_ApplyTails:
		; Tails gets his own because of the unique location of his palette entries
		lea	(Normal_palette+$10).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),2(a1)									; write last palette entry

		; check water
		tst.b	(Water_flag).w
		beq.w	SuperHyper_PalCycle_SuperSonic
		lea	(Water_palette+$10).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),2(a1)									; write last palette entry
		bra.w	SuperHyper_PalCycle_SuperSonic
; ---------------------------------------------------------------------------

SuperHyper_PalCycle_NormalKnuckles:

		; run frame timer
		subq.b	#1,(Palette_timer).w
		bpl.s	SuperHyper_PalCycle_Apply.return
		addq.b	#2+1,(Palette_timer).w

		; increment palette frame and update Knuckles' palette
		lea	(PalCycle_SuperHyperKnuckles).l,a0
		move.w	(Palette_frame).w,d0
		addq.w	#3*2,(Palette_frame).w									; next frame
		cmpi.w	#(PalCycle_SuperHyperKnuckles_end-PalCycle_SuperHyperKnuckles),(Palette_frame).w	; is it the last frame?
		blo.s	SuperHyper_PalCycle_Apply								; if not, branch
		clr.w	(Palette_frame).w									; reset frame counter
		move.b	#$E,(Palette_timer).w

SuperHyper_PalCycle_Apply:
		lea	(Normal_palette+4).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),(a1)										; write last palette entry

		; check water
		tst.b	(Water_flag).w
		beq.s	.return
		lea	(Water_palette+4).w,a1
		move.l	(a0,d0.w),(a1)+										; write first two palette entries
		move.w	4(a0,d0.w),(a1)										; write last palette entry

.return
		rts
