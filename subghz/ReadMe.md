# Various SUB files I've found or created. Some tested, some not.

Special thanks to [FalsePhilosopher](https://github.com/FalsePhilosopher) for organization help and everyone else that shares files!<br>
Worth a mention: If you have a HackRF, you can find a ton of files and info over at RocketGod's [HackRF Treasure Chest](https://github.com/RocketGod-git/HackRF-Treasure-Chest).

## How are the raw SUB files are formatted? (Adapted from a chat with [ImprovingRigmarole](https://github.com/improving-rigmarole)!)

This is a very quick and dirty explanation of the Flipper "raw" SUB format. Enough to figure out more at least.<br>
Each numerical value is the duration of a pulse in microseconds. Positive is `send` and negative is `pause`.<br>
Example: `3607 -100 1789 -66` means send (positive) during the `3607µs` then pause (negative) for the `100µs`, etc.<br>
You can easily plot any raw SUB (or IR) file at the [Official Pulse Plotter](https://my.flipp.dev/pulse-plotter) and see a graph to help decode patterns.

Another take... positive numbers in the raw .SUB files tell you how long (in microseconds / μs) the signal was ON and the negative numbers tell you how long it was OFF. Usually on means 1 and off means 0. This also makes sense when you remember/realize OOK = `On Off Keying`.

## NOTE: The deBruijn and OpenSesame files have moved to the [Garages subfolder](https://github.com/UberGuidoZ/Flipper/tree/main/Sub-GHz/Garages/deBruijn).

You can generate MANY of your own SUBs, such as MegaCode and Firefly, over at [Flipper Maker](https://flippermaker.github.io/).

