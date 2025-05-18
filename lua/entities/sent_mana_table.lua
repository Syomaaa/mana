AddCSLuaFile()

-- Création de la police personnalisée style Black Clover
if CLIENT then
    surface.CreateFont("BlackCloverFont", {
        font = "Arial", 
        size = 60,
        weight = 800,
        antialias = true,
        shadow = true,
        outline = true
    })
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Grimoire Magique"
ENT.Category = "Mana"
ENT.Author = "Remigius"
ENT.Spawnable = true
ENT.AdminSpawnable = false

--------------------
-- Spawn Function --
--------------------
function ENT:SpawnFunction(ply, tr, classname)
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
    self:SetModel("models/bookshelf4.mdl")
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()

        if (phys:IsValid()) then
            phys:Wake()
        end
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
    net.Start("Mana:OpenBookShelve")
    net.Send(activator)
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
    
    -- Rendu du texte 3D
    local pos = self:GetPos() + Vector(0, 0, 80) -- Positionne le texte au-dessus de l'entité
    
    -- Dessine le texte toujours face au joueur
    cam.Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
        -- Effet d'ombre pour faire ressortir le texte
        draw.SimpleText("Reroll", "BlackCloverFont", 2, 2, Color(0, 0, 0, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        -- Texte principal en blanc
        draw.SimpleText("Reroll", "BlackCloverFont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end