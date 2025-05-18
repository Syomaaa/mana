-- lua/mana/cl_roulette.lua
-- Système de roulette pour l'addon Mana (avec animation naturelle)

local PANEL = {}

-- Configuration de la roulette
local ROULETTE_WIDTH = 1600  -- Taille de la fenêtre adaptée au background
local ROULETTE_HEIGHT = 900
local ITEM_WIDTH = 180      -- Taille des cartes de magie
local ITEM_HEIGHT = 180
local ITEM_SPACING = 15
local VISIBLE_ITEMS = 7     -- Nombre d'items visibles à la fois
local SPIN_DURATION = 8     -- Durée fixe de l'animation en secondes
local SPIN_VARIANCE = 0.5   -- Variation aléatoire de la durée (± secondes)
local SPIN_SOUNDS = {
    start = Sound("ui/buttonrollover.wav"),
    spinning = Sound("ui/buttonclick.wav"),
    stop = Sound("ui/achievement_earned.wav")
}

-- Dimensions des éléments
local FRAME_WIDTH = 1600
local FRAME_HEIGHT = 649
local BUTTON_WIDTH = 485
local BUTTON_HEIGHT = 104
local CLOSE_WIDTH = 95
local CLOSE_HEIGHT = 96
local REROLL_BUTTON_WIDTH = 485  -- Même largeur que le bouton Lancer
local REROLL_BUTTON_HEIGHT = 60  -- Hauteur de l'image btnreroll.png

-- Assets
local ASSETS = {
    background = Material("materials/reroll/background_hexa.png", "noclamp smooth"),
    button = Material("materials/reroll/lancer.png", "noclamp smooth"),
    close = Material("materials/reroll/close.png", "noclamp smooth"),
    frame = Material("materials/reroll/wiphexa.png", "noclamp smooth"),
    magic_bg = Material("materials/reroll/grimoire.png", "noclamp smooth"), -- Image de fond commune pour toutes les magies
    reroll_button = Material("materials/reroll/btnreroll.png", "noclamp smooth")  -- Nouvelle image pour les rerolls
}

-- Créer un cache pour les matériaux des magies
local magicMaterials = {}

-- Fonction pour obtenir le matériau d'une magie
local function GetMagicMaterial(magicName)
    if not magicMaterials[magicName] then
        local magicConfig = Mana.Config.Magic[magicName]
        local imagePath = magicConfig and magicConfig.Image or "materials/reroll/grimoire.png"
        magicMaterials[magicName] = Material(imagePath, "noclamp smooth")
    end
    return magicMaterials[magicName]
end

function PANEL:Init()
    -- Transformation des variables globales en propriétés locales du panel
    self.isSpinning = false
    self.spinStartTime = 0
    self.spinEndTime = 0
    self.allItems = {}
    self.visibleItems = {}
    self.selectedPower = nil
    self.startOffset = 0
    self.currentOffset = 0
    self.currentVelocity = 0
    self.initialVelocity = 1500  -- Vitesse initiale élevée (pixels/seconde)
    self.finalPosition = 0
    self.originalItemsWeight = {}  -- Table pour stocker les poids des items originaux
    -- Variables pour le verrouillage de position
    self.isPositionLocked = false
    self.lockedOffset = 0
    
    self:SetSize(ROULETTE_WIDTH, ROULETTE_HEIGHT)
    self:Center()
    self:MakePopup()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self.Sys = SysTime()
    
    -- Calculer le centre de la zone de roulette en fonction de l'encadrement
    local frameX = (ROULETTE_WIDTH - FRAME_WIDTH) / 2
    local frameY = (ROULETTE_HEIGHT - FRAME_HEIGHT) / 2
    local rouletteWidth = ITEM_WIDTH * VISIBLE_ITEMS + ITEM_SPACING * (VISIBLE_ITEMS - 1)
    
    -- Créer la zone de roulette centrée dans l'encadrement
    self.RoulettePanel = vgui.Create("DPanel", self)
    self.RoulettePanel:SetPos(
        frameX + (FRAME_WIDTH - rouletteWidth) / 2, 
        frameY + (FRAME_HEIGHT * 0.55 - ITEM_HEIGHT / 2) -- Déplacé un peu plus bas (55% de la hauteur au lieu de 50%)
    )
    self.RoulettePanel:SetSize(rouletteWidth, ITEM_HEIGHT)
    
    -- La peinture de la zone de roulette - maintenant transparente sauf pour le contenu
    self.RoulettePanel.Paint = function(s, w, h) 
        -- La zone de la roulette est masquée au-delà de ses bords
        local x1, y1 = s:LocalToScreen(0, 0)
        local x2, y2 = s:LocalToScreen(w, h)
        render.SetScissorRect(x1, y1, x2, y2, true)
    end
    
    self.RoulettePanel.PaintOver = function(s, w, h)
        render.SetScissorRect(0, 0, 0, 0, false)
    end
    
    -- Bouton pour lancer la roulette
    self.LaunchBtn = vgui.Create("DButton", self)
    self.LaunchBtn:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
    self.LaunchBtn:SetPos(
        (ROULETTE_WIDTH - BUTTON_WIDTH) / 2, 
        frameY + FRAME_HEIGHT - 140 -- Positionner sous l'encadrement
    )
    self.LaunchBtn:SetText("")
    self.LaunchBtn.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(ASSETS.button)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    
    local panel = self -- Référence au panel pour l'utiliser dans les closures
    
    self.LaunchBtn.DoClick = function()
        if not panel.isSpinning then
            local isFirst = LocalPlayer():GetMaxMana() == 0
            if (not isFirst and LocalPlayer():GetManaRerolls() <= 0) then
                Derma_Message("Vous n'avez aucun reroll", "Erreur", "Ok")
                return
            end
            
            -- Envoyer un message au serveur pour déduire le reroll immédiatement
            if not isFirst then
                net.Start("Mana:DeductRerollUpfront")
                net.SendToServer()
            end
            
            panel:StartSpin()
        end
    end
    
    -- Panneau de rerolls avec la nouvelle image
    self.RerollPanel = vgui.Create("DPanel", self)
    self.RerollPanel:SetSize(REROLL_BUTTON_WIDTH, REROLL_BUTTON_HEIGHT)
    self.RerollPanel:SetPos(
        (ROULETTE_WIDTH - REROLL_BUTTON_WIDTH) / 2,
        frameY + FRAME_HEIGHT - 140 + BUTTON_HEIGHT + 1 -- Position sous le bouton lancer avec un peu d'espace
    )
    self.RerollPanel.Paint = function(s, w, h)
        -- Dessiner l'image de fond
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(ASSETS.reroll_button)
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Afficher le texte avec le nombre de rerolls
        local rerolls = LocalPlayer():GetManaRerolls()
        draw.SimpleText("Rerolls restants: " .. rerolls, "mana.title", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    -- Bouton fermer
    self.CloseBtn = vgui.Create("DButton", self)
    self.CloseBtn:SetSize(CLOSE_WIDTH, CLOSE_HEIGHT)
    self.CloseBtn:SetPos(ROULETTE_WIDTH - CLOSE_WIDTH - 20, 20) -- Position en haut à droite avec une marge
    self.CloseBtn:SetText("")
    self.CloseBtn.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(ASSETS.close)
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Légère mise en évidence au survol
        if s:IsHovered() and not panel.isSpinning then
            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawRect(0, 0, w, h)
        end
    end
    
    self.CloseBtn.DoClick = function()
        if panel.isSpinning then return end
        panel:Remove()
    end
    
    -- Initialiser les données
    self:InitializeItems()
    self:CreateItems()
end

function PANEL:PrepareRoulette()
    -- Cette fonction distribue les magies dans la roulette selon leur rareté
    -- Plus une magie est rare, moins elle apparaîtra dans la roulette
    
    -- Récupérer toutes les magies depuis la config
    local originalItems = {}
    local totalWeight = 0
    local RARITY_THRESHOLD = 1.0  -- Seuil en dessous duquel une magie est considérée comme "très rare"
    local ROULETTE_SIZE = 5000    -- Nombre total de positions dans la roulette (augmenté pour plus de précision)
    
    -- D'abord, calculer le poids total et stocker les données originales
    for magicName, magicData in pairs(Mana.Config.Magic) do
        local rarity = magicData.Rarity or 100
        -- Vérifier que la rareté n'est pas zéro (exclusion des magies d'événement)
        if rarity > 0 then
            table.insert(originalItems, {
                name = magicName,
                rarity = rarity
            })
            self.originalItemsWeight[magicName] = rarity
            totalWeight = totalWeight + rarity
        end
    end
    
    -- Ensuite, créer la liste d'items avec répétition basée sur la rareté
    self.allItems = {}
    
    -- Table pour compter le nombre d'occurrences de chaque magie
    local countByMagic = {}
    
    -- Pour chaque magie, déterminer combien de fois elle apparaît dans la roulette
    for _, item in ipairs(originalItems) do
        -- Normaliser le poids - plus la rareté est élevée, plus l'item apparaît souvent
        local normalizedWeight = item.rarity / totalWeight
        
        -- Calculer combien de fois cet item devrait apparaître dans la roulette finale
        local itemCount = 0
        
        if item.rarity < RARITY_THRESHOLD then
            -- Pour les magies très rares, on calcule un nombre précis basé sur leur rareté
            -- Cela peut être 0 pour les raretés extrêmement faibles
            itemCount = math.floor(normalizedWeight * ROULETTE_SIZE)
        else
            -- Pour les magies communes, on garantit au moins une occurrence
            itemCount = math.max(1, math.floor(normalizedWeight * 1000))
        end
        
        countByMagic[item.name] = itemCount
        
        -- Ajouter cet item le nombre de fois calculé
        for i = 1, itemCount do
            table.insert(self.allItems, {
                name = item.name,
                rarity = item.rarity
            })
        end
    end
    
    -- Mélanger la liste pour que les items de même type ne soient pas regroupés
    table.Shuffle(self.allItems)
    
    -- Log pour debug
    print("Roulette préparée avec "..#self.allItems.." positions")
    for name, count in pairs(countByMagic) do
        local config = Mana.Config.Magic[name]
        if config and config.Rarity < RARITY_THRESHOLD then
            print(name..": "..count.." occurrences (rareté: "..config.Rarity..")")
        end
    end
    
    -- Si la roulette est vide (cas improbable), ajouter au moins un élément par défaut
    if #self.allItems == 0 then
        for _, item in ipairs(originalItems) do
            if item.rarity > 0 then
                table.insert(self.allItems, {
                    name = item.name,
                    rarity = item.rarity
                })
                break
            end
        end
    end
end

function PANEL:InitializeItems()
    -- Cette nouvelle méthode prépare la roulette avec une distribution naturelle
    self:PrepareRoulette()
end

function PANEL:CreateItems()
    self.visibleItems = {}
    
    -- Création du conteneur de la roulette
    if IsValid(self.ContentPanel) then
        self.ContentPanel:Remove()
    end
    
    self.ContentPanel = vgui.Create("DPanel", self.RoulettePanel)
    local totalWidth = ITEM_WIDTH * #self.allItems + ITEM_SPACING * (#self.allItems - 1)
    self.ContentPanel:SetSize(totalWidth, ITEM_HEIGHT)
    self.ContentPanel:SetPos(0, 0)
    self.ContentPanel.Paint = function() end
    
    local panel = self -- Référence au panel pour l'utiliser dans les closures
    
    -- Création des éléments de la roulette
    for i, item in ipairs(self.allItems) do
        local itemPanel = vgui.Create("DPanel", self.ContentPanel)
        itemPanel:SetSize(ITEM_WIDTH, ITEM_HEIGHT)
        itemPanel:SetPos((i-1) * (ITEM_WIDTH + ITEM_SPACING), 0)
        
        local rarityColor
        if item.rarity <= 1 then
            rarityColor = Color(255, 0, 0) -- Épique/Légendaire (rouge)
        elseif item.rarity <= 5 then
            rarityColor = Color(0, 255, 0) -- Rare (vert)
        else
            rarityColor = Color(255, 255, 255) -- Commun (blanc)
        end
        
        itemPanel.Paint = function(s, w, h)
            -- Fond de base
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
            
            -- Utiliser l'image spécifique à la magie ou l'image par défaut
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(GetMagicMaterial(item.name))
            surface.DrawTexturedRect(0, 0, w, h)
            
            -- Bande noire en bas pour le texte (environ 25% de la hauteur)
            local textHeight = h * 0.25
            draw.RoundedBox(0, 0, h - textHeight, w, textHeight, Color(0, 0, 0, 230))
            
            -- Render magic name with white text on black background
            draw.SimpleText(item.name, "mana.title", w/2, h - textHeight/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            -- Border with rarity color
            surface.SetDrawColor(rarityColor)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
            
            -- Effet spécial pour l'item au centre lors du ralentissement
            if panel.isSpinning then
                -- Trouver si cet item est au centre
                local centerX = s:GetParent():GetParent():GetWide() / 2
                local myPos = s:GetX() + s:GetParent():GetX()
                local myCenterX = myPos + w/2
                local distanceFromCenter = math.abs(myCenterX - centerX)
                
                -- Highlight des items proches du centre pendant le ralentissement
                local currentTime = SysTime()
                local progress = math.Clamp((currentTime - panel.spinStartTime) / (panel.spinEndTime - panel.spinStartTime), 0, 1)
                
                if progress > 0.7 then
                    local highlightIntensity = 0
                    
                    -- Items très proches du centre
                    if distanceFromCenter < ITEM_WIDTH * 0.5 then
                        -- Effet de pulsation pour l'item central
                        local pulse = math.sin(SysTime() * 15) * 0.5 + 0.5
                        highlightIntensity = math.min(1, (progress - 0.7) * 5) * (0.6 + 0.4 * pulse)
                        
                        -- Effet spécial pour l'item final
                        if progress > 0.95 then
                            surface.SetDrawColor(rarityColor.r, rarityColor.g, rarityColor.b, 155 + 100 * pulse)
                            surface.DrawOutlinedRect(0, 0, w, h, 3)
                            surface.DrawOutlinedRect(2, 2, w-4, h-4, 1)
                        end
                    end
                    -- Items voisins proches (effet atténué)
                    else if distanceFromCenter < ITEM_WIDTH * 1.2 then
                        local proximityFactor = 1 - (distanceFromCenter / (ITEM_WIDTH * 1.2))
                        highlightIntensity = math.min(1, (progress - 0.7) * 5) * proximityFactor * 0.5
                    end
                    
                    -- Appliquer l'effet de surbrillance
                    if highlightIntensity > 0 then
                        surface.SetDrawColor(rarityColor.r, rarityColor.g, rarityColor.b, 
                                            math.min(200, 50 + 150 * highlightIntensity))
                        surface.DrawOutlinedRect(0, 0, w, h, 2)
                    end
                end
            end
        end
        
        table.insert(self.visibleItems, {
            panel = itemPanel,
            data = item
        })
    end
    
    -- Position initiale aléatoire
    local centerX = self.RoulettePanel:GetWide() / 2
    self.currentOffset = centerX - math.random(10, #self.allItems - 10) * (ITEM_WIDTH + ITEM_SPACING)
    self:UpdateItemPositions()
end

function PANEL:UpdateItemPositions()
    if IsValid(self.ContentPanel) then
        self.ContentPanel:SetPos(self.currentOffset, 0)
    end
end

-- Fonction pour trouver l'item au centre de la roulette
function PANEL:GetCenterItem()
    local centerX = self.RoulettePanel:GetWide() / 2
    local itemSize = ITEM_WIDTH + ITEM_SPACING
    local closestDistance = math.huge
    local closestItem = nil
    local closestIndex = 0
    
    -- Recherche plus précise de l'item au centre
    for i, item in ipairs(self.allItems) do
        local itemPos = (i - 0.5) * itemSize + self.currentOffset
        local distanceFromCenter = math.abs(itemPos - centerX)
        
        if distanceFromCenter < closestDistance then
            closestDistance = distanceFromCenter
            closestItem = item
            closestIndex = i
        end
    end
    
    return closestItem, closestIndex
end

function PANEL:StartSpin()
    if self.isSpinning then return end
    
    -- Déverrouiller la position pour un nouveau spin
    self.isPositionLocked = false
    
    local isFirst = LocalPlayer():GetMaxMana() == 0
    
    -- Jouer le son de démarrage
    surface.PlaySound(SPIN_SOUNDS.start)
    
    self.isSpinning = true
    
    -- Choix aléatoire pondéré pour déterminer la magie préférée
    local rnd = math.random()
    local cumulativeWeight = 0
    local totalWeight = 0
    
    -- Calculer le poids total
    for _, weight in pairs(self.originalItemsWeight) do
        totalWeight = totalWeight + weight
    end
    
    -- Sélectionner la magie basée sur sa probabilité
    local desiredPower = nil
    
    for magicName, weight in pairs(self.originalItemsWeight) do
        local normalizedWeight = weight / totalWeight
        cumulativeWeight = cumulativeWeight + normalizedWeight
        
        if rnd <= cumulativeWeight then
            desiredPower = magicName
            break
        end
    end
    
    if not desiredPower then
        -- Fallback au cas où
        local keys = table.GetKeys(self.originalItemsWeight)
        desiredPower = keys[1]
    end
    
    -- Noter la magie désirée, mais ne pas forcer son apparition
    -- Elle sera simplement plus probable dans la roulette
    print("Magie désirée: " .. desiredPower) -- Debug
    
    -- Définir une position de départ et une vitesse initiale
    self.startOffset = self.currentOffset
    self.currentVelocity = self.initialVelocity
    
    -- Configurer l'animation avec une durée fixe
    local duration = SPIN_DURATION + math.random(-SPIN_VARIANCE * 100, SPIN_VARIANCE * 100) / 100
    self.spinStartTime = SysTime()
    self.spinEndTime = self.spinStartTime + duration
    
    local panel = self -- Référence au panel pour l'utiliser dans la closure
    
    -- Fonction pour finaliser l'animation
    local function finishSpin()
        panel.isSpinning = false
        
        -- Jouer le son d'arrêt
        surface.PlaySound(SPIN_SOUNDS.stop)
        
        -- Trouver simplement l'item qui est au centre à la fin sans essayer de réaligner
        local finalItem, finalIndex = panel:GetCenterItem()
        
        if finalItem then
            panel.selectedPower = finalItem.name
        else
            -- Fallback au cas où
            panel.selectedPower = desiredPower
        end
        
        -- Verrouiller la position finale sans réalignement
        panel.isPositionLocked = true
        panel.lockedOffset = panel.currentOffset
        
        -- Envoyer le résultat au serveur
        net.Start("Mana:RequestPower")
        net.WriteBool(isFirst)
        net.WriteString(panel.selectedPower) -- Envoyer le nom de la magie sélectionnée
        net.SendToServer()
    end
    
    -- Configurer le timer de fin
    timer.Simple(duration, finishSpin)
end

function PANEL:Think()
    if self.isSpinning then
        local currentTime = SysTime()
        local elapsed = currentTime - self.spinStartTime
        local duration = self.spinEndTime - self.spinStartTime
        local progress = math.Clamp(elapsed / duration, 0, 1)
        
        -- Simuler un comportement physique naturel
        -- La vitesse diminue selon une courbe de friction
        
        if progress < 0.1 then
            -- Phase initiale: vitesse maximale constante
            -- Ne pas changer la vitesse
        elseif progress < 0.8 then
            -- Phase de ralentissement principal
            -- La vitesse diminue de manière exponentielle
            local deceleration = self.currentVelocity * (0.05 + 0.2 * progress)
            self.currentVelocity = math.max(0, self.currentVelocity - deceleration * FrameTime())
        else
            -- Phase finale: ralentissement avec micro-oscillations
            local deceleration = self.currentVelocity * 1.2
            self.currentVelocity = math.max(0, self.currentVelocity - deceleration * FrameTime())
            
            -- Ajouter de légères oscillations qui diminuent
            local oscillationFactor = (1 - progress) * 5
            local oscillation = math.sin(progress * 20) * oscillationFactor
            self.currentVelocity = self.currentVelocity + oscillation
        end
        
        -- Ne pas modifier la position si elle est verrouillée
        if not self.isPositionLocked then
            -- Déplacer les items selon la vitesse actuelle
            self.currentOffset = self.currentOffset + self.currentVelocity * FrameTime()
            
            -- Système de boucle infinie
            local totalWidth = (ITEM_WIDTH + ITEM_SPACING) * #self.allItems
            
            -- Si on est allé trop loin à droite, revenir au début
            while self.currentOffset > ITEM_WIDTH * 2 do
                self.currentOffset = self.currentOffset - totalWidth
            end
            
            -- Si on est allé trop loin à gauche, aller à la fin
            while self.currentOffset < -totalWidth + ITEM_WIDTH * 2 do
                self.currentOffset = self.currentOffset + totalWidth
            end
        else
            -- S'assurer que la position reste verrouillée
            self.currentOffset = self.lockedOffset
        end
        
        -- Mettre à jour les positions
        self:UpdateItemPositions()
        
        -- Jouer des sons pendant le défilement avec une fréquence qui diminue progressivement
        local soundThreshold = math.max(100, self.currentVelocity / 5)
        if math.random(1, 1000) < soundThreshold and progress < 0.9 then
            surface.PlaySound(SPIN_SOUNDS.spinning)
        end
    end
    
    -- S'assurer que la position reste verrouillée même après la fin du spin
    if self.isPositionLocked and not self.isSpinning then
        self.currentOffset = self.lockedOffset
        self:UpdateItemPositions()
    end

    -- Vérifier si la touche ÉCHAP est pressée et que la roulette n'est pas en train de tourner
    if input.IsKeyDown(KEY_ESCAPE) and not self.isSpinning then
        self:Remove()
    end
    
    -- Mettre à jour le panneau de rerolls pour afficher le nombre actuel
    if IsValid(self.RerollPanel) then
        self.RerollPanel:SetPaintedManually(false)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    
    -- Dessiner le fond avec l'asset
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(ASSETS.background)
    surface.DrawTexturedRect(0, 0, w, h)
    
    -- Calculer la position de l'encadrement
    local frameX = (w - FRAME_WIDTH) / 2
    local frameY = (h - FRAME_HEIGHT) / 2
    
    -- IMPORTANT: Dessiner le cadre AVANT que le bouton soit rendu dans PaintOver
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(ASSETS.frame)
    surface.DrawTexturedRect(frameX, frameY, FRAME_WIDTH, FRAME_HEIGHT)
end

function PANEL:PaintOver(w, h)
    -- Dessiner l'indicateur central (ligne de sélection) seulement
    local centerX = self.RoulettePanel:GetX() + self.RoulettePanel:GetWide() / 2
    local indicatorTop = self.RoulettePanel:GetY() - 20
    local indicatorBottom = self.RoulettePanel:GetY() + self.RoulettePanel:GetTall() + 20
    
    -- Effet de brillance
    for i = 3, 1, -1 do
        local alpha = 150 - i * 40
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.DrawLine(centerX - i, indicatorTop, centerX - i, indicatorBottom)
        surface.DrawLine(centerX + i, indicatorTop, centerX + i, indicatorBottom)
    end
    
    -- Ligne blanche centrale
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawLine(centerX, indicatorTop, centerX, indicatorBottom)
    
    -- Petits triangles blancs en haut et en bas
    local triangleSize = 6
    draw.NoTexture()
    
    -- Effet de pulsation pour les triangles
    local pulse = 0
    if self.isSpinning then
        pulse = math.sin(SysTime() * 5) * 0.3 + 0.7
    else
        pulse = 1
    end
    
    -- Triangle du haut
    surface.SetDrawColor(255, 255, 255, 255 * pulse)
    surface.DrawPoly({
        {x = centerX, y = indicatorTop},
        {x = centerX - triangleSize, y = indicatorTop - triangleSize},
        {x = centerX + triangleSize, y = indicatorTop - triangleSize}
    })
    
    -- Triangle du bas
    surface.SetDrawColor(255, 255, 255, 255 * pulse)
    surface.DrawPoly({
        {x = centerX, y = indicatorBottom},
        {x = centerX - triangleSize, y = indicatorBottom + triangleSize},
        {x = centerX + triangleSize, y = indicatorBottom + triangleSize}
    })
end

-- Fonction pour forcer la sélection d'une magie spécifique (pour les admins)
function PANEL:ForceSelectMagic(magicName)
    if self.isSpinning then return end
    
    -- Pour les sélections forcées (admins), nous utilisons une approche légèrement différente
    -- Trouver les occurrences de la magie spécifiée
    local occurrences = {}
    for i, item in ipairs(self.allItems) do
        if item.name == magicName then
            table.insert(occurrences, i)
        end
    end
    
    if #occurrences > 0 then
        -- Choisir une occurrence au hasard
        local randomIndex = occurrences[math.random(1, #occurrences)]
        
        -- Centrer légèrement à gauche de cette occurrence pour que la roulette s'arrête dessus
        local centerX = self.RoulettePanel:GetWide() / 2
        self.currentOffset = centerX - (randomIndex - 0.5) * (ITEM_WIDTH + ITEM_SPACING)
        self.currentOffset = self.currentOffset - 1000  -- Décaler un peu pour l'animation
        
        -- Lancer le spin
        self:StartSpin()
    else
        -- Si aucune occurrence n'est trouvée, créer un spin normal
        self:StartSpin()
    end
end

vgui.Register("Mana.Roulette", PANEL, "DFrame")

-- Hook pour remplacer l'ouverture du menu existant par notre roulette
hook.Add("Initialize", "Mana.ReplaceBookWithRoulette", function()
    -- On garde une référence au net.Receive original
    local originalNetReceive = net.Receive
    
    -- On surcharge la fonction pour intercepter l'ouverture du menu de grimoire
    net.Receive = function(messageName, callback)
        if messageName == "Mana:OpenBookShelve" then
            -- Notre nouveau callback
            originalNetReceive(messageName, function()
                vgui.Create("Mana.Roulette")
            end)
        else
            -- Comportement standard pour les autres messages
            originalNetReceive(messageName, callback)
        end
    end
end)

-- Remplace complètement l'ancien menu si le hook ci-dessus n'est pas suffisant
net.Receive("Mana:OpenBookShelve", function()
    vgui.Create("Mana.Roulette")
end)

-- Ajouter une fonction pour permettre au serveur de spécifier une magie
net.Receive("Mana:SetSelectedPower", function()
    local selectedMagic = net.ReadString()
    
    local roulettePanel = vgui.Create("Mana.Roulette")
    if IsValid(roulettePanel) then
        roulettePanel:ForceSelectMagic(selectedMagic)
    end
end)