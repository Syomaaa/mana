Mana = Mana or {}

if CLIENT then
    include("mana/sh_meta.lua")
    include("mana/sh_config.lua")
    include("mana/cl_hud.lua")
    include("mana/cl_net.lua")
    include("mana/cl_stats.lua")
    
else
    AddCSLuaFile("mana/sh_meta.lua")
    AddCSLuaFile("mana/cl_hud.lua")
    AddCSLuaFile("mana/cl_net.lua")
    AddCSLuaFile("mana/sh_config.lua")
    AddCSLuaFile("mana/cl_stats.lua")
    include("mana/sh_meta.lua")
    include("mana/sh_config.lua")
    include("mana/sv_net.lua")
    include("mana/sv_sql.lua")
    include("mana/sv_meta.lua")
    resource.AddFile( "materials/gonzo/damage.vtf" )
    resource.AddFile( "materials/gonzo/health.vtf" )
    resource.AddFile( "materials/gonzo/resistance.vtf" )
    resource.AddFile( "materials/gonzo/speed.vtf" )
    resource.AddFile( "materials/lda.png" )
end