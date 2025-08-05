; ---------------------------------------------------------------------------
; Object 7E - Special Stage results screen
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_SpecialStage_Results:
		move.w	(Special_stage_ring_count).w,d0
		add.w	d0,d0								; multiply by 10
		move.w	d0,d1
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,(Ring_bonus_countdown).w					; get the ring bonus
		clr.w	(Time_bonus_countdown).w
		tst.w	(Special_stage_rings_left).w
		bne.s	.notperf
		move.w	#5000,(Time_bonus_countdown).w					; set the time bonus

.notperf
		move.w	#6*60,d0							; wait 6 seconds before starting score counting sequence
		tst.b	(Music_disable_flag).w
		beq.s	.settime
		move.w	#3*60,d0							; wait 3 seconds before starting score counting sequence

.settime
		move.w	d0,objoff_2E(a0)
		move.l	#.create,address(a0)
		rts
; ---------------------------------------------------------------------------

.create
		tst.w	(KosPlus_modules_left).w
		bne.s	.return								; don't load the objects until the art has been loaded

		; load text
		lea	next_object(a0),a1
		lea	ObjArray_SSResults(pc),a2
		bsr.w	SpecialStage_Results_Load

		; next
		move.l	#.wait,address(a0)

.return
		rts
; ---------------------------------------------------------------------------

.wait
		tst.w	objoff_2E(a0)
		beq.s	.countdown
		subq.w	#1,objoff_2E(a0)

		; check timer
		tst.b	(Music_disable_flag).w
		bne.s	.return
		cmpi.w	#5*60-11,objoff_2E(a0)
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
		moveq	#3,d0
		and.w	(Level_frame_counter).w,d0
		bne.s	.return2
		sfx	sfx_Switch,1							; every four frames play the score countdown sound
; ---------------------------------------------------------------------------

.finish
		sfx	sfx_Register							; play the cash register sound
		move.w	#2*60,objoff_2E(a0)						; set wait amount
		move.l	#.wait2,address(a0)

.wait2
		cmpi.w	#50,(Special_stage_ring_count).w
		blo.s	.setend								; skip perfect

		; next
		tst.w	objoff_2E(a0)
		beq.s	.continue
		subq.w	#1,objoff_2E(a0)

.return2
		rts
; ---------------------------------------------------------------------------

.continue

		; create continue player icon
		jsr	(Create_New_Sprite3).w
		bne.s	.setend
		move.l	#Obj_2EBE8,address(a1)

		; set wait
		move.w	#4*60+30,objoff_2E(a0)						; set wait
		sfx	sfx_Continue							; play extra continue sound

.setend
		move.l	#.endtimer,address(a0)

.endtimer
		tst.w	objoff_2E(a0)
		beq.s	.checksuper
		subq.w	#1,objoff_2E(a0)
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
		move.l	d0,(Dynamic_object_RAM+(object_size*44)+address).w
		move.l	d0,(Dynamic_object_RAM+(object_size*45)+address).w
		move.l	d0,(Dynamic_object_RAM+(object_size*46)+address).w
		move.l	d0,(Dynamic_object_RAM+(object_size*47)+address).w
		move.l	d0,(Dynamic_object_RAM+(object_size*48)+address).w

		; set wait
		moveq	#4,d0
		move.w	d0,(Dynamic_object_RAM+(object_size*46)+objoff_2E).w
		move.w	d0,(Dynamic_object_RAM+(object_size*48)+objoff_2E).w

		; set
		move.w	#5,objoff_30(a0)						; number of objects
		move.l	#.waitsuper,address(a0)

.return3
		rts
; ---------------------------------------------------------------------------

.endr
		move.b	#GameModeID_LevelScreen,(Game_mode).w				; set screen mode to Level
		addq.w	#4*2,sp								; exit from object and current screen
		rts
; ---------------------------------------------------------------------------

.waitsuper
		tst.w	objoff_30(a0)							; wait until the last object has been deleted
		bne.s	.return3

		; create Super/Hyper text
		lea	(Dynamic_object_RAM+(object_size*44)).w,a1
		lea	ObjArray_SSResults2(pc),a2
		bsr.s	SpecialStage_Results_Load

		; wait
		move.w	#4*60,objoff_2E(a0)						; set wait
		move.l	#.endtimer2,address(a0)

.endtimer2
		tst.w	objoff_2E(a0)
		beq.s	.endr
		subq.w	#1,objoff_2E(a0)
		rts

; =============== S U B R O U T I N E =======================================

SpecialStage_Results_Load:
		move.w	(a2)+,d1							; make objects

.loop
		move.l	(a2)+,address(a1)
		move.w	(a2)+,objoff_46(a1)
		move.w	(a2)+,x_pos(a1)
		move.w	(a2)+,y_pos(a1)
		move.b	(a2)+,mapping_frame(a1)
		move.b	(a2)+,width_pixels(a1)
		move.b	#setBit(render_flags.multi_sprite),render_flags(a1)
		move.l	#Map_Results,mappings(a1)
		move.w	#make_art_tile($500,0,0),art_tile(a1)
		move.w	a0,parent2(a1)
		lea	next_object(a1),a1
		dbf	d1,.loop
		rts

; =============== S U B R O U T I N E =======================================

Obj_2EA10:
		bsr.w	sub_2EC80
		add.w	d0,x_pos(a0)
		add.w	d0,objoff_46(a0)
		bra.s	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EA1E:
		bra.s	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EA3E:
		bsr.w	sub_2EC80
		sub.w	d0,x_pos(a0)
		sub.w	d0,objoff_46(a0)

loc_2EA4A:
		move.l	#loc_2EA50,address(a0)

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
		jsr	(LevResults_DisplayScore).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_2EA7C:
		cmpi.w	#50,(Special_stage_ring_count).w
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
		tst.w	(Emerald_flicker_flag).w
		beq.s	.return
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.return
		rts

; =============== S U B R O U T I N E =======================================

Obj_2EAC8:
		tst.w	(Special_stage_spheres_left).w
		beq.w	loc_2EC7A
		bsr.w	sub_2ECBC
		bra.s	loc_2EA50

; =============== S U B R O U T I N E =======================================

Obj_2EAD8:
		tst.w	(Special_stage_spheres_left).w
		bne.w	loc_2EC7A
		bsr.w	sub_2ECA8
		cmpi.b	#ChaosEmer_Count,(a1)
		blo.s	Obj_2EAF6
		subi.w	#16,x_pos(a0)
		subi.w	#16,objoff_46(a0)

; =============== S U B R O U T I N E =======================================

Obj_2EAF6:
		bsr.w	sub_2EC80
		add.w	d0,x_pos(a0)
		add.w	d0,objoff_46(a0)
		add.b	d1,mapping_frame(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EB30:
		tst.w	(Special_stage_spheres_left).w
		bne.w	loc_2EC7A
		bsr.w	sub_2ECBC
		bsr.w	sub_2EC80
		sub.w	d0,x_pos(a0)
		sub.w	d0,objoff_46(a0)
		bsr.w	sub_2ECA8
		cmpi.b	#ChaosEmer_Count,(a1)
		blo.w	loc_2EA4A
		subi.w	#16,x_pos(a0)
		subi.w	#16,objoff_46(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EB64:
		tst.w	(Special_stage_spheres_left).w
		bne.s	loc_2EC7A
		bsr.w	sub_2ECBC
		cmpi.b	#ChaosEmer_Count,(Chaos_emerald_count).w
		blo.w	loc_2EA4A
		subq.w	#8,x_pos(a0)
		subq.w	#8,objoff_46(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EBA4:
		tst.w	(Special_stage_spheres_left).w
		bne.s	loc_2EC7A
		bsr.w	sub_2ECBC
		bsr.w	sub_2ECA8
		cmpi.b	#ChaosEmer_Count,(a1)
		blo.s	loc_2EC7A
		bsr.s	sub_2EC80
		sub.w	d0,x_pos(a0)
		sub.w	d0,objoff_46(a0)
		bra.w	loc_2EA4A

; =============== S U B R O U T I N E =======================================

Obj_2EBCC:
		tst.w	(Special_stage_spheres_left).w
		bne.s	loc_2EC7A
		bsr.s	sub_2ECBC
		bsr.s	sub_2ECA8
		cmpi.b	#ChaosEmer_Count,(a1)
		blo.s	loc_2EC7A
		bra.w	loc_2EA50
; ---------------------------------------------------------------------------

loc_2EC7A:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_2EBE8:										; (Continue Sonic Icon)

		; init
		move.l	#Map_Results,mappings(a0)
		move.w	#make_art_tile($500,0,0),art_tile(a0)
		move.w	#$17C,x_pos(a0)
		move.w	#$14C,y_pos(a0)
		move.l	#.draw,address(a0)
		move.w	(Player_mode).w,d0						; get current character "mode"
		move.b	.framearray(pc,d0.w),mapping_frame(a0)

.draw
		btst	#3,(Level_frame_counter+1).w
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
		moveq	#0,d0								; xpos
		moveq	#0,d1								; Sonic
		cmpi.w	#PlayerModeID_Sonic,(Player_mode).w
		bls.s	.return
		moveq	#-24,d0								; xpos
		moveq	#3,d1								; Knuckles
		cmpi.w	#PlayerModeID_Knuckles,(Player_mode).w
		bhs.s	.return
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
		tst.w	objoff_2E(a0)
		beq.s	loc_2EC2A
		subq.w	#1,objoff_2E(a0)
		bra.s	loc_2EC44
; ---------------------------------------------------------------------------

loc_2EC2A:
		tst.b	render_flags(a0)						; object visible on the screen?
		bmi.s	loc_2EC3E							; if yes, branch
		movea.w	parent2(a0),a1							; a1=parent object
		subq.w	#1,objoff_30(a1)						; if offscreen, subtract from number of elements and delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

loc_2EC3E:
		addi.w	#32,x_pos(a0)							; move out

loc_2EC44:
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

	if ChaosEmer_Count=7

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
ObjArray_SSResults_end

	elseif ChaosEmer_Count=6

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
ObjArray_SSResults_end

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
ObjArray_SSResults2_end
