
hook.Add( "HUDShouldDraw", "DefautHUD", function( name )
	if ( name == "CHudHealth" or name == "CHudBattery" or name == "DarkRP_Hungermod" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" ) then
	    return false
	end
end )
    -- groupe d image
local bcilux1 = Material("blackclovermatilux/blackcloverilux.png", "noclamp smooth")
local bcilux2 = Material("blackclovermatilux/moneybcilux.png", "noclamp smooth")
local bcilux3 = Material("blackclovermatilux/steakbcilux.png", "noclamp smooth")

local show = nil
local function AzeriaRespX(sx) return ScrW() / 1920 * sx end
local function AzeriaRespY(sy) return ScrH() / 1080 * sy end
local function AzeriaResp(sx, sy) return AzeriaRespX(sx), AzeriaRespY(sy) end    

local function DrawPModelPanel()
    local pPanel = vgui.Create("DPanel")
    pPanel:SetPos(AzeriaResp(75, 825))
    pPanel:SetSize(AzeriaResp(120, 120))
    function pPanel:Paint() end

    show = vgui.Create("DModelPanel", pPanel)
    show:Dock(FILL)
    show:SetModel(LocalPlayer():GetModel())
    show:SetCamPos(Vector(40, -0, 60))
    show:SetFOV(55)
    show:SetLookAt(Vector(0, 0, 60))
    show.Think = function()
        if not LocalPlayer():Alive() then
            pPanel:SetSize(AzeriaResp(50, 50))
        else
            pPanel:SetSize(AzeriaResp(180, 180))
        end
        
        show:SetModel(LocalPlayer():GetModel())
    end
    show.LayoutEntity = function()
        return false
    end
    return show
end

local currentHp = 0
local currentHP_percent

local currentMana = 0
local currentMana_percent

--[[
hook.Add("HUDPaint", "Azeria_BlackCloverHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end  -- Vérification du joueur

    local currentMana = Lerp(FrameTime() * 1.5, 0, ply:GetMana() or 0)
    local maxMana = ply:GetMaxMana() or 100  -- Par défaut 100 si non défini
    local currentMana_percent = math.Clamp(currentMana / maxMana, 0, 1)

    -- Dessin de la barre de mana
    draw.RoundedBox(4, AzeriaRespX(280), AzeriaRespY(974), currentMana_percent * AzeriaRespX(300), AzeriaRespY(35), Color(0, 0, 255, 255))
    draw.SimpleText(math.floor(ply:GetMana() or 0) .. "/" .. maxMana, "font_bc_partout", AzeriaRespX(430), AzeriaRespY(991.5), Color(255, 255, 255), 1, 1)
end)
]]
