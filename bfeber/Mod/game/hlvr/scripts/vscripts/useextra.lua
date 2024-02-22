DoIncludeScript("bindings.lua", nil)

------ PMEIN1 FIND PLAYER POS ----------
local playerEnt = Entities:GetLocalPlayer()
EmitSoundOnClient("HL2Player.Use", playerEnt)
local startVector = playerEnt:EyePosition()
local fullpos = string.sub(string.format("%s", startVector),26,-2)
local xpos_index = string.find(fullpos, " ")
local xpos = tonumber(string.sub(fullpos,0,xpos_index - 1))
local ypos_index = string.find(fullpos, " ", xpos_index + 1)
local ypos = tonumber(string.sub(fullpos,xpos_index + 1,ypos_index - 1))
local zpos = tonumber(string.sub(fullpos,ypos_index + 1,fullpos:len()))
----------------------------------------

local map = GetMapName()
local class = thisEntity:GetClassname()
local name = thisEntity:GetName()
local model = thisEntity:GetModelName()
local player = Entities:GetLocalPlayer()

print(class)
print(name)
print(model)

player:Attribute_SetIntValue("useextra_executed", 1)

if not (vlua.find(name, "elev_anim_door") and (thisEntity:Attribute_GetIntValue("used", 0) == 1 or thisEntity:GetVelocity() ~= Vector(0, 0, 0))) then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:Attribute_SetIntValue("toggle", 1)
    else
        thisEntity:Attribute_SetIntValue("toggle", 0)
    end
end

function IsCombineConsoleLocked()
    local ents = Entities:FindAllByClassnameWithin("baseanimating", thisEntity:GetCenter(), 3)
    for i = 1, #ents do
        local ent = ents[i]
        if ent:GetModelName() == "models/props_combine/combine_consoles/handle_plate.vmdl" and ent:GetCycle() == 1 then
            return false
        end
    end
    return true
end

-- if map == "a3_distillery" then
    -- if vlua.find(name, "plug") then
        -- if player:Attribute_GetIntValue("plug_lever", 0) == 0 then
            -- return
        -- elseif name == "11578_2420_181_antlion_plug_crank_a" and player:Attribute_GetIntValue("plug_lever", 0) ~= 2 then
            -- return
        -- elseif name == "11578_2420_183_antlion_plug_crank_a" and player:Attribute_GetIntValue("plug_lever", 0) ~= 3 then
            -- return
        -- elseif name == "antlion_plug_crank_c" and player:Attribute_GetIntValue("plug_lever", 0) ~= 4 then
            -- return
        -- end
    -- elseif name == "barricade_door" and player:GetOrigin().x > 433 then
        -- return
    -- end
-- end

-- if class == "prop_animinteractable" and (name ~= "pallet_lever" or name ~= "pallet_lever_unpowered" or name ~= "pallet_lever_vertical") then
	-- SendToConsole("ent_fire !picker enablereturntocompletion;ent_fire !picker setreturntocompletionamount 1")
-- end

if not vlua.find(model, "doorhandle") and name ~= "russell_entry_window" and name ~= "larry_ladder" and name ~= "@pod_shell" and name ~= "589_panel_switch" and name ~= "tc_door_control" and (class == "item_health_station_charger" or (class == "prop_animinteractable" and (not vlua.find(name, "elev_anim_door") or (vlua.find(name, "elev_anim_door") and thisEntity:Attribute_GetIntValue("toggle", 0) == 1 and thisEntity:GetVelocity() == Vector(0, 0, 0))) and not vlua.find(name, "5628_2901_barricade_door")) or (class == "item_hlvr_combine_console_rack" and IsCombineConsoleLocked() == false)) and not (map == "a4_c17_parking_garage" and name == "door_reset" and player:Attribute_GetIntValue("circuit_" .. map .. "_toner_junction_5_completed", 0) == 0) and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    if name:find("^tractor_beam_console_lever_" ) ~= nil then
		SendToConsole("ent_fire " .. name .. " enablereturntocompletion;ent_fire " .. name .. " setreturntocompletionamount 1")
	elseif not vlua.find(name, "intro_rollup_door") and not (map == "a4_c17_zoo" and vlua.find(name, "door_reset")) then
		if vlua.find(name, "slide_train_door") and Entities:FindByClassnameNearest("phys_constraint", thisEntity:GetCenter(), 20) then
			return
		end

		if name == "12712_shotgun_wheel" and Entities:FindByNameNearest("12712_shotgun_bar_for_wheel", thisEntity:GetCenter(), 20) then
			return
		end

		if name == "greenhouse_door" then
			if string.format("%.2f", thisEntity:GetCycle()) ~= "0.05" then
				return
			end
		end

		local count = 0
		if class == "prop_animinteractable" and model == "models/props_subway/scenes/desk_lever.vmdl" then
			if map == "a4_c17_water_tower" then
				completion_amount = 0.5
				if thisEntity:GetName() == "" then
					if player:Attribute_GetIntValue("lever_number", 0) == 0 then
						thisEntity:SetEntityName("Lever1")
						player:Attribute_SetIntValue("lever_number", 1)
					elseif player:Attribute_GetIntValue("lever_number", 0) == 1 then
						thisEntity:SetEntityName("Lever2")
					end
				end
				player:SetThink(function()
					SendToConsole("ent_fire " .. thisEntity:GetName() .. " EnableReturnToCompletion")
					if player:Attribute_GetIntValue("use_released", 0) == 1 then
						SendToConsole("ent_fire " .. thisEntity:GetName() .. " setreturntocompletionamount 0.5")
						if thisEntity:Attribute_GetIntValue("lever_direction", 0) == 0 then
							thisEntity:Attribute_SetIntValue("lever_direction", 1)
						else
							thisEntity:Attribute_SetIntValue("lever_direction", 0)
						end
					else
						if thisEntity:Attribute_GetIntValue("lever_direction", 0) == 0 then
							completion_amount = completion_amount - 0.01
							SendToConsole("ent_fire " .. thisEntity:GetName() .. " setreturntocompletionamount " .. completion_amount)
						else
							completion_amount = completion_amount + 0.01
							SendToConsole("ent_fire " .. thisEntity:GetName() .. " setreturntocompletionamount " .. completion_amount)
						end
						return 0
					end
				end, "Interacting", 0)
			else
				thisEntity:FireOutput("OnCompletionB", nil, nil, nil, 0)
			end
		elseif name ~= "plug_console_starter_lever" then
			if name == "track_switch_lever" then
				count = 0.35
				player:SetThink(function()
					if player:Attribute_GetIntValue("use_released", 0) == 1 then
						SendToConsole("ent_fire track_switch_lever SetCompletionValue 0.35 0")
						SendToConsole("ent_fire train_switch_reset_relay Trigger 0 0")
						if player:Attribute_GetIntValue("released_train_lever_once", 0) == 0 then
							SendToConsole("ent_fire speech_radio CancelSpeech")
							SendToConsole("ent_fire train_switch_control_override_0 Cancel")
							SendToConsole("ent_fire train_switch_control_override_10 Start")
							player:Attribute_SetIntValue("released_train_lever_once", 1)
						end
					else
						return 0
					end
				end, "Interacting", 0)
				SendToConsole("ent_fire traincar_01_hackplug Alpha 0")
			elseif map == "a3_distillery" and name == "verticaldoor_wheel" then
				count = 0
				completion_amount = -0.0001
				player:SetThink(function()
					local jeff = Entities:FindByClassname(ent, "npc_zombie_blind")
					if player:Attribute_GetIntValue("use_released", 0) == 1 and count < 10 or vlua.find(Entities:FindAllInSphere(Vector(291, 291, 322), 10), jeff) then
						-- SendToConsole("ent_fire verticaldoor_wheel EnableReturnToCompletion 0 0")
						-- SendToConsole("ent_fire @verticaldoor SetSpeed 100")
						-- SendToConsole("ent_fire @verticaldoor Close")
						SendToConsole("ent_fire verticaldoor_wheel setreturntocompletionamount 0")
					else
						-- SendToConsole("ent_fire verticaldoor_wheel DisableReturnToCompletion 0 0")
						-- SendToConsole("ent_fire @verticaldoor SetSpeed 10")
						-- SendToConsole("ent_fire @verticaldoor Open")
						SendToConsole("ent_fire verticaldoor_wheel EnableReturnToCompletion")
						completion_amount = completion_amount + 0.02
						SendToConsole("ent_fire verticaldoor_wheel setreturntocompletionamount " .. completion_amount)
						return 0
					end
				end, "Interacting", 0)
			elseif map == "a3_distillery" and name == "11478_6233_tutorial_wheel" then
				count = 0
				completion_amount = -0.0001
				player:SetThink(function()
					local jeff = Entities:FindByClassname(ent, "npc_zombie_blind")
					if player:Attribute_GetIntValue("use_released", 0) == 1 and count < 10 or vlua.find(Entities:FindAllInSphere(Vector(291, 291, 322), 10), jeff) then
						SendToConsole("ent_fire verticaldoor_wheel setreturntocompletionamount 0")
					else
						SendToConsole("ent_fire 11478_6233_tutorial_wheel EnableReturnToCompletion")
						completion_amount = completion_amount + 0.001
						SendToConsole("ent_fire 11478_6233_tutorial_wheel setreturntocompletionamount " .. completion_amount)
						return 0
					end
				end, "Interacting", 0)
			elseif name == "12712_shotgun_wheel" then
				count = 0
				player:SetThink(function()
					if player:Attribute_GetIntValue("use_released", 0) == 1 and count < 1 then
						DoEntFireByInstanceHandle(thisEntity, "EnableReturnToCompletion", "", 0, nil, nil)
					else
						DoEntFireByInstanceHandle(thisEntity, "DisableReturnToCompletion", "", 0, nil, nil)
						SendToConsole("ent_fire_output " .. thisEntity:GetName() .. " Position " .. count / 2)
						return 0
					end
				end, "Interacting", 0)
			elseif map == "a4_c17_tanker_yard" and name == "bridge_crank" then
				thisEntity:FireOutput("OnInteractStart", nil, nil, nil, 0)
				completion_amount = -0.0001
				player:SetThink(function()
					if player:Attribute_GetIntValue("use_released", 0) == 1 then
						thisEntity:FireOutput("OnInteractStop", nil, nil, nil, 0)
					else
						SendToConsole("ent_fire bridge_crank EnableReturnToCompletion")
						completion_amount = completion_amount + 0.02
						SendToConsole("ent_fire bridge_crank setreturntocompletionamount " .. completion_amount)
						return 0
					end
				end, "Interacting", 0)
			elseif name == "console_selector_interact" then
				local ent = Entities:FindByName(nil, "console_opener_prop_handle_interact")
				ent:Attribute_SetIntValue("used", 0)
				SendToConsole("ent_fire_output console_opener_prop_handle_interact OnCompletionExitA")
				local count2 = ent:GetCycle()
				ent:SetThink(function()
					if count2 > 0 then
						count2 = count2 - 0.015
						DoEntFireByInstanceHandle(ent, "SetCompletionValue", "" .. count2, 0, nil, nil)
						return 0
					else
						return nil
					end
				end, "", 0)
				count = thisEntity:GetCycle()
				player:SetThink(function()
					if player:Attribute_GetIntValue("use_released", 0) == 0 then
						DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. count, 0, nil, nil)
						return 0
					end
				end, "Interacting", 0)
			elseif not vlua.find(name, "elev_anim_door") and not vlua.find(name, "tractor_beam_console_lever") then
				thisEntity:Attribute_SetIntValue("used", 1)
			end
		elseif map == "a4_c17_tanker_yard" and name == "plug_console_starter_lever" then
			completion_amount = -0.0001
			player:SetThink(function()
				if player:Attribute_GetIntValue("use_released", 0) == 1 then
					SendToConsole("ent_fire plug_console_starter_lever setreturntocompletionamount 0")
				else
					SendToConsole("ent_fire plug_console_starter_lever EnableReturnToCompletion")
					completion_amount = completion_amount + 0.01
					SendToConsole("ent_fire plug_console_starter_lever setreturntocompletionamount " .. completion_amount)
					return 0
				end
			end, "Interacting", 0)
		end

		if class == "item_health_station_charger" or class == "item_hlvr_combine_console_rack" then
			DoEntFireByInstanceHandle(thisEntity, "EnableOnlyRunForward", "", 0, nil, nil)
		end

		if model == "models/interaction/anim_interact/twohandlift/twohandlift.vmdl" then
			SendToConsole("snd_sos_start_soundevent RollUpDoor.MoveLinear_Start")
			thisEntity:FireOutput("OnCompletionB", nil, nil, nil, 1)
		end

		if model == "models/interaction/anim_interact/rollingdoor/rollingdoor.vmdl" then
			count = thisEntity:GetCycle()
			thisEntity:FireOutput("OnCompletionB", nil, nil, nil, 0)
		end

		-- if name == "barricade_door_hook" then
			-- count = thisEntity:GetCycle()
		-- end

		-- if name == "barricade_door" then
			-- local ent = Entities:FindByName(nil, "barricade_door_hook")
			-- ent:Attribute_SetIntValue("used", 0)
			-- DoEntFireByInstanceHandle(ent, "SetCompletionValue", "0", 0, nil, nil)
			-- DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0.1, nil, nil)
			-- SendToConsole("ent_fire player_speedmod ModifySpeed 0")
		-- end

		local is_console = class == "prop_animinteractable" and model == "models/props_combine/combine_consoles/vr_console_rack_1.vmdl"

		if name == "" and not (class == "prop_animinteractable" and model == "models/props_subway/scenes/desk_lever.vmdl") then
			thisEntity:SetEntityName("" .. thisEntity:GetEntityIndex())
		end

		thisEntity:SetThink(function()
			if not is_console then
				if not name == "pallet_lever_unpowered" then --or not name == "pallet_lever" or not name == "pallet_lever_vertical" then
					DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. count, 0, nil, nil)
				end
			end

			if name == "12712_shotgun_wheel" then
				count = count + 0.003
			elseif name == "console_selector_interact" then
				if thisEntity:Attribute_GetIntValue("reverse", 0) == 1 then
					count = count - 0.003
				else
					count = count + 0.003
				end
			else
				count = count + 0.01
			end

			if is_console then
				DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. count, 0, nil, nil)
			end

			if name == "12712_shotgun_wheel" then
				if player:Attribute_GetIntValue("use_released", 0) == 1 then
					thisEntity:Attribute_SetIntValue("used", 0)
					return nil
				end
			end

			if name == "console_selector_interact" then
				if player:Attribute_GetIntValue("use_released", 0) == 1 then
					thisEntity:Attribute_SetIntValue("used", 0)
					return nil
				end
			end

			if model == "models/interaction/anim_interact/hand_crank_wheel/hand_crank_wheel.vmdl" then
				SendToConsole("ent_fire_output " .. thisEntity:GetName() .. " Position " .. count)
			end

			if name == "track_switch_lever" and player:Attribute_GetIntValue("use_released", 0) == 1 then
				return nil
			end

			-- if map == "a3_distillery" then
				-- if name == "verticaldoor_wheel" then
					-- local jeff = Entities:FindByClassname(ent, "npc_zombie_blind")
					-- if player:Attribute_GetIntValue("use_released", 0) == 1 or vlua.find(Entities:FindAllInSphere(Vector(291, 291, 322), 10), jeff) then
						-- thisEntity:Attribute_SetIntValue("used", 0)
						-- return nil
					-- end
				-- end
			-- end

			if vlua.find(name, "elev_anim_door") then
				DoEntFireByInstanceHandle(thisEntity, "DisableReturnToCompletion", "", 0, nil, nil)
			end

			if not (map == "a3_distillery" and name == "verticaldoor_wheel") and count >= 1 or count >= 10 then
				if name ~= "barricade_door_hook" then
					thisEntity:FireOutput("OnCompletionA_Forward", nil, nil, nil, 0)
					-- if map == "a3_distillery" and name == "verticaldoor_wheel" then
						-- Entities:GetLocalPlayer():Attribute_SetIntValue("locked_jeff_in_freezer", 1)
						-- SendToConsole("ent_fire relay_verticaldoor_opened Trigger")
					-- end
				end

				if (name == "barricade_door" and not map == "a3_distillery") then
					DoEntFireByInstanceHandle(Entities:FindByName(nil, "barricade_lock_relay"), "Trigger", "", 0, nil, nil)
					SendToConsole("ent_fire player_speedmod ModifySpeed 1")
				elseif name == "12712_shotgun_wheel" then
					local bar = Entities:FindByName(nil, "12712_shotgun_bar_for_wheel")
					bar:Kill()
					bar = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["targetname"]="12712_shotgun_bar_for_wheel", ["model"]="models/props/misc_debris/vort_winch_pipe.vmdl", ["origin"]="711.395874 1319.248047 -168.302490", ["angles"]="0.087952 120.220528 90.588112"})
					SendToConsole("ent_remove shotgun_pickup_blocker")
				elseif name == "console_opener_prop_handle_interact" then
					SendToConsole("ent_fire_output console_opener_prop_handle_interact OnCompletionA")
				elseif name == "console_selector_interact" then
					thisEntity:Attribute_SetIntValue("reverse", 1)
				elseif model == "models/interaction/anim_interact/twohandlift/twohandlift.vmdl" then
					SendToConsole("snd_sos_start_soundevent RollUpDoor.FullOpen")
				end
				return nil
			elseif name == "console_selector_interact" and count <= 0 then
				thisEntity:Attribute_SetIntValue("reverse", 0)
			elseif (name == "verticaldoor_wheel" and map == "a3_distillery") then
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
	end
--elseif (name == "barricade_door_hook" and player:Attribute_GetIntValue("locked_jeff_in_freezer", 0) == 0) or (name == "589_panel_switch" and Entities:FindByName(nil, "589_path_11"):Attribute_GetIntValue("toner_path_powered", 0) == 1) or name == "5628_2901_barricade_door_hook" or name == "tc_door_control" or (vlua.find(name, "elev_anim_door") and thisEntity:Attribute_GetIntValue("toggle", 0) == 0 and thisEntity:GetVelocity() == Vector(0, 0, 0)) then
elseif (vlua.find(name, "elev_anim_door") and thisEntity:Attribute_GetIntValue("toggle", 0) == 0 and thisEntity:GetVelocity() == Vector(0, 0, 0)) then
    if thisEntity:Attribute_GetIntValue("used", 0) == 1 then
        if name == "barricade_door_hook" then
            thisEntity:StopThink("AnimateCompletionValue")
            thisEntity:Attribute_SetIntValue("used", 0)

            local ent = Entities:FindByName(nil, "barricade_door")
            ent:FireOutput("OnCompletionA_Backward", nil, nil, nil, 0)
            ent:Attribute_SetIntValue("used", 0)
        else
            return
        end
    elseif not vlua.find(name, "elev_anim_door") then
        thisEntity:Attribute_SetIntValue("used", 1)
    end

    local count = 1 - thisEntity:GetCycle()
    thisEntity:SetThink(function()
        DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 1 - count, 0, nil, nil)
        count = count + 0.01
        if count >= 1 then
            thisEntity:FireOutput("OnCompletionA_Backward", nil, nil, nil, 0)
            return nil
        else
            return 0
        end
    end, "AnimateCompletionValue", 0)
end

if vlua.find(model, "doorhandle") then
    local ent = Entities:FindByClassnameNearest("prop_door_rotating_physics", thisEntity:GetOrigin(), 60)
    DoEntFireByInstanceHandle(ent, "Use", "", 0, player, player)
end

if vlua.find(name, "socket") then
    local ent = Entities:FindByClassname(thisEntity, "prop_physics")
    DoEntFireByInstanceHandle(ent, "RunScriptFile", "check_useextra_distance", 0, player, player)
end

if class == "prop_ragdoll" or class == "prop_ragdoll_attached" then
    for k, v in pairs(thisEntity:GetChildren()) do
        DoEntFireByInstanceHandle(v, "RunScriptFile", "useextra", 0, player, player)
    end
end

if vlua.find(name, "_locker_door_") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,5000))
elseif vlua.find(name, "_portaloo_door") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-1500))
elseif vlua.find(name, "_hazmat_crate_lid") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-5000,0))
elseif vlua.find(model, "electric_box_door") then
    if vlua.find(name, "electrical_panel_1_door") and (map == "a3_c17_processing_plant" or map == "a4_c17_zoo") then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,1000))
    else
        if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
            thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
        else
            thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
        end
    end
elseif vlua.find(name, "_dumpster_lid") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,2000,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-800,0))
    end
elseif vlua.find(name, "_portaloo_seat") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 1 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-3000,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,2000,0))
    end
elseif vlua.find(name, "_drawer") then
    if vlua.find(model, "models/props/desk_1_drawer_") then
        if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
            thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetRightVector() * 100)
        else
            thisEntity:ApplyAbsVelocityImpulse(thisEntity:GetRightVector() * 100)
        end
    elseif vlua.find(model, "models/props/interior_furniture/interior_kitchen_drawer_") or (vlua.find(model, "models/props/interior_furniture/interior_furniture_cabinet_") and vlua.find(model, "drawer")) then
        if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
            thisEntity:ApplyAbsVelocityImpulse(thisEntity:GetRightVector() * 100)
        else
            thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetRightVector() * 100)
        end
    else
        if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
            thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetForwardVector() * 100)
        else
            thisEntity:ApplyAbsVelocityImpulse(thisEntity:GetForwardVector() * 100)
        end
    end
elseif vlua.find(name, "_trashbin02_lid") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,1000,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-3000,0))
    end
elseif vlua.find(name, "_car_door_rear") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,1500,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-2800,0))
    end
elseif vlua.find(name, "ticktacktoe_") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,RandomInt(1000, 3000),0))
end

if model == "models/props/zoo/vet_cage_square.vmdl" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
    end
end

if vlua.find(model, "models/props/interior_furniture/interior_kitchen_cabinet_") or vlua.find(model, "models/props/interior_furniture/interior_furniture_cabinet_") then
    if vlua.find(model, "002") then
        if vlua.find(model, "door_a") then
            if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
                thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
            else
                thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
            end
        else
            if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
                thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-2000,0))
            else
                thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,2000,0))
            end
        end
    elseif vlua.find(model, "door_a") then
        if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
            thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
        else
            thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
        end
    else
        if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
            thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
        else
            thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
        end
    end
end

if vlua.find(name, "_wooden_board") then
    DoEntFireByInstanceHandle(thisEntity, "Break", "", 0, nil, nil)
    player:Attribute_SetIntValue("break_boards_tutorial_shown", 1)
end

if class == "prop_door_rotating_physics" and vlua.find(name, "padlock_door") then
    DoEntFireByInstanceHandle(thisEntity, "InteractStart", "", 0, nil, nil)
end

if vlua.find(model, "van_a0") then
    local name = thisEntity:GetName():gsub("_window", "")
    local ent = Entities:FindByName(nil, name)
    if ent then
        if thisEntity == ent then
            DoEntFireByInstanceHandle(ent, "Toggle", "", 0, nil, nil)
            if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
                thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetForwardVector() * 150)
            else
                thisEntity:ApplyAbsVelocityImpulse(thisEntity:GetForwardVector() * 300)
            end
        else
            DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
        end
    end
end

if vlua.find(model, "car_sedan_a0") then
    local name = thisEntity:GetName():gsub("_door", ""):gsub("car", "car_door"):gsub("_window", "")
    local ent = Entities:FindByName(nil, name)
    if ent then
        DoEntFireByInstanceHandle(ent, "Toggle", "", 0, nil, nil)
    end
end


---------- a1_intro_world ----------

--if name == "microphone" or name == "call_button_prop" or model == "maps/a1_intro_world/entities/unnamed_205_2961_1020.vmdl" then
if name == "call_button_prop_2" then
    SendToConsole("ent_fire_output call_button onin")
end

if name == "button_monitor_upper_left_2" then
	SendToConsole("ent_fire branch_screen_up_left toggletest")
	SendToConsole("ent_fire snd_button_a StartSound")
end

if name == "button_monitor_upper_right_2" then
	SendToConsole("ent_fire branch_screen_up_right toggletest")
	SendToConsole("ent_fire snd_button_c StartSound")
end

if name == "button_monitor_lower_left_2" then
	SendToConsole("ent_fire branch_screen_left_lower toggletest")
	SendToConsole("ent_fire snd_button_b StartSound")
end

if name == "button_monitor_lower_right_2" then
	SendToConsole("ent_fire branch_screen_lower_right toggletest")
	SendToConsole("ent_fire snd_button_d StartSound")
end

if name == "greenhouse_door_lock" then
    local ent = Entities:FindByName(nil, "greenhouse_door")
    DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
end

--if name == "205_2653_door" or name == "205_2653_door2" or name == "205_8018_button_pusher_prop" then
if name == "205_8018_button_pusher_prop" then
    --SendToConsole("ent_fire debug_roof_elevator_call_relay trigger")
    SendToConsole("ent_fire 205_8018_button_branch test")
end

if name == "205_8032_button_pusher_prop" then
    SendToConsole("ent_fire_output 205_8032_button_center_pusher OnIn")
end

if model == "models/props/eli_manor/antique_globe01a.vmdl" then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,1000))
end

if model == "models/props/interactive/washing_machine01a_door.vmdl" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
    end
end

if model == "models/props/interactive/washing_machine01a_loader.vmdl" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetForwardVector() * 100)
    else
        thisEntity:ApplyAbsVelocityImpulse(thisEntity:GetForwardVector() * 100)
    end
end

if name == "door_named_for_audio_ent_02" then
    DoEntFireByInstanceHandle(thisEntity, "InteractStart", "", 0, nil, nil)
end

if vlua.find(model, "models/props/c17/antenna01") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
end

if name == "205_4130_alyx_radio_antenna" then
	SendToConsole("ent_fire 205_4130_relay_start_radio trigger")
	Storage:SaveBoolean("radio_antenna_raised", true)
	Storage:SaveString("radio_station", "d")
	print(Storage:LoadBoolean("radio_antenna_raised"))
end

if name == "979_518_button_pusher_prop" then
    --SendToConsole("ent_fire debug_choreo_start_relay trigger")
	SendToConsole("ent_fire_output 979_518_button_center_pusher onin")
end

if name == "light_switch_1" then
    if thisEntity:Attribute_GetIntValue("used", 0) == 0 then
        SendToConsole("ent_fire 205_6591_switch_off_relay trigger")
        thisEntity:Attribute_SetIntValue("used", 1)
    else
        SendToConsole("ent_fire 205_6591_switch_on_relay trigger")
        thisEntity:Attribute_SetIntValue("used", 0)
    end
end

if name == "light_switch_2" then
    if thisEntity:Attribute_GetIntValue("used", 0) == 0 then
        SendToConsole("ent_fire 205_6594_switch_off_relay trigger")
        thisEntity:Attribute_SetIntValue("used", 1)
    else
        SendToConsole("ent_fire 205_6594_switch_on_relay trigger")
        thisEntity:Attribute_SetIntValue("used", 0)
    end
end

if name == "washing_machine_button_1" then
    SendToConsole("ent_fire_output 273_3825_washing_machine_button_handpose onhandposed")
end

if name == "washing_machine_button_2" then
    SendToConsole("ent_fire_output 273_3640_washing_machine_button_handpose onhandposed")
end

if name == "washing_machine_button_3" then
    SendToConsole("ent_fire_output 273_3641_washing_machine_button_handpose onhandposed")
end

if name == "washing_machine_button_4" then
    SendToConsole("ent_fire_output 273_3642_washing_machine_button_handpose onhandposed")
end


---------- a1_intro_world_2 ----------

if name == "russell_headset" then
    --SendToConsole("ent_fire debug_relay_put_on_headphones trigger")
	SendToConsole("ent_fire_output russell_headset onputonheadset")
    --SendToConsole("ent_fire 4962_car_door_left_front close")
end

if name == "4962_car_door_left_front" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
	SendToConsole("ent_fire 4962_car_door_left_front close")
	thisEntity:Attribute_SetIntValue("used", 1)
end

if name == "carousel" then
    SendToConsole("+attack")
    player:SetThink(function()
        SendToConsole("-attack")
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-500))
    end, "SpinCarousel", 0)
end

if vlua.find(name, "mailbox") and vlua.find(model, "door") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2500))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2500))
    end
end

if name == "russell_entry_window" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    --SendToConsole("fadein 0.2")
    --SendToConsole("setpos -1728 275 100")
    --SendToConsole("ent_fire russell_entry_window SetCompletionValue 1")
	SendToConsole("ent_fire russell_entry_window setreturntocompletionamount 1;ent_fire russell_entry_window setreturntocompletionstyle 2;ent_fire russell_entry_window enablereturntocompletion")
    thisEntity:Attribute_SetIntValue("used", 1)
end

if vlua.find(model, "models/props/interior_furniture/interior_furniture_cabinet_002_door_") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
    end
end

if model == "models/props/fridge_1a_door2.vmdl" or model == "models/props/fridge_1a_door.vmdl" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
    end
end

if name == "621_6487_button_pusher_prop" then
    SendToConsole("ent_fire 621_6487_button_branch test")
end

if name == "glove_dispenser_brush" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    thisEntity:Attribute_SetIntValue("used", 1)
    SendToConsole("ent_fire relay_give_gravity_gloves trigger")
    SendToConsole("hidehud 1")
    SendToConsole("hudhearts_startupdateloop")
    SendToConsole("wristpockets_startupdateloop")
    Entities:GetLocalPlayer():Attribute_SetIntValue("gravity_gloves", 1)
end


---------- a2_quarantine_entrance ----------

if map == "a2_quarantine_entrance" then
    if IsCombineConsoleLocked() == false then
        local ent = Entities:FindByName(nil, "17670_combine_console")
        DoEntFireByInstanceHandle(ent, "RackOpening", "1", 0, thisEntity, thisEntity)
    end
end


---------- a2_pistol ----------

if model == "models/props/distillery/firebox_1_door_a.vmdl" then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
end


---------- a2_headcrabs_tunnel ----------

if map == "a2_headcrabs_tunnel" then
    if name == "flashlight" or name == "flashlight_guy" then
        SendToConsole("ent_fire_output flashlight OnAttachedToHand")
        SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
        player:Attribute_SetIntValue("has_flashlight", 1)
        SendToConsole("ent_remove flashlight")
        SendToConsole("ent_remove fake_flashlight_for_room")

        local ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="FLASHLIGHT"})
        DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
        SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")

        SendToConsole("inv_flashlight")
		_G.flashlight_on = "1"
    end
end


---------- a2_train_yard ----------

if map == "a2_train_yard" then
    if IsCombineConsoleLocked() == false then
        local ent = Entities:FindByName(nil, "5325_3947_combine_console")
        DoEntFireByInstanceHandle(ent, "RackOpening", "1", 0, thisEntity, thisEntity)
    end
end


---------- a3_station_street ----------

if map == "a3_station_street" then
    if name == "2_8127_elev_button_floor_1_call_button" then
        SendToConsole("ent_fire_output 2_8127_elev_button_floor_1_call OnIn")
		EmitSoundOnClient("Button_LobbyElevator.Success",Entities:GetLocalPlayer())
    elseif name == "2_8127_elev_button_floor_2_call_button" then
        SendToConsole("ent_fire_output 2_8127_elev_button_floor_2_call OnIn")
		EmitSoundOnClient("Button_LobbyElevator.Success",Entities:GetLocalPlayer())
    elseif name == "2_8127_elev_button_floor_1_elev_button" then
        SendToConsole("ent_fire 2_8127_elev_button_test_floor_1 trigger")
		EmitSoundOnClient("Button_LobbyElevator.Success",Entities:GetLocalPlayer())
    elseif name == "2_8127_elev_button_floor_2_elev_button" then
        SendToConsole("ent_fire 2_8127_elev_button_test_floor_2 trigger")
		EmitSoundOnClient("Button_LobbyElevator.Success",Entities:GetLocalPlayer())
    end
end


---------- a3_hotel_lobby_basement ----------

if map == "a3_hotel_lobby_basement" then
    if class == "hlvr_piano" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
        thisEntity:Attribute_SetIntValue("used", 1)
        SendToConsole("ent_fire piano_played_first_time trigger")

        thisEntity:SetThink(function()
            -- C
            Entities:FindByName(nil, "piano_key_white_30"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note1", 6.0)

        thisEntity:SetThink(function()
            -- D
            Entities:FindByName(nil, "piano_key_white_31"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note2", 6.5)

        thisEntity:SetThink(function()
            -- E
            Entities:FindByName(nil, "piano_key_white_32"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note3", 7.0)

        thisEntity:SetThink(function()
            -- F
            Entities:FindByName(nil, "piano_key_white_33"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note4", 7.5)

        thisEntity:SetThink(function()
            -- G
            Entities:FindByName(nil, "piano_key_white_34"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note5", 8.0)

        thisEntity:SetThink(function()
            -- G
            Entities:FindByName(nil, "piano_key_white_34"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note6", 9.0)

        thisEntity:SetThink(function()
            -- A
            Entities:FindByName(nil, "piano_key_white_35"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note7", 10.0)

        thisEntity:SetThink(function()
            -- A
            Entities:FindByName(nil, "piano_key_white_35"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note8", 10.5)

        thisEntity:SetThink(function()
            -- A
            Entities:FindByName(nil, "piano_key_white_35"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note9", 11.0)

        thisEntity:SetThink(function()
            -- A
            Entities:FindByName(nil, "piano_key_white_35"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note10", 11.5)

        thisEntity:SetThink(function()
            -- G
            Entities:FindByName(nil, "piano_key_white_34"):ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        end, "Note11", 12.0)

        thisEntity:SetThink(function()
            SendToConsole("ent_fire piano_played_followup trigger")
        end, "FinishPiano", 10)
    end

    if class == "hlvr_piano_key_model" then
        thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetUpVector() * 100)
        DoEntFireByInstanceHandle(Entities:FindByClassname(nil, "hlvr_piano"), "RunScriptFile", "useextra", 0, nil, nil)
    end
end


---------- a3_c17_processing_plant ----------

if name == "vent_door" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-1000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,1000))
    end
end

if map == "a3_c17_processing_plant" then
	if name == "door_factory_interior" then
		SendToConsole("unbind .")
		SendToConsole("unbind ,")
	end
	if name == "shack_path_1_port_1" then
		SendToConsole("ent_fire shack_path_1_port_1 onplugrotated")
		SendToConsole("ent_fire_output shack_path_1 onpoweron")
		SendToConsole("ent_fire_output shack_path_2 onpoweron")
		SendToConsole("ent_fire_output shack_path_3 onpoweron")
		SendToConsole("ent_fire_output shack_path_4 onpoweron")
		SendToConsole("ent_fire_output shack_path_5 onpoweron")
	end
end

if name == "pallet_lever_unpowered" then
    if thisEntity:GetMoveParent() then
        DoEntFireByInstanceHandle(thisEntity, "ClearParent", "", 0, nil, nil)
    else
        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        local look_delta = player:EyeAngles()
		SendToConsole("ent_fire pallet_lever_unpowered enablereturntocompletion")
        player:SetThink(function()
			static_look = 0
            if player:Attribute_GetIntValue("use_released", 0) == 0 then
                local x = ((look_delta.x - player:EyeAngles().x)/10) * -1
                look_delta = player:EyeAngles()
				static_look = static_look + x
				thisEntity:Attribute_SetFloatValue(static_look2, thisEntity:Attribute_GetFloatValue(static_look2, 0.500000) + static_look)
				SendToConsole("ent_fire !picker setreturntocompletionamount " .. thisEntity:Attribute_GetFloatValue(static_look2, 0.500000))
                return 0
            end
        end, "Interacting", 0)
    end
elseif name == "pallet_lever_vertical" then
    if thisEntity:GetMoveParent() then
        DoEntFireByInstanceHandle(thisEntity, "ClearParent", "", 0, nil, nil)
    else
        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        local look_delta = player:EyeAngles()
		SendToConsole("ent_fire pallet_lever_vertical enablereturntocompletion")
        player:SetThink(function()
			static_look = 0
            if player:Attribute_GetIntValue("use_released", 0) == 0 then
                local x = ((look_delta.x - player:EyeAngles().x)/10) * -1
                look_delta = player:EyeAngles()
				static_look = static_look + x
				thisEntity:Attribute_SetFloatValue(static_look2, thisEntity:Attribute_GetFloatValue(static_look2, 0.500000) + static_look)
				SendToConsole("ent_fire !picker setreturntocompletionamount " .. thisEntity:Attribute_GetFloatValue(static_look2, 0.500000))
                return 0
            end
        end, "Interacting", 0)
    end
elseif name == "pallet_lever" then
    if thisEntity:GetMoveParent() then
        DoEntFireByInstanceHandle(thisEntity, "ClearParent", "", 0, nil, nil)
    else
        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        local look_delta = player:EyeAngles()
		SendToConsole("ent_fire pallet_lever enablereturntocompletion")
        player:SetThink(function()
			static_look = 0
            if player:Attribute_GetIntValue("use_released", 0) == 0 then
                local x = ((look_delta.x - player:EyeAngles().x)/10) * -1
                look_delta = player:EyeAngles()
				static_look = static_look + x
				thisEntity:Attribute_SetFloatValue(static_look2, thisEntity:Attribute_GetFloatValue(static_look2, 0.500000) + static_look)
				SendToConsole("ent_fire !picker setreturntocompletionamount " .. thisEntity:Attribute_GetFloatValue(static_look2, 0.500000))
                return 0
            end
        end, "Interacting", 0)
    end
end


---------- a3_distillery ----------

if map == "a3_distillery" then
    if name == "larry_ladder" then
        SendToConsole("ent_fire_output larry_ladder OnCompletionA")
        SendToConsole("ent_fire_output larry_ladder OnCompletionC")
        player:Attribute_SetIntValue("pulled_larry_ladder", 1)
    end

    if name == "cellar_ladder" then
		if player:Attribute_GetIntValue("cellar_ladder_down", 0) == 0 then
			SendToConsole("ent_fire cellar_ladder Enable")
			player:Attribute_SetIntValue("cellar_ladder_down", 1)
		else
			ClimbLadder(560)
		end
        -- SendToConsole("ent_fire cellar_ladder SetCompletionValue 1")
    end

    -- if name == "11578_2635_380_button_center" then
    if name == "tc_door_button" then
        SendToConsole("ent_fire_output 11578_2635_380_button_center_pusher OnIn")
    end
	
	if name == "5628_2901_barricade_door_hook" then
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count - 0.01
			if count >= 0.99 then
				thisEntity:FireOutput("OnCompletionA_Backward", nil, nil, nil, 0)
				return 0
			elseif count <= 0 then
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
	end

    if name == "intro_rollup_door" then
        --SendToConsole("ent_fire_output intro_rollup_door OnCompletionA_Forward")
        --SendToConsole("ent_fire door_xen_crust Break")
        --SendToConsole("ent_fire relay_door_xen_crust_c Trigger")
        --SendToConsole("ent_fire relay_door_xen_crust_d Trigger")
        --SendToConsole("ent_fire relay_door_xen_crust_e Trigger")
        --SendToConsole("ent_fire @snd_music_bz_hello Kill")
		SendToConsole("ent_fire intro_rollup_door enablereturntocompletion")
		if player:Attribute_GetIntValue("door_xen_crust_broken", 0) == 0 then
			SendToConsole("ent_fire door_xen_crust break")
			SendToConsole("ent_fire door_xen_crust_cover break")
			SendToConsole("ent_fire door_xen_crustpcrust_0 break")
			SendToConsole("ent_fire door_xen_crustpcrust_1 break")
			SendToConsole("ent_fire intro_rollup_door setreturntocompletionamount 0.005")
			player:Attribute_SetIntValue("door_xen_crust_broken", 1)
		elseif player:Attribute_GetIntValue("door_xen_crust_broken", 0) == 1 then
			SendToConsole("ent_fire door_xen_crustpcrust_2 break")
			SendToConsole("ent_fire door_xen_crustpcrust_3 break")
			SendToConsole("ent_fire door_xen_crustpcrust_4 break")
			SendToConsole("ent_fire door_xen_crustpcrust_5 break")
			SendToConsole("ent_fire intro_rollup_door setreturntocompletionamount 0.01")
			player:Attribute_SetIntValue("door_xen_crust_broken", 2)
		elseif player:Attribute_GetIntValue("door_xen_crust_broken", 0) == 2 then
			SendToConsole("ent_fire door_xen_crustpcrust_6 break")
			SendToConsole("ent_fire door_xen_crustpcrust_7 break")
			SendToConsole("ent_fire door_xen_crustpcrust_8 break")
			SendToConsole("ent_fire door_xen_crustpcrust_9 break")
			SendToConsole("ent_fire intro_rollup_door setreturntocompletionamount 1")
			player:Attribute_SetIntValue("door_xen_crust_broken", 3)
		end
    end

    -- if name == "barricade_door_hook" and player:Attribute_GetIntValue("locked_jeff_in_freezer", 0) == 1 then
        -- SendToConsole("ent_fire barricade_begin_exit_relay Trigger")
    -- end
	
	-- TO DO: This door doesn't seem to always respect the returntocompletion system, so it's forced open/closed for now
	
	if name == "barricade_door" and player:Attribute_GetIntValue("barricade_door_locked", 0) == 0 then
		-- SendToConsole("ent_fire barricade_door setreturntocompletionstyle 0")
		-- SendToConsole("ent_fire barricade_door enablereturntocompletion")
		SendToConsole("ent_fire b_barricade_door_closed setvalue 1")
		SendToConsole("ent_fire b_barricade_door_hook_closed setvalue 1")
		SendToConsole("ent_fire barricade_door setreturntocompletionamount 1")
		SendToConsole("ent_fire barricade_door_hook setcompletionvalue 1 0.5")
		player:Attribute_SetIntValue("barricade_door_locked", 1)
		player:Attribute_SetIntValue("barricade_door_hook_down", 1)
		-- SendToConsole("ent_fire barricade_door setreturntocompletionstyle 3")
	end
	
	if name == "barricade_door_hook" and player:Attribute_GetIntValue("barricade_door_locked", 0) == 1 then
		SendToConsole("ent_fire_output barricade_door_listener onmixed")
		player:Attribute_SetIntValue("barricade_door_locked", 0)
		player:Attribute_SetIntValue("barricade_door_hook_down", 0)
	elseif name == "barricade_door_hook" and player:Attribute_GetIntValue("barricade_door_hook_down", 0) == 0 then
		SendToConsole("ent_fire barricade_door_hook setcompletionvalue 1")
		player:Attribute_SetIntValue("barricade_door_hook_down", 1)
	elseif name == "barricade_door_hook" and player:Attribute_GetIntValue("barricade_door_hook_down", 0) == 1 then
		SendToConsole("ent_fire barricade_door_hook setcompletionvalue 0")
		player:Attribute_SetIntValue("barricade_door_hook_down", 0)
	end
	
	if name == "cabinet_door_a" or name == "cabinet_door_b" or name == "cabinet_door_c" then
		SendToConsole("ent_fire !picker enablereturntocompletion;ent_fire !picker setreturntocompletionstyle 1;ent_fire !picker setreturntocompletionamount 1")
	end

    if name == "tc_door_control" then
        -- SendToConsole("ent_fire relay_close_compactor_doors Trigger")
		if player:Attribute_GetIntValue("tc_door_closed", 0) == 0 then
			local count = 1 - thisEntity:GetCycle()
			thisEntity:SetThink(function()
				DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 1 - count, 0, nil, nil)
				count = count + 0.01
				if count >= 1 then
					thisEntity:FireOutput("OnCompletionB_Backward", nil, nil, nil, 0)
					return nil
				else
					return 0
				end
			end, "AnimateCompletionValue", 0)
			--SendToConsole("ent_fire relay_close_compactor_doors trigger")
			player:Attribute_SetIntValue("tc_door_closed", 1)
			-- SendToConsole("ent_fire tc_door_control setcompletionvalue 0")
			-- SendToConsole("ent_fire relay_close_compactor_doors trigger")
			-- SendToConsole("ent_fire @b_compactor_is_resetting_b test")
			-- SendToConsole("ent_fire tc_door_control enablereturntocompletion 0")
		else
			local count = 0 + thisEntity:GetCycle()
			thisEntity:SetThink(function()
				DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
				count = count + 0.01
				if count >= 1 then
					thisEntity:FireOutput("OnCompletionA_Forward", nil, nil, nil, 0)
					return nil
				else
					return 0
				end
			end, "AnimateCompletionValue", 0)
			--SendToConsole("ent_fire relay_open_compactor_doors trigger")
			player:Attribute_SetIntValue("tc_door_closed", 0)
			-- SendToConsole("ent_fire tc_door_control setcompletionvalue 1")
			-- SendToConsole("ent_fire relay_open_compactor_doors trigger")
			-- SendToConsole("ent_fire @b_compactor_is_resetting_a test")
			-- SendToConsole("ent_fire tc_door_control enablereturntocompletion 1")
		end
    end

    -- if name == "11478_6233_tutorial_wheel" then
        -- SendToConsole("ent_fire 11478_6233_verticaldoor_wheel_tutorial open")
    -- end

    if name == "11479_2385_button_pusher_prop" then
        SendToConsole("ent_fire_output 11479_2385_button_center_pusher onin")
        _G.distillery_elev_called = 1
    end

    if name == "11479_2386_button_pusher_prop" then
        SendToConsole("ent_fire_output 11479_2386_button_center_pusher onin")
    end
	
	if name == "plug_console_starter_lever" then
		SendToConsole("ent_fire plug_console_starter_lever enablereturntocompletion")
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count + 0.01
			if count >= 1 then
				thisEntity:FireOutput("OnCompletionB_Forward", nil, nil, nil, 0)
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
	end

    if name == "11578_2420_181_antlion_plug_crank_a" then
        -- SendToConsole("ent_fire_output 11578_2420_181_antlion_plug_crank_a oncompletionc_forward")
		SendToConsole("ent_fire 11578_2420_181_antlion_plug_crank_a enablereturntocompletion")
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count + 0.01
			if count >= 1 then
				thisEntity:FireOutput("OnCompletionC_Forward", nil, nil, nil, 0)
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
    end

    if name == "11578_2420_183_antlion_plug_crank_a" then
        -- SendToConsole("ent_fire_output 11578_2420_183_antlion_plug_crank_a oncompletionc_forward")
		SendToConsole("ent_fire 11578_2420_183_antlion_plug_crank_a enablereturntocompletion")
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count + 0.01
			if count >= 1 then
				thisEntity:FireOutput("OnCompletionC_Forward", nil, nil, nil, 0)
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
    end

    if name == "antlion_plug_crank_c" then
        -- SendToConsole("ent_fire_output antlion_plug_crank_c oncompletionc_forward")
		SendToConsole("ent_fire antlion_plug_crank_c enablereturntocompletion")
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count + 0.01
			if count >= 1 then
				thisEntity:FireOutput("OnCompletionC_Forward", nil, nil, nil, 0)
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
    end
end


---------- a4_c17_zoo ----------

if map == "a4_c17_zoo" then
	if model == "models/props/industrial_door_1_40_92_white_temp.vmdl" and thisEntity:GetOrigin() == Vector(7218, 2044, -128) then
		player:Attribute_SetIntValue("circuit_" .. map .. "_junction_health_trap_2_completed", 1)
	end
	
	if name == "door_reset" then
		SendToConsole("ent_fire door_reset enablereturntocompletion")
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count + 0.01
			if count >= 1 then
				thisEntity:FireOutput("OnCompletionA_Forward", nil, nil, nil, 0)
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
	end
	
	if name == "twohander" then
		SendToConsole("ent_fire twohander enablereturntocompletion")
		SendToConsole("ent_fire twohander setreturntocompletionamount 1")
	end
	
	if name == "589_panel_switch" then
		SendToConsole("ent_fire 589_panel_switchs enablereturntocompletion")
		local count = 0 + thisEntity:GetCycle()
		thisEntity:SetThink(function()
			DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 0 + count, 0, nil, nil)
			count = count + 0.01
			if count >= 1 then
				thisEntity:FireOutput("OnCompletionA_Backward", nil, nil, nil, 0)
				return nil
			else
				return 0
			end
		end, "AnimateCompletionValue", 0)
	end
end


---------- a4_c17_parking_garage ----------

if name == "toner_sliding_ladder" then
    ClimbLadder(160)
end


---------- Other ----------

if name == "prop_crowbar" then
    thisEntity:Kill()
end

if name == "l_candler" or name == "r_candler" then
    player:Attribute_SetIntValue("disable_unstuck", 1)
    SendToConsole("ent_fire innervault_energize_event_relay Kill")
    SendToConsole("ent_fire_output g_release_hand1 OnHandPosed")
    SendToConsole("ent_fire_output g_release_hand2 OnHandPosed")
    SendToConsole("ent_fire player_speedmod ModifySpeed 0")
    -- If subtitles are deactivated hide also the custom hud elements
    if Convars:GetStr("cc_subtitles") == "0" then
        SendToConsole("r_drawvgui 0")
    else
        SendToConsole("hidehud 4")
    end
    -- Just to make sure the heart icons are gone, hidehud 4 seems fine
    SendToConsole("hudhearts_stopupdateloop")
    SendToConsole("wristpockets_stopupdateloop")
end

if name == "combine_gun_mechanical" then
    SendToConsole("bind J novr_leavecombinegun")
	if thisEntity:Attribute_GetIntValue("used", 0) == 0 then
		local ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=5, ["x"]=-1, ["y"]=0.6})
		DoEntFireByInstanceHandle(ent, "SetText", "Press [J] to get out", 0, nil, nil)
		DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)

		ent = Entities:FindByName(nil, "combine_gun_interact") -- parent gun entity
		ent:Attribute_SetIntValue("ready", 1)
		ent:SaveQAngle("OrigAngle", ent:GetAngles())
	end
	EquipCombineGunMechanical(player)
    thisEntity:Attribute_SetIntValue("used", 1)
end

-- Call elevator button
if name == "18918_5275_button_pusher_prop" then
    SendToConsole("ent_fire_output 18918_5275_button_center_pusher OnIn")
end

-- Elevator button
if name == "18918_5316_button_pusher_prop" then
    SendToConsole("ent_fire_output 18918_5316_button_center_pusher OnIn")
    SendToConsole("phys_pushscale 0")
end

-- if name == "bridge_crank" then
    -- SendToConsole("ent_fire driven_bridge SetPlaybackRate 1 1")
    -- SendToConsole("ent_fire drawbridge_brush Enable")
    -- local ent = Entities:FindByName(nil, "bridge_crank")
    -- ent:FireOutput("OnInteractStart", nil, nil, nil, 0)
    -- ent:FireOutput("OnInteractStop", nil, nil, nil, 2.8)
-- end

if name == "3_8223_mesh_combine_switch_box" then
    if thisEntity:GetSequence() == "open_idle" then
        Entities:FindByName(nil, "3_8223_handpose_combine_switchbox_button_press"):FireOutput("OnHandPosed", nil, nil, nil, 0)
    end
end

if name == "3_8223_prop_button" then
    Entities:FindByName(nil, "3_8223_handpose_combine_switchbox_button_press"):FireOutput("OnHandPosed", nil, nil, nil, 0)
end

if class == "item_combine_tank_locker" then
    if thisEntity:GetCycle() <= 0.5 then
        DoEntFireByInstanceHandle(thisEntity, "PlayAnimation", "combine_locker_standing", 0, nil, nil)

        local ent = Entities:FindByClassname(nil, "item_hlvr_combine_console_tank")
        while ent do
            if ent:GetMoveParent() then
                DoEntFireByInstanceHandle(ent, "EnablePickup", "", 0, nil, nil)
            end
            ent = Entities:FindByClassname(ent, "item_hlvr_combine_console_tank")
        end
    end
end

if class == "item_healthcharger_reservoir" then
    local ent = Entities:FindByClassnameNearest("item_health_station_charger", thisEntity:GetOrigin(), 20)
    DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
end

if class == "prop_dynamic" then
    if model == "models/props_combine/health_charger/combine_health_charger_vr_pad.vmdl" then
        local ent = Entities:FindByClassnameNearest("item_health_station_charger", thisEntity:GetOrigin(), 20)
        DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
        ent = Entities:FindByClassnameNearest("item_healthcharger_internals", thisEntity:GetOrigin(), 20)
        if ent:GetSequence() == "idle_deployed" and tostring(thisEntity:GetMaterialGroupMask()) == "5" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            ent = Entities:FindByClassnameNearest("item_healthcharger", thisEntity:GetOrigin(), 20)

            local charges = 75

            if player:GetHealth() < player:GetMaxHealth() and ent:Attribute_GetIntValue("charges", charges) > 0 then
                ent:FireOutput("OnHealingPlayerStart", nil, nil, nil, 0)
                StartSoundEvent("HealthStation.Start", player)
                player:SetThink(function()
                    if player:GetVelocity().z == 0 then
                        SendToConsole("ent_fire player_speedmod ModifySpeed 0")
                        return nil
                    end
                    return 0
                end, "StopPlayerOnLand", 0)
            else
                StartSoundEvent("HealthStation.Deny", player)
                return
            end

            player:SetThink(function()
                local stop = false

                if player:Attribute_GetIntValue("use_released", 0) == 1 then
                    stop = true
                else
                    if player:GetHealth() >= player:GetMaxHealth() or ent:Attribute_GetIntValue("charges", charges) == 0 then
                        stop = true
                        StartSoundEvent("HealthStation.Complete", player)
                    else
                        player:SetHealth(player:GetHealth() + 1)
                        ent:Attribute_SetIntValue("charges", ent:Attribute_GetIntValue("charges", charges) - 1)

                        if ent:Attribute_GetIntValue("charges", charges) == 0 then
                            Entities:FindByClassnameNearest("item_hlvr_health_station_vial", ent:GetOrigin(), 50):SetGraphParameterBool("bDrain", true)
                        end

                        return 0.1
                    end
                end

                if stop then
                    SendToConsole("ent_fire_output health_station OnHealingPlayerStop")
                    player:StopThink("HealthChargeSoundLoop")
                    StopSoundEvent("HealthStation.Loop", player)
                    SendToConsole("ent_fire player_speedmod ModifySpeed 1")
                end
            end, "Interacting", 0)

            player:SetThink(function()
                StartSoundEvent("HealthStation.Loop", player)
            end, "HealthChargeSoundLoop", 0.7)
        end
    elseif model == "models/props/alyx_hideout/button_plate.vmdl" then
        -- SendToConsole("ent_fire 2_8127_elev_button_test_floor_" .. player:Attribute_GetIntValue("next_elevator_floor", 2) .. " Trigger")

        -- if player:Attribute_GetIntValue("next_elevator_floor", 2) == 2 then
            -- player:Attribute_SetIntValue("next_elevator_floor", 1)
        -- else
            -- player:Attribute_SetIntValue("next_elevator_floor", 2)
        -- end
    end
end

if map == "a3_hotel_interior_rooftop" and name == "window_sliding1" then
	SendToConsole("ent_fire zombieparty_window_slideconstraint setoffset 1")
    -- SendToConsole("fadein 0.2")
    -- SendToConsole("setpos_exact 788 -1420 576")
    SendToConsole("-use")
    thisEntity:SetThink(function()
        SendToConsole("+use")
    end, "", 0)
end

-- if name == "2860_window_sliding1" then
    -- SendToConsole("fadein 0.2")
    -- SendToConsole("setpos_exact 1437 -1422 140")
-- end

if name == "2_11128_cshield_station_1" then
    if thisEntity:GetCycle() == 1 then
        Entities:FindByName(nil, "2_11128_cshield_station_handpose"):FireOutput("OnHandPosed", nil, nil, nil, 0)
    end
end

if name == "2_11128_cshield_station_prop_button" then
    Entities:FindByName(nil, "2_11128_cshield_station_handpose"):FireOutput("OnHandPosed", nil, nil, nil, 0)
end

if name == "2_203_elev_button_floor_1" or name == "2_203_elevator_switch_box" then
    SendToConsole("ent_fire_output 2_203_elev_button_floor_1_handpose OnHandPosed")
end

if name == "2_203_inside_elevator_button" then
    SendToConsole("ent_fire_output 2_203_elev_button_elevator_handpose OnHandPosed")
end

if name == "inside_elevator_button" then
    SendToConsole("ent_fire_output elev_button_elevator_handpose OnHandPosed")
end

if name == "@pod_shell" or name == "pod_insides" then
    local ent = Entities:FindByName(nil, "@pod_shell")
    if ent:Attribute_GetIntValue("used", 0) == 0 then
        ent:Attribute_SetIntValue("used", 1)
        SendToConsole("ent_fire @pod_shell Unlock")
    end
end

if name == "traincar_01_hatch" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    thisEntity:Attribute_SetIntValue("used", 1)
    SendToConsole("ent_fire_output traincar_01_hackplug OnHackSuccess")
end

-- Combine fabricator
if class == "prop_hlvr_crafting_station_console" then
    if thisEntity:GetGraphParameter("bBootup") == true and thisEntity:Attribute_GetIntValue("crafting_station_ready", 0) == 1 then
        if thisEntity:GetGraphParameter("bCollectingResin") then
            if Convars:GetStr("chosen_upgrade") ~= "" then
                if Convars:GetStr("chosen_upgrade") == "cancel" then
                    thisEntity:SetGraphParameterBool("bCrafting", false)
                    SendToConsole("ent_fire point_clientui_world_panel Enable")
                    thisEntity:Attribute_SetIntValue("cancel_cooldown_done", 0)
                else
                    SendToConsole("ent_fire upgrade_ui kill")
                    -- TODO: ent_create point_clientui_world_movie_panel {src_movie "file://{resources}/videos/wupgrade_frabrication.webm" targetname test width 200 height 100 }
                end
                thisEntity:SetGraphParameterBool("bCollectingResin", false)
            end
        elseif thisEntity:Attribute_GetIntValue("cancel_cooldown_done", 1) == 1 and thisEntity:GetGraphParameter("bCrafting") == false then
            local viewmodel = Entities:FindByClassname(nil, "viewmodel")
            if viewmodel then
                if string.match(viewmodel:GetModelName(), "v_pistol") then
                    SendToConsole("ent_fire weapon_pistol Kill")
                    SendToConsole("use weapon_physcannon")
                    Convars:SetStr("weapon_in_crafting_station", "pistol")
                    local console = Entities:FindByClassnameNearest("prop_hlvr_crafting_station_console", player:GetOrigin(), 100)
                    local ent = Entities:FindByClassnameNearest("trigger_crafting_station_object_placement", console:GetOrigin(), 40)
                    local angles = ent:GetAngles()
                    local origin = ent:GetCenter() - angles:Forward() * 1.5 - Vector(0,0,2.25)
                    ent = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["targetname"]="weapon_in_fabricator", ["model"]="models/weapons/vr_alyxgun/vr_alyxgun.vmdl", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")
                    ent = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["targetname"]="weapon_in_fabricator", ["model"]="models/weapons/vr_alyxgun/vr_alyxgun_slide_anim_interact.vmdl", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")

                    local ents = Entities:FindAllByClassname("point_clientui_world_panel")
                    DoEntFireByInstanceHandle(ents[1], "Disable", "", 0, nil, nil)
                    DoEntFireByInstanceHandle(ents[2], "Disable", "", 0, nil, nil)
                    local angles = ents[2]:GetAngles()
                    local origin = ents[2]:GetOrigin() + Vector(0,0,0.04)
                    ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="upgrade_ui", ["dialog_layout_name"]="file://{resources}/layout/custom_game/crafting_station_pistol.xml", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent.upgrade1 = function()
                        if player:Attribute_GetIntValue("pistol_upgrade_aimdownsights", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 1")
                        end
                    end
                    ent.upgrade2 = function()
                        if player:Attribute_GetIntValue("pistol_upgrade_burstfire", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 2")
                        end
                    end
                    ent.upgrade3 = function()
                        if player:Attribute_GetIntValue("pistol_upgrade_hopper", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 3")
                        end
                    end
                    ent.upgrade4 = function()
                        if player:Attribute_GetIntValue("pistol_upgrade_lasersight", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 4")
                        end
                    end
                    ent.cancelupgrade = function()
                        SendToConsole("novr_crafting_station_cancel_upgrade")
                    end
                    ent:RedirectOutput("CustomOutput0", "cancelupgrade", ent)
                    ent:RedirectOutput("CustomOutput1", "upgrade1", ent)
                    ent:RedirectOutput("CustomOutput2", "upgrade2", ent)
                    ent:RedirectOutput("CustomOutput3", "upgrade3", ent)
                    ent:RedirectOutput("CustomOutput4", "upgrade4", ent)
                    SendToConsole("ent_fire upgrade_ui addcssclass HasObject")
                elseif string.match(viewmodel:GetModelName(), "v_shotgun") then
                    SendToConsole("ent_fire weapon_shotgun Kill")
                    SendToConsole("use weapon_physcannon")
                    Convars:SetStr("weapon_in_crafting_station", "shotgun")
                    local console = Entities:FindByClassnameNearest("prop_hlvr_crafting_station_console", player:GetOrigin(), 100)
                    local ent = Entities:FindByClassnameNearest("trigger_crafting_station_object_placement", console:GetOrigin(), 40)
                    local angles = ent:GetAngles()
                    local origin = ent:GetCenter() - angles:Forward() * 1.5 - Vector(0,0,2.25)
                    ent = SpawnEntityFromTableSynchronous("item_hlvr_weapon_shotgun", {["targetname"]="weapon_in_fabricator", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")

                    local ents = Entities:FindAllByClassname("point_clientui_world_panel")
                    DoEntFireByInstanceHandle(ents[1], "Disable", "", 0, nil, nil)
                    DoEntFireByInstanceHandle(ents[2], "Disable", "", 0, nil, nil)
                    local angles = ents[2]:GetAngles()
                    local origin = ents[2]:GetOrigin() + Vector(0,0,0.04)
                    ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="upgrade_ui", ["dialog_layout_name"]="file://{resources}/layout/custom_game/crafting_station_shotgun.xml", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent.upgrade1 = function()
                        if player:Attribute_GetIntValue("shotgun_upgrade_lasersight", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 1")
                        end
                    end
                    ent.upgrade2 = function()
                        if player:Attribute_GetIntValue("shotgun_upgrade_doubleshot", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 2")
                        end
                    end
                    ent.upgrade3 = function()
                        if player:Attribute_GetIntValue("shotgun_upgrade_hopper", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 3")
                        end
                    end
                    ent.upgrade4 = function()
                        if player:Attribute_GetIntValue("shotgun_upgrade_grenadelauncher", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 4")
                        end
                    end
                    ent.cancelupgrade = function()
                        SendToConsole("novr_crafting_station_cancel_upgrade")
                    end
                    ent:RedirectOutput("CustomOutput0", "cancelupgrade", ent)
                    ent:RedirectOutput("CustomOutput1", "upgrade1", ent)
                    ent:RedirectOutput("CustomOutput2", "upgrade2", ent)
                    ent:RedirectOutput("CustomOutput3", "upgrade3", ent)
                    ent:RedirectOutput("CustomOutput4", "upgrade4", ent)
                    SendToConsole("ent_fire upgrade_ui addcssclass HasObject")
                elseif string.match(viewmodel:GetModelName(), "v_smg1") then
                    SendToConsole("ent_fire weapon_ar2 Kill")
                    SendToConsole("use weapon_physcannon")
                    Convars:SetStr("weapon_in_crafting_station", "smg")
                    local console = Entities:FindByClassnameNearest("prop_hlvr_crafting_station_console", player:GetOrigin(), 100)
                    local ent = Entities:FindByClassnameNearest("trigger_crafting_station_object_placement", console:GetOrigin(), 40)
                    local angles = ent:GetAngles()
                    local origin = ent:GetCenter() - angles:Forward() * 1.5 - Vector(0,0,2.25)
                    ent = SpawnEntityFromTableSynchronous("item_hlvr_weapon_rapidfire", {["targetname"]="weapon_in_fabricator", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")

                    local ents = Entities:FindAllByClassname("point_clientui_world_panel")
                    DoEntFireByInstanceHandle(ents[1], "Disable", "", 0, nil, nil)
                    DoEntFireByInstanceHandle(ents[2], "Disable", "", 0, nil, nil)
                    local angles = ents[2]:GetAngles()
                    local origin = ents[2]:GetOrigin() + Vector(0,0,0.04)
                    ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="upgrade_ui", ["dialog_layout_name"]="file://{resources}/layout/custom_game/crafting_station_smg.xml", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent.upgrade1 = function()
                        if player:Attribute_GetIntValue("smg_upgrade_aimdownsights", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 1")
                        end
                    end
                    ent.upgrade2 = function()
                        if player:Attribute_GetIntValue("smg_upgrade_lasersight", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 2")
                        end
                    end
                    ent.upgrade3 = function()
                        if player:Attribute_GetIntValue("smg_upgrade_casing", 0) == 0 then
                            SendToConsole("novr_crafting_station_choose_upgrade 3")
                        end
                    end
                    ent.cancelupgrade = function()
                        SendToConsole("novr_crafting_station_cancel_upgrade")
                    end
                    ent:RedirectOutput("CustomOutput0", "cancelupgrade", ent)
                    ent:RedirectOutput("CustomOutput1", "upgrade1", ent)
                    ent:RedirectOutput("CustomOutput2", "upgrade2", ent)
                    ent:RedirectOutput("CustomOutput3", "upgrade3", ent)
                    SendToConsole("ent_fire upgrade_ui addcssclass HasObject")
                else
                    return
                end
                thisEntity:SetGraphParameterBool("bCollectingResin", true)
                thisEntity:SetGraphParameterBool("bCrafting", true)
                thisEntity:Attribute_GetIntValue("crafting_station_ready", 0)
            end
        end
        if thisEntity:GetGraphParameter("bCrafting") == false then
            Convars:SetStr("chosen_upgrade", "")
        end
    end
end

if class == "item_hlvr_combine_console_tank" then
    if thisEntity:GetGraphParameter("bAwake") == true then
        return
    end

    if thisEntity:GetMoveParent() then
        DoEntFireByInstanceHandle(thisEntity, "ClearParent", "", 0, nil, nil)
    else
        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        local look_delta = player:EyeAngles()
        player:SetThink(function()
            if player:Attribute_GetIntValue("use_released", 0) == 0 then
                thisEntity:SetAngularVelocity(0,0,0)
                local x = (look_delta.x - player:EyeAngles().x) * -50
                if x < 0 then
                    x = x * 1.75
                end
                thisEntity:ApplyLocalAngularVelocityImpulse(Vector(Clamp(x, -18, 18) , 0, 0))
                look_delta = player:EyeAngles()
                return 0
            end
        end, "Interacting", 0)
    end
end

if class == "item_hlvr_weapon_tripmine" then
	SendToConsole("ent_fire !picker deactivatemine")
end

if name == "room1_lights_circuitbreaker_switch" then
    SendToConsole("ent_fire_output controlroom_circuitbreaker_relay ontrigger")
	if player:Attribute_GetIntValue("auto_flashlight", 1) == 1 and _G.flashlight_on == "0" then
		create_flashlight()
		_G.flashlight_on = "1"
	end
end

if name == "plug_console_starter_lever"and not map == "a3_distillery" then
    if map == "a4_c17_tanker_yard" then
        if thisEntity:Attribute_GetIntValue("used", 0) == 1 then
            return
        end

        thisEntity:Attribute_SetIntValue("used", 1)
    end

    SendToConsole("ent_fire_output plug_console_starter_lever OnCompletionB_Forward")
end

if name == "lift_button_box" then
	if RAISE_PLATFORM == "" then
		if thisEntity:Attribute_GetIntValue("used", 0) == 1 then
			SendToConsole("ent_fire_output lift_button_down onin")
			thisEntity:Attribute_SetIntValue("used", 0)
		else
			SendToConsole("ent_fire_output lift_button_up onin")
			thisEntity:Attribute_SetIntValue("used", 1)
		end
	else
		SendToConsole("bind " .. RAISE_PLATFORM .. " +raise_platform")
		SendToConsole("bind " .. LOWER_PLATFORM .. " +lower_platform")
	end
else
	SendToConsole("unbind " .. RAISE_PLATFORM)
	SendToConsole("unbind " .. LOWER_PLATFORM)
end

if name == "pallet_lever_vertical" then
    SendToConsole("ent_fire_output pallet_logic_phys_raise ontrigger")
end

if name == "pallet_lever" then
    SendToConsole("ent_fire_output pallet_logic_extend ontrigger")
end

if class == "item_hlvr_headcrab_gland" then
    SendToConsole("ent_fire achievement_squeeze_heart FireEvent")
end

if class == "prop_reviver_heart" then
    player:SetContextNum("player_picked_up_heart", 1, 10)
end

if model == "models/props/construction/hat_construction.vmdl" and name ~= "hat_construction" then
    if Entities:FindByName(nil, "hat_construction_viewmodel") then
        return
    end

    if player:Attribute_GetIntValue("wearable_tutorial_shown", 0) == 0 then
        player:Attribute_SetIntValue("wearable_tutorial_shown", 1)
        SendToConsole("ent_fire text_wearable ShowMessage")
        SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
    end

    local ent = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["targetname"]="hat_construction_viewmodel", ["model"]="models/props/construction/hat_construction.vmdl", ["disableshadows"]=true, ["solid"]=0})
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    ent:SetParent(viewmodel, "")
    ent:SetAbsOrigin(viewmodel:GetOrigin() + RotatePosition(Vector(0, 0, 0), player:GetAngles(), Vector(0, 0, 4)))
    ent:SetLocalAngles(0, 0, 0)

    if thisEntity:GetMaterialGroupHash() < 0 then
        ent:SetSkin(1)
        local color = thisEntity:GetRenderColor()
        ent:SetRenderColor(color.x, color.y, color.z)
    end

    SendToConsole("ent_fire npc_barnacle SetRelationship \"player D_NU 99\"")

    thisEntity:Kill()
end

if class == "item_item_crate" then
    DoEntFireByInstanceHandle(thisEntity, "SetHealth", "0", 0, nil, nil)
end

local item_pickup_params = { ["userid"]=player:GetUserID(), ["item"]=class, ["item_name"]=name }

-- Weapons
if class == "item_hlvr_weapon_energygun" and map ~= "a1_intro_world_2" then
	SendToConsole("give weapon_pistol")
	SendToConsole("ent_remove weapon_bugbait")
	thisEntity:Kill()
elseif class == "item_hlvr_weapon_shotgun" and name ~= "weapon_in_fabricator" then
    item_pickup_params.item = "hlvr_weapon_shotgun"
    FireGameEvent("item_pickup", item_pickup_params)

    SendToConsole("give weapon_shotgun")
    SendToConsole("ent_fire 12712_relay_player_shotgun_is_ready Trigger")
    SendToConsole("ent_fire item_hlvr_weapon_shotgun Kill")

    player:SetThink(function()
        SendToConsole("ent_fire 12712_shotgun_zombie_speak CancelSpeech")
    end, "RemoveRusselReloadingHint", 0.5)
elseif class == "item_hlvr_weapon_rapidfire" and name ~= "weapon_in_fabricator" then
    SendToConsole("give weapon_ar2")
    if map == "a3_hotel_interior_rooftop" then
        local ents = Entities:FindAllByClassnameWithin("item_hlvr_clip_rapidfire", thisEntity:GetCenter(), 10)
        for k, v in pairs(ents) do
            DoEntFireByInstanceHandle(v, "RunScriptFile", "useextra", 0, player, nil)
        end
    end
    SendToConsole("ent_fire item_hlvr_weapon_rapidfire Kill")

-- Other Items
elseif vlua.find(class, "item_hlvr_crafting_currency_") then
    if name == "currency_booby_trap" then
        thisEntity:FireOutput("OnPlayerPickup", nil, nil, nil, 0)
    end

    FireGameEvent("item_pickup", item_pickup_params)
    if vlua.find(class, "large") then
        SendToConsole("hlvr_addresources 0 0 0 5")
    else
        SendToConsole("hlvr_addresources 0 0 0 1")
    end
    StartSoundEventFromPosition("Inventory.BackpackGrabItemResin", player:EyePosition())

    thisEntity:Kill()
elseif class == "item_hlvr_clip_energygun" or class == "item_hlvr_clip_generic_pistol" then
    player:Attribute_SetIntValue("pistol_magazine_ammo", 10)
    FireGameEvent("item_pickup", item_pickup_params)
    if name == "pistol_clip_1" then
        SendToConsole("ent_remove weapon_bugbait")
        SendToConsole("give weapon_pistol")
        SendToConsole("ent_fire_output ammo_insert_listener OnEventFired")
        player:SetThink(function()
            SendToConsole("ent_fire text_shoot ShowMessage")
            SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
        end, "ShowShootTutorial", 4)
    else
        SendToConsole("hlvr_addresources 10 0 0 0")
    end
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_energygun_multiple" or class == "item_hlvr_clip_generic_pistol_multiple" then
    if thisEntity:Attribute_GetIntValue("used", 0) == 1 then
        return
    end
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 40 0 0 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_shotgun_multiple" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 0 0 4 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_shotgun_single" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 0 0 1 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_rapidfire" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 0 30 0 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_grenade_xen" then
    if player:Attribute_GetIntValue("grenade_tutorial_shown", 0) <= 1 then
        player:Attribute_SetIntValue("grenade_tutorial_shown", 2)
        SendToConsole("ent_fire text_grenade ShowMessage")
        SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
    end

    if WristPockets_PlayerHasFreePocketSlot(player) then
        -- player can store max 2 grenades in pockets
        -- all grenades will go straight into pockets if there is capacity
        WristPockets_PickUpXenGrenade(player, thisEntity)
        FireGameEvent("item_pickup", item_pickup_params)

        StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())

        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        viewmodel:RemoveEffects(32)
        thisEntity:Kill()
    end
elseif class == "item_hlvr_grenade_frag" then
    thisEntity:Attribute_SetIntValue("picked_up", 0)
    if thisEntity:GetSequence() == "vr_grenade_unarmed_idle" then
        if player:Attribute_GetIntValue("grenade_tutorial_shown", 0) == 0 then
            player:Attribute_SetIntValue("grenade_tutorial_shown", 1)
            SendToConsole("ent_fire text_grenade ShowMessage")
            SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
        end

        local ent = Entities:FindByName(nil, "player_radio_station")
        if ent then
            DoEntFireByInstanceHandle(ent, "SpeakConcept", "speech:open_grenades", 0, nil, nil)
        end

        if WristPockets_PlayerHasFreePocketSlot(player) then
			-- player can store max 2 grenades in pockets
			-- all grenades will go straight into pockets if there is capacity
			WristPockets_PickUpGrenade(player, thisEntity)
			FireGameEvent("item_pickup", item_pickup_params)
            SendToConsole("viewmodel_update")

            StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
            --SendToConsole("give weapon_frag")
            local viewmodel = Entities:FindByClassname(nil, "viewmodel")
            viewmodel:RemoveEffects(32)
            thisEntity:Kill()
		end
    end
elseif class == "item_healthvial" then
    thisEntity:Attribute_SetIntValue("picked_up", 0)
    if player:GetHealth() < (player:GetMaxHealth() - 15) or (WristPockets_PlayerHasFreePocketSlot(player) == false and player:GetHealth() < player:GetMaxHealth()) then
        player:Attribute_SetIntValue("syringe_tutorial_shown", 1)
        player:SetContextNum("used_health_pen", 1, 10)
        player:SetHealth(min(player:GetHealth() + cvar_getf("hlvr_health_vial_amount"), player:GetMaxHealth()))
        FireGameEvent("item_pickup", item_pickup_params)
        StartSoundEventFromPosition("HealthPen.Stab", player:EyePosition())
        StartSoundEventFromPosition("HealthPen.Success01", player:EyePosition())
        StartSoundEventFromPosition("HealthPen.Success02", player:EyePosition())
        thisEntity:Kill()
    elseif player:Attribute_GetIntValue("syringe_tutorial_shown", 0) == 0 then
        player:Attribute_SetIntValue("syringe_tutorial_shown", 1)
        SendToConsole("ent_fire text_syringe ShowMessage")
        SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
    else
		WristPockets_PickUpHealthPen(player, thisEntity)
		FireGameEvent("item_pickup", item_pickup_params)
    end
elseif class == "item_hlvr_prop_battery" or class == "item_hlvr_health_station_vial" or class == "prop_reviver_heart" then
    if thisEntity:Attribute_GetIntValue("no_pick_up", 0) == 0 then
        -- prevent wristpocket pickup if health station vial is already mounted in charger
        if class == "item_hlvr_health_station_vial" then
            local entcharger = Entities:FindByClassnameNearest("item_healthcharger_internals", thisEntity:GetOrigin(), 20)
            if entcharger ~= nil then
                if not entcharger:GetSequence() == "idle_deployed" and not entcharger:GetSequence() == "prepare_inject" and not entcharger:GetSequence() == "idle_retracted" then
                    WristPockets_PickUpValuableItem(player, thisEntity)
                else
                    local ent = Entities:FindByClassnameNearest("item_health_station_charger", thisEntity:GetOrigin(), 20)
                    DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
                end
            else
                WristPockets_PickUpValuableItem(player, thisEntity)
            end
        else
            WristPockets_PickUpValuableItem(player, thisEntity)
        end
    elseif thisEntity:Attribute_GetIntValue("no_pick_up", 0) == 1 then
        thisEntity:Attribute_SetIntValue("no_pick_up", 0)
    end
end
