util.AddNetworkString("Mana:BroadcastStats")
util.AddNetworkString("Mana:BroadcastManaInfos")
util.AddNetworkString("Mana:RequestApplySkill")
util.AddNetworkString("Mana:NextIncrease")
util.AddNetworkString("Mana:RequestReset")
util.AddNetworkString("Mana:RequestPower")
util.AddNetworkString("Mana:OpenBookShelve")
util.AddNetworkString("Mana:GiveManaItems")
util.AddNetworkString("Mana:AdminPanel")

net.Receive("Mana:GiveManaItems", function(l, ply)

    local ptype  = net.ReadString()
    local item   = net.ReadString()

    --don d'un joueur à un autre joueur
    if ptype == "friend" then

        local amt = net.ReadInt(16)
        local target = net.ReadEntity()

        --inutile d'aller plus loin si les informations ne sont pas valides ou si le joueur cible est le joueur emitteur
        if not item or not amt or not target or not IsValid(target) or not target:IsPlayer() or (ply == target) or amt <= 0 then return end

        if item == "reset" and amt <= ply:GetManaResets() then
            Mana:AddResets(ply:SteamID64(), false, -amt)
            Mana:AddResets(target:SteamID64(), false, amt)
        elseif item == "reroll" and amt <= ply:GetManaRerolls() then
            Mana:AddResets(ply:SteamID64(), true, -amt)
            Mana:AddResets(target:SteamID64(), true, amt)
        end

    --action provenant du menu administrateur
    elseif ptype == "admin" and Mana.Config.AdminCmdAccess[ply:GetUserGroup()] then

        local optionsAvailable = {
            ["reset"]  = true,
            ["reroll"] = true,
            ["stats"]  = true,
            ["mana"]   = true,
            ["get"]    = true,
        }

        --action simple depuis un bouton sur un joueur
        if optionsAvailable[item] then

            local amt = net.ReadInt(16)
            local target = net.ReadEntity()

            --verification sur le joueur cible et la validite des infos saisies (montant)
            if not item or not amt or not target or not IsValid(target) or not target:IsPlayer() then return end
            
            if item == "reset" then
                Mana:AddResets(target:SteamID64(), false, amt)
            elseif item == "reroll" then
                Mana:AddResets(target:SteamID64(), true, amt)
            elseif item == "stats" then
                Mana:AddStats(target:SteamID64(), 0, amt)
            elseif item == "mana" then
                Mana:IncreaseMana(target:SteamID64(), amt)
            end

        --action manuelle via le panel de commande manuelle
        elseif item == "cmd" then

            local cmd = net.ReadString()
            local cmdSplit = string.Explode(" ", cmd)
            if not cmdSplit or #cmdSplit < 2 or not optionsAvailable[cmdSplit[1]] then return end

            if cmdSplit[1] == "reset" then
                local sid, isreroll, amount = cmdSplit[2], 0, tonumber(cmdSplit[3] or 1)
                Mana:AddResets(sid, isreroll, amount)
            elseif cmdSplit[1] == "reroll" then
                local sid, isreroll, amount = cmdSplit[2], 1, tonumber(cmdSplit[3] or 1)
                Mana:AddResets(sid, isreroll, amount)
            elseif cmdSplit[1] == "stats" then
                local sid, reset, amount = cmdSplit[2], 0, tonumber(cmdSplit[3] or 1)
                Mana:AddStats(sid, reset, amount)
            elseif cmdSplit[1] == "mana" then
                local sid, amount = cmdSplit[2], tonumber(cmdSplit[3] or 1)
                Mana:IncreaseMana(sid, amount)
            elseif cmdSplit[1] == "get" then
                Mana:GetManaInfos(cmdSplit[2], ply)
            end

        end
        
    end

end)

net.Receive("Mana:RequestApplySkill", function(l, ply)
    local isAdd = net.ReadBool()
    if (isAdd and ply:GetManaSkillPoints() <= 0) then return end
    local field = net.ReadString()
    if not ply._manaStats then
        ply._manaStats = {}
    end
    ply._manaStats[field] = (ply._manaStats[field] or 0) + (isAdd and 1 or -1)

    if (field == "Speed" or field == "Health") then
        ply:SetupManaStats()
    end
end)

net.Receive("Mana:RequestReset", function(l, ply)
    if (ply:GetManaResets() > 0) then
        ply._manaStats = {
            Damage = 0,
            Speed = 0,
            Resistance = 0,
            Vitality = 0
        }

        if not Mana.Config.PermaStatsGiven then
            ply:SetNWInt("ManaStatsGiven", 0)
        end

        ply:SetupManaStats()
        ply:GiveManaResets(-1)
    end
end)

net.Receive("Mana:RequestPower", function(l, ply)
    local isFirst = net.ReadBool()
    local canReroll = false

    if (isFirst and ply:GetMaxMana() == 0) then
        ply:IncreaseMana(math.random(500, 800))
        ply:SaveMana()
        canReroll = true
    elseif (not isFirst and ply:GetManaRerolls() > 0) then
        ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
        Mana.SQL:Query("UPDATE muramana SET rerolls='" .. ply:GetManaRerolls() .. "' WHERE steamid='" .. ply:SteamID64() .. "'")
        canReroll = true
    end

    if (canReroll) then
        local options = {}

        for k, v in pairs(Mana.Config.Magic) do
            if v.Rarity and v.Rarity > 0 then
                for i = 0, v.Rarity do
                    table.insert(options, k)
                end
            end
        end
        
        --YAM FIX : attention à cette boucle infinie si on a uniquement deux configurations possible et une seule d'activée (rareté > 0)
        if (#options <= 1) then return end
        
        local magie = table.Random(options)
        while (ply:GetManaMagic() == magie)
            do
                magie = table.Random(options)
            end

        ply:SetNWString("ManaMagic", magie)
        Mana.SQL:Query("UPDATE muramana SET magicset='" .. ply:GetManaMagic() .. "' WHERE steamid='" .. ply:SteamID64() .. "'")
        ply:InitializeMagic(ply)
    end
end)