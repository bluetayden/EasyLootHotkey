Scriptname EasyLootHotkeyScript extends Quest  
{Loots "common" items from the current container on pressing a hotkey. Depends on configs from EasyLootHotkeySettings.}

; FIELDS ------------------------------------------------------------------------

; Constants
int Property ESC_KEY = 1 AutoReadonly
string Property CONTAINER_MENU_NAME = "ContainerMenu" AutoReadonly

; Public
EasyLootHotkeySettings Property SettingsInstance Auto
Sound Property GoldPickupSound Auto

; EVENTS ------------------------------------------------------------------------

Event OnInit()
    RegisterLootHotkey(SettingsInstance.LootHotkey)
EndEvent

Event OnKeyDown(int aiKeyCode)
    ; Don't do anything if the hotkey is wrong, or the ContainerMenu is not open
    if ((aiKeyCode != SettingsInstance.LootHotkey) || (!UI.IsMenuOpen(CONTAINER_MENU_NAME)))
        return
    endif

    ; Get the object the player was looking at before the ContainerMenu was opened. Assumes it's a container.
    ObjectReference kContainer = Game.GetCurrentCrosshairRef()

    ; Take the relevant items
    LootItems(kContainer)
EndEvent

; FUNCTIONS ---------------------------------------------------------------------

Function RegisterLootHotkey(int aiKeycode)
    RegisterForKey(aiKeycode)
EndFunction

Function UnregisterLootHotkey(int aiKeycode)
    UnregisterForKey(aiKeycode)
EndFunction

Function LootItems(ObjectReference akContainer)
    int iNumTypesTaken = 0
    int iNumTotalTaken = 0
    int iFormIndex = akContainer.GetNumItems()

    while (iFormIndex > 0)
        iFormIndex -= 1
        Form kForm = akContainer.GetNthForm(iFormIndex)

        if (ShouldLoot(kForm))
            int iNumOfType = akContainer.GetItemCount(kForm)
            akContainer.RemoveItem(kForm, iNumOfType, true, Game.GetPlayer())
            iNumTypesTaken += 1
            iNumTotalTaken += iNumOfType
        endif
    endwhile

    ; Show items that were taken (if any), and play a sound
    if (iNumTotalTaken > 0)
        Debug.Notification("Looted " + iNumTypesTaken + " (x" + iNumTotalTaken + ") items from " + akContainer.GetDisplayName())
        GoldPickupSound.Play(Game.GetPlayer())
    endif

    ; Close the menu by simulating a press of the ESC key
    if (SettingsInstance.CloseContainerOnLoot)
        Input.TapKey(ESC_KEY)
    endif
EndFunction

bool Function ShouldLoot(Form akForm)
    string sFormName = akForm.GetName()

    ; TODO: It would be better to use akForm.HasKeyword(), and store the target keywords as script properties/consts
    if sFormName == "gold" || \
       sFormName == "lockpick" || \
       akForm.HasKeywordString("VendorItemGem") || \
       akForm.HasKeywordString("VendorItemPotion") || \
       akForm.HasKeywordString("ArmorJewelry") || \
       akForm.HasKeywordString("VendorItemJewelry") || \
       akForm.HasKeywordString("ClothingNecklace") || \
       akForm as SoulGem || \
       akForm as Key || \
       akForm as Scroll || \
       akForm as Ammo || \
       (akForm.HasKeywordString("VendorItemOreIngot") && !IsDwarvenJunk(sFormName))
        return true
    EndIf

    return false
EndFunction

bool Function IsDwarvenJunk(string asFormName)
    if (SettingsInstance.TakeDwarvenMetals)
        ; If the user wants to loot Dwarven items, return false early
        return false
    endif

    bool bIsDwarven = StringUtil.Find(asFormName, "Dwarven") != -1
    bool bIsDwemer = StringUtil.Find(asFormName, "Dwemer") != -1

    if (!bIsDwarven && !bIsDwemer)
        ; The item isn't Dwarven
        return false
    endif

    ; There are a bunch of items under the "VendorItemOreIngot" Keyword that aren't actually ingots or ores.
    ; These include things like "Dwarven Scrap Metal" or "Large Decorative Dwemer Strut". So the easiest thing to do
    ; is just ignore everything except actual ingots.
    return asFormName != "Dwarven Metal Ingot"
EndFunction