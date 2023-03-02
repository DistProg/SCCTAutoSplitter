// SCCT AutoSplitter by Distro
// This current version is for testing purposes only. If it proves to work for everyone, there will be code cleanup.
// Please leave some feedback on how well the autosplitter works and report bugs to Distro.

state("splintercell3")
{	
    //Load Removal
    bool isMenu: "splintercell3.exe", 0x8FA4E8, 0xF8; // Flag that tells you when we're in the menu. Only necessary if you use either LevelTime or LoadTime. Can also be used in the future if we want to pause the timer in menus.
    bool cutscene: "binkw32.dll", 0x54AB4; // Flag that tells you when a cutscene is running. Only necessary if you use either LevelTime or LoadTime.   
    //int loadSave: "splintercell3.exe", 0x29A560, 0xC, 0x134; // set to 6 during QS or QL
    int loadSave: "splintercell3.exe", 0xA16A08, 0xC, 0x134; // set to 6 during QS or QL
    int levelLoad: "splintercell3.exe", 0x8C8B38; // used as flag because the value stays at 1 when loading a level.

    //Splitting behavior
	string255 map: "splintercell3.exe", 0x73E6CC, 0x4; 
	int ResetMenu: "splintercell3.exe",  0xA17608, 0x184; // Used for auto-reset. Turns to 0 when Press Fire to Load Screen is done loading on Lighthouse.
    //int runStart: "splintercell3.exe",  0x1079F4, 0x94; // Used for auto-start. Jumps from 1 to 49155 or 49166 when run starts.
	int runStart: "splintercell3.exe",  0x8F6988, 0x450, 0x9C, 0x10, 0x50, 0x820; // Used for auto-start. Jumps from 1 to 49155 or 49166 when run starts.
    bool soshoEnd: "splintercell3.exe",  0x7497D4, 0x1C; // Last mission complete Flag 1
    //bool missionComplete: "splintercell3.exe", 0xA2C81C; // 1 at mission complete
}

startup {
    settings.Add("subsplit", false, "Split when entering Seoul Part 2?");
}

isLoading {
    return (current.loadSave == 6 || current.levelLoad == 1);
}

start {
	return (current.runStart == 49155 || current.runStart == 49156 || current.runStart == 49166);
}

split {  
    
    if (current.map == "11_KokuboSosho") {
        return (old.cutscene && !current.cutscene && current.soshoEnd);
    }

    if (!settings["subsplit"] && current.map == "09_SeoulTwo") {
        return false;
    }

	return (current.map != old.map && current.map != "menu" && current.map != "01_Lighthouse");
}

reset {
    return (old.ResetMenu != 0 && current.ResetMenu == 0 && current.map == "01_Lighthouse");
}
