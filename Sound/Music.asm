; ---------------------------------------------------------------------------
; Music metadata (pointers, speed shoes tempos, flags)
; ---------------------------------------------------------------------------

MusicIndex:
; Levels
ptr_mus01:		SMPS_MUSIC_METADATA	Music01, s3TempotoS1($FF), 0
ptr_mus02:		SMPS_MUSIC_METADATA	Music02, s3TempotoS1($FF), 0
ptr_mus03:		SMPS_MUSIC_METADATA	Music03, s3TempotoS1($FF), 0
ptr_mus04:		SMPS_MUSIC_METADATA	Music04, s3TempotoS1($FF), 0
ptr_mus05:		SMPS_MUSIC_METADATA	Music05, s3TempotoS1($FF), 0
ptr_mus06:		SMPS_MUSIC_METADATA	Music06, s3TempotoS1($FF), 0

; Misc
ptr_mus07:		SMPS_MUSIC_METADATA	Music07, s3TempotoS1($FF), 0
ptr_mus08:		SMPS_MUSIC_METADATA	Music08, s3TempotoS1($FF), 0
ptr_mus09:		SMPS_MUSIC_METADATA	Music09, s3TempotoS1($FF), 0
ptr_mus0A:		SMPS_MUSIC_METADATA	Music0A, s3TempotoS1($FF), 0
ptr_mus0B:		SMPS_MUSIC_METADATA	Music0B, s3TempotoS1($FF), 0
ptr_mus0C:		SMPS_MUSIC_METADATA	Music0C, s3TempotoS1($FF), 0

; Boss
ptr_mus0D:		SMPS_MUSIC_METADATA	Music0D, s3TempotoS1($FF), 0
ptr_mus0E:		SMPS_MUSIC_METADATA	Music0E, s3TempotoS1($FF), 0
ptr_mus0F:		SMPS_MUSIC_METADATA	Music0F, s3TempotoS1($FF), 0
ptr_mus10:		SMPS_MUSIC_METADATA	Music10, s3TempotoS1($FF), 0
ptr_mus11:		SMPS_MUSIC_METADATA	Music11, s3TempotoS1($FF), 0

; Other
ptr_mus12:		SMPS_MUSIC_METADATA	Music12, s3TempotoS1($FF), 0
ptr_mus13:		SMPS_MUSIC_METADATA	Music13, s3TempotoS1($FF), 0
ptr_mus14:		SMPS_MUSIC_METADATA	Music14, s3TempotoS1($FF), 0
ptr_mus15:		SMPS_MUSIC_METADATA	Music15, s3TempotoS1($FF), 0
ptr_mus16:		SMPS_MUSIC_METADATA	Music16, s3TempotoS1($02), SMPS_MUSIC_METADATA_FORCE_PAL_SPEED
ptr_mus17:		SMPS_MUSIC_METADATA	Music17, s3TempotoS1($FF), 0

ptr_musend

; ---------------------------------------------------------------------------
; Music data ($01-$3F)
; ---------------------------------------------------------------------------

Music01:		include "Sound/Music/Mus - GHZ.asm"
	even
Music02:		include "Sound/Music/Mus - MZ.asm"
	even
Music03:		include "Sound/Music/Mus - SYZ.asm"
	even
Music04:		include "Sound/Music/Mus - LZ.asm"
	even
Music05:		include "Sound/Music/Mus - SLZ.asm"
	even
Music06:		include "Sound/Music/Mus - SBZ.asm"
	even
Music07:		include "Sound/Music/Mus - Invincibility.asm"
	even
Music08:		include "Sound/Music/Mus - Extra Life.asm"
	even
Music09:		include "Sound/Music/Mus - Special Stage.asm"
	even
Music0A:		include "Sound/Music/Mus - Title Screen.asm"
	even
Music0B:		include "Sound/Music/Mus - Menu.asm"
	even
Music0C:		include "Sound/Music/Mus - Ending.asm"
	even
Music0D:		include "Sound/Music/Mus - Boss Theme.asm"
	even
Music0E:		include "Sound/Music/Mus - FZ.asm"
	even
Music0F:		include "Sound/Music/Mus - Miniboss.asm"
	even
Music10:		include "Sound/Music/Mus - Zone Boss.asm"
	even
Music11:		include "Sound/Music/Mus - Final Boss.asm"
	even
Music12: 		include "Sound/Music/Mus - Sonic Got Through.asm"
	even
Music13:		include "Sound/Music/Mus - Game Over.asm"
	even
Music14:		include "Sound/Music/Mus - Continue Screen.asm"
	even
Music15:		include "Sound/Music/Mus - S3 Credits.asm"
	even
Music16:		include "Sound/Music/Mus - Drowning.asm"
	even
Music17:		include "Sound/Music/Mus - Get Emerald.asm"
	even
