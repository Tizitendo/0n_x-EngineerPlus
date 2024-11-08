log.info("Successfully loaded " .. _ENV["!guid"] .. ".")
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto()

local Engineer = nil
local player = nil
local Turret = nil

Initialize(function()
    Engineer = Survivor.find("ror-engineer")
    
    Engineer:onInit(function(self)
        player = Player.get_client()
    end)
end)

gm.pre_script_hook(gm.constants.damager_attack_process, function(self, other, result, args)
    if args[1].value.parent == player.value and args[1].value.hit_effect == 1632.0 and args[1].value.knockback == 10 then
        args[1].value.stun = 1
        if Turret ~= nil and Instance.exists(Turret) then
            if args[1].value.x > Turret.x then
                args[1].value.knockback_direction = 1
                log.warning("right")
            else
                args[1].value.knockback_direction = -1
                log.warning("left")
            end
        else
            if args[1].value.x > player.value.x then
                args[1].value.knockback_direction = 1
            else
                args[1].value.knockback_direction = -1
            end
        end
    end
end)

gm.post_script_hook(gm.constants.instance_create_depth, function(self, other, result, args)
    if result.value.object_index == gm.constants.oEngiTurretB then
        Turret = result.value 
    end
    if result.value.object_index == gm.constants.oActorTargetPlayer then
        local target, bool = Instance.find_all(Object.find("ror-ActorTargetPlayer"))
        for k, v in pairs(target) do
            
            local function destroytarget()
                Helper.log_struct(n.value)
                if v.value.parent ~= nil and v.value.parent.object_name == "oEngiTurretB" then
                    v:destroy()
                end
            end
            Alarm.create(test, 360)
        end
    end
end)
