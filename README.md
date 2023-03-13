# Splinter Cell: Chaos Theory Autoplitter

## Memory addresses

| Binary            | OS1        | OS2   | OS3  | OS4  | Type   | Name            | Description                                                                      |
| ----------------- | ---------- | ----- | ---- | ---- | ------ | --------------- | -------------------------------------------------------------------------------- |
| splintercell3.exe | 0x00A0E3DC | 0x8   | 0x94 |      | bool   | inMenu          | `true` while the ESC menu is open                                                |
| binkw32.dll       | 0x54AB4    |       |      |      | bool   | cutscene        | `true` while a cutscene is running                                               |
| splintercell3.exe | 0x9327E8   |       |      |      | bool   | qsql            | `true` while quick-loading or quick-saving                                       |
| splintercell3.exe | 0x8C8B38   |       |      |      | int    | isLoading       | `1` while loading a level or in the main menu                                    |
| splintercell3.exe | 0x73E6CC   | 0x4   |      |      | string | mapName         | Map name                                                                         |
| splintercell3.exe | 0xA17608   | 0x184 |      |      | int    | inResetMenu     | Momentarily goes to `0` in the "PRESS ANY KEY TO CONTINUE" screen for Lighthouse |
| splintercell3.exe | 0x0090B734 | 0x10  | 0x14 | 0x80 | double | igt             | In-game timer                                                                    |
| splintercell3.exe | 0xA2C81C   |       |      |      | bool   | missionComplete | `true` when the "MISSION COMPLETE" screen is up                                  |
| splintercell3.exe | 0x7497D4   | 0x1C  |      |      | bool   | soshoEnd        | Mission complete flag in Kokubo Sosho                                            |
| splintercell3.exe | 0x008FA4E8 | 0xE8  |      |      | bool   | missionEnd      | `true` during "MISSION COMPLETE" or "MISSION FAILED" screens                     |

## Map names

These are the internal map names that you get when you read the memory address mentioned above. They are also the file names of the files in Data/Maps/.

### Singleplayer

| Map          | Internal name  |
| ------------ | -------------- |
| Main menu    | menu           |
| Lighthouse   | 01_Lighthouse  |
| Cargo ship   | 02_CargoShip   |
| Bank         | 03_Bank        |
| Penthouse    | 04_Penthouse   |
| Displace     | 05_Displace    |
| Hokkaido     | 06_Hokkaido    |
| Battery      | 07_Battery     |
| Seoul 1      | 08_SeoulOne    |
| Seoul 2      | 09_SeoulTwo    |
| Bathhouse    | 10_Bathhouse   |
| Kokubo Sosho | 11_KokuboSosho |

### Co-op

| Map             | Internal name    |
| --------------- | ---------------- |
| Training        | 00_Training_COOP |
| Panama          | 01_Panama        |
| Seoul 3         | 02_seoulthree    |
| Chemical Bunker | 03_ChemBunker    |
| Train Station   | 04_GCS           |
| UN Headquarters | 07_UNhq          |
| Nuclear Plant   | 05_NuclearPlant  |
