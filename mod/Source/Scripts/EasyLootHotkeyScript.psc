Scriptname EasyLootHotkeyScript extends Quest  
{Loots "common" items from the current container on pressing a hotkey. Depends on configs from EasyLootHotkeySettings.}

; FIELDS ------------------------------------------------------------------------

; Constants
int Property ESC_KEY = 1 AutoReadonly
string Property CONTAINER_MENU_NAME = "ContainerMenu" AutoReadonly ; Vanilla Container Menu
string Property QUICKLOOT_MENU_NAME = "LootMenu" AutoReadonly ; QuickLoot IE (Mod) Menu

; Public
EasyLootHotkeySettings Property SettingsInstance Auto
Sound Property GoldPickupSound Auto

; EVENTS ------------------------------------------------------------------------

Event OnInit()
    RegisterLootHotkey(SettingsInstance.LootHotkey)
EndEvent

Event OnKeyDown(int aiKeyCode)
    bool bIsQuickLootOpen = UI.IsMenuOpen(QUICKLOOT_MENU_NAME)

    ; Return early if the hotkey is wrong, or a container menu is not open
    if ((aiKeyCode != SettingsInstance.LootHotkey) || !(UI.IsMenuOpen(CONTAINER_MENU_NAME) || bIsQuickLootOpen))
        return
    endif

    ; Get the object the player was looking at before the container menu was opened. Assumes it's a container.
    ObjectReference kContainer = Game.GetCurrentCrosshairRef()

    ; Take the relevant items
    LootItems(kContainer, bIsQuickLootOpen)
EndEvent

; FUNCTIONS ---------------------------------------------------------------------

Function RegisterLootHotkey(int aiKeycode)
    RegisterForKey(aiKeycode)
EndFunction

Function UnregisterLootHotkey(int aiKeycode)
    UnregisterForKey(aiKeycode)
EndFunction

Function LootItems(ObjectReference akContainer, bool abQuickLootWasOpen)
    int iNumTypesTaken = 0
    int iNumTotalTaken = 0
    int iFormIndex = akContainer.GetNumItems()

    ; Iterate over all items in the container
    while (iFormIndex > 0)
        iFormIndex -= 1
        Form kForm = akContainer.GetNthForm(iFormIndex)

        if (ShouldLoot(kForm))
            ; And move them into the player's inventory if relevant
            int iNumOfType = akContainer.GetItemCount(kForm)
            akContainer.RemoveItem(kForm, iNumOfType, true, Game.GetPlayer())
            iNumTypesTaken += 1
            iNumTotalTaken += iNumOfType
        endif
    endwhile

    if (iNumTotalTaken > 0)
        ; Show items that were taken (if any), and play a sound
        Debug.Notification("Looted " + iNumTypesTaken + " (x" + iNumTotalTaken + ") items from " + akContainer.GetDisplayName())
        GoldPickupSound.Play(Game.GetPlayer())
    else
        Debug.Notification("No relevant items were found in " + akContainer.GetDisplayName())
    endif

    ; Close the container menu by simulating a press of the ESC key. Note: the QuickLoot mod has a menu that runs
    ; "in-world", so we skip in that case, because trying to close it would just open the pause menu.
    if (SettingsInstance.CloseContainerOnLoot && !abQuickLootWasOpen)
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