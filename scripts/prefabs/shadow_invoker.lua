local assets={   
	Asset("ANIM", "anim/shadow_invoker.zip"),
	Asset("ATLAS", "images/inventoryimages/shadow_invoker.xml"),    
	Asset("IMAGE", "images/inventoryimages/shadow_invoker.tex"),
}

prefabs = {
	--"shadow",
}

local function OnUse(inst, user)
    if user and user.components.sanity then
        local loss = user.components.sanity.max * 0.25
        user.components.sanity:DoDelta(-loss)
        user.components.talker:Say("Je sens mon esprit vaciller...")
    end

end

local function fn()    
	local inst = CreateEntity()    

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()   

	MakeInventoryPhysics(inst) 

	inst.AnimState:SetBank("shadow_invoker")
    inst.AnimState:SetBuild("shadow_invoker")
    inst.AnimState:PlayAnimation("idle")  

    inst:AddTag("shadow_invoker")
    inst:AddTag("useableitem")
    inst:AddTag("shadow_invoker_action")
    --inst:AddTag("nopunch")
    --inst:AddTag("shadow_invoker")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable")


    inst:AddComponent("named")
    inst.components.named:SetName("Invocateur d'Ombre")

    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.imagename = "shadow_invoker"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shadow_invoker.xml"        

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("shadow_invoker", fn, assets)