log.info("Successfully loaded " .. _ENV["!guid"] .. ".")
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto()

local Engineer = nil
local player = nil
local Turret = nil

Initialize(function()
    Engineer = Survivor.find("ror-engineer")

    Callback.add("onPlayerInit", "EngineerPlus-onPlayerInit", function()
        player = Player.get_client()
    end)
end)

gm.pre_script_hook(gm.constants.damager_attack_process, function(self, other, result, args)
    if player.name == "Engineer" then
        if args[1].value.parent == player.value and args[1].value.hit_effect == 1632.0 and args[1].value.knockback == 10 then
            if args[1].value.stun < 0.5 then
                args[1].value.stun = 0.5
            end

            -- change knockback to always be away from turret/player
            if Turret ~= nil and Instance.exists(Turret) then
                if args[1].value.x > Turret.x then
                    args[1].value.knockback_direction = 1
                else
                    args[1].value.knockback_direction = -1
                end
            else
                if args[1].value.x > player.value.x then
                    args[1].value.knockback_direction = 1
                else
                    args[1].value.knockback_direction = -1
                end
            end
        end
    end
end)

gm.post_script_hook(gm.constants.instance_create_depth, function(self, other, result, args)
    -- get turret object
    if result.value.object_index == gm.constants.oEngiTurretB then
        Turret = result.value
    end

    -- destroys the turret target after 6 seconds
    if result.value.object_index == gm.constants.oActorTargetPlayer then
        local target = Instance.find_all(Object.find("ror-ActorTargetPlayer"))
        local function destroytarget()
            for k, v in pairs(target) do
                if v.value.parent ~= nil and v.value.parent.object_name == "oEngiTurretB" then
                    v:destroy()
                end
            end
        end
        Alarm.create(destroytarget, 360)
    end
end)
