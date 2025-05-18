local function implementStats(data)
    if not IsValid(LocalPlayer()) then
        timer.Simple(1, function()
            implementStats(data)
        end)
        return
    else
        LocalPlayer()._manaStats = data
    end
end

net.Receive("Mana:BroadcastStats", function()
    implementStats(net.ReadTable())
end)

net.Receive("Mana:AdminPanel", function()
    LocalPlayer()._allManaStats = net.ReadTable()
    Mana.Vgui:OpenAdminPanel()
end)

net.Receive("Mana:BroadcastManaInfos", function()

    local hasInfos = net.ReadBool()
    local message = "Aucunes informations !"

    if hasInfos then
        local manaInfos = net.ReadTable()
        local statsMsg = ""
        manaInfos = manaInfos[1]    
        if manaInfos.stats then
            manaInfos.stats = util.JSONToTable(manaInfos.stats)
            if manaInfos.stats.Resistance then
                statsMsg = " stats R("..manaInfos.stats.Resistance..") D("..manaInfos.stats.Damage..") S("..manaInfos.stats.Speed..") V("..manaInfos.stats.Vitality..")"
            end
        end
        message = "reset("..(manaInfos.reset or 0)..") mana("..(manaInfos.mana or 0)..") rerolls("..(manaInfos.mana or 0)..") statsgive("..(manaInfos.statsgive or 0)..")"..statsMsg
    end

    Mana.Vgui:NotifAdmin(message)

end)