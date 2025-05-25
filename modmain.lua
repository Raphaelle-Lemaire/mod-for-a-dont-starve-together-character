PrefabFiles = {
	"raph",
	"raph_none",
	"shadow_invoker",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/raph.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/raph.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/raph.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/raph.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/raph_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/raph_silho.xml" ),

    Asset( "IMAGE", "bigportraits/raph.tex" ),
    Asset( "ATLAS", "bigportraits/raph.xml" ),
	
	Asset( "IMAGE", "images/map_icons/raph.tex" ),
	Asset( "ATLAS", "images/map_icons/raph.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_raph.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_raph.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_raph.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_raph.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_raph.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_raph.xml" ),
	
	Asset( "IMAGE", "images/names_raph.tex" ),
    Asset( "ATLAS", "images/names_raph.xml" ),
	
    Asset( "IMAGE", "bigportraits/raph_none.tex" ),
    Asset( "ATLAS", "bigportraits/raph_none.xml" ),

    Asset("IMAGE", "images/inventoryimages/shadow_invoker.tex"),
    Asset("ATLAS", "images/inventoryimages/shadow_invoker.xml"),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.raph = "The Sample Character"
STRINGS.CHARACTER_NAMES.raph = "Raph"
STRINGS.CHARACTER_DESCRIPTIONS.raph = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.raph = "\"Quote\""

-- Custom speech strings
STRINGS.CHARACTERS.RAPH = require "speech_raph"

-- The character's name as appears in-game 
STRINGS.NAMES.RAPH = "Raph"

AddMinimapAtlas("images/map_icons/raph.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("raph", "FEMALE")

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

AddRecipe2("shadow_invoker",
    {
        Ingredient("twigs", 2),
        Ingredient("cutgrass", 2),
        Ingredient("nightmarefuel", 2)
    },
    TECH.NONE, 
    {
        builder_tag = "shadowmagicuser",
        atlas = "images/inventoryimages/shadow_invoker.xml",
        image = "shadow_invoker.tex",
        product = "shadow_invoker",
        nounlock = true,
        no_deconstruction = true,
        allow_deploy = true,
    },
    { "TOOLS" }
)

local function DrainSanityByPercent(doer, percent)
    if doer and doer.components and doer.components.sanity then
        if doer.components.sanity:GetPercent() > percent then
            local sanity = doer.components.sanity
            local amount = percent * sanity.max
            sanity:DoDelta(-amount)
            return true
        else
            if doer.components.talker then
                doer.components.talker:Say("Je ne me sens pas assez bien pour utiliser ça.")
            end
            return false
        end
    end
end

local function OnUseShadowInvoker(act)
    local doer = act.doer
    if doer then
        if DrainSanityByPercent(doer, 0.25) then
            if doer.components.talker then
                doer.components.talker:Say("Je sens que je perd pied...")
            end
        end
    end
    return true
end

local USESHADOWINVOKER = GLOBAL.Action({priority=5, mount_valid=true})
USESHADOWINVOKER.id = "USESHADOWINVOKER"
USESHADOWINVOKER.str = "Invoke Shadow Power"
USESHADOWINVOKER.fn = OnUseShadowInvoker

AddAction(USESHADOWINVOKER)

local function AddShadowInvokerAction(inst, doer, actions, right)
    if doer:HasTag("player") and inst.prefab == "shadow_invoker" then
        print("[DEBUG] AddShadowInvokerAction called for prefab:", inst.prefab)
        table.insert(actions, GLOBAL.ACTIONS.USESHADOWINVOKER)
        print("[DEBUG] USESHADOWINVOKER action added")
    end
end

AddComponentAction("INVENTORY", "inventoryitem", AddShadowInvokerAction)

-- Handler pour l'action dans le stategraph (pour "wilson" par exemple)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.USESHADOWINVOKER, "doshortaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.USESHADOWINVOKER, "doshortaction"))