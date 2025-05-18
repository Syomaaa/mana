AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()

	self:SetModel(Mana.Config.NpcModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX) 
	self:SetUseType(SIMPLE_USE) 
	self:DropToFloor()
	self:CapabilitiesAdd(CAP_ANIMATEDFACE) 
	self:CapabilitiesAdd(CAP_TURN_HEAD)

end

function ENT:AcceptInput( inputType, ply )   

	if not IsValid(ply) then return end

    if inputType == "Use" and ply:IsPlayer() then

		if ply.MagicNpcCooldown and CurTime() < ply.MagicNpcCooldown then
            if DarkRP then
                DarkRP.notify( ply, 0, 2, "Patientez..." )
			end
			return
		end
		
		net.Start("Mana:OpenBookShelve")
    	net.Send(ply)

		ply.MagicNpcCooldown = CurTime() + 0.5

   end

end

function ENT:PhysgunPickup( ply )

	return (ply:IsSuperAdmin() or ply:IsAdmin())
	
end