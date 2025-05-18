AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = ""
ENT.Author = ""
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false

--------------------
-- Spawn Function --
--------------------
function ENT:SpawnFunction(ply, tr)
    if (not tr.Hit) then return end
    local SpawnPos = tr.HitPos + tr.HitNormal * 25
    local ent = ents.Create(classname)
    ent:SetPos(SpawnPos)
    ent:Spawn()
    ent:Activate()

    if ShouldSetOwner then
        ent.Owner = ply
    end

    return ent
end

----------------
-- Initialize --
----------------
function ENT:Initialize()
    self:SetModel(models/vaelyn/Man_14.mdl)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

-----------------
-- Take Damage -- 
-----------------
function ENT:OnTakeDamage(dmginfo)
    self:TakePhysicsDamage(dmginfo)
end

------------
-- On use --
------------
function ENT:Use(activator, caller)
end

-----------
-- Think --
-----------
function ENT:Think()
end

-----------
-- Touch --
-----------
function ENT:Touch(ent)
end

--------------------
-- PhysicsCollide -- 
--------------------
function ENT:PhysicsCollide(data, physobj)
end

function ENT:Draw()
    self:DrawModel()
end