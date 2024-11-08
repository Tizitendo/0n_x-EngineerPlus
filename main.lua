log.info("Successfully loaded " .. _ENV["!guid"] .. ".")
mods.on_all_mods_loaded(function()
    for _, m in pairs(mods) do
        if type(m) == "table" and m.RoRR_Modding_Toolkit then
            for _, c in ipairs(m.Classes) do
                if m[c] then
                    _G[c] = m[c]
                end
            end
        end
    end
end)

local Engineer = nil
local player = nil

__initialize = function()
    Engineer = Survivor.find("ror-engineer")
    
    Engineer:onInit(function(self)
        player = Player.get_client()
    end)
end
if hotload then
    __initialize()
end
hotload = true

gm.pre_script_hook(gm.constants.damager_attack_process, function(self, other, result, args)
    if args[1].value.parent == player.value and args[1].value.hit_effect == 1632.0 and args[1].value.knockback == 10 then
        args[1].value.stun = 1
        if args[1].value.x > player.value.x then
            args[1].value.knockback_direction = 1
        else
            args[1].value.knockback_direction = -1
        end
    end
end)

gm.post_script_hook(gm.constants.instance_create_depth, function(self, other, result, args)
    if result.value.object_index == gm.constants.oActorTargetPlayer then
        agro = result.value
        local function myFunc()
            if agro.parent ~= nil and agro.parent.object_name == "oEngiTurretB" then
                Instance.destroy(agro)
            end
        end
        Alarm.create(myFunc, 360)
    end
end)
