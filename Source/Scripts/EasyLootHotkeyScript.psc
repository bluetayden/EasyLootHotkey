Scriptname EasyLootHotkeyScript extends Quest  
{Loots "common" items from the current container on pressing the 'T' key}

Int Property LootHotkey = 20 Auto  ; 'T' key  
Int Property EscapeKey = 1 Auto  ; 'Esc' key  
Int Property EventPollTime = 1 Auto  
String Property ContainerMenuName = "ContainerMenu" Auto  

Sound Property GoldPickupSound Auto  

Event OnInit()
    RegisterForKey(LootHotkey)
EndEvent

Event OnKeyDown(int keyCode)
    ; Don't do anything if the hotkey is wrong, or the ContainerMenu is not open
    if keyCode != LootHotkey || !UI.IsMenuOpen(ContainerMenuName)
        return
    EndIf
    
    ; Get the object the player was lookking at before the ContainerMenu was opened. Assumes it's a container.
    ObjectReference kContainer = Game.GetCurrentCrosshairRef()

    ; Take the relevant items
    LootItems(kContainer)
EndEvent

Event OnUpdate()
    RegisterForSingleUpdate(EventPollTime)
EndEvent

Function LootItems(ObjectReference akContainer)
    Int iNumTypesTaken = 0
    Int iNumTotalTaken = 0
    Int iFormIndex = akContainer.GetNumItems()

	While iFormIndex > 0
		iFormIndex -= 1
        Form kForm = akContainer.GetNthForm(iFormIndex)

        if ShouldLoot(kForm)
            Int iNumOfType = akContainer.GetItemCount(kForm)
            akContainer.RemoveItem(kForm, iNumOfType, true, Game.GetPlayer())
            iNumTypesTaken += 1
            iNumTotalTaken += iNumOfType
        EndIf
    EndWhile

    ; Close the menu by simulating a press of the ESC key
    Input.TapKey(EscapeKey)

    ; Show items that were taken (if any), and play a sound
    if iNumTotalTaken > 0
        Debug.Notification("Looted " + iNumTypesTaken + " (x" + iNumTotalTaken + ") common items from " + akContainer.GetDisplayName())
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
        
    Debug.Notification("Opened " + akContainer.GetDisplayName() + " container. " + iNumItems + "x items inside")
    Debug.Notification(iFormIndex + "x items inside");
    Debug.Notification(sItemNames)
EndFunction

bool Function ShouldLoot(Form akForm)
    ; TODO: Probably would be better to use akForm.HasKeyword(), and store the target keywords as script properties

    if akForm.GetName() == "gold" || \
       akForm.GetName() == "lockpick" || \
       akForm.HasKeywordString("VendorItemGem") || \
       akForm.HasKeywordString("VendorItemOreIngot") || \
       akForm.HasKeywordString("VendorItemPotion") || \
       akForm.HasKeywordString("ArmorJewelry") || \
       akForm.HasKeywordString("VendorItemJewelry") || \
       akForm.HasKeywordString("ClothingNecklace") || \
       akForm as SoulGem || \
       akForm as Key || \
       akForm as Scroll || \
       akForm as Ammo
        return true
    EndIf

    return false
EndFunction
