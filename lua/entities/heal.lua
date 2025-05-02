AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Heal"
ENT.Category = "Grimoire"
ENT.Author = "Remigius"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.UseDelay = true

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/legion_ran/pylon/pylon.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

if SERVER then
	function ENT:OnTakeDamage()
		return false
	end 

	function ENT:AcceptInput( Name, Activator, Caller )
		if self.UseDelay then
			if Name == "Use" and Caller:IsPlayer() then
				self.UseDelay = false
				timer.Simple(5, function() self.UseDelay = true end)
				Caller:SetHealth( math.max( Caller:Health(), Caller:GetMaxHealth() ) )
				Caller:PrintMessage( HUD_PRINTTALK, " Vous êtes désormais en bonne santé! ")
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end