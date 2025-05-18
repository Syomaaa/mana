Mana.Config = {}
Mana.Config.ManaPerSkill = 25

Mana.Config.OverTimeGain = {
    [24000] = 300,
    [12000] = 200,
    [9000] = 175,
    [6000] = 150,
    [3000] = 100,
    [0] = 35
}

Mana.Config.SkillStep = {100, 200}
Mana.Config.RegenerationPercent = 1
Mana.Config.RenenerationTime = 0.6

Mana.Config.DefaultWeapon = "keys"

if CLIENT then
    Mana.Config.StatKey = KEY_I
    Mana.Config.DefaultSwitch = KEY_EQUAL
end

----------------------------------
--Pour rappel : les commandes chat accessibles sont les suivantes :
--  /manadouble     = même chose que la commande console "muramana_setdouble"
--  /manareset      = même chose que la commande console "muramana_addresets" 
--  /manaincrease   = même chose que la commande console "muramana_increasemana"
--  /manastats      = même chose que la commande console "muramana_increasestats"
-- /manaadmin       = pour ouvrir le menu admin
----------------------------------
Mana.Config.AdminCmdAccess = {
    ["superadmin"] = true,
    ["admin"] = false,
}

--Est-ce que les points stats donnés par les administrateurs sont permanents ?
--true = permanent, ne sera pas reset par les resets des joueurs
--false = sera reset à 0 automatiquement dès qu'un joueur fera reset
Mana.Config.PermaStatsGiven = true

--Quel est le modèle du NPC ?
Mana.Config.NpcModel = "models/mona/genshin_impact/rstar/mona/mona_npc.mdl"

Mana.Config.Magic = {}

--1
-- Mana.Config.Magic["Sanguinaire"] = {
--     Rarity = 95,
--     Image = "materials/magies/Magie-Sang.png",
--     Spells = {
--         ["Sanguinaire 1"] = {
--             ManaRequired = 500, --Min maxmana required to unlock this weapon
--             WeaponClass = "magiesang1", --Weapon Class you want to give
--             Cost = 5 --it takes 3 mana per second
--         },
--         ["Sanguinaire 2"] = {
--             ManaRequired = 3000, --Min maxmana required to unlock this weapon
--             WeaponClass = "magiesang2", --Weapon Class you want to give
--             Cost = 50 --it takes 3 mana per second
--         },
--         ["Mana Shield"] = {
--             ManaRequired = 4500, --Min maxmana required to unlock this weapon
--             WeaponClass = "manashield", --Weapon Class you want to give
--             Cost = 75 --it takes 3 mana per second
--         },
--         ["Sanguinaire 3"] = {
--             ManaRequired = 6000, --Min maxmana required to unlock this weapon
--             WeaponClass = "zonesanguinaire", --Weapon Class you want to give
--             Cost = 100 --it takes 3 mana per second
--         },
--         ["Sanguinaire 4"] = {
--             ManaRequired = 12000, --Min maxmana required to unlock this weapon
--             WeaponClass = "magiesang4", --Weapon Class you want to give
--             Cost = 200 --it takes 3 mana per second
--         },
--         ["Mana Detection"] = {
--             ManaRequired = 20000, --Min maxmana required to unlock this weapon
--              WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
--             Cost = 300 --it takes 3 mana per second
--         },
       
--     }
-- }

--2
Mana.Config.Magic["Amour"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Amour.png",
    Spells = {
        ["Amour 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieamour1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Amour 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieamour2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Amour 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieamour3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Amour 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieamour4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
            WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--3
Mana.Config.Magic["Musique"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Musique.png",
    Spells = {
        ["Musique 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemusique1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Musique 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemusique2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Musique 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemusique3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Musique 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemusique4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--4
Mana.Config.Magic["Controle"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Controle.png",
    Spells = {
        ["Controle 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecontrole1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Controle 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecontrole2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Controle 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecontrole3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Controle 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecontrole4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--5
Mana.Config.Magic["Teleportation"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Teleportation.png",
    Spells = {
        ["Teleportation 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magietp1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Teleportation 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "weapon_portal", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Teleportation 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietp3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Teleportation 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietp4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--6
Mana.Config.Magic["Eau"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Eau.png",
    Spells = {
        ["Eau 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieeau1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Eau 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieeau2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Eau 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieeau3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Eau 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "requin_suiton", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--7
Mana.Config.Magic["Soin"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Soin.png",
    Spells = {
        ["Soin 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoin1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Soin 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoin2", --Weapon Class you want to give
            Cost = 40 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Soin 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoin3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Soin 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoin4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--8
Mana.Config.Magic["Poison"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Poison.png",
    Spells = {
        ["Poison 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepoison1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Poison 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepoison2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Poison 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepoison3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Poison 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepoison4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--9
Mana.Config.Magic["Glace"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Glace.png",
    Spells = {
        ["Glace 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "glace_one", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Glace 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "glace_two", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Glace 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieglace3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Glace 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "glace_four", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--10
Mana.Config.Magic["Foudre"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Foudre.png",
    Spells = {
        ["Foudre 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudre1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Foudre 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudre2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Foudre 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudre3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Foudre 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudre4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--11
Mana.Config.Magic["Explosion"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Explosion.png",
    Spells = {
        ["Explosion 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieexplo1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Explosion 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieexplo2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Explosion 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "explosion3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Explosion 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieexplosion4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--12
Mana.Config.Magic["Renforcement"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Renforcement.png",
    Spells = {
        ["Renforcement 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magierenfo1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Renforcement 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magierenfo2", --Weapon Class you want to give
            Cost = 150 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Renforcement 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magierenfo3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Renforcement 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magierenfo4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--13
Mana.Config.Magic["Lumiere"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Lumiere.png",
    Spells = {
        ["Lumiere 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magielumiere1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Lumiere 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "lumiere_two", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Lumiere 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "lumiere3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Lumiere 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magielumiere4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--14
Mana.Config.Magic["Tenebres"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Tenebre.png",
    Spells = {
        ["Tenebres 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magietenebre1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Tenebres 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "darkness2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Tenebres 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "tenebre3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Tenebres 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietenebre4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--15
Mana.Config.Magic["Feu"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Feu.png",
    Spells = {
        ["Feu 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeu1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Feu 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeu2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Feu 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "fire_mha", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Feu 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeu4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--16
Mana.Config.Magic["Roche"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Roche.png",
    Spells = {
        ["Roche 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieroche1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Roche 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieroche2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Roche 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "roche3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Roche 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "v3", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--17
Mana.Config.Magic["Temps"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Temps.png",
    Spells = {
        ["Temps 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magietemps1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Temps 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "gpow_timecontrol", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Temps 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietemps3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Temps 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "weapon_temps4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--18
Mana.Config.Magic["Vent"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Vent.png",
    Spells = {
        ["Vent 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magievent1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Vent 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "flight_swep", --Weapon Class you want to give
            Cost = 150 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Vent 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magievent3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Vent 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magievent4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--19
Mana.Config.Magic["Picturale"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Pictural.png",
    Spells = {
        ["Picturale 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepictural1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Picturale 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepictural2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Picturale 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "feuviolet", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Picturale 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "yc_metamorphe_swep", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--20
Mana.Config.Magic["Os"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Os.png",
    Spells = {
        ["OS 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieos1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["OS 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieos2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["OS 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieos3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["OS 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieos4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--21
Mana.Config.Magic["Plante"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Plante.png",
    Spells = {
        ["Plante 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieplante1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
          },
        ["Plante 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieplante2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Plante 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieplante3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Plante 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieplante4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--22
Mana.Config.Magic["Anti Magie"] = {
    Rarity = 0.09,
    Image = "materials/magies/Magie-Anti-magie.png",
    Spells = {
        ["Anti Magie 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "antimagie2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Anti Magie 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "antimagie3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Anti Magie 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "antimagie4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Anti Magie 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "antimagie5", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--23
Mana.Config.Magic["Gaz"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Gaz.png",
    Spells = {
        ["Gaz 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "gaz1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Gaz 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "gaz2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Gaz 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "gaz3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Gaz 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "gaz4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--24
Mana.Config.Magic["Spirit"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Spirit.png",
    Spells = {
        ["Spirit 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "weapon_particle_thom_un-spirit", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Spirit 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiespirit2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Spirit 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "weapon_energystorm", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Spirit 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "spirit4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--25
Mana.Config.Magic["Cremation"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Cremation.png",
    Spells = {
        ["Cremation 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "cremation1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Cremation 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "cremation2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Cremation 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "cremation3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Cremation 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "cremation4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--26
Mana.Config.Magic["Crystal"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Cristal.png",
    Spells = {
        ["Crystal 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "crystal_tire", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Crystal 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "crystal2", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Crystal 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecrystal3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Crystal 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "chutecrystal", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--27
Mana.Config.Magic["Gravite"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Gravite.png",
    Spells = {
        ["Gravite 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiegravite1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Gravite 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiegravite2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Gravite 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiegravite3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Gravite 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiegravite4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--28
Mana.Config.Magic["Mercure"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Mercure.png",
    Spells = {
        ["Mercure 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "mercureun", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Mercure 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "omnishield", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Mercure 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "mercure3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Mercure 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "mercure", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--29
Mana.Config.Magic["Miroir"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Miroir.png",
    Spells = {
        ["Miroir 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemiroir1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Miroir 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemiroir2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Miroir 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemiroir3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Miroir 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemiroir4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--30
Mana.Config.Magic["Illusion"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Illusion.png",
    Spells = {
        ["Illusion 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieillusion1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Illusion 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieillusion2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Illusion 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieillusion3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Illusion 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieillusion4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--31
Mana.Config.Magic["Piege"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Piege.png",
    Spells = {
        ["Piege 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepiege1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Piege 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepiege2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Piege 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepiege3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Piege 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiepiege4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--32
Mana.Config.Magic["Lune"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Lune.png",
    Spells = {
        ["Lune 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magielune1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Lune 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magielune2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Lune 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magielune3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Lune 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magielune4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--33
Mana.Config.Magic["Jugement"] = {
    Rarity = 0.1,
    Image = "materials/magies/Magie-Jugement.png",
    Spells = {
        ["Jugement 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiejugement1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Jugement 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiejugement2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Jugement 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiejugement3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Jugement 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiejugement4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--34
Mana.Config.Magic["Soleil"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Soleil.png",
    Spells = {
        ["Soleil 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoleil1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Soleil 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoleil2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Soleil 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoleil3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Soleil 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesoleil4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--35
Mana.Config.Magic["Songe"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Songe.png",
    Spells = {
        ["Songe 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesonge1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Songe 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesonge2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Songe 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesonge3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Songe 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesonge4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--36
Mana.Config.Magic["Sable"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Sable.png",
    Spells = {
        ["Sable 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesable1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Sable 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesable2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Sable 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesable3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Sable 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesable4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--37
Mana.Config.Magic["Fils"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Fils.png",
    Spells = {
        ["Fils 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefils1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Fils 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefils2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Fils 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefils3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Fils 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefils4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--38
Mana.Config.Magic["Feerique"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Feerique.png",
    Spells = {
        ["Feerique 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeerique1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Feerique 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeerique2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Feerique 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeerique3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Feerique 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefeerique4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--39
Mana.Config.Magic["Brume"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Brume.png",
    Spells = {
        ["Brume 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebrume1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Brume 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebrume2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Brume 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebrume3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Brume 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebrume4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--40
Mana.Config.Magic["Invocation"] = {
    Rarity = 0.1,
    Image = "materials/reroll/grimoire.png",
    Spells = {
        ["Invocation 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "invocation1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Invocation 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "invocation2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Invocation 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "invocation3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Invocation 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "invocation4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--41
Mana.Config.Magic["Incandescente"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Incandescente.png",
    Spells = {
        ["Incandescente 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieincandescente1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Incandescente 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieincandescente2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Incandescente 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieincandescente3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Incandescente 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieincandescente4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--42
Mana.Config.Magic["Infini"] = {
    Rarity = 0.1,
    Image = "materials/magies/Magie-Infini.png",
    Spells = {
        ["Infini 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfini1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Infini 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfini2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Infini 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfini3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Infini 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfini4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--43
Mana.Config.Magic["Neige"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Neige.png",
    Spells = {
        ["Neige 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieneige1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Neige 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieneige2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Neige 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieneige3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Neige 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieneige4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--44
Mana.Config.Magic["Astral"] = {
    Rarity = 0.1,
    Image = "materials/magies/Magie-Astral.png",
    Spells = {
        ["Astral 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieastral1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Astral 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieastral2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Astral 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieastral3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Astral 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieastral4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--45
Mana.Config.Magic["Désintégration"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Desintegration.png",
    Spells = {
        ["Désintégration 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiedesintegration1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Désintégration 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiedesintegration2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Désintégration 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiedesintegration3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Désintégration 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiedesintegration4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--46
Mana.Config.Magic["Ombre"] = {
    Rarity = 0.1,
    Image = "materials/magies/Magie-Ombre.png",
    Spells = {
        ["Ombre 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieombre1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Ombre 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "cloaking-3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Ombre 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieombre3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Ombre 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieombre4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--47
Mana.Config.Magic["Bestial"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Bestial.png",
    Spells = {
        ["Bestial 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebestial1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Bestial 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebestial2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Bestial 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebestial3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Bestial 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiebestial4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--48
Mana.Config.Magic["Invocation d'arme"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Invocation-armes.png",
    Spells = {
        ["Invocation d'arme 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "berserker1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Invocation d'arme 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "berserker2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Invocation d'arme 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "berserker3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Invocation d'arme 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "berserker4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--49
Mana.Config.Magic["Typhon"] = {
    Rarity = 95,
    Image = "materials/magies/Magie-Typhon.png",
    Spells = {
        ["Typhon 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magietyphon1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Typhon 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietyphon2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Typhon 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietyphon3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Typhon 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magietyphon4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
}

--50
Mana.Config.Magic["Corruption"] = {
    Rarity = 0.1,
    Image = "materials/magies/Magie-Corruption.png",
    Spells = {
        ["Corruption 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecorruption1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Corruption 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecorruption2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Corruption 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecorruption3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Corruption 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiecorruption4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--51
Mana.Config.Magic["Celeste"] = {
    Rarity = 0.09,
    Image = "materials/magies/Magie-Celeste.png",
    Spells = {
        ["Celeste 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieceleste1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Celeste 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieceleste2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Celeste 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieceleste3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Celeste 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieceleste4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 
--52
Mana.Config.Magic["Infernal"] = {
    Rarity = 0.09,
    Image = "materials/magies/Magie-Infernal.png",
    Spells = {
        ["Infernal 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfernal1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Infernal 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfernal2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Infernal 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfernal3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Infernal 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieinfernal4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--53
Mana.Config.Magic["Etoile"] = {
    Rarity = 0.1,
    Image = "materials/magies/Magie-Etoile.png",
    Spells = {
        ["Etoile 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magieetoile1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Etoile 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieetoile2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Etoile 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieetoile3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Etoile 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magieetoile4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--54
Mana.Config.Magic["Foudre Noir"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Foudre-noir.png",
    Spells = {
        ["Foudre Noir 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudrenoir1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Foudre Noir 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "foudrenoir_two", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Foudre Noir 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudrenoir3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Foudre Noir 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiefoudrenoir4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--55
Mana.Config.Magic["Saisonniere"] = {
    Rarity = 0,
    Image = "materials/reroll/grimoire.png",
    Spells = {
        ["Saisonniere 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesaisonniere1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Saisonniere 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesaisonniere2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Saisonniere 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesaisonniere3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Saisonniere 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiesaisonniere4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--56
Mana.Config.Magic["Metal"] = {
    Rarity = 4.5,
    Image = "materials/magies/Magie-Metal.png",
    Spells = {
        ["Metal 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemetal1", --Weapon Class you want to give
            Cost = 5 --it takes 3 mana per second
        },
        ["Metal 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemetal2", --Weapon Class you want to give
            Cost = 50 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Metal 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemetal3", --Weapon Class you want to give
            Cost = 100 --it takes 3 mana per second
        },
        ["Metal 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiemetal4", --Weapon Class you want to give
            Cost = 200 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--57
Mana.Config.Magic["Stellaire"] = {
    Rarity = 0.09,
    Image = "materials/magies/Magie-Stellaire.png",
    Spells = {
        ["Stellaire 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "magiestellaire1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Stellaire 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiestellaire2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Stellaire 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiestellaire3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Stellaire 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "magiestellaire4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 

--58
Mana.Config.Magic["Transformation"] = {
    Rarity = 0,
    Image = "materials/reroll/grimoire.png",
    Spells = {
        ["Transformation 1"] = {
            ManaRequired = 500, --Min maxmana required to unlock this weapon
            WeaponClass = "transfo1", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Transformation 2"] = {
            ManaRequired = 3000, --Min maxmana required to unlock this weapon
            WeaponClass = "transfo2", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Shield"] = {
            ManaRequired = 4500, --Min maxmana required to unlock this weapon
            WeaponClass = "manashield", --Weapon Class you want to give
            Cost = 75 --it takes 3 mana per second
        },
        ["Transformation 3"] = {
            ManaRequired = 6000, --Min maxmana required to unlock this weapon
            WeaponClass = "transfo3", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Transformation 4"] = {
            ManaRequired = 12000, --Min maxmana required to unlock this weapon
            WeaponClass = "transfo4", --Weapon Class you want to give
            Cost = 0 --it takes 3 mana per second
        },
        ["Mana Detection"] = {
            ManaRequired = 20000, --Min maxmana required to unlock this weapon
             WeaponClass = "weapon_mana_detection", --Weapon Class you want to give
            Cost = 300 --it takes 3 mana per second
        },
       
    }
} 