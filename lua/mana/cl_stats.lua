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

local options = {
    [1] = {
        Name = "Health",
        Icon = surface.GetTextureID("gonzo/health.vtf"),
        Stat = function(val) return "+" .. val .. " PV maximum" end,
        Max = 1000
    },
    [2] = {
        Name = "Speed",
        Icon = surface.GetTextureID("gonzo/speed.vtf"),
        Stat = function(val) return "+" .. val .. " extra units/sec" end,
        Max = 250
    },
    [3] = {
        Name = "Resistance",
        Icon = surface.GetTextureID("gonzo/resistance.vtf"),
        Stat = function(val) return "Dégats subis réduit de " .. val .. "%" end,
        Max = 0
    },
    [4] = {
        Name = "Damage",
        Icon = surface.GetTextureID("gonzo/damage.vtf"),
        Stat = function(val) return "Dégats augmenté de " .. val .. "%" end,
        Max= 0
    }
}

Mana.Vgui = Mana.Vgui or {}

local PANEL = {}

function PANEL:Init()
    mstats = self
    self:SetSize(500, 385)
    self:MakePopup()
    self:DockPadding(8, 42, 8, 8)
    self.lblTitle:SetFont("mana.title")
    self:SetBackgroundBlur(true)
    self:Center()
    self:SetTitle("Mana Stats")
    self:ShowCloseButton(false)
    self.Cl = vgui.Create("DButton", self)
    self.Cl:SetText("r")
    self.Cl:SetTextColor(color_white)
    self.Cl:SetFont("Marlett")
    self.Cl.DoClick = function()
        if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end
        self:Remove()
    end
    self.Cl.Paint = function(s, w, h) end
    self.Sys = SysTime()

    local giveMenu = vgui.Create("DImageButton", self)
    giveMenu:SetToolTip("Donner à des amis")
    giveMenu:SetSize(20,20)
    giveMenu:SetPos(self:GetWide()*0.4 - giveMenu:GetWide()*0.5, 10) 
    giveMenu:SetImage("icon16/group_add.png")
    giveMenu.DoClick = function()
        if IsValid(Mana.Vgui.GiveMenu) then Mana.Vgui.GiveMenu:Remove() end
        Mana.Vgui.GiveMenu = vgui.Create("Mana.StatsToGive")
        self:Remove()
    end

    local top = vgui.Create("DPanel", self) 
    top:Dock(TOP)
    top:SetTall(46)
    top:DockMargin(0, 0, 0, 8)
    top.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, color_black)
        draw.SimpleText("Vous avez " ..  LocalPlayer():GetManaResets() .. " reset disponible", "mana.stat", 4, 10, Color(255, 255, 255, 150), 0, 1)
        draw.SimpleText("Clique gauche: +1 | Clique molette: +5 | Clique droit: +10","Arial", 4, h-10, Color(255, 255, 255, 150), 0, 1)
    end
    top.Reset = vgui.Create("DButton", top)
    top.Reset:Dock(RIGHT)
    top.Reset:SetText("")
    top.Reset.Paint = function(s, w, h)
        surface.SetDrawColor((s:IsHovered() and LocalPlayer():GetManaResets() > 0) and Color(255, 106, 0) or Color(255, 255, 255, 50))
        surface.DrawOutlinedRect(0, 0, w, h)

        draw.SimpleText("Reset", "mana.smoll", w / 2, h / 2, Color(255, 255, 255, LocalPlayer():GetManaResets() > 0 and 200 or 50), 1, 1)
    end
    top.Reset.DoClick = function()
        if (LocalPlayer():GetManaResets() > 0) then
            Derma_Query("Etes vous sur de vouloir reset vos compétences?", "Confirmation", "Oui", function()
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

    for k = 1, 4 do
        local info = options[k]
        local pnl = vgui.Create("DPanel", self)
        pnl:Dock(TOP)
        pnl:SetTall(64)
        pnl.add = vgui.Create("DButton", pnl)
        pnl.add:Dock(RIGHT)
        pnl.add:SetWide(52)
        pnl.add:DockMargin(8, 8, 8, 8)
        pnl.add:SetFont("mana.title")
        pnl.add:SetText("+")
        pnl.add:SetTextColor(color_white)

        pnl.add.Paint = function(s, w, h)
            surface.SetDrawColor((s:IsHovered() and LocalPlayer():GetManaSkillPoints() > 0) and Color(255, 106, 0) or Color(255, 255, 255, 50))
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        pnl.add.DoClick = function()
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
        pnl.add.DoRightClick = function()
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
        pnl.add.DoMiddleClick = function()
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
        pnl:DockMargin(0, 0, 0, 8)

        pnl.Paint = function(s, w, h)
            surface.SetDrawColor(255, 255, 255, 50)
            surface.DrawOutlinedRect(0, 0, w, h)
            surface.SetDrawColor(255, 255, 255, 175)
            surface.SetTexture(info.Icon)
            surface.DrawTexturedRect(0, 0, h, h)
            local tx, _ = draw.SimpleText(info.Name, "mana.stat", h+2, 10, color_white)
            draw.SimpleText("[" .. comma_value(LocalPlayer():GetManaStats(info.Name)) .. " Point".. (LocalPlayer():GetManaStats(info.Name)>1 and "s" or "") .." attribué".. (LocalPlayer():GetManaStats(info.Name)>1 and "s" or "") .."]", "mana.smoll", h + tx + 6, 14, Color(255,216,0))
            local test = draw.SimpleText(info.Stat(LocalPlayer()["GetMana" .. info.Name](LocalPlayer())), "mana.stat", h+10, 32, Color(255, 255, 255, 100))
            draw.SimpleText(info.Max ~= -1 and "Max: " .. info.Max .. "%" or "", "mana.smoll", h+357, 5, Color(255,255,255, 25), TEXT_ALIGN_RIGHT)
        end
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    draw.RoundedBox(4, 0, 0, w, h, Color(16, 16, 16, 200))
    local tx, _ = draw.SimpleText("/" .. math.floor( (LocalPlayer():GetMaxMana() / Mana.Config.ManaPerSkill) + LocalPlayer():GetManaStatsGiven() ), "mana.stat", w - 40, 10, Color(255, 255, 255, 100), TEXT_ALIGN_RIGHT)
    local test = draw.SimpleText(comma_value(LocalPlayer():GetManaSkillPoints()),  "mana.stat", w - 40 - tx, 10, Color(255,216,0), TEXT_ALIGN_RIGHT)
    draw.SimpleText("Point à attribuer:", "mana.stat", w - 40 - tx - 60, 10, Color(255, 255, 255, 200), TEXT_ALIGN_RIGHT)
end

function PANEL:PerformLayout(w, h)
    self.lblTitle:SetSize(w, 38)
    self.lblTitle:SetPos(8, 0)

    if IsValid(self.Cl) then
        self.Cl:SetPos(w - 36, 4)
        self.Cl:SetSize(32, 32)
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

    self:SetSize(500, 385)
    self:MakePopup()
    self:DockPadding(8, 42, 8, 8)
    self.lblTitle:SetFont("mana.title")
    self:SetBackgroundBlur(true)
    self:Center()
    self:SetTitle("Faire un don")
    self:ShowCloseButton(false)

    self.Cl = vgui.Create("DButton", self)
    self.Cl:SetText("r")
    self.Cl:SetTextColor(color_white)
    self.Cl:SetFont("Marlett")

    self.Cl.DoClick = function()
        if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end
        self:Remove()
    end

    self.Cl.Paint = function(s, w, h) end
    self.Sys = SysTime()

    local mainMenu = vgui.Create("DImageButton", self)  
    mainMenu:SetToolTip("Revenir au menu principal")
    mainMenu:SetSize(20,20)
    mainMenu:SetPos(self:GetWide()*0.4 - mainMenu:GetWide()*0.5, 10) 
    mainMenu:SetImage("icon16/application_side_contract.png")
    mainMenu.DoClick = function()
        vgui.Create("Mana.Stats")
        self:Remove()
    end

    local top = vgui.Create("DPanel", self) 
    top:Dock(TOP)
    top:SetTall(80)
    top:DockMargin(0, 0, 0, 8)
    top.Paint = function(s, w, h)
        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.SimpleText("Vous avez " ..  LocalPlayer():GetManaResets() .. " reset disponible", "mana.stat", 4, 14, Color(255, 255, 255, 150), 0, 1)
        draw.SimpleText("Vous avez " ..  LocalPlayer():GetManaRerolls() .. " rerolls disponible", "mana.stat", 4, 39, Color(255, 255, 255, 150), 0, 1)
        draw.SimpleText("Rechercher une personne : ", "mana.stat", 4, 62, Color(255, 255, 255, 150), 0, 1)
    end

    local Scroll = vgui.Create( "DScrollPanel", self )
    Scroll:Dock(TOP)
    Scroll:DockMargin(0, 0, 0, 8)
    Scroll:SetTall(250)
    Scroll.Players  = {}
    Scroll.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    local sbar = Scroll:GetVBar()
    function sbar:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    function sbar.btnUp:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnDown:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnGrip:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(0, 0, w, h)
    end

    local function CreateItemList(filter)

        Scroll:Clear()

        local items = player.GetAll()
        local function filterFunc(options)
            local match = false
            for _, val in pairs (options or {}) do
                if string.match(string.lower(val), string.lower(filter), 1) then
                    match = true 
                end
            end
            return match
        end 

        if filter ~= nil and filter ~= "" then
            items = {}
            local filteredTable = {}

            for k,v in pairs(player.GetAll()) do
                local options = {steamid = v:SteamID(),steamid64 = v:SteamID64(),name = v:Nick(), steamname = v:SteamName()}
                if filterFunc(options) then
                    filteredTable[k] = v 
                end
            end
            items = filteredTable
        end

        for k,v in pairs(items) do
            
            if v == LocalPlayer() then continue end
            
            Scroll.Players[k] = vgui.Create("DPanel", Scroll) 
            Scroll.Players[k]:Dock(TOP)
            Scroll.Players[k]:SetTall(30)
            Scroll.Players[k]:DockMargin(5, 8, 5, 8)
            Scroll.Players[k].Paint = function(s, w, h)
                surface.SetDrawColor(255, 255, 255, 50)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(v:Nick(), "mana.stat", 4, h*0.5, Color(255, 255, 255, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local giveResetBtn = vgui.Create("DButton", Scroll.Players[k])
            giveResetBtn:SetText("")
            giveResetBtn:Dock(RIGHT)
            giveResetBtn:SetWide(85)
            giveResetBtn:DockMargin(0, 3, 8, 3)
            giveResetBtn.Paint = function(s, w, h)
                local clr = Color(255, 255, 255, 150)
                if s:IsHovered() then
                    if LocalPlayer():GetManaResets() > 0 then
                        clr = Color(0, 255, 0, 150)
                    else
                        clr = Color(255, 0, 0, 150)
                    end
                end
                draw.SimpleText("+ reset", "mana.stat", 4, h*0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            giveResetBtn.DoClick = function()
                if LocalPlayer():GetManaResets() <= 0 then 
                    LocalNotif( "Vous n'avez pas de resets !", ScrW(), 0, 50, 1.5 )
                    return 
                end
                Derma_StringRequest(
                    "Don de reset à "..v:Nick(), 
                    "Combien de reset souhaitez-vous donner ? (Vous possédez "..LocalPlayer():GetManaResets().." resets)",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif( "Vous devez saisir un nombre !", ScrW(), 0, 50  )
                            return
                        elseif tonumber(text) <= 0 then
                            LocalNotif( "Le nombre doit être positif !", ScrW(), 0, 50  )
                            return
                        elseif tonumber(text) > LocalPlayer():GetManaResets() then
                            LocalNotif( "Vous n'avez pas assez de resets !", ScrW(), 0, 50  )
                            return
                        end
                        --network
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("friend")
                        net.WriteString("reset")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end

            local giveRerollsBtn = vgui.Create("DButton", Scroll.Players[k])
            giveRerollsBtn:SetText("")
            giveRerollsBtn:Dock(RIGHT)
            giveRerollsBtn:SetWide(85)
            giveRerollsBtn:DockMargin(0, 3, 8, 3)
            giveRerollsBtn.Paint = function(s, w, h)
                local clr = Color(255, 255, 255, 150)
                if s:IsHovered() then
                    if LocalPlayer():GetManaRerolls() > 0 then
                        clr = Color(0, 255, 0, 150)
                    else
                        clr = Color(255, 0, 0, 150)
                    end
                end
                draw.SimpleText("+ rerolls", "mana.stat", 4, h*0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            giveRerollsBtn.DoClick = function()
                if LocalPlayer():GetManaRerolls() <= 0 then 
                    LocalNotif( "Vous n'avez pas de rerolls !", ScrW(), 0, 50, 1.5 )
                    return 
                end
                Derma_StringRequest(
                    "Don de reroll à "..v:Nick(), 
                    "Combien de reroll souhaitez-vous donner ? (Vous possédez "..LocalPlayer():GetManaRerolls().." resets)",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif( "Vous devez saisir un nombre !", ScrW(), 0, 50  )
                            return
                        elseif tonumber(text) <= 0 then
                            LocalNotif( "Le nombre doit être positif !", ScrW(), 0, 50  )
                            return
                        elseif tonumber(text) > LocalPlayer():GetManaRerolls() then
                            LocalNotif( "Vous n'avez pas assez de rerolls !", ScrW(), 0, 50  )
                            return
                        end
                        --network
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("friend")
                        net.WriteString("reroll")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end

        end

    end
    
    CreateItemList()
        
    local searchBox = vgui.Create("DTextEntry", top)
    searchBox:SetTall(22)
    searchBox:DockMargin(250, 0, 10, 8)
    searchBox:Dock(BOTTOM)
    searchBox:SetUpdateOnType(true)
    searchBox:SetDrawLanguageID( false )
    searchBox.OnValueChange = function(s , val)
        CreateItemList(val)
    end
    local whi = Color(255, 255, 255, 150)
    searchBox.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        s:DrawTextEntryText(whi, whi, whi)
    end

end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    draw.RoundedBox(4, 0, 0, w, h, Color(16, 16, 16, 200))
end

function PANEL:PerformLayout(w, h)
    self.lblTitle:SetSize(w, 38)
    self.lblTitle:SetPos(8, 0)

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


local PANEL = {}

function PANEL:Init()

    self:SetSize(500, 385)
    self:MakePopup()
    self:DockPadding(8, 42, 8, 8)
    self.lblTitle:SetFont("mana.title")
    self:SetBackgroundBlur(true)
    self:Center()
    self:SetTitle("Mana Admin")
    self:ShowCloseButton(false)

    self.Cl = vgui.Create("DButton", self)
    self.Cl:SetText("r")
    self.Cl:SetTextColor(color_white)
    self.Cl:SetFont("Marlett")
    self.Cl.DoClick = function()
        if IsValid(Mana.Vgui.LocalNotifPanel) then Mana.Vgui.LocalNotifPanel:Remove() end
        self:Remove()
    end

    self.Cl.Paint = function(s, w, h) end
    self.Sys = SysTime()

    local cmdManual = vgui.Create("DImageButton", self)  
    cmdManual:SetToolTip("Commande manuelle")
    cmdManual:SetSize(20,20)
    cmdManual:SetPos(self:GetWide()*0.4 - cmdManual:GetWide()*0.5, 10) 
    cmdManual:SetImage("icon16/application_xp_terminal.png")
    cmdManual.DoClick = function()
        Derma_StringRequest(
            "Commande manuelle", 
            "Quelle commande voulez-vous exécuter ?\n1: mana steamid64 amount \n2: reset steamid64 amount\n3: stats steamid64 amount\n4: reroll steamid64 amount\n5: get steamid64 \n\n Exemple : reroll 765234564 100",
            "",
            function(text)
                --a client check so it can help us understand what's going on
                local textSplit = string.Explode(" ", text)
                if not textSplit or #textSplit < 2 then
                    LocalNotif( "Pas assez d'arguments", ScrW(), 0, 50  )     
                    return
                elseif not tonumber(textSplit[2]) then
                    LocalNotif( "Le STEAMID 64 n'est pas valide", ScrW(), 0, 50  )     
                    return
                end
                --network
                net.Start("Mana:GiveManaItems")
                net.WriteString("admin")
                net.WriteString("cmd")
                net.WriteString(text)
                net.SendToServer()
            end,
            function(text) end
        )
    end

    local top = vgui.Create("DPanel", self) 
    top:Dock(TOP)
    top:SetTall(30)
    top:DockMargin(0, 0, 0, 8)
    top.Paint = function(s, w, h)
        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.SimpleText("Rechercher une personne : ", "mana.stat", 4, h*0.5, Color(255, 255, 255, 150), 0, 1)
    end

    local Scroll = vgui.Create( "DScrollPanel", self )
    Scroll:Dock(TOP)
    Scroll:DockMargin(0, 0, 0, 8)
    Scroll:SetTall(300)
    Scroll.Players  = {}
    Scroll.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    local sbar = Scroll:GetVBar()
    function sbar:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    function sbar.btnUp:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnDown:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnGrip:Paint( w, h )
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(0, 0, w, h)
    end

    local function CreateItemList(filter)

        Scroll:Clear()

        local items = player.GetAll()
        local function filterFunc(options)
            local match = false
            for _, val in pairs (options or {}) do
                if string.match(string.lower(val), string.lower(filter), 1) then
                    match = true 
                end
            end
            return match
        end 

        if filter ~= nil and filter ~= "" then
            items = {}
            local filteredTable = {}

            for k,v in pairs(player.GetAll()) do
                local options = {steamid = v:SteamID(),steamid64 = v:SteamID64(),name = v:Nick(), steamname = v:SteamName()}
                if filterFunc(options) then
                    filteredTable[k] = v 
                end
            end
            items = filteredTable
        end

        for k,v in pairs(items) do
            
            Scroll.Players[k] = vgui.Create("DPanel", Scroll) 
            Scroll.Players[k]:Dock(TOP)
            Scroll.Players[k]:SetTall(90)
            Scroll.Players[k]:DockMargin(5, 8, 5, 8)
            local vStats = ""
            if LocalPlayer()._allManaStats and LocalPlayer()._allManaStats[v:SteamID()] then
                local st = LocalPlayer()._allManaStats[v:SteamID()]
                vStats = "stats : D("..st.Damage..") S("..st.Speed..") R("..st.Resistance..") V("..st.Vitality.. ")"
            end
            Scroll.Players[k].Paint = function(s, w, h)
                surface.SetDrawColor(255, 255, 255, 50)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(v:Nick(), "mana.stat", 4, 15, Color(255, 106, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(v:GetManaResets().." reset, "..v:GetManaRerolls().." reroll, "..v:GetMana().." mana, statsgive("..v:GetManaStatsGiven()..")", "mana.stat", 4, 35, Color(255, 255, 255, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(vStats, "mana.stat", 4, 55, Color(255, 255, 255, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local giveResetBtn = vgui.Create("DButton", Scroll.Players[k])
            giveResetBtn:SetText("")
            giveResetBtn:Dock(RIGHT)
            giveResetBtn:SetWide(85)
            giveResetBtn:DockMargin(0, 60, 8, 0)
            giveResetBtn.Paint = function(s, w, h)
                local clr = Color(255, 255, 255, 150)
                draw.SimpleText("+ reset", "mana.stat", 4, h*0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)  
            end
            giveResetBtn.DoClick = function()
                Derma_StringRequest(
                    "Donner du reset à "..v:Nick(), 
                    "Combien de reset souhaitez-vous donner ?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif( "La saisie est incorrecte ! Nombre obligatoire", ScrW(), 0, 50  )
                            return
                        end
                        --network
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("reset")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end

            local giveRerollsBtn = vgui.Create("DButton", Scroll.Players[k])
            giveRerollsBtn:SetText("")
            giveRerollsBtn:Dock(RIGHT)
            giveRerollsBtn:SetWide(85)
            giveRerollsBtn:DockMargin(0, 60, 8, 0)
            giveRerollsBtn.Paint = function(s, w, h)
                local clr = Color(255, 255, 255, 150)
                draw.SimpleText("+ rerolls", "mana.stat", 4, h*0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            giveRerollsBtn.DoClick = function()
                Derma_StringRequest(
                    "Donner du reroll à "..v:Nick(), 
                    "Combien de reroll souhaitez-vous donner ?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif( "La saisie est incorrecte ! Nombre obligatoire", ScrW(), 0, 50  )
                            return
                        end
                        --network
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("reroll")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end

            local giveManaBtn = vgui.Create("DButton", Scroll.Players[k])
            giveManaBtn:SetText("")
            giveManaBtn:Dock(RIGHT)
            giveManaBtn:SetWide(85)
            giveManaBtn:DockMargin(0, 60, 8, 0)
            giveManaBtn.Paint = function(s, w, h)
                local clr = Color(255, 255, 255, 150)
                draw.SimpleText("+ mana", "mana.stat", 4, h*0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            giveManaBtn.DoClick = function()
                Derma_StringRequest(
                    "Donner du mana à "..v:Nick(), 
                    "Combien de mana souhaitez-vous donner ?",
                    "1",
                    function(text)
                        print("[DEBUG] "..text)
                        if not tonumber(text) or v:GetMaxMana() <= 0 or tonumber(text) > ( v:GetMaxMana() - v:GetMana() ) and v:GetMaxMana() != v:GetMana() then
                            LocalNotif( "La saisie est incorrecte ! Nombre obligatoire", ScrW(), 0, 50  )
                            -- print sqlite player data
                            print("[DEBUG] "..v:Nick().." "..v:SteamID().." "..v:SteamID64().." "..v:GetMaxMana().." "..v:GetMana())
                            
                            return
                        end
                        --network
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("mana")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end

            local giveStatBtn = vgui.Create("DButton", Scroll.Players[k])
            giveStatBtn:SetText("")
            giveStatBtn:Dock(RIGHT)
            giveStatBtn:SetWide(85)
            giveStatBtn:DockMargin(0, 60, 8, 0)
            giveStatBtn.Paint = function(s, w, h)
                local clr = Color(255, 255, 255, 150)
                draw.SimpleText("+ stats", "mana.stat", 4, h*0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            giveStatBtn.DoClick = function()
                Derma_StringRequest(
                    "Donner du stat à "..v:Nick(), 
                    "Combien de stat souhaitez-vous donner ?",
                    "1",
                    function(text)
                        if not tonumber(text) then
                            LocalNotif( "La saisie est incorrecte ! Nombre obligatoire", ScrW(), 0, 50  )
                            return
                        end
                        --network
                        net.Start("Mana:GiveManaItems")
                        net.WriteString("admin")
                        net.WriteString("stats")
                        net.WriteInt(tonumber(text), 16)
                        net.WriteEntity(v)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end

        end

    end
    
    CreateItemList()
        
    local searchBox = vgui.Create("DTextEntry", top)
    searchBox:DockMargin(250, 3, 10, 3)
    searchBox:Dock(FILL)
    searchBox:SetUpdateOnType(true)
    searchBox:SetDrawLanguageID( false )
    searchBox.OnValueChange = function(s , val)
        CreateItemList(val)
    end
    local whi = Color(255, 255, 255, 150)
    searchBox.Paint = function(s, w, h)
        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        s:DrawTextEntryText(whi, whi, whi)
    end

end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Sys)
    draw.RoundedBox(4, 0, 0, w, h, Color(16, 16, 16, 200))
end

function PANEL:PerformLayout(w, h)
    self.lblTitle:SetSize(w, 38)
    self.lblTitle:SetPos(8, 0)

    if IsValid(self.Cl) then
        self.Cl:SetPos(w - 36, 4)
        self.Cl:SetSize(32, 32)
    end
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