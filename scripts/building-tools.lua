--Here: Functions for building with the mod, both basics and advanced tools.
local localising = require("scripts.localising")
local fa_utils = require("scripts.fa-utils")
local fa_electrical = require("scripts.electrical")
local dirs = defines.direction
local fa_graphics = require("scripts.graphics")
local fa_rail_builder = require("scripts.rail-builder")
local fa_belts = require("scripts.transport-belts")
local fa_mining_tools = require("scripts.mining-tools")
local fa_teleport = require("scripts.teleport")

local mod = {}

--[[Attempts to build the item in hand.
* Does nothing if the hand is empty or the item is not a place-able entity.
* If the item is an offshore pump, calls a different, special function for it.
* You can offset the building with respect to the direction the player is facing. The offset is multiplied by the placed building width.
]]
function mod.build_item_in_hand(pindex, free_place_straight_rail)
   local stack = game.get_player(pindex).cursor_stack
   local p = game.get_player(pindex)

   --Valid stack check
   if not (stack and stack.valid and stack.valid_for_read) then
      game.get_player(pindex).play_sound({ path = "utility/cannot_build" })
      local message = "Invalid item in hand!"
      if game.get_player(pindex).is_cursor_empty() then
         local auto_cancel_when_empty = true --laterdo this check may become a toggle-able game setting
         if players[pindex].build_lock == true and auto_cancel_when_empty then
            players[pindex].build_lock = false
            message = "Build lock disabled, emptied hand."
         end
      end
      printout(message, pindex)
      return
   end

   --Exceptional build cases
   if stack.name == "offshore-pump" then
      mod.build_offshore_pump_in_hand(pindex)
      return
   elseif stack.name == "rail" then
      if not (free_place_straight_rail == true) then
         --Append rails unless otherwise stated
         local pos = players[pindex].cursor_pos
         fa_rail_builder.append_rail(pos, pindex)
         return
      end
   elseif stack.name == "rail-signal" or stack.name == "rail-chain-signal" then
      fa_rail_builder.free_place_rail_signal_in_hand(pindex)
      return
   end
   --General build cases
   if stack and stack.valid_for_read and stack.valid and stack.prototype.place_result ~= nil then
      local ent = stack.prototype.place_result
      local dimensions = fa_utils.get_tile_dimensions(stack.prototype, players[pindex].building_direction)
      local position = nil
      local placing_underground_belt = stack.prototype.place_result.type == "underground-belt"

      if not players[pindex].cursor then
         --Not in cursor mode
         local old_pos = game.get_player(pindex).position
         if
            stack.name == "locomotive"
            or stack.name == "cargo-wagon"
            or stack.name == "fluid-wagon"
            or stack.name == "artillery-wagon"
         then
            --Allow easy placement onto rails by simply offsetting to the faced direction.
            local rail_vehicle_offset = 2.5
            position = fa_utils.offset_position(old_pos, players[pindex].player_direction, rail_vehicle_offset)
         else
            --Apply offsets according to building direction and player direction
            local width = stack.prototype.place_result.tile_width
            local height = stack.prototype.place_result.tile_height
            local left_top =
               { x = math.floor(players[pindex].cursor_pos.x), y = math.floor(players[pindex].cursor_pos.y) }
            local right_bottom = { x = left_top.x + width, y = left_top.y + height }
            local dir = players[pindex].building_direction
            turn_to_cursor_direction_cardinal(pindex)
            local p_dir = players[pindex].player_direction

            --Flip height and width if the object is rotated sideways
            if dir == dirs.east or dir == dirs.west then
               --Note, diagonal cases are rounded to north/south cases
               height = stack.prototype.place_result.tile_width
               width = stack.prototype.place_result.tile_height
               right_bottom = { x = left_top.x + width, y = left_top.y + height }
            end

            --Apply offsets when facing west or north so that items can be placed in front of the character
            if p_dir == dirs.west then
               left_top.x = (left_top.x - width + 1)
               right_bottom.x = (right_bottom.x - width + 1)
            elseif p_dir == dirs.north then
               left_top.y = (left_top.y - height + 1)
               right_bottom.y = (right_bottom.y - height + 1)
            end

            position = { x = left_top.x + math.floor(width / 2), y = left_top.y + math.floor(height / 2) }

            --In build lock mode and outside cursor mode, build from behind the player
            if players[pindex].build_lock and not players[pindex].cursor and stack.name ~= "rail" then
               local base_offset = -2
               local size_offset = 0
               if p_dir == dirs.north or p_dir == dirs.south then
                  size_offset = -height + 1
               elseif p_dir == dirs.east or p_dir == dirs.west then
                  size_offset = -width + 1
               end
               position =
                  fa_utils.offset_position(position, players[pindex].player_direction, base_offset + size_offset)
            end
         end
      else
         --Cursor mode offset: to the top left corner, according to building direction
         local width = stack.prototype.place_result.tile_width
         local height = stack.prototype.place_result.tile_height
         local left_top = { x = math.floor(players[pindex].cursor_pos.x), y = math.floor(players[pindex].cursor_pos.y) }
         local right_bottom = { x = left_top.x + width, y = left_top.y + height }
         local dir = players[pindex].building_direction
         turn_to_cursor_direction_cardinal(pindex)
         local p_dir = players[pindex].player_direction

         --Flip height and width if the object is rotated
         if dir == dirs.east or dir == dirs.west then --Note, does not cover diagonal directions for non-square objects.
            local temp = height
            height = width
            width = temp
            right_bottom = { x = left_top.x + width, y = left_top.y + height }
         end

         position = { x = left_top.x + math.floor(width / 2), y = left_top.y + math.floor(height / 2) }
      end
      if stack.name == "small-electric-pole" and players[pindex].build_lock == true then
         --Place a small electric pole in this position only if it is within 6.5 to 7.6 tiles of another small electric pole
         local surf = game.get_player(pindex).surface
         local small_poles =
            surf.find_entities_filtered({ position = position, radius = 7.6, name = "small-electric-pole" })
         local all_beyond_6_5 = true
         local any_connects = false
         local any_found = false
         for i, pole in ipairs(small_poles) do
            any_found = true
            if util.distance(fa_utils.center_of_tile(position), pole.position) < 6.5 then
               all_beyond_6_5 = false
            elseif util.distance(fa_utils.center_of_tile(position), pole.position) >= 6.5 then
               any_connects = true
            end
         end
         if not (all_beyond_6_5 and any_connects) then
            game.get_player(pindex).play_sound({ path = "Inventory-Move" })
            if not any_found then game.get_player(pindex).play_sound({ path = "utility/cannot_build" }) end
            return
         end
      elseif stack.name == "medium-electric-pole" and players[pindex].build_lock == true then
         --Place a medium electric pole in this position only if it is within 6.5 to 8 tiles of another medium electric pole
         local surf = game.get_player(pindex).surface
         local med_poles =
            surf.find_entities_filtered({ position = position, radius = 8, name = "medium-electric-pole" })
         local all_beyond_6_5 = true
         local any_connects = false
         local any_found = false
         for i, pole in ipairs(med_poles) do
            any_found = true
            if util.distance(fa_utils.center_of_tile(position), pole.position) < 6.5 then
               all_beyond_6_5 = false
            elseif util.distance(fa_utils.center_of_tile(position), pole.position) >= 6.5 then
               any_connects = true
            end
         end
         if not (all_beyond_6_5 and any_connects) then
            game.get_player(pindex).play_sound({ path = "Inventory-Move" })
            if not any_found then game.get_player(pindex).play_sound({ path = "utility/cannot_build" }) end
            return
         end
      elseif stack.name == "big-electric-pole" and players[pindex].build_lock == true then
         --Place a big electric pole in this position only if it is within 29 to 30 tiles of another medium electric pole
         position = fa_utils.offset_position(position, players[pindex].player_direction, -1)
         local surf = game.get_player(pindex).surface
         local big_poles = surf.find_entities_filtered({ position = position, radius = 30, name = "big-electric-pole" })
         local all_beyond_min = true
         local any_connects = false
         local any_found = false
         for i, pole in ipairs(big_poles) do
            any_found = true
            if util.distance(position, pole.position) < 28.5 then
               all_beyond_min = false
            elseif util.distance(position, pole.position) >= 28.5 then
               any_connects = true
            end
         end
         if not (all_beyond_min and any_connects) then
            game.get_player(pindex).play_sound({ path = "Inventory-Move" })
            if not any_found then game.get_player(pindex).play_sound({ path = "utility/cannot_build" }) end
            return
         end
      elseif stack.name == "substation" and players[pindex].build_lock == true then
         --Place a substation in this position only if it is within 16 to 18 tiles of another medium electric pole
         position = fa_utils.offset_position(position, players[pindex].player_direction, -1)
         local surf = game.get_player(pindex).surface
         local sub_poles = surf.find_entities_filtered({ position = position, radius = 18.01, name = "substation" })
         local all_beyond_min = true
         local any_connects = false
         local any_found = false
         for i, pole in ipairs(sub_poles) do
            any_found = true
            if util.distance(position, pole.position) < 17.01 then
               all_beyond_min = false
            elseif util.distance(position, pole.position) >= 17.01 then
               any_connects = true
            end
         end
         if not (all_beyond_min and any_connects) then
            game.get_player(pindex).play_sound({ path = "Inventory-Move" })
            if not any_found then game.get_player(pindex).play_sound({ path = "utility/cannot_build" }) end
            return
         end
      elseif placing_underground_belt and players[pindex].underground_connects == true then
         --Flip the chute
         players[pindex].building_direction = (players[pindex].building_direction + dirs.south) % (2 * dirs.south)
      end

      --Clear build area obstacles
      fa_mining_tools.clear_obstacles_in_rectangle(
         players[pindex].building_footprint_left_top,
         players[pindex].building_footprint_right_bottom,
         pindex
      )

      --Teleport player out of build area
      mod.teleport_player_out_of_build_area(
         players[pindex].building_footprint_left_top,
         players[pindex].building_footprint_right_bottom,
         pindex
      )

      --Try to build it
      local build_successful = false
      local building = {
         position = position,
         --position = center_of_tile(position),
         direction = players[pindex].building_direction,
         alt = false,
      }
      --game.print("pos = " .. position.x .. " , " .. position.y,{volume_modifier=0})
      if building.position ~= nil and game.get_player(pindex).can_build_from_cursor(building) then
         --Build it
         game.get_player(pindex).build_from_cursor(building)
         schedule(2, "read_tile", pindex)
         build_successful = true
      else
         --Report errors
         game.get_player(pindex).play_sound({ path = "utility/cannot_build" })
         if players[pindex].build_lock == false then
            --Explain build error
            local result = "Cannot place that there "
            local build_area =
               { players[pindex].building_footprint_left_top, players[pindex].building_footprint_right_bottom }
            local ents_in_area = p.surface.find_entities_filtered({
               area = build_area,
               invert = true,
               type = ENT_TYPES_YOU_CAN_BUILD_OVER,
            })
            local tiles_in_area = p.surface.find_tiles_filtered({
               area = build_area,
               invert = false,
               name = {
                  "water",
                  "deepwater",
                  "water-green",
                  "deepwater-green",
                  "water-shallow",
                  "water-mud",
                  "water-wube",
               },
            })
            local obstacle_ent_name = nil
            local obstacle_tile_name = nil
            --Check for an entity in the way
            for i, area_ent in ipairs(ents_in_area) do
               if
                  area_ent.valid
                  and area_ent.prototype.tile_width
                  and area_ent.prototype.tile_width > 0
                  and area_ent.prototype.tile_height
                  and area_ent.prototype.tile_height > 0
               then
                  obstacle_ent_name = localising.get(area_ent, pindex)
               end
            end

            --Report obstacles
            if obstacle_ent_name ~= nil then
               result = result .. ", " .. obstacle_ent_name .. " in the way."
            elseif #tiles_in_area > 0 then
               result = result .. ", water is in the way."
            end
            printout(result, pindex)
         end
      end
      --Restore the original underground belt chute preview
      if placing_underground_belt and players[pindex].underground_connects == true then
         players[pindex].building_direction = (players[pindex].building_direction + dirs.south) % (2 * dirs.south)
         local stack = game.get_player(pindex).cursor_stack
         if
            stack
            and stack.valid_for_read
            and stack.valid
            and stack.prototype.place_result.type == "underground-belt"
         then
            stack.set_stack({ name = stack.name, count = stack.count })
         end
      end
      --Flip pipe-to-ground in hand
      if
         build_successful
         and stack
         and stack.valid_for_read
         and stack.valid
         and stack.prototype.place_result ~= nil
         and stack.prototype.place_result.name == "pipe-to-ground"
      then
         players[pindex].building_direction = fa_utils.rotate_180(players[pindex].building_direction)
         game.get_player(pindex).play_sound({ path = "Rotate-Hand-Sound" })
      end
   elseif stack and stack.valid_for_read and stack.valid and stack.prototype.place_as_tile_result ~= nil then
      --Tile placement
      local p = game.get_player(pindex)
      local t_size = players[pindex].cursor_size * 2 + 1
      local pos = players[pindex].cursor_pos --Center on the cursor in default
      if players[pindex].cursor and players[pindex].preferences.tiles_placed_from_northwest_corner then
         pos.x = pos.x - players[pindex].cursor_size
         pos.y = pos.y - players[pindex].cursor_size
      end
      if p.can_build_from_cursor({ position = pos, terrain_building_size = t_size }) then
         p.build_from_cursor({ position = pos, terrain_building_size = t_size })
      else
         p.play_sound({ path = "utility/cannot_build" })
      end
   else
      game.get_player(pindex).play_sound({ path = "utility/cannot_build" })
   end

   --Update cursor highlight (end)
   local ent = get_selected_ent(pindex)
   if ent and ent.valid then
      fa_graphics.draw_cursor_highlight(pindex, ent, nil)
   else
      fa_graphics.draw_cursor_highlight(pindex, nil, nil)
   end
end

--[[Assisted building function for offshore pumps.
* Called as a special case by build_item_in_hand
]]
function mod.build_offshore_pump_in_hand(pindex)
   local stack = game.get_player(pindex).cursor_stack

   if stack and stack.valid and stack.valid_for_read and stack.name == "offshore-pump" then
      local ent = stack.prototype.place_result
      players[pindex].pump.positions = {}
      local initial_position = game.get_player(pindex).position
      initial_position.x = math.floor(initial_position.x)
      initial_position.y = math.floor(initial_position.y)
      for i1 = -10, 10 do
         for i2 = -10, 10 do
            for i3 = 0, 3 do
               local position = { x = initial_position.x + i1, y = initial_position.y + i2 }
               if
                  game
                     .get_player(pindex)
                     .can_build_from_cursor({ name = "offshore-pump", position = position, direction = i3 * 2 })
               then
                  table.insert(players[pindex].pump.positions, { position = position, direction = i3 * 2 })
               end
            end
         end
      end
      if #players[pindex].pump.positions == 0 then
         printout("No available positions.  Try moving closer to water.", pindex)
      else
         players[pindex].in_menu = true
         players[pindex].menu = "pump"
         players[pindex].move_queue = {}
         printout(
            "There are "
               .. #players[pindex].pump.positions
               .. " possibilities, scroll up and down, then select one to build, or press e to cancel.",
            pindex
         )
         table.sort(players[pindex].pump.positions, function(k1, k2)
            return util.distance(initial_position, k1.position) < util.distance(initial_position, k2.position)
         end)

         players[pindex].pump.index = 0
      end
   end
end

--Reads the result of trying to rotate a building, which is a vanilla action.
function mod.rotate_building_info_read(event, forward)
   pindex = event.player_index
   if not check_for_player(pindex) then return end
   local mult = 1
   if forward == false then mult = -1 end
   if players[pindex].in_menu == false or players[pindex].menu == "blueprint_menu" then
      local ent = get_selected_ent(pindex)
      local stack = game.get_player(pindex).cursor_stack
      local build_dir = players[pindex].building_direction
      if stack and stack.valid_for_read and stack.valid and stack.prototype.place_result ~= nil then
         if stack.prototype.place_result.supports_direction then
            --Update the assumed hand direction
            if not players[pindex].lag_building_direction then
               game.get_player(pindex).play_sound({ path = "Rotate-Hand-Sound" })
               build_dir = (build_dir + dirs.east * mult) % (2 * dirs.south)
            end

            --Exceptions
            if stack.name == "rail" then
               --The actual rotation is by 45 degrees only.
               --Bug:This misaligns the preview. Clearing the cursor does not work. We need to track rotation offsets to fix it.
               --It looks like 4 rotations fully invert it and 8 rotations fix it.
               local rot_offset = players[pindex].cursor_rotation_offset
               if rot_offset == nil then
                  rot_offset = mult
               else
                  rot_offset = rot_offset + mult
                  if rot_offset >= 8 then
                     rot_offset = rot_offset - 8
                  elseif rot_offset <= -8 then
                     rot_offset = rot_offset + 8
                  end
               end
               players[pindex].cursor_rotation_offset = rot_offset
               if rot_offset ~= 0 then build_dir = (build_dir - dirs.northeast * mult) % (2 * dirs.south) end

               --Printout warning
               if rot_offset > 0 then
                  printout(
                     fa_utils.direction_lookup(build_dir)
                        .. " rail rotation warning: rotate a rail "
                        .. rot_offset
                        .. " times backward to re-align cursor, and then rotate a different item in hand to select the rotation you want before placing a rail",
                     pindex
                  )
               elseif rot_offset < 0 then
                  printout(
                     fa_utils.direction_lookup(build_dir)
                        .. " rail rotation warning: rotate a rail "
                        .. -rot_offset
                        .. " times forward to re-align cursor, and then rotate a different item in hand to select the rotation you want before placing a rail",
                     pindex
                  )
               else
                  printout(fa_utils.direction_lookup(build_dir) .. ", cursor rotation is aligned", pindex)
               end
               return
            end

            --Display and read the new direction info
            players[pindex].building_direction = build_dir
            fa_graphics.sync_build_cursor_graphics(pindex)
            printout(fa_utils.direction_lookup(build_dir) .. " in hand", pindex)
            players[pindex].lag_building_direction = false
         else
            printout(stack.name .. " never needs rotating.", pindex)
         end
      elseif stack ~= nil and stack.valid_for_read and stack.is_blueprint and stack.is_blueprint_setup() then
         --Rotate blueprints: They are tracked separately, and we reset them to north when cursor stack changes
         game.get_player(pindex).play_sound({ path = "Rotate-Hand-Sound" })
         players[pindex].blueprint_hand_direction = (players[pindex].blueprint_hand_direction + dirs.east * mult)
            % (2 * dirs.south)
         printout(fa_utils.direction_lookup(players[pindex].blueprint_hand_direction), pindex)

         --Flip the saved bp width and height
         local temp = players[pindex].blueprint_height_in_hand
         players[pindex].blueprint_height_in_hand = players[pindex].blueprint_width_in_hand
         players[pindex].blueprint_width_in_hand = temp

         --Call graphics update
         fa_graphics.sync_build_cursor_graphics(pindex)
      elseif ent and ent.valid then
         game.get_player(pindex).selected = ent

         if ent.supports_direction then
            --Assuming that the vanilla rotate event will now rotate the ent
            local new_dir = (ent.direction + dirs.east * mult) % (2 * dirs.south)

            if
               ent.name == "steam-engine"
               or ent.name == "steam-turbine"
               or ent.name == "rail"
               or ent.name == "straight-rail"
               or ent.name == "curved-rail"
               or ent.name == "character"
            then
               --Exception: These ents do not rotate
               new_dir = (new_dir - dirs.east * mult) % (2 * dirs.south)
            elseif (ent.tile_width ~= ent.tile_height and ent.supports_direction) or ent.type == "underground-belt" then
               --Exceptions: None-square ents rotate 2x , while underground belts simply flip instead
               --Examples, boiler, pump, flamethrower, heat exchanger,
               new_dir = (new_dir + dirs.east * mult) % (2 * dirs.south)
            end

            printout(fa_utils.direction_lookup(new_dir), pindex)

            --
         else
            printout(ent.name .. " never needs rotating.", pindex)
         end
      else
         printout("Cannot rotate", pindex)
      end
   end
end

--Does everything to handle the nudging feature, taking the keypress event and the nudge direction as the input. Nothing happens if an entity cannot be selected.
function mod.nudge_key(direction, event)
   local pindex = event.player_index
   local p = game.get_player(pindex)
   if not check_for_player(pindex) or players[pindex].menu == "prompt" then return end
   local ent = get_selected_ent(pindex)
   if ent and ent.valid then
      if ent.force == game.get_player(pindex).force then
         local old_pos = ent.position
         local new_pos = fa_utils.offset_position(ent.position, direction, 1)
         local temporary_teleported = false
         local actually_teleported = false

         --Clear the new build location
         local left_top
         local right_bottom
         local width = ent.tile_width
         local height = ent.tile_height
         if ent.direction == dirs.east or ent.direction == dirs.west then
            --Flip width and height. Note: diagonal cases are rounded to north/south cases
            height = ent.tile_width
            width = ent.tile_height
         end

         left_top = {
            x = math.floor(ent.position.x - math.floor(width / 2)),
            y = math.floor(ent.position.y - math.floor(height / 2)),
         }
         left_top = fa_utils.offset_position(left_top, direction, 1)
         right_bottom = { x = math.ceil(left_top.x + width), y = math.ceil(left_top.y + height) }
         fa_mining_tools.clear_obstacles_in_rectangle(left_top, right_bottom, pindex)

         --First teleport the ent to 0,0 temporarily
         temporary_teleported = ent.teleport({ 0, 0 })
         if not temporary_teleported then
            game.get_player(pindex).play_sound({ path = "utility/cannot_build" })
            printout({ "access.failed-to-nudge" }, pindex)
            return
         end

         --Now check if the ent can be placed at its new location, and proceed or revert accordingly
         local check_name = ent.name
         if check_name == "entity-ghost" then check_name = ent.ghost_name end
         if ent.surface.can_place_entity({ name = check_name, position = new_pos, direction = ent.direction }) then
            actually_teleported = ent.teleport(new_pos)
         else
            --Cannot build in new location, so send it back
            actually_teleported = ent.teleport(old_pos)
            game.get_player(pindex).play_sound({ path = "utility/cannot_build" })

            --Explain build error
            local result = "Cannot nudge"
            local build_area = { left_top, right_bottom }
            local ents_in_area = p.surface.find_entities_filtered({
               area = build_area,
               invert = true,
               type = ENT_TYPES_YOU_CAN_BUILD_OVER,
            })
            local tiles_in_area = p.surface.find_tiles_filtered({
               area = build_area,
               invert = false,
               name = {
                  "water",
                  "deepwater",
                  "water-green",
                  "deepwater-green",
                  "water-shallow",
                  "water-mud",
                  "water-wube",
               },
            })
            local obstacle_ent_name = nil
            local obstacle_tile_name = nil
            --Check for an entity in the way
            for i, area_ent in ipairs(ents_in_area) do
               if
                  area_ent.valid
                  and area_ent.prototype.tile_width
                  and area_ent.prototype.tile_width > 0
                  and area_ent.prototype.tile_height
                  and area_ent.prototype.tile_height > 0
               then
                  obstacle_ent_name = localising.get(area_ent, pindex)
               end
            end

            --Report obstacles
            if obstacle_ent_name ~= nil then
               result = result .. ", " .. obstacle_ent_name .. " in the way."
            elseif #tiles_in_area > 0 then
               result = result .. ", water is in the way."
            end
            printout(result, pindex)
            return
         end
         if not actually_teleported then
            --Failed to teleport
            printout({ "access.failed-to-nudge" }, pindex)
            return
         else
            --Successfully teleported and so nudged
            printout({ "access.nudged-one-direction", { "access.direction", direction } }, pindex)
            if players[pindex].cursor then
               players[pindex].cursor_pos = fa_utils.offset_position(players[pindex].cursor_pos, direction, 1)
               fa_graphics.draw_cursor_highlight(pindex, ent, "train-visualization")
               fa_graphics.sync_build_cursor_graphics(pindex)
            end
            if ent.type == "electric-pole" then
               -- laterdo **bugfix when nudged electric poles have extra wire reach, cut wires
               -- if ent.clone{position = new_pos, surface = ent.surface, force = ent.force, create_build_effect_smoke = false} == true then
               -- ent.destroy{}
               -- end
            end
         end
      end

      --Update ent connections after teleporting it
      ent.update_connections()
   else
      printout("Nudged nothing.", pindex)
   end
end

--Returns a list of positions for this entity where it has its heat pipe connections.
function mod.get_heat_connection_positions(ent_name, ent_position, ent_direction)
   local pos = ent_position
   local positions = {}
   if ent_name == "heat-pipe" then
      table.insert(positions, { x = pos.x, y = pos.y })
   elseif ent_name == "heat-exchanger" then
      table.insert(positions, fa_utils.offset_position(pos, fa_utils.rotate_180(ent_direction), 0.5))
   elseif ent_name == "nuclear-reactor" then
      table.insert(positions, { x = pos.x - 2, y = pos.y - 2 })
      table.insert(positions, { x = pos.x - 0, y = pos.y - 2 })
      table.insert(positions, { x = pos.x + 2, y = pos.y - 2 })

      table.insert(positions, { x = pos.x - 2, y = pos.y - 0 })
      table.insert(positions, { x = pos.x + 2, y = pos.y - 0 })

      table.insert(positions, { x = pos.x - 2, y = pos.y + 2 })
      table.insert(positions, { x = pos.x - 0, y = pos.y + 2 })
      table.insert(positions, { x = pos.x + 2, y = pos.y + 2 })
   end
   return positions
end

--Returns a list of positions for this entity where it expects to find other heat pipe interfaces that it can connect to.
function mod.get_heat_connection_target_positions(ent_name, ent_position, ent_direction)
   local pos = ent_position
   local positions = {}
   if ent_name == "heat-pipe" then
      table.insert(positions, { x = pos.x - 1, y = pos.y - 0 })
      table.insert(positions, { x = pos.x + 1, y = pos.y - 0 })
      table.insert(positions, { x = pos.x - 0, y = pos.y - 1 })
      table.insert(positions, { x = pos.x - 0, y = pos.y + 1 })
   elseif ent_name == "heat-exchanger" then
      table.insert(positions, fa_utils.offset_position(pos, fa_utils.rotate_180(ent_direction), 1.5))
   elseif ent_name == "nuclear-reactor" then
      table.insert(positions, { x = pos.x - 2, y = pos.y - 3 })
      table.insert(positions, { x = pos.x - 0, y = pos.y - 3 })
      table.insert(positions, { x = pos.x + 2, y = pos.y - 3 })

      table.insert(positions, { x = pos.x - 3, y = pos.y - 2 })
      table.insert(positions, { x = pos.x + 3, y = pos.y - 2 })

      table.insert(positions, { x = pos.x - 3, y = pos.y - 0 })
      table.insert(positions, { x = pos.x + 3, y = pos.y - 0 })

      table.insert(positions, { x = pos.x - 3, y = pos.y + 2 })
      table.insert(positions, { x = pos.x + 3, y = pos.y + 2 })

      table.insert(positions, { x = pos.x - 2, y = pos.y + 3 })
      table.insert(positions, { x = pos.x - 0, y = pos.y + 3 })
      table.insert(positions, { x = pos.x + 2, y = pos.y + 3 })
   end
   return positions
end

--Returns an info string about trying to build the entity in hand. The info type depends on the entity. Note: Limited usefulness for entities with sizes greater than 1 by 1.
function mod.build_preview_checks_info(stack, pindex)
   if stack == nil or not stack.valid_for_read or not stack.valid then return "invalid stack" end
   local p = game.get_player(pindex)
   local surf = game.get_player(pindex).surface
   local pos = table.deepcopy(players[pindex].cursor_pos)
   local result = ""
   local build_dir = players[pindex].building_direction
   local ent_p = stack.prototype.place_result --it is an entity prototype!
   if ent_p == nil or not ent_p.valid then return "invalid entity" end

   --Notify before all else if surface/player cannot place this entity. laterdo extend this valid placement check by copying over build offset stuff
   if
      ent_p.tile_width <= 1
      and ent_p.tile_height <= 1
      and not surf.can_place_entity({ name = stack.name, position = pos, direction = build_dir })
   then
      return " cannot place this here "
   end

   --For belt types, check if it would form a corner or junction here. **Laterdo include underground exits and possibly ghost belts.
   if ent_p.type == "transport-belt" then
      local ents_north = p.surface.find_entities_filtered({
         position = { x = pos.x + 0, y = pos.y - 1 },
         type = { "transport-belt", "underground-belt" },
      })
      local ents_south = p.surface.find_entities_filtered({
         position = { x = pos.x + 0, y = pos.y + 1 },
         type = { "transport-belt", "underground-belt" },
      })
      local ents_east = p.surface.find_entities_filtered({
         position = { x = pos.x + 1, y = pos.y + 0 },
         type = { "transport-belt", "underground-belt" },
      })
      local ents_west = p.surface.find_entities_filtered({
         position = { x = pos.x - 1, y = pos.y + 0 },
         type = { "transport-belt", "underground-belt" },
      })

      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x + 0, y = pos.y - 1 },
         surface = p.surface,
         time_to_live = 30,
      })
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x + 0, y = pos.y + 1 },
         surface = p.surface,
         time_to_live = 30,
      })
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x - 1, y = pos.y - 0 },
         surface = p.surface,
         time_to_live = 30,
      })
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x + 1, y = pos.y - 0 },
         surface = p.surface,
         time_to_live = 30,
      })

      if #ents_north > 0 or #ents_south > 0 or #ents_east > 0 or #ents_west > 0 then
         local sideload_count = 0
         local backload_count = 0
         local outload_count = 0
         local this_dir = build_dir
         local outload_dir = nil
         local outload_is_corner = false

         --Find the outloading belt and its direction and shape, if any
         if this_dir == dirs.north and ents_north[1] ~= nil and ents_north[1].valid then
            rendering.draw_circle({
               color = { 0.5, 0.5, 1 },
               radius = 0.3,
               width = 2,
               target = ents_north[1].position,
               surface = ents_north[1].surface,
               time_to_live = 30,
            })
            outload_dir = ents_north[1].direction
            outload_count = 1
            local outload_inputs = ents_north[1].belt_neighbours["inputs"]
            if
               (outload_inputs == nil or #outload_inputs == 0)
               and (this_dir == fa_utils.rotate_90(outload_dir) or this_dir == fa_utils.rotate_270(outload_dir))
            then
               outload_is_corner = true
            end
         elseif this_dir == dirs.east and ents_east[1] ~= nil and ents_east[1].valid then
            rendering.draw_circle({
               color = { 0.5, 0.5, 1 },
               radius = 0.3,
               width = 2,
               target = ents_east[1].position,
               surface = ents_east[1].surface,
               time_to_live = 30,
            })
            outload_dir = ents_east[1].direction
            outload_count = 1
            local outload_inputs = ents_east[1].belt_neighbours["inputs"]
            if
               (outload_inputs == nil or #outload_inputs == 0)
               and (this_dir == fa_utils.rotate_90(outload_dir) or this_dir == fa_utils.rotate_270(outload_dir))
            then
               outload_is_corner = true
            end
         elseif this_dir == dirs.south and ents_south[1] ~= nil and ents_south[1].valid then
            rendering.draw_circle({
               color = { 0.5, 0.5, 1 },
               radius = 0.3,
               width = 2,
               target = ents_south[1].position,
               surface = ents_south[1].surface,
               time_to_live = 30,
            })
            outload_dir = ents_south[1].direction
            outload_count = 1
            local outload_inputs = ents_south[1].belt_neighbours["inputs"]
            if
               (outload_inputs == nil or #outload_inputs == 0)
               and (this_dir == fa_utils.rotate_90(outload_dir) or this_dir == fa_utils.rotate_270(outload_dir))
            then
               outload_is_corner = true
            end
         elseif this_dir == dirs.west and ents_west[1] ~= nil and ents_west[1].valid then
            rendering.draw_circle({
               color = { 0.5, 0.5, 1 },
               radius = 0.3,
               width = 2,
               target = ents_west[1].position,
               surface = ents_west[1].surface,
               time_to_live = 30,
            })
            outload_dir = ents_west[1].direction
            outload_count = 1
            local outload_inputs = ents_west[1].belt_neighbours["inputs"]
            if
               (outload_inputs == nil or #outload_inputs == 0)
               and (this_dir == fa_utils.rotate_90(outload_dir) or this_dir == fa_utils.rotate_270(outload_dir))
            then
               outload_is_corner = true
            end
         end

         --Find the backloading and sideloading belts, if any
         if ents_north[1] ~= nil and ents_north[1].valid and ents_north[1].direction == dirs.south then
            rendering.draw_circle({
               color = { 1, 1, 0.2 },
               radius = 0.2,
               width = 2,
               target = ents_north[1].position,
               surface = ents_north[1].surface,
               time_to_live = 30,
            })
            if this_dir == dirs.east or this_dir == dirs.west then
               sideload_count = sideload_count + 1
            elseif this_dir == dirs.south then
               backload_count = 1
            end
         end

         if ents_south[1] ~= nil and ents_south[1].valid and ents_south[1].direction == dirs.north then
            rendering.draw_circle({
               color = { 1, 1, 0.4 },
               radius = 0.2,
               width = 2,
               target = ents_south[1].position,
               surface = ents_south[1].surface,
               time_to_live = 30,
            })
            if this_dir == dirs.east or this_dir == dirs.west then
               sideload_count = sideload_count + 1
            elseif this_dir == dirs.north then
               backload_count = 1
            end
         end

         if ents_east[1] ~= nil and ents_east[1].valid and ents_east[1].direction == dirs.west then
            rendering.draw_circle({
               color = { 1, 1, 0.6 },
               radius = 0.2,
               width = 2,
               target = ents_east[1].position,
               surface = ents_east[1].surface,
               time_to_live = 30,
            })
            if this_dir == dirs.north or this_dir == dirs.south then
               sideload_count = sideload_count + 1
            elseif this_dir == dirs.west then
               backload_count = 1
            end
         end

         if ents_west[1] ~= nil and ents_west[1].valid and ents_west[1].direction == dirs.east then
            rendering.draw_circle({
               color = { 1, 1, 0.8 },
               radius = 0.2,
               width = 2,
               target = ents_west[1].position,
               surface = ents_west[1].surface,
               time_to_live = 30,
            })
            if this_dir == dirs.north or this_dir == dirs.south then
               sideload_count = sideload_count + 1
            elseif this_dir == dirs.east then
               backload_count = 1
            end
         end

         --Determine expected junction info
         if sideload_count + backload_count + outload_count > 0 then --Skips "unit" because it is obvious
            local say_middle = true
            result = ", forms belt "
               .. fa_belts.transport_belt_junction_info(
                  sideload_count,
                  backload_count,
                  outload_count,
                  this_dir,
                  outload_dir,
                  say_middle,
                  outload_is_corner
               )
         end
      end
   end

   --For underground belts, state the potential neighbor: any neighborless matching underground of the same name and same/opposite direction, and along the correct axis
   if ent_p.type == "underground-belt" then
      local connected = false
      local check_dist = 5
      if stack.name == "fast-underground-belt" then
         check_dist = 7
      elseif stack.name == "express-underground-belt" then
         check_dist = 9
      end
      local candidates = game
         .get_player(pindex).surface
         .find_entities_filtered({ name = stack.name, position = pos, radius = check_dist, direction = build_dir })
      if #candidates > 0 then
         for i, cand in ipairs(candidates) do
            rendering.draw_circle({
               color = { 1, 1, 0 },
               radius = 0.5,
               width = 3,
               target = cand.position,
               surface = cand.surface,
               time_to_live = 60,
            })
            local dist_x = cand.position.x - pos.x
            local dist_y = cand.position.y - pos.y
            if
               cand.direction == build_dir
               and cand.neighbours == nil
               and cand.belt_to_ground_type == "input"
               and (fa_utils.get_direction_biased(cand.position, pos) == fa_utils.rotate_180(build_dir))
               and (dist_x == 0 or dist_y == 0)
            then
               rendering.draw_circle({
                  color = { 0, 1, 0 },
                  radius = 1.0,
                  width = 3,
                  target = cand.position,
                  surface = cand.surface,
                  time_to_live = 60,
               })
               result = result
                  .. " connects "
                  .. fa_utils.direction_lookup(build_dir)
                  .. " with "
                  .. math.floor(util.distance(cand.position, pos)) - 1
                  .. " tiles underground, "
               connected = true
               players[pindex].underground_connects = true
            end
         end
      end
      if not connected then
         result = result .. " not connected "
         players[pindex].underground_connects = false
      end
   end

   --For pipes to ground, state when connected
   if stack.name == "pipe-to-ground" then
      local connected = false
      local check_dist = 10
      local closest_dist = 11
      local closest_cand = nil
      local candidates =
         game
            .get_player(pindex).surface
            .find_entities_filtered({ name = stack.name, position = pos, radius = check_dist, direction = fa_utils.rotate_180(build_dir) })
      if #candidates > 0 then
         for i, cand in ipairs(candidates) do
            rendering.draw_circle({
               color = { 1, 1, 0 },
               radius = 0.5,
               width = 3,
               target = cand.position,
               surface = cand.surface,
               time_to_live = 60,
            })
            local dist_x = cand.position.x - pos.x
            local dist_y = cand.position.y - pos.y
            if
               cand.direction == fa_utils.rotate_180(build_dir)
               and (fa_utils.get_direction_biased(pos, cand.position) == build_dir)
               and (dist_x == 0 or dist_y == 0)
            then
               rendering.draw_circle({
                  color = { 0, 1, 0 },
                  radius = 1.0,
                  width = 3,
                  target = cand.position,
                  surface = cand.surface,
                  time_to_live = 60,
               })
               connected = true
               --Check if closest cand
               local cand_dist = util.distance(cand.position, pos)
               if cand_dist <= closest_dist then
                  closest_dist = cand_dist
                  closest_cand = cand
               end
            end
         end
         --Report the closest candidate (therefore the correct one)
         if closest_cand ~= nil then
            result = result
               .. " connects "
               .. fa_utils.direction_lookup(fa_utils.rotate_180(build_dir))
               .. " with "
               .. math.floor(util.distance(closest_cand.position, pos)) - 1
               .. " tiles underground, "
         end
      end
      if not connected then result = result .. " not connected underground, " end
   end

   --For pipes, read the fluids in fluidboxes of surrounding entities, if any. Also warn if there are multiple fluids, hence a mixing error. Pipe preview
   if stack.name == "pipe" then
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x + 0, y = pos.y - 1 },
         surface = p.surface,
         time_to_live = 30,
      })
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x + 0, y = pos.y + 1 },
         surface = p.surface,
         time_to_live = 30,
      })
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x - 1, y = pos.y - 0 },
         surface = p.surface,
         time_to_live = 30,
      })
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = { x = pos.x + 1, y = pos.y - 0 },
         surface = p.surface,
         time_to_live = 30,
      })
      local ents_north = p.surface.find_entities_filtered({ position = { x = pos.x + 0, y = pos.y - 1 } })
      local ents_south = p.surface.find_entities_filtered({ position = { x = pos.x + 0, y = pos.y + 1 } })
      local ents_east = p.surface.find_entities_filtered({ position = { x = pos.x + 1, y = pos.y + 0 } })
      local ents_west = p.surface.find_entities_filtered({ position = { x = pos.x - 1, y = pos.y + 0 } })
      local relevant_fluid_north = nil
      local relevant_fluid_east = nil
      local relevant_fluid_south = nil
      local relevant_fluid_west = nil
      local box = nil
      local dir_from_pos = nil

      local north_ent = nil
      for i, ent_cand in ipairs(ents_north) do
         if ent_cand.valid and ent_cand.fluidbox ~= nil then north_ent = ent_cand end
      end
      local south_ent = nil
      for i, ent_cand in ipairs(ents_south) do
         if ent_cand.valid and ent_cand.fluidbox ~= nil then south_ent = ent_cand end
      end
      local east_ent = nil
      for i, ent_cand in ipairs(ents_east) do
         if ent_cand.valid and ent_cand.fluidbox ~= nil then east_ent = ent_cand end
      end
      local west_ent = nil
      for i, ent_cand in ipairs(ents_west) do
         if ent_cand.valid and ent_cand.fluidbox ~= nil then west_ent = ent_cand end
      end
      box, relevant_fluid_north, dir_from_pos = mod.get_relevant_fluidbox_and_fluid_name(north_ent, pos, dirs.north)
      box, relevant_fluid_south, dir_from_pos = mod.get_relevant_fluidbox_and_fluid_name(south_ent, pos, dirs.south)
      box, relevant_fluid_east, dir_from_pos = mod.get_relevant_fluidbox_and_fluid_name(east_ent, pos, dirs.east)
      box, relevant_fluid_west, dir_from_pos = mod.get_relevant_fluidbox_and_fluid_name(west_ent, pos, dirs.west)

      --Prepare result string
      if
         relevant_fluid_north ~= nil
         or relevant_fluid_east ~= nil
         or relevant_fluid_south ~= nil
         or relevant_fluid_west ~= nil
      then
         local count = 0
         result = result .. ", pipe can connect to "

         if relevant_fluid_north ~= nil then
            result = result .. relevant_fluid_north .. " at north, "
            count = count + 1
         end
         if relevant_fluid_east ~= nil then
            result = result .. relevant_fluid_east .. " at east, "
            count = count + 1
         end
         if relevant_fluid_south ~= nil then
            result = result .. relevant_fluid_south .. " at south, "
            count = count + 1
         end
         if relevant_fluid_west ~= nil then
            result = result .. relevant_fluid_west .. " at west, "
            count = count + 1
         end

         --Check which fluids are empty or equal (and thus not mixing invalidly). "Empty" counts too because sometimes a pipe itself is empty but it is still part of a network...
         if
            relevant_fluid_north ~= nil
            and (
               relevant_fluid_north == relevant_fluid_south
               or relevant_fluid_north == relevant_fluid_east
               or relevant_fluid_north == relevant_fluid_west
            )
         then
            count = count - 1
         end
         if
            relevant_fluid_east ~= nil
            and (relevant_fluid_east == relevant_fluid_south or relevant_fluid_east == relevant_fluid_west)
         then
            count = count - 1
         end
         if relevant_fluid_south ~= nil and (relevant_fluid_south == relevant_fluid_west) then count = count - 1 end

         if count > 1 then result = result .. " warning: there may be mixing fluids " end
      end
   --Same as pipe preview but for the faced direction only
   elseif stack.name == "pipe-to-ground" then
      local face_dir = players[pindex].building_direction
      local ent_pos = fa_utils.offset_position(pos, face_dir, 1)
      rendering.draw_circle({
         color = { 1, 0.0, 0.5 },
         radius = 0.1,
         width = 2,
         target = ent_pos,
         surface = p.surface,
         time_to_live = 30,
      })

      local ents_faced = p.surface.find_entities_filtered({ position = ent_pos })
      local relevant_fluid_faced = nil
      local box = nil
      local dir_from_pos = nil

      local faced_ent = nil
      for i, ent_cand in ipairs(ents_faced) do
         if ent_cand.valid and ent_cand.fluidbox ~= nil then faced_ent = ent_cand end
      end

      box, relevant_fluid_faced, dir_from_pos = mod.get_relevant_fluidbox_and_fluid_name(faced_ent, pos, face_dir)
      --Prepare result string
      if relevant_fluid_faced ~= nil then
         local count = 0
         result = result
            .. ", connects "
            .. fa_utils.direction_lookup(face_dir)
            .. " to "
            .. relevant_fluid_faced
            .. " directly "
      else
         result = result .. ", not connected above ground "
      end
   end

   --For heat pipes, preview the connection directions
   if ent_p.type == "heat-pipe" then
      result = result .. " heat pipe can connect "
      local con_targets = mod.get_heat_connection_target_positions("heat-pipe", pos, dirs.north)
      local con_count = 0
      if #con_targets > 0 then
         for i, con_target_pos in ipairs(con_targets) do
            --For each heat connection target position
            rendering.draw_circle({
               color = { 1.0, 0.0, 0.5 },
               radius = 0.1,
               width = 2,
               target = con_target_pos,
               surface = p.surface,
               time_to_live = 30,
            })
            local target_ents = p.surface.find_entities_filtered({ position = con_target_pos })
            for j, target_ent in ipairs(target_ents) do
               if
                  target_ent.valid
                  and #mod.get_heat_connection_positions(target_ent.name, target_ent.position, target_ent.direction)
                     > 0
               then
                  for k, spot in
                     ipairs(
                        mod.get_heat_connection_positions(target_ent.name, target_ent.position, target_ent.direction)
                     )
                  do
                     --For each heat connection of the found target entity
                     rendering.draw_circle({
                        color = { 1.0, 1.0, 0.5 },
                        radius = 0.2,
                        width = 2,
                        target = spot,
                        surface = p.surface,
                        time_to_live = 30,
                     })
                     if util.distance(con_target_pos, spot) < 0.2 then
                        --For each match
                        rendering.draw_circle({
                           color = { 0.5, 1.0, 0.5 },
                           radius = 0.3,
                           width = 2,
                           target = spot,
                           surface = p.surface,
                           time_to_live = 30,
                        })
                        con_count = con_count + 1
                        local con_dir = fa_utils.get_direction_biased(con_target_pos, pos)
                        if con_count > 1 then result = result .. " and " end
                        result = result .. fa_utils.direction_lookup(con_dir)
                     end
                  end
               end
            end
         end
      end
      if con_count == 0 then result = result .. " to nothing " end
   end
   --For electric poles, report the directions of up to 5 wire-connectible electric poles that can connect
   if ent_p.type == "electric-pole" then
      local pole_dict =
         surf.find_entities_filtered({ type = "electric-pole", position = pos, radius = ent_p.max_wire_distance })
      local poles = {}
      for i, v in pairs(pole_dict) do
         if
            v.prototype.max_wire_distance >= ent_p.max_wire_distance
            or v.prototype.max_wire_distance >= util.distance(v.position, pos)
         then
            table.insert(poles, v)
         end
      end
      if #poles > 0 then
         --List the first 4 poles within range
         result = result .. " connecting "
         for i, pole in ipairs(poles) do
            if i < 5 then
               local dist = math.ceil(util.distance(pole.position, pos))
               local dir = fa_utils.get_direction_biased(pole.position, pos)
               result = result .. dist .. " tiles " .. fa_utils.direction_lookup(dir) .. ", "
            end
         end
      else
         --Notify if no connections and state nearest electric pole
         result = result .. " not connected, "
         local nearest_pole, min_dist = fa_electrical.find_nearest_electric_pole(nil, false, 50, surf, pos)
         if min_dist == nil or min_dist >= 1000 then
            result = result .. " no electric poles within 1000 tiles, "
         else
            local dir = fa_utils.get_direction_biased(nearest_pole.position, pos)
            result = result
               .. math.ceil(min_dist)
               .. " tiles "
               .. fa_utils.direction_lookup(dir)
               .. " to nearest electric pole, "
         end
      end
   end

   --For roboports, like electric poles, list possible neighbors (anything within 100 distx or 100 disty will be a neighbor
   if ent_p.name == "roboport" then
      local reach = 48.5
      local top_left = { x = math.floor(pos.x - reach), y = math.floor(pos.y - reach) }
      local bottom_right = { x = math.ceil(pos.x + reach), y = math.ceil(pos.y + reach) }
      local port_dict = surf.find_entities_filtered({ type = "roboport", area = { top_left, bottom_right } })
      local ports = {}
      for i, v in pairs(port_dict) do
         table.insert(ports, v)
      end
      if #ports > 0 then
         --List the first 5 poles within range
         result = result .. " connecting "
         for i, port in ipairs(ports) do
            if i <= 5 then
               local dist = math.ceil(util.distance(port.position, pos))
               local dir = fa_utils.get_direction_biased(port.position, pos)
               result = result .. dist .. " tiles " .. fa_utils.direction_lookup(dir) .. ", "
            end
         end
      else
         --Notify if no connections and state nearest roboport
         result = result .. " not connected, "
         local max_dist = 2000
         local nearest_port, min_dist = fa_utils.find_nearest_roboport(p.surface, p.position, max_dist)
         if min_dist == nil or min_dist >= max_dist then
            result = result .. " no other roboports within " .. max_dist .. " tiles, "
         else
            local dir = fa_utils.get_direction_biased(nearest_port.position, pos)
            result = result
               .. math.ceil(min_dist)
               .. " tiles "
               .. fa_utils.direction_lookup(dir)
               .. " to nearest roboport, "
         end
      end
   end

   --For logistic chests, list whether there is a network nearby
   if ent_p.type == "logistic-container" then
      local network = p.surface.find_logistic_network_by_position(pos, p.force)
      if network == nil then
         local nearest_roboport = fa_utils.find_nearest_roboport(p.surface, pos, 5000)
         if nearest_roboport == nil then
            result = result .. ", not in a network, no networks found within 5000 tiles"
         else
            local dist = math.ceil(util.distance(pos, nearest_roboport.position) - 25)
            local dir = fa_utils.direction_lookup(fa_utils.get_direction_biased(nearest_roboport.position, pos))
            result = result
               .. ", not in a network, nearest network "
               .. nearest_roboport.backer_name
               .. " is about "
               .. dist
               .. " to the "
               .. dir
         end
      else
         local network_name = network.cells[1].owner.backer_name
         result = result .. ", in network" .. network_name
      end
   end

   --For rail signals, check for valid placement
   if ent_p.name == "rail-signal" or ent_p.name == "rail-chain-signal" then
      local preview_dir = fa_rail_builder.free_place_rail_signal_in_hand(pindex, true)
      if preview_dir ~= nil then result = result .. ", signal heading " .. fa_utils.direction_lookup(preview_dir) end
   end

   --For all electric powered entities, note whether powered, and from which direction. Otherwise report the nearest power pole.
   if ent_p.electric_energy_source_prototype ~= nil then
      local position = pos
      local build_dir = players[pindex].building_direction
      if players[pindex].cursor then
         position.x = position.x + math.ceil(2 * ent_p.selection_box.right_bottom.x) / 2 - 0.5
         position.y = position.y + math.ceil(2 * ent_p.selection_box.right_bottom.y) / 2 - 0.5
      elseif players[pindex].player_direction == defines.direction.north then
         if build_dir == dirs.north or build_dir == dirs.south then
            position.y = position.y + math.ceil(2 * ent_p.selection_box.left_top.y) / 2 + 0.5
         elseif build_dir == dirs.east or build_dir == dirs.west then
            position.y = position.y + math.ceil(2 * ent_p.selection_box.left_top.x) / 2 + 0.5
         end
      elseif players[pindex].player_direction == defines.direction.south then
         if build_dir == dirs.north or build_dir == dirs.south then
            position.y = position.y + math.ceil(2 * ent_p.selection_box.right_bottom.y) / 2 - 0.5
         elseif build_dir == dirs.east or build_dir == dirs.west then
            position.y = position.y + math.ceil(2 * ent_p.selection_box.right_bottom.x) / 2 - 0.5
         end
      elseif players[pindex].player_direction == defines.direction.west then
         if build_dir == dirs.north or build_dir == dirs.south then
            position.x = position.x + math.ceil(2 * ent_p.selection_box.left_top.x) / 2 + 0.5
         elseif build_dir == dirs.east or build_dir == dirs.west then
            position.x = position.x + math.ceil(2 * ent_p.selection_box.left_top.y) / 2 + 0.5
         end
      elseif players[pindex].player_direction == defines.direction.east then
         if build_dir == dirs.north or build_dir == dirs.south then
            position.x = position.x + math.ceil(2 * ent_p.selection_box.right_bottom.x) / 2 - 0.5
         elseif build_dir == dirs.east or build_dir == dirs.west then
            position.x = position.x + math.ceil(2 * ent_p.selection_box.right_bottom.y) / 2 - 0.5
         end
      end
      local dict = game.get_filtered_entity_prototypes({ { filter = "type", type = "electric-pole" } })
      local poles = {}
      for i, v in pairs(dict) do
         table.insert(poles, v)
      end
      table.sort(poles, function(k1, k2)
         return k1.supply_area_distance < k2.supply_area_distance
      end)
      local check = false
      ---@type LuaEntity
      local found_pole = nil
      for i, pole in ipairs(poles) do
         local names = {}
         for i1 = i, #poles, 1 do
            table.insert(names, poles[i1].name)
         end
         local supply_dist = pole.supply_area_distance
         if supply_dist > 15 then supply_dist = supply_dist - 2 end
         local area = {
            left_top = {
               (position.x + math.ceil(ent_p.selection_box.left_top.x) - supply_dist),
               (position.y + math.ceil(ent_p.selection_box.left_top.y) - supply_dist),
            },
            right_bottom = {
               (position.x + math.floor(ent_p.selection_box.right_bottom.x) + supply_dist),
               (position.y + math.floor(ent_p.selection_box.right_bottom.y) + supply_dist),
            },
            orientation = players[pindex].building_direction / (2 * dirs.south),
         } --**laterdo "connected" check is a little buggy at the supply area edges, need to trim and tune, maybe re-enable direction based offset? The offset could be due to the pole width: 1 vs 2, maybe just make it more conservative?
         local T = {
            area = area,
            name = names,
         }
         local supplier_poles = surf.find_entities_filtered(T)
         if #supplier_poles > 0 then
            check = true
            found_pole = supplier_poles[1]
            break
         end
      end
      if check then
         result = result .. " Power connected "
         if found_pole.valid then
            local dist = math.ceil(util.distance(found_pole.position, pos))
            local dir = fa_utils.get_direction_biased(found_pole.position, pos)
            result = result .. " from " .. dist .. " tiles " .. fa_utils.direction_lookup(dir) .. ", "
         end
      else
         result = result .. " Power Not Connected, "
         --Notify if no connections and state nearest electric pole
         local nearest_pole, min_dist = fa_electrical.find_nearest_electric_pole(nil, false, 50, surf, pos)
         if min_dist == nil or min_dist >= 1000 then
            result = result .. " no electric poles within 1000 tiles, "
         else
            local dir = fa_utils.get_direction_biased(nearest_pole.position, pos)
            result = result
               .. math.ceil(min_dist)
               .. " tiles "
               .. fa_utils.direction_lookup(dir)
               .. " to nearest electric pole, "
         end
      end
   end

   if
      players[pindex].cursor
      and util.distance(players[pindex].cursor_pos, players[pindex].position) > p.reach_distance + 2
   then
      result = result .. ", cursor out of reach "
   end
   return result
end

--For a building with fluidboxes, returns the external fluidbox and fluid name that would connect to one of the building's own fluidboxes at a particular position, from a particular direction. Importantly, ignores fluidboxes that are positioned correctly but would not connect, such as a pipe to ground facing a perpebdicular direction.
function mod.get_relevant_fluidbox_and_fluid_name(building, pos, dir_from_pos)
   local relevant_box = nil
   local relevant_fluid_name = nil
   if building ~= nil and building.valid and building.fluidbox ~= nil then
      rendering.draw_circle({
         color = { 1, 1, 0 },
         radius = 0.2,
         width = 2,
         target = building.position,
         surface = building.surface,
         time_to_live = 30,
      })
      --Run checks to see if we have any fluidboxes that are relevant
      for i = 1, #building.fluidbox, 1 do
         --game.print("box " .. i .. ": " .. building.fluidbox[i].name)
         for j, con in ipairs(building.fluidbox.get_pipe_connections(i)) do
            local target_pos = con.target_position
            local con_pos = con.position
            --game.print("new connection at: " .. target_pos.x .. "," .. target_pos.y)
            rendering.draw_circle({
               color = { 1, 0, 0 },
               radius = 0.2,
               width = 2,
               target = target_pos,
               surface = building.surface,
               time_to_live = 30,
            })
            if
               util.distance(target_pos, pos) < 0.3
               and fa_utils.get_direction_biased(con_pos, pos) == dir_from_pos
               and not (building.name == "pipe-to-ground" and building.direction == dir_from_pos)
            then --Note: We correctly ignore the backside of a pipe to ground.
               rendering.draw_circle({
                  color = { 0, 1, 0 },
                  radius = 0.3,
                  width = 2,
                  target = target_pos,
                  surface = building.surface,
                  time_to_live = 30,
               })
               relevant_box = building.fluidbox[i]
               if building.fluidbox[i] ~= nil then
                  relevant_fluid_name = building.fluidbox[i].name
               elseif building.fluidbox.get_locked_fluid(i) ~= nil then
                  relevant_fluid_name = building.fluidbox.get_locked_fluid(i)
               else
                  relevant_fluid_name = "empty pipe"
               end
            end
         end
      end
   end
   return relevant_box, relevant_fluid_name, dir_from_pos
end

function mod.teleport_player_out_of_build_area(left_top, right_bottom, pindex)
   local p = game.get_player(pindex)
   local pos = p.position
   if pos.x < left_top.x or pos.x > right_bottom.x or pos.y < left_top.y or pos.y > right_bottom.y then return end
   local exits = {}
   exits[1] = { x = left_top.x - 1, y = left_top.y - 0 }
   exits[2] = { x = left_top.x - 0, y = left_top.y - 1 }
   exits[3] = { x = left_top.x - 1, y = left_top.y - 1 }
   exits[4] = { x = left_top.x - 2, y = left_top.y - 0 }
   exits[5] = { x = left_top.x - 0, y = left_top.y - 2 }
   exits[6] = { x = left_top.x - 2, y = left_top.y - 2 }

   --Teleport to exit spots if possible
   for i, pos in ipairs(exits) do
      if p.surface.can_place_entity({ name = "character", position = pos }) then
         fa_teleport.teleport_to_closest(pindex, pos, false, true)
         return
      end
   end

   --Teleport best effort to -2, -2
   fa_teleport.teleport_to_closest(pindex, exits[6], false, true)
end

--Assuming there is a steam engine in hand, this function will automatically build it next to a suitable boiler.
function mod.snap_place_steam_engine_to_a_boiler(pindex)
   local p = game.get_player(pindex)
   local found_empty_spot = false
   local found_valid_spot = false
   --Locate all boilers within 10m
   local boilers = p.surface.find_entities_filtered({ name = "boiler", position = p.position, radius = 10 })

   --If none then locate all boilers within 25m
   if boilers == nil or #boilers == 0 then
      boilers = p.surface.find_entities_filtered({ name = "boiler", position = p.position, radius = 25 })
   end

   if boilers == nil or #boilers == 0 then
      p.play_sound({ path = "utility/cannot_build" })
      printout("Error: No boilers found nearby", pindex)
      return
   end

   --For each boiler found:
   for i, boiler in ipairs(boilers) do
      --Check if there is any entity in front of it
      local output_location = fa_utils.offset_position(boiler.position, boiler.direction, 1.5)
      rendering.draw_circle({
         color = { 1, 1, 0.25 },
         radius = 0.25,
         width = 2,
         target = output_location,
         surface = p.surface,
         time_to_live = 60,
         draw_on_ground = false,
      })
      local output_ents = p.surface.find_entities_filtered({
         position = output_location,
         radius = 0.25,
         type = { "resource", "generator" },
         invert = true,
      })
      if output_ents == nil or #output_ents == 0 then
         --Determine engine position based on boiler direction
         found_empty_spot = true
         local engine_position = output_location
         local dir = boiler.direction
         local old_building_dir = players[pindex].building_direction
         players[pindex].building_direction = dir
         if dir == dirs.east then
            engine_position = fa_utils.offset_position(engine_position, dirs.east, 2)
         elseif dir == dirs.south then
            engine_position = fa_utils.offset_position(engine_position, dirs.south, 2)
         elseif dir == dirs.west then
            engine_position = fa_utils.offset_position(engine_position, dirs.west, 2)
         elseif dir == dirs.north then
            engine_position = fa_utils.offset_position(engine_position, dirs.north, 2)
         end
         rendering.draw_circle({
            color = { 0.25, 1, 0.25 },
            radius = 0.5,
            width = 2,
            target = engine_position,
            surface = p.surface,
            time_to_live = 60,
            draw_on_ground = false,
         })
         fa_mining_tools.clear_obstacles_in_circle(engine_position, 4, pindex)
         --Check if can build from cursor to the relative position
         if p.can_build_from_cursor({ position = engine_position, direction = dir }) then
            p.build_from_cursor({ position = engine_position, direction = dir })
            found_valid_spot = true
            printout(
               "Placed steam engine near boiler at "
                  .. math.floor(boiler.position.x)
                  .. ","
                  .. math.floor(boiler.position.y),
               pindex
            )
            return
         end
      end
   end
   --If all have been skipped and none were found then play error
   if found_empty_spot == false then
      p.play_sound({ path = "utility/cannot_build" })
      printout("Error: All boilers nearby are blocked or already connected.", pindex)
      return
   elseif found_valid_spot == false then
      p.play_sound({ path = "utility/cannot_build" })
      printout("Error: Boilers found but unable to build in front of them, check build area for obstacles.", pindex)
      return
   end
end

--Identifies if a pipe is a pipe end, so that it can be singled out. The motivation is that pipe ends generally should not exist because the pipes should connect to something. Laterdo review
function mod.is_a_pipe_end(ent, pindex)
   local p = game.get_player(pindex)
   local pos = players[pindex].cursor_pos
   local ents_north = p.surface.find_entities_filtered({ position = { x = pos.x + 0, y = pos.y - 1 } })
   local ents_south = p.surface.find_entities_filtered({ position = { x = pos.x + 0, y = pos.y + 1 } })
   local ents_east = p.surface.find_entities_filtered({ position = { x = pos.x + 1, y = pos.y + 0 } })
   local ents_west = p.surface.find_entities_filtered({ position = { x = pos.x - 1, y = pos.y + 0 } })
   local relevant_fluid_north = nil
   local relevant_fluid_east = nil
   local relevant_fluid_south = nil
   local relevant_fluid_west = nil
   local box = nil
   local dir_from_pos = nil
   local total_ent_count = 0

   local north_ent = nil
   local north_count = 0
   for i, ent_cand in ipairs(ents_north) do
      if ent_cand.valid and ent_cand.fluidbox ~= nil then
         north_ent = ent_cand
         total_ent_count = total_ent_count + 1
         if ent_cand.type == "pipe" or (ent_cand.type == "pipe-to-ground" and ent_cand.direction == dirs.north) then
            north_count = 1
            total_ent_count = total_ent_count - 1
         end
      end
   end
   local south_ent = nil
   local south_count = 0
   for i, ent_cand in ipairs(ents_south) do
      if ent_cand.valid and ent_cand.fluidbox ~= nil then
         south_ent = ent_cand
         total_ent_count = total_ent_count + 1
         if ent_cand.type == "pipe" or (ent_cand.type == "pipe-to-ground" and ent_cand.direction == dirs.south) then
            south_count = 1
            total_ent_count = total_ent_count - 1
         end
      end
   end
   local east_ent = nil
   local east_count = 0
   for i, ent_cand in ipairs(ents_east) do
      if ent_cand.valid and ent_cand.fluidbox ~= nil then
         east_ent = ent_cand
         total_ent_count = total_ent_count + 1
         if ent_cand.type == "pipe" or (ent_cand.type == "pipe-to-ground" and ent_cand.direction == dirs.east) then
            east_count = 1
            total_ent_count = total_ent_count - 1
         end
      end
   end
   local west_ent = nil
   local west_count = 0
   for i, ent_cand in ipairs(ents_west) do
      if ent_cand.valid and ent_cand.fluidbox ~= nil then
         west_ent = ent_cand
         total_ent_count = total_ent_count + 1
         if ent_cand.type == "pipe" or (ent_cand.type == "pipe-to-ground" and ent_cand.direction == dirs.west) then
            west_count = 1
            total_ent_count = total_ent_count - 1
         end
      end
   end

   local sum = north_count + south_count + east_count + west_count
   if sum > 1 then
      return false
   elseif sum == 0 and total_ent_count == 0 then
      --No connections at all
      return true
   elseif sum == 1 and total_ent_count == 0 then
      --1 pipe only
      return true
   elseif sum == 0 and total_ent_count == 1 then
      --1 ent only, possibly not connected
      --Choose false to avoid false positives
      return false
   else
      --More than 1 anything
      return false
   end
end

function mod.delete_empty_planners_in_inventory(pindex)
   local inv = game.get_player(pindex).get_main_inventory()
   local length = #inv
   for i = 1, length, 1 do
      local stack = inv[i]
      if stack and stack.valid_for_read then
         if stack.name == "cut-paste-tool" or stack.name == "copy-paste-tool" then
            stack.clear()
         elseif stack.is_deconstruction_item or stack.is_upgrade_item then
            stack.clear()
         elseif stack.is_blueprint and stack.is_blueprint_setup() == false then
            stack.clear()
         end
      end
   end
end

return mod
