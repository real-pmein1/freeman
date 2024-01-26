# HLA-NoVR-Launcher
Launcher for Half-Life: Alyx NoVR

Modified by pmein1, original by bfeber

## Installation

This launcher is currently using bfeber's v2.4 code.

### Windows
[Download and extract the archive to a folder of your choice.](https://github.com/real-pmein1/freeman/releases/latest/download/HLA-NoVR-Launcher.7z)

---

### Steam Deck/Linux

Not yet tested.

## Important Information

If prompted after clicking "Play" in the launcher, select your Half-Life: Alyx installation folder (the one with the folders `game` and `content` inside).

## Changes from the bfeber Launcher

+ Removed launcher auto-update
+ Removed mod auto-update (for now)
+ Removed Steam requirement (to still use Steam, launch Steam first then run the launcher)
+ Removed administrator elevation requirement on Windows
+ Removed "Branch" textbox
+ Moved "Custom launch options" away from the window edge

### Additional Game Parameters

These parameters are sent to hlvr.exe by the launcher, in addition to those provided in the Custom launch options box:
+ -novr +vr_enable_fake_vr 1 -condebug +hlvr_main_menu_delay 999999 +hlvr_main_menu_delay_with_intro 999999 +hlvr_main_menu_delay_with_intro_and_saves 999999 -window

## Compiling the Launcher

Instructions will be provided in due course as to how to compile the launcher from source.

## Credits
Original launcher made by [bfeber](https://www.github.com/bfeber/HLA-NoVR-Launcher)

The awesome background video was made by [Half Peeps](https://www.youtube.com/@HALFPEEPS).

## License
This program is licensed under the [LGPL](LICENSE.txt). It uses the [Qt 6.6.1 library](https://www.qt.io) and parts of the [7-Zip program](www.7-zip.org), both also licensed under the [LGPL](LICENSE.txt).
