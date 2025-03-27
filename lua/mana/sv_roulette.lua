-- lua/mana/sv_roulette.lua
-- Mise à jour du système de reroll côté serveur pour supporter la roulette

-- Stocker l'ancienne fonction de reroll pour référence
local originalRequestPowerHandler

-- Fonction pour obtenir une magie aléatoire basée sur la rareté
function Mana:GetRandomMagic()
    local magics = {}
    local totalWeight = 0
    
    -- Calcul du poids total
    for k, v in pairs(self.Config.Magic) do
        totalWeight = totalWeight + v.Rarity
    end
    
    -- Table de magies avec leurs poids relatifs
    for k, v in pairs(self.Config.Magic) do
        table.insert(magics, {
            name = k,
            weight = v.Rarity,
            relativeWeight = v.Rarity / totalWeight
        })
    end
    
    -- Sélection par poids
    local rnd = math.random()
    local cumulativeWeight = 0
    
    for _, magic in ipairs(magics) do
        cumulativeWeight = cumulativeWeight + magic.relativeWeight
        
        if rnd <= cumulativeWeight then
            return magic.name
        end
    end
    
    -- En cas d'erreur, retourner la première magie
    return magics[1].name
end

-- Intercepte et remplace le gestionnaire de requête de pouvoir
hook.Add("Initialize", "Mana.SetupRouletteServer", function()
    -- Le message réseau existe déjà, on doit juste modifier son comportement
    
    -- On vérifie si la fonction net.Receivers["Mana:RequestPower"] existe
    if net.Receivers and net.Receivers["Mana:RequestPower"] then
        -- Sauvegarde l'ancien handler
        originalRequestPowerHandler = net.Receivers["Mana:RequestPower"]
        
        -- Remplace par notre nouveau handler
        net.Receive("Mana:RequestPower", function(len, ply)
            local isFirst = net.ReadBool()
            local selectedMagic = net.ReadString()
            
            -- Si le client a spécifié une magie, on l'utilise
            -- Sinon on en génère une aléatoirement (compatibilité avec l'ancien système)
            if selectedMagic and selectedMagic ~= "" and Mana.Config.Magic[selectedMagic] then
                -- Le joueur a besoin de rerolls sauf si c'est sa première magie
                if not isFirst and ply:GetManaRerolls() <= 0 then
                    ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                    return
                end
                
                -- Déduire un reroll si ce n'est pas la première magie
                if not isFirst then
                    ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
                    Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                end
                
                -- Mettre à jour la magie
                ply:SetNWString("ManaMagic", selectedMagic)
                
                -- Si c'est la première fois, initialiser le mana
                if isFirst then
                    ply:SetNWInt("MaxMana", 500)
                    ply:SetNWInt("Mana", 500)
                    ply:SetupManaTimer()
                end
                
                -- Mettre à jour la base de données
                Mana.SQL:Query("UPDATE muramana SET magicset='" .. selectedMagic .. "', mana=" .. ply:GetMana() .. ", maxmana=" .. ply:GetMaxMana() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                
                -- Initialiser la magie
                ply:InitializeMagic(ply)
                
                -- Notifier le client
                ply:PrintMessage(HUD_PRINTTALK, "Vous avez obtenu la magie: " .. selectedMagic)
            else
                -- Si pas de magie spécifiée, on utilise l'ancien handler
                if originalRequestPowerHandler then
                    originalRequestPowerHandler(len, ply)
                else
                    -- Si l'ancien handler n'est pas disponible, on implémente une version simplifiée
                    local magicName = Mana:GetRandomMagic()
                    
                    -- Le joueur a besoin de rerolls sauf si c'est sa première magie
                    if not isFirst and ply:GetManaRerolls() <= 0 then
                        ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                        return
                    end
                    
                    -- Déduire un reroll si ce n'est pas la première magie
                    if not isFirst then
                        ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
                        Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                    end
                    
                    -- Mettre à jour la magie
                    ply:SetNWString("ManaMagic", magicName)
                    
                    -- Si c'est la première fois, initialiser le mana
                    if isFirst then
                        ply:SetNWInt("MaxMana", 500)
                        ply:SetNWInt("Mana", 500)
                        ply:SetupManaTimer()
                    end
                    
                    -- Mettre à jour la base de données
                    Mana.SQL:Query("UPDATE muramana SET magicset='" .. magicName .. "', mana=" .. ply:GetMana() .. ", maxmana=" .. ply:GetMaxMana() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                    
                    -- Initialiser la magie
                    ply:InitializeMagic(ply)
                    
                    -- Notifier le client
                    ply:PrintMessage(HUD_PRINTTALK, "Vous avez obtenu la magie: " .. magicName)
                end
            end
        end)
    else
        -- Si le message réseau n'existe pas encore, on le crée
        util.AddNetworkString("Mana:RequestPower")
        
        net.Receive("Mana:RequestPower", function(len, ply)
            local isFirst = net.ReadBool()
            local selectedMagic = net.ReadString()
            
            if selectedMagic and selectedMagic ~= "" and Mana.Config.Magic[selectedMagic] then
                -- Le joueur a besoin de rerolls sauf si c'est sa première magie
                if not isFirst and ply:GetManaRerolls() <= 0 then
                    ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                    return
                end
                
                -- Déduire un reroll si ce n'est pas la première magie
                if not isFirst then
                    ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
                    Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                end
                
                -- Mettre à jour la magie
                ply:SetNWString("ManaMagic", selectedMagic)
                
                -- Si c'est la première fois, initialiser le mana
                if isFirst then
                    ply:SetNWInt("MaxMana", 500)
                    ply:SetNWInt("Mana", 500)
                    ply:SetupManaTimer()
                end
                
                -- Mettre à jour la base de données
                Mana.SQL:Query("UPDATE muramana SET magicset='" .. selectedMagic .. "', mana=" .. ply:GetMana() .. ", maxmana=" .. ply:GetMaxMana() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                
                -- Initialiser la magie
                ply:InitializeMagic(ply)
                
                -- Notifier le client
                ply:PrintMessage(HUD_PRINTTALK, "Vous avez obtenu la magie: " .. selectedMagic)
            else
                -- Si pas de magie spécifiée, on en génère une aléatoirement
                local magicName = Mana:GetRandomMagic()
                
                -- Le joueur a besoin de rerolls sauf si c'est sa première magie
                if not isFirst and ply:GetManaRerolls() <= 0 then
                    ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                    return
                end
                
                -- Déduire un reroll si ce n'est pas la première magie
                if not isFirst then
                    ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
                    Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                end
                
                -- Mettre à jour la magie
                ply:SetNWString("ManaMagic", magicName)
                
                -- Si c'est la première fois, initialiser le mana
                if isFirst then
                    ply:SetNWInt("MaxMana", 500)
                    ply:SetNWInt("Mana", 500)
                    ply:SetupManaTimer()
                end
                
                -- Mettre à jour la base de données
                Mana.SQL:Query("UPDATE muramana SET magicset='" .. magicName .. "', mana=" .. ply:GetMana() .. ", maxmana=" .. ply:GetMaxMana() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                
                -- Initialiser la magie
                ply:InitializeMagic(ply)
                
                -- Notifier le client
                ply:PrintMessage(HUD_PRINTTALK, "Vous avez obtenu la magie: " .. magicName)
            end
        end)
    end
    
    -- Créer un message réseau pour permettre au serveur de définir une magie spécifique
    util.AddNetworkString("Mana:SetSelectedPower")
end)