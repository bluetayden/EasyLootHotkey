Scriptname EasyLootHotkeySettings extends SKI_QuestBase
{Config values for the EasyLootHotkeyScript, changes persist in the user's save game file. Modified via the EasyLootHotkeyMCM menu.}

; FIELDS ------------------------------------------------------------------------

; Constants
bool Property DEFAULT_CLOSE_CONTAINER_ON_LOOT = true AutoReadonly
bool Property DEFAULT_TAKE_DWARVEN_METALS = false AutoReadonly
int Property DEFAULT_LOOT_HOTKEY = 20 AutoReadonly ; 'T' key

; Script Ref
EasyLootHotkeyScript Property ScriptInstance Auto

; Public Settings
bool Property CloseContainerOnLoot = true Auto

bool Property TakeDwarvenMetals = false Auto

int Property LootHotkey
    int Function get()
        return _lootHotkey
    EndFunction
    
    Function set(int aiKeycode)
        ScriptInstance.UnregisterLootHotkey(_lootHotkey)
        _lootHotkey = aiKeycode
        ScriptInstance.RegisterLootHotkey(_lootHotkey)
    EndFunction
EndProperty

; Private Settings
int _lootHotkey = 20