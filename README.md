# TicTacToe (IBM i RPGLE + DDS)

A simple Tic-Tac-Toe game for IBM i, implemented using ILE RPG (RPGLE) and a DDS Display File for the green‑screen UI.

## Repository structure

- [tictacr.rpgle](https://github.com/aravindvemulaa/TicTacToe/blob/main/tictacr.rpgle) — Main ILE RPG program source
- [tictacd.dspf](https://github.com/aravindvemulaa/TicTacToe/blob/main/tictacd.dspf) — DDS display file defining the screen(s) and UI
- README.md — This file

## Requirements

- IBM i (AS/400, iSeries) system
- User profile with authority to create source files and compile objects
- One of:
  - 5250 terminal (SEU/PDM or ACS Run SQL Scripts/CL)
  - Rational Developer for i (RDi) or VS Code with Code for IBM i

## Getting the source onto IBM i

Choose one approach:

- Copy/paste the contents of each file into corresponding source members on IBM i (recommended for quick setup).
- Or, upload the files to the IFS and copy them into source physical files.

Recommended source file layout:
- QRPGLESRC for the RPG source member TICTACR
- QDDSSRC for the DDS display source member TICTACD

Example commands to create these source files (if they don’t already exist):

```
CRTSRCPF FILE(*LIBL/QRPGLESRC) RCDLEN(112) TEXT('ILE RPG source')
CRTSRCPF FILE(*LIBL/QDDSSRC)   RCDLEN(112) TEXT('DDS Display source')
```

Then create source members:
- Member TICTACR in MYLIB/QRPGLESRC and paste in the contents of tictacr.rpgle
- Member TICTACD in MYLIB/QDDSSRC and paste in the contents of tictacd.dspf

## Compile

1) Compile the display file:

```
CRTDSPF FILE(*LIBL/TICTACD) SRCFILE(MYLIB/QDDSSRC)
```

2) Compile the RPG program (bound program):

```
CRTBNDRPG PGM(*LIBL/TICTACR) SRCFILE(*LIBL/QRPGLESRC) DFTACTGRP(*NO)
```

Notes:
- If your system requires it, you can compile into the default activation group by setting `DFTACTGRP(*YES)` (though ILE best practice is `*NO`).
- Adjust MYLIB to the library of your choice.

## Run

Call the program from a 5250 session:

```
CALL PGM(*LIBL/TICTACR)
```

The UI defined in TICTACD will guide play. Use the on‑screen prompts to select grid cells and alternate turns. The program determines win/draw conditions.

## How it works

- Game logic: Implemented in [tictacr.rpgle](https://github.com/aravindvemulaa/TicTacToe/blob/main/tictacr.rpgle) (ILE RPG).
## *** Make sure that when you input your choice (X or O), the cursor is positioned in the field where you are entering the value. Otherwise, an error will occur. Since in a display   file, we retain the cursor position in this way and logic is implemented based on that.
- UI: Screen layout, fields, and any function keys are defined in [tictacd.dspf](https://github.com/aravindvemulaa/TicTacToe/blob/main/tictacd.dspf), compiled into display file TICTACD.

## Development tips

- RDi/VS Code: Create/edit members in QRPGLESRC/QDDSSRC and use your build actions to run CRTDSPF and CRTBNDRPG.
- Debugging: STRDBG PGM(MYLIB/TICTACR) OPMSRC(*YES)
- If you rename members, keep object names aligned (program TICTACR, display TICTACD) or update your compile commands accordingly.
## Improvements to make
- we can implment to play with bot using a random number genration.
- add game history using database file and recording each game.
  

## Author

- Repository: [aravindvemulaa/TicTacToe](https://github.com/aravindvemulaa/TicTacToe)

