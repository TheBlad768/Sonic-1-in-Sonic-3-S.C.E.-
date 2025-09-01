; ===========================================================================
; Kosinski Plus Module compressed Renders graphics
; ===========================================================================

ArtKosPM_HUD:				binclude "Objects/Renders/HUD/KosinskiPM Art/HUD.kospm"
	even
ArtKosPM_SonicLifeIcon:			binclude "Objects/Renders/HUD/KosinskiPM Art/Sonic Life Icon.kospm"
	even
ArtKosPM_MilesLifeIcon:			binclude "Objects/Renders/HUD/KosinskiPM Art/Miles Life Icon.kospm"
	even
ArtKosPM_TailsLifeIcon:			binclude "Objects/Renders/HUD/KosinskiPM Art/Tails Life Icon.kospm"
	even
ArtKosPM_KnucklesLifeIcon:		binclude "Objects/Renders/HUD/KosinskiPM Art/Knuckles Life Icon.kospm"
	even
ArtKosPM_GameOver:			binclude "Objects/Renders/Game Over/KosinskiPM Art/Game Over.kospm"
	even
ArtKosPM_Pylon:				binclude "Objects/Renders/Pylon/KosinskiPM Art/Pylon.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Main graphics
; ===========================================================================

ArtKosPM_Ring_Sparks:			binclude "Objects/Main/Rings/KosinskiPM Art/Sparks.kospm"
	even
ArtKosPM_Monitors:			binclude "Objects/Main/Monitor/KosinskiPM Art/Monitors.kospm"
	even
ArtKosPM_MonitorsEggRobo:		binclude "Objects/Main/Monitor/KosinskiPM Art/Egg Robo.kospm"
	even
ArtKosPM_SpikesSprings:			binclude "Objects/Main/Spikes/KosinskiPM Art/SpikesSprings.kospm"
	even
ArtKosPM_HiddenBonus:			binclude "Objects/Main/Hidden Bonus/KosinskiPM Art/Hidden Bonus.kospm"
	even
ArtKosPM_BossExplosion:			binclude "Objects/Main/Explosion/KosinskiPM Art/Boss Explosion.kospm"
	even
ArtKosPM_Explosion:			binclude "Objects/Main/Explosion/KosinskiPM Art/Explosion.kospm"
	even
ArtKosPM_EnemyPtsStarPost:		binclude "Objects/Main/StarPost/KosinskiPM Art/Enemy points.kospm"
	even
ArtKosPM_GrayButton:			binclude "Objects/Main/Button/KosinskiPM Art/Gray Button.kospm"
	even
ArtKosPM_MZGrayButton:			binclude "Objects/Main/Button/KosinskiPM Art/MZ Gray Button.kospm"
	even
ArtKosPM_DiagonalSpring:		binclude "Objects/Main/Spring/KosinskiPM Art/Diagonal Spring.kospm"
	even
ArtKosPM_Bubbles:			binclude "Objects/Main/Bubbler/KosinskiPM Art/Bubbles.kospm"
	even
ArtKosPM_WaveSplash:			binclude "Objects/Main/Wave Splash/KosinskiPM Art/Wave Splash.kospm"
	even
ArtKosPM_WaveSplashLZ:			binclude "Objects/Main/Wave Splash/KosinskiPM Art/Wave Splash(LZ).kospm"
	even
ArtKosPM_EggCapsule:			binclude "Objects/Main/Egg Capsule/KosinskiPM Art/Egg Capsule.kospm"
	even
ArtKosPM_Seal:				binclude "Objects/Main/Animals/KosinskiPM Art/Seal.kospm"
	even
ArtKosPM_Pig:				binclude "Objects/Main/Animals/KosinskiPM Art/Pig.kospm"
	even
ArtKosPM_BlueFlicky:			binclude "Objects/Main/Animals/KosinskiPM Art/Blue Flicky.kospm"
	even
ArtKosPM_Chicken:			binclude "Objects/Main/Animals/KosinskiPM Art/Chicken.kospm"
	even
ArtKosPM_Penguin:			binclude "Objects/Main/Animals/KosinskiPM Art/Penguin.kospm"
	even
ArtKosPM_Squirrel:			binclude "Objects/Main/Animals/KosinskiPM Art/Squirrel.kospm"
	even
ArtKosPM_Rabbit:			binclude "Objects/Main/Animals/KosinskiPM Art/Rabbit.kospm"
	even
ArtKosPM_ResultsGeneral:		binclude "Objects/Main/Results/KosinskiPM Art/General.kospm"
	even
ArtKosPM_ResultsSONIC:			binclude "Objects/Main/Results/KosinskiPM Art/SONIC.kospm"
	even
ArtKosPM_ResultsMILES:			binclude "Objects/Main/Results/KosinskiPM Art/MILES.kospm"
	even
ArtKosPM_ResultsTAILS:			binclude "Objects/Main/Results/KosinskiPM Art/TAILS.kospm"
	even
ArtKosPM_ResultsKNUCKLES:		binclude "Objects/Main/Results/KosinskiPM Art/KNUCKLES.kospm"
	even
ArtKosPM_StarPostStars1:		binclude "Objects/Main/StarPost/KosinskiPM Art/StarPost Stars 1.kospm"
	even
ArtKosPM_StarPostStars2:		binclude "Objects/Main/StarPost/KosinskiPM Art/StarPost Stars 2.kospm"
	even
ArtKosPM_StarPostStars3:		binclude "Objects/Main/StarPost/KosinskiPM Art/StarPost Stars 3.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Title Card graphics
; ===========================================================================

ArtKosPM_TitleCardRedAct:		binclude "Objects/Main/Title Card/KosinskiPM Art/Title Card Red ACT.kospm"
	even
ArtKosPM_TitleCardNum1:			binclude "Objects/Main/Title Card/KosinskiPM Art/Title Card Number 1.kospm"
	even
ArtKosPM_TitleCardNum2:			binclude "Objects/Main/Title Card/KosinskiPM Art/Title Card Number 2.kospm"
	even
ArtKosPM_TitleCardNum3:			binclude "Objects/Main/Title Card/KosinskiPM Art/Title Card Number 3.kospm"
	even
ArtKosPM_TitleCardNum4:			binclude "Objects/Main/Title Card/KosinskiPM Art/Title Card Number 4.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Sega screen graphics
; ===========================================================================

	if SegaVersion=0
ArtKosPM_Sega:				binclude "Screens/Sega/S3K/KosinskiPM Art/Foreground.kospm"
	elseif SegaVersion=1
ArtKosPM_Sega:				binclude "Screens/Sega/S1/KosinskiPM Art/Foreground.kospm"
	else
ArtKosPM_SegaProto:			binclude "Screens/Sega/Proto/KosinskiPM Art/Foreground.kospm"
	endif
	even

; ===========================================================================
; Kosinski Plus Module compressed Title screen graphics
; ===========================================================================

ArtKosPM_TitleFG:			binclude "Screens/Title/KosinskiPM Art/Foreground.kospm"
	even
ArtKosPM_TitleCredits:			binclude "Screens/Title/KosinskiPM Art/Hidden Credits.kospm"
	even
ArtKosPM_TitleSonic:			binclude "Screens/Title/KosinskiPM Art/Sonic.kospm"
	even
ArtKosPM_TitleText:			binclude "Screens/Title/KosinskiPM Art/Text.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Options screen graphics
; ===========================================================================

ArtKosPM_OptionsBG:			binclude "Screens/Options/KosinskiPM Art/Background.kospm"
	even
ArtKosPM_OptionsText:			binclude "Screens/Options/KosinskiPM Art/Text.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Level Select screen graphics
; ===========================================================================

ArtKosPM_LevelSelectText:		binclude "Screens/Level Select/SCE/KosinskiPM Art/Text.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Level Select RSDK screen graphics
; ===========================================================================

ArtKosPM_LevelSelectRSDKBG:		binclude "Screens/Level Select/RSDK/KosinskiPM Art/Background.kospm"
	even
ArtKosPM_LevelSelectRSDKIcons:		binclude "Screens/Level Select/RSDK/KosinskiPM Art/Icon.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Level screen graphics (Environment)
; ===========================================================================

ArtKosPM_GHZBreakableWall:		binclude "Objects/Environ/Breakable Wall/KosinskiPM Art/GHZ Breakable Wall.kospm"
	even
ArtKosPM_GHZEdgeWalls:			binclude "Objects/Environ/Edge Walls/KosinskiPM Art/GHZ Edge Walls.kospm"
	even
ArtKosPM_PplRock:			binclude "Objects/Environ/Purple Rock/KosinskiPM Art/Purple Rock.kospm"
	even
ArtKosPM_SpikePole:			binclude "Objects/Environ/Spike Pole/KosinskiPM Art/Spike Pole.kospm"
	even
ArtKosPM_Bridge:			binclude "Objects/Environ/Bridge/KosinskiPM Art/Bridge.kospm"
	even
ArtKosPM_Swing:				binclude "Objects/Environ/Swinging Platform/KosinskiPM Art/GHZ Swinging Platform.kospm"
	even
ArtKosPM_Fireballs:			binclude "Objects/Environ/Lava Ball/KosinskiPM Art/Fireballs.kospm"
	even
ArtKosPM_LavaWall:			binclude "Objects/Environ/Lava Wall/KosinskiPM Art/Lava Wall.kospm"
	even
ArtKosPM_MZBlock:			binclude "Objects/Environ/Moving Blocks/KosinskiPM Art/Green Pushable Block.kospm"
	even
ArtKosPM_MZMetal:			binclude "Objects/Environ/Chained Stompers/KosinskiPM Art/Metal Blocks.kospm"
	even
ArtKosPM_MZGlass:			binclude "Objects/Environ/Glass Block/KosinskiPM Art/Glass Block.kospm"
	even
ArtKosPM_Bumper:			binclude "Objects/Environ/Bumper/KosinskiPM Art/Bumper.kospm"
	even
ArtKosPM_LargeSpikeball:		binclude "Objects/Environ/Big Spiked Ball/KosinskiPM Art/Large Spikeball.kospm"
	even
ArtKosPM_SmallSpikeball:		binclude "Objects/Environ/Spiked Ball and Chain/KosinskiPM Art/Small Spikeball.kospm"
	even
ArtKosPM_SpikedBallandChain:		binclude "Objects/Environ/Spiked Ball and Chain/KosinskiPM Art/Spiked Ball and Chain.kospm"
	even
ArtKosPM_LZBlock1:			binclude "Levels/LZ/KosinskiPM Art/LZ 32x32 Block.kospm"
	even
ArtKosPM_LZBlock2:			binclude "Levels/LZ/KosinskiPM Art/LZ Blocks.kospm"
	even
ArtKosPM_LZBlock3:			binclude "Levels/LZ/KosinskiPM Art/LZ 32x16 Block.kospm"
	even
ArtKosPM_LZDoor1:			binclude "Objects/Environ/Floating Blocks and Doors/KosinskiPM Art/LZ Vertical Door.kospm"
	even
ArtKosPM_LZDoor2:			binclude "Objects/Environ/Floating Blocks and Doors/KosinskiPM Art/LZ Horizontal Door.kospm"
	even
ArtKosPM_Cork:				binclude "Objects/Environ/Labyrinth Blocks/KosinskiPM Art/Cork.kospm"
	even
ArtKosPM_LZPlatform:			binclude "Objects/Environ/Labyrinth Blocks/KosinskiPM Art/Rising Platform.kospm"
	even
ArtKosPM_Gargoyle:			binclude "Objects/Environ/Gargoyle/KosinskiPM Art/Gargoyle and Fireball.kospm"
	even
ArtKosPM_BreakablePole:			binclude "Objects/Environ/Pole that Breaks/KosinskiPM Art/Breakable Pole.kospm"
	even
ArtKosPM_FlappingDoor:			binclude "Objects/Environ/Flapping Door/KosinskiPM Art/Flapping Door.kospm"
	even
ArtKosPM_Harpoon:			binclude "Objects/Environ/Harpoon/KosinskiPM Art/Harpoon.kospm"
	even
ArtKosPM_WaterSplashes:			binclude "Objects/Environ/Labyrinth Waterfalls/KosinskiPM Art/Water and Splashes.kospm"
	even
ArtKosPM_LabyrinthConveyor:		binclude "Objects/Environ/Labyrinth Conveyor/KosinskiPM Art/Labyrinth Conveyor.kospm"
	even
ArtKosPM_SLZBreakableWall:		binclude "Objects/Environ/Breakable Wall/KosinskiPM Art/SLZ Breakable Wall.kospm"
	even
ArtKosPM_Fan:				binclude "Objects/Environ/Fan/KosinskiPM Art/Fan.kospm"
	even
ArtKosPM_Seesaw:			binclude "Objects/Environ/Seesaw/KosinskiPM Art/Seesaw.kospm"
	even
ArtKosPM_LittleSpikeball:		binclude "Objects/Environ/Seesaw/KosinskiPM Art/Little Spikeball.kospm"
	even
ArtKosPM_SLZCannon:			binclude "Objects/Environ/Lava Ball/KosinskiPM Art/Cannon.kospm"
	even
ArtKosPM_SLZBlock:			binclude "Objects/Environ/Collapsing Floor/KosinskiPM Art/SLZ 32x32 Block.kospm"
	even
ArtKosPM_SLZSwing:			binclude "Objects/Environ/Swinging Platform/KosinskiPM Art/SLZ Swinging Platform.kospm"
	even
ArtKosPM_Electric:			binclude "Objects/Environ/Electrocuter/KosinskiPM Art/Electrocuter.kospm"
	even
ArtKosPM_FlamePipe:			binclude "Objects/Environ/Flamethrower/KosinskiPM Art/Flaming Pipe.kospm"
	even
ArtKosPM_SpinPform:			binclude "Objects/Environ/Spinning Platforms/KosinskiPM Art/Spinning Platform.kospm"
	even
ArtKosPM_TrapDoor:			binclude "Objects/Environ/Spinning Platforms/KosinskiPM Art/Trapdoor.kospm"
	even
ArtKosPM_SBZFloor:			binclude "Objects/Environ/Collapsing Floor/KosinskiPM Art/SBZ Collapsing Floor.kospm"
	even
ArtKosPM_Stomper:			binclude "Objects/Environ/Stomper and Door/KosinskiPM Art/SBZ Stomper.kospm"
	even
ArtKosPM_SlideFloor:			binclude "Objects/Environ/Stomper and Door/KosinskiPM Art/SBZ Sliding Floor Trap.kospm"
	even
ArtKosPM_Cutter:			binclude "Objects/Environ/Saws and Pizza Cutters/KosinskiPM Art/Pizza Cutter.kospm"
	even
ArtKosPM_SBZWheel1:			binclude "Objects/Environ/Running Disc/KosinskiPM Art/Running Disc.kospm"
	even
ArtKosPM_SBZWheel2:			binclude "Objects/Environ/Rotating Junction/KosinskiPM Art/Junction Wheel.kospm"
	even
ArtKosPM_Girder:			binclude "Objects/Environ/Girder Block/KosinskiPM Art/Crushing Girder.kospm"
	even
ArtKosPM_SBZBlock:			binclude "Objects/Environ/Vanishing Platforms/KosinskiPM Art/Vanishing Platforms.kospm"
	even
ArtKosPM_SBZDoor1:			binclude "Objects/Environ/Small Door/KosinskiPM Art/Small Vertical Door.kospm"
	even
ArtKosPM_SBZDoor2:			binclude "Objects/Environ/Stomper and Door/KosinskiPM Art/SBZ Large Horizontal Door.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Level screen graphics (Bosses)
; ===========================================================================

ArtKosPM_RobotnikShip1:			binclude "Objects/Bosses/Robotnik/KosinskiPM Art/Robotnik Ship 1.kospm"
	even
ArtKosPM_RobotnikShip2:			binclude "Objects/Bosses/Robotnik/KosinskiPM Art/Robotnik Ship 2.kospm"
	even
ArtKosPM_EggRoboHead:			binclude "Objects/Bosses/Robotnik/KosinskiPM Art/Egg Robo Head.kospm"
	even
ArtKosPM_RobotnikShipStand:		binclude "Objects/Bosses/Robotnik/KosinskiPM Art/Robotnik Ship Stand.kospm"
	even
ArtKosPM_BossCrane:			binclude "Objects/Bosses/GHZ3/KosinskiPM Art/Crane.kospm"
	even
ArtKosPM_BossFireTube:			binclude "Objects/Bosses/MZ3/KosinskiPM Art/Tube.kospm"
	even
ArtKosPM_SYZBlock:			binclude "Objects/Bosses/SYZ3/KosinskiPM Art/Boss Block.kospm"
	even
ArtKosPM_SYZSpike:			binclude "Objects/Bosses/SYZ3/KosinskiPM Art/Spike.kospm"
	even
ArtKosPM_BossSpikeBallTube:		binclude "Objects/Bosses/SLZ3/KosinskiPM Art/Tube.kospm"
	even
ArtKosPM_SE_ControlDesk:		binclude "Objects/Bosses/Scrap Eggman/KosinskiPM Art/Control Desk.kospm"
	even
ArtKosPM_FZBoss:			binclude "Objects/Bosses/FZ/KosinskiPM Art/Boss - Final Zone.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Level screen graphics (Enemies)
; ===========================================================================

ArtKosPM_Crabmeat:			binclude "Objects/Enemies/Crabmeat/KosinskiPM Art/Enemy Crabmeat.kospm"
	even
ArtKosPM_Chopper:			binclude "Objects/Enemies/Chopper/KosinskiPM Art/Enemy Chopper.kospm"
	even
ArtKosPM_Buzz:				binclude "Objects/Enemies/Buzz Bomber/KosinskiPM Art/Enemy Buzz Bomber.kospm"
	even
ArtKosPM_Motobug:			binclude "Objects/Enemies/Moto Bug/KosinskiPM Art/Enemy Motobug.kospm"
	even
ArtKosPM_Newtron:			binclude "Objects/Enemies/Newtron/KosinskiPM Art/Enemy Newtron.kospm"
	even
ArtKosPM_Basaran:			binclude "Objects/Enemies/Basaran/KosinskiPM Art/Enemy Basaran.kospm"
	even
ArtKosPM_Caterkiller:			binclude "Objects/Enemies/Caterkiller/KosinskiPM Art/Enemy Caterkiller.kospm"
	even
ArtKosPM_Yadrin:			binclude "Objects/Enemies/Yadrin/KosinskiPM Art/Enemy Yadrin.kospm"
	even
ArtKosPM_Roller:			binclude "Objects/Enemies/Roller/KosinskiPM Art/Enemy Roller.kospm"
	even
ArtKosPM_Splats:			binclude "Objects/Enemies/Splats/KosinskiPM Art/Enemy Splats.kospm"
	even
ArtKosPM_Burrobot:			binclude "Objects/Enemies/Burrobot/KosinskiPM Art/Enemy Burrobot.kospm"
	even
ArtKosPM_Jaws:				binclude "Objects/Enemies/Jaws/KosinskiPM Art/Enemy Jaws.kospm"
	even
ArtKosPM_Orbinaut:			binclude "Objects/Enemies/Orbinaut/KosinskiPM Art/Enemy Orbinaut.kospm"
	even
ArtKosPM_Bomb:				binclude "Objects/Enemies/Bomb/KosinskiPM Art/Enemy Bomb.kospm"
	even
ArtKosPM_BallHog:			binclude "Objects/Enemies/Ball Hog/KosinskiPM Art/Enemy Ball Hog.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Continue screen graphics
; ===========================================================================

ArtKosPM_ContinueSprites:		binclude "Screens/Continue/KosinskiPM Art/Player Sprites.kospm"
	even
ArtKosPM_ContinueIcons:			binclude "Screens/Continue/KosinskiPM Art/Player Icons.kospm"
	even
ArtKosPM_ContinueDigits:		binclude "Screens/Continue/KosinskiPM Art/Digits.kospm"
	even
ArtKosPM_EggRoboBadnik:			binclude "Screens/Continue/KosinskiPM Art/Egg Robo Badnik.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Special Stage screen graphics
; ===========================================================================

ArtKosPM_SSHUD:				binclude "Screens/Special Stage/KosinskiPM Art/HUD.kospm"
	even
ArtKosPM_SSBgFish:			binclude "Screens/Special Stage/KosinskiPM Art/Birds & Fish.kospm"
	even
ArtKosPM_SSBgCloud:			binclude "Screens/Special Stage/KosinskiPM Art/Clouds.kospm"
	even
ArtKosPM_SSGOAL:			binclude "Screens/Special Stage/KosinskiPM Art/GOAL.kospm"
	even
ArtKosPM_SSRBlock:			binclude "Screens/Special Stage/KosinskiPM Art/R.kospm"
	even
ArtKosPM_SSEmStars:			binclude "Screens/Special Stage/KosinskiPM Art/Emerald Twinkle.kospm"
	even
ArtKosPM_SSRedWhite:			binclude "Screens/Special Stage/KosinskiPM Art/Red-White.kospm"
	even
ArtKosPM_SSUpDown:			binclude "Screens/Special Stage/KosinskiPM Art/UP-DOWN.kospm"
	even
ArtKosPM_SSEmerald:			binclude "Screens/Special Stage/KosinskiPM Art/Emeralds.kospm"
	even
ArtKosPM_SSGhost:			binclude "Screens/Special Stage/KosinskiPM Art/Ghost.kospm"
	even
ArtKosPM_SSGlass:			binclude "Screens/Special Stage/KosinskiPM Art/Glass.kospm"
	even
ArtKosPM_SSResults:			binclude "Screens/Special Stage/KosinskiPM Art/Results General.kospm"
	even
ArtKosPM_SSResultsTKIcons:		binclude "Screens/Special Stage/KosinskiPM Art/Results Tails Knuckles Icons.kospm"
	even
ArtKosPM_SSResultsSUPER:		binclude "Screens/Special Stage/KosinskiPM Art/Results SUPER.kospm"
	even
ArtKosPM_SSResultsHYPER:		binclude "Screens/Special Stage/KosinskiPM Art/Results HYPER.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Ending screen graphics
; ===========================================================================

ArtKosPM_FlowersEnding:			binclude "Screens/Ending/KosinskiPM Art/Flowers Ending.kospm"
	even
ArtKosPM_EmeraldsEnding:		binclude "Screens/Ending/KosinskiPM Art/Emeralds Ending.kospm"
	even
ArtKosPM_StHLogoEnding:			binclude "Screens/Ending/KosinskiPM Art/StH Logo Ending.kospm"
	even

; ===========================================================================
; Kosinski Plus Module compressed Credits screen graphics
; ===========================================================================

ArtKosPM_SmallTextCredits:		binclude "Screens/Credits/KosinskiPM Art/8x16 Font.kospm"
	even
ArtKosPM_RobotnikCredits:		binclude "Screens/Credits/KosinskiPM Art/Robotnik.kospm"
	even
ArtKosPM_EggRoboCredits:		binclude "Screens/Credits/KosinskiPM Art/Egg Robo.kospm"
	even
