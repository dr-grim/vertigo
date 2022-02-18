# Vertigo

![Vertigo title screen](Vertigo-titlescreen.png)

Full sources for BBC Micro/Electron game "Vertigo" from 1991, as published by Superior Software. Thanks to Richard Hanson at
[Superior Interactive](https://www.superiorinteractive.com/) for permission to release the source code. 

## Original Development Discs
These have been converted and uploaded in the [`original-dev-discs`](original-dev-discs) folder - see [`README.md`](original-dev-discs/README.md) in there for more info.

## Converted Sources
Mapped from ADE+ to beebasm, the 6502 sources are in the [`src`](src) folder, built from the root folder's [`Makefile`](Makefile). This will clone the [`beebasm`](https://github.com/stardot/beebasm) GitHub repository as a sub-folder (if it doesn't already exist), and build `beebasm` if the executable isn't present. The disc image `vertigo.ssd` for Vertigo is then built.

The `clean` make rule will remove the `beebasm` cloned repository and also remove the built disc image `vertigo.ssd`.

### BBC Master variant
Builds `vertigo.ssd`

The code I'd retrieved has the graphics showing `(C) 1989`, so it's not the final disc version (released with `(C) 1991` as its final release date). However, it build a binary match of the executable found on the backup disc, and works 100%. There may have been later tweaks, I'll keep digging.

### BBC 'B' disc variant
Builds `vertigo-bbc-b-disc.ssd`

The disc was corrupted, but I managed to retrieve the source code and binary data files. The cassette version sources look ok, so I may be able to rebuild the art from that.