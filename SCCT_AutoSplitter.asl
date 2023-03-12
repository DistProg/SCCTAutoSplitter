// SCCT AutoSplitter by Distro and Buttercak3

state("splintercell3")
{
    // Load removal
    bool cutscene: "binkw32.dll", 0x54AB4;
    bool qsql: "splintercell3.exe", 0x9327E8;
    int isLoading: "splintercell3.exe", 0x8C8B38;

    // Splitting behavior
    int runStart: "splintercell3.exe", 0x8F6988, 0x450, 0x9C, 0x10, 0x50, 0x820;
    string255 mapName: "splintercell3.exe", 0x73E6CC, 0x4;
    int inResetMenu: "splintercell3.exe",  0xA17608, 0x184;
    bool soshoEnd: "splintercell3.exe",  0x7497D4, 0x1C;
    bool missionComplete: "splintercell3.exe", 0xA2C81C;

    // In-game timer
    double igt: "splintercell3.exe", 0x0090B734, 0x10, 0x14, 0x80;
}

startup
{
    settings.Add("subsplit", false, "Split when entering Seoul Part 2");
    settings.Add("coop_mode", false, "[Experimental] Co-op mode");
    settings.Add("sync_igt", false, "[Experimental] Sync Game Time with in-game timer");
    settings.Add("actual_igt", false, "Always display the actual in-game time", "sync_igt");
    settings.Add("il_mode", false, "[Experimental] IL Mode");
    settings.Add("il_noql", false, "No QS/QL Mode", "il_mode");

    settings.SetToolTip("actual_igt", "Game Time will go back down after a QL; Useful for practice and debugging");
    settings.SetToolTip("il_mode", "Auto-start in every mission and split at the mission complete screen");
    settings.SetToolTip("il_noql", "Auto-start after the loadout selection instead (use with IGT sync setting)");
    settings.SetToolTip("coop_mode", "Auto-start when the IGT starts in any level");

    // Tracks Game Time synced with the game
    vars.gameTime = 0.0d;

    // Used to track real-time whenever IGT is not available
    vars.prevTime = DateTime.Now;
    vars.time = DateTime.Now;

    vars.inLevel = false;
}

update {
    if (settings["sync_igt"]) {
        vars.prevTime = vars.time;
        vars.time = DateTime.Now;

        if (!vars.inLevel && old.igt != current.igt && current.igt == 0) {
            vars.inLevel = true;
        }

        if (vars.inLevel && !old.missionComplete && current.missionComplete) {
            vars.inLevel = false;
        }
    }
}

isLoading
{
    if (settings["sync_igt"]) {
        // Returning a constant true value will prevent LiveSplit from interpolating Game Time between ticks.
        return true;
    } else {
        return current.qsql || current.isLoading == 1;
    }
}

start
{
    if (settings["coop_mode"]) {
        return old.igt != 0 && current.igt == 0;
    } else if (settings["il_mode"]) {
        if (settings["il_noql"]) {
            // Start when the IGT resets to 0
            return old.igt == 0 && current.igt != 0;
        } else {
            return !old.cutscene && current.cutscene;
        }
    } else if (current.runStart == 49155 || current.runStart == 49156 || current.runStart == 49166) {
        vars.inLevel = false;
        return true;
    }
}

split
{
    if (settings["coop_mode"] && current.mapName == "05_NuclearPlant") {
        return !old.missionComplete && current.missionComplete;
    }

    if (settings["il_mode"] && settings["il_noql"]) {
        if (!old.missionComplete && current.missionComplete) {
            return true;
        }
    }

    if (current.mapName == "11_KokuboSosho") {
        return (old.cutscene && !current.cutscene && current.soshoEnd);
    }

    if (!settings["subsplit"] && current.mapName == "09_SeoulTwo") {
        return false;
    }

    return (current.mapName != old.mapName && current.mapName != "menu" && current.mapName != "01_Lighthouse");
}

reset
{
    if (!settings["il_mode"]) {
        return (old.inResetMenu != 0 && current.inResetMenu == 0 && current.mapName == "01_Lighthouse");
    }
}

gameTime
{
    if (!settings["sync_igt"]) {
        return null;
    } else if (settings["actual_igt"]) {
        return TimeSpan.FromSeconds(current.igt);
    } else if (current.isLoading == 1) {
        return TimeSpan.FromSeconds(vars.gameTime);
    } else if (!vars.inLevel || (current.igt == old.igt && !current.qsql)) {
        // Whenever we're not playing, use real-time.
        vars.gameTime += (vars.time - vars.prevTime).TotalMilliseconds / 1000.0;
    } else if (current.igt >= old.igt + 2) {
        // When the IGT does a large jump (more than 2 seconds), use real-time instead.
        // This can happen between levels or when going to the menu.
        vars.gameTime += (vars.time - vars.prevTime).TotalMilliseconds / 1000.0;
    } else if (current.igt > old.igt) {
        vars.gameTime += current.igt - old.igt;
    }

    return TimeSpan.FromSeconds(vars.gameTime);
}

onReset
{
    vars.gameTime = 0.0;
}
