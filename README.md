# SONIC-1-IN-SONIC-3-S.C.E.-

## Disclaimer

This is a port of Sonic The Hedgehog (1991) to Sonic Clean Engine (S.C.E.), our heavily modified and improved Sonic 3 & Knuckles engine, which we have been using for a long time for our MD projects (such as Hellfire Saga and Sonic 3 & Knuckles: Epilogue).

Free use. You use it at your own risk. All code is provided “as is”. This source code uses software from other authors. Check their licenses before using it. You assume any and all responsibility for using this content responsibly. I claims no responsibility or warranty.

You can use this source code as a base for your projects, or just as an example for optimizations of your source code.

## Additional links

#### Main source code:

- [Sonic-Clean-Engine-S.C.E.-](https://github.com/TheBlad768/Sonic-Clean-Engine-S.C.E.-)

#### Extended source code:

- [Sonic-Clean-Engine-S.C.E.-Extended-](https://github.com/TheBlad768/Sonic-Clean-Engine-S.C.E.-Extended-)

## Quick start

- For editing sprites you can use [SonMapEd](https://info.sonicretro.org/SonMapEd), [ClownMapEd](https://info.sonicretro.org/ClownMapEd) or [Flex2](https://info.sonicretro.org/Flex_2) (Read the issues).

- For editing levels you can use official [SonLVL](https://info.sonicretro.org/SonLVL) or [SonLVL-64x64-Compatible](https://github.com/Project1114/SonLVL-64x64-Compatible). Unfortunately, [SonED2](https://info.sonicretro.org/SonED2) is no longer supported.

- To convert SMPS music to asm format you can use [smps2asm](https://forums.sonicretro.org/index.php?threads/smps2asm-and-improved-s-k-driver.26876).

## Current issues

1. S.C.E. uses [Kosinski Plus algorithm](https://github.com/flamewing/mdcomp/blob/master/src/asm/KosinskiPlus.asm), but **Flex2** program does not support **Kosinski Plus Module**. Therefore, **Flex2.json** project file is partially useless. **SonMapEd** program does not support **Kosinski Plus** at all. You can only open uncompressed graphics.

#### Alternative programs:
- [mdcomp](https://github.com/flamewing/mdcomp/releases)
- [ClownMapEd](https://github.com/Clownacy/ClownMapEd/releases)
- [FW-KENSC-ShellExt](https://github.com/MainMemory/FW-KENSC-ShellExt/releases)

2. S.C.E. uses a different layout format to support two-byte IDs chunks. Unfortunately there are no converters here for the new layout format. You just won't be able to use the original layouts from Sonic 3 & Knuckles.
You could try using different [Layout.cs](https://github.com/TheBlad768/Sonic-Clean-Engine-S.C.E.-/tree/master/SonLVL%20INI%20Files/Common/Layout) for **SonLVL** to convert layout to the new format.

## FAQ

- If you want to convert levels from previous Sonic games, you have to use [LevelConverter](https://info.sonicretro.org/LevelConverter) from [SonLVL](https://info.sonicretro.org/SonLVL). Then change the layout format using [Layout.cs](https://github.com/TheBlad768/Sonic-Clean-Engine-S.C.E.-/tree/master/SonLVL%20INI%20Files/Common/Layout).

- If you want to make a different text for Title Card, you need to create a file of letters from [List.unc](https://github.com/TheBlad768/Sonic-Clean-Engine-S.C.E.-/tree/master/Objects/Title%20Card/KosinskiPM%20Art/Levels). This will be loaded before the level starts.
You don't have to add the letters **'ENOZ' (ZONE)** because those letters are already in VRAM. Then you have to create a mapping of your zone name in [Map - Title Card.asm](https://github.com/TheBlad768/Sonic-Clean-Engine-S.C.E.-/tree/master/Objects/Title%20Card/Object%20Data).

- If you want to use other SMPS music you can use [Valley Bell's SMPS Research](https://forums.sonicretro.org/index.php?threads/valley-bells-smps-research.32473) or [vgm2smps](https://github.com/Ivan-YO/vgm2smps/releases).

## Credits

### Red Miso Studios Staff

- TheBlad768 -- Project lead, sole programmer, S.C.E. Game Engine
- kuroya2mouse -- Level art and level design edits, sprite art and other things
- pixelcat -- Sprite art, UI art and other things
- FoxConED -- S.C.E. Level Select font art
- Dolphman -- Robotnik head art

### Testing and other help

- giovanni.gen, KGL, DeltaW, Narcologer, CatswellMeow, Nintorch, FoxConED, lavagaming1, cuberoot, Vladikcomper, ProjectFM, MarkeyJester, VAdaPEGA

### Special Support

- cuberoot

### Special Thanks

- joshyflip for consulting on the artwork
- Flamewing, devon, RealMalachi and others for bug fixing guides
- Clownacy for work on the disassemblies
- SSRG and Sonic Retro

## Discord

- [redmisostudios](https://discords.com/servers/redmisostudios)

## These projects are based on this source code

- Sonic 3 Rebuilt by TomatoWave_0
- [Sonic The Hedgehog in Hellfire Saga](https://github.com/TheBlad768/Hellfire-Saga-Public-Source)
- Sonic 3 & Knuckles: Epilogue
- TishaProject (2019)
- Sonic Virtual Adventure (2017) (Cancelled) — In the past I made this source code specifically for this project (:

## Check out the Sonic Retro source code

- [s1disasm](https://github.com/sonicretro/s1disasm)
- [s2disasm](https://github.com/sonicretro/s2disasm)
- [skdisasm](https://github.com/sonicretro/skdisasm)
