Scriptname EasyLootHotkeyMCM extends SKI_ConfigBase  
{MCM for the EasyLootHotkey mod}

; SCRIPT VERSION ------------------------------------------------------------------------

int Function GetVersion()
    return 5
EndFunction

; PROPERTIES ----------------------------------------------------------------------------

; Persistent Settings (stored in the user's game save)
EasyLootHotkeySettings Property SettingsInstance Auto

; PRIVATE VARIABLES ---------------------------------------------------------------------

; OIDs (T:Text B:Toggle S:Slider M:Menu, C:Color, K:Key)
int _lootHotkeyOID_K
int _takeDwarvenMetalsOID_B
int _closeContainerOnLootOID_B

; INITIALIZATION ------------------------------------------------------------------------

Event OnConfigInit()
    ModName = "Easy Loot Hotkey"
EndEvent

; EVENTS --------------------------------------------------------------------------------

Event OnPageReset(string asPage)
    if (asPage != "")
        return
    endif

    SetCursorPosition(0)
    AddHeaderOption("Preferences")

    SetCursorPosition(2)
    _lootHotkeyOID_K = AddKeyMapOption("Loot Hotkey", SettingsInstance.LootHotkey)

    SetCursorPosition(4)
    _takeDwarvenMetalsOID_B = AddToggleOption("Take Dwarven Metals", SettingsInstance.TakeDwarvenMetals)

    SetCursorPosition(6)
    _closeContainerOnLootOID_B = AddToggleOption("Auto-Close Containers", SettingsInstance.CloseContainerOnLoot)
EndEvent

Event OnOptionDefault(int aiOption)
    if (aiOption == _closeContainerOnLootOID_B)
        SettingsInstance.CloseContainerOnLoot = SettingsInstance.DEFAULT_CLOSE_CONTAINER_ON_LOOT 
        SetToggleOptionValue(_closeContainerOnLootOID_B, SettingsInstance.CloseContainerOnLoot)
    elseif (aiOption == _takeDwarvenMetalsOID_B)
        SettingsInstance.TakeDwarvenMetals = SettingsInstance.DEFAULT_TAKE_DWARVEN_METALS 
        SetToggleOptionValue(_takeDwarvenMetalsOID_B, SettingsInstance.TakeDwarvenMetals)   
    elseif (aiOption == _lootHotkeyOID_K)
        SettingsInstance.LootHotkey = SettingsInstance.DEFAULT_LOOT_HOTKEY
        SetKeyMapOptionValue(_lootHotkeyOID_K, SettingsInstance.LootHotkey)
    endif
EndEvent

Event OnOptionSelect(int aiOption)
    if (aiOption == _closeContainerOnLootOID_B)
        SettingsInstance.CloseContainerOnLoot = !SettingsInstance.CloseContainerOnLoot 
        SetToggleOptionValue(_closeContainerOnLootOID_B, SettingsInstance.CloseContainerOnLoot)
    elseif (aiOption == _takeDwarvenMetalsOID_B)
        SettingsInstance.TakeDwarvenMetals = !SettingsInstance.TakeDwarvenMetals 
        SetToggleOptionValue(_takeDwarvenMetalsOID_B, SettingsInstance.TakeDwarvenMetals)
    endif
EndEvent

Event OnOptionKeyMapChange(int aiOption, int aiKeycode, string asConflictControl, string asConflictName)
    if (aiOption == _lootHotkeyOID_K)
        SettingsInstance.LootHotkey = aiKeycode
        SetKeyMapOptionValue(_lootHotkeyOID_K, SettingsInstance.LootHotkey)
    endif
EndEvent

Event OnOptionHighlight(int aiOption)
    if (aiOption == _lootHotkeyOID_K)
        SetInfoText("The hotkey that will loot items when pressed.\nDefault: 'T'")
    elseif (aiOption == _takeDwarvenMetalsOID_B)
        SetInfoText("Whether Dwarven metals besides 'Dwarven Metal Ingot' should be taken from containers e.g. 'Dwarven Scrap Metal'.\nDefault: false")
    elseif (aiOption == _closeContainerOnLootOID_B)
        SetInfoText("Whether a container menu should be automatically closed after looting is complete.\nDefault: true")
    endif
EndEvent