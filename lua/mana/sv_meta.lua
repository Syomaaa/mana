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
    local interval = -1
    for mana, secs in pairs(Mana.Config.OverTimeGain) do
        if(self:GetMaxMana() > mana) then
            interval = secs
        end
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
    
        -- Clover
        [17] = 1000,
        [18] = 1500,
        [19] = 2000,
        [20] = 3000,
        [21] = 3500,
        [22] = 4000,
        [23] = 5500,
        [24] = 7500,
        [25] = 1000,
        [26] = 1500,
        [27] = 2000,
        [28] = 3000,
        [29] = 3500,
        [30] = 4000,
        [31] = 5500,
        [32] = 7500,
        [33] = 1000,
        [34] = 1500,
        [35] = 2000,
        [36] = 3000,
        [37] = 3500,
        [38] = 4000,
        [39] = 5500,
        [40] = 7500,
        [41] = 1000,
        [42] = 1500,
        [43] = 2000,
        [44] = 3000,
        [45] = 3500,
        [46] = 4000,
        [47] = 5500,
        [48] = 7500,
        -- Royaute
        [50] = 3000,
        [51] = 3000,
        [52] = 1000,
        [53] = 1000,
        [54] = 2000,
        [55] = 2000,
        [56] = 6000,
        [57] = 10000,
        -- Spade
       [7] = 1500, 
       [8] = 2000,
       [9] = 2500,
       [10] = 3500,
       [11] = 4000,
       [12] = 4500,
       [13] = 6000,
       [14] = 8000,
       [15] = 6000,
       [16] = 10500,
       -- Noblesse
       [60] = 250,
       [61] = 400,
       [62] = 550,
       [63] = 700,
       [64] = 850,
       [65] = 1000,
       [66] = 2000,
       [67] = 500,
       -- Familier
       [70] = 250,
       -- EVENT
       [71] = 100000,
       -- FORGERON
       [72] = 250,
       -- Bandit
       [73] = 1500,
       [74] = 3000,
       [75] = 4000,
       [76] = 4500,
       -- Habitant
       [2] = 250,
       [3] = 250,
       [4] = 250,
       [5] = 250,
       [6] = 250,
       [58] = 250,
       [59] = 250,
       [68] = 250,
       [69] = 250
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

function Mana:AddResets(ply, isreroll, amount)
    local ent = isstring(ply) and player.GetBySteamID64(ply) or nil
    local val = (isreroll and "rerolls" or "resets")

    if (IsValid(ent)) then
        local query = "UPDATE muramana SET " .. val .. "=" .. ((isreroll and ent:GetManaRerolls() or ent:GetManaResets()) + amount) .. " WHERE steamid='" .. ent:SteamID64() .. "'"
        self.SQL:Query(query)
        ent:SetNWInt(isreroll and "ManaRerolls" or "ManaResets", ent:GetNWInt(isreroll and "ManaRerolls" or "ManaResets") + amount)
    else
        self.SQL:Query("UPDATE muramana SET " .. val .. "=" .. val .. " + " .. amount .. " WHERE steamid='" .. ply .. "'")
    end

    hook.Run("OnRerollsUpdate", ply, isreroll, amount)
end

concommand.Add("muramana_addresets", function(ply, cmd, args)
    if (IsValid(ply)) then return end
    local sid, isreroll, amount = args[1], tonumber(args[2] or 0) == 1, tonumber(args[3] or 1)
    Mana:AddResets(sid, isreroll, amount)
end)

function Mana:AddStats(ply, reset, amount)
    local ent = isstring(ply) and player.GetBySteamID64(ply) or nil
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
    local ent = isstring(ply) and player.GetBySteamID64(ply) or nil

    if (IsValid(ent)) then
        local query = "UPDATE muramana SET maxmana=maxmana + " .. amount .. " WHERE steamid='" .. ent:SteamID64() .. "'"
        self.SQL:Query(query)
        ent:IncreaseMana(amount)
    else
        self.SQL:Query("UPDATE muramana SET maxmana=maxmana + " .. amount .. " WHERE steamid='" .. ply .. "'")
    end

    hook.Run("OnRerollsUpdate", ply, isreroll, amount)
end

concommand.Add("muramana_increasemana", function(ply, cmd, args)
    if (IsValid(ply)) then return end
    local sid, amount = args[1], tonumber(args[2] or 100)
    Mana:IncreaseMana(sid, amount)
end)

function Mana:GetManaInfos(ply, admin)

    if not IsValid(admin) then return end

    local ent = isstring(ply) and player.GetBySteamID64(ply) or nil
    local sid = IsValid(ent) and ent:SteamID64() or ply

    self.SQL:Query("SELECT * FROM muramana WHERE steamid='" .. sid .. "'", function(result) 
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

hook.Add("PlayerSay","Mana.AdminCmd", function( ply, args )

    --infos valides ?
    if not IsValid(ply) or not args or args == "" then return end

    --est-ce que le joueur est considéré comme un administrateur ?
    if not Mana.Config.AdminCmdAccess[ply:GetUserGroup()] then return end

    --est-ce l'ouverture du panel admin
    if args == "/manaadmin" then

        local sendStats = {}
        for k,v in pairs (player.GetAll()) do
            sendStats[v:SteamID()] = v._manaStats
        end
        net.Start("Mana:AdminPanel")
        net.WriteTable(sendStats)
        net.Send(ply)

        return

    end

    local argsplit = string.Explode(" ", args)
    --pas assez de paramètres, pas besoin d'aller plus loin... (toutes les fonctions nécessitent à minima deux arguments "commande" + "steamid", le reste variera)
    if not argsplit or #argsplit < 2 then return end

    --on récupére les arguments communs
    local cmd = argsplit[1]
    local sid = argsplit[2]

    --est-ce que la commande est connue ?
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
    end

end)


hook.Add("InitPostEntity", "Mana.AutoSave", function()
    timer.Create("MuramanaSave", 60 * 15, 0, function()
        for k, v in pairs(player.GetAll()) do
            v:SaveMana()
        end
    end)
end)