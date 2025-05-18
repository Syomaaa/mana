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
    local res = skill or 0  -- Garantit que res n'est jamais nil

    -- Valeurs par défaut au cas où Mana.Config.SkillStep est nil
    local step1 = (Mana.Config.SkillStep and Mana.Config.SkillStep[1]) or 100
    local step2 = (Mana.Config.SkillStep and Mana.Config.SkillStep[2]) or 200

    for k = 0, res do
        if (k < step1) then
            res = res + a
        elseif (k < step2) then
            res = res + b
        else
            res = res + c
        end
    end

    return res
end

function plyMeta:GetManaResistance(x)
    return math.Clamp(manaValue(x or (self:GetManaStats("Resistance") or 0)/10, 0, 0, 0), 0, 50)
end

function plyMeta:GetManaDamage(x)
    return math.Clamp(manaValue(x or (self:GetManaStats("Damage") or 0)/4, 0, 0, 0), 0, 100)
end

function plyMeta:GetManaHealth(x)
    -- Changé de "Health" à "Vitality" pour correspondre à la structure des données
    return manaValue(x or (self:GetManaStats("Health") or 0)*4, 0, 0, 0)
end

function plyMeta:GetManaSpeed(x)
    return manaValue(x or (self:GetManaStats("Speed") or 0)*.8, 0, 0, 0)
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