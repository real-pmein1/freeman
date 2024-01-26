require "wristpockets"

-- Display upgraded weapon viewmodels by withoutaface

local function PrecacheViewModels()
    local ent_table = { -- used solution by SoMNst & Epic
        targetname = "novr_precacheviewmodels",
		vscripts = "viewmodels_precache.lua"
    }
	SpawnEntityFromTableAsynchronous("logic_script", ent_table, nil, nil);
end

-- Init is called in novr.lua
function Viewmodels_Init()
    -- Precache the viewmodels
    PrecacheViewModels()
    -- Set model after map load
    local player = Entities:GetLocalPlayer()
    player:SetThink(function()
        Viewmodels_UpgradeModel()
    end, "ViewmodelUpgradeInit", 1)
end

-- Check for weapon upgrades and set the correct viewmodel
function Viewmodels_UpgradeModel()
    local player = Entities:GetLocalPlayer()

    -- Fetch pistol upgrades
    local pistol_aimdownsights = player:Attribute_GetIntValue("pistol_upgrade_aimdownsights", 0)
    local pistol_burstfire = player:Attribute_GetIntValue("pistol_upgrade_burstfire", 0)
    local pistol_hopper = player:Attribute_GetIntValue("pistol_upgrade_hopper", 0)
    local pistol_lasersight = player:Attribute_GetIntValue("pistol_upgrade_lasersight", 0)

    -- List of pistol viewmodels
    local pistol_search_str = "v_pistol"
    local pistol_viewmodel_shroud_stock = "models/weapons/v_pistol_shroud_stock.vmdl"
    local pistol_viewmodel_shroud_stock_ads = "models/weapons/v_pistol_shroud_stock_ads.vmdl"
    local pistol_viewmodel_stock = "models/weapons/v_pistol_stock.vmdl"
    local pistol_viewmodel_shroud = "models/weapons/v_pistol_shroud.vmdl"
    local pistol_viewmodel_shroud_ads = "models/weapons/v_pistol_shroud_ads.vmdl"
    local pistol_viewmodel_hopper = "models/weapons/v_pistol_hopper.vmdl"
    local pistol_viewmodel_hopper_ads = "models/weapons/v_pistol_hopper_ads.vmdl"
    local pistol_viewmodel_base = "models/weapons/v_pistol.vmdl"
    local pistol_viewmodel_hopper_no_shroud = "models/weapons/v_pistol_hopper_no_shroud.vmdl"
	local pistol_viewmodel_hopper_no_shroud_stock = "models/weapons/v_pistol_hopper_no_shroud_stock.vmdl"
	local pistol_viewmodel_hopper_no_stock = "models/weapons/v_pistol_hopper_no_stock.vmdl"
	local pistol_viewmodel_hopper_no_stock_ads = "models/weapons/v_pistol_hopper_no_stock_ads.vmdl"

    -- Fetch shotgun upgrades
    local shotgun_doubleshot = player:Attribute_GetIntValue("shotgun_upgrade_doubleshot", 0)
    local shotgun_grenadelauncher = player:Attribute_GetIntValue("shotgun_upgrade_grenadelauncher", 0)
    local shotgun_hopper = player:Attribute_GetIntValue("shotgun_upgrade_hopper", 0)
    local shotgun_lasersight = player:Attribute_GetIntValue("shotgun_upgrade_lasersight", 0)

    local shotgun_playerhasgrenade = WristPockets_PlayerHasGrenade()

    -- List of shotgun viewmodels
    local shotgun_search_str = "v_shotgun"
    local shotgun_viewmodel_burst_grenade_attached = "models/weapons/v_shotgun_burst_grenade_attached.vmdl"
    local shotgun_viewmodel_burst_grenade = "models/weapons/v_shotgun_burst_grenade.vmdl"
    local shotgun_viewmodel_burst = "models/weapons/v_shotgun_burst.vmdl"
    local shotgun_viewmodel_grenade_attached = "models/weapons/v_shotgun_grenade_attached.vmdl"
    local shotgun_viewmodel_grenade = "models/weapons/v_shotgun_grenade.vmdl"
    local shotgun_viewmodel_hopper = "models/weapons/v_shotgun_hopper.vmdl"
    local shotgun_viewmodel_base = "models/weapons/v_shotgun.vmdl"
    local shotgun_viewmodel_hopper_grenade_attached = "models/weapons/v_shotgun_hopper_grenade_attached.vmdl"
	local shotgun_viewmodel_hopper_no_burst = "models/weapons/v_shotgun_hopper_no_burst.vmdl"
	local shotgun_viewmodel_hopper_no_burst_grenade_attached = "models/weapons/v_shotgun_hopper_no_burst_grenade_attached.vmdl"
	local shotgun_viewmodel_hopper_no_grenade = "models/weapons/v_shotgun_hopper_no_grenade.vmdl"
    local shotgun_viewmodel_hopper_no_burst_grenade = "models/weapons/v_shotgun_hopper_no_burst_grenade.vmdl"

    -- Fetch smg1 upgrades
    local smg_aimdownsights = player:Attribute_GetIntValue("smg_upgrade_aimdownsights", 0)
    local smg_fasterfirerate = player:Attribute_GetIntValue("smg_upgrade_fasterfirerate", 0)
    local smg_casing = player:Attribute_GetIntValue("smg_upgrade_casing", 0)
    local smg_lasersight = player:Attribute_GetIntValue("smg_upgrade_lasersight", 0)

    -- List of smg1 viewmodels
    local smg_search_str = "v_smg1"
    local smg_viewmodel_holo = "models/weapons/v_smg1_holo.vmdl"
    local smg_viewmodel_holo_ads = "models/weapons/v_smg1_holo_ads.vmdl"
    local smg_viewmodel_powerpack = "models/weapons/v_smg1_powerpack.vmdl"
    local smg_viewmodel_base = "models/weapons/v_smg1.vmdl"
    local smg_viewmodel_casing = "models/weapons/v_smg1_casing.vmdl"
    local smg_viewmodel_casing_ads = "models/weapons/v_smg1_casing_ads.vmdl"
    local smg_viewmodel_casing_no_holo = "models/weapons/v_smg1_casing_no_holo.vmdl"
	local smg_viewmodel_casing_no_holo_powerpack = "models/weapons/v_smg1_casing_no_holo_powerpack.vmdl"

    -- Update weapon viewmodel
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    if viewmodel then
        local viewmodel_name = viewmodel:GetModelName()
        --print(string.format("found viewmodel %s", viewmodel_name))

        if cvar_getf("fov_ads_zoom") > FOV_ADS_ZOOM then
            SendToConsole("hud_draw_fixed_reticle 1")
            SendToConsole("crosshair 0")
        end
        
        -- Set upgraded pistol viewmodels
        if string.match(viewmodel_name, pistol_search_str) then
            -- laser sight
            if pistol_lasersight == 1 and cvar_getf("fov_ads_zoom") > FOV_ADS_ZOOM then
                SendToConsole("hud_draw_fixed_reticle 0")
                SendToConsole("crosshair 1")
            end
            -- hopper
            if pistol_hopper == 1 and pistol_aimdownsights == 1 and pistol_burstfire == 1 then
                if string.match(viewmodel_name, pistol_viewmodel_hopper) or string.match(viewmodel_name, pistol_viewmodel_hopper_ads) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_hopper)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s, hopper %s)", pistol_viewmodel_hopper, pistol_aimdownsights, pistol_burstfire, pistol_hopper))
                    return
                end
            -- hopper no shroud
            elseif pistol_hopper == 1 and pistol_aimdownsights == 0 and pistol_burstfire == 1 then
                if string.match(viewmodel_name, pistol_viewmodel_hopper_no_shroud) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_hopper_no_shroud)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s, hopper %s)", pistol_viewmodel_hopper_no_shroud, pistol_aimdownsights, pistol_burstfire, pistol_hopper))
                    return
                end
            -- hopper no stock
            elseif pistol_hopper == 1 and pistol_aimdownsights == 1 and pistol_burstfire == 0 then
                if string.match(viewmodel_name, pistol_viewmodel_hopper_no_stock) or string.match(viewmodel_name, pistol_viewmodel_hopper_no_stock_ads) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_hopper_no_stock)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s, hopper %s)", pistol_viewmodel_hopper_no_stock, pistol_aimdownsights, pistol_burstfire, pistol_hopper))
                    return
                end
            -- hopper no shroud no stock
            elseif pistol_hopper == 1 and pistol_aimdownsights == 0 and pistol_burstfire == 0 then
                if string.match(viewmodel_name, pistol_viewmodel_hopper_no_shroud_stock) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_hopper_no_shroud_stock)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s, hopper %s)", pistol_viewmodel_hopper_no_shroud_stock, pistol_aimdownsights, pistol_burstfire, pistol_hopper))
                    return
                end
            -- shroud and stock
            elseif pistol_aimdownsights == 1 and pistol_burstfire == 1 then
                if string.match(viewmodel_name, pistol_viewmodel_shroud_stock) or string.match(viewmodel_name, pistol_viewmodel_shroud_stock_ads) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_shroud_stock)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s)", pistol_viewmodel_shroud_stock, pistol_aimdownsights, pistol_burstfire))
                    return
                end
            -- shroud
            elseif pistol_aimdownsights == 1 and pistol_burstfire == 0 then
                if string.match(viewmodel_name, pistol_viewmodel_shroud) or string.match(viewmodel_name, pistol_viewmodel_shroud_ads) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_shroud)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s)", pistol_viewmodel_shroud, pistol_aimdownsights, pistol_burstfire))
                    return
                end
            -- stock
            elseif pistol_aimdownsights == 0 and pistol_burstfire == 1 then
                if string.match(viewmodel_name, pistol_viewmodel_stock) then
                    return
                else
                    viewmodel:SetModel(pistol_viewmodel_stock)
                    print(string.format("Viewmodels - pistol: %s (aimdownsights %s, burstfire %s)", pistol_viewmodel_stock, pistol_aimdownsights, pistol_burstfire))
                    return
                end
            end
        end

        -- Set upgraded shotgun viewmodels
        if string.match(viewmodel_name, shotgun_search_str) then
            -- laser sight
            if shotgun_lasersight == 1 and cvar_getf("fov_ads_zoom") > FOV_ADS_ZOOM then
                SendToConsole("hud_draw_fixed_reticle 0")
                SendToConsole("crosshair 1")
            end
            -- hopper
            if shotgun_hopper == 1 and shotgun_doubleshot == 1 and shotgun_grenadelauncher == 1 then
                if string.match(viewmodel_name, shotgun_viewmodel_hopper_grenade_attached) and shotgun_playerhasgrenade then
                    return
                elseif string.match(viewmodel_name, shotgun_viewmodel_hopper) and shotgun_playerhasgrenade == false then
                    return
                else
                    if shotgun_playerhasgrenade then
                        viewmodel:SetModel(shotgun_viewmodel_hopper_grenade_attached)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s, hopper %s)", shotgun_viewmodel_hopper_grenade_attached, shotgun_doubleshot, shotgun_grenadelauncher, shotgun_hopper))
                    else
                        viewmodel:SetModel(shotgun_viewmodel_hopper)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s, hopper %s)", shotgun_viewmodel_hopper, shotgun_doubleshot, shotgun_grenadelauncher, shotgun_hopper))
                    end
                    return
                end
            -- hopper no burst
            elseif shotgun_hopper == 1 and shotgun_doubleshot == 0 and shotgun_grenadelauncher == 1 then
                if string.match(viewmodel_name, shotgun_viewmodel_hopper_no_burst_grenade_attached) and shotgun_playerhasgrenade then
                    return
                elseif string.match(viewmodel_name, shotgun_viewmodel_hopper_no_burst) and shotgun_playerhasgrenade == false then
                    return
                else
                    if shotgun_playerhasgrenade then
                        viewmodel:SetModel(shotgun_viewmodel_hopper_no_burst_grenade_attached)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s, hopper %s)", shotgun_viewmodel_hopper_no_burst_grenade_attached, shotgun_doubleshot, shotgun_grenadelauncher, shotgun_hopper))
                    else
                        viewmodel:SetModel(shotgun_viewmodel_hopper_no_burst)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s, hopper %s)", shotgun_viewmodel_hopper_no_burst, shotgun_doubleshot, shotgun_grenadelauncher, shotgun_hopper))
                    end
                    return
                end
            -- hopper no grenade
            elseif shotgun_hopper == 1 and shotgun_doubleshot == 1 and shotgun_grenadelauncher == 0 then
                if string.match(viewmodel_name, shotgun_viewmodel_hopper_no_grenade) then
                    return
                else
                    viewmodel:SetModel(shotgun_viewmodel_hopper_no_grenade)
                    print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s, hopper %s)", shotgun_viewmodel_hopper_no_grenade, shotgun_doubleshot, shotgun_grenadelauncher, shotgun_hopper))
                    return
                end
            -- hopper no burst no grenade
            elseif shotgun_hopper == 1 and shotgun_doubleshot == 0 and shotgun_grenadelauncher == 0 then
                if string.match(viewmodel_name, shotgun_viewmodel_hopper_no_burst_grenade) then
                    return
                else
                    viewmodel:SetModel(shotgun_viewmodel_hopper_no_burst_grenade)
                    print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s, hopper %s)", shotgun_viewmodel_hopper_no_burst_grenade, shotgun_doubleshot, shotgun_grenadelauncher, shotgun_hopper))
                    return
                end
            -- burst and grenade
            elseif shotgun_doubleshot == 1 and shotgun_grenadelauncher == 1 then
                if string.match(viewmodel_name, shotgun_viewmodel_burst_grenade_attached) and shotgun_playerhasgrenade then
                    return
                elseif string.match(viewmodel_name, shotgun_viewmodel_burst_grenade) and shotgun_playerhasgrenade == false then
                    return
                else
                    if shotgun_playerhasgrenade then
                        viewmodel:SetModel(shotgun_viewmodel_burst_grenade_attached)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s)", shotgun_viewmodel_burst_grenade_attached, shotgun_doubleshot, shotgun_grenadelauncher))
                    else
                        viewmodel:SetModel(shotgun_viewmodel_burst_grenade)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s)", shotgun_viewmodel_burst_grenade, shotgun_doubleshot, shotgun_grenadelauncher))
                    end
                    return
                end
            -- burst
            elseif shotgun_doubleshot == 1 and shotgun_grenadelauncher == 0 then
                if string.match(viewmodel_name, shotgun_viewmodel_burst) then
                    return
                else
                    viewmodel:SetModel(shotgun_viewmodel_burst)
                    print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s)", shotgun_viewmodel_burst, shotgun_doubleshot, shotgun_grenadelauncher))
                    return
                end
            -- grenade
            elseif shotgun_doubleshot == 0 and shotgun_grenadelauncher == 1 then
                if string.match(viewmodel_name, shotgun_viewmodel_grenade_attached) and shotgun_playerhasgrenade then
                    return
                elseif string.match(viewmodel_name, shotgun_viewmodel_grenade) and shotgun_playerhasgrenade == false then
                    return
                else
                    if shotgun_playerhasgrenade then
                        viewmodel:SetModel(shotgun_viewmodel_grenade_attached)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s)", shotgun_viewmodel_grenade_attached, shotgun_doubleshot, shotgun_grenadelauncher))
                    else
                        viewmodel:SetModel(shotgun_viewmodel_grenade)
                        print(string.format("Viewmodels - shotgun: %s (doubleshot %s, grenadelauncher %s)", shotgun_viewmodel_grenade, shotgun_doubleshot, shotgun_grenadelauncher))
                    end
                    return
                end
            end
        end

        -- Set upgraded smg1 viewmodels
        if string.match(viewmodel_name, smg_search_str) then
            -- laser sight
            if smg_lasersight == 1 and cvar_getf("fov_ads_zoom") > FOV_ADS_ZOOM then
                SendToConsole("hud_draw_fixed_reticle 0")
                SendToConsole("crosshair 1")
            end
            -- casing
            if smg_casing == 1 and smg_aimdownsights == 1 and (smg_fasterfirerate == 1 or smg_fasterfirerate == 0) then
                if string.match(viewmodel_name, smg_viewmodel_casing) or string.match(viewmodel_name, smg_viewmodel_casing_ads) then
                    return
                else
                    viewmodel:SetModel(smg_viewmodel_casing)
                    print(string.format("Viewmodels - smg: %s (aimdownsights %s, fasterfirerate %s, casing %s)", smg_viewmodel_casing, smg_aimdownsights, smg_fasterfirerate, smg_casing))
                    return
                end
            -- casing no holo
            elseif smg_casing == 1 and smg_aimdownsights == 0 and smg_fasterfirerate == 1 then
                if string.match(viewmodel_name, smg_viewmodel_casing_no_holo) then
                    return
                else
                    viewmodel:SetModel(smg_viewmodel_casing_no_holo)
                    print(string.format("Viewmodels - smg: %s (aimdownsights %s, fasterfirerate %s, casing %s)", smg_viewmodel_casing_no_holo, smg_aimdownsights, smg_fasterfirerate, smg_casing))
                    return
                end
            -- casing no holo no powerpack
            elseif smg_casing == 1 and smg_aimdownsights == 0 and smg_fasterfirerate == 0 then
                if string.match(viewmodel_name, smg_viewmodel_casing_no_holo_powerpack) then
                    return
                else
                    viewmodel:SetModel(smg_viewmodel_casing_no_holo_powerpack)
                    print(string.format("Viewmodels - smg: %s (aimdownsights %s, fasterfirerate %s, casing %s)", smg_viewmodel_casing_no_holo_powerpack, smg_aimdownsights, smg_fasterfirerate, smg_casing))
                    return
                end
            -- holo
            elseif smg_aimdownsights == 1 and (smg_fasterfirerate == 1 or smg_fasterfirerate == 0) then
                if string.match(viewmodel_name, smg_viewmodel_holo) or string.match(viewmodel_name, smg_viewmodel_holo_ads) then
                    return
                else
                    viewmodel:SetModel(smg_viewmodel_holo)
                    print(string.format("Viewmodels - smg: %s (aimdownsights %s, fasterfirerate %s)", smg_viewmodel_holo, smg_aimdownsights, smg_fasterfirerate))
                    return
                end
            -- powerpack
            elseif smg_aimdownsights == 0 and smg_fasterfirerate == 1 then
                if string.match(viewmodel_name, smg_viewmodel_powerpack) then
                    return
                else
                    viewmodel:SetModel(smg_viewmodel_powerpack)
                    print(string.format("Viewmodels - smg: %s (aimdownsights %s, fasterfirerate %s)", smg_viewmodel_powerpack, smg_aimdownsights, smg_fasterfirerate))
                    return
                end
            end
        end

    end
end

-- Function to call after weapon switch
Convars:RegisterCommand("viewmodel_update" , function()
    local player = Entities:GetLocalPlayer()
    if player ~= nil then
        player:SetThink(function()
            Viewmodels_UpgradeModel()
        end, "ViewmodelUpdate", 0)
    end
end, "function viewmodel_update", 0)
