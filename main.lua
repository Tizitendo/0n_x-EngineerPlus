log.info("Successfully loaded " .. _ENV["!guid"] .. ".")
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto(true)

Initialize(function()
    gm.pre_script_hook(gm.constants.damager_attack_process, function(self, other, result, args)
        if type(args[1].value.parent) ~= "number" and args[1].value.parent.player_p_number ~= nil and args[1].value.hit_effect == 1632.0 and args[1].value.knockback == 10 then
            local targets = Instance.find_all(Object.find("ror", "ActorTargetPlayer"))
            local minDistance = (args[1].value.x - targets[1].x)^2 + (args[1].value.y - targets[1].y)^2
            local closestTarget = targets[1]
            for i = 2, #targets do
                local Distance = (args[1].value.x - targets[i].x)^2 + (args[1].value.y - targets[i].y)^2
                if minDistance > Distance then
                    minDistance = Distance
                    closestTarget = targets[i]
                end
            end
            if args[1].value.x > closestTarget.x then
                args[1].value.knockback_direction = 1
            else
                args[1].value.knockback_direction = -1
            end
        end
    end)
end)

gm.post_script_hook(gm.constants.instance_create_depth, function(self, other, result, args)
    -- destroys the turret target after 6 seconds
    local function WaitForInit(result)
        if result.object_index == gm.constants.oActorTargetPlayer and result.parent ~= nil and result.parent.object_index == gm.constants.oEngiTurretB then
            local function destroytarget(target)
                if target ~= nil and target.parent ~= nil and target.parent.object_index == gm.constants.oEngiTurretB then
                    Instance.wrap(target):destroy()
                end
            end
            Alarm.create(destroytarget, 360, result)
        end
    end
    Alarm.create(WaitForInit, 1, result.value)
end)
