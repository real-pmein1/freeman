# Freeman - A Half-Life: Alyx Non-VR Mod

This mod is designed to run Half-Life: Alyx without the VR hardware requirement and without the contraints/viruses/missing parts of other non-vr mods.

It is an amalgamation of original scripting and several different mods, all of which are listed below in the credits.

The intended audience of this mod are those who are unable to use VR (sight issues, other disabilities, money contraints etc) or those who simply do not want to keep getting out their VR equipment for short periods of gaming.  It is not intended for those who claim this game should always be run with VR, regardless of circumstance.

If you can use VR and haven't yet played Alyx in VR, I would suggest to do so.  Using this mod turns the game into a very different experience (similar to a HL2 mod); more action, less puzzle.

Please read this to the end as it contains some helpful hints in the FAQ section to help make your way through the game.

## Functionality

+ Ability to complete the game to the end
+ Proper WSAD/mouse movement
+ Jumping
+ Auto or manual flashlight (disabled until picked up)
+ Source 1/HL2 weapons (Pistol/Shotgun/AR2/Grenades)
+ Usable health stations and medpens
+ Usable resin
+ Crafting stations (altered functionality)
+ Auto or manual VR teleport-style ladder climbing
+ Jeff fully neutered (optional of course)
+ Working main menu
+ Full subtitle support
+ Unmodified game files so VR version can be used without removing the mod
+ A Portal 2 Easter egg

## Requirements

Half-Life: Alyx (tested on v1.2.1 (best compatibility) and v1.5.4, should work on any version)

## Automatic installation

The automated mod installer will create a folder inside the Half-Life Alyx\game folder called "freeman" and copy the required mod files to there.  It will then create a copy of hlvr.exe and patch it to load the hlnonvr.dll file.  The game should be started using the new hlnonvr.exe executable.

### Manual installation

If you want to install manually, download the repository in zip format and extract the "freeman" and "bin" folders to your hla\game\ folder and run \game\bin\win64\hlapatcher.exe.  Then run as below.

## Running the game

Create a shortcut to bin\hlnonvr.exe and add the following parameters:

-game freeman -w 1920 -h 1080

Replace 1920 and 1080 with your screen resolution.  Smaller settings will result in a window.  You can add any other Source 2 parameters too, like -console -vconsole -dev etc.  The -w and -h parameters need to be specified so the on-screen messages appear correctly.

## Uninstallation

Delete the freeman folder completely and any shortcuts, then remove the bin\hlnonvr.exe and hlnonvr.dll files.

## FAQs

Q) How do I get back to the Main Menu  
A) Press TAB; the ESCAPE key isn't usable properly in spectator mode and therefore cannot be bound to load the startup map (the game is auto-saved at this point too)

Q) I cannot go up any ladder  
A) Press USE on upright ladders to be teleported to the top (some also allow the reverse too); walk forward and jump on slanted ladders

Q) Sometimes I get stuck on objects on the floor, like cables or boxes  
A) One of the issues of VR to non-VR; just jump over it

Q) I cannot rotate the round Combine tanks used on the two Combine Consoles  
A) Shoot them with the pistol rather than USEing them; shooting different parts of the tank make it rotate more slowly

Q) Using a medped can increase my health beyond 100%  
A) Yes, I chose to cumulatively add health up to 200% when using the pens as a nod to old-school shooters; be wary of using the health stations when over 100%...

Q) How do I change options/keybinds etc?  
A) Screen resolution is set by the parameters above; keybinds can be changed in the freeman\cfg\autoexec.cfg file

Q) The chapter titles or other on-screen messages aren't displaying correctly  
A) Make sure the screen resolution is set in the command line with -w and -h

Q) I hate Jeff  
A) No problem; press N to have him stop in his tracks and M to release him

Q) Why is the mod called "Freeman"  
A) Because of the HEV HUD and arms when holding weapons

Q) This game shouldn't be played outside of VR  
A) ...

## Valve fixes

The Vodka count speech is now correctly played when leaving the Distillery when only carrying one bottle

## Third-party mod fixes

Flashlight script now plays sound on switch off as well as switch on
Flashlight save bug has been removed
Flashlight is only usable after being picked up at the correct point in the game
Triggers script re-written to allow correct progress through the game
hlnonvr.dll modified to remove the Steam dependancy

## Known issues

When the player is killed, the game pauses and must be unpaused with P (by default) to continue
No pause menu
The AR2 is used in the final map rather than energy balls
The hotel's Combine elevators are set to automatically run due to incorrect entity flags

## Credits

+ Mod author: pmein1

+ HLNONVR (DLL): https://github.com/Jan4V/hlnonvr
+ HL2 weapons: https://github.com/KonqiTheKonqueror/Source2-PFSK
+ VScript base, initial triggers script, flashlight and jump fix: https://github.com/JJL772/half-life-alyx-scripts
+ Entity variable storage: https://github.com/FrostSource/hla_extravaganza

## Mod use

You can use this mod in any other mod as long as the credits section is put into your credits section and I am credited accordingly.
