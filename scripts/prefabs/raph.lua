
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- Custom starting items
local start_inv = {
	"shadow_invoker",
	"nightmarefuel",
    "nightmarefuel",
}

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when reviving from ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "raph_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "raph_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function OnTemperatureChanged(inst, data)
    if data and data.newtemperature then
        local temp = data.newtemperature

        if temp < 0 then
            -- Immunité au froid
            inst.components.health.externalmodifiers:SetModifier("cold_immunity", 0)
        elseif temp > 25 then
            -- Malus chaleur doublé
            local heat_penalty = -(temp - 25) * 0.08  -- double du coeff précédent
            inst.components.health.externalmodifiers:SetModifier("heat_multiplier", heat_penalty)
        else
            -- Pas de modificateur hors extrêmes
            inst.components.health.externalmodifiers:SetModifier("cold_immunity", 0)
            inst.components.health.externalmodifiers:SetModifier("heat_multiplier", 0)
        end
    end
end

local function sanity_aura_fn(inst, observer)
    if inst.components.sanity.current > (inst.components.sanity.max * 0.5) then
        return 0.1  -- valeur d'augmentation de sanity par seconde pour les autres
    else
        return 0
    end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "raph.tex" )
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wendy"
	inst:AddTag("shadowmagicuser")
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	-- Damage multiplier (optional)
	inst.components.hunger.hungerrate = 0.7 * TUNING.WILSON_HUNGER_RATE
	inst.components.sanity.night_drain_mult = 1.2
	inst.components.health :StartRegen(1, 30)
	inst.components.sanity.dapperness = 1.2
	inst.components.combat.damagemultiplier = 0.6
	inst.components.locomotor.runspeed = 8

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = sanity_aura_fn

	inst:ListenForEvent("temperaturedeltachanged", OnTemperatureChanged)

	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload

end

return MakePlayerCharacter("raph", prefabs, assets, common_postinit, master_postinit, start_inv)
