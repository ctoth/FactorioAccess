# Version 0.11.2 BETA
Released on May 17th, 2024.

## Summary
- This minor update brings several small new features, tweaks, and bugfixes across the board based on recent feedback, with special thanks this week to @ahicks. Improvements include better info and controls regarding personal logistics, rail signals, the scanner list, and the Kruise Kontrol feature.

## Features
- Added inserter hand stack size tuning from their menus.
  * Press PAGEUP or PAGEDOWN to edit
  * Alternative controls: ALT + UP/DOWN
  * Setting it to 0 restores the default (maximum available) value.

- Added freeform placement of rail signals next to straight rails.
  * Like in vanilla gameplay, you can now drop a rail signal at a candidate position next to a straight rail and it will automatically rotate itself.
  * The rule is that the signal should always be on the right hand side with respect to the direction of travel along the rail.
  * Preview checks have been added as well.
  * Disconnected rail signals will now also report that they are not working.

- Added diagonal rail fork building options to the rail builder.
  * Also extended the lengths of the forward exit segments built for cardinal direction rail forks.

- The player logistic info summary now lists how many unfulfilled requests you have and what the missing items are.

- For a selected item, its logistic request slot can now be entirely cleared by pressing "CONTROL + SHIFT + ALT + L".

## Changes
- Personal logistic requests can now be edited from the crafting menu, so you no longer need to have the items on hand.
  * The first item product of each recipe is selected.
  * The few items that you cannot craft by hand are missing, but this tweak is intended as a temporary Q.O.L. improvement until we build a dedicated logistics requests menu.

- Distance and direction and alignment checks have been revised.
  * The algorithm to check alignment has been simplified: All positions are floored to the northwest corner of the respective tile.
  * An entity reported by the scan list now reports the cursor position at the northwest corner rather than the entity's center position. Therefore alignment using the scan list considers the northwest corner.
  * Cursor distance and direction vectors now use the same calculations as the alignment checks to ensure that they agree.

- The scan list categories have been expanded.
  * There are now three types of buildings: logistics buildings, production buildings, and other buildings. The categories match the vanilla groupings of the buildings.
  * Train stops are still listed along with vehicles, as an exception for the sake of convenience.
  * A category for ghosts has been added.

- The scan list, as an exception, selects curved rails from the center instead of the northwest corner.
  * This is done because usually the northwest corner of a curved rail's rectangle is a few tiles away from it.

- Kruise Kontrol status prediction has been significantly improved.
  * Factorio Access now use identical checks as Kruise Kontrol to predict what the initial state will be when the feature is activated.
  * Factorio Access is now better able to predict whether KK has arrived at a walking or driving destination, or has finished building related tasks.
  * In general, though, if the character seems to be doing nothing during KK, we recommend pressing "ENTER" to cancel it and re-sync the mods.

- Kruise Kontrol can now be activated without opening Remote View if the target location is not distant.
  * This also makes its behavior more predictable.

- Revised sub-automatic train travel to make it easier to use.
  * Setting this now makes the train head directly to the temporary station and switch to manual control upon arriving and instantly removing the temporary station.
  * Therefore you can set a train back to automatic after you arrive and let it resume its schedule with minimal fuss.

- Cursor skipping now reacts to entering and exiting an area with water.

- Improved reporting of the top item contents of trains and logistic networks.
  * Large numbers are simplified, such as numbers greater than 10 thousand being floored to the nearest thousand.
  * The top 10 items are listed instead of top 3 or 5.

- Every mod menu now says its name after you open it, making it easier to follow along.
  * Most menus did this already, but it was added for those left over: fast travel, structure travel, rail builder, warnings.

- Added information to notify that pressing "ALT + L" toggles personal logistic requests.
  * This is a vanilla game feature that applies in any menu.

- Added information to notify that a spidertron can only be driven manually during smooth walking mode.

## Bugfixes
- Fixed a bug that made teleporting to a ghost delete that ghost.

- Fixed a crash due to opening the inventory while still waiting to respawn.

- Fixed a bug that prevented info reports about tile pavement previews.

- Fixed some crashes related to the unfinished ghost rail planner support feature.

- Fixed electric poles reporting supplied buildings incorrectly because the reports were also counting flying robots.


# Version 0.11.1 BETA
Released on May 13th, 2024.

## Summary
- This update features the second phase of the refactoring of the codebase into modules, making it easier to follow and maintain. It is also accompanied by some small additions, changes, and bugfixes. Improved systems include the launcher, Remote View, Kruise Kontrol, fast travel, and the rail builder. While a fair amount of testing has been done, new bugs may still emerge due to the refactor.

## Info
- The second part of the refactoring into modules was completed.
  * Files with multiple modules in them were split so that every module has one file and vice versa.
  * Any Lua module being referenced within its own file is now called "mod" for brevity and simplicity. 
  * All Lua modules related to the runtime stage were moved to a "scripts" folder, matching modding conventions.
  * Cleaned up several todo comments.
  * More refactor work is needed later, to further clean up "control.lua".

- Started using the GitHub Issues system to track all issues and some feature requests. The Discord channels will still be open for use but the goal is to log everything on GitHub.

- Added a document that provides info for contributors, as a starting point for explaining how the mod code works.

- Moved to using StyLua to standardize code formatting. It needs to be run after you finish making changes. GitHUb actions were added so that every commit is now checked for StyLua compliance.

- A new menu system and other code infrastructure is being designed by @ahicks. It is being tested right now for circuit networks code and may be applied to the rest of the codebase later so that more flexible and useful menu designs can be supported later on.

## Features
- The rail builder now supports adding left forks and right forks, giving a total of 4 possible forks.

- Launcher: Added braille display support so that mod readouts are also written to the displays.

## Changes
- When reading the relative direction of the cursor or a scan list entry, if it is fully aligned in that cardinal or diagonal direction, the game will now also read out "aligned".

- Checking for the nearest damaged entity will now also jump the cursor to the entity, making it easier to target it.

- Items in hand can now have their logistic requests edited while the trash menu is open.
  * You can now also check the request info for an item in a slot of the trash inventory, but you need to take it in hand to edit its requests. This is good because editing the requests for an item might have it automatically flushed out of the trash inventory without warning.

- Closing the fast travel menu no longer returns the cursor to the player, and the cursor being jumped to a point when it is selected is now stated openly.

- Tweaked the early tutorial chapters to improve clarity. Notably, added reminders to empty the hand, and switched to using chests instead of pipes as reference points for placing burner inserters.

- Improved integration for the mod Kruise Kontrol, by Klonan.
  * KK actions will now be possible while in telestep mode.
  * Pressing any walking key will no longer cancel KK actions because this was not working correctly. You must press "ENTER" to cancel actions.

- Added a system for independently predicting and reporting the Kruise Kontrol status. 
  * The status checks what was targeted to initiate Kruise Kontrol and is updated accordingly.
  * The status is reported regularly, although this report is often interrupted by cursor readouts.
  * If the status was walking and the player has reached the destination and has not moved for 1 second, then the status automatically is assumed to be arrived.
  * For other cases, the status reporting is finished only when you cancel Kruise Kontrol by pressing "Enter", because there may be ongoing actions despite the player standing still at the target location.

- Bumping into objects no longer makes an alert beep but you still hear the sound of a striking metal boot or sliding gravel.

- Improved info about saving times. The mod suggests waiting 3 seconds although generally it takes less than 1 second.

- Launcher: Improved command line parameter handling.

## Bugfixes
- Fixed a locale error about teleporting the cursor.

- Fixed lab module slots being incorrectly labelled as reserved for science packs.

- Fixed an issue with the handling of the undocumented direction number 8, which represents "here". It is read out as an empty string.

- Fixed a crash due to loading a cursor bookmark before having set any.

- Fixed a crash when using area mining to clear rail objects including signals.

- Fixed footstep sounds being wrongly played while navigating through menus.

- Fixed several bugs that were placing the mouse pointer incorrectly while in Remote View, and so interfering with Kruise Kontrol.

- Fixed a crash that occurs while rotating buildings.

- Fixed some invalid keybinds.

- Re-fixed the playing of multiple mining sounds while mining a resource.

- Fixed some mod features interfering with vanilla mode.


# Version 0.11.0 BETA - EXPERIMENTAL
Released preview 0.11.0e1 on April 27th, 2024.

## Summary
- This update is mostly about changes under the hood while the mod codebase is being refactored so that the code is easier to follow and maintain, for contributors both new and old. The update also includes some bug fixes and small improvements, but the refactor has caused new bugs. Extensive testing is needed to find and fix the new bugs. Therefore this release is labeled as "experimental" and is recommended only to players who are interested in bug hunting.

## Info
- Started to significantly refactor the mod codebase, with huge help from @eph and @ahicks.
  * The aim is to make the code easier to follow and maintain, for contributors both new and old.
  * Improved the explanations of functions, and renamed several of them to more accurate or concise names.
  * Moved most functions into Lua modules that have their own lua files and are required by other files as local objects, as per best practices. This makes it easier to examine independent modules and their dependencies.
  * Added "fa-info-for-contributors.md" as an introductory resource for contributors. 
  * Fixed several IDE warnings.
  * Further work is underway for simplifying event handlers and other functions inside "control.lua" by moving their contents into smaller functions inside appropriate modules.
  * The refactor introduced some new bugs, and many of them have been found and fixed. However, further testing is needed so that other bugs can be found and/or fixed.

## Features
- None.

## Changes
- Color info was added to descriptions of electronic chips and transport belts, because the colors are commonly used by the community to distinguish them.

- Added alternate keybinds for increasing and decreasing chest locked slots and train wait times: You can use "ALT + UP" / "ALT + DOWN" instead of "PAGE UP" / "PAGE DOWN". You can also use "SHIFT"/"CONTROL" and "UP"/"DOWN" instead of "SHIFT"/"CONTROL" and "PAGE UP"/"PAGE DOWN".

## Bugfixes
- Fixed a stray textbox bug that softlocks the game. Closing any menu should now remove stray GUI elements such as these textboxes. Also, pressing ENTER to confirm these textboxes now closes them too.

- Pressing "RIGHT BRACKET" on a blueprint in the inventory now does nothing instead of deleting it.

- Train menu: Fixed an updating issue with the single time travel feature so that it resets correctly.


# Version 0.10.1 BETA
Released on April 13th, 2024.

## Summary
- This update comes after some restructuring of the mod repository and joining the official Factorio Mod Portal. Note that releases still need to be installed from the GitHub page because of the launcher and config changes required to run the mod properly. The update itself includes tweaks, additions, and bugfixes across the board thanks to community feedback. Notably, several blueprint bugs have been fixed and Remote View has been added. 

## Info
- The mod's GitHub repository has been moved to a new address to make contributions easier: https://github.com/Factorio-Access/FactorioAccess. Hyperlinks to it have been automatically updated.

- The mod's wiki has been moved to this address as well, and hyperlinks to it have been updated manually. You may need to update your own wiki related browser bookmarks.

- The mod has now been officially added to the Factorio Mod Portal, but please note that downloading and installing it from the portal does not make it playable. You still need to use the mod launcher for vocalization and also making game configuration changes to accommodate this mod. Therefore please use the GitHub releases page and follow the install instructions.
    
- Release folder contents now include mod dependency info and a mod portal compatible changelog, which is what prompted formatting changes for the main changelog.

- Settings for configuring other mods are now updated using data stage code, as it should be. Meanwhile, the feature for in-game settings changing is still being worked on.

## Features
- Added Remote View, which is when the camera and microphone focuses on the player's cursor instead of the player's character. Press "ALT + I" to toggle it.
  * Press arrow keys to move the cursor in remote view. Do not use the "W" "A" "S" "D" keys because this makes the camera pan too fast in a way we cannot control.
  * This view allows focusing on distant locations, although blurred or uncharted areas offer limited info and no sounds. You need to keep them fully loaded using radars.
  * Remote view automatically opens and closes Cursor Mode along with itself.
  * For now, most sounds are muffled in remote view, but this will be fixed. 

- Added basic support for the Kruise Kontrol mod, which allows automatic walking to the cursor location.
  * Press "CONTROL + ALT + RIGHT BRACKET" twice, to first open the cursor location in remote view, and then to instruct an action.
  * Usually the action is to walk or drive to that spot. Special cases include selecting a resource to start mining it, selecting a ghost to start building them, selected a descontruction marked building to start removing them, selecting trees to start chopping them, and selecting enemies to start fighting them.
  * Press "ENTER" to cancel ongoing actions. Some actions may be unclear at times so this is recommended if things are taking to long.
  * The character cuts trees along their automatic walking paths.

- The pollution level at the cursor position can now be read, by pressing "SHIFT + U". Note that "high" pollution is usually when trees start taking pollution damage. Other than that, the most important thing to track regarding pollution is how heavily polluted enemy spawners are, which can be checked with the scanner tool.

- The scanner can now locate the nearest damaged entity of the player's own team, by pressing "SHIFT + P". This has a range limit of 1000 tiles.

## Changes
- Launcher: Changed the description of the Compass Valley preset to make it more beginner friendly.

- Cursor area scanning now reports coverage percentages only for ground tiles. It also notes whether there are other things in the area after listing the first 4 things.

- Cursor area scanning now updates the scan result list properly so that the list can be used to examine in detail what is within the area.

- Cursor size options now include 51 by 51.

- Minor revisions were made in some tutorial steps for clarity.

- Checking technology info now also reads the localised description of the technology. Technology required ingredient names have been localised too.

- You can now teleport from the structure travel menu as well.

- Alternate controls for SCAN-UP and SCAN-DOWN have been changed to "ALT + UP" and "ALT + DOWN". The main controls are still "PAGEUP" and "PAGEDOWN".

## Bugfixes
- Fixed a mod initialization crash that was preventing it from running on dedicated servers.

- Removed deprecated cursor release keybind, which was interfering with rail analysis.

- Fixed the incorrect reporting of blueprint dimensions from inside the blueprint menu.

- Fixed a crash during the re-selection of blueprints with no names or descriptions.

- Fixed a crash during the reading of blueprints with invalid items or icons in them, such as old science pack versions.

- Fixed the ambiguity about the "electronics" technology having no direct unlocks.

- Fixed the input for locking 5 inventory slots of chests.

- Fixed some mod menu typos.


# Version 0.10.0 BETA
Released on April 6th, 2024.

This update features a full rewrite of the mod tutorial to include new chapters and details. Please note that the new tutorial may need more tweaking despite being reviewed, so feel free to get in touch about issues or suggestions. The update also has some launcher improvements such as mod management, as well as small additions and changes to improve the early game, and some changes thanks to community feedback.

## New features

- The tutorial has been rewritten, doubling in length. The game should now be more accessible to new players.
  * There are now 12 chapters covering everything up to producing logistic science packs, and general tips chapter at the end.
  * There is a total of over 300 steps in total, with generally only 1 or 2 instructions per step.
  * Recently added features such as blueprints, cursor skipping, and steam engine snapping have been included.
  * If you had started the tutorial before this update, jumping back to its start is recommended so that you can reset to the new version and then skip doing the steps that you have already covered. You can jumping back to the start by pressing "ALT + SHIFT + H" a few times. 
  * The tutorial needs further testing and will continue to receive minor tweaks. Experienced players are invited to give it a try as well, for review assistance.

- New launcher version, with the following additions and changes:
  * Added a mod management menu, for other mods. You can now enable or disable other mods here so that you no longer need to delete a mod to remove it.
  * Saving the game now plays beeps at the start and end of it, instead of speaking a message that interrupts other speech.
  * The launcher now loads much faster.
  * Fixed a bug so that a missing translation key returns English text instead of an error.

- Added steam engine snapped building.
  * Press "CONTROL + LEFT BRACKET" with a steam engine in hand to try automatically building a correctly positioned steam engine next to the first free boiler found within 25 tiles.
  * Mainly added because when you first need steam engines in the first hours of the game you are still new to building.
  * Does not snap to anything else.
  * You still need to clear the building area manually, inlcuding stepping out of the way.

- You can now read the cursor position distance as a vector from the character position by pressing "ALT + K".
  * This reports the vertical and horizontal distances separately, without giving an average compass direction.
  * This information is useful for building belts and pipes because you'll get the exact distances to cover since they cannot connect to each other diagonally.

- A selected fluid in a building can now be permanently flushed away by pressing "X".

- The blueprint menu now has the option to re-select the blueprint's area, while keeping its original name and descriptions and icons.

## Changes

- Autosaving now makes two click sounds in the background to signal its start and end, instead of interrupting speech output.

- Reading a tile now also comments about its visibility information.
  * An uncharted tile is labelled as so. You cannot know what is there and it might not even be generated yet.
  * A charted tile that is more than about 100 tiles away from the nearest player or powered radar is blurred by the game, and it is now also labelled as so. A blurred area has minimal information about what is happening there and produces no sounds even though machines continue to work and enemies continue to move. Tile blurring affects some but not all remote interactions, and sighted players prefer to spread radars around to keep most factory areas continuously visible. 
  * For a camera centered on the player, which is the default case, a tile that is outside the camera view is outside the rendered screen area and is now labelled as "distant". This affects some actions involving remote controls, although we have tried to minimize the dependency on doing things on screen. You can use the mouse wheel to zoom in and out, which changes camera coverage.

- The tutorial now gifts one stack of coal as part of your emergency supply kit that is already provided at the start of the game. This is important for teaching game mechanics in a clean order. This gift switched from rocket fuel to coal in order to simplify the process and not offer a significant advantage.

- Steam engine direction reporting now says "north and south", or "east and west", to acknowledge that the building is symmetrical.

- A selected water tile is now labelled as "open" or "shore" or "crevice", depending on the arrangement of other water tiles around it.

- A pipe end is now identified as a special case where a pipe has less than 2 connections. This is worth noting because it means the pipe does not lead to anything.

- Pipe ends are now distinguished from other pipes in the scanner list.

- Pipes and storage tanks are now distinguished in the scanner list by the fluid contained.

- Storage tanks are now categorized as containers in the scanner list.

- When you successfully build a pipe to ground unit, the building direction in hand is flipped 180 degrees so that the other end can be built quickly.

- The pipe to ground building preview now also reports information about the above ground connection preview.

- Removed unnecessary repetition of "per cycle" when listing recipe ingredients.

- Checking the status of an enemy spawner now reveals the enemy evolution factor.

- Tweaked names of curved rail and diagonal rail directions to improve clarity.

- Removed the default descriptions from science packs and modules so that the mod's custom descriptions would apply.

## Bugfixes

- Fixed incorrect reporting of player weapons when you switch a vehicle weapon. 
  * Note: Reading out the correct vehicle weapon has not been added yet.
  
- If the pipe to ground preview finds multiple successful underground connections, the closest one is now taken, which is the correct case.

- Fixed a localisation error for when you start crafting a recipe.

- Fixed self-interrupting reminders at the start of the game.


# Version 0.9.1 BETA
Released on March 19th, 2024.

This is a quick update based on feedback for 0.9.0.

## New features

- Added support for programmable speakers.
  * You can use them to set up audio alerts based on circuit conditions. 
  * You also can get creative with them like by connecting speakers along a transport belt to play music.

## Changes

- None.

## Bugfixes

- Fixed the signal selector crashing when the end of a group is reached.


# Version 0.9.0 BETA
Released on March 15th, 2024.

This major update introduces support for circuit networks, and several improvements to vehicle driving, and manual control over player logistic trash. Please check the details for other tweaks and fixes.

## New features

- Added circuit network support for the most popular features. 
  * Circuit networks allow you to tune your factory by reading signals from machines and instructing other machines to act according to signal values.
  * You can create circuit networks by connecting applicable buildings with red or green circuit wires, as discussed in update 0.8.3. Everything connected to the same wire without interruption is part of the same network. You can connect circuit wires to electric poles as well.
  * Different buildings can have different reading or operation modes for the circuit network. The most used feature is enabling the operation of a machine, such as a pump or a belt or an inserter, based on a circuit signal's condition. For example, you can activate a belt unit to feed coal to your steam power system when your accumulators are running low on charge.
  * To open the circuit network menu for a machine, press 'N' when you select it with the cursor or after opening its menu.
  * In the circuit network menu you can examine the network connections and also configure the machine's modes and its enabling condition.
  * For a machine with an enabling condition, you can check if the condition is met at the moment by checking the machine's status. It will be either disabled by control behavior or have a different status such as working.
  * Note that to connect a gate, you actually need to connect to the wall unit next to the gate.
  * For circuit network features that are not implemented into the mod yet, feel free to make requests.
  
- Added signal selector menu.
  * You can use this menu to select signals when setting up a constant combinator or an enabling condition on another machine.
  * Signals can include items or fluids. They also include virtual signals such as signal channels labeled using letters or digits or colors.
  * Special virtual signals include the "everything" signal that checks every nonzero signal at the same time, and the "anything" signal that passes for any nonzero signal.
  * The signal selector supports menu search. 

- Added first version of driving proximity alert.
  * When driving a car or tank or train forward or while stopped, the nearest entity ahead will beep. 
  * When driving in reverse, the nearest entity behind is checked instead.
  * Nearer entities will beep faster. The alert distances for cars are 50 meters, 25 meters, 10 meters, and 3 meters. For trains, these distances are trippled.
  * For trains, the entity must be not part of the same train and it must be on rails, although this includes disconnected rails that would actually be safe from this train. The distance reference looks only at the wagon or locomotive that you are riding and not the whole train.
  * You can press 'J' while driving to identify what last beeped and its distance, if you are still facing it.
  * Entities that you can pass over or under without crashing will not beep.
  * This feature does not yet detect water bodies. Your vehicle might still snag into water shores but it will not be damaged from it.
  * Despite the added alerts, it is recommended to drive slowly, perhaps using the newly added cruise control mode.
  
- Integrated the mod Vehicle Snap.
  * This mod makes a moving car or tank lock to one of the 8 main directions after you press 'A' or 'D' to turn it.
  * This way you can maintain a heading a lot more easily.
  * It does not work while pavement driving assistance is active.
  
- Integrated the mod Pavement Driving Assist Continued.
  * This mod allows cars and tanks to follow paved roads automatically, such as stone brick or concrete roads. Exiting a road produces an alert with 3 beeps.
  * A good road width to use is 5 tiles, and turns need to include diagonal sections, although the diagonals can be short, like for 5 tiles.
  * The driving assistant can be enabled by pressing 'L'. This will disable vehicle direction snapping.
  * The cruise control system can be enabled by pressing 'O'. This is recommended because it keeps the car speed at 35 kilometers per hour. You can stop and start with 'W' and 'S' during cruise control so that the speed changes between 0 and 35.
  * You can type in a new cruise control speed by pressing 'CONTROL + O'. Note that the driving assistant requires a minimum speed of 21 kilometers per hour.
  * The mod also introduces some extra tools such as stop signs for automatic vehicles to interact with.
  * The mod technology needs to be unlocked with research, although the basic tools are unlocked just with logistic science.
  
- Added manual control over player logistic trash.
  * You can now directly send the cursor stack or the selected inventory stack to your logistic trash by pressing 'O'.
  * The logistic trash inventory can now be accessed when it is unlocked, as a new tab of the player menu, after "technologies".
  * This inventory has a fixed size of 3 rows of 10 slots each.
  * This inventory can be searched.
  * You can take items in hand from this menu and press 'Q' to restore them to the inventory, unless logistic limits throw it back into trash automatically.
  * You can check slot coordinates and item descriptions from this menu.
  
## Changes 

- Reading the rail structure ahead is now run by pressing 'SHIFT + J' and reading the structure behind is now run by pressing 'CONTROL + J'. This is because pressing only 'J' is reserved for reporting entities that raise the driving proximity alert.

- Cursor skip special case for underground segments: Skipping from one end towards the underground direction of an underground belt chute or pipe to ground will bring the cursor to the other end.

- Updated constant combinator support to use the circuit menu.
  * As a new feature, you can now change the count of the last added signal.
  * Other combinators are not supported yet.
  
- Revised item and entity descriptions (in English) to improve accuracy, fix typos, and include entries that did not exist before.

- Vehicle trunks, and the player inventory opened through a building menu, can now use menu search.

- Tweaked the inventory transfer shortcut, the one via pressing 'CONTROL + LEFT BRACKET' on an empty slot.
  * You can no longer transfer blueprints and blueprint books this way because this custom code does not preserve blueprint data. Other shortcuts work fine.
  * Identified a bug where if you try to do this more than once, the code always makes the building transfer to the player, unless you re-open the building's menu.
  
- Restored cursor mode usage while driving and improved the issue of vehicles moving when you move the cursor.
  * Moving cars and tanks will slow down.
  * Stopped cars and tanks will not move.
  * Moving trains with manual control will slow down.
  * Stopped trains with manual control will fidget much less than before.
  * Spidertrons and automatic trains should not be affected.
  
- Improved vehicle direction and speed reporting.
  * Heading and speed is now reported before the vehicle name.
  * Spidertron heading is irrelevant so it is not reported.
  
- Building reserved slot reporting now uses the localised names and the amounts of ingredients and products per recipe cycle.

- Splitter priority direction reading now gives the compass direction too.

- The player or spidertron logistic requests summary info from the 'L' key, now reports whether the player or spidertron is in the construction or logistic range of the nearest roboport network. Note that the logistic range is 25 tiles and the contruction range is 55 tiles.

- The roboport menu's info options are now simply introduced when selected, and are activated when clicked using 'LEFT BRACKET'.

## Bugfixes

- Fixed a crash while reading fluid descriptions.

- Fixed a recent bug where empty inventory slots were not being reported.

- Fixed crashes due to inventory transfer result reporting, by shortening the results lists to 5 individually named items at most.

- Fixed a warnings menu bug where a furnace with its output full would be listed instead as out of fuel.


# Version 0.8.4 BETA
Released on March 9th, 2024.

In this medium-sized quality-of-life update there are several tweaks and additions based on community feedback. Additions include fast travel point descriptions and cursor skipping and vehicle horns. Changes include improvements to crafting menus, production statistics, and inserters.

## New features

- Fast travel points can now have descriptions attached to them. They can be read or changed from the fast travel menu.

- Added cursor skipping for cursor mode, as suggested by @ohylli.
  * When you press SHIFT + a walking direction key, the cursor now moves in that direction and skips over repeating tiles until it reaches a change point.
  * Crossing from an entity to empty ground counts as a change.
  * Crossing from empty ground to an entity counts as a change.
  * Crossing between two entities with different names counts as a change.
  * Crossing between two transport belt units with different neighbor counts or shapes also counts as a change.
  * Crossing between two entities with the same name does not count as a change unless they are facing different directions.
  * One skip has a maximum distance of 100 tiles, but you can instruct another skip afterward.
  * The character does not skip along with the cursor but you can always teleport to it.

- You can now honk a vehicle horn by pressing 'V'.
  * There are different sounds for cars, tanks, and trains.
  * Trains still honk by themselves in different ways to indicate safety issues.
  * Spidertrons honk like cars but anyone is welcome to recommend a unique sound.

- Trains now make a clacking sound when turning at a curved rail.

- The base ingredients needed to craft a recipe can now be listed by pressing 'SHIFT + K'. Right now this does not include the counts.

- Constant combinators now read their on/off state and this can be toggled by pressing 'LEFT BRACKET' on them.

## Changes 

- Inserters now report pick up and drop off locations with more detail.

- Mining drills now report output locations with more detail.

- Mining drills now report when selected that they have their outputs full.

- Expanded filter inserter support.
  * If any filters are set, they are reported when the inserter is selected.
  * Like with splitter filters, you can add the item in hand to the filter by pressing 'CONTROL + LEFT BRACKET'.
  * Like with splitter filters, you can clear the last filter by pressing 'CONTROL + LEFT BRACKET' with an empty hand.

- When the player is standing in the area where a building is being placed, they are now teleported out of the way, to the northwest corner of the build area.
  * If the corner is completely blocked, the character will still teleport but to inside the corner and therefore still in the way.

- The crafting menu now lists every recipe unlocked so far, including the ones you cannot craft by hand. When you try to craft a recipe that requires a building, the name of the building is read out.

- If an item cannot be crafted because you do not have enough ingredients, the missing ingredients will now be reported.
  
- Production statistics can now be checked also for recipes in the crafting menu.

- Production statistics for an item now include the number produced in the last 10 minutes (thank you @ohylli).

- Blueprint name and description changing now starts with a blank text box instead of starting with the existing text.

- Selecting an entity now also reports if the entity is currently marked for deconstruction or for upgrading.

- Area mining now also reports a count of how many item stacks are collected from it.

## Bugfixes

- Fixed pumpjack yield reporting

- Fixed roboports crashing when they have no networks.

- Fixed a bug where nudged entities were not connecting properly to other entities.


# Version 0.8.3 BETA 
Released on February 29th, 2024.

In this intermediate update some requested features are added and several bugs are fixed. There is also some preparation work related to circuit networks, which are not yet supported but they will be in the next major update. Additions include connecting wires, power switches, constant combinators, cursor position typing, cursor bookmarking, and item production summary reading. For changes, the sandbox world scenario has been improved and improvements were made to trees, ghosts, remnants, transport belts, and localization.

## New features

- Added support for manually connecting wires.
  * Copper wires can be connected to electric poles or power switches. Electric pole connections to each other are automatic.
  * Electricity wires between poles and machines are based on coverage area and cannot be edited.
  * Red or green circuit wires can connected to electric poles or applicable machines. This is done to form circuit networks (not supported yet).
  * Press LEFT BRACKET on the relevant building with the relevant wire in hand to begin connecting. 
  * For copper wires, you need to press for the start and end point every time, while for circuit wires every relevant building will connect to the last one pressed if within range. 
  * The maximum connection range is either about 7 tiles or greater if you are connecting together electric poles with long wire reach.
  * If you redraw a particular wire connection, it gets cut instead.
  
- Added manual control support for power switches.
  * Power switches allow you to connect or disconnect two different electric networks using a manual switch or a circuit condition. A power switch has an east side and a west side when connecting copper wires, and you can connect to a particular side by pressing on the correct edge. Meanwhile, there is just one connection for circuit wires.
  * Selecting a power switch will read the connected power and circuit networks.
  * If no circuit wire is connected to the switch, you can manually switch it on or off by pressing "LEFT BRACKET" on it.
  * If a circuit wire is connnected to the switch, it will automatically work according to the circuit condition (not yet supported).
  
- Added constant combinator support.
  * You can manually configure the signals of this machine and switching it on will send the signals constantly to the connected circuit network.
  * A secondary use for these machines is to place them next to transport belts to represent the expected belt contents, which is useful when the belt is empty.
  * Selecting a constant combinator will read the signals it has.
  * You can add a signal for the item in hand by holding it over the constant combinator and pressing "CONTROL + LEFT BRACKET".
  * You clear the last signal by holding your empty hand over the constant combinator and pressing "CONTROL + LEFT BRACKET".
  * Support will be added later for writing fluid signals and virtual signals.

- Added feature to jump the cursor to coordinates typed into a text box. 
  * Open this by pressing "ALT + T".
  * When typing, the X coordinate comes first, followed by a space and then the y coordinate.

- Added a simple cursor bookmark feature.
  * Press "SHIFT + B" to save the current position as your bookmark.
  * Press "B" to load the last position.
  * There is support for only one bookmark for now.
  
- Added production summary feature: Press "U" for an item selected in hand or in the inventory to read the summary of how many units were produced in the last one minute, last one hour, and last one thousand hours.

- New area mining feature: If a deconstruction planner is in hand, the character will try to mine obstacles and also everything marked for deconstruction, except for cliffs.

- New fast travel option added: Relocate this point to your current character position. 

- If you choose the option to respawn after a death, the respawn time is about 10 seconds. A reminder system as been added for it.

- Checking the time by pressing "T" now also notes the total mission time, which is the time played since crash landing.

## Changes

- Ghost directions can now be read.

- Improved cursor detection of remnants.
  * Remnants can be built over and they also fade over time. They can still be useful by standing in for ghosts, because destroyed buildings do not leave behind ghosts until you unlock construction robots.
  * Remnants are the same size as the buildings they used to be but the cursor is only able to detect their middle parts, which is an improvement over no detection at all for some cases.

- Added remnants to the "Other" category of the scan list.

- Re-added individual trees to the scanner list in a streamlined way.
  * The scanner range for individual trees is 25 tiles.
  * All tree types including different species or dead trunks are simply listed as "tree types". You can still check the specific type with the cursor.

- The research queue is forced to be turned off because you cannot edit it yet. We will re-add it as an accessible feature later.

- Removed player collision with inserters so that it will be much easier to walk around crowded factory areas. The hitboxes were already small, so there is very little lost here.

- Removed player collision with constant combinators because they are often used to explain transport belt contents and it would be smoother to walk over them like with belts.

- Selecting a splitter now reads out its priority situation.

- You can now add a selected entity to the quickbar if you have no item in hand and no menus open.

- Transport belt content assumptions now also check the input belts of belt unit, so that sparsely filled belts can better suggest what they carry.

- Transport belt junction type reading has been improved so that the belt units before belt corners are now recognised as regular middle belt units instead of pouring ends.

- If you try to shoot an atomic bomb to a position within 35 tiles (the explosion range) you get an alert.
  * The alert prevents you from firing for 5 seconds. You can keep holding down SPACE to fire despite the alert.
  * Furthermore, successfully aiming will require you to zoom out by scrolling the mouse wheel. 
  * Note: Therefore the expected firing range for atomic bombs is between 35 and 54 tiles.

- The sandbox world scenario has been revised. 
  * It now includes infinity chests with their filters set so that you can build new chests elsewhere and copy over the filters.
  * Blueprints items containing guidance info have been added.
  * Instant free crafting mode is not enabled by default, but the instructions to enable it have been added in a blueprint.
  * You can now find power armor and construction robots ready to go at the start.
  
- Improved localisation, so that the translated names are read out for:
  * Selected entities.
  * Items previewed on transport belts.
  * Items previewed in selected containers.
  * Fluids previewed in selected buildings and pipes.
  * Note: There is still much localisation work to do, such as opening up full mod sentences for translating.

## Bugfixes

- Removed unnecessary message of a building not being equipped after you place it as a ghost.

- Fixed crude oil amount reading to match the vanilla numbers.

- Fixed crashes due to shooting when you have no ammo.

- Fixed crashes after deaths or at game start due to missing player characters.

- Fixed a crash due to sorting the scan list with enemies missing.

- Removed the sound cues of the character randomly getting selected sometimes while running in smooth walk mode.


# Version 0.8.2 BETA 
Released on February 21st, 2024. 

This minor update is all about blueprints and ghosts. It fixes recently reported crashes related to blueprints and ghosts, adds blueprint book reading support after some serious tinkering, and tweaks a few related things.

## New features

- Added support for importing and browsing blueprint books.
  * Press LEFT BRACKET for a blueprint book in hand to begin browsing it as a list.
  * Navigate the list with W and S. This will read blueprints in the book in terms of their names and icons. Note that many community blueprints tend to have no name and automatically generated icons.
  * Press LEFT BRACKET to put the book away and copy the selected blueprint into hand.
  * Note: Blueprint books can go inside each other. If a blueprint book slot contains another blueprint book in it, the mod is not yet able to identify it.
  * Note: Further support regarding blueprint books will be added later, such as renaming them or adding blueprints into them.

- Added information to note that a blueprint in hand is being flipped.
  * You can flip a blueprint in hand horizontally by pressing "F".
  * You can flip a blueprint in hand vertically by pressing "G".
  * Note: Flipping a blueprint creates a symmetric version of it that you cannot get by rotating it. It is useful for putting similarly designed factory areas on the two sides of the same transport belt. For example if your machine row goes from East to West and has the input belt on the North side, you can flip it to make it go from West to East instead while the input belt remains on the North side.
  * Note: If a blueprint contains a building that cannot be flipped, such as a burner mining drill, oil refinery, chemical plant, or the such, then none of the blueprint gets flipped. This will become allowed in Factorio version 2.0.

## Changes

- Attempting to build a blueprint now reads out feedback.
  * Success includes the blueprint name.
  * Error due to an obstacle reads the obstacle.

- Improved blueprint menu
  * New menu line: Read this blueprint's dimensions and total component count
  * Rotating the blueprint in hand while the menu is open will update this info and the visual previews correctly.

## Bugfixes

- Fixed a crash that prevented handling blueprints with circuit signal icons added to their icon lists.

- Fixed a crash that prevented nudging ghosts.

- Fixed a crash due to emptying the hand while the blueprint menu is still open.


# Version 0.8.1 BETA 
Released on February 20th, 2024. 

This update fixes some new and old bugs, and brings some minor tweaks and additions.

## New features

- You can now read your character's coordinates by pressing "CONTROL + K". This is independent from the cursor.

## Changes

- Removed camera changing focus to the cursor in cursor mode. This was causing audio confusion and also had issues with map view panning.

- Entity names are now localised when read by the cursor.

- Selecting an entity using the scanner in any mode, or using the pipette tool in cursor mode, now jumps the cursor to the entity's northwest corner.
  * This is very useful when you want to manually fill in ghosts quickly.

- Generalized the new tutorial summary control to read in the opposite mode.
  * By default, pressing "ALT + H" will read the current step's summary.
  * In summary mode, pressing "ALT + H" will read the current step's details.
  * You can toggle summary mode by pressing "CONTROL + SHIFT + H".

- Adjusted tutorial controls for skipping chapters, to match previous changes.
  * You go to the next step by pressing "CONTROL + H" and go to the previous step by pressing "SHIFT + H".
  * You go to the next chapter by pressing "CONTROL + ALT + H" and go to the previous chapter by pressing "SHIFT + ALT + H".

- Changed a configuration setting to enable building the ghosts.
  * You can now (correctly) place a ghost of the buildable item in hand by pressing "SHIFT + LEFT BRACKET".

- Clarified build preview dimension info.

## Bugfixes

- Fixed a crash when renaming a fast travel point.

- Fixed a crash due to analyzing ghost belts.

- Fixed a pipe preview reading bug due to it reading the player.

- Fixed some typos in the tutorial text.

- Fixed a bug due to belt placement previews not accounting for underground belt entrances and exits. 
  * However, ghost belts still cannot be accounted for.


# Version 0.8.0 BETA 
Released on February 18th, 2024.

This update includes full support for blueprints, and also for the spidertron thanks to contributions from @dzsoker. The update also has several improvement tweaks across the mod thanks to detailed feedback from @SightlessKombat. More tweaks are on the way in future updates.

## Launcher changes

- Demo maps have been converted into mod scenarios.
  * Every time you launch a scenario, it starts from the same defined point.
  * You can save a scenario map and load it like any other map.
  * With this new mode, we will be able to publish improvements to the demo maps in later updates.
  
- Fixed a bug that did not read out punctuation key names when they were a part of a key combination.

- Fixed a crash related to language selection.

- Fixed a bug related to the --mod-directory flag.


## New features

- Added blueprint menu for editing and managing blueprints. Menu options include:
   1. Read the description of this blueprint
   2. Read the icons of this blueprint, which are its features components
   3. List all components of this blueprint
   4. List all missing components for building this blueprint 
   5. Edit the label of this blueprint
   6. Edit the description of this blueprint
   7. Create a copy of this blueprint
   8. Clear this blueprint 
   9. Export this blueprint as a text string
   10. Import a text string to overwrite this blueprint

- Added spidertron remote menu (work done by @dzsoker from our Discord). It has the following options:
  1. Link or unlink a remote with a spidertron
  2. Rename the linked spidertron
  3. Set the cursor position as the spidertron autopilot target 
  4. Add the cursor position to the spidertron autopilot queue 
  5. Toggle automatically targetting enemies when the spidertron is working by itself
  6. Toggle automatically targetting enemies when there is a gunner insider
  7. Set the spidertron autopilot to follow the selected entity
  * Open the menu by pressing "RIGHT BRACKET" with the remote in hand.
  * Shortcut: If you press "LEFT BRACKET" with the rempote in hand, it will set the cursor position as the spidertron autopilot target.
  * Shortcut: If you press "CONTROL + LEFT BRACKET" with the rempote in hand, it will set the spidertron autopilot to follow the selected entity.

- Added spidertron equipment grid support (work done by @dzsoker from our Discord).
  * Press "SHIFT + LEFT BRACKET" to equip a selected equipment item in the spidertron trunk or an item in hand while the spidertron menu is open.
  * Press "G" and "SHIFT + G" on the spidertron menu to get info about its equipment.
  * Press "CONTROL + SHIFT + G" to empty out the spidertron equipment grid.

- Added repeating reminders for the start of the game about basic controls. 
  * Press "TAB" to begin.
  * Press "H" to open the tutorial.

- New game sounds added, others were adjusted 
  * Moving the cursor mode makes a virtual sound to distinguish it from walking.
  * Resizing the cursor uses this sound too as it is another cursor action.
  * Ongoing crafting now makes a background sound.
  * Artillery remote usage makes a sound.
  * Footsteps were made louder
  * Scanner was made quieter.
  * When you are mining ore, you hear only one mining sound. 
  * You hear a sound when you pick up an item such as ore while mining continuously.
    
- Added functionality for the artillery remote.
  * When you press LEFT BRACKET with it, artillery cannons within range can fire to the cursor position, even if it is not on screen.
  * If you are standing next to the cursor when you order a strike, a warning is read out.

- Visual addition: Now in cursor mode, if the cursor is out of player reach, the camera will focus on the cursor in map view.
  * This applies when you jump the cursor around when scrolling the scanner list or the fast travel list.
  * This also applies when you move the cursor with ARROW KEYS, but pressing W A S D keeps the vanilla functionality of panning the camera instead of making it focus on the cursor.

## Changes

- Changed tutorial controls.
  * You now press "CONTROL + H" to go along the list and "SHIFT + H" to go back.
  * You can now press "ALT + H" to read the summary for the current step only, or press "CONTROL + SHIFT + H" to toggle between summary mode and details mode.

- When a building cannot be built, objects in the way are now identified, such as buildings or cliffs or water.

- Nudging buildings has been improved so that obstacles in the nudge area such as items on the ground are cleared automatically and larger obstacles are identified, such as buildings or cliffs or water.

- Improved entity ghost information, like when reading entities or scan entries.

- Better reporting about items in hand.
  * Rotating items in hand says "in hand" after the new direction.
  * "Empty hand" revised to "Emptied hand".
  * Ghosts in hand are now correctly identified instead of an empty hand.
  
- Revised crafting menu and crafting queue info
  * The crafting category name (also called the item group name) is now stated when you change the category by pressing "W" or "S".
  * The mod now clearly specifies how many times you can craft a recipe.
  * When you begin to craft a recipe, the menu reads how many batches there are in queue in total.
  * Improved localisation for these menus to include the recipe names.

- Examining or previewing heat pipes now gives Information about the heat connections.
  * The same applies for examining heat exchangers and nuclear reactors that are already built.

- Logistic chests and their previews now report info about their logistic network connection status.

- Entities in general will now report whether they are missing inputs or have a full output, when you select them with the cursor.

- Partial localisation made for entity status reading, and a layout was added for easily improving localisation across the rest of the mod later on.

- Menu search for the technologies menu now checks all three categories, now matching other menus.

- Visual menu icons can now come in pairs. 
  * The crafting queue menu now has a pair of icons to distinguish it from the crafting menu.
  * For blueprint menus all four blueprint icons can be displayed too.

## Bugfixes

- Fixed a recent bug that was preventing diagonal rail appending when running diagonally in smooth walk mode.

- Fixed a crash related to reading building fluids.

- Fixed a crash due to an API bug in reading entity status number 23. The original bug has been fixed for a later release.

- Fixed a crash related to inventory browsing after handling armor equipment.


# Version 0.7.3 BETA 

Released on February 7th, 2024.

In this intermediate update the launcher has been improved so that it reads punctuation key names as intended, and translates key names when localization is used. In addition, the update brings support for the deconstruction planner and the upgrade planner, and the basics for blueprint support. For the full blueprint support plan, read the section for upcoming features.

## New features

- Deconstruction planner support
  * Press "ALT + D" to hold a decontruction planner in hand. Press "LEFT BRACKET" with the planner in hand to mark the start point and end point of the selection area for deconstruction. The order is given when the selection ends. You can cancel the ongoing selection by clearing your hand before marking the end point, or press "Z" to undo the order if it was your last action.
  * To cancel deconstruction orders for an area being selected, finish the selection by pressing "RIGHT BRACKET" instead.
  * Info: The deconstruction planner is useful for picking up large areas of entities with the help of construction robots. You can use the deconstruction planner item to select an area and mark all entities inside for deconstruction. The selection includes player built structures but also trees and rocks. These marked entities will stop working and get picked up by available construction robots that can reach them, and be taken to logistic storage chests.
  * Note: If you are near the area and have your own construction robots in your personal roboport, they will join the deconstruction and take their picked up items into your inventory.

- Upgrade planner support
  * Press "ALT + U" to hold an upgrade planner in hand. Press "LEFT BRACKET" with the planner in hand to mark the start point and end point of the selection area for upgrading. The order is given when the selection ends. You can cancel the ongoing selection by clearing your hand before marking the end point, or press "Z" to undo the order if it was your last action.
  * To cancel upgrade orders for an area being selected, finish the selection by pressing "RIGHT BRACKET" instead.
  * Info: The upgrade planner is useful for upgrading large areas of buildings with the help of construction robots. A building being marked for an upgrade means that there is a request made for it to be replaced with its higher tier version. For example, transport belts being upgraded would request for fast transport belts. If the upgraded versions of marked buildings can be found in a logistic network, construction robots will take them and replace the buildings and then take the picked up old buildings to logistic storage. Upgrade requests remain active indefinitely and they do not pause building operation.
  * Note: Your personal roboport can do this too using your own inventory for supply and dropoff instead of the logistic network.

- Experimental preview of blueprint support (work in progress)
  * Press "ALT + B" to hold an empty blueprint in hand. Press "LEFT BRACKET" with the planner in hand to mark the start point and end point of the selection area for upgrading. You can cancel the ongoing selection by clearing your hand before marking the end point.
  * Entities within the selection area become a new filled blueprint, which is saved to the blueprint in hand.
  * You can press "LEFT BRACKET" with the filled blueprint in hand to place down its contents as ghosts, for construction robots to fill if the relevant buildings can be found in storage. 
  * Note: A blueprint can be placed at an distance from the player but if it is near the player and not too large, obstacles in the build area are cleared automatically when placing.
  * Note: Blueprints in the mod, like building previews, are held by their top left corners instead of their centers. The previews can be rotated and have correct graphical previews. The rotation resets each time you take a blueprint in hand.
  * Info about the featured entities in a blueprint can be read. Up to four featured entities are selected automatically by the game and a used to clarify the blueprint's visual icon.

- Area mining added for ghosts. Press "SHIFT + X" on a ghost to remove all ghosts within 10 tiles.

- Regular rail signal pairs can now be placed on mid rails, with a warning about how it is easy to get deadlocks with them.

## Changes 

- The launcher should now read out punctuation key names correctly.

- The launcher translates the names of keys.

- Improved area mining for railway objects to include train stops and a better explanation about removing all such objects within 10 tiles.

- Tweaked some tutorial steps to clarify them based on community feedback.

- Direction names are now given by the game, which may be localised.

- Ghost names are now localised and read more quickly.

## Bugfixes

- Fixed a launcher crash due to incorrect keybind naming.

- Fixed a crash when placing the last underground belt in hand.

## Upcoming features 

- Blueprint management menu, with options such as the following:
  * Add or change this blueprint's label (short)
  * Add or change this blueprint's description (long)
  * Copy or delete this blueprint 
  * List all blueprint contents by count
  * Export a blueprint string from this blueprint.
  * Import a blueprint string to overwrite this blueprint.
  * Possibly other features such as upgrading entities within the blueprint.
  * Possibly allowing the blueprint selection to include placed tiles.

- Press a key to review information about the area being selected right now, before finishing the selection.
  * This can include the area size and affected entity count.

# Version 0.7.2 BETA

Released on February 4th, 2024.

This is a minor update mainly to fix bugs and improve building tools, but it also features a special little addition from a community member.

## New features

- Thanks to contributions from @dzsoker, logistic request support for spidertrons has been added. It works like player logistic requests, and is uniquely available for spidertrons among all vehicles.

## Changes

- Reduced volume for some new mod sounds.

- Added rectangular obstacle clearing under building preview footprints prior to building, so that simple obstacles like trees or items on the ground will not block you from building.

- Better explained the rail in hand rotation issue. Note that you can rotate another item in hand, and then grab the rail item to get it in hand with the right rotation.

- Visual building previews now account for build lock mode, when the buildings are set to be placed behind you as you walk.

## Bugfixes 

- Fixed the automatic aiming function crashing the game due to a mistake with changing function names.

- Fixed some bugs related to entity selection that caused multiple things to happen in one buttom press. If you are still experiencing issues, go to your "config.ini" file and make sure that you set "open-gui-alternative=" to have nothing after the equals sign.

- Fixed a crash when opening train menus while riding a train.

- Fixed build lock mode in cursor mode having offset bugs that were introduced in 0.7.0. 

- Fixed electric pole distances not being correct in some build lock mode cases.


# Version 0.7.1 BETA
Released on February 1st, 2024.

This is a minor update to extend the tutorial, tweaks some basic behavior, and fix bugs.

## Changes

- The tutorial has been reviewed and extended.
  * You need to rewind the tutorial to the very top for it to reset. Consider using "CONTROL + ALT + H" to jump back in chapters.
  * Now there are 9 chapters, covering up until the end of building a complete automation science factory.
  * Internal names for keybinds have been added to later chapters as well.
  * Because the "LEFT BRACKET" and "RIGHT BRACKET" keys can vary between different keyboards and vocalizers, a warning has been added to the tutorial start messages about this.
  
- The placement system for underground belt chutes has been revised.
  * Now you do not need to rotate the exit chute in hand for it to be connected and built. It will simply be at the same rotation as the entrance chute, while the flipping is handled by the mod internally.
  
- Selecting your own character has been re-enabled in Cursor Mode.

- Toggling vanilla mode or cursor hiding now reads this out too.

## Bugfixes 

- Fixed a crash that occured when adding to an existing stack of an item.

- Fixed a crash due to incrementing a logistic request for an item with stack size 1.

# Version 0.7.0 BETA

Released on January 30th, 2024.

This update brings many interface tweaks and additions. Most importantly, we are adding the first version of the mod's own tutorial system, which teaches the basic controls and mechanics, and gives the player small objectives up until they complete their first two technology researches. In addition, how the mod cursor updates and how it syncs with the visual mouse pointer have been vastly improved. The launcher has also been improved, now supporting localization and improved new game setup including new presets.

## New Features

- New launcher features.
  1. Added launcher localization support including an option to select your language before the main menu.
  2. The new game settings menu completely revamped to make game setup smoother.

- Map presets have been revised.
  1. Compass valley remains unchanged as the custom peaceful map with fairly favorable settings and a world seed that is always the same. We recommend it for your first game.
  2. The "no enemies" preset has default settings except that enemy bases are fully turned off.
  3. The "peaceful" preset has default settings except that enemies are in peaceful mode, where they do not start any attacks, but still react to being attacked.
  4. All other presets come directly from the game.

- The tutorial system has been added.
  * Press "H" to hear the current tutorial step. Press "SHIFT + H" and "CONTROL + H" to go forward and backward along the steps.
  * To make it easier to review steps, there is a chapter and summary system. You can toggle between hearing step details or their summaries by pressing "CONTROL + SHIFT + H". 
  * You can jump between the chapters by using "ALT + SHIFT + H" and "ALT + CONTROL + H".
  * The tutorial system works by giving info in steps. There are over 100 steps spread out over 7 chapters, including objectives, basic info, tips and so on. 
  * The logic of the system is to teach the controls, and give the player small objectives up until they complete their first research, and provide condensed wiki information about everything they use.
  * Reading the wiki will now be needed if you want to learn more advanced info such as transport belt lane management, or if you prefer to have the basics explained in extra detail.
  * Running the tutorial also provides a little gift so that steps are explained in a smoother order, and also the early game becomes very slightly faster.
  * Feedback is welcome for rebalancing any of the steps.
  
- Damaged items are considered by the game as not the same as the same items at full health, so the mod now identifies damaged items, so that you can place and repair them.
  * If you have multiple damaged units of the same item, the inventory system has a shortcut where it groups all damaged units of the item into the same stack and averages their health levels.
  
- A sound cue can now be heard when you encounter an entity in smooth walking mode. This makes it much easier to detect when you arrive at an ore patch. 

- The player character now visually turns to face the cursor direction correctly.

- Vehicle inventories can now be accessed, including cars, tanks, cargo wagons, and rocket cargo slots.

- You can now take half of an inventory stack when your hand is empty by pressing "RIGHT BRACKET", but for now only from the player inventory menu when it is open by itself or alongside a chest. On the other hand, smart-inserting half a stack by pressing "SHIFT + RIGHT BRACKET" already works from the player inventory inside building menus.

- Small additions
  * The power load level for steam engines is now expressed in a percentage as a summary before giving the exact numbers as usual.
  * Steam engines now indicate their fluid contents.
  * GUI icons were added for the offshore pump building menu.
  * Visual build previews now include the enlarged cursor if holding paving items, since they can be placed outside of cursor mode too.
  * A furnace's recipe can now be identified from its output slot if it is inactive otherwise.
  * Left clicking with the mouse is now also associated with the mod's entity click handling function.
  
## Changes

- Rotation input behavior has been changed. 
  * You can now use rotate "R" and reverse rotate "SHIFT + R" universally, including Vanilla Mode. 
  * The first rotation command now rotates the building instead of simply reading the current direction. This provides parity with vanilla behavior and also the info is already available when an entity is examined.

- Big revisions for how the mouse pointer is visually handled. This minimizes bugs and makes the cursor logic easier to see for those with partial vision.
  * The pointer is now strongly bound to the mod's cursor with higher accuracy. This is enforced every time you press a key to move the mod cursor or while you have an item in hand. 
  * If the mod cursor is going off the edge of the screen, the mouse pointer is centered on the player character in the middle.
  * Entity selection has been fully tied to the mod cursor exclusively, so the mouse pointer clicking on something out of range or on something that is in front of something else will not cause issues.
  * Vanilla mode bypasses all of these checks and fully unbinds the mouse pointer and re-enables selecting entities with it.
  * There is also another bypass for those who prefer it: You can middle click the mouse to unbind the mouse and select with it freely until the mod cursor moves again or the menu changes. 
  
- Mod release files have been cleaned up.
  * Removed unneeded files from the 0.7.0 release folder. These include the "map presets" folder and DLL files.
  * The mod's MIT license is now included in the mod's own folder.
  
- The scanner tool has been tuned to report more accurately when it is finished.

- When you enter Cursor Mode during smooth walking, you will now be repositioned to the center of the nearest tile if it is walkable. The displacement is always less than 1 tile.

- Smooth walking has been made smoother such that info updates and cursor updates are more accurate.

- Improved how transport belts in hand are rotated to match the player direction during build lock mode.

- Improved pipe connection direction reports so that they point to the relevant pipes of a connected entity instead of the whole entity, which may be at a diagonal direction.

- The fast travel system now takes the player position as the reference when creating a new point.

- Other changes
  * Crafting menu info and some other menu info is better phrased now.
  * Entity part reading has been made more accurate.

## Bugfixes

- Launcher bugs fixed, such as removing a circular dependency about setting up config files for the first time loading the game.

- Fixed the sync of visual building previews with the mod drawn building preview footprints. This includes rotating objects and using the pipette tool.

- Fixed several cases of missing updates for the cursor highlight box and building preview visuals.

- Cursor reach distance for clicking entities has been made more accurate.

- Mining an access radar now gives you back the access radar instead ofa regular radar.

- Fixed flamethrower turrets causing a crash when you examine their contents.

- Fixed crashes that were happening while reading special tool items in hand.

- Fixed the game crashing when your character dies.

- Fixed the transport belt analyzer crashing due to localization setup errors.

## New known bugs

- There are some cases where the mod cursor and mouse pointer rotation lose sync. You can fix this by using the pipette tool to resync them.
  
# Version 0.6.0 BETA

Released on January 20th, 2024.

This update brings several new features and changes to increase overall accessibility. Additions and changes include launcher improvements, redesigned and extended mod sound effects, new or changed game configuration settings, new or changed keybinds and controls, and some features to improve the scanner tool.

## New features

- New launcher features, mostly internal changes while we work on improving multiplayer setup support.
  1. When joining a multiplayer game, the launcher will prefer Steam networking if available. This has not been tested for every case but you are now more likely overall to connect to an internet multiplayer game without issues.
  2. When starting the launcher from the command line, you can now enter arguments meant for Factorio and they will be passed along, with the exception of "-h"/"--help" which prints our help info instead.
  3. The command line switch for the launcher's debugger mode is "--fa-debug". You can include this in a shortcut, so you never forget to turn on debugging and then have to restart Factorio to turn it on. You can also still turn on debugging after launching by typing "debug" at any launcher menu. 
  4. Fix: "host save" now compensates for Factorio trying to just use the last modified save instead of the one specified.
  5. Fix: "host save" now compensates for steam using a different player-data.json file.
  6. Fix: Better Steam (or not Steam) detection.
  
- New game configuration defaults have been prepared.
  * New graphics options defaults are proposed. They set the graphics to minimum settings to save on performance and battery.
  * Some vanilla keybinds to open graphical menus such as "M", "O", and "B", are removed so that we can use them for mod features instead. All of these graphical menus can be opened using graphical buttons at the top right corner of the screen.
  * Some optional settings like loading mods automatically, or startup time optimisation, are now presented as well. For these we recommend selecting the option you prefer or keeping what is suggested.

- New mod sound effects have been added and most mod sound effects were changed.
  * When you wrap around the edge of an inventory, a new scrolling type of sound plays.
  * The scanner has a pulsing sound when it runs.
  * New sounds have been added for the new smooth walking bump alert and stuck alert.
  * Other sounds, including enemy alerts, train alerts, and damage alerts, have all been changed to support a new sound library.
  * We might revisit using the old sound library after we clear up some uncertainties regarding licensing.

- New radar building type: Access Radar
  * This is a custom version of the regular radar that was designed for this mod. It has the same dimensions and appearance except for a slightly darker color.
  * As advantages, this radar type has more than twice the charting range and about six times the charting speed as the regular radar.
  * As disadvantages, this radar type consumes twice as much power as the regular radar and costs twice as many ingredients to craft. Also, the nearby chunk visibility effect provided by this radar type has a smaller range and a lower refresh rate (exactly sufficient when at full power).
  * For both radar types, it takes about 6 hours to completely chart all chunks within range, although building more radars can cut down this time significantly.
  
- Examining a radar with the cursor will now read out its charting progress and range.
  * Chunks that have been already charted are also counted towards this progress.
  * Radars are programmed to always focus on charting chunks that have not yet been charted by other radars or any other means. Therefore a radar will continuously work to reach 100% charting progress before it begins to re-scan charted areas. 
  * Building more radars in the same area will linearly increase the charting speed for all of them, but note that the Access Radar is about six times faster than the regular radar.
  * Charted chunks are usable by the scanner tool, which otherwise cannot detect entities there.
  * You only need to chart every chunk once. A radar being removed will not take away functionality from the entity scanner tool.

- Added smooth walking bump alert.
  * If your character is running in a straight line in a cardinal direction, and they get shifted laterally because of bumping into an object or running into a cliff edge, then you will hear the bump alert beep. 
  * If at a cliff edge, you can also hear a the sound of sliding rocks or gravel.
  * Note: Bumping shifts you at most by one tile at a time and it causes no damage.
  
- Added smooth walking stuck alert. 
 * If your character is running but is not changing position due to being stuck, the stuck alert beep will begin to play continously after about 1 second of being stuck.
 * You can almost always get unstuck by moving into a new direction, and verify that it worked via the absence of the alert.

- Added directional entity scanning. Press "SHIFT + END" to make the entity scanner check only the direction that you are currently facing. 
  * You can use this feature for cases like identifying the obstacles ahead when building a railway.
  * You can face and scan a diagonal direction when in smooth walking mode.
  * The scan angle is slightly wider for objects within 10 tiles so that they are not missed, but some large objects that are only partially covered by this direction might still be missed.

- Quickbar support has been expanded, including support for switching to different quickbar pages.
  * The game allows you to have up to 10 different quickbar pages. You switch to a different one by pressing "SHIFT + NUMBER" for the number you choose from "1" to "9" or "0". While this already worked quietly before, we have now added information read outs for it. Usually it is nice to have a dedicated quickbar page for different tasks, like one for train stuff, one for combat stuff, and so on.
  * Quickbar actions will now give some more information like what item has been selected or removed, or which item is at slot number one for the selected new quickbar page.
  * You can now put the item in hand into a quickbar slot without needing to open your inventory. This uses the same keys as before, "CONTROL + NUMBER" for the number you choose from "1" to "9" or "0".

- Other additions
  * When you open the crafting queue, it now reads how many recipe instances in total are in the queue.
  * Information feedback is given when you cancel items from the crafting queue.  

## Changes

- Some mod controls have been changed. Please note:
  * The "Q" key now empties the hand and runs the smart pipette tool, like in vanilla keybinds. Reading the hand is now done with "SHIFT + Q". Therefore, the two keybinds have simply switched places. This is for several reasons: Parity with vanilla gameplay, the hand emptying and pipette being used more frequently overall than hand reading, and symmetry with "SHIFT + E" reading the current menu and with "E" opening and closing menus.
  * The menu search function is now activated by pressing "CONTROL + F", instead of pressing "ENTER". This prevents unintentionally boarding or exiting vehicles when trying to open the search, and it is also a more intuitive keybind that matches most other computer programs.
  * Scan result list sorting now uses "N" to sort by distance to your current position because it is used more often than sorting by total count, which now uses "SHIFT + N".

- Some existing configuration option default were changed. The launcher prompt for new options should cover these.

- From now on, the scanner list sorting by distance always takes the player position as a reference point rather than cursor position, because the cursor changes position when navigating the list and can often cause confusion.

- In multiplayer mode, everyone's cursor boxes are now drawn for everyone, with each cursor given its own character's color.

- The maximum limit value for a personal logistic request can now be set to zero as well, which will trash an item as soon as you put it in your inventory. If you want to edit the request after that, you must pick the item into your hand from a chest and set the request from your hand.

## Bugfixes 

- Fixed: Nudging a building now correctly applies a check for whether the new location is clear. This should prevent ending up with incorrectly overlapping buildings.

- Fixed: Splitter settings can now be applied to all splitter types.

- Fixed: Walking in telestep mode now sets the character walking speed to zero, which prevents characters from moving unintentionally in multiplayer mode.

- Fixed: An entity damaged alert will no longer be sounded if the entity loses no health despite being attacked.

- Fixed a crash in the rail analyzer when it is unable to find a reference rail.

- Fixed a crash for placing your first roboport, which was due to not being able to find other roboports nearby.

- Fixed a bug that prevented the search box more than once because the old one was not deleted.


# Version 0.5.0 BETA

Released on 12th January, 2024.

In this update we have added all the basics and some of the extras for logistic robot and roboport support. Additional extras will be added in future updates. Another big feature for this update is that you can now search most menus, and with localised names!

## New features

- Added logistic chest support. Selected items refers to items in hand or items selected within the chest inventory while the chest menu is open.
  * For requester and buffer chests, you can now tune the requested minimum amount for a selected item with "SHIFT + L" and "CONTROL + L".
  * For logistic storage chests, you can set or clear the logistic filter with the selected item or a blank slot by pressing either "SHIFT + L" or "CONTROL + L".
  * You can press "L" for a selected chest to review its request status.
  * You can toggle a requester chest's feature to request from buffers by pressing "CONTROL + SHIFT + L".
  * Added "no action" messages to clarify several cases where nothing happens.
  * Note: Unlocking chest requests requires some advanced research in game using utility science packs.

- Roboports now have supporting info.
  * During build preview in telestep mode or cursor mode, roboports note which roboports they connect to, which need to be within about 50 tiles.
  * Selecting a roboport now gives information about the robots and repair packs inside.
  
- Added roboport menus, which are like train menus but focus on roboports and their logistic networks. Options include the following:
  * Rename a logistic network
  * Check roboport neighbors (which are other roboports they are connected with, to enable robot migration)
  * Check robot counts for this roboport.
  * Check robot counts for the entire network.
  * Check chest counts for the entire network.
  * Check item counts for items stored in accessible chests across the network, which excludes requester chest contents.
  
- Added ability to name logistic networks, as with trains and train stops.
  * Roboports on the scanner list are separated according to their networks.

- Greatly improved our tools for localisation support, with massive thanks to @Eph!
  * Translations will be requested and used in the search feature and other places when you first load the game.
  * Item and recipe and technology names have been localised in more parts of the mod but a lot of localisation work remains.

- Added menu searching for the player inventory, crafting menu, technology menu, building output inventory, and building recipe selection menu.
  * This should work for finding item or recipe names in your localised language, or in English as a fallback option.
  * For every menu listed, you open the search bar by pressing "ENTER", and then you type the search term and confirm with "ENTER".
  * For every menu listed, you can iterate through search results by pressing "SHIFT + ENTER".
  * For the inventory menus, you can also iterate backward by pressing "CONTROL + ENTER". 
  * For the technology menu, the search menu is unable to switch between locked and unlocked research categories.

- Locate item in hand from crafting menu added.
  * In most menus, for the item in hand, if you press "CONTROL + SHIFT + Q", this will run a crafting menu search using the first word of the item name in hand.
  * If something else opens, you can continue the search by pressing "SHIFT + ENTER".
  
- Locate item in hand from inventory feature was revamped to work as intended.
  * For the item in hand, if you press "CONTROL + Q" from the player inventory menu or with no menu open, this will open the relevant item slot in the player inventory.
  * For the item in hand, if you press "CONTROL + Q" from a building output inventory, his will open the relevant item slot in the building output inventory.
  
- You can now check the currently open menu by pressing "SHIFT + E".

## Changes

- Tweaked item pickup info to name the picked up items sooner.

- Improved accuracy of aiming assistance.

- Tweaked high enemy presence alert to sound also when there are fewer than 5 enemies but any of them is a strong enemy, such as a big biter.

## Bugfixes

- Fixed missing teleporter sound effects. Fun fact: It was a design choice related to the fog of war effect.

- Fixed bugs that jumped the cursor incorrectly after teleporting or failing to teleport.

- Fixed entity area reporting when cursor scanning areas.

- Fixed crashes from the earlier additions related to roboports.

- The sandbox map was accidentally saved with multiple mods enabled, which may make it difficult to open, so it has been reset.

- Fixed a multiplayer walking bug for non-hosting players in telestep mode.

- Removed accidentally enabled debug console messages about mining.

# Version 5.0.0 BETA Pre-release 1

Pre-release published on 7th January, 2024.

This is a pre-release of the logistics robots update before I need to go on a development break. Personal logistics are now available and we have verified that you can use construction robots for automatic repair and ghost replacement. The update also brings some tweaks and bugfixes for other features.

## New features

- Added support for personal logistics requests for items. You can read or modify them, but you need to be within about 50 tiles of a roboport for the robots to work. The following controls apply for items in hand when no menus are open, and for selected item slots when the player inventory is open.
  * Check the currently set logistic request for the selected item by pressing "L".
  * Increase the minimum requested quantity for the selected item by pressing "SHIFT + L", and decrease it by pressing "CONTROL + L".
  * Increase the maximum requested quantity for the selected item by pressing "SHIFT + ALT + L", and decrease it by pressing "CONTROL + ALT + L".
  * Note: If you have less than the requested minimum amount for an item, logistics robots will look at logistics storage chests and try to bring more of the item to you from them.
  * Note: If you have more than the requested maximum amount for an item, your excess will be held at your logistics trash inventory, and logistics robots will come and empty it into the nearest logistics storage chest.
  * Note: Combining features lets you automate your inventory management with the help of logistics robots, either in a dedicated storage area or across your whole factory, as far as roboports can reach.

- You can check the overall status of your logistics requests, by pressing "L" with no menus open or with an empty inventory slot selected.

- You can pause or resume your entire set of logistic requests, by pressing "CONTROL + SHIFT + L".

- Added limited assistance when building roboports, which can be placed like other buildings, but must be within 45 tiles or so of each other.
  
- You can now teleport to the location of the last damage alert by pressing "CONTROL + SHIFT + P"

## Changes

- Verified that you can use construction robots to repair items and replace ghosts of destroyed entities automatically, using roboport buildings or personal roboports, and also logistic storage chests.

- Teleporting now checks for enemy presence at the target location.
  * If you try to teleport normally with "SHUFT + T" you will get the warning instead when enemies are present.
  * You can instead use forced teleporting, by pressing "CONTROL + SHIFT + T"

- Improved information about locked slots for chests
  * The number of locked slots is read when you open a chest menu.
  * If a locked slot is selected, this is noted.
  * Note: A locked slot cannot have items inserted to it unless by hand, but items can be removed from it by all the usual ways.

- Fast travel locations now take the cursor when checked.
  * You can now read their relative positions by pressing "SHIFT + K".
  * Note: Creating a new fast travel location takes the current cursor position as the reference.

- Improved area scan information. Now, entity counts are given and charting percentage is given if it is less than 100%.
  
- Adjusted the volumes of most new sound effects. More tweaking may be needed.

## Bugfixes

- Fixed crash: If you have no available weapons and try to switch weapons, you get a warning now.

- Fixed crude oil missing from area scans.

- Fixed bug: Checking a scan entry updates the cursor more accurately now.

## Future worker robot features

- Roboport information will be improved concerning details like range, neighbors, and availability.

- Other logistic robot features will be added.
  * Chest logistics access, which is very powerful.
  * Personal trash access
  * Better info about existing logistic requests

- Other construction robot features will be added.
  * Selecting rectangular areas to mark it for automatic deconstruction.
  * Selecting rectangular areas to mark it for automatic upgrading to hier machine tiers.
  * Selecting rectangular areas that you can save as a blueprint item, which lets you copy and paste the area.
  * Placing down a blueprint for contruction robots to build.
  * Giving key information about blueprint items.
  * Possibly, hopefully, support for importing and exporting blueprint items as text strings.

# Version 0.4.9 BETA

Released on 31 December, 2023. Happy new year!

1. This update is about tweaks and bugfixes and small additions across the board, but mainly regarding combat-related features. An important change is that some keys such as the item info key have been remapped (check the first bullet of the Changes section below). Other changes include revisiting several new and old parts of the code, from the new enemy proximity alert system back to the old structure travel feature.

2. Among the additions, new sound effects have been added from the Gamemaster Audio - Pro Sound Collection, courtesy of @WilfSplodNokit. The expanded sound library brings new possibilities and reduces the need to re-use the game's own sounds. The new sounds are mainly for improving the combat experience. We have also added automatic aiming for all guns and proper information support about picking up items.

3. For bug fixes, I am happy to note that the long-known bug that sometimes prevented appending rails has now been fixed. Apart from that it is nice to note the good number of fixes and revisions in total. 

4. I strongly recommend you to play on Factorio 1.1.100 or later to run this version correctly. If you had updated the game for any of the 0.4.8 releases, that should be enough. 

5. Many thanks to our several community members coming forward this month with feedback and bug reports! 

6. Please note that Wiki updates to reflect these recent changes will be coming later.

7. There were very many changes and fixes this time. Despite all the testing, there may be a need to release a patch so please stay tuned regarding that.

## New features

- New sound effects have been added so that new combat-related situations can be described quickly.
  * Teleporting has a new sound to make it sound more zappy. 
  * Locking the aim of a gun has its own beep sound.
  * A player energy shield taking damage has its own sound, like a beep with the sound of an impact being deflected from the shield.
  * A player character with no shield taking damage has its own sound, like a life support system alert beep.
  * The entity damaged alert has its own alert sound so that the entity destroyed alert sound is not re-used.
  * The enemy proximity alert system has a new alert tier with its own sound for when more than 5 enemies are nearby.
  
- Area repairing added.
  * With multiple repair packs in hand if you press CONTROL + SHIFT + LEFT BRACKET, every structure within about 12 tiles of the character will be repaired until done or until you run low on repair packs.
  
- Automatic aiming has been added or improved for all guns, and a sound cue has been added for when a gun locks onto an enemy within range.
  * The pistol and submachine gun and rocket launcher with regular rockets are smartly used weapons that only fire when locked and without wasting ammo. Bringing the cursor near the target enemy is enough to make the character lock on, and then you can fire by pressing "SPACE". You can also target any entity you want by placing the cursor on it directly and pressing "C".
  * For guns with area damage, such as the shotgun or the flamethrower, the character always shoots at the cursor without caring about ammo. You can shoot with "SPACE" or with "C". Automatic aiming assists here by moving the cursor to the nearest enemy.
  * The automatic aiming does not activate if you are in cursor mode so that you can manually select targets if you want to.

- When the inventory is open and an item is in hand, you can press CONTROL + Q to put the item back and open its slot in the inventory. 
  * This is like a reverse of the quickbar feature.
  * It will be quite useful in future updates because some item-related features will be available only from the inventory menu.
  * If possible, hope to make this feature work also when no menus are open, but for now you have to open the player inventory menu first.
  
- You can now press SHIFT + Y to check the entity description of the last checked scanner entry.
  * This does not work for resources.
  * We are planning to revise and improve descriptions so that this feature enables things like learning about the characteristics of a distant scanned enemy.
  
- Added detailed information about picking up items.
  * Pressing and holding F will now only be used for picking up items.
  * You will be informed about whether you are successfully picking up items and what these items (probably) are.
  * The item pickup range is about 1 tile or sometimes less, so when you are standing next to a transport belt in telestep mode you only pickup from the lane closer to you, and in smooth walking mode you might be picking up from one or both lanes, which is not easy to determine unless you are standing directly on top of the belt and thus picking up from both lanes.
    
- More information has been added for finding and collecting character corpses.
  * The area mining tool is now more powerful and can clear scorch marks and other obstacles.
  * Checking a character corpse will notify whether it matches your character.
  * Hold down X to collect a character corpse, you will receive info about it.
  * If you have difficulty with locking onto the character corpse, try area mining first, and then try telestep mode and cursor mode and tile cycling with CONTROL + F.
  
## Changes

- Changes to default game controls
  * The item or entity information key used to be "L" by default, the new default is "Y". The "L" key will instead be used in upcoming logistic robotics features.
  * Increasing the cursor size is now done by default using "SHIFT + I", instead of "CONTROL + I".
  * Decreasing the cursor size is now done by default using "CONTROL + I", instead of "CONTROL + SHIFT + I".
  * Tile cycling, which is a rarely used feature for reading additional entities on the same tile, if any, is mow activated with "SHIFT + F", instead of just "F".

- Made repair pack consumption more accurate towards the original game behavior.
  * Repair packs have durability, one pack is consumed after repairing 300 units of health.
  * A building is only partially repaired if your pack runs out before completing the repair, but you can just continue the repair work with the next pack, which automatically comes in hand.
  
- Left bracket controls have been fully reviewed.
  * When you press left bracket with an item or on an entity, if there are no expected actions for this, this will be reported.
  * Pressing left bracket should no longer trigger multiple actions at once and thus they will not block each other.
  * When throwing a capsule, if the target is out of range, you will now be informed.

- Structure travel feature reviewed.
  * Press CONTROL + S on a building to map the area around it. Press arrow keys to jump between neighboring structures. The new comments will make it clearer about where the cursor is right now.
  * New feature: co-ordinate reading with the K key now works for structures checked during structure travel
  * Issue identified: Opening this menu causes a lot of lag, as if the game crashed. We worked to decrease this lag time to about 5-10 seconds, which is still a lot. 
  * Bug identified: Some side-by-side buildings are not identified during the creation of the building network.

- Vanilla mode and cursor hiding tweaks
  * Enabling it now enables smooth walking and cursor hiding with it.
  * Disabling it now disables cursor hiding with it.
  * Walking and cursor hiding still have their own toggle buttons.
  * The cursor hiding setting now decides on all mod cursor drawings
  
- Enemy proximity alerts have new levels. The total situaion is this:
  * Slow marching: Nearest enemy is within 50 to 100 tiles.
  * Moderate marching: Nearest enemy is within 25 to 50 tiles.
  * Fast marching: 1 to 5 enemies are within 25 tiles.
  * Fast marching and slow klaxon: 6 to 10 enemies are within 25 tiles.
  * Fast marching and fast klaxon: More than 10 enemies are within 25 tiles. RUN!

- Enemy spawners are now listed on the scanner list in terms of how polluted they are.
  * "normal" means they are not polluted at all.
  * "almost polluted" means that there is pollution near the spawner but not on it yet.
  * "polluted lightly" means that the spawner is now absorbing pollution and is preparing small enemy attack groups that will target your factory.
  * "polluted heavily" means that the spawner is now absorbing a lot of pollution and is preparing large enemy attack groups that will target your factory.

- Train stops on the scan list are now listed with vehicles instead of buildings, for convenience. The names of the stops are also read while in the scan list.

- All rail vehicles on the scan list now include their train name but none of them are sorted by it.

- Building 3-way rail forks is now cleaner, with the straight part of the fork being longer.

- Clarified several error messages for actions like inserting items, opening menus, checking item info, reloading weapons, and more.

- Menu visuals have been extended to include more menus.

- Removed the vanilla tip pop-ups, which are mostly graphics based but can still confuse the screen reader.

- Damage alerts are now muted for the first minute of the game so that you are not constantly alerted about the spaceship burning.
 
- Thrown items such as grenades and cliff explosives now have their valid throwing ranges checked with high accuracy.

- When you open a crafting building that has no recipe set, it will now open the recipe selection sector of the building first. This matches the vanilla behavior.

- In the inventory menu, you can now directly equip an item by pressing SHIFT + LEFT BRACKET, without needing to take it in hand.

- When no menus are open, you can now directly equip an item in hand by pressing SHIFT + LEFT BRACKET, without needing to open the inventory.

## Bugfixes

- Fixed the long-persisting rail appending bug! Rail appending after train stops or forks should function as intended in all cases now.

- Fixed a bug that prevents using capsule items such as cliff explosives.

- Very likely fixed the bug where opening a menu makes the character walk around by itself.

- Fixed a localization error that occurs when nudging buildings.

- Fixed a bug that made modules in hand get placed into module slots as whole stacks instead of single modules.

- Fixed a recent crash that was happening while placing rail vehicles.

- Restored the scanner category for buildings.

- Fixed a crash that occured when checking item descriptions in the filter inserter menu. Unfortunately no descriptions can be checked in this menu.

- Fixed area mining having infinite range. Sorry people, it is supposed to be used only near the player.

- Fixed a bug that prevented anouncements of player characters dying.

- Fixed a crash that was due to building info not being reset when you close a building menu.

- Fixed a visual bug where you could open a building menu in the mod but the corresponding GUI would not appear.

- Fixed all bugs related incorrect or missing information when you switch guns by pressing TAB or SHIFT + TAB.

## Known bugs

- New issue: If too many entities are destroyed in a short time, like from a nuclear explosion, the game will lag for a few minutes but it should keep loading in alert sounds until it finishes processing them all.

- New bug: Structure travel sometimes misses buildings that are directly next to each other.

- We have moved the list of known bugs to a Wiki page so that we can update it without waiting for a new release, [click here](https://github.com/Crimso777/Factorio-Access/wiki/Known-Bugs).

# Version 0.4.8 BETA (Full Release)

Released on December 19th, 2023.

This full release of version 0.4.8 brings the additional features needed for making complex train systems. Now you can build systems with multiple automatic trains using forks and bypasses, and you can set different waiting conditions for each train stop for each train. You can manually drive with increased safety or you can skip manual driving entirely by selecting a reachable station from a menu and traveling to it once using subautomatic travel.

This update also improves other features like the scanner, vanilla mode, mining tools, and mod menu visuals. The pre-release of this update had also added sandbox maps and launcher improvements.

Note that this update uses new Factorio API features and so you need to be running Factorio 1.1.95 or later. The current latest version is Factorio 1.1.100.

## New features

- New subautomatic rail travel system where you can pick the destination.
  * Opening the subautomatic travel option will create a list of every train stop the train can reach from its current position.
  * Selecting a stop from this list adds it to the top of the train schedule as a temporary station and sends the train to it.
  * After reaching the temporary stop, the train will wait for all players to disembark and it will then resume its normal schedule.
  * This addition will make it safer and easier to build a complex train schedule by making it easier to reach a train stop so that it can be added to the permanent schedule.  

- Added rail bypass junction building option for vertical and horizontal end rails.
  * Rail bypass areas are meant for reducing traffic in rail systems with multiple trains on them because trains can wait or pass by each other while inside them.
  * At the bypass junction a regular two-way rail splits into a pair of parallel one-way rails. These rails need to be extended to be longer than the longest train in the system so that two trains can pass by each other in the bypass area without blocking each other's tracks. The two rails need to be joined again at another bypass junction, thus completing the full bypass structure.
  * The one-way exit rail at the bypass junction is the only place in the mod (for now) that allows regular rail signals because the bypass system is a reliable way to use their advantages without causing deadlocks. 

- New scanner categories added.
  * Vehicles category includes cars and locomotives and wagons. Locomotives are grouped per train.
  * Player category lists player characters by name. It also lists character corpses and highlights every player's own character corpse to them exclusively.
  * Enemy category lists mobile and fixed enemy units and structures.
  
- Added the Stop On Red mod by DaveMcW to releases by default. 
  * This train driving safety mod makes manually controlled trains stop at closed rail signals.
  * If you keep holding down the acceleration, or if you reverse into the signal with a train that has no backward facing locomotives, then you can overpower the safety feature.
  
- New train driving safety features: honking
  * If you are manually driving a moving train near a closed rail signal, the train will make two short honks to notify you to stop at the signal. You can press J to monitor the signal.
  * If you are on a moving train and there is another train within the same rail signal block, the train will make a long honk to notify a possible collision. If you are driving, you should stop accelerating. If you are hearing this often, it means that you need to add more rail signals or remove trains from the system or reconnect disconnected trains.
  
- In case of buggy rendering of visuals, you can now press CONTROL + ALT + R to clear all rendered objects.

## Changes

- Forests in the scan list are now labeled in terms of density, and empty forests are now removed from the list.

- Revised and extended train menus to include the new features in a streamlined way.

- Every mod audio menu now has a GUI icon appearing alongside it for clarity. The same icon appearing over your character's head.

- Reading coordinates of the cursor (K key by default) now prints this information silently to the console and also draws a marker at the cursor point.

- Improved vanilla mode
  * Mod related menus will no longer open and lock you in when you press the relevant keys.
  * Pressing CONTROL + ALT + C will now toggle hiding the cursor entirely including build previews.
  * T in vanilla mode key opens technology menu like the default.
  
- Area mining now also clears tree stumps and scorch marks.

- Group mining of rails now includes curved rails and covers a 7 tile radius instead of 5.

- Restored being able to go up and down the scanner list while in cursor mode, but only with the PAGE UP and PAGE DOWN keys. The arrow keys in cursor mode are still used to move the cursor.

- Rail alerts for trains within the same block are now less dramatic if the train is more than 200 tiles away.
  
## Bugfixes

- Intersections including curved rails are now checked as well when querying the nearest intersection.

- Fixed a crash related to missing recipe descriptions, but there may be more crashes remaining about this.

- Fixed lack of updates to forests in the scanner list. Rescanning will refresh the lists.

## Known bugs

- New bug found: if you load game with a menu open, the icons for it will not disappear. In case of buggy rendering of visuals, you can now press CONTROL + ALT + R to clear all rendered objects.

- We have moved the list of known bugs to a Wiki page so that we can update it without waiting for a new release, [click here](https://github.com/Crimso777/Factorio-Access/wiki/Known-Bugs).

# Version 0.4.8 BETA (Currently at Pre-Release 1)

Pre-release 1 on December 10th, 2023.

This update brings new train features, but due to ongoing development it is a pre-release for now. It includes support for rail forks and for a new sophisticated method to build train schedules from the train stop menus instead of the train menus. 

The update also fixes the recent big bug that crashes the game when a fluid slot of a building is empty. If you will not use the new features but you want the bugfixes, you can download the pre-release anyway.

Before the full release, early feedback is needed for improving the features and also some more train-related additions will be made in order to make complex automatic train systems better supported.

## New features

- Added rail fork building.
  * At vertical and horizontal end rails, you now have the option to build forks. You can either build a two-way fork that splits to the left and right, or a three-way fork that includes also the forward direction.
  * The rail analyzer will pick up a fork ahead and list the available directions for it. When manually driving through a fork, you need to hold A or D to pick the direction you want to take.
  * More than one automatic train and more than zero rail forks in the same railway system is an extra dangerous combination that can have train crashes and deadlocks, and so it is recommended to plan carefully.

- Added a new method of building train schedules, from train stop menus.
  * The new method allows building more complex train schedules that the instant scheduling tool cannot handle, but for now you need to first manually drive to each station so that you can add it to your schedule.
  * The new method also brings support for new waiting conditions: The train being inactive, the train being completely full or empty, or the train having any or no players on board.
  
- The train menu now has the option to toggle manual or automatic dirving modes.

- New launcher improvements.
  * Fixed localization issues.
  * Improved the automatic config updater.
  * Greatly increased pause time after printing tracebacks to allow easier bug reporting.
  
- New sandbox map added with cheats enabled.
  * This is map where you can design your factory areas or play around with minimal restrictions.
  * On this map you have all technology unlocked and you can craft almost every recipe by hand instantly.
  * This map has no enemies or cliffs, forests spread far apart, and just one lake in the middle. Ore patches are extra rich.
  * The starting area has an infinite electric energy interface and some infinity pipes to supply endless amounts of fluids. The infinity chest will delete anything you put in it.

## Planned Features

- Expanding subautomatic travel so that you can pick any train stop from the map and TRY to make the train go to it. This will be easier and safer than having to manually drive across a system with several trains and forks in it.

- New scanner categories for enemies, players, and vehicles.

- Adding train bypass structures, which will allow improved traffic flow in train systems with multiple automatic trains.

- Improved reading of a train's schedule from its own menu, such as by including the waiting conditions.

## Changes

- In some cases, the rail appender is unable to build a rail somewhere even though you can manually place it. Such cases are now identified and stated.

## Bugfixes

- Fixed a group of crashes that happened when examining fluid-containing buildings that are currently empty.

- Fixed the issue of the player character sometimes randomly walking around when a train related menu is opened.

## Known bugs

- We have moved the list of known bugs to a Wiki page so that we can update it without waiting for a new release, [click here](https://github.com/Crimso777/Factorio-Access/wiki/Known-Bugs).

# Version 0.4.7 BETA

Released on December 3rd, 2023.

In this update we have transport belts report more information about items moving on them and we made some good progress for combat support in Peaceful Mode. The wiki pages are being extended to match.

## New features

- Additional transport belt info.
  * If the belt is empty now but it very recently carried an item, this will be stated so that belts with low traffic can be examined more easily.
  * Entity info for a belt now explains whether one or both lanes of a belt unit are full and stopped (also called being saturated or compressed). A lane being full and stopped means that it is backing up due to having more inputs than outputs. Often, this is a good thing in Factorio because it is easier to follow a system with excess supply rather than excess demand.
  
- Added enemy proximity alert system.
  * You hear a soft alert like a marching sound if you are within 100 tiles of an enemy.
  * The alert is more rapid when within 50 tiles and most rapid when within 25 tiles, which usually is when aggressive enemies would notice you and attack you.
  * The alert does not yet account for the number of enemies, only the position of the nearest one.
  * Note that enemies already make their own movement and attack sounds when you are nearby.
  * We aim to make this alert system more sophisticated with help from the community.
  
- When an entity from your force takes damage, you hear an alert followed by an explanation about it.
  * This alert has a cooldown of 5 seconds between each warning so that the alerts do not block all other sounds.
  * Additional features such as teleporting to the attack area are being considered.
  
- When an entity from your force is destroyed, you hear an alert followed by an explanation about it.
   * Additional features such as teleporting to the attack area are being considered.

- When any player is killed, all other players hear an alert about it, including an explanation.
   * This feature is still being tested.
   

## Changes

- None.

## Bugfixes

- Fixed a new crash that occurs when you control-click with an empty hand.

- Fixed a group of crashes that occur when you try to do essentially anything while waiting to respawn.

- Fixed the cursor momentarily picking up your character while changing direction in smooth walking mode.

## Known bugs

- Newly noted: The death screen has no keyboard support. The screen reader is required.

- We have moved the list of known bugs to a Wiki page so that we can update it without waiting for a new release, [click here](https://github.com/Crimso777/Factorio-Access/wiki/Known-Bugs).


# Version 0.4.6 BETA

Released November 16th, 2023. 

In this update we fixed several bugs and massively cleaned up the code layout to allow more flexibility in setting keybinds. This may have brought about new bugs but we tested and fixed bugs for a few hours. 

We have also improved the launcher and added a new demo map. We also explored if we can support some other mods and started making a list on the Wiki for compatible other mods.

## New features

- Added or confirmed compatibility for some other mods, and started listing them on a new wiki page, [click here.](https://github.com/Crimso777/Factorio-Access/wiki/Compatible-Other-Mods).
  * AAI Containers & Warehouses, by Earendel
  * AAI Loaders, by Earendel (requires a patch made in this update)
  * Void Chest Plus, by Optera
  
- Launcher improvements.
  * Revised the multiplayer friends list menu design for improved clarity.
  * Config file management improved. Changes we make to the config file no longer overwrite the existing settings without asking you when you launch the game.
  * There is now support for the Steam version of the game although it takes a few steps to configure it, and we still recommend using the standalone version of the game.

- Third demo map added. 
  * This is a continuation of the first demo map and it features more systems like nuclear power and a rocket silo. 
  * Note that it was created using game editing and so the factory is missing certain assembling areas, especially those for advanced science packs.
  
- Rail intersections are now identified when the cursor is over them.

- Checking the status of any rail now reads the distance and direction to the nearest rail intersection.

- Added basic custom graphical images to indicate which menu is open. 
  * These GUI images appear even on top of other menu interfaces. 
  * The existing rendered icons have been made cleaner and smaller. We decided to keep them because they are still helpful for others to see what menu you have open.
  
## Changes

- Extensive redesign of the main functions of the code to improve readability and keybind support.
  * Actions are now named more clearly on the key binds list.
  * Some multi-purpose keys were split into multiple functions that can safely be called at the same time.
  * Comments were added throughout the code to make it easier to follow.
  * Improved handling of player preference related code for when we add support for it.
  
- Restored support for using arrow keys for the scanner results by default. Note that this works only outside of menus.

- Tweaked rail crossing alarm system to extend its range and improve its visuals.
  
## Bugfixes

- Reduced the reading of flying text after removing objects. This should minimize lag and crashes due to too much flying text.

- Fixed a bug that made smooth walking mode not detect objects well when you turn.

- Fixed a bug where the character would run around unexpectedly.

- Fixed a crash during the rail analyzer reverse direction.

- Fixed a multiplayer issue where resources would not be scanned by non-host players who did not restart the game.

- Fixed cursor area scanning reporting random resources at zero percent.

- Stopped the reading tiles when driving unless in cursor mode, but even then the reader is limited.

- Fixed the speed reading of vehicles.

- Fixed the speed reading of mining drills affected by modules.

## Known bugs

- We have moved the list of known bugs to a Wiki page so that we can update it without waiting for a new release, [click here](https://github.com/Crimso777/Factorio-Access/wiki/Known-Bugs).

# Version 0.4.5 BETA

Released November 3rd, 2023.

This is a fairly small update about fixing recent major bugs and requested features. 

## New features

- You can now change how long a train waits at its stations.
  * This is done on the train menu. To apply the changed number, you need to recreate the instant schedule.
  * Increase or decrease by 5 seconds using PAGE UP and PAGE down respectively.
  * Increase or decrease by 60 seconds using CONTROL + PAGE UP and CONTROL + PAGE down respectively.
  * The same number is applied to all stations for now. A far more flexible train scheduling system was thought out but will be added later.

- Build lock mode now has special support for big electric poles and substations.
  * For big electric poles, you place them when 28 to 30 tiles apart, which is the max wire reach.
  * For substations, you place them about 18 tiles apart, which is both the max wire reach and the supply area.

## Changes

- Improved building slot reading
  * Fluids are named as inputs or outputs and their counts are given.
  * Empty module slots are distinguished as such.
  * Filter slots are now numbered. Note that the last slot is usually the whitelist/blacklist switch which determines the policy for all the other slots.

- Reading another player character will now say their name.

- Visual improvement: The tile highlighter for the cursor is now always drawn, whether an entity is selected or not.

- Many changes under the hood for code cleanup. More is on the way so that we can allow better user settings such as choosing your own keybinds.

## Bugfixes

- Hopefully actually fixed the multiplayer bug of only the host player being able to scan for most resources (the aggregated ones).

- Potentially fixed a multiplayer issue where characters run out of their assigned tiles in telestep mode.

- Fixed filter inserters crashing the game due to a recent inventory reading update.

- Fixed several bugs and crashes that were due to issues exposed after tidying up the tile reader code.
  * This includes teleporting to the cursor, connecting or disconnecting train wagons, and more.

## Known Bugs 

- Nudging bugs
  * Nudged buildings might illegally overlap with each other.
  * Fix in progress: Nudged electric poles do not update their wire connections.
  * Transport belts and splitters cannot be nudged.
  
- Due to a matchamking server issue, multiplayer apart from LAN play is not possible unless you use port forwarding, or the vanilla graphical menus.

- A few technology descriptions have errors.

- Higher tier modules have the same descriptions read as tier 1 modules despite having stronger effects (and different written descriptions).

- The scanner tool does not update forests correctly after cutting trees.

- Extending a rail after building a train stop sometimes causes problems.

- Lab research speed is reported slightly incorrectly when modules are added.

- Electricity connection preview information is sometimes incorrect if you are at the edge of a supply zone.



# Version 0.4.4 BETA

Released on October 29th, 2023.

## New features

- Added vanilla mode to make the mod more similar to vanilla Factorio for sighted players playing multiplayer.
  * Toggle this mode with CONTROL + ALT + V
  * Effects: The narrator is mostly muted and the cursor allows free movement with the mouse.
  * Note: As before, the vanilla cursor preview can be rotated using SHIFT + R.

- Extended localisation support. Volunteer translators are welcome!
  * It now includes the scanner tool and inventory slot locking.
  * Added comments to localisation file to make it easier to translate.

- You can now get the relative position of the cursor by pressing SHIFT + K. Meanwhile, just "K" still gives absolute coordinates and relevant entity part.

- In cursor mode, you can now use arrow keys to move the cursor by one tile regardless of the cursor size. This allows more precisely covering the area of interest when scanning areas.
    
## Changes

- Changed the config file to support both vanilla and mod-specific controls as much as possible by default.
  NOTE: If you want to keep your config settings from before the update, save your old config file and restore it after installing the update files.

- Improved group mining feature.
  * If you press SHIFT + X on a tree or a rock or a ground item or an empty tile, all such obstacle objects within 5 tiles are cleared out.
  * If you press SHIFT + X on a rail, all rails and signals within 5 tiles are mined. 
  * If you are holding the instant mining tool (the cut paste tool) in hand and you press SHIFT + X, everything that can be mined within 5 tiles is mined, except for resource patches.

- Improved visual effects.
  * Teleporting now produces some smoke.
  * When the technology or fast travel menu is opened, an icon is drawn over the character's head to note that they are focused on that menu.
  * Larger cursor sizes are now drawn more responsively.
  * Entities selected by the cursor are highlighted more effectively.
  
- New launcher with revised features.
  * You can now continue your last game where you left off.
  * When entering multiplayer, your player name is read out for you.
  * The menus have been rearranged to be clearer.
  * A matchmaking server issue has been identified as the reason for connection issues. Therefore multiplayer across the internet requires workarounds. you need to use LAN, or port forwarding, or the graphical vanilla matchmaking menus after launch.
  
- New direction and distance calculation functions that should be more accurate.

- The number of output slots announced for a chest is now the number of unlocked slots instead of the maximum capacity.

- Machine inventory slots reserved for particular input or output items or fluids are now read out precisely instead of using crowded "or" statements.

- Flying text in connection to mining entities is no longer read unless you are moving.

## Bugfixes

- The cursor now more effectively centers on entities so that they can be read during smooth walking.

- Changed the way tiles are read such that there should be fewer crashes related to this.

- Fixed a crash due to switching menus while no guns are equipped. 

- Fixed (hopefully) a crash related to the scanner scanning invalid entities.

- Fixed a crash related to while loops used when instant mining.

- Fixed teleporter sound.

- Fixed a bug where aggregated resources like ore patches were lost from the scanner list.

- Fixed (hopefully) a bug where aggregated resources like ore patches were lost to all non-hosting players in multiplayer.

- Fixed (hopefully) multiplayer mode player messages getting mixed up.

- Water tyle types such as deep water are now correctly recognized by the cursor scan.

## Known Bugs 

- Nudging bugs
  * Nudged buildings might illegally overlap with each other.
  * Fix in progress: Nudged electric poles do not update their wire connections.
  * Transport belts and splitters cannot be nudged.
  
- Due to a matchamking server issue, multiplayer apart from LAN play is not possible unless you use port forwarding, or the vanilla graphical menus.

- A few technology descriptions have errors.

- The scanner tool does not update forests correctly after cutting trees.

- Extending a rail after building a train stop sometimes causes problems. For now, you should remove the train stop anyway because they need to be near the ends of rail tracks.  

- Lab research speed is reported slightly incorrectly when modules are added.

- Fix in progress: Some resources do not appear on the scanner list, especially for non-hosting players in multiplayer mode.

- Electricity connection preview information is sometimes incorrect if you are at the edge of a supply zone.

# Version 0.4.3 BETA

Released on October 26th, 2023.

## New features

- The scanner and teleporter now have sound effects and visual effects.

- Recipe item lists now include how many seconds it takes to craft the recipe at default speed.

- When you press K for a recipe being selected in a building, its item list is read out. 

- Scanned chests will now summarize items inside
* "Empty" for empty chests
* The item name for chests with one item type.
* "Various items" for chests with more than one item type.

- Non-zero speed bonuses of any machine are now reported in its status message.

- Non-zero productivity bonuses of any machine are now reported in its status message.

- Hitting the top and bottom of the scanned item list will make a sound like with the inventory edges.
  
## Changes

- Tweaked some aspects of status message reporting.

- Smooth walking mode now detects every entity including ores on the ground.

## Bugfixes

- Fixed some crashes related to fast travel.

- Fixed some crashes related to multiplayer mode (pindex handling).

- Fixed the cursor incorrectly updating after several actions such as teleporting to it.

- Fixed an unstable teleporting bug that arose from teleporting to the cursor repeatedly.

## Known Bugs 

- A few item and technology descriptions have errors (speed modules, logistic robotics).

- The scanner tool does not update forests correctly after cutting trees.

- Extending a rail after building a train stop sometimes causes problems. For now, you should remove the train stop anyway because they need to be near the ends of rail tracks.  

- Transport belts and splitters cannot be nudged.

- Nudged buildings might illegally overlap with each other.

- Lab research speed is reported slightly incorrectly when modules are added.

# Version 0.4.2 BETA

Released on October 21st, 2023.

## New features

- Added a config file editor where you can edit game settings that appear in the config file. This includes settings such as autosave intervals and keyboard controls.

- When building in cursor mode, press K over an empty tile to learn the dimensions and directions of the building preview in hand.

- Checking the status of a machine now provides info about its working speed, power usage, and health.

- Added support for using repair packs to repair buildings. Note that this does not use the internal repair code and may have bugs.

- Building preview graphical improvements.
  * Added a direction indicator arrow, because we are unable to rotate the cursor sprite.
  * Added build preview footprint rectangle drawing, because we are unable to de-render the misaligned cursor sprite.

- Added graphical highlighting for the mod's cursor so that it can be followed on screen much more easily.

- Items being held by inserters are read out.

- Rocks can be cleared automatically now.

- New area mining for group mining. If you press SHIFT + X on an empty tile, all nearby trees and rocks are mined automatically. This is in addition to this working when you already select a tree or rock.
  
## Changes

- Improved launcher
  * Map presets are no longer separate from savegames, for simplicity. The last map generated gets saved once and you need to save it under a new name yourself if you want to keep it.
  * Multiplayer mode now has basic matchmaking by using the friends list system.

- Revised building preview positions for the cursor. Almost always, the cursor holds a building preview from its northwest corner. 
  * The exceptions are when the preview would overlap with the character: Only when the character is not in cursor mode, looking north will make the building held from the southwest corner, and similarly looking west will make the building held from the northeast corner.

- Revised tile paving system
  * When you place down paving tiles, they are now placed at where the cursor is rather than where the player is. The preview is centered on the cursor tile unlike building previews, which are held from the north west corner.
  * Changing the cursor size now changes the paving preview size. For example, size 1 means a 1 by 1 paving preview is used.
  * The same changes apply for mining tiles around the cursor. Note that when you remove too many tiles at once, the narrator is overloaded temporarily.
  * Paving is interrupted if you run out of items for it.
  
- Improved build lock mode.
  * It now works when smooth walking. Note that hearing the error sound for entities bigger than one tile is normal while the repeated building might continue.
  * When not in cursor mode and a transport belt is in hand and the character changes direction, the building direction changes with them so that the belt follows the player.

- Revised cursor resizing code. Cursor size options are now 1, 3, 5, 11, 21, 101, and 251.

- Fluid amounts inside fluid containers are now read.

- Entities out of player reach are now noted as such when you try to interact with them using the cursor.

- Scanner announcements explain distances sooner and now with more precision about directions.

- Improved cursor handling, such as making the cursor jump automatically to entries selected on the scanner list.

- When you are holding an item in hand while trying to open a building interface, the game will allow it if the item is not a type that can be built or paved.

- Your hand is now cleared when you enter or exit a vehicle.

## Bugfixes

- Fixed issues with some entities such as transport belts not being detected during smooth walking.

- Fixed the cursor scanner being unable to read paving tiles.

- Fixed a crash related to changing the scanner sorting method.

- Fixed a bug that prevents teleporting to valid resource areas that are not single entities.

- Fixed an issue that applied incorrect checks to building previews.

- Fixed a crash related to nudging buildings.

- Fixed bugs related to opening the fast travel menu and warnings menu in situations that do not support it.

- Fixed crashes during using cursor mode while driving.

- Fixed a bug about reading train fuel

## Known Bugs 

- The scanner tool does not update forests correctly after cutting trees.

- Extending a rail after building a train stop sometimes causes problems. For now, you should remove the train stop anyway because they need to be near the ends of rail tracks.  

- Transport belts and splitters cannot be nudged.

# Version 0.4.1 BETA

Released on October 9th, 2023.

## New features

- New Launcher (so you need to use the new release). The launcher supports a wider range of vocalizers including built-in ones.

- Basic multiplayer support, but with limited testing!

## Changes

- Entity part reporting is now more precise and concise.

- The currently selected scanner entity is visually marked with a white circle.

## Bugfixes

- Fixed a fatal crash that occured when a ore tile is depleted.

- Rewrote large cursor area scanner tool so that it correctly reports entities and resources in an area.

- Fixed the repetition of ingredient and product lists for crafting recipes and technologies.

- Fixed a bug where technologies with prerequisites were incorrectly said to have none.

- Fixed a crash due to teleporting to an entity that no longer exists (like when you mine it).

## Known Bugs 

- Placing a paving tile places it at the player's feet regardless of the size and location of the cursor.

- The scanner tool does not update correctly regarding forest patches.

- Changing the scanner sorting rule causes crashes.

- Extending a rail after building a train stop sometimes causes problems. For now, you should remove the train stop anyway because they need to be near the ends of rail tracks.  



# Version 0.4.0 BETA

Released on October 6th, 2023.

Note, as a beta release, there may be more bugs and compatibility issues than usual. While we try to minimize these, it is important to protect your save files by saving under a new name as soon as you open a version 0.3 save file in version 0.4.

## New features

- General vehicle support
  * Entering and exiting a vehicle will notify you about the vehicle name.
  * Press K inside a vehicle to learn the heading and coordinates.
  * Pressing L while inside a vehicle will provide additional information about it. For cars, the fuel stocks are stated. For trains, basic info is given while the train menu has detailed info.
  * You can refuel a vehicle by dropping a fuel item stack in hand into it via CONTROL + LEFT BRACKET.
  * You can check the fuel inventory contents by pressing RIGHT BRACKET.

- Trains Implementation. Phases 0 through 3, out of 5, are complete. In general, we made it accessible to build rail lines, analyze rail segments, build train stations, build and examine trains, and drive trains manually or automatically between two stations.
  * Added info support for rails. There is now distinction between end rails, station rails, etc. and the directions of rails are given.
  * Added support for building and renaming train stops.
  * Added train station rail information tool. When you look at a rail behind a train stop, you get information of which section of which rail vehicle would be positioned there when a train stops at the station.
  * Rail appender tool: Adds a straight rail to extend any straight end rail near the cursor.
  * Rail structure building menu: Allows building correctly oriented railway structures based on a selected end rail as the anchor point. Also can add signals to mid rails.
  * Functions added to build 45 degree turns and 90 degree turns as structures at end rails.
  * Added support for building and naming trains.
  * Allowed reading the fuel amount in a locomotive: check its status via RIGHT BRACKET.
  * The contents of cargo wagons and fluid wagons can be checked via RIGHT BRACKET.
  * Information about a train can be read from its menu including name, length, vehicle counts, cargo item counts, etc.
  * Rail analyzer tool: Press J inside a train to learn the nearest structure ahead on the rails and the distance to it. Press SHIFT + J to check the opposite direction.
  * Rail analyzer tool works on foot as well.
  * Subautomatic travel added: You can select an option from the train menu to make a train go by itself to a far away station and wait until all passengers get off.
  * Automatic travel via instant train scheduler added. An instant automatic schedule rotates between every reachable train stop and waits at each for 5 minutes.
  * Trains announce to passengers their next stations when departing or arriving.
  * Trains announce to passengers when waiting at rail signals.
  * Rail crossing alert tool added. Slow beep means a train moving somewhere within 200 tiles. Fast beep means an automatic train within 100 tiles is heading towards your general direction. Frantic fast alarm bells mean that you need to get off that rail ASAP!
  * Rail chain signal placement designed to be same as in Vanilla. You need to craft any signals you place and they are refunded when mined.
  * Other additions all across the code to support trains.
  * Note 1: In terms of missing features, there is currently no support for rail forks, one-way rails, and fine control over train schedules.
  * Note 2: Parallel rail lines should be at least a few tiles apart. This is partially enforced for the rail appender tool.
  * Note 3: See Chapter 16 of the wiki for more info.

- Improved electric pole support with new features.
  * Selecting an electric pole now lists all the wire connection distances, and counts the energy consumers and producers within its supply area.
  * The pole's electric network's demand satisfaction percentages are now reported, as well as the network flow rate and capacity. Check with RIGHT BRACKET.
  * If an electric pole has no power flowing (as in 0 satisfaction), the nearest supplied electric pole is reported.  
  * When placing an electric pole, all connectible electric poles around it are listed. If there are none, the nearest electric pole is listed. This context info allows better understanding of electric networks.

- Added building preview information for several structures. This information is based on the cursor location while an item to be built is held in hand.
  * For small buildings, the preview can warn when building is not possible.
  * For transport belt types, the belt junction type that would form by placing the belt there is stated.
  * For underground belts and pipes to ground, whether and where the currently selected tile would connect is stated.
  * For pipe units, the expected fluid pipe connections around are stated, and there is a warning about potentially mixing fluids.
  * For electric powered machines, if power is connected, an electric pole that supplies it is listed. If not, the nearest electric pole is listed. Note that this feature is a little inaccurate around supply area boundaries except when in cursor mode.
  * Other similar changes.
  
- Added support for splitter priority settings.
  * Press SHIFT + LEFT ARROW to set the INPUT priority to the left side, meaning that the splitter will take from the right only when it cannot from the left.
  * Similarly press SHIFT + RIGHT ARROW to set the INPUT priority to the right side.
  * To clear the input priority, try to set the same side again.
  * Press CONTROL + LEFT ARROW to set the OUTPUT priority to the left side, meaning that the splitter will output to the right only when it cannot to the left.
  * Similarly press CONTROL + RIGHT ARROW to set the OUTPUT priority to the right side.
  * To clear the output priority, try to set the same side again.
  
- Added support for splitter filter mode.
  * With an item in hand, press CONTROL + LEFT BRACKET on a splitter to set its output filter to the item. When there is a filtered item, it goes out one side and every other item goes out the other side.
  * By default the filter output goes left. To change the filter output side, press CONTROL + ARROW KEY accordingly. There is no equal distribution in filter mode.
  * To clear the filter, with an empty hand press CONTROL + LEFT BRACKET on the splitter. 

- Added support for armor and armor equipment modules.
  * NOTE: All the following controls apply when the inventory (alone) is open, meaning that no buildings are open.
  * Press LEFT BRACKET to pick up the item and then press SHIFT + LEFT BRACKET to equip it. Armor equipment requires wearing armor that can support it.
  * Press G to read armor name and equipment statistics, if any. "G" is for "Gear".
  * Press SHIFT + G to read the list of equipment.
  * Press CONTROL + SHIFT + G to remove all equipment and armor.
  
- Added support for hand weapons / guns.
  * Your weapons inventory can hold up to three weapons. You cycle between them by pressing TAB when not in a menu. You also have three corresponsing ammo slots.
  * NOTE: All the following controls apply when the inventory (alone) is open, meaning that no buildings are open.
  * Press LEFT BRACKET to pick up the weapon or ammo stack and then press SHIFT + LEFT BRACKET to equip it.
  * Press R to read current weapons and ammunition counts. "R" is for "arms" or "reloading".
  * Press SHIFT + R to reload all weapon ammunition slots from your inventory. Note that existing ammo stacks will be prefered over fuller ammo stacks of different types.
  * Press CONTROL + SHIFT + R to remove all weapons and ammunition.
  
- Added entity part identification: When you press K with the cursor hovering over an entity, its selected part will be reported, such as the southeast corner or the center.

- Added build lock smart placement for medium electric poles. They are placed to allow maxiumum continuous area coverage rather than maximum wire reach.

- Group mining added for some groups: If you press SHIFT + X on a tree or a rail, it will mine all of them immediately around you instead of only one.

- Mine lock added: Press CONTROL + X to hold the cut-and-paste tool. Every building the cursor touches while holding this tool will be mined instantly if possible. To disable to tool, empty your hand with SHIFT + Q.

- Added support for placing stone bricks and concrete varients as paving tiles, for making pathways or decoration.

- Added support for placing landfill over water. Note: This is not reversible.

- Added support for throwing capsule items, including cliff explosives, defender drones, and grenades. Note: Grenades will damage everything including you while cliff explosives affect only cliffs.

- Added support for nuclear power buildings: Temperature readings and other relevant information is now provided.

- Added support for rocket silos. They can now report rocket part counts and launch rockets when ready.

## Changes

- You are now able to walk over pipes and under small or medium electric poles. This change reflects both what popular mods support already. Also tip: In smooth walking mode, you can already squeeze around inserters and chests or in between most side-by-side buildings.

- The intermediate walking mode has been removed so that you can easily switch between telestep and smooth walking. When in game mod settings are supported in the future, we plan to bring it back.

- Transport belt junction types are now better identified.
  * Note that a "pouring end" could either be sideloading onto a different belt, or continuing into a belt corner which preserves the lanes.
  * Safe merging junctions (also called T-junctions) are identified as a belt unit that is double sideloaded but empty at the back so that the lanes will be entirely predictable.
 
- Underground belts can now be identified as entrances or exits, explaining whether items are flowing into the ground or out from it.

- Teleporting is disabled while riding a vehicle.

- Reported local time has been shifted by twelve hours so that daytime is 6 to 18 and midnight is around 24.

- Minor changes
  * Changed the keybind for disconnecting rail vehicles from "V" to "SHIFT + G".
  * Entity ghosts are now better identified.
  * Items on the ground are now better identified.
  * Boilers and heat exchangers now report their fluid contents.
  * For all entities reporting fluid contents, any extra fluids are also reported.
  * Beacon contents are now read.
  * Containers now report their top 2 items at first look, instead of 1. 
  * If the player inventory being full prevents an item transfer, this should be announced correctly.
  * Added new sound effects for the cursor reaching the borders of inventories.
  
## Known bugs

- The scanner tool does not update correctly regarding forest patches.

- Sometimes browsing the scanner list can cause crashes.

- Extending a rail after building a train stop sometimes causes problems. For now, you should remove the train stop anyway because they need to be near the ends of rail tracks.  

## Bugfixes

- Fixed a bug where the inventory is opened directly when a Factorio Access menu is closed.

- Fixed a bug where entities that have not started using their fuel are reported as out of fuel.

- Fixed various crashes related to reading invalid items.

- Corrected the information error where items cannot be transferred to another building. It is not necessarily because it is full.

## Code Changes

- Temporary fixes applied for sweeping scanner bug crashes under the carpet. The bugs will need to be revisted. They are marked with the word "beta" written between two pairs of asterisks.

- New helper functions
  * get_direction_of_that_from_this - Reports 8 main directions, intentionally biased towards reporting diagonals.
  * direction_lookup - convert direction defines integer to a text.
  * rotate_90 and rotate_180, for changing direcitons
  * mine_trees_and_rocks 
  * get_entity_part_at_cursor 

- For several main functions, parts of them were taken out and made new functions that can be called from multiple places.

- Added new file "rails-and-trains.lua" that houses most vehicle and train related content, as well as some universal helper functions.

- Added several new controls to data.lua

- Modified some vanilla prototypes collision masks to allow walking through pipes and poles.

- Teleporting function can now also be called silently.

- Future proofing: Renamed all directions in "rails-and-trains.lua" to use the defines instead of hardcoded integers


# Version 0.3.1

Updated 10/26/2022

## New features

-Build lock. When enabled, the game will continuously try to build behind the player as they walk, or under the cursor in cursor mode. Useful for tasks like building long transport belts. Press CONTROL + B to enable or disable. It also automatically gets disabled when you switch into or out of cursor mode or empty your hand and take a step.

-Build lock has a special case for small electric poles where it places an electric pole only if it is within 6.5 to 7.5 tiles of the nearest small electric pole, allowing you to build lines of fully spaced out small electric poles while just walking. Note that not every tile between the fully spaced poles is powered.

## Changes

-Scanner Resource Aggregation: On the scan list, patches of resources will now be read as a group.  This includes all resource types including water, trees, and ores.

-Getting item or entity information with the L key now works for entities on the surface and inside chests and most building menus.

-Getting slot coordinates with the K key now works inside chests and most/all building menus.

-In cursor mode, pressing J will announce that the cursor is returned to the player in addition to doing it.

-Transport belt parts such as corners, junctions, and ends will now be specified when read by the cursor.

## Bugfixes

-Fixed a crash when setting filter inserter filters due to being able to select unsupported fluid recipes.

# Version 0.3.0

Updated 9/30/2022

## New features

-New scanner categorization format.  Scanned entities will now be categorized by what they produce.  You can now tell the difference between a mining drill producing iron, and one producing copper, all from the scan list.

-New Scanner Controls:  Ppress SHIFT+PAGEUP and SHIFT+PAGEDOWN to select a particular building from the scan list.  For example, if you have 3 mining drills, it is now possible to track the one that is 3rd farthest from your position.

-New info: Fluid input and output tiles of buildings will now identify which fluid they should contain. 

-Building status info. Press RIGHT BRACKET with your hand empty when facing a building to read out its status, such as having its output full or missing ingredients. Great for diagnosing problems.

-Chest inventory limiting (bar). Useful for controlling automatically filled chests. When the chest inventory is open, press PAGE UP or PAGE DOWN to increase or decrease the limit by 1. Hold shift while pressing to increase or decrease by 5. Hold CONTROL while pressing to increase or decrease by the maximum amount.

-New inventory transfer shortcut (same as Vanilla Factorio) between building and player inventories. When you have a building inventory open, pressing CONTROL + LEFT BRACKET for a selected item in an inventory will cause an attempt to transfer the entire supply of this item to the other inventory. Non-transferred items will remain in their original inventory. Similarly, pressing CONTROL + RIGHT BRACKET will try to transfer half of the entire supply of the selected item.

-New inventory smart insert shortcut (same as Vanilla Factorio) between building and player inventories. When you have a building inventory open and select an empty slot, pressing CONTROL + LEFT BRACKET will cause an attempt to transfer the full contents of the selected inventory into the other inventory. This is useful for easily filling up labs and assembling machines with everything applicable from your own inventory instead of searching for items individually. Non-transferred items will remain in their original inventory. Similarly, pressing CONTROL + RIGHT BRACKET on an empty slot will try to transfer half of the entire supply of every item.

-New entity info upon encounter: Chests will announce their main contents. Pipes to ground, pumps, and storage tanks will announce the fluids they contain. Accumulators announce their charge percentage and amount. Solar panels announce their current production level based on the time of day. Electric poles announce the current power usage and then the current power generation capacity.

-New info: Transport belt analyzer now announces the position of each lane on the belt segment in front of you. For example, iron plates could be on the south lane of a belt segment facing west. This info is helpful for building sideloading junctions.

-New info: The reserved empty slots for ingredients and products inside assembling machines and chemical plants now announce what is expected to go in them.

## Changes

-Rocks are now categorized as resources because they can contain stone and coal.

-Entity information will no longer state the type of an entity, which usually was a repeat of the entity’s name.

## Bugfixes

-When you open a menu or an inventory, the item in the first slot was not being read. This should be fixed now for all menus.

-Transport belt analyzer now correctly reads contents of upstream belts

## Other

-Thanks to everyone who filled out the player survey!



# Version 0.2.0

Updated 07/27/22

New Features

-A new Freeplay map designed by @Sir Fendi, designed to introduce new players to Factorio Access.  Select Compass Valley from the list of difficulties to try it out.

-A new Fast Travel system.  Press V to open the fast travel menu, and save your cursor's location for later.  You are free to name, rename, delete, and create new points whenever you like.

-A new way to navigate your factory: BStride.  Travel from building to building as if they were laid out in a nice even grid.  Press CONTROL + S to open the BStride menu, then navigate with WASD.  Pick a direction, navigate the resulting list of options, and confirm a direction with your initial direction key.  For instance, if I wanted to go to the second building north of me, I'd press W to open the northern buildings list, D to select the second building from the list, then W again to confirm.  Press Left Bracket to teleport to your target building.

-Throughput summaries are now provided when looking at a building.  Simply walk up to a belt or pipe, and the mod will tell you what's on/in it.

-Trying to teleport to a building will no longer give an error.  Now you will teleport to the nearest free position, and the mod will tell you where you are in relation to your target.

-Pressing CONTROL + HOME will now teleport the player to the closest available position near the target, or if in cursor mode the old behavior will still occur.

-Mining a building now has audible feedback

-Copy building settings with SHIFT + RIGHT BRACKET, and paste the settings on another building with SHIFT + LEFT BRACKET.

-Visual cursor now follows the virtual cursor

-Game no longer requires callibration 

-Spaceship containers now include audible feedback when opening and closing.

-Default scan range is now 250 tiles in either direction of the player.

-Added building nudging. Nudge building by one tile by pressing CONTROL + SHIFT + DIRECTION, where the direction is one of W A S D.

And Many Many bug fixes thanks to @MyNameIsTrez

# Version 0.1.2

Updated 07/15/22

Bug Fixes:

-Pumps should now say the correct output direction, even when they are facing north.

-Fixed a crash involving pumps and left clicking before navigating the pump menu

-Fixed bugs regarding filter inserters and their unique menu structure

-Fixed game crashing if butttons were pressed before callibration

Features:

-Game will now announce to player when tab is necessary to start the game

-Updated descriptions for certain entities

-Objects that cannot be rotated will now appropriately say so

-Added item information in crafting menu.  Press L to get a description of a recipe's product


# Version 0.1.1

Updated 07/09/22

Bug Fixes:

-Fixed errors when mining things such as trees.  Thanks @Eph

# Version 0.1.0

Updated 07/07/2022

New Features:

-Added transport line analyzer:  LEFT BRACKET while facing a belt to open the new and improved transport belt menu.  Use tab to toggle between the contents of the single tile you are looking at, the entire transport line's contents, and analysis of belts upstream and downstream from the examined belt.

-Added Warnings menu:  Press P to see the new warnings menu.  Warnings are little icons that appear over buildings graphically and indicate something is wrong with the building.  Examples include not connected, no power, and no fuel.  LEFT BRACKET while over a warning to jump to the building in question.

-Added localised descriptions for all items and entities in the game.  Press L while over an item in inventory to get detailed information about the item.  Special shoutout to @Sir Fendi and @MyNameIsTres for making this possible.  

-Selecting items will now notify the player what is currently in the hand.  Thanks to @Eph for making this happen

-Added various mouse controls while on the main map.  Examples include CONTROL + LEFT BRACKET and CONTROL + RIGHT BRACKET for fast transfer and fast split respectively.  This means to put the entire stack you are holding in a building, press CONTROL and LEFT BRACKET while focused on a building.  To put half, press CONTROL + RIGHT BRACKET.  Thanks again to @Eph for his work in this regard

-Jumping cursor to scan items no longer requires entering cursor mode.  This should make it easier to get where you need to go.

-Read-Tile now gives additional information including the recipe that a production building is using, whether it is connected to power or out of fuel.

-Q now speaks the item held in hand.  SHIFT + Q now performs actions that Q previously executed.

Various Bug Fixes.


# Version 0.0.5

Updated 06/23/22
New Features:

-Manual Recalibration: Press CONTROL + END to recallibrate.  Very useful if you frequently zoom in

-Sort by number of entities found in a scan: Press SHIFT + PAGEUP and SHIFT + PAGEDOWN to alternate between scanning modes

-Modular Cursor:  Change the size of your cursor with CONTROL + I and CONTROL + SHIFT + I

   note:  The cursor is only modular in cursor mode, so you will need to press I first in order to enter cursor mode.

-Scan Summary: The modular cursor will give a list of important information for the area scanned, in addition to adding the normal elements to your scan list.  For now end only triggers the normal re-scan around the player's location.

-Building filters are now accessible

-New Item selector:  Only implemented for filter building slots currently, if popular could make navigating recipes and technologies easier too.

-Examining a resource tile will now speak the amount of resources left to be mined.

-Added more descriptive feedback regarding entities that cannot be rotated

Various bugfixes:

   -Fixed bug where teleporting wouldn't properly update the cursor and player locations

   -Fixed bug where electric poles wouldn't speak connected/not connected while over a resource

   -Fixed bug where offshore pumps wouldn't read output correctly

   -fixed bug(hopefully) where a scanned item would disappear from the scan list requiring a re-scan

   -fixed bug where opening inventory during callibration would bypass callibration

# Version 0.0.4

Updated 6/16/22

-Variety of bug fixes:

   -Game will no longer crash when changing category before the initial scan

   -Electric poles now correctly say connected based on cursor location, not player location

   -Belts that become invalid should no longer crash the game

   -Oddly shaped buildings should now read all input/output regardless of orientation

-Brand new movement modes brought by @Eph on Discord.  Toggle between them with Control+W

   -Telestep: The good old movement you all know and try to love

   -Step-By-Walk: Should be the same as telestep but with footstep sound effects.  

   -Smooth-Walking: Effectively turns off the read tile system unless you walk into something you cannot pass through.  Great for navigating forests, squeezing between furnaces, and getting places quickly.  No more angry tapping.

Note: The new movement system may have some undiscovered bugs, so please be patient and report in the Issues channel on Discord.

-Significant improvements to scanning and initialization performance.

-A fresh new .jkm file for Jaws users.  This should also speed up performance.  Consult the readme for instructions on how to install this file.


# Version 0.0.3

Updated 6/15/22

-Added accessible menu for placing offshore pumps

-Added f to the list of keybinds in the readme


# Version 0.0.2

Updated 6/15/22

-Started a changelog, version numbers will be reflected here but not in the mods folder just to keep things simple

-Added tile based descriptions of a buildings input/output.  To see this information, use cursor mode and move around the perimeter of the building.  

   For instance: moving the cursor over the top left corner of a burner mining drill will speak "output 1 north" indicating that things come out of the building, and this occurs 1 tile north of the cursor.

-Added descriptions for direction a building is facing

--Added power output description when cursor is over a generator type building

   note: solar panels are programmed differently, so will require more work for power output information.

-Added total network power production to description when cursor is on electric poles

-Added several new categories for scanning

-Empty categories will now be ignored, and the player will not have to move through them.

-Added a Jump to Scanned feature, whereby the player can jump their cursor to the location of something in the scan list.

   This is done with control+home and can only be done while in cursor mode

-Underground belts and pipes are now somewhat accessible.  Once placed they will indicate the location of their connected partner. 

   Note, these objects do not yet speak "connected" or "not connected" while placing them, but that too will be added this week.

-Modified building logic to be more reliable.

-Building from cursor now supported.  Player must be in range of the target location, and the target location must be unoccupied

-Removed unnecessary empty inventories from buildings

-Callibration once again has a failsafe.  If your callibration failed, you will be prompted to callibrate again.

-Player will now be notified at the end of every autosave, and at the beginning of any autosave triggered by pressing F1

   Note: Notifying at the start of game triggered autosaves is a work in progress, and should be done by end of week.

-Fixed crash triggered by selecting "back" option in launcher save file list
