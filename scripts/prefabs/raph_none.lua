local assets =
{
	Asset( "ANIM", "anim/raph.zip" ),
	Asset( "ANIM", "anim/ghost_raph_build.zip" ),
}

local skins =
{
	normal_skin = "raph",
	ghost_skin = "ghost_raph_build",
}

local base_prefab = "raph"

local tags = {"RAPH", "CHARACTER"}

return CreatePrefabSkin("raph_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})