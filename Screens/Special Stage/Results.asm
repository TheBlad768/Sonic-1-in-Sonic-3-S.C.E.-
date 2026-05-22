; ---------------------------------------------------------------------------
; Object 7E - Special Stage results screen
; ---------------------------------------------------------------------------

; dynamic object variables

	dsset animations_addr								; pretend we're in the RAM

specialstageresults.elements_count	ds.b 1						; (1 byte)
specialstageresults.exit_phase		ds.b 1						; (1 byte)

specialstageresults.destination =	parent3						; (2 bytes)

	dsreset										; stop pretending and reset the program counter

; =============== S U B R O U T I N E =======================================

Obj_SpecialStageResults:
		move.w	(SpecialStage.ring_count).w,d0
		add.w	d0,d0								; multiply by 10
		move.w	d0,d1
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,(Ring_bonus_countdown).w					; get the ring bonus
		clr.w	(Time_bonus_countdown).w
		tst.w	(SpecialStage.rings_left).w
		bne.s	.notperf
		move.w	#5000,(Time_bonus_countdown).w					; set the time bonus

.notperf
		move.w	#6*60,d0							; wait 6 seconds before starting score counting sequence
		tst.b	(Music_disable_flag).w
		beq.s	.settime
		move.w	#3*60,d0							; wait 3 seconds before starting score counting sequence

.settime
		move.w	d0,wait_timer(a0)						; set wait timer
		move.l	#.create,code_addr(a0)
		rts
; ---------------------------------------------------------------------------

.create
		tst.w	(KosPlus_modules_left).w
		bne.s	.return								; don't load the objects until the art has been loaded

		; load text
		lea	next_object(a0),a1
		lea	ObjArray_SSResults(pc),a2
		bsr.w	SpecialStageResults_Load

		; next
		move.l	#.wait,code_addr(a0)

.return
		rts
; ---------------------------------------------------------------------------

.wait
		tst.w	wait_timer(a0)							; is timer over?
		beq.s	.countdown							; if yes, branch
		subq.w	#1,wait_timer(a0)						; decrement timer

		; check timer
		tst.b	(Music_disable_flag).w
		bne.s	.return
		cmpi.w	#5*60-11,wait_timer(a0)
		bne.s	.return								; play after eh, a second or so
		music	mus_GotThrough,1						; play level complete theme
; ---------------------------------------------------------------------------

.countdown
		moveq	#0,d0
		moveq	#10,d1
		tst.w	(Time_bonus_countdown).w
		beq.s	.skiptb
		add.w	d1,d0
		sub.w	d1,(Time_bonus_countdown).w					; get 100 points from the time bonus

.skiptb
		tst.w	(Ring_bonus_countdown).w
		beq.s	.skiprb
		add.w	d1,d0
		sub.w	d1,(Ring_bonus_countdown).w					; get 100 points from the ring bonus

.skiprb

		; check buttons
		moveq	#btnABC,d1							; are buttons A, B, or C being pressed?
		and.b	(Ctrl_1_pressed).w,d1
		beq.s	.skipr								; if not, branch

		; skip countdown
		add.w	(Time_bonus_countdown).w,d0
		add.w	(Ring_bonus_countdown).w,d0
		clr.l	(Time_bonus_countdown).w					; clear time and ring bonus countdown

.skipr
		tst.w	d0
		beq.s	.finish								; branch once score has finished counting down
		jsr	(HUD_AddToScore).w						; add to actual score

		; play sfx
		moveq	#3,d0
		and.w	(Level_frame_counter).w,d0
		bne.s	.return2
		sfx	sfx_Switch,1							; every four frames play the score countdown sound
; ---------------------------------------------------------------------------

.finish
		sfx	sfx_Register							; play the cash register sound
		move.w	#2*60,wait_timer(a0)						; set wait amount
		move.l	#.wait2,code_addr(a0)

.wait2
		cmpi.w	#50,(SpecialStage.ring_count).w
		blo.s	.setend								; skip perfect

		; next
		tst.w	wait_timer(a0)							; is timer over?
		beq.s	.continue							; if yes, branch
		subq.w	#1,wait_timer(a0)						; decrement timer

.return2
		rts
; ---------------------------------------------------------------------------

.continue

		; create continue player icon
		jsr	(Create_New_Object_3).w
		bne.s	.setend
		move.l	#Obj_2EBE8,code_addr(a1)

		; set wait
		move.w	#(4*60)+30,wait_timer(a0)					; set wait
		sfx	sfx_Continue							; play extra continue sound

.setend
		move.l	#.endtimer,code_addr(a0)

.endtimer
		tst.w	wait_timer(a0)							; is timer over?
		beq.s	.checksuper							; if yes, branch
		subq.w	#1,wait_timer(a0)						; decrement timer
		rts
; ---------------------------------------------------------------------------

.checksuper

	if SonKnuxTransform
		cmpi.b	#7,(Chaos_emerald_count).w
		blo.s	.endr
	else
		bra.s	.endr
	endif

		; move text to the right
		move.l	#Obj_2EC1E,d0
		move.l	d0,(Dynamic_object_RAM+(object_size*44)+code_addr).w
		move.l	d0,(Dynamic_object_RAM+(object_size*45)+code_addr).w
		move.l	d0,(Dynamic_object_RAM+(object_size*46)+code_addr).w
		move.l	d0,(Dynamic_object_RAM+(object_size*47)+code_addr).w
		move.l	d0,(Dynamic_object_RAM+(object_size*48)+code_addr).w

		; set wait
		moveq	#4,d0
		move.w	d0,(Dynamic_object_RAM+(object_size*46)+wait_timer).w
		move.w	d0,(Dynamic_object_RAM+(object_size*48)+wait_timer).w

		; set
		move.b	#5,specialstageresults.elements_count(a0)			; number of objects
		move.l	#.waitsuper,code_addr(a0)

.return3
		rts
; ---------------------------------------------------------------------------

.endr
		move.b	#GameModeID_LevelScreen,(Game_mode).w				; set screen mode to Level
		addq.w	#4*2,sp								; exit from object and current screen
		rts
; ---------------------------------------------------------------------------

.waitsuper
		tst.b	specialstageresults.elements_count(a0)				; wait until the last object has been deleted
		bne.s	.return3

		; create Super/Hyper text
		lea	(Dynamic_object_RAM+(object_size*44)).w,a1
		lea	ObjArray_SSResults2(pc),a2
		bsr.s	SpecialStageResults_Load

		; wait
		move.w	#4*60,wait_timer(a0)						; set wait
		move.l	#.endtimer2,code_addr(a0)

.endtimer2
		tst.w	wait_timer(a0)							; is timer over?
		beq.s	.endr								; if yes, branch
		subq.w	#1,wait_timer(a0)						; decrement timer
		rts

; =============== S U B R O U T I N E =======================================

SpecialStageResults_Load:
		move.w	(a2)+,d1							; make objects

.loop
		move.l	(a2)+,code_addr(a1)
		move.w	(a2)+,specialstageresults.destination(a1)
		move.w	(a2)+,x_pos(a1)
		move.w	(a2)+,y_pos(a1)
		move.b	(a2)+,mapping_frame(a1)
		move.b	(a2)+,width_pixels(a1)
		move.b	#setBit(render_flags.multi_sprite),render_flags(a1)
		move.l	#Map_Results,mappings_addr(a1)
		move.w	#make_art_tile($500,0,FALSE),art_tile(a1)
		move.w	a0,parent2(a1)
		lea	next_object(a1),a1
		dbf	d1,.loop
		rts

; =============== S U B R O U T I N E =======================================

Obj_2EA10:
		bsr.w	sub_2EC80
		add.w	d0,x_pos(a0)
		add.w	d0,specialstageresults.destination(a0)
		bra.s	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EA1E:
		bra.s	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EA3E:
		bsr.w	sub_2EC80
		sub.w	d0,x_pos(a0)
		sub.w	d0,specialstageresults.destination(a0)

loc_2EA4A:
		move.l	#loc_2EA50,code_addr(a0)

loc_2EA50:
		jsr	(LevelResults_MoveElement).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_2EA5A:
		jsr	(LevelResults_MoveElement).l
		move.w	(Ring_bonus_countdown).w,d0
		bra.s	loc_2EA6C

; =============== S U B R O U T I N E =======================================

Obj_2EA64:
		jsr	(LevelResults_MoveElement).l
		move.w	(Time_bonus_countdown).w,d0

loc_2EA6C:
		jsr	(LevelResults_DisplayScore).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_2EA7C:
		cmpi.w	#50,(SpecialStage.ring_count).w
		blo.w	loc_2EC7A
		bra.s	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EAA6:
		lea	(Collected_emeralds_array).w,a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0						; width is used as chaos emerald id
		cmpi.b	#1,(a1,d0.w)							; was the chaos emerald collected?
		bne.w	loc_2EC7A							; if not, delete

		; draw
		tst.w	(SpecialStage.emerald_flicker_flag).w
		beq.s	.return
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.return
		rts

; =============== S U B R O U T I N E =======================================

Obj_2EAC8:
		tst.w	(SpecialStage.spheres_left).w
		beq.w	loc_2EC7A
		bsr.w	sub_2ECBC
		bra.s	loc_2EA50

; =============== S U B R O U T I N E =======================================

Obj_2EAD8:
		tst.w	(SpecialStage.spheres_left).w
		bne.w	loc_2EC7A
		bsr.w	sub_2ECA8
		cmpi.b	#ChaosEmeralds_Count,(a1)
		blo.s	Obj_2EAF6
		subi.w	#16,x_pos(a0)
		subi.w	#16,specialstageresults.destination(a0)

; =============== S U B R O U T I N E =======================================

Obj_2EAF6:
		bsr.w	sub_2EC80
		add.w	d0,x_pos(a0)
		add.w	d0,specialstageresults.destination(a0)
		add.b	d1,mapping_frame(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EB30:
		tst.w	(SpecialStage.spheres_left).w
		bne.w	loc_2EC7A
		bsr.w	sub_2ECBC
		bsr.w	sub_2EC80
		sub.w	d0,x_pos(a0)
		sub.w	d0,specialstageresults.destination(a0)
		bsr.w	sub_2ECA8
		cmpi.b	#ChaosEmeralds_Count,(a1)
		blo.w	loc_2EA4A
		subi.w	#8*2,x_pos(a0)
		subi.w	#8*2,specialstageresults.destination(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EB64:
		tst.w	(SpecialStage.spheres_left).w
		bne.s	loc_2EC7A
		bsr.w	sub_2ECBC
		cmpi.b	#ChaosEmeralds_Count,(Chaos_emerald_count).w
		blo.w	loc_2EA4A
		subq.w	#8,x_pos(a0)
		subq.w	#8,specialstageresults.destination(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EBA4:
		tst.w	(SpecialStage.spheres_left).w
		bne.s	loc_2EC7A
		bsr.w	sub_2ECBC
		bsr.w	sub_2ECA8
		cmpi.b	#ChaosEmeralds_Count,(a1)
		blo.s	loc_2EC7A
		bsr.s	sub_2EC80
		sub.w	d0,x_pos(a0)
		sub.w	d0,specialstageresults.destination(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EBCC:
		tst.w	(SpecialStage.spheres_left).w
		bne.s	loc_2EC7A
		bsr.s	sub_2ECBC
		bsr.s	sub_2ECA8
		cmpi.b	#ChaosEmeralds_Count,(a1)
		blo.s	loc_2EC7A
		bra.w	loc_2EA50
; ---------------------------------------------------------------------------

loc_2EC7A:
		jmp	(Delete_Current_Object).w

; =============== S U B R O U T I N E =======================================

Obj_2EBE8:										; (Continue Sonic Icon)

		; init
		move.l	#Map_Results,mappings_addr(a0)
		move.w	#make_art_tile($500,0,FALSE),art_tile(a0)
		move.w	#$17C,x_pos(a0)
		move.w	#$14C,y_pos(a0)
		move.l	#.draw,code_addr(a0)
		move.w	(Player_mode).w,d0						; get current character "mode"
		move.b	.framearray(pc,d0.w),mapping_frame(a0)

.draw
		btst	#3,(Level_frame_counter.byte).w
		beq.s	.return
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.framearray	dc.b $29, $29, $2A, $2B, $2B
	even
; ---------------------------------------------------------------------------

.return
		rts

; =============== S U B R O U T I N E =======================================

sub_2EC80:

		; set Sonic
		moveq	#0,d0								; xpos
		moveq	#0,d1								; Sonic
		cmpi.w	#PlayerModeID_Sonic,(Player_mode).w				; is Sonic?
		bls.s	.return								; if yes, branch

		; set Knuckles
		moveq	#-24,d0								; xpos
		moveq	#3,d1								; Knuckles
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w				; is Knuckles?
		bhs.s	.return								; if yes, branch

		; check Miles/Tails
		moveq	#0,d0								; xpos
		moveq	#1,d1								; Miles
		tst.b	(Graphics_flags).w						; check console region
		bpl.s	.return
		moveq	#4,d0								; xpos
		moveq	#2,d1								; Tails

.return
		rts

; =============== S U B R O U T I N E =======================================

sub_2ECA8:
		lea	(Chaos_emerald_count).w,a1
		rts

; =============== S U B R O U T I N E =======================================

sub_2ECBC:
		ori.w	#palette_line_3,art_tile(a0)
		rts

; =============== S U B R O U T I N E =======================================

Obj_2EC1E:

		; wait
		tst.w	wait_timer(a0)							; is timer over?
		beq.s	.check_delete							; if yes, branch
		subq.w	#1,wait_timer(a0)						; decrement timer
		bra.s	.draw
; ---------------------------------------------------------------------------

.check_delete
		tst.b	render_flags(a0)						; object visible on the screen?
		bmi.s	.move_out_xpos							; if yes, branch

		; delete
		movea.w	parent2(a0),a1							; a1=parent object
		subq.b	#1,specialstageresults.elements_count(a1)			; if offscreen, subtract from number of elements and delete
		jmp	(Delete_Current_Object).w
; ---------------------------------------------------------------------------

.move_out_xpos
		addi.w	#32,x_pos(a0)							; move out

.draw
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

	if ChaosEmeralds_Count=7

ObjArray_SSResults: specialresultsheader
	specialresultsobjdata	Obj_2EA1E, 160, 1120, 128, $17, 192			; 1
	specialresultsobjdata	Obj_2EA1E, 64, 1088, 152, $18, 176			; 2
	specialresultsobjdata	Obj_2EA5A, 248, 1272, 152, 1, 128			; 3
	specialresultsobjdata	Obj_2EA1E, 64, 1152, 168, $19, 128			; 4
	specialresultsobjdata	Obj_2EA64, 248, 1336, 168, 1, 128			; 5
	specialresultsobjdata	Obj_2EA7C, 64, 1216, 184, $1A, 144			; 6
	specialresultsobjdata	Obj_2EAA6, 160, 160, 80, $1B, 0				; 7 (Chaos Emerald 4)
	specialresultsobjdata	Obj_2EAA6, 144, 144, 104, $1C, 2			; 8 (Chaos Emerald 3)
	specialresultsobjdata	Obj_2EAA6, 176, 176, 104, $1D, 4			; 9 (Chaos Emerald 5)
	specialresultsobjdata	Obj_2EAA6, 128, 128, 80, $1E, 6				; 10 (Chaos Emerald 2)
	specialresultsobjdata	Obj_2EAA6, 192, 192, 80, $1F, 8				; 11 (Chaos Emerald 6)
	specialresultsobjdata	Obj_2EAA6, 112, 112, 104, $20, 10			; 12 (Chaos Emerald 1)
	specialresultsobjdata	Obj_2EAA6, 208, 208, 104, $21, 12			; 13 (Chaos Emerald 7)
	specialresultsobjdata	Obj_2EAC8, 160, 992, 32, $22, 192			; 14
	specialresultsobjdata	Obj_2EAD8, 84, 788, 24, $13, 144			; 15
	specialresultsobjdata	Obj_2EB30, 164, 868, 24, $23, 144			; 16
	specialresultsobjdata	Obj_2EB64, 160, 992, 48, $24, 200			; 17
	specialresultsobjdata	Obj_2EBA4, 148, 852, 24, $25, 64			; 18
	specialresultsobjdata	Obj_2EBCC, 152, 984, 48, $26, 32			; 19
	specialresultsend								; end marker

	elseif ChaosEmeralds_Count=6

ObjArray_SSResults: specialresultsheader
	specialresultsobjdata	Obj_2EA1E, 160, 1120, 128, $17, 192			; 1
	specialresultsobjdata	Obj_2EA1E, 64, 1088, 152, $18, 176			; 2
	specialresultsobjdata	Obj_2EA5A, 248, 1272, 152, 1, 128			; 3
	specialresultsobjdata	Obj_2EA1E, 64, 1152, 168, $19, 128			; 4
	specialresultsobjdata	Obj_2EA64, 248, 1336, 168, 1, 128			; 5
	specialresultsobjdata	Obj_2EA7C, 64, 1216, 184, $1A, 144			; 6
	specialresultsobjdata	Obj_2EAA6, 170, 170, 96, $1B, 0				; 7 (Chaos Emerald 4)
	specialresultsobjdata	Obj_2EAA6, 150, 150, 96, $1C, 2				; 8 (Chaos Emerald 3)
	specialresultsobjdata	Obj_2EAA6, 190, 190, 96, $1D, 4				; 9 (Chaos Emerald 5)
	specialresultsobjdata	Obj_2EAA6, 130, 130, 96, $1E, 6				; 10 (Chaos Emerald 2)
	specialresultsobjdata	Obj_2EAA6, 210, 210, 96, $1F, 8				; 11 (Chaos Emerald 6)
	specialresultsobjdata	Obj_2EAA6, 110, 110, 96, $20, 10			; 12 (Chaos Emerald 1)
	specialresultsobjdata	Obj_2EAA6, 230, 230, 96, $21, 12			; 13 (Chaos Emerald 7)
	specialresultsobjdata	Obj_2EAC8, 160, 992, 32, $22, 192			; 14
	specialresultsobjdata	Obj_2EAD8, 84, 788, 24, $13, 144			; 15
	specialresultsobjdata	Obj_2EB30, 164, 868, 24, $23, 144			; 16
	specialresultsobjdata	Obj_2EB64, 160, 992, 48, $24, 200			; 17
	specialresultsobjdata	Obj_2EBA4, 148, 852, 24, $25, 64			; 18
	specialresultsobjdata	Obj_2EBCC, 152, 984, 48, $26, 32			; 19
	specialresultsend								; end marker

	else
		fatal "Warning! You need to set the location for the chaos emeralds!"
	endif

ObjArray_SSResults2: specialresultsheader
	specialresultsobjdata	Obj_2EA10, 64, 832, 24, $27, 112			; 1
	specialresultsobjdata	Obj_2EAF6, 128, 896, 24, $13, 144			; 2
	specialresultsobjdata	Obj_2EA3E, 208, 976, 24, $3A, 96			; 3
	specialresultsobjdata	Obj_2EA10, 64, 960, 48, $28, 64				; 4
	specialresultsobjdata	Obj_2EA10, 104, 1000, 48, $12, 160			; 5 (SUPER/HYPER)
	specialresultsobjdata	Obj_2EAF6, 184, 1080, 48, $13, 144			; 6
	specialresultsend								; end marker
