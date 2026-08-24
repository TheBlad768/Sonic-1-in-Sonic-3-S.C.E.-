; ===========================================================================
; ║                                                                         ║
; ║                             SONIC&K SOUND DRIVER                        ║
; ║                         Modified SMPS Z80 Type 2 DAC                    ║
; ║                                                                         ║
; ===========================================================================
; Disassembled by MarkeyJester
; Routines, pointers and stuff by Linncaki
; Thoroughly commented and improved (including optional bugfixes) by Flamewing
; ===========================================================================
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
; ===========================================================================
; Music Banks
; ===========================================================================
; Music Bank 1
; ---------------------------------------------------------------------------
Mus_Bank1_Start:	startBank
	Music_Master_Table
z80_UniVoiceBank:	include "Sound/UniBank.asm"
MusData_GHZ:			include "Sound/Music/Mus - GHZ.asm"
MusData_MZ:			include "Sound/Music/Mus - MZ.asm"
MusData_SYZ:			include "Sound/Music/Mus - SYZ.asm"
MusData_LZ:				include "Sound/Music/Mus - LZ.asm"
MusData_SLZ:			include "Sound/Music/Mus - SLZ.asm"
MusData_SBZ:			include "Sound/Music/Mus - SBZ.asm"
MusData_Invincible:			include "Sound/Music/Mus - Invincibility.asm"
MusData_ExtraLife:		include "Sound/Music/Mus - Extra Life.asm"
MusData_SpecialStage:	include "Sound/Music/Mus - Special Stage.asm"
MusData_Title:			include "Sound/Music/Mus - Title Screen.asm"
MusData_Menu:			include "Sound/Music/Mus - Menu.asm"
MusData_Ending:			include "Sound/Music/Mus - Ending.asm"
MusData_S1Boss:			include "Sound/Music/Mus - Boss Theme.asm"
MusData_FZ:				include "Sound/Music/Mus - FZ.asm"
MusData_MidBoss:			include "Sound/Music/Mus - Miniboss.asm"
MusData_ZoneBoss:			include "Sound/Music/Mus - Zone Boss.asm"
MusData_FinalBoss:		include "Sound/Music/Mus - Final Boss.asm"
MusData_GotThrough:		include "Sound/Music/Mus - Sonic Got Through.asm"
MusData_GameOver:		include "Sound/Music/Mus - Game Over.asm"
MusData_Continue:		include "Sound/Music/Mus - Continue Screen.asm"
MusData_S3Credits:		include "Sound/Music/Mus - S3 Credits.asm"
MusData_Drowning:		include "Sound/Music/Mus - Drowning.asm"
MusData_Emerald:		include "Sound/Music/Mus - Get Emerald.asm"

	finishBank
; ---------------------------------------------------------------------------
