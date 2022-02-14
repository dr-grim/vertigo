# Conversion notes from `ADE+` to `beebasm`

These notes were used to create `convert_6502_src.sh`, which does the heavy lifting from `ADE+` to `beebasm` - the user still has to check and tidy, tho'!

## Patterns looked for
* Rename `sourcefile` -> `sourcefile.6502`
* Replace `\r` -> `\n` (replace carriage return with line feed for end of line)
* `\n([a-zA-Z])` to `\n.\1` to prepend a `.` on each label
* `\n\s*\*` to `\n;\s*\*` to prepend a `;` on each star-based comment
* `DFB` -> `EQUB`
* `DW` -> `EQUW`
* `DS` -> `SKIP`
* `STR string` -> `EQUS string, &0D` (as MACROs don't support string parameters)
* `ASC` -> `EQUS`
* `CHN(.+)` -> `INCLUDE "\1"`
* `EQU` -> `=`
* `TTL` -> comment out (set page title when printing a listing)
* negative numbers not supported in immediate mode; use AND &FF to get 8 lsb
* ADE+ and beebasm `>` and `<` operator meanings are flipped (used to perform `MOD` and `DIV` 256), viz:

    Operator | ADE+ | beebasm
    -|-|-
    `>` | MOD 256 | DIV 256
    `<` | DIV 256 | MOD 256

* `<([&a-z0-9A-Z]*)` -> `HI($1)`
* `>([&a-z0-9A-Z]*)` -> `LO($1)`
  