# Easy Loot Hotkey

## Description
This is a small script that becomes active whenever you're inspecting a container, like a chest or NPC's inventory. When you press the `T` key on your keyboard, it will move all the "common" items from that container into your inventory.

Most of the time when you're looting in a dungeon, you don't need to pick up anything other than valuables and consumables from containers. So this hopefully covers most of those cases.

**Note:** This script is only really meant to be used on containers with a small amount of items. It slows down considerably (or just breaks) if you're working with a lot of them.

List of affected items:
- Gold
- Lockpicks
- Gems (VendorItemGem)
- Ores and Ingots (VendorItemOreIngot)
- Potions (VendorItemPotion)
- Amulets, Necklaces and Rings (ArmorJewelry, VendorItemJewelry, ClothingNecklace, ClothingRing)
- Soul Gems
- Keys
- Magic Scrolls
- Arrows (Ammo)

## Version Compatibility
This mod has only been tested for **Skyrim SE 1.6.1170**. It may not work with other versions.

## Requirements
- SKSE64
- SkyUI

## Installation
- Install using MO2.
- Alternatively, download the main file, drop it into your `Skyrim Special Edition/Data` directory, and extract the contents there.

## Usage
- Open a container in the game, and press the `T` key on your keyboard.
- You can configure the hotkey used for looting, as well as a few other preferences using MCM. Pause the game (`Esc` key) and navigate to `System > Mod Configuration > Easy Loot Hotkey`.

## Source Code
- The source for this mod can be found in the `Source/Scripts` directory of the main file.
- You can also find the [source on GitHub](https://github.com/bluetayden/EasyLootHotkey).
