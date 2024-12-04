# HLA-NoVR-Launcher - commit 98a4030
Launcher for Half-Life: Alyx NoVR

## Compiling

### Windows
1.  Get latest code from here
2.  Get Godot_v4.4-dev5_win64.exe.zip
3.  Get Godot_v4.4-dev5_export_templates.tpz
4.  Get latest rcedit.exe from https://github.com/electron/rcedit/releases
5.  Extract Godot and templates
6.  Run Godot, import and edit the HLA launcher project
7.  Editor->Editor Settings->Export->Windows->Set rcedit.exe path
8.  Editor->Manage Export Templates->Install (the export templates)
9.  Project->Export->Windows Desktop
10. Set Export Path
11. Export All...->Release

---

### Steam Deck/Linux

If you use a Steam Deck/Linux, see the [FAQ](https://docs.google.com/document/d/1mlDz24iE1r4Lf16y5N9I37ZIvm4V0ie2Sxg1GBlcs10) for installation instructions.

## Important Information

In case you need to select a folder after clicking "Play" in the launcher, select your "Half-Life Alyx" folder (it's located where Steam installed the game and it has the folders `game` and `content` inside of it).

These parameters are sent to hlvr.exe by the launcher, in addition to those provided in the Custom launch options box:
+ -novr +vr_enable_fake_vr 1 -condebug +hlvr_main_menu_delay 999999 +hlvr_main_menu_delay_with_intro 999999 +hlvr_main_menu_delay_with_intro_and_saves 999999 -window

## Changes from the bfeber Launcher

+ Removed auto-update (except the Launcher-Helper)
+ Removed Steam requirement (to still use Steam, launch Steam first then run the launcher)

## Credits
Original launcher made by bfeber/gb2dev

The awesome background video was made by [Half Peeps](https://www.youtube.com/@HALFPEEPS).

## License
This program is licensed under the [GPL](LICENSE).

It also uses a custom version of [Steam Achievement Manager](https://github.com/gibbed/SteamAchievementManager), modified to give achievements from the command line.
