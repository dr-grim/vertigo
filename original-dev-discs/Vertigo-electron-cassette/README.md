# Vertigo Electron cassette (Opus DDOS 720kB)

Single load, no easter egg animation.
Uses MODE 4 for display, and converts MODE 1 colour sprites to 2 colour MODE 4.

# Volume 0A
Targetted as a release disc; all parts are collected here to enable Vertigo to be played.

# Volume 0B
Source code store; all text files had the `e.` directory, which is represented as a folder name (having been pulled from Opus DDOS into ADFS, and then into Linux).

# Volumes 2A...2E
Partially copied over. These files include the sprite construction, level editor, etc.

# Volume 2A (not uploaded yet)

Looks like MODE 1 original sprites from BBC Master 128k version.

# Volume 2B

MODE 4 converted data from Volume 2A.

## Level data
`LEVEL1` ... `LEVEL6` are concatenated using `joiner` (tokenised file - extracted to text as `joiner.bas` for reference) to form `levels`. `LEVEL6` is cut short, as only 3 screens are actually needed - only levels 3, 4 and 5 have an animated ball path.

`levels` is the downsampled to form `n.levels` by using `convLVL` (tokenised BASIC - extracted to text as `convLVL.bas` for reference). Note that `n.levels` was renamed from `n/levels` after ADFS export as `n.levels` made a subdirectory in the ADFS disc image.

## Sprite and level data merging
`n.levels` is then concatenated with `ball`, `jewel`, `nasty`, `wipeout`, `final`, `eolevel`, `largeBa`, `ball.sp` and `mums.sp`,
using the `joiner` script; this generates `bank4`. The name looks a bit odd - probably a handover from an earlier script for the BBC Master 129k version when sprite data was (probably) stashed in bank 4 of 16kB sideways RAM.

This is a rather convoluted toolchain! Run `joiner`, select option 1; run `convLVL`; run `joiner` again, select option 2. Ouch! Oh for a Makefile! :)

## `beebasm` changes
The data is now loaded in directly at assembly time, using `INCBIN`. The `mus.sp` sprites have been split using a shell script (see [split-mums.sp.sh](../../src-electron-cassette/data/split-mums.sp.sh)), so they can be littered around spare areas in the memory map.
