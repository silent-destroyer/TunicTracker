-- LAYOUT SWITCHING
function apLayoutChange()
    local progSword = Tracker:FindObjectForCode("progswordSetting")
    if (string.find(Tracker.ActiveVariantUID, "standard") or string.find(Tracker.ActiveVariantUID, "var_itemsonly") or string.find(Tracker.ActiveVariantUID, "var_minimal")) then
        if progSword.Active then
            Tracker:AddLayouts("layouts/itemspop_progsword.json")
            Tracker:AddLayouts("layouts/broadcastpop_progsword.json")
        else
            Tracker:AddLayouts("layouts/itemspop.json")
            Tracker:AddLayouts("layouts/standard_broadcastpop.json")
        end
    end
end

ScriptHost:AddWatchForCode("useApLayout", "progswordSetting", apLayoutChange)

function updateLayout()
    local ladders = Tracker:FindObjectForCode("ladder_shuffle")
    local fuses = Tracker:FindObjectForCode("fuse_shuffle")
    local enemies = Tracker:FindObjectForCode("shuffle_enemy_drops")
    local souls = Tracker:FindObjectForCode("shuffle_enemy_souls")
    local layoutString = "layouts/trackerpop"
    if (string.find(Tracker.ActiveVariantUID, "standard") or string.find(Tracker.ActiveVariantUID, "var_itemsonly") or string.find(Tracker.ActiveVariantUID, "var_minimal")) then
        if ladders.Active then
            layoutString = layoutString .. "_ladders"
        end
        if fuses.Active then
            layoutString = layoutString .. "_fuses"
        end
        if enemies.CurrentStage > 0 and souls.Active then
            layoutString = layoutString .. "_enemies"
        end
        if Tracker:FindObjectForCode("show_hints").Active then
            layoutString = layoutString .. "_hints"
        end
        Tracker:AddLayouts(layoutString .. ".json")
        Tracker:AddLayouts(layoutString .. ".json")
    end

end

function has_ladder(ladderName)
    if not Tracker:FindObjectForCode("ladder_shuffle").Active then
        return true
    end

    return Tracker:FindObjectForCode(ladderName).Active
end

function has_enemy_soul(soulName)
    if not Tracker:FindObjectForCode("shuffle_enemy_souls").Active then
        return true
    end

    return Tracker:FindObjectForCode(soulName).Active
end

function enemy_drops()
    return Tracker:FindObjectForCode("shuffle_enemy_drops").CurrentState > 0
end

function extra_enemy()
    return Tracker:FindObjectForCode("shuffle_enemy_drops").CurrentState == 2
end

function is_fs()
    return Tracker:FindObjectForCode("fuse_shuffle").Active == true
end

function not_fs()
    return Tracker:FindObjectForCode("fuse_shuffle").Active == false
end

function is_not_bells()
    return Tracker:FindObjectForCode("bell_shuffle").Active == false
end

function can_ls()
    return Tracker:ProviderCountForCode("ls_item") > 0 or Tracker:FindObjectForCode("storage_no_items").Active
end

function has_lantern()
    return Tracker:FindObjectForCode("light").Active or Tracker:FindObjectForCode("lanternless").Active
end

function has_mask()
    return Tracker:FindObjectForCode("mask").Active or Tracker:FindObjectForCode("maskless").Active
end

function has_hex_goal_amount()
    if HEXGOAL ~= nil and HEXGOAL ~= 0 then
        return Tracker:ProviderCountForCode("hexquest") >= HEXGOAL
    end
    return false
end

function is_hexquest_on()
    return Tracker:FindObjectForCode("hexagonquest").Active
end


ScriptHost:AddWatchForCode("ladderLayout", "ladder_shuffle", updateLayout)
ScriptHost:AddWatchForCode("fuseLayout", "fuse_shuffle", updateLayout)
ScriptHost:AddWatchForCode("enemyLayout", "shuffle_enemy_drops", updateLayout)
ScriptHost:AddWatchForCode("soulsLayout", "shuffle_enemy_souls", updateLayout)
ScriptHost:AddWatchForCode("hintsLayout", "show_hints", updateLayout)
