-- Thème moderne pour l'interface joueur
local THEME = {
    bg = Color(25, 30, 40, 230),         -- Fond principal
    panel = Color(35, 40, 50, 230),      -- Panneaux
    header = Color(45, 50, 60, 230),     -- En-têtes
    accent = Color(0, 120, 215),         -- Couleur d'accentuation
    accentHover = Color(0, 150, 255),    -- Accentuation au survol
    warning = Color(215, 55, 55),        -- Avertissement
    warningHover = Color(255, 70, 70),   -- Avertissement au survol
    text = Color(230, 230, 230),         -- Texte principal
    textDark = Color(180, 180, 180),     -- Texte secondaire
    textDisabled = Color(120, 120, 120), -- Texte désactivé
    border = Color(60, 65, 75, 230),     -- Bordures
    gold = Color(255, 216, 0)            -- Couleur or pour les points
}

-- Police d'origine
surface.CreateFont("mana.title", {
    font = "Tahoma",
    size = 32
})

surface.CreateFont("mana.stat", {
    font = "Arial",
    size = 22
})

surface.CreateFont("mana.smoll", {
    font = "Arial",
    size = 16,
    weight = 700
})

surface.CreateFont("Arial", {
    font = "Arial",
    size = 16,
    weight = 700
})

-- Polices pour la nouvelle interface d'administration et l'interface joueur moderne
surface.CreateFont("ManaAdmin.Title", {
    font = "Roboto",
    size = 24,
    weight = 500
})

surface.CreateFont("ManaAdmin.SubTitle", {
    font = "Roboto",
    size = 20,
    weight = 500
})

surface.CreateFont("ManaAdmin.Text", {
    font = "Roboto",
    size = 18,
    weight = 400
})

surface.CreateFont("ManaAdmin.SmallText", {
    font = "Roboto",
    size = 16,
    weight = 400
})

surface.CreateFont("ManaAdmin.ButtonText", {
    font = "Roboto",
    size = 16,
    weight = 500
})

-- Fonction pour créer un bouton stylisé
local function CreateStyledButton(parent, text, color, hoverColor)
    local btn = vgui.Create("DButton", parent)
    btn:SetText("")
    
    local btnColor = color or THEME.accent
    local btnHoverColor = hoverColor or THEME.accentHover
    
    btn.Paint = function(self, w, h)
        local bgColor = self:IsEnabled() and (self:IsHovered() and btnHoverColor or btnColor) or ColorAlpha(btnColor, 50)
        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        
        -- Effet de pression
        if self:IsDown() then
            draw.RoundedBox(4, 2, 2, w-4, h-4, ColorAlpha(THEME.panel, 50))
        end
        
        -- Indicateur de focus
        if self:IsHovered() and self:IsEnabled() then
            surface.SetDrawColor(THEME.text)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end
        
        draw.SimpleText(text, "ManaAdmin.ButtonText", w/2, h/2, THEME.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return btn
end

local options = {
    [1] = {
        Name = "Health",
        Icon = surface.GetTextureID("gonzo/health.vtf"),
        Stat = function(val) return "+" .. val .. " PV maximum" end,
        Max = 1000,
        Enabled = true
    },
    [2] = {
        Name = "Speed",
        Icon = surface.GetTextureID("gonzo/speed.vtf"),
        Stat = function(val) return "+" .. val .. " extra units/sec" end,
        Max = 250,
        Enabled = true
    },
    [3] = {
        Name = "Resistance",
        Icon = surface.GetTextureID("gonzo/resistance.vtf"),
        Stat = function(val) return "Dégats subis réduit de " .. val .. "%" end,
        Max = 0,
        Enabled = false -- Non fonctionnel
    },
    [4] = {
        Name = "Damage",
        Icon = surface.GetTextureID("gonzo/damage.vtf"),
        Stat = function(val) return "Dégats augmenté de " .. val .. "%" end,
        Max= 0,
        Enabled = false -- Non fonctionnel
    }
}

Mana.Vgui = Mana.Vgui or {}

-- Interface joueur modernisée pour Mana.Stats (remplace l'ancienne)
local PANEL = {}

function PANEL:Init()
    self.mstats = self
    self:SetSize(700, 500)
    self:MakePopup()
    self:Center()
    self:SetTitle("Mana Stats")
    self:ShowCloseButton(false)
    self:SetDraggable(true)
    
    -- Style du panneau
    self.lblTitle:SetFont("ManaAdmin.Title")
    self.lblTitle:SetTextColor(THEME.text)
    
    -- Référence pour l'effet de flou
    self.Sys = SysTime()
    
    -- Bouton de fermeture
    self.Cl = vgui.Create("DButton", self)
    self.Cl:SetText("r")
    self.Cl:SetTextColor(THEME.text)
    self.Cl:SetFont("Marlett")
    self.Cl.DoClick = function()
        if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end
        self:Remove()
    end
    self.Cl.Paint = function(s, w, h) end
    
    -- Bouton pour donner à des amis
    local giveMenu = vgui.Create("DImageButton", self)
    giveMenu:SetToolTip("Donner à des amis")
    giveMenu:SetSize(24, 24)
    giveMenu:SetPos(self:GetWide() - 80, 8)
    giveMenu:SetImage("icon16/group_add.png")
    giveMenu.DoClick = function()
        if IsValid(Mana.Vgui.GiveMenu) then Mana.Vgui.GiveMenu:Remove() end
        Mana.Vgui.GiveMenu = vgui.Create("Mana.StatsToGive")
        self:Remove()
    end
    
    -- Conteneur principal
    local mainPanel = vgui.Create("DPanel", self)
    mainPanel:Dock(FILL)
    mainPanel:DockMargin(10, 50, 10, 10)
    mainPanel.Paint = function() end
    
    -- Panneau d'information
    local infoPanel = vgui.Create("DPanel", mainPanel)
    infoPanel:Dock(TOP)
    infoPanel:SetTall(80)
    infoPanel:DockMargin(0, 0, 0, 10)
    infoPanel.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, THEME.panel)
        
        -- Informations du joueur
        draw.SimpleText("Point à attribuer:", "ManaAdmin.Text", 20, 20, THEME.text)
        draw.SimpleText(comma_value(LocalPlayer():GetManaSkillPoints()), "ManaAdmin.SubTitle", 170, 20, THEME.gold)
        draw.SimpleText("/" .. math.floor((LocalPlayer():GetMaxMana() / Mana.Config.ManaPerSkill) + LocalPlayer():GetManaStatsGiven()), "ManaAdmin.Text", 170 + 100, 20, THEME.textDark)
        
        draw.SimpleText("Vous avez " .. LocalPlayer():GetManaResets() .. " reset disponible", "ManaAdmin.Text", 20, 50, THEME.text)
        
        -- Ligne séparatrice
        surface.SetDrawColor(THEME.border)
        surface.DrawLine(300, 15, 300, h-15)
        
        -- Instructions
        draw.SimpleText("Clique gauche: +1 | Clique molette: +5 | Clique droit: +10", "ManaAdmin.SmallText", w-20, h-20, THEME.textDark, TEXT_ALIGN_RIGHT)
    end
    
    -- Bouton de reset
    local resetBtn = CreateStyledButton(infoPanel, "Reset", THEME.warning, THEME.warningHover)
    resetBtn:SetSize(100, 30)
    resetBtn:SetTooltip("Réinitialiser toutes vos statistiques\nRequiert 1 reset disponible")
    resetBtn.DoClick = function()
        if (LocalPlayer():GetManaResets() > 0) then
            Derma_Query("Êtes-vous sûr de vouloir réinitialiser vos compétences?", "Confirmation", "Oui", function()
                net.Start("Mana:RequestReset")
                net.SendToServer()
                LocalPlayer()._manaStats = {
                    Damage = 0,
                    Speed = 0,
                    Resistance = 0,
                    Vitality = 0
                }
            end, "Non")
        end
    end
    resetBtn.Think = function(self)
        self:SetEnabled(LocalPlayer():GetManaResets() > 0)
        self:SetAlpha(LocalPlayer():GetManaResets() > 0 and 255 or 100)
        
        -- Position dynamique du bouton pour qu'il soit toujours aligné correctement à droite
        local parentW = self:GetParent():GetWide()
        if parentW > 0 then
            self:SetPos(parentW - 120, 25)
        end
    end
    
    -- Container pour les statistiques
    local statsContainer = vgui.Create("DScrollPanel", mainPanel)
    statsContainer:Dock(FILL)
    statsContainer.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, THEME.panel)
    end
    
    -- Styliser la barre de défilement
    local scrollBar = statsContainer:GetVBar()
    scrollBar:SetWide(8)
    function scrollBar:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnUp:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnDown:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.accent)
    end
    
    -- Options de statistiques
    for k = 1, 4 do
        local info = options[k]
        local statPanel = vgui.Create("DPanel", statsContainer)
        statPanel:Dock(TOP)
        statPanel:SetTall(80)
        statPanel:DockMargin(10, 10, 10, 10)
        
        if not info.Enabled then
            -- Statistiques désactivées (Resistance et Damage)
            statPanel.Paint = function(s, w, h)
                draw.RoundedBox(6, 0, 0, w, h, THEME.header)
                
                -- Icône avec opacité réduite
                surface.SetDrawColor(255, 255, 255, 75)
                surface.SetTexture(info.Icon)
                surface.DrawTexturedRect(15, h/2-32, 64, 64)
                
                -- Nom de la statistique
                draw.SimpleText(info.Name, "ManaAdmin.SubTitle", 94, 15, THEME.textDark)
                
                -- Message de fonctionnalité à venir
                draw.SimpleText("En cours de développement", "ManaAdmin.Text", 94, 40, THEME.warning)
                draw.SimpleText(info.Stat(0), "ManaAdmin.SmallText", 94, 60, THEME.textDark)
                
                -- Badge "Bientôt"
                draw.RoundedBox(4, w-80, 15, 60, 24, THEME.warning)
                draw.SimpleText("Bientôt", "ManaAdmin.SmallText", w-50, 15+12, THEME.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        else
            -- Statistiques actives (Health et Speed)
            statPanel.Paint = function(s, w, h)
                draw.RoundedBox(6, 0, 0, w, h, THEME.header)
                
                -- Icône
                surface.SetDrawColor(255, 255, 255, 175)
                surface.SetTexture(info.Icon)
                surface.DrawTexturedRect(15, h/2-32, 64, 64)
                
                -- Nom de la statistique
                draw.SimpleText(info.Name, "ManaAdmin.SubTitle", 94, 15, THEME.text)
                
                -- Points attribués
                draw.SimpleText("[" .. comma_value(LocalPlayer():GetManaStats(info.Name)) .. " Point" .. (LocalPlayer():GetManaStats(info.Name)>1 and "s" or "") .. " attribué" .. (LocalPlayer():GetManaStats(info.Name)>1 and "s" or "") .. "]", 
                               "ManaAdmin.SmallText", 94, 40, THEME.gold)
                
                -- Effet de la statistique
                draw.SimpleText(info.Stat(LocalPlayer()["GetMana" .. info.Name](LocalPlayer())), "ManaAdmin.Text", 94, 60, THEME.textDark)
                
                -- Maximum (avec plus d'espace à droite pour le bouton +)
                if info.Max ~= -1 then
                    draw.SimpleText("Max: " .. info.Max .. (info.Name == "Health" and " PV" or "%"), "ManaAdmin.SmallText", w-120, 10, THEME.textDark, TEXT_ALIGN_RIGHT)
                end
            end
            
            -- Bouton pour ajouter des points (amélioré)
            statPanel.add = vgui.Create("DButton", statPanel)
            statPanel.add:SetText("+")
            statPanel.add:SetFont("ManaAdmin.SubTitle")
            statPanel.add:SetTextColor(THEME.text)
            statPanel.add:SetSize(60, 40)
            statPanel.add:SetTooltip("Ajouter des points à " .. info.Name .. "\nClique gauche: +1\nClique molette: +5\nClique droit: +10")
            
            statPanel.add.Paint = function(self, w, h)
                local bgColor = THEME.accent
                if self:IsHovered() and self:IsEnabled() then
                    bgColor = THEME.accentHover
                end
                if not self:IsEnabled() then
                    bgColor = ColorAlpha(THEME.accent, 50)
                end
                
                draw.RoundedBox(4, 0, 0, w, h, bgColor)
                
                -- Effet de pression
                if self:IsDown() then
                    draw.RoundedBox(4, 2, 2, w-4, h-4, ColorAlpha(THEME.panel, 50))
                end
                
                -- Indicateur de focus
                if self:IsHovered() and self:IsEnabled() then
                    surface.SetDrawColor(THEME.text)
                    surface.DrawOutlinedRect(0, 0, w, h, 2)
                end
                
                draw.SimpleText("+", "ManaAdmin.SubTitle", w/2, h/2, THEME.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            
            -- Position dynamique du bouton d'ajout - en bas à droite avec plus d'espace
            statPanel.add.Think = function(self)
                local enabled = LocalPlayer():GetManaSkillPoints() > 0 && (info.Max == -1 || LocalPlayer()["GetMana" .. info.Name](LocalPlayer()) < info.Max)
                self:SetEnabled(enabled)
                self:SetAlpha(enabled and 255 or 100)
                
                -- Positionner le bouton en bas à droite avec plus d'espace
                local parentW = self:GetParent():GetWide()
                local parentH = self:GetParent():GetTall()
                if parentW > 0 then
                    -- Augmenter la marge à droite et ajuster la position verticale
                    -- Pour laisser plus d'espace entre le Max et le bouton
                    self:SetPos(parentW - 100, parentH - 45)
                end
            end
            
            statPanel.add.DoClick = function()
                if (LocalPlayer():GetManaSkillPoints() >= 1 && (info.Max == -1 || LocalPlayer()["GetMana" .. info.Name](LocalPlayer()) < info.Max)) then
                    net.Start("Mana:RequestApplySkill")
                    net.WriteBool(true)
                    net.WriteString(info.Name)
                    net.SendToServer()

                    if not LocalPlayer()._manaStats then
                        LocalPlayer()._manaStats = {}
                    end

                    LocalPlayer()._manaStats[info.Name] = (LocalPlayer()._manaStats[info.Name] or 0) + 1
                end
            end
            
            statPanel.add.DoRightClick = function()
                if (LocalPlayer():GetManaSkillPoints() >= 10 && (info.Max == -1 || LocalPlayer()["GetMana" .. info.Name](LocalPlayer()) < info.Max)) then
                    for i=1,10 do
                        net.Start("Mana:RequestApplySkill")
                        net.WriteBool(true)
                        net.WriteString(info.Name)
                        net.SendToServer()
                    end

                    if not LocalPlayer()._manaStats then
                        LocalPlayer()._manaStats = {}
                    end

                    LocalPlayer()._manaStats[info.Name] = (LocalPlayer()._manaStats[info.Name] or 0) + 10
                end
            end
            
            statPanel.add.DoMiddleClick = function()
                if (LocalPlayer():GetManaSkillPoints() >= 5 && (info.Max == -1 || LocalPlayer()["GetMana" .. info.Name](LocalPlayer()) < info.Max)) then
                    for i=1,5 do
                        net.Start("Mana:RequestApplySkill")
                        net.WriteBool(true)
                        net.WriteString(info.Name)
                        net.SendToServer()
                    end

                    if not LocalPlayer()._manaStats then
                        LocalPlayer()._manaStats = {}
                    end

                    LocalPlayer()._manaStats[info.Name] = (LocalPlayer()._manaStats[info.Name] or 0) + 5
                end
            end
            
            -- Ce bloc est remplacé par le nouveau think dans le bloc précédent
        end
    end
    
    -- Barre de progression du mana
    local manaBar = vgui.Create("DPanel", mainPanel)
    manaBar:Dock(BOTTOM)
    manaBar:SetTall(40)
    manaBar:DockMargin(0, 10, 0, 0)
    
    manaBar.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, THEME.panel)
        
        local manaPercent = LocalPlayer():GetMana() / LocalPlayer():GetMaxMana()
        
        -- Fond de la barre
        draw.RoundedBox(4, 10, 10, w-20, h-20, THEME.bg)
        
        -- Barre de progression
        draw.RoundedBox(4, 10, 10, (w-20) * manaPercent, h-20, THEME.accent)
        
        -- Texte
        draw.SimpleText("Mana: " .. LocalPlayer():GetMana() .. " / " .. LocalPlayer():GetMaxMana(), "ManaAdmin.Text", w/2, h/2, THEME.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    draw.RoundedBox(6, 0, 0, w, h, THEME.bg)
    
    -- Barre de titre
    draw.RoundedBoxEx(6, 0, 0, w, 40, THEME.header, true, true, false, false)
end

function PANEL:PerformLayout(w, h)
    self.lblTitle:SetSize(w, 38)
    self.lblTitle:SetPos(10, 0)

    if IsValid(self.Cl) then
        self.Cl:SetPos(w - 36, 4)
        self.Cl:SetSize(32, 32)
    end
    
    -- Mettre à jour la position du bouton de don
    for _, child in pairs(self:GetChildren()) do
        if child:GetClassName() == "DImageButton" then
            child:SetPos(w - 80, 8)
        end
    end
    
    -- Mise à jour de la position du bouton de reset dans infoPanel
    for _, child in pairs(self:GetChildren()) do
        if child:GetName() == "DPanel" then
            for _, subchild in pairs(child:GetChildren()) do
                if subchild:GetClassName() == "DPanel" then
                    for _, btn in pairs(subchild:GetChildren()) do
                        if btn:GetClassName() == "DButton" and btn:GetText() == "Reset" then
                            btn:SetPos(subchild:GetWide() - 120, 25)
                        end
                    end
                end
            end
        end
    end
end

function comma_value(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

vgui.Register("Mana.Stats", PANEL, "DFrame")

--------------------------------------------------------------------------
--------------------------------------------------------------------------

local function LocalNotif( message, x, px, py, time )
    if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end
    Mana.Vgui.LocalNotifPanel = vgui.Create( "DFrame" )
    Mana.Vgui.LocalNotifPanel:SetSize(x , 30)
    Mana.Vgui.LocalNotifPanel:SetPos(px, py)
    Mana.Vgui.LocalNotifPanel.Paint = function(self,w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(16, 16, 16, 200))
        draw.SimpleText(message, "mana.stat", w / 2 , h / 2, Color( 255, 255, 255, 150 ), 1, 1 )
    end
    Mana.Vgui.LocalNotifPanel:SetTitle("")
    Mana.Vgui.LocalNotifPanel:MakePopup()
    Mana.Vgui.LocalNotifPanel:SetDraggable( false )
    Mana.Vgui.LocalNotifPanel:ShowCloseButton( false )
    timer.Simple(time or 2, function() if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end end)
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    -- Configuration générale du panneau
    self:SetSize(600, 450)
    self:MakePopup()
    self:Center()
    self:SetTitle("Faire un don")
    self:ShowCloseButton(false)
    self:SetDraggable(true)
    
    -- Style du panneau
    self.lblTitle:SetFont("ManaAdmin.Title")
    self.lblTitle:SetTextColor(THEME.text)
    
    -- Référence pour l'effet de flou
    self.Sys = SysTime()
    
    -- Bouton de fermeture
    self.Cl = vgui.Create("DButton", self)
    self.Cl:SetText("r")
    self.Cl:SetTextColor(THEME.text)
    self.Cl:SetFont("Marlett")
    self.Cl.DoClick = function()
        if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end
        self:Remove()
    end
    self.Cl.Paint = function(s, w, h) end
    
    -- Bouton pour revenir au menu principal
    local mainMenu = vgui.Create("DButton", self)
    mainMenu:SetSize(200, 30)
    mainMenu:SetText("")
    mainMenu:SetTooltip("Revenir au menu principal")
    mainMenu.Paint = function(self, w, h)
        local bgColor = self:IsHovered() and ColorAlpha(THEME.accent, 80) or ColorAlpha(THEME.accent, 30)
        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        
        surface.SetDrawColor(THEME.text)
        surface.SetMaterial(Material("icon16/application_side_contract.png"))
        surface.DrawTexturedRect(10, h/2-8, 16, 16)
        
        draw.SimpleText("Retour au menu principal", "ManaAdmin.SmallText", 35, h/2, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    mainMenu.DoClick = function()
        vgui.Create("Mana.Stats")
        self:Remove()
    end
    
    -- Décaler le bouton vers la droite et le centrer avec le titre
    mainMenu.Think = function(self)
        local parentW = self:GetParent():GetWide()
        if parentW > 0 then
            -- Positionner à droite avec une marge
            self:SetPos(parentW - self:GetWide() - 40, 5)
        end
    end
    
    -- Panneau d'information
    local infoPanel = vgui.Create("DPanel", self)
    infoPanel:Dock(TOP)
    infoPanel:SetTall(80)
    infoPanel:DockMargin(10, 50, 10, 10)
    infoPanel.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, THEME.panel)
        
        -- Header de l'info panel
        draw.RoundedBoxEx(6, 0, 0, w, 30, THEME.header, true, true, false, false)
        draw.SimpleText("Informations", "ManaAdmin.SubTitle", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        -- Info resets et rerolls avec icônes
        draw.SimpleText("Vous avez " .. LocalPlayer():GetManaResets() .. " reset" .. (LocalPlayer():GetManaResets() > 1 and "s" or "") .. " disponible" .. (LocalPlayer():GetManaResets() > 1 and "s" or ""), 
                       "ManaAdmin.Text", 20, 45, THEME.gold, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        draw.SimpleText("Vous avez " .. LocalPlayer():GetManaRerolls() .. " reroll" .. (LocalPlayer():GetManaRerolls() > 1 and "s" or "") .. " disponible" .. (LocalPlayer():GetManaRerolls() > 1 and "s" or ""), 
                       "ManaAdmin.Text", w - 20, 45, THEME.gold, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
    
    -- Zone de recherche
    local searchPanel = vgui.Create("DPanel", self)
    searchPanel:Dock(TOP) 
    searchPanel:SetTall(50)
    searchPanel:DockMargin(10, 0, 10, 10)
    searchPanel.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, THEME.panel)
        
        draw.SimpleText("Rechercher un joueur:", "ManaAdmin.Text", 10, h/2, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local searchBox = vgui.Create("DTextEntry", searchPanel)
    searchBox:SetSize(300, 30)
    searchBox:SetPos(searchPanel:GetWide() - 320, 10)
    searchBox:SetUpdateOnType(true)
    searchBox:SetPlaceholderText("Nom, SteamID...")
    searchBox:SetDrawLanguageID(false)
    
    -- Style du champ de recherche
    searchBox.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.bg)
        surface.SetDrawColor(THEME.border)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        
        s:DrawTextEntryText(THEME.text, THEME.accent, THEME.text)
        
        if s:GetText() == "" and not s:HasFocus() then
            draw.SimpleText(s:GetPlaceholderText(), "ManaAdmin.SmallText", 5, h/2, THEME.textDark, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    
    -- Liste des joueurs
    local playerScroll = vgui.Create("DScrollPanel", self)
    playerScroll:Dock(FILL)
    playerScroll:DockMargin(10, 0, 10, 10)
    playerScroll.Players = {}
    playerScroll.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, THEME.panel)
    end
    
    -- Personnalisation de la barre de défilement
    local scrollBar = playerScroll:GetVBar()
    scrollBar:SetWide(8)
    function scrollBar:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnUp:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnDown:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.accent)
    end
    
    -- Fonction pour créer la liste des joueurs
    local function CreatePlayerList(filter)
        playerScroll:Clear()
        
        local players = player.GetAll()
        
        -- Fonction de filtrage
        local function filterFunc(options)
            local match = false
            for _, val in pairs(options or {}) do
                if string.match(string.lower(val), string.lower(filter), 1) then
                    match = true
                end
            end
            return match
        end
        
        -- Filtrer les joueurs si nécessaire
        if filter and filter ~= "" then
            local filteredPlayers = {}
            
            for k, v in pairs(player.GetAll()) do
                local options = {
                    steamid = v:SteamID(),
                    steamid64 = v:SteamID64(),
                    name = v:Nick(),
                    steamname = v:SteamName()
                }
                
                if filterFunc(options) then
                    filteredPlayers[k] = v
                end
            end
            
            players = filteredPlayers
        end
        
        -- Message si aucun joueur trouvé
        if table.Count(players) == 0 or (table.Count(players) == 1 and players[1] == LocalPlayer()) then
            local emptyLabel = vgui.Create("DLabel", playerScroll)
            emptyLabel:Dock(TOP)
            emptyLabel:SetTall(40)
            emptyLabel:SetText("Aucun joueur trouvé")
            emptyLabel:SetFont("ManaAdmin.Text")
            emptyLabel:SetTextColor(THEME.textDark)
            emptyLabel:SetContentAlignment(5) -- Centre
            return
        end
        
        -- Créer un élément pour chaque joueur
        for k, v in pairs(players) do
            if v == LocalPlayer() then continue end
            
            playerScroll.Players[k] = vgui.Create("DPanel", playerScroll)
            playerScroll.Players[k]:Dock(TOP)
            playerScroll.Players[k]:SetTall(60)
            playerScroll.Players[k]:DockMargin(10, 10, 10, 0)
            
            playerScroll.Players[k].Paint = function(s, w, h)
                draw.RoundedBox(6, 0, 0, w, h, THEME.header)
                
                -- Afficher le nom du joueur
                draw.SimpleText(v:Nick(), "ManaAdmin.SubTitle", 15, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                
                -- Afficher le SteamID
                draw.SimpleText(v:SteamID(), "ManaAdmin.SmallText", 15, 40, THEME.textDark, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            
            -- Conteneur pour les boutons
            local buttonContainer = vgui.Create("DPanel", playerScroll.Players[k])
            buttonContainer:Dock(RIGHT)
            buttonContainer:SetWide(280)
            buttonContainer:DockMargin(0, 5, 10, 5)
            buttonContainer.Paint = function() end
            
            -- Bouton pour donner des resets
            local giveResetBtn = CreateStyledButton(buttonContainer, "Donner Reset", THEME.accent, THEME.accentHover)
            giveResetBtn:Dock(LEFT)
            giveResetBtn:SetWide(130)
            giveResetBtn:DockMargin(0, 0, 10, 0)
            giveResetBtn:SetTooltip("Donner un ou plusieurs resets à ce joueur")
            
            giveResetBtn.DoClick = function()
                if LocalPlayer():GetManaResets() <= 0 then
                    LocalNotif("Vous n'avez pas de resets !", ScrW(), 0, 50, 1.5)
                    return
                end
                
                Derma_StringRequest(
                    "Don de reset à " .. v:Nick(),
                    "Combien de resets souhaitez-vous donner ? (Vous possédez " .. LocalPlayer():GetManaResets() .. " resets)",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif("Vous devez saisir un nombre !", ScrW(), 0, 50)
                            return
                        elseif tonumber(text) <= 0 then
                            LocalNotif("Le nombre doit être positif !", ScrW(), 0, 50)
                            return
                        elseif tonumber(text) > LocalPlayer():GetManaResets() then
                            LocalNotif("Vous n'avez pas assez de resets !", ScrW(), 0, 50)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("friend")
                        net.WriteString("reset")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
            
            -- Bouton pour donner des rerolls
            local giveRerollBtn = CreateStyledButton(buttonContainer, "Donner Reroll", THEME.accent, THEME.accentHover)
            giveRerollBtn:Dock(RIGHT)
            giveRerollBtn:SetWide(130)
            giveRerollBtn:SetTooltip("Donner un ou plusieurs rerolls à ce joueur")
            
            giveRerollBtn.DoClick = function()
                if LocalPlayer():GetManaRerolls() <= 0 then
                    LocalNotif("Vous n'avez pas de rerolls !", ScrW(), 0, 50, 1.5)
                    return
                end
                
                Derma_StringRequest(
                    "Don de reroll à " .. v:Nick(),
                    "Combien de rerolls souhaitez-vous donner ? (Vous possédez " .. LocalPlayer():GetManaRerolls() .. " rerolls)",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif("Vous devez saisir un nombre !", ScrW(), 0, 50)
                            return
                        elseif tonumber(text) <= 0 then
                            LocalNotif("Le nombre doit être positif !", ScrW(), 0, 50)
                            return
                        elseif tonumber(text) > LocalPlayer():GetManaRerolls() then
                            LocalNotif("Vous n'avez pas assez de rerolls !", ScrW(), 0, 50)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("friend")
                        net.WriteString("reroll")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
            
            -- Désactiver les boutons si aucun reset/reroll disponible
            giveResetBtn.Think = function(self)
                self:SetEnabled(LocalPlayer():GetManaResets() > 0)
                self:SetAlpha(LocalPlayer():GetManaResets() > 0 and 255 or 100)
            end
            
            giveRerollBtn.Think = function(self)
                self:SetEnabled(LocalPlayer():GetManaRerolls() > 0)
                self:SetAlpha(LocalPlayer():GetManaRerolls() > 0 and 255 or 100)
            end
        end
    end
    
    -- Initialiser la liste des joueurs
    CreatePlayerList()
    
    -- Configurer le filtrage
    searchBox.OnValueChange = function(self, value)
        CreatePlayerList(value)
    end
    
    -- Mettre à jour dynamiquement la position des éléments
    searchPanel.PerformLayout = function(self, w, h)
        searchBox:SetPos(w - 320, 10)
    end
    
    -- Fonction pour mettre à jour le panel au resize
    self.OnSizeChanged = function(self, w, h)
        if IsValid(mainMenu) then
            mainMenu:SetPos(w - mainMenu:GetWide() - 40, 5)
        end
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    draw.RoundedBox(6, 0, 0, w, h, THEME.bg)
    
    -- Barre de titre
    draw.RoundedBoxEx(6, 0, 0, w, 40, THEME.header, true, true, false, false)
end

function PANEL:PerformLayout(w, h)
    self.lblTitle:SetSize(w/3, 38)  -- Limiter la largeur du titre
    
    -- Centrer le titre
    self.lblTitle:SetPos(w/2 - self.lblTitle:GetWide()/2, 0)

    if IsValid(self.Cl) then
        self.Cl:SetPos(w - 36, 4)
        self.Cl:SetSize(32, 32)
    end
end

vgui.Register("Mana.StatsToGive", PANEL, "DFrame")

--------------------------------------------------------------------------
--------------------------------------------------------------------------

function Mana.Vgui:NotifAdmin(msg)
    local w = ScrW()
    LocalNotif( msg or "Données incorrectes", w, 0, 50, 5 )   
end

function Mana.Vgui:OpenAdminPanel()
    if not Mana.Config.AdminCmdAccess[LocalPlayer():GetUserGroup()] then return end
    if IsValid(self.AdminMenu) then self.AdminMenu:Remove() end
    self.AdminMenu = vgui.Create("Mana.StatsForAdmin")
end

--------------------------------------------------------------------------
-- NOUVELLE INTERFACE D'ADMINISTRATION
--------------------------------------------------------------------------

-- Configurations visuelles pour l'interface d'administration moderne
local THEME = {
    bg = Color(25, 30, 40, 230),
    panel = Color(35, 40, 50, 230),
    header = Color(45, 50, 60, 230),
    accent = Color(0, 120, 215),
    accentHover = Color(0, 150, 255),
    warning = Color(215, 55, 55),
    warningHover = Color(255, 70, 70),
    success = Color(55, 170, 55),
    successHover = Color(70, 200, 70),
    text = Color(230, 230, 230),
    textDark = Color(180, 180, 180),
    textDisabled = Color(120, 120, 120),
    border = Color(60, 65, 75, 230)
}

-- Fonction pour créer un bouton stylisé
local function CreateStyledButton(parent, text, color, hoverColor)
    local btn = vgui.Create("DButton", parent)
    btn:SetText("")
    
    local btnColor = color or THEME.accent
    local btnHoverColor = hoverColor or THEME.accentHover
    
    btn.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, self:IsHovered() and btnHoverColor or btnColor)
        
        -- Effet de pression
        if self:IsDown() then
            draw.RoundedBox(4, 2, 2, w-4, h-4, ColorAlpha(THEME.panel, 50))
        end
        
        draw.SimpleText(text, "ManaAdmin.ButtonText", w/2, h/2, THEME.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return btn
end

-- Fonction pour créer un panneau d'onglet stylisé
local function CreateTabPanel(parent)
    local tabPanel = vgui.Create("DPanel", parent)
    tabPanel:Dock(FILL)
    tabPanel:DockMargin(5, 5, 5, 5)
    
    tabPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.panel)
    end
    
    -- Créer le système d'onglets
    tabPanel.tabButtons = {}
    tabPanel.contents = {}
    tabPanel.activeTab = nil
    
    -- Panneau pour les boutons d'onglets
    tabPanel.tabBar = vgui.Create("DPanel", tabPanel)
    tabPanel.tabBar:Dock(TOP)
    tabPanel.tabBar:SetTall(40)
    tabPanel.tabBar.Paint = function(self, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, THEME.header, true, true, false, false)
    end
    
    -- Contenu des onglets
    tabPanel.contentPanel = vgui.Create("DPanel", tabPanel)
    tabPanel.contentPanel:Dock(FILL)
    tabPanel.contentPanel:DockMargin(5, 5, 5, 5)
    tabPanel.contentPanel.Paint = function() end
    
    -- Fonction pour ajouter un onglet
    tabPanel.AddTab = function(self, name, icon)
        local index = table.Count(self.tabButtons) + 1
        
        -- Créer le bouton d'onglet
        local button = vgui.Create("DButton", self.tabBar)
        button:SetText("")
        button:Dock(LEFT)
        button:SetWide(140)
        button:DockMargin(5, 5, 0, 0)
        
        button.Paint = function(s, w, h)
            local isActive = self.activeTab == index
            local bgColor = isActive and THEME.accent or THEME.panel
            
            if s:IsHovered() and not isActive then
                bgColor = ColorAlpha(THEME.accent, 100)
            end
            
            draw.RoundedBox(4, 0, 0, w, h, bgColor)
            
            if icon then
                surface.SetDrawColor(THEME.text)
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(10, h/2-8, 16, 16)
                draw.SimpleText(name, "ManaAdmin.SmallText", 35, h/2, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText(name, "ManaAdmin.SmallText", w/2, h/2, THEME.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        
        -- Créer le contenu de l'onglet
        local content = vgui.Create("DPanel", self.contentPanel)
        content:Dock(FILL)
        content:SetVisible(false)
        content.Paint = function() end
        
        -- Stocker les références
        self.tabButtons[index] = button
        self.contents[index] = content
        
        -- Configurer la fonction de clic
        button.DoClick = function()
            if self.activeTab then
                self.contents[self.activeTab]:SetVisible(false)
            end
            
            self.activeTab = index
            self.contents[index]:SetVisible(true)
        end
        
        -- Si c'est le premier onglet, l'activer par défaut
        if index == 1 then
            self.activeTab = index
            content:SetVisible(true)
        end
        
        return content
    end
    
    return tabPanel
end

-- Interface principale d'administration
local PANEL = {}

function PANEL:Init()
    -- Configuration du cadre principal
    self:SetSize(900, 600)
    self:Center()
    self:SetTitle("Panneau d'administration Mana")
    self:MakePopup()
    self:SetDraggable(true)
    self:ShowCloseButton(true)
    self:SetSizable(true)
    self:SetMinWidth(600)
    self:SetMinHeight(400)
    
    -- Style du panneau
    self.lblTitle:SetFont("ManaAdmin.Title")
    self.lblTitle:SetTextColor(THEME.text)
    
    -- Référence pour l'effet de flou
    self.startTime = SysTime()
    
    -- Créer le panneau d'onglets
    self.tabPanel = CreateTabPanel(self)
    
    -- Onglet de gestion des joueurs individuels
    self:CreatePlayerManagementTab()
    
    -- Onglet d'actions de masse
    self:CreateMassActionsTab()
    
    -- Onglet de commandes manuelles
    self:CreateManualCommandsTab()
    
    -- Onglet des statistiques globales
    self:CreateStatsTab()
end

-- Onglet de gestion des joueurs individuels
function PANEL:CreatePlayerManagementTab()
    local playerTab = self.tabPanel:AddTab("Joueurs", nil)
    
    -- Panneau de recherche
    local searchPanel = vgui.Create("DPanel", playerTab)
    searchPanel:Dock(TOP)
    searchPanel:SetTall(50)
    searchPanel:DockMargin(5, 5, 5, 5)
    searchPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.header)
    end
    
    local searchLabel = vgui.Create("DLabel", searchPanel)
    searchLabel:SetText("Rechercher un joueur:")
    searchLabel:SetTextColor(THEME.text)
    searchLabel:SetFont("ManaAdmin.Text")
    searchLabel:SizeToContents()
    searchLabel:SetPos(10, 15)
    
    local searchBox = vgui.Create("DTextEntry", searchPanel)
    searchBox:Dock(RIGHT)
    searchBox:DockMargin(10, 10, 10, 10)
    searchBox:SetWide(300)
    searchBox:SetPlaceholderText("Nom, SteamID, SteamID64...")
    searchBox:SetDrawLanguageID(false)
    
    -- Liste des joueurs
    local playerList = vgui.Create("DScrollPanel", playerTab)
    playerList:Dock(FILL)
    playerList:DockMargin(5, 5, 5, 5)
    
    -- Styliser la barre de défilement
    local scrollBar = playerList:GetVBar()
    scrollBar:SetWide(8)
    function scrollBar:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnUp:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnDown:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.accent)
    end
    
    -- Fonction pour créer les éléments de joueur
    local function CreatePlayerItems(filter)
        playerList:Clear()
        
        local players = player.GetAll()
        
        -- Filtrer les joueurs si nécessaire
        if filter and filter ~= "" then
            local filteredPlayers = {}
            
            for _, ply in pairs(players) do
                local name = ply:Nick():lower()
                local steamID = ply:SteamID():lower()
                local steamID64 = ply:SteamID64():lower()
                
                filter = filter:lower()
                
                if string.find(name, filter, 1, true) or 
                   string.find(steamID, filter, 1, true) or 
                   string.find(steamID64, filter, 1, true) then
                    table.insert(filteredPlayers, ply)
                end
            end
            
            players = filteredPlayers
        end
        
        -- Créer un élément pour chaque joueur
        for _, ply in pairs(players) do
            local playerPanel = vgui.Create("DPanel", playerList)
            playerPanel:Dock(TOP)
            playerPanel:SetTall(120)
            playerPanel:DockMargin(0, 0, 0, 5)
            
            playerPanel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, THEME.panel)
                
                -- Ligne du haut (nom et SteamID)
                draw.RoundedBoxEx(4, 0, 0, w, 30, THEME.header, true, true, false, false)
                draw.SimpleText(ply:Nick(), "ManaAdmin.SubTitle", 10, 15, THEME.accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(ply:SteamID(), "ManaAdmin.SmallText", w - 10, 15, THEME.textDark, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                
                -- Informations de mana
                local statsY = 40
                draw.SimpleText(ply:GetManaResets() .. " resets, " .. ply:GetManaRerolls() .. " rerolls, " .. ply:GetMana() .. "/" .. ply:GetMaxMana() .. " mana", 
                               "ManaAdmin.Text", 10, statsY, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                
                -- Informations de statistiques
                local statsDisplay = ""
                if LocalPlayer()._allManaStats and LocalPlayer()._allManaStats[ply:SteamID()] then
                    local stats = LocalPlayer()._allManaStats[ply:SteamID()]
                    statsDisplay = "Stats: D(" .. stats.Damage .. ") S(" .. stats.Speed .. ") R(" .. stats.Resistance .. ") V(" .. stats.Vitality .. ")"
                end
                
                draw.SimpleText(statsDisplay, "ManaAdmin.Text", 10, statsY + 25, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                
                -- Magie
                local magic = ply:GetManaMagic()
                if magic and magic ~= "" then
                    draw.SimpleText("Magie: " .. magic, "ManaAdmin.Text", 10, statsY + 50, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
            
            -- Conteneur pour les boutons
            local buttonContainer = vgui.Create("DPanel", playerPanel)
            buttonContainer:Dock(BOTTOM)
            buttonContainer:SetTall(35)
            buttonContainer:DockMargin(5, 0, 5, 5)
            buttonContainer.Paint = function() end
            
            -- Boutons d'action - Ajouter des rerolls
            local addRerollBtn = CreateStyledButton(buttonContainer, "Ajouter Rerolls", THEME.accent)
            addRerollBtn:Dock(LEFT)
            addRerollBtn:SetWide(120)
            addRerollBtn:DockMargin(0, 0, 5, 0)
            addRerollBtn.DoClick = function()
                Derma_StringRequest(
                    "Ajouter des rerolls",
                    "Combien de rerolls voulez-vous ajouter à " .. ply:Nick() .. "?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            notification.AddLegacy("Veuillez entrer un nombre valide", NOTIFY_ERROR, 3)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("reroll")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(ply)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
            
            -- Bouton pour retirer des rerolls
            local removeRerollBtn = CreateStyledButton(buttonContainer, "Retirer Rerolls", THEME.warning, THEME.warningHover)
            removeRerollBtn:Dock(LEFT)
            removeRerollBtn:SetWide(120)
            removeRerollBtn:DockMargin(0, 0, 5, 0)
            removeRerollBtn.DoClick = function()
                Derma_StringRequest(
                    "Retirer des rerolls",
                    "Combien de rerolls voulez-vous retirer à " .. ply:Nick() .. "?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            notification.AddLegacy("Veuillez entrer un nombre valide", NOTIFY_ERROR, 3)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("removereroll")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(ply)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
            
            -- Bouton pour ajouter du mana
            local addManaBtn = CreateStyledButton(buttonContainer, "Ajouter Mana", THEME.accent)
            addManaBtn:Dock(LEFT)
            addManaBtn:SetWide(120)
            addManaBtn:DockMargin(0, 0, 5, 0)
            addManaBtn.DoClick = function()
                Derma_StringRequest(
                    "Ajouter du mana",
                    "Combien de mana voulez-vous ajouter à " .. ply:Nick() .. "?",
                    "100",
                    function(text)
                        if not tonumber(text) then
                            notification.AddLegacy("Veuillez entrer un nombre valide", NOTIFY_ERROR, 3)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("mana")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(ply)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
            
            -- Bouton pour ajouter des statistiques
            local addStatsBtn = CreateStyledButton(buttonContainer, "Ajouter Stats", THEME.accent)
            addStatsBtn:Dock(LEFT)
            addStatsBtn:SetWide(120)
            addStatsBtn:DockMargin(0, 0, 5, 0)
            addStatsBtn.DoClick = function()
                Derma_StringRequest(
                    "Ajouter des statistiques",
                    "Combien de points de statistiques voulez-vous ajouter à " .. ply:Nick() .. "?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            notification.AddLegacy("Veuillez entrer un nombre valide", NOTIFY_ERROR, 3)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("stats")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(ply)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
            
            -- Bouton pour ajouter des resets
            local addResetBtn = CreateStyledButton(buttonContainer, "Ajouter Resets", THEME.accent)
            addResetBtn:Dock(LEFT)
            addResetBtn:SetWide(120)
            addResetBtn:DockMargin(0, 0, 5, 0)
            addResetBtn.DoClick = function()
                Derma_StringRequest(
                    "Ajouter des resets",
                    "Combien de resets voulez-vous ajouter à " .. ply:Nick() .. "?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            notification.AddLegacy("Veuillez entrer un nombre valide", NOTIFY_ERROR, 3)
                            return
                        end
                        
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("reset")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(ply)
                        net.SendToServer()
                    end,
                    function() end
                )
            end
        end
    end
    
    -- Initialiser la liste des joueurs
    CreatePlayerItems()
    
    -- Configurer le filtrage
    searchBox.OnValueChange = function(self, value)
        CreatePlayerItems(value)
    end
end

-- Onglet d'actions de masse
function PANEL:CreateMassActionsTab()
    local massTab = self.tabPanel:AddTab("Actions de masse", nil)
    
    local scrollPanel = vgui.Create("DScrollPanel", massTab)
    scrollPanel:Dock(FILL)
    
    -- Styliser la barre de défilement
    local scrollBar = scrollPanel:GetVBar()
    scrollBar:SetWide(8)
    function scrollBar:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnUp:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnDown:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.border)
    end
    function scrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.accent)
    end
    
    -- Section pour les actions de masse
    local actionPanel = vgui.Create("DPanel", scrollPanel)
    actionPanel:Dock(TOP)
    -- Augmenter la hauteur de 350 à 400 pour éviter la coupure
    actionPanel:SetTall(400)
    actionPanel:DockMargin(5, 5, 5, 5)
    
    actionPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.panel)
        draw.RoundedBoxEx(4, 0, 0, w, 30, THEME.header, true, true, false, false)
        draw.SimpleText("Actions pour tous les joueurs", "ManaAdmin.SubTitle", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Section des rerolls
    local rerollPanel = vgui.Create("DPanel", actionPanel)
    rerollPanel:Dock(TOP)
    rerollPanel:SetTall(100)
    rerollPanel:DockMargin(10, 40, 10, 10)
    
    rerollPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.header)
        draw.SimpleText("Distribution de rerolls", "ManaAdmin.Text", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local rerollAmount = vgui.Create("DNumberWang", rerollPanel)
    rerollAmount:Dock(LEFT)
    rerollAmount:DockMargin(10, 40, 10, 10)
    rerollAmount:SetWide(100)
    rerollAmount:SetMin(1)
    rerollAmount:SetMax(100)
    rerollAmount:SetValue(1)
    
    -- Modification 2: Changer la couleur du bouton de vert à bleu
    local giveRerollsBtn = CreateStyledButton(rerollPanel, "Donner des rerolls à tous les joueurs", THEME.accent, THEME.accentHover)
    giveRerollsBtn:Dock(LEFT)
    giveRerollsBtn:DockMargin(0, 40, 10, 10)
    giveRerollsBtn:SetWide(300)
    
    giveRerollsBtn.DoClick = function()
        local amount = rerollAmount:GetValue()
        
        if amount <= 0 then
            notification.AddLegacy("Veuillez entrer un nombre positif", NOTIFY_ERROR, 3)
            return
        end
        
        Derma_Query(
            "Êtes-vous sûr de vouloir donner " .. amount .. " rerolls à tous les joueurs?",
            "Confirmation",
            "Oui", function()
                net.Start("Mana:GiveManaItems")
                net.WriteString("admin")
                net.WriteString("massreroll")
                net.WriteInt(amount, 16)
                net.SendToServer()
                
                notification.AddLegacy("Attribution de " .. amount .. " rerolls à tous les joueurs", NOTIFY_GENERIC, 3)
            end,
            "Non", function() end
        )
    end
    
    -- Section du mana
    local manaPanel = vgui.Create("DPanel", actionPanel)
    manaPanel:Dock(TOP)
    manaPanel:SetTall(100)
    manaPanel:DockMargin(10, 10, 10, 10)
    
    manaPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.header)
        draw.SimpleText("Distribution de mana", "ManaAdmin.Text", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local manaAmount = vgui.Create("DNumberWang", manaPanel)
    manaAmount:Dock(LEFT)
    manaAmount:DockMargin(10, 40, 10, 10)
    manaAmount:SetWide(100)
    manaAmount:SetMin(100)
    manaAmount:SetMax(10000)
    manaAmount:SetValue(100)
    
    -- Modification 2: Changer la couleur du bouton de vert à bleu
    local giveManaBtn = CreateStyledButton(manaPanel, "Augmenter le mana max de tous les joueurs", THEME.accent, THEME.accentHover)
    giveManaBtn:Dock(LEFT)
    giveManaBtn:DockMargin(0, 40, 10, 10)
    giveManaBtn:SetWide(300)
    
    giveManaBtn.DoClick = function()
        local amount = manaAmount:GetValue()
        
        if amount <= 0 then
            notification.AddLegacy("Veuillez entrer un nombre positif", NOTIFY_ERROR, 3)
            return
        end
        
        Derma_Query(
            "Êtes-vous sûr de vouloir augmenter le mana max de tous les joueurs de " .. amount .. "?",
            "Confirmation",
            "Oui", function()
                net.Start("Mana:GiveManaItems")
                net.WriteString("admin")
                net.WriteString("massmana")
                net.WriteInt(amount, 16)
                net.SendToServer()
                
                notification.AddLegacy("Augmentation du mana max de " .. amount .. " pour tous les joueurs", NOTIFY_GENERIC, 3)
            end,
            "Non", function() end
        )
    end
    
    -- Section des resets
    local resetPanel = vgui.Create("DPanel", actionPanel)
    resetPanel:Dock(TOP)
    resetPanel:SetTall(100)
    resetPanel:DockMargin(10, 10, 10, 10)
    
    resetPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.header)
        draw.SimpleText("Distribution de resets", "ManaAdmin.Text", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local resetAmount = vgui.Create("DNumberWang", resetPanel)
    resetAmount:Dock(LEFT)
    resetAmount:DockMargin(10, 40, 10, 10)
    resetAmount:SetWide(100)
    resetAmount:SetMin(1)
    resetAmount:SetMax(10)
    resetAmount:SetValue(1)
    
    -- Modification 2: Changer la couleur du bouton de vert à bleu
    local giveResetBtn = CreateStyledButton(resetPanel, "Donner des resets à tous les joueurs", THEME.accent, THEME.accentHover)
    giveResetBtn:Dock(LEFT)
    giveResetBtn:DockMargin(0, 40, 10, 10)
    giveResetBtn:SetWide(300)
    
    giveResetBtn.DoClick = function()
        local amount = resetAmount:GetValue()
        
        if amount <= 0 then
            notification.AddLegacy("Veuillez entrer un nombre positif", NOTIFY_ERROR, 3)
            return
        end
        
        Derma_Query(
            "Êtes-vous sûr de vouloir donner " .. amount .. " resets à tous les joueurs?",
            "Confirmation",
            "Oui", function()
                net.Start("Mana:GiveManaItems")
                net.WriteString("admin")
                net.WriteString("massreset")
                net.WriteInt(amount, 16)
                net.SendToServer()
                
                notification.AddLegacy("Attribution de " .. amount .. " resets à tous les joueurs", NOTIFY_GENERIC, 3)
            end,
            "Non", function() end
        )
    end
end

-- Onglet de commandes manuelles
function PANEL:CreateManualCommandsTab()
    local cmdTab = self.tabPanel:AddTab("Commandes", nil)
    
    local cmdPanel = vgui.Create("DPanel", cmdTab)
    cmdPanel:Dock(FILL)
    cmdPanel:DockMargin(5, 5, 5, 5)
    
    cmdPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.panel)
        draw.RoundedBoxEx(4, 0, 0, w, 30, THEME.header, true, true, false, false)
        draw.SimpleText("Commandes manuelles", "ManaAdmin.SubTitle", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Titre des instructions
    local titleLabel = vgui.Create("DLabel", cmdPanel)
    titleLabel:SetPos(10, 40)
    titleLabel:SetText("Commandes disponibles (clic droit pour copier):")
    titleLabel:SetFont("ManaAdmin.Text")
    titleLabel:SetTextColor(THEME.text)
    titleLabel:SizeToContents()
    
    -- Liste des commandes avec possibilité de copier
    local commands = {
        {cmd = "mana steamid64 amount", desc = "Ajoute du mana maximum au joueur"},
        {cmd = "reset steamid64 amount", desc = "Ajoute des resets au joueur"},
        {cmd = "stats steamid64 amount", desc = "Ajoute des points de stats au joueur"},
        {cmd = "reroll steamid64 amount", desc = "Ajoute des rerolls au joueur"},
        {cmd = "removereroll steamid64 amount", desc = "Retire des rerolls au joueur"},
        {cmd = "get steamid64", desc = "Récupère les informations du joueur"}
    }
    
    -- Créer un panneau cliquable pour chaque commande
    local yPos = 70
    for i, cmdInfo in ipairs(commands) do
        local cmdButton = vgui.Create("DButton", cmdPanel)
        cmdButton:SetPos(20, yPos)
        cmdButton:SetSize(600, 25)
        cmdButton:SetText("")
        
        cmdButton.Paint = function(self, w, h)
            local bgColor = self:IsHovered() and ColorAlpha(THEME.accent, 50) or Color(0, 0, 0, 0)
            draw.RoundedBox(4, 0, 0, w, h, bgColor)
            
            local textColor = self:IsHovered() and THEME.text or THEME.textDark
            draw.SimpleText(i .. ". " .. cmdInfo.cmd .. " - " .. cmdInfo.desc, "ManaAdmin.SmallText", 0, h/2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        -- Copier la commande au clic gauche
        cmdButton.DoClick = function()
            SetClipboardText(cmdInfo.cmd)
            notification.AddLegacy("Commande copiée dans le presse-papier", NOTIFY_GENERIC, 2)
        end
        
        -- Copier la commande au clic droit
        cmdButton.DoRightClick = function()
            SetClipboardText(cmdInfo.cmd)
            notification.AddLegacy("Commande copiée dans le presse-papier", NOTIFY_GENERIC, 2)
        end
        
        yPos = yPos + 30
    end
    
    -- Exemple d'utilisation
    local exampleLabel = vgui.Create("DLabel", cmdPanel)
    exampleLabel:SetPos(20, yPos + 10)
    exampleLabel:SetText("Exemple: reroll 76561198012345678 10")
    exampleLabel:SetFont("ManaAdmin.SmallText")
    exampleLabel:SetTextColor(THEME.textDark)
    exampleLabel:SizeToContents()
    
    -- Zone de saisie de commande
    local cmdEntry = vgui.Create("DTextEntry", cmdPanel)
    cmdEntry:SetPos(10, yPos + 50)
    cmdEntry:SetSize(600, 30)
    cmdEntry:SetPlaceholderText("Entrez votre commande...")
    
    -- Bouton d'exécution
    local executeBtn = CreateStyledButton(cmdPanel, "Exécuter", THEME.accent)
    executeBtn:SetPos(620, yPos + 50)
    executeBtn:SetSize(150, 30)
    
    executeBtn.DoClick = function()
        local cmd = cmdEntry:GetValue()
        
        if cmd == "" then
            notification.AddLegacy("Veuillez entrer une commande", NOTIFY_ERROR, 3)
            return
        end
        
        net.Start("Mana:GiveManaItems")
        net.WriteString("admin")
        net.WriteString("cmd")
        net.WriteString(cmd)
        net.SendToServer()
        
        cmdEntry:SetValue("")
    end
    
    -- Astuce pour coller rapidement la commande
    local pasteHintLabel = vgui.Create("DLabel", cmdPanel)
    pasteHintLabel:SetPos(10, yPos + 90)
    pasteHintLabel:SetText("Astuce: Utilisez CTRL+V pour coller rapidement une commande copiée")
    pasteHintLabel:SetFont("ManaAdmin.SmallText")
    pasteHintLabel:SetTextColor(THEME.accent)
    pasteHintLabel:SizeToContents()
end

-- Onglet des statistiques globales
function PANEL:CreateStatsTab()
    local statsTab = self.tabPanel:AddTab("Statistiques", nil)
    
    local statsPanel = vgui.Create("DPanel", statsTab)
    statsPanel:Dock(FILL)
    statsPanel:DockMargin(5, 5, 5, 5)
    
    statsPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, THEME.panel)
        draw.RoundedBoxEx(4, 0, 0, w, 30, THEME.header, true, true, false, false)
        draw.SimpleText("Statistiques globales", "ManaAdmin.SubTitle", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Calcul des statistiques globales
    local function CalculateGlobalStats()
        local players = player.GetAll()
        local totalMana = 0
        local totalMaxMana = 0
        local totalRerolls = 0
        local totalResets = 0
        local magicCounts = {}
        
        for _, ply in pairs(players) do
            totalMana = totalMana + ply:GetMana()
            totalMaxMana = totalMaxMana + ply:GetMaxMana()
            totalRerolls = totalRerolls + ply:GetManaRerolls()
            totalResets = totalResets + ply:GetManaResets()
            
            local magic = ply:GetManaMagic()
            if magic and magic ~= "" then
                magicCounts[magic] = (magicCounts[magic] or 0) + 1
            end
        end
        
        -- Trier les magies par popularité
        local sortedMagics = {}
        for magic, count in pairs(magicCounts) do
            table.insert(sortedMagics, {name = magic, count = count})
        end
        
        table.sort(sortedMagics, function(a, b) return a.count > b.count end)
        
        return {
            players = #players,
            totalMana = totalMana,
            totalMaxMana = totalMaxMana,
            totalRerolls = totalRerolls,
            totalResets = totalResets,
            magics = sortedMagics
        }
    end
    
    -- Affichage des statistiques
    local function UpdateStats()
        statsPanel:Clear()
        
        local titleLabel = vgui.Create("DLabel", statsPanel)
        titleLabel:SetPos(10, 5)
        titleLabel:SetSize(400, 20)
        titleLabel:SetFont("ManaAdmin.SubTitle")
        titleLabel:SetTextColor(THEME.text)
        titleLabel:SetText("Statistiques globales")
        
        local stats = CalculateGlobalStats()
        
        local infoPanel = vgui.Create("DPanel", statsPanel)
        infoPanel:SetPos(10, 40)
        infoPanel:SetSize(400, 150)
        infoPanel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, THEME.header)
            
            draw.SimpleText("Joueurs connectés: " .. stats.players, "ManaAdmin.Text", 10, 25, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("Total mana: " .. stats.totalMana .. "/" .. stats.totalMaxMana, "ManaAdmin.Text", 10, 50, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("Total rerolls: " .. stats.totalRerolls, "ManaAdmin.Text", 10, 75, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("Total resets: " .. stats.totalResets, "ManaAdmin.Text", 10, 100, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        -- Distribution des magies
        local magicPanel = vgui.Create("DPanel", statsPanel)
        magicPanel:SetPos(10, 200)
        magicPanel:SetSize(400, 30 + 25 * math.min(10, #stats.magics))
        
        magicPanel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, THEME.header)
            draw.SimpleText("Distribution des magies:", "ManaAdmin.Text", 10, 15, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            
            for i, magic in ipairs(stats.magics) do
                if i <= 10 then
                    local percentage = (magic.count / stats.players) * 100
                    draw.SimpleText(i .. ". " .. magic.name .. ": " .. magic.count .. " (" .. math.Round(percentage, 1) .. "%)", 
                                   "ManaAdmin.SmallText", 20, 30 + (i-1) * 25, THEME.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
        end
        
        -- Bouton de rafraîchissement
        local refreshBtn = CreateStyledButton(statsPanel, "Rafraîchir", THEME.accent)
        refreshBtn:SetPos(300, 10)
        refreshBtn:SetSize(100, 20)
        refreshBtn.DoClick = function()
            UpdateStats()
            notification.AddLegacy("Statistiques mises à jour", NOTIFY_GENERIC, 2)
        end
    end
    
    -- Initialisation des statistiques
    UpdateStats()
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
    
    -- Fond principal
    draw.RoundedBox(6, 0, 0, w, h, THEME.bg)
    
    -- Barre de titre
    draw.RoundedBoxEx(6, 0, 0, w, 30, THEME.header, true, true, false, false)
end

vgui.Register("Mana.StatsForAdmin", PANEL, "DFrame")

--------------------------------------------------------------------------
--------------------------------------------------------------------------

local INIT = {}

function INIT:Init()
    mstats = self
    self:SetSize(500, 242)
    self:MakePopup()
    self:DockPadding(8, 42, 8, 8)
    self:Center()
    self.Sys = SysTime()
    self:SetTitle("Gardienne de la tour aux Grimoires")
    self.lblTitle:SetFont("mana.title")
    self:ShowCloseButton(false)
    self.Cl = vgui.Create("DButton", self)
    self.Cl:SetText("r")
    self.Cl:SetTextColor(color_white)
    self.Cl:SetFont("Marlett")

    self.Cl.DoClick = function()
        self:Remove()
    end

    self.Cl.Paint = function(s, w, h) end

    self.Option = vgui.Create("DButton", self)
    self.Option:SetSize(300, 48)
    self.Option:SetFont("mana.stat")
    self.Option:SetTextColor(color_white)
    self.Option.Paint = function(s, w, h)
        surface.SetDrawColor(s:IsHovered() and Color(36, 165, 213) or Color(255, 255, 255, 150))
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    self.Option:SetPos(self:GetWide() / 2 - self.Option:GetWide() / 2, 156)
    self.Option:SetText(LocalPlayer():GetMaxMana() == 0 and "Lis le grimoire" or "Reroll magie (" .. LocalPlayer():GetManaRerolls() .. " reroll" .. (LocalPlayer():GetManaRerolls()>1 and "s" or "") .. ")")
    self.Option.DoClick = function(s)
        local isFirst = LocalPlayer():GetMaxMana() == 0
        if (not isFirst and LocalPlayer():GetManaRerolls() <= 0) then
            Derma_Message("Vous n'avez aucun reroll", "Erreur", "Ok")
            return
        end
        net.Start("Mana:RequestPower")
        net.WriteBool(isFirst)
        net.SendToServer()
        self:Remove()
    end
end

function INIT:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    draw.RoundedBox(4, 0, 0, w, h, Color(16, 16, 16, 200))

    if (LocalPlayer():GetMaxMana() <= 0) then
        draw.SimpleText("Vous n'avez pas encore votre grimoire", "mana.stat", w / 2, 64, Color(255, 255, 255, 100), 1, 1)
        draw.SimpleText("Si tu décides de le prendre", "mana.stat", w / 2, 92, Color(255, 255, 255, 100), 1, 1)
        draw.SimpleText("Ta vie changera radicalement", "mana.stat", w / 2, 120, Color(255, 255, 255, 100), 1, 1)
    else
        draw.SimpleText("Ta magie est puissante", "mana.stat", w / 2, 64, Color(255, 255, 255, 100), 1, 1)
        draw.SimpleText("Mais veux tu tenter ta chance", "mana.stat", w / 2, 92, Color(255, 255, 255, 100), 1, 1)
        draw.SimpleText("Pour peut etre en apprendre une nouvelle?", "mana.stat", w / 2, 120, Color(255, 255, 255, 100), 1, 1)
    end
end

function INIT:PerformLayout(w, h)
    self.lblTitle:SetSize(w, 38)
    self.lblTitle:SetPos(8, 0)

    if IsValid(self.Cl) then
        self.Cl:SetPos(w - 36, 4)
        self.Cl:SetSize(32, 32)
    end
end

vgui.Register("Mana.Book", INIT, "DFrame")

net.Receive("Mana:OpenBookShelve", function()
    vgui.Create("Mana.Book")
end)

hook.Add("PlayerButtonDown", "Mana.OpenMenu", function(ply, btn)
    if not IsFirstTimePredicted() then return end
    if (Mana.Config.StatKey == btn) then
        vgui.Create("Mana.Stats")
    end
    if (Mana.Config.DefaultSwitch == btn) then
        RunConsoleCommand("use", Mana.Config.DefaultWeapon)
    end
end)

if IsValid(mstats) then
    mstats:Remove()
end