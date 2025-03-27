function Mana:Log(txt)
    MsgC(Color(25, 25, 200), "[MANA] ", color_white, txt)
end

local plyMeta = FindMetaTable("Player")

function plyMeta:GetManaStats(id)
    if (id) then
        return (self._manaStats or {})[id] or 0
    else
        return self._manaStats or {}
    end
end

function plyMeta:GetMaxMana()
    return self:GetNWInt("MaxMana", 0)
end

function plyMeta:GetManaMagic()
    return self:GetNWString("ManaMagic", "")
end

function plyMeta:GetManaSkillPoints()
    local max = math.floor(self:GetMaxMana() / Mana.Config.ManaPerSkill)

    for k, v in pairs(self._manaStats or {}) do
        max = max - v
    end

    max = max + self:GetManaStatsGiven()

    return max
end

local function manaValue(skill, a, b, c)
    local res = skill

    for k = 0, res do
        if (k < Mana.Config.SkillStep[1]) then
            res = res + a
        elseif (k < Mana.Config.SkillStep[2]) then
            res = res + b
        else
            res = res + c
        end
    end

    return res
end

function plyMeta:GetManaResistance(x)
    return math.Clamp(manaValue(x or self:GetManaStats("Resistance")/10, 0, 0, 0), 0, 50)
end

function plyMeta:GetManaDamage(x)
    return math.Clamp(manaValue(x or self:GetManaStats("Damage")/4, 0, 0, 0), 0, 100)
end

function plyMeta:GetManaHealth(x)
    return manaValue(x or self:GetManaStats("Health")*4, 0, 0, 0)
end

function plyMeta:GetManaSpeed(x)
    return manaValue(x or self:GetManaStats("Speed")*.8, 0, 0, 0)
end

function plyMeta:GetMana()
    return self:GetNWInt("Mana", 0)
end

function plyMeta:AddMana(x)
    self:SetNWInt("Mana", math.Clamp(self:GetMana() + x, 0, self:GetMaxMana()))
    hook.Run("OnManaChange", self, x, self:GetMana())
end

function plyMeta:GetManaResets()
    return self:GetNWInt("ManaResets", 0)
end

function plyMeta:GetManaRerolls()
    return self:GetNWInt("ManaRerolls", 0)
end

function plyMeta:GetManaStatsGiven()
    return self:GetNWInt("ManaStatsGiven", 0)
end