Scriptname EasyLootHotkeyScript extends Quest  
{Loots "common" items from the current container on pressing the 'T' key}

int Property LootHotkey = 20 Auto  ; 'T' key  
int Property EscapeKey = 1 Auto  ; 'Esc' key  
string Property ContainerMenuName = "ContainerMenu" Auto  

Sound Property GoldPickupSound Auto  

Event OnInit()
    RegisterForKey(LootHotkey)
EndEvent

Event OnKeyDown(int keyCode)
    ; Don't do anything if the hotkey is wrong, or the ContainerMenu is not open
    if keyCode != LootHotkey || !UI.IsMenuOpen(ContainerMenuName)
        return
    EndIf
    
    ; Get the object the player was looking at before the ContainerMenu was opened. Assumes it's a container.
    ObjectReference kContainer = Game.GetCurrentCrosshairRef()

    ; Take the relevant items
    LootItems(kContainer)
EndEvent

Function LootItems(ObjectReference akContainer)
    int iNumTypesTaken = 0
    int iNumTotalTaken = 0
    int iFormIndex = akContainer.GetNumItems()

	While iFormIndex > 0
		iFormIndex -= 1
        Form kForm = akContainer.GetNthForm(iFormIndex)

        if ShouldLoot(kForm)
            int iNumOfType = akContainer.GetItemCount(kForm)
            akContainer.RemoveItem(kForm, iNumOfType, true, Game.GetPlayer())
            iNumTypesTaken += 1
            iNumTotalTaken += iNumOfType
        EndIf
    EndWhile

    ; Close the menu by simulating a press of the ESC key
    Input.TapKey(EscapeKey)

    ; Show items that were taken (if any), and play a sound
    if iNumTotalTaken > 0
        Debug.Notification("Looted " + iNumTypesTaken + " (x" + iNumTotalTaken + ") items from " + akContainer.GetDisplayName())
        GoldPickupSound.Play(Game.GetPlayer())
    EndIf
EndFunction

Function DebugLogLootableItems(ObjectReference akContainer)
    String sItemNames = ""
    Int iNumItems = akContainer.GetNumItems()

    Int iFormIndex = iNumItems
	While iFormIndex > 0
		iFormIndex -= 1
        Form kForm = akContainer.GetNthForm(iFormIndex)
        
        sItemNames += kForm.GetName() + " " + kForm.GetType() + " is "
        
        if (ShouldLoot(kForm))
            sItemNames += "lootable"
        else
            sItemNames += "not lootable"
        EndIf

        sItemNames += " | "
    EndWhile
        
    Debug.Notification("Opened " + akContainer.GetDisplayName() + " container. " + iNumItems + "x items inside.")
    Debug.Notification(sItemNames)
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

bool Function IsDwarvenJunk(string sFormName)
    bool bIsDwarven = StringUtil.Find(sFormName, "Dwarven") != -1
    bool bIsDwemer = StringUtil.Find(sFormName, "Dwemer") != -1
    
    if !bIsDwarven && !bIsDwemer
        ; The item isn't Dwarven
        return false
    EndIf

    ; There are a bunch of items under the "VendorItemOreIngot" Keyword that aren't actually ingots or ores.
    ; These include things like "Dwarven Scrap Metal" or "Large Decorative Dwemer Strut". So the easiest thing to do
    ; is just ignore everything except actual ingots.
    return sFormName != "Dwarven Metal Ingot"
EndFunction
