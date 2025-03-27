-- lua/mana/cl_roulette.lua
-- Système de roulette pour l'addon Mana (avec utilisation des assets graphiques fournis)

local PANEL = {}

-- Configuration de la roulette
local ROULETTE_WIDTH = 1600  -- Taille de la fenêtre adaptée au background
local ROULETTE_HEIGHT = 900
local ITEM_WIDTH = 180      -- Augmenté de 130 à 180
local ITEM_HEIGHT = 180     -- Augmenté de 130 à 180
local ITEM_SPACING = 15     -- Augmenté de 10 à 15
local VISIBLE_ITEMS = 5
local SPIN_DURATION = 5 -- Durée de l'animation en secondes
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

-- Assets
local ASSETS = {
    background = Material("materials/reroll/background_hexa.png", "noclamp smooth"),
    button = Material("materials/reroll/lancer.png", "noclamp smooth"),
    close = Material("materials/reroll/close.png", "noclamp smooth"),
    frame = Material("materials/reroll/wiphexa.png", "noclamp smooth"),
    magic_bg = Material("materials/reroll/magic_bg.png", "noclamp smooth") -- Image de fond commune pour toutes les magies
}

-- Assets
local ASSETS = {
    background = Material("materials/reroll/background_hexa.png", "noclamp smooth"),
    button = Material("materials/reroll/lancer.png", "noclamp smooth"),
    close = Material("materials/reroll/close.png", "noclamp smooth"),
    frame = Material("materials/reroll/wiphexa.png", "noclamp smooth"),
    magic_bg = Material("materials/reroll/grimoire.png", "noclamp smooth") -- Image de fond commune pour toutes les magies
}

function PANEL:Init()
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
        frameY + (FRAME_HEIGHT * 0.58 - ITEM_HEIGHT / 2) -- Déplacé un peu plus bas (58% de la hauteur au lieu de 50%)
    )
    self.RoulettePanel:SetSize(rouletteWidth, ITEM_HEIGHT)
    self.RoulettePanel.Paint = function(s, w, h)
        -- On ne dessine rien ici, juste le conteneur pour les items
    end
    
    -- Bouton pour lancer la roulette
    self.LaunchBtn = vgui.Create("DButton", self)
    self.LaunchBtn:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
    self.LaunchBtn:SetPos(
        (ROULETTE_WIDTH - BUTTON_WIDTH) / 2, 
        frameY + FRAME_HEIGHT + 20 -- Positionner sous l'encadrement
    )
    self.LaunchBtn:SetText("")
    self.LaunchBtn.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(ASSETS.button)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    
    self.LaunchBtn.DoClick = function()
        self:StartSpin()
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
    end
    
    self.CloseBtn.DoClick = function()
        if isSpinning then return end
        self:Remove()
    end
    
    -- Initialiser les données
    self:InitializeItems()
    self:CreateItems()
end

function PANEL:InitializeItems()
    -- Récupérer toutes les magies depuis la config
    allItems = {}
    local totalWeight = 0
    
    for magicName, magicData in pairs(Mana.Config.Magic) do
        local rarity = magicData.Rarity or 100
        local weight = rarity / 10 -- On convertit la rareté en poids pour la sélection aléatoire
        
        table.insert(allItems, {
            name = magicName,
            weight = weight,
            rarity = rarity
        })
        
        totalWeight = totalWeight + weight
    end
    
    -- On s'assure que tous les items ont un poids relatif
    for _, item in ipairs(allItems) do
        item.relativeWeight = item.weight / totalWeight
    end
    
    -- On mélange les items pour commencer
    table.Shuffle(allItems)
end

function PANEL:CreateItems()
    visibleItems = {}
    local rouletteContent = vgui.Create("DPanel", self.RoulettePanel)
    rouletteContent:SetSize(ITEM_WIDTH * #allItems + ITEM_SPACING * (#allItems - 1), ITEM_HEIGHT)
    rouletteContent:SetPos(0, 0)
    rouletteContent.Paint = function() end
    
    for i, item in ipairs(allItems) do
        local itemPanel = vgui.Create("DPanel", rouletteContent)
        itemPanel:SetSize(ITEM_WIDTH, ITEM_HEIGHT)
        itemPanel:SetPos((i-1) * (ITEM_WIDTH + ITEM_SPACING), 0)
        
        local rarityColor
        if item.rarity <= 0.1 then
            rarityColor = Color(255, 0, 255) -- Légendaire (violet)
        elseif item.rarity <= 1 then
            rarityColor = Color(255, 165, 0) -- Épique (orange)
        elseif item.rarity <= 5 then
            rarityColor = Color(0, 112, 221) -- Rare (bleu)
        else
            rarityColor = Color(255, 255, 255) -- Commun (blanc)
        end
        
        itemPanel.Paint = function(s, w, h)
            -- Fond de base (carré noir)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
            
            -- Utiliser l'image de fond commune
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(ASSETS.magic_bg)
            surface.DrawTexturedRect(0, 0, w, h)
            
            -- Bande noire en bas pour le texte (environ 25% de la hauteur)
            local textHeight = h * 0.25
            draw.RoundedBox(0, 0, h - textHeight, w, textHeight, Color(0, 0, 0, 230))
            
            -- Render magic name with white text on black background
            draw.SimpleText(item.name, "mana.title", w/2, h - textHeight/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            -- Border with rarity color
            surface.SetDrawColor(rarityColor)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end
        
        table.insert(visibleItems, {
            panel = itemPanel,
            data = item
        })
    end
    
    self.ContentPanel = rouletteContent
    currentOffset = 0
    self:UpdateItemPositions()
end

function PANEL:UpdateItemPositions()
    if IsValid(self.ContentPanel) then
        local x = currentOffset
        self.ContentPanel:SetPos(x, 0)
    end
end

function PANEL:StartSpin()
    if isSpinning then return end
    
    local isFirst = LocalPlayer():GetMaxMana() == 0
    if (not isFirst and LocalPlayer():GetManaRerolls() <= 0) then
        Derma_Message("Vous n'avez aucun reroll", "Erreur", "Ok")
        return
    end
    
    -- Play start sound
    surface.PlaySound(SPIN_SOUNDS.start)
    
    isSpinning = true
    
    -- Select a magic based on rarity
    local rnd = math.random()
    local cumulativeWeight = 0
    selectedPower = nil
    
    for i, item in ipairs(allItems) do
        cumulativeWeight = cumulativeWeight + item.relativeWeight
        
        if rnd <= cumulativeWeight then
            selectedPower = item.name
            
            -- Position de l'item sélectionné (centré)
            local centerPos = self.RoulettePanel:GetWide() / 2 - ITEM_WIDTH / 2
            targetOffset = centerPos - (i-1) * (ITEM_WIDTH + ITEM_SPACING)
            break
        end
    end
    
    if not selectedPower then
        -- Fallback if something went wrong
        selectedPower = allItems[1].name
        targetOffset = self.RoulettePanel:GetWide() / 2 - ITEM_WIDTH / 2
    end
    
    -- Setup animation
    spinStartTime = SysTime()
    spinEndTime = spinStartTime + SPIN_DURATION
    
    -- Function to select the magic when spinning ends
    local function finishSpin()
        isSpinning = false
        
        -- Play stop sound
        surface.PlaySound(SPIN_SOUNDS.stop)
        
        -- Send result to server
        net.Start("Mana:RequestPower")
        net.WriteBool(isFirst)
        net.WriteString(selectedPower) -- Send the selected magic name
        net.SendToServer()
        
        -- Show result
        Derma_Message("Vous avez obtenu la magie: " .. selectedPower, "Félicitations!", "OK")
        
        -- Close the panel after a short delay
        timer.Simple(1, function()
            if IsValid(self) then
                self:Remove()
            end
        end)
    end
    
    -- Setup end timer
    timer.Simple(SPIN_DURATION, finishSpin)
end

function PANEL:Think()
    if isSpinning then
        local currentTime = SysTime()
        local progress = math.Clamp((currentTime - spinStartTime) / SPIN_DURATION, 0, 1)
        
        -- Easing function for smooth deceleration
        local easeOutCubic = 1 - (1 - progress) ^ 3
        
        -- Calculate the current position based on the easing
        currentOffset = Lerp(easeOutCubic, currentOffset, targetOffset)
        
        -- Update positions
        self:UpdateItemPositions()
        
        -- Play spinning sound at intervals during the first half
        if progress < 0.5 and math.floor(progress * 20) % 2 == 0 and math.floor(progress * 20) ~= math.floor((progress - FrameTime()) * 20) then
            surface.PlaySound(SPIN_SOUNDS.spinning)
        end
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    
    -- Draw background using your asset
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(ASSETS.background)
    surface.DrawTexturedRect(0, 0, w, h)
    
    -- Draw frame around roulette area using your asset
    local frameX = (w - FRAME_WIDTH) / 2
    local frameY = (h - FRAME_HEIGHT) / 2
    
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(ASSETS.frame)
    surface.DrawTexturedRect(frameX, frameY, FRAME_WIDTH, FRAME_HEIGHT)
    
    -- Draw rerolls remaining
    local rerolls = LocalPlayer():GetManaRerolls()
    draw.SimpleText("Rerolls restants: " .. rerolls, "mana.title", w/2, frameY + FRAME_HEIGHT + BUTTON_HEIGHT + 40, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
    
    if IsValid(Mana.RoulettePanel) then
        Mana.RoulettePanel:ForceSelectMagic(selectedMagic)
    end
end)