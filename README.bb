[b][u]Description[/u][/b]
This is a small script that becomes active whenever you're inspecting a container, like a chest or NPC's inventory. When you press the [font=Courier New]T[/font]
 key on your keyboard, it will move all the "common" items from that container into your inventory.

Most of the time when you're looting in a dungeon, you don't need to pick up anything other than valuables and consumables from containers. So this hopefully covers most of those cases.

[b]Note:[/b] This script is only really meant to be used on containers with a small amount of items. It slows down considerably (or just breaks) if you're working with a lot of them.

List of affected items:
[list]
[*]Gold
[*]Lockpicks
[*]Gems (VendorItemGem)
[*]Ores and Ingots (VendorItemOreIngot)
[*]Potions (VendorItemPotion)
[*]Amulets, Necklaces and Rings (ArmorJewelry, VendorItemJewelry, ClothingNecklace, ClothingRing)
[*]Soul Gems
[*]Keys
[*]Magic Scrolls 
[*]Arrows (Ammo)
[/list]
[b][u]Version Compatibility[/u][/b]
This mod has only been tested for [b]Skyrim SE 1.6.1170[/b]. It may not work with other versions.

[b][u]Requirements[/u][/b]
[list]
[*]SKSE64
[*]SkyUI
[/list]
[b][u]Installation[/u][/b]
[list]
[*]Install using MO2.
[*]Alternatively, download the main file, drop it into your "[font=Courier New]Skyrim Special Edition/Data[/font]" directory, and extract the contents there.
[/list]
[b][u]Usage[/u][/b]
[list]
[*]Open a container in the game, and press the [b]T[/b] key on your keyboard. 
[*]You can configure the hotkey used for looting, as well as a few other preferences using MCM. Pause the game ([b]ESC[/b] key) and navigate to [b]System > Mod Configuration > Easy Loot Hotkey[/b].
[/list]
[b][u]Source Code[/u][/b]
[list]
[*]The source for this mod can be found in the "[font=Courier New]Source/Scripts[/font] directory" of the main file. 
[*]You can also find the [url=https://github.com/bluetayden/EasyLootHotkey]source on GitHub[/url].
[/list]