concommand.Add("print_job_ids", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    
    print("=== LISTE DES IDS DE JOBS ===")
    for id, data in pairs(RPExtraTeams or team.GetAllTeams()) do
        local name = data.name or team.GetName(id)
        print("ID: " .. id .. " | Nom: " .. name)
    end
    print("==============================")
end)