-- lua/mana/sv_roulette.lua
-- Mise à jour du système de reroll côté serveur pour supporter la roulette

-- Stocker l'ancienne fonction de reroll pour référence
local originalRequestPowerHandler

-- Suivi des joueurs qui ont déjà payé pour un spin
local paidForSpin = {}

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
    -- Ajouter un message réseau pour la déduction anticipée des rerolls
    util.AddNetworkString("Mana:DeductRerollUpfront")
    
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
                -- Vérifier si le joueur a le droit d'obtenir une nouvelle magie
                if not isFirst and not paidForSpin[ply:SteamID()] and ply:GetManaRerolls() < 0 then
                    ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                    return
                end
                
                -- Marquer le joueur comme ayant utilisé son spin payé
                if paidForSpin[ply:SteamID()] then
                    paidForSpin[ply:SteamID()] = nil
                end
                
                -- SUPPRIMÉ: Ne plus déduire de reroll ici car c'est fait au clic du bouton
                -- if not isFirst then
                --     ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
                --     Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                -- end
                
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
                    
                    -- Vérifier si le joueur a le droit d'obtenir une nouvelle magie
                    if not isFirst and not paidForSpin[ply:SteamID()] and ply:GetManaRerolls() < 0 then
                        ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                        return
                    end
                    
                    -- Marquer le joueur comme ayant utilisé son spin payé
                    if paidForSpin[ply:SteamID()] then
                        paidForSpin[ply:SteamID()] = nil
                    end
                    
                    -- SUPPRIMÉ: Ne plus déduire de reroll ici car c'est fait au clic du bouton
                    -- if not isFirst then
                    --     ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
                    --     Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
                    -- end
                    
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
                -- Vérifier si le joueur a le droit d'obtenir une nouvelle magie
                if not isFirst and not paidForSpin[ply:SteamID()] and ply:GetManaRerolls() < 0 then
                    ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                    return
                end
                
                -- Marquer le joueur comme ayant utilisé son spin payé
                if paidForSpin[ply:SteamID()] then
                    paidForSpin[ply:SteamID()] = nil
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
                
                -- Vérifier si le joueur a le droit d'obtenir une nouvelle magie
                if not isFirst and not paidForSpin[ply:SteamID()] and ply:GetManaRerolls() < 0 then
                    ply:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas assez de rerolls!")
                    return
                end
                
                -- Marquer le joueur comme ayant utilisé son spin payé
                if paidForSpin[ply:SteamID()] then
                    paidForSpin[ply:SteamID()] = nil
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

-- Gestionnaire pour le nouveau message de déduction anticipée des rerolls
net.Receive("Mana:DeductRerollUpfront", function(len, ply)
    if ply:GetMaxMana() == 0 then return end -- Ne pas déduire pour les nouveaux utilisateurs
    if ply:GetManaRerolls() <= 0 then return end -- Ne pas déduire s'ils n'en ont pas
    
    -- Déduire un reroll
    ply:SetNWInt("ManaRerolls", ply:GetManaRerolls() - 1)
    Mana.SQL:Query("UPDATE muramana SET rerolls=" .. ply:GetManaRerolls() .. " WHERE steamid='" .. ply:SteamID64() .. "';")
    
    -- Marquer ce joueur comme ayant payé pour un spin
    paidForSpin[ply:SteamID()] = true
    
    -- Nettoyer après 30 secondes en cas de déconnexion ou autre problème
    timer.Simple(30, function()
        if paidForSpin[ply:SteamID()] then
            paidForSpin[ply:SteamID()] = nil
        end
    end)
end)