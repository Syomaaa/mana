--[[
    hooks:

    OnManaChange - ply, amount, totalmana
    OnManaIncreased - ply, amount, totalmaxmana
    OnManaAdjustStats - ply
    OnManaDouble - ply, duration
]]
--
local plyMeta = FindMetaTable("Player")

function plyMeta:InitializeMana(data)
    local steamid = self:SteamID64()
    if not data.maxmana then
        Mana.SQL:Query("INSERT INTO muramana (steamid, mana, maxmana, doublemana, resets, stats) VALUES('" .. self:SteamID64() .. "'," .. self:GetMana() .. ", " .. self:GetMaxMana() .. ", false, 0, '[]');")
    end

    self:SetNWInt("MaxMana", data.maxmana or 0)
    self:SetNWInt("Mana", data.mana or 0)
    self:SetNWInt("ManaResets", data.resets or 0)
    self:SetNWInt("ManaRerolls", data.rerolls or 0)
    self:SetNWInt("ManaStatsGiven", data.statsgive or 0)
    self:SetNWString("ManaMagic", data.magicset or "")
    local double = (data.double or 0) == 1

    if (double) then
        local stamp = data.double_stamp - os.time()

        if (stamp < 0) then
            double = false
        else
            timer.Simple(stamp, function()
                if IsValid(self) and self:GetNWBool("DoubleMana") then
                    self:SetNWBool("DoubleManage", false)
                    Mana.SQL:Query("UPDATE muramana SET double_stamp=0, double=0 WHERE steamid='" .. self:SteamID64() .. "'")
                end
            end)
        end
    end

    if not data.stats then
    
        data.stats = {
            Damage = 0,
            Speed = 0,
            Resistance = 0,
            Vitality = 0
        }

        local stats = util.TableToJSON(data.stats)
        local checkExist = "SELECT * FROM muramana WHERE steamid='"..steamid.."';"
        local update = "UPDATE muramana SET mana=0, maxmana=0, doublemana=0, resets=0, rerolls=0, double_stamp=0, stats='"..stats.."' WHERE steamid='"..steamid.."';"
        local insert = "INSERT INTO muramana (steamid, mana, maxmana, doublemana, resets, rerolls, double_stamp, stats) VALUES('"..steamid.."', 0, 0, 0, 0, 0, 0, '"..stats.."');"

        Mana.SQL:Query(
            checkExist, 
            function(res) 
                if res and #res >= 0 then
                    Mana.SQL:Query(update)
                else
                    Mana.SQL:Query(insert)
                end
            end 
        )

        --YAM FIX : Cette requête était tout simplement mal foutue dans le sens ou l'insertion tombée en erreur dans le cas d'une clé primaire déjà existante, quand même ... j'ai ajouté la vérification
        -- Mana.SQL:Query("INSERT INTO muramana (steamid, mana, maxmana, doublemana, resets, rerolls, double_stamp, stats) VALUES('" .. self:SteamID64() .. "', 0, 0, 0, 0, 0, 0, '" .. util.TableToJSON(data.stats) .. "');")
    end

    self._manaStats = istable(data.stats) and data.stats or util.JSONToTable(data.stats)
    self:SetNWBool("DoubleMana", double)
    net.Start("Mana:BroadcastStats")
    net.WriteTable(self._manaStats)
    net.Send(self)
    self:SetupManaStats()

    if (self:GetMaxMana() ~= 0) then
        self:SetupManaTimer()
        self:LoadManaWeapons()
    end
end

function plyMeta:InitializeMagic(ply)
    for k, v in pairs(self.manaWeapons or {}) do
        self:StripWeapon(k)
    end

    ply:PrintMessage(3, "Grimoire obtenu: " .. self:GetManaMagic())
    print(ply:GetName() .. " obtient le grimoire " .. self:GetManaMagic())

    self:LoadManaWeapons()
end

function plyMeta:LoadManaWeapons()
    local magic = Mana.Config.Magic[self:GetManaMagic()]
    
    if magic.Spells ~= nil then
	    for k, v in pairs(magic.Spells) do
	        if (not self:HasWeapon(v.WeaponClass) and self:GetMaxMana() >= v.ManaRequired) then
	            self:Give(v.WeaponClass)

	            if (not self.manaWeapons) then
	                self.manaWeapons = {}
	            end

	            self.manaWeapons[v.WeaponClass] = true
	        end
	    end
	end
end

function plyMeta:SetRegenerationRate(x)
    self:SetNWFloat("Mana.Regeneration", x)
end

function plyMeta:GiveManaResets(x)
    self:SetNWInt("ManaResets", self:GetManaResets() + x)
    self:SaveMana()
end

function plyMeta:SetupManaTimer()
    local interval = 300  -- Valeur par défaut (5 minutes) au cas où

    -- Vérifier si la configuration existe avant d'itérer
    if Mana.Config and Mana.Config.OverTimeGain then
        for mana, secs in pairs(Mana.Config.OverTimeGain) do
            if(self:GetMaxMana() > mana) then
                interval = secs
            end
        end
    else
        print("[MANA] Warning: OverTimeGain configuration is missing, using default interval")
    end

    net.Start("Mana:NextIncrease")
    net.WriteFloat(CurTime() + interval)
    net.Send(self)

    timer.Create(self:SteamID64() .. "_Mana", interval, 1, function()
        if IsValid(self) then
            self:IncreaseMana(self:GetNWBool("DoubleMana", false) and 2 or 1)
            self:SetupManaTimer()
        end
    end)
end

function plyMeta:IncreaseMana(amount)
    self:SetNWInt("MaxMana", self:GetMaxMana() + amount)
    timer.Remove(self:SteamID64() .. "_Mana")
    self:SetupManaTimer()
    hook.Run("OnManaIncreased", self, amount, self:GetMaxMana())
end

HpJobs = {
    -- Arrivant
    [1] = 250,
    
    -- Habitants
    [2] = 500,  -- Habitant de Clover
    [3] = 500,  -- Habitant de Spade
    [72] = 500, -- Habitant Neutre
    
    -- Métiers
    [4] = 500,  -- Alchimiste
    [5] = 500,  -- Marchand
    [62] = 500, -- Musicien
    [63] = 500, -- Tavernier
    [73] = 500, -- Marchand Neutre
    [76] = 500, -- Forgeron
    
    -- Spade
    [6] = 1000,  -- Guerrier Mage Novice 3ème classe
    [7] = 1500,  -- Guerrier Mage Novice 2ème classe
    [8] = 2000,  -- Guerrier Mage Novice 1ère classe
    [9] = 2500,  -- Guerrier Mage Confirmé
    [10] = 3500, -- Guerrier Mage Supérieur
    [11] = 4000, -- Grand Guerrier Mage
    [12] = 6500, -- Disciple de l'ombre
    [13] = 9000, -- Triades Sombres
    [14] = 9000, -- Conseiller
    [15] = 9000, -- Chef Triade Sombre
    [16] = 3000, -- Garde Royal
    [17] = 3000, -- Chef Garde Royal
    [18] = 2500, -- Prince
    [19] = 2500, -- Princesse
    [20] = 3500, -- Reine
    [21] = 3500, -- Roi
    
    -- Aigle d'Argent (Clover)
    [22] = 1000, -- Chevalier Mage Novice 3ème classe
    [23] = 1500, -- Chevalier Mage Novice 2ème classe
    [24] = 2000, -- Chevalier Mage Novice 1ère classe
    [25] = 2500, -- Chevalier Mage Confirmé
    [26] = 3500, -- Chevalier Mage Supérieur
    [27] = 4000, -- Grand Chevalier Mage
    [28] = 5500, -- Vice Capitaine
    [29] = 7500, -- Capitaine
    
    -- Taureau Noir (Clover)
    [30] = 1000, -- Chevalier Mage Novice 3ème classe
    [31] = 1500, -- Chevalier Mage Novice 2ème classe
    [32] = 2000, -- Chevalier Mage Novice 1ère classe
    [33] = 2500, -- Chevalier Mage Confirmé
    [34] = 3500, -- Chevalier Mage Supérieur
    [35] = 4000, -- Grand Chevalier Mage
    [36] = 5500, -- Vice Capitaine
    [37] = 7500, -- Capitaine
    
    -- Lion Flamboyant (Clover)
    [38] = 1000, -- Chevalier Mage Novice 3ème classe
    [39] = 1500, -- Chevalier Mage Novice 2ème classe
    [40] = 2000, -- Chevalier Mage Novice 1ère classe
    [41] = 2500, -- Chevalier Mage Confirmé
    [42] = 3500, -- Chevalier Mage Supérieur
    [43] = 4000, -- Grand Chevalier Mage
    [44] = 5500, -- Vice Capitaine
    [45] = 7500, -- Capitaine
    
    -- Mante d'Emeraude (Clover)
    [46] = 1000, -- Chevalier Mage Novice 3ème classe
    [47] = 1500, -- Chevalier Mage Novice 2ème classe
    [48] = 2000, -- Chevalier Mage Novice 1ère classe
    [49] = 2500, -- Chevalier Mage Confirmé
    [50] = 3500, -- Chevalier Mage Supérieur
    [51] = 4000, -- Grand Chevalier Mage
    [52] = 5500, -- Vice Capitaine
    [53] = 7500, -- Capitaine
    
    -- Staff
    [54] = 10000, -- Staff en Service
    
    -- Royauté Clover
    [55] = 3000,  -- Garde Royal
    [56] = 3000, -- Chef Garde Royal 
    [57] = 2500, -- Prince
    [58] = 2500, -- Princesse
    [59] = 3500, -- Reine
    [60] = 3500, -- Roi
    
    -- Empereur et Parlement
    [61] = 8000, -- Empereur Mage
    [70] = 2000,  -- President du Parlement Magique
    [71] = 1500,  -- Parlement Magique
    
    -- Noblesse
    [64] = 1100,  -- Baronnet
    [65] = 1200,  -- Baron
    [66] = 1300,  -- Vicomte
    [67] = 1550,  -- Comte
    [68] = 1800,  -- Marquis
    [69] = 2000, -- Duc
    
    -- Familier
    [74] = 500,  -- Familier
    
    -- EVENT
    [75] = 100000, -- Event
    
    -- Bandit
    [77] = 1500, -- Recrue Bandit
    [78] = 3000, -- Bandit
    [79] = 4000, -- Sous Chef Bandit
    [80] = 4500  -- Chef Bandit
}

function plyMeta:SetupManaStats()
    local playerBaseHealth = (HpJobs[self:Team()] or 100)

    self:SetJumpPower(150 + self:GetManaSpeed())
    self:SetRunSpeed(280 + self:GetManaSpeed())
    self:SetWalkSpeed(120)
    self:SetMaxHealth(playerBaseHealth + self:GetManaHealth())

    if self:Health() > playerBaseHealth + self:GetManaHealth()  then
        self:SetHealth(playerBaseHealth + self:GetManaHealth())
    end

    hook.Run("OnManaAdjustStats", self)
end

function plyMeta:SaveMana()
    Mana.SQL:Query("UPDATE muramana SET mana=" .. self:GetMana() .. ", maxmana=" .. self:GetMaxMana() .. ", resets=" .. self:GetManaResets() .. ", stats='" .. util.TableToJSON(self._manaStats or {}) .. "' WHERE steamid='" .. self:SteamID64() .. "';")
end

function plyMeta:LoadMana()
    Mana.SQL:Query("SELECT * FROM muramana WHERE steamid='" .. self:SteamID64() .. "'", function(data)
        local manaData = {}

        if data and data[1] then
            manaData = data[1]
            MsgN("We found mana info")
        else
            MsgN("Mana data not found")
        end
        PrintTable(manaData)
        self:InitializeMana(manaData)
    end)
end

function Mana:SetDouble(ply, duration)
    local expire = os.time() + duration * 60
    local ent = isstring(ply) and player.GetBySteamID64(ply) or nil
    self.SQL:Query("UPDATE muramana SET double_stamp=" .. expire .. ", double=1 WHERE steamid='" .. (isstring(ply) and ply or ply:SteamID64()) .. "'")

    if (IsValid(ent)) then
        ent:SetNWBool("DoubleMana", true)

        timer.Simple(duration * 60, function()
            if (IsValid(ent)) then
                ent:SetNWBool("DoubleMana", false)
                hook.Run("OnManaDouble", ply, 0)
                self.SQL:Query("UPDATE muramana SET double_stamp=0, double=0 WHERE steamid='" .. (isstring(ply) and ply or ply:SteamID64()) .. "'")
            end
        end)

        hook.Run("OnManaDouble", ply, duration)
    end
end

concommand.Add("muramana_setdouble", function(ply, cmd, args)
    if (IsValid(ply)) then return end
    local sid, duration = args[1], (args[2] or 60)
    Mana:SetDouble(sid, duration)
end)

-- Fonction corrigée pour gérer correctement les types
function Mana:AddResets(ply, isreroll, amount)
    local steamID = isstring(ply) and ply or ply:SteamID64()
    local ent = isstring(ply) and player.GetBySteamID64(ply) or ply
    local val = (isreroll and "rerolls" or "resets")

    if (IsValid(ent)) then
        local query = "UPDATE muramana SET " .. val .. "=" .. ((isreroll and ent:GetManaRerolls() or ent:GetManaResets()) + amount) .. " WHERE steamid='" .. ent:SteamID64() .. "'"
        self.SQL:Query(query)
        ent:SetNWInt(isreroll and "ManaRerolls" or "ManaResets", ent:GetNWInt(isreroll and "ManaRerolls" or "ManaResets") + amount)
    else
        self.SQL:Query("UPDATE muramana SET " .. val .. "=" .. val .. " + " .. amount .. " WHERE steamid='" .. steamID .. "'")
    end

    hook.Run("OnRerollsUpdate", steamID, isreroll, amount)
end

concommand.Add("muramana_addresets", function(ply, cmd, args)
    if (IsValid(ply)) then return end
    local sid, isreroll, amount = args[1], tonumber(args[2] or 0) == 1, tonumber(args[3] or 1)
    Mana:AddResets(sid, isreroll, amount)
end)

function Mana:AddStats(ply, reset, amount)
    local ent = isstring(ply) and player.GetBySteamID64(ply) or ply
    if (IsValid(ent)) then
        local amt = (reset == 0 and (ent:GetManaStatsGiven() + amount)) or 0
        local query = "UPDATE muramana SET statsgive=" ..amt.. " WHERE steamid='" .. ent:SteamID64() .. "'"
        self.SQL:Query(query)
        ent:SetNWInt("ManaStatsGiven", amt)
    else
        if reset == 0 then
            self.SQL:Query("UPDATE muramana SET statsgive = statsgive + " .. amount .. " WHERE steamid='" .. ply .. "'")
        else
            self.SQL:Query("UPDATE muramana SET statsgive = 0 WHERE steamid='" .. ply .. "'")
        end
    end

    hook.Run("OnStatsUpdate", ply, amount)
end

concommand.Add("muramana_increasestats", function(ply, cmd, args)
    if (IsValid(ply)) then return end
    local sid, reset, amount = args[1], tonumber(args[2] or 0), tonumber(args[3] or 1)
    Mana:AddStats(sid, reset, amount)
end)

function Mana:IncreaseMana(ply, amount)
    local steamID = isstring(ply) and ply or ply:SteamID64()
    local ent = isstring(ply) and player.GetBySteamID64(ply) or ply

    if (IsValid(ent)) then
        local query = "UPDATE muramana SET maxmana=maxmana + " .. amount .. " WHERE steamid='" .. ent:SteamID64() .. "'"
        self.SQL:Query(query)
        ent:IncreaseMana(amount)
    else
        self.SQL:Query("UPDATE muramana SET maxmana=maxmana + " .. amount .. " WHERE steamid='" .. steamID .. "'")
    end
end

concommand.Add("muramana_increasemana", function(ply, cmd, args)
    if (IsValid(ply)) then return end
    local sid, amount = args[1], tonumber(args[2] or 100)
    Mana:IncreaseMana(sid, amount)
end)

function Mana:GetManaInfos(ply, admin)
    if not IsValid(admin) then return end

    local steamID = isstring(ply) and ply or ply:SteamID64()

    self.SQL:Query("SELECT * FROM muramana WHERE steamid='" .. steamID .. "'", function(result) 
        --on success
        if result and type(result) == "table" then
            local infos = #result > 0
            net.Start("Mana:BroadcastManaInfos")
            net.WriteBool(infos)
            if infos then
                net.WriteTable(result)
            end
            net.Send(admin)
        end
    end)
end

-- Fonction corrigée pour retirer des rerolls à un joueur
function Mana:RemoveRerolls(ply, amount)
    local steamID = isstring(ply) and ply or ply:SteamID64()
    local ent = isstring(ply) and player.GetBySteamID64(ply) or ply
    
    if (IsValid(ent)) then
        local newAmount = math.max(0, ent:GetManaRerolls() - amount)
        local query = "UPDATE muramana SET rerolls=" .. newAmount .. " WHERE steamid='" .. ent:SteamID64() .. "'"
        self.SQL:Query(query)
        ent:SetNWInt("ManaRerolls", newAmount)
    else
        self.SQL:Query("UPDATE muramana SET rerolls=GREATEST(0, rerolls-" .. amount .. ") WHERE steamid='" .. steamID .. "'")
    end
    
    hook.Run("OnRerollsUpdate", steamID, true, -amount)
end

-- Fonction corrigée pour donner des rerolls à tous les joueurs
function Mana:GiveRerollsToAll(amount)
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) then
            -- Mise à jour manuelle au lieu d'appeler AddResets
            local currentRerolls = ply:GetManaRerolls()
            ply:SetNWInt("ManaRerolls", currentRerolls + amount)
            
            -- Mise à jour de la base de données
            local steamID = ply:SteamID64()
            self.SQL:Query("UPDATE muramana SET rerolls=" .. (currentRerolls + amount) .. " WHERE steamid='" .. steamID .. "'")
            
            -- Exécution du hook avec le SteamID comme chaîne
            hook.Run("OnRerollsUpdate", steamID, true, amount)
        end
    end
end

-- Fonction corrigée pour augmenter le mana maximum de tous les joueurs
function Mana:IncreaseManaForAll(amount)
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) then
            -- Utiliser IncreaseMana directement sur la cible
            ply:IncreaseMana(amount)
            
            -- Mise à jour de la base de données
            local steamID = ply:SteamID64()
            self.SQL:Query("UPDATE muramana SET maxmana=maxmana + " .. amount .. " WHERE steamid='" .. steamID .. "'")
        end
    end
end

-- Fonction corrigée pour donner des resets à tous les joueurs
function Mana:GiveResetsToAll(amount)
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) then
            -- Mise à jour manuelle au lieu d'appeler AddResets
            local currentResets = ply:GetManaResets()
            ply:SetNWInt("ManaResets", currentResets + amount)
            
            -- Mise à jour de la base de données
            local steamID = ply:SteamID64()
            self.SQL:Query("UPDATE muramana SET resets=" .. (currentResets + amount) .. " WHERE steamid='" .. steamID .. "'")
            
            -- Exécution du hook avec le SteamID comme chaîne
            hook.Run("OnRerollsUpdate", steamID, false, amount)
        end
    end
end

hook.Add("PlayerInitialSpawn", "Mana.ReadDB", function(ply)
    ply:LoadMana()
    ply:SelectWeapon( "Avis" )
end)

hook.Add("PlayerSpawn", "Mana.AssignWeapon", function(ply)
    if (ply:GetMaxMana() > 0) then
        timer.Simple(1, function()
            ply:LoadManaWeapons()
            ply:SetupManaStats()
            ply:SetHealth(ply:GetMaxHealth())
        end)
    end
end)

hook.Add("PlayerDeath", "Mana.Restart", function(ply)
    ply:SetNWInt("Mana", 0)
    timer.Simple(1, function()
        ply:Spawn()
    end)
end)

hook.Add("EntityTakeDamage", "Mana.ResolveDamage", function(ent, dmg)
    if (dmg:GetAttacker():IsPlayer()) then
        local damage = dmg:GetDamage()
        local dmgReduction = ent:IsPlayer() and (1 - ent:GetManaResistance() / 100) or 1

        dmg:SetDamage(damage * dmgReduction + damage * (dmg:GetAttacker():GetManaDamage() / 100))
    elseif (ent:IsPlayer()) then
        local dmgReduction = (1 - ent:GetManaResistance() / 100)
        dmg:SetDamage(dmg:GetDamage() * dmgReduction)
    end
end)

hook.Add("PlayerDisconnected", "Mana.WriteDB", function(ply)
    ply:SaveMana()
end)

hook.Add("PlayerSwitchWeapon", "Mana.SetWeaponizer", function(ply, old, new)
    if (ply:GetMaxMana() > 0) then
        local magic = ply:GetManaMagic()

        if (ply.magicWeapon and IsValid(old) and old:GetClass() == ply.magicWeapon) then
            ply.magicCost = nil
            ply.magicWeapon = nil
        end

        if (magic and Mana.Config.Magic[magic]) then
            local result = true

            for k, v in pairs(Mana.Config.Magic[magic].Spells) do
                if (new:GetClass() == v.WeaponClass) then
                    if (ply:GetMana() < v.Cost) then
                        result = false
                        break
                    end

                    ply.magicCost = v.Cost
                    ply.magicWeapon = v.WeaponClass
                end
            end

            if (not result) then
                ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de mana pour utiliser ce sort !")

                return true
            end
        end
    end
end)

hook.Add("OnManaChange", "Mana.AssignWeapon", function(ply, mana)
    if (ply:GetManaMagic() == "") then return end
    ply:LoadManaWeapons()
end)

local nextTick = 0

hook.Add("PlayerTick", "Mana.Reneration", function(ply)
    if (nextTick > CurTime() or not ply:Alive() or ply:GetMaxMana() == 0 or ply:GetMana() >= ply:GetMaxMana()) then return end

    for k, v in pairs(player.GetAll()) do
        local amount = v:GetMaxMana() * ((Mana.Config.RegenerationPercent * v:GetNWFloat("Mana.Regeneration", 1)) / 100)
        
        if (v.magicCost) then
            amount = -v.magicCost
            if (v:GetMana() <= v.magicCost) then
                v:SelectWeapon(Mana.Config.DefaultWeapon)
                v.magicCost = false
            end
        end

        v:AddMana(amount)
    end

    nextTick = CurTime() + Mana.Config.RenenerationTime
end)

hook.Add("PlayerSay", "Mana.AdminCmd", function(ply, args)
    -- Infos valides ?
    if not IsValid(ply) or not args or args == "" then return end
    
    -- Est-ce que le joueur est considéré comme un administrateur ?
    if not Mana.Config.AdminCmdAccess[ply:GetUserGroup()] then return end
    
    -- Est-ce l'ouverture du panel admin
    if args == "/manaadmin" then
        local sendStats = {}
        for k, v in pairs(player.GetAll()) do
            sendStats[v:SteamID()] = v._manaStats
        end
        net.Start("Mana:AdminPanel")
        net.WriteTable(sendStats)
        net.Send(ply)
        
        return
    end
    
    local argsplit = string.Explode(" ", args)
    -- Pas assez de paramètres, pas besoin d'aller plus loin...
    if not argsplit or #argsplit < 2 then return end
    
    -- On récupère les arguments communs
    local cmd = argsplit[1]
    local sid = argsplit[2]
    
    -- Est-ce que la commande est connue ?
    if cmd == "/manadouble" then
        local duration = argsplit[3] or 60
        Mana:SetDouble(sid, duration)
    elseif cmd == "/manareroll" then
        local isreroll, amount = tonumber(argsplit[3] or 0) == 1, tonumber(argsplit[4] or 1)
        Mana:AddResets(sid, isreroll, amount)
    elseif cmd == "/manaincrease" then
        local amount = tonumber(argsplit[3] or 100)
        Mana:IncreaseMana(sid, amount)
    elseif cmd == "/manastats" then
        local reset, amount = tonumber(argsplit[3] or 0), tonumber(argsplit[4] or 1)
        Mana:AddStats(sid, reset, amount)
    elseif cmd == "/manaremovereroll" then
        local amount = tonumber(argsplit[3] or 1)
        Mana:RemoveRerolls(sid, amount)
    elseif cmd == "/manamassreroll" then
        local amount = tonumber(argsplit[2] or 1) -- Dans ce cas, le 2e paramètre est le montant
        Mana:GiveRerollsToAll(amount)
    elseif cmd == "/manamassmana" then
        local amount = tonumber(argsplit[2] or 100)
        Mana:IncreaseManaForAll(amount)
    elseif cmd == "/manamassreset" then
        local amount = tonumber(argsplit[2] or 1)
        Mana:GiveResetsToAll(amount)
    end
end)

-- Mise à jour du traitement des messages réseau
net.Receive("Mana:GiveManaItems", function(len, ply)
    local mode = net.ReadString()  -- "admin" ou "friend"
    local cmdType = net.ReadString()
    
    if mode == "admin" then
        -- Vérifier si le joueur est administrateur
        if not Mana.Config.AdminCmdAccess[ply:GetUserGroup()] then return end
        
        -- Traitement des commandes administratives
        if cmdType == "cmd" then
            local commandText = net.ReadString()
            local args = string.Explode(" ", commandText)
            
            if #args < 2 then
                ply:ChatPrint("Format de commande incorrect. Utilisez: <commande> <steamid64> <montant>")
                return
            end
            
            local cmd = args[1]
            local targetID = args[2]
            local amount = tonumber(args[3] or "1")
            
            if not amount or amount <= 0 then
                ply:ChatPrint("Montant invalide.")
                return
            end
            
            if cmd == "mana" then
                Mana:IncreaseMana(targetID, amount)
                ply:ChatPrint("Mana max augmenté de " .. amount .. " pour " .. targetID)
            elseif cmd == "reset" then
                Mana:AddResets(targetID, false, amount)
                ply:ChatPrint("Ajout de " .. amount .. " resets pour " .. targetID)
            elseif cmd == "reroll" then
                Mana:AddResets(targetID, true, amount)
                ply:ChatPrint("Ajout de " .. amount .. " rerolls pour " .. targetID)
            elseif cmd == "removereroll" then
                Mana:RemoveRerolls(targetID, amount)
                ply:ChatPrint("Retrait de " .. amount .. " rerolls pour " .. targetID)
            elseif cmd == "stats" then
                Mana:AddStats(targetID, 0, amount)
                ply:ChatPrint("Ajout de " .. amount .. " stats pour " .. targetID)
            elseif cmd == "get" then
                Mana:GetManaInfos(targetID, ply)
            end
        elseif cmdType == "reset" or cmdType == "reroll" or cmdType == "removereroll" or cmdType == "mana" or cmdType == "stats" then
            local amount = net.ReadInt(16)
            local target = net.ReadEntity()
            
            if not IsValid(target) then
                ply:ChatPrint("Joueur cible invalide.")
                return
            end
            
            if cmdType == "reset" then
                Mana:AddResets(target, false, amount)
                ply:ChatPrint("Ajout de " .. amount .. " resets pour " .. target:Nick())
            elseif cmdType == "reroll" then
                Mana:AddResets(target, true, amount)
                ply:ChatPrint("Ajout de " .. amount .. " rerolls pour " .. target:Nick())
            elseif cmdType == "removereroll" then
                Mana:RemoveRerolls(target, amount)
                ply:ChatPrint("Retrait de " .. amount .. " rerolls pour " .. target:Nick())
            elseif cmdType == "mana" then
                Mana:IncreaseMana(target, amount)
                ply:ChatPrint("Mana max augmenté de " .. amount .. " pour " .. target:Nick())
            elseif cmdType == "stats" then
                Mana:AddStats(target, 0, amount)
                ply:ChatPrint("Ajout de " .. amount .. " stats pour " .. target:Nick())
            end
        elseif cmdType == "massreroll" then
            local amount = net.ReadInt(16)
            Mana:GiveRerollsToAll(amount)
            ply:ChatPrint("Ajout de " .. amount .. " rerolls pour tous les joueurs.")
        elseif cmdType == "massmana" then
            local amount = net.ReadInt(16)
            Mana:IncreaseManaForAll(amount)
            ply:ChatPrint("Mana max augmenté de " .. amount .. " pour tous les joueurs.")
        elseif cmdType == "massreset" then
            local amount = net.ReadInt(16)
            Mana:GiveResetsToAll(amount)
            ply:ChatPrint("Ajout de " .. amount .. " resets pour tous les joueurs.")
        end
    elseif mode == "friend" then
        -- Traitement des dons entre amis
        local amount = net.ReadInt(16)
        local target = net.ReadEntity()
        
        if not IsValid(target) or not target:IsPlayer() then return end

        if cmdType == "reset" then
            if not (ply:GetManaResets() >= amount) then return end
            ply:SetNWInt("ManaResets", ply:GetManaResets() - amount)
            target:SetNWInt("ManaResets", target:GetManaResets() + amount)
            Mana.SQL:Query("UPDATE muramana SET resets=" .. ply:GetManaResets() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
            Mana.SQL:Query("UPDATE muramana SET resets=" .. target:GetManaResets() .. " WHERE steamid='" .. target:SteamID64() .. "';")
            DarkRP.notify(ply, 0, 4, "Vous avez donné "..amount.." resets à "..target:Name())
            DarkRP.notify(target, 0, 4, "Vous avez reçu "..amount.." resets de "..ply:Name())
        elseif cmdType == "reroll" then
            if not (ply:GetManaRerolls() >= amount) then return end
            ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - amount)
            target:SetNWInt("ManaRerolls", target:GetManaRerolls() + amount)
            Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
            Mana.SQL:Query("UPDATE muramana SET rerolls=" .. target:GetManaRerolls() .. " WHERE steamid='" .. target:SteamID64() .. "';")
            DarkRP.notify(ply, 0, 4, "Vous avez donné "..amount.." rerolls à "..target:Name())
            DarkRP.notify(target, 0, 4, "Vous avez reçu "..amount.." rerolls de "..ply:Name())
        end
    end
end)

hook.Add("InitPostEntity", "Mana.AutoSave", function()
    timer.Create("MuramanaSave", 60 * 15, 0, function()
        for k, v in pairs(player.GetAll()) do
            v:SaveMana()
        end
    end)
end)