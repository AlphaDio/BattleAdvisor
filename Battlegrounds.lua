
-- Load the different data for each battlegrounds supported, like the strategies
-- available, or the maximum numbers of people in the battleground.
function loadBattlegrounds()

    print("Battlegrounds loaded!");
    
    -- Alterac Valley
    AV  =   {
        -- Second element, the max number of players
        playersNum = 40, -- Anti Magic Numbers
        title = "Alterac Valley",
        nick    = "AV",
        
        -- First element, the possible strategies
        strategy = {
            {   title = "BackCap",
                roles = {
                    {4, "Assaulters", 
                        "Must capture the Alliance Graveyards up to Aid Station and kill Vann"},
                    {2, "Backcappers", 
                        "Must destroy the 2 Stoneheart towers, once destroyed must help Defense"},
                    {2, "Defenders", 
                        "Must prevent the destruction of Tower Point and Iceblood Tower, then defend the base"}
                },
                group = true,
                bg = "Alterac Valley"
            },
            {   title = "Galv",
                roles = {
                    {3, "War on Galv",
                        "Must defend Galv, if Galv dies then help offense up to Vann"},
                    {3, "Assaulters",
                        "Must capture the Alliance Graveyards up to Aid Station and kill Vann"},
                    {2, "Grave Robbers",
                        "Must capture as much graveyard as possible, with those closest to the base in priority"}
                },
                group = true,
                bg = "Alterac Valley"
            },
            {   title = "ZERG!!!",
                roles = {
                    {5, "Assaulters",
                        "Must mindlessly get to Aid Station, bypassing towers and capturing Stormpike and Aid Station GY"},
                    {2, "Defenders",
                        "Must regroup and defend Frostwolf base, with the graveyard in priority, most important role of the strategy"},
                    {1, "Stormpike GY Defenders", 
                        "Must assault Stormpike Graveyard and defend it until captured"}
                },
                group = true,
                bg = "Alterac Valley"
            }
        }
    };
    
    -- Isle Of Conquest
    
    IoC     = {
        
        playersNum = 40,
        title = "Isle of Conquest",
        nick    = "IoC",
        
        strategy = {
            {   title = "Air Rush",
                roles = {
                    {1, "Hangar Guard",
                        "Must prevent the enemy from recapping the Hangar"},
                    {3, "Paratrooper",
                        "Must get to the hangar ASAP and use the airship to jump inside the enemy base"},
                    {2, "Capper",
                        "Must capture any node close to the enemy base"},
                    {2, "Mid Sentry",
                        "Must prevent the enemy from having the Docks and help assault West Gate with vehicules"}
                },
                group = true,
                bg = "Isle of Conquest"
            },
            {   title = "Peon Rush",
                roles = {
                    {2, "Defenders",
                        "Must defend our gates and our fortress, beware enemy paratroopers"},
                    {4, "Sappers",
                        "Must capture the Workshop and use the seaforium bombs to breach Front Gate"},
                    {1, "Heavy Armor",
                        "Must capture the Docks and use vehicules to breach West Gate"},
                    {1, "Door Guards",
                        "Must defend the enemy West Gate to protect the bombs and vehicules"}
                },
                group = true,
                bg = "Isle of Conquest"
            },
            {   title = "Vehicule Rush",
                roles = {
                    {3, "Drivers", 
                        "Must capture the Docks and use vehicules to breach West Gate, IMPORTANT: use the Catapults" ..
                        " to get inside enemy fort"},
                    {2, "Engineers",
                        "Must capture the Workshop and use its vehicules to breach West Gate"},
                    {2, "Door Guards",
                        "Must defend the enemy West Gate to protect the bombs and vehicules"},
                    {1, "Robbers",
                        "Must capture the Quarry and Refinery nodes to ensure vehicule buff, then pester the Hangar node"}
                },
                group = true,
                bg = "Isle of Conquest"
            }
        }
    };
    
    
    -- Arathi Basin
    
    AB  = { 
        playersNum = 15,
        title = "Arathi Basin",
        nick    = "AB",
        
        strategy = {
            {   title = "Lock",
                roles = {
                    {1, "Farm Assault", 
                        "Must capture and defend the Farm node"},
                    {1, "Blacksmith Assault",
                        "Must capture and defend the Blacksmith node"},
                    {1, "Lumber Mill Assault",
                        "Must capture and defend the Lumber Mill node"}
                },
                group = true,
                bg = "Arathi Basin"
            },
            {   title = "ZERG!!!",
                roles = {
                    {2, "Assaulters",
                        "Must regroup at the closest node, and as ONE BIG GROUP (7+), attack the closest enemy node"},
                    {1, "Guards",
                        "Must protect the last node captured until another is captured, MOST IMPORTANT ROLE"}
                },
                group = true,
                bg = "Arathi Basin"
            }
        }
        
    };
    
    
    -- Warsong Gulch
    
    WSG = { 
        playersNum = 10,
        title = "Warsong Gulch",
        nick    = "WSG",
        
        strategy = {
            {   title = "D&O",
                roles = {
                    {1, "Defense", 
                        "must guard the flag and pursue and take down enemy flag carrier if failing"},
                    {1, "Offense",
                        "Must go after the flag and escort the flag carrier staying together as a GROUP"}
                },
                group = true,
                bg = "Warsong Gulch"
            }
        }
        
    };
    
    
    -- Eye of the Storm
    
    EotS = { 
        playersNum = 15,
        title = "Eye of the Storm",
        nick    = "EotS",
        
        strategy = {
            {   title = "Don't Stand In Mid",
                roles = {
                    {1, "Fel Reaver Defender", 
                        "Must defend the Fel Reaver node"},
                    {1, "Blood Elf Tower Defender",
                        "Must go after the flag and escort the flag carrier staying together as a GROUP"},
                    {1, "Swingers",
                        "Must get to the center of the bg and defend it, ONE person should get the flag and cap it, " ..
                        "if a node is lost, must help recapture it"}
                },
                group = true,
                bg = "Eye of the Storm"
            }
        }
                
    };
    
    WG = {
        playersNum = 40,
        title = "Wintergrasp",
        nick    = "WG",
        
        strategy = {
            {   title = "",
                roles = {
                    {2, "South Defense",
                        "Must defend the southern towers, DO NOT MAKE ANY VEHICULES AT THE SOUTH WORKSHOPS"},
                    {4, "West Assaulters",
                        "Must assault the west walls and get the allys busy! The priority is the wall, only make Siege Engine"},
                    {2, "East Assaulters",
                        "Must assault the east walls, maintain control of Sunken Ring WS, and get to the freaking door, MOST IMPORTANT ROLE IN THE STRAT!"}
                
                },
                group = true,
                bg = "Wintergrasp"
                
            }
        },
        advice = "Do NOT make vehicules in the southern workshops. Focus on one wall, do not disperse. If you have a demolisher, your target is the " ..
        "walls."
    }
    
    -- Twin Peaks
    TP = {
    
    }
    
    -- Tol Barad
    TB = {
    
    }
    
    -- Battle of Gilneas
    BoG = {
    
    }
    
    -- We create a nice little table to get the Bg fast, this is the official of what
    -- battlegrounds are supported
    battlegrounds = { ["AV"] = AV, ["WSG"] = WSG, ["AB"] = AB, ["IoC"] = IoC, ["WG"] = WG,
        ["BoG"] = BoG, ["TP"] = TP, ["EotS"] = EotS, ["TB"] = TB};
    
end

-- Get a Battleground object table from a battleground name
function getBattlegroundFromString(bg_name)
    local bg = nil;
    
    -- Bunch of if statements, yeaaaahhh
    if (bg_name == "Alterac Valley" or bg_name == "AV") then
        bg = battlegrounds["AV"];
    end
    if (bg_name == "Arathi Basin" or bg_name == "AB") then
        bg = battlegrounds["AB"];
    end
    if (bg_name == "Warsong Gulch" or bg_name == "WSG") then
        bg = battlegrounds["WSG"];
    end
    if (bg_name == "Isle of Conquest" or bg_name == "IoC") then
        bg = battlegrounds["IoC"];
    end
    if (bg_name == "Wintergrasp" or bg_name == "WG") then
        bg = battlegrounds["WG"];
    end
    if (bg_name == "Twin Peaks" or bg_name == "TP") then
        bg = battlegrounds["TP"];
    end
    if (bg_name == "Battle of Gilneas" or bg_name == "BoG") then
        bg = battlegrounds["BoG"];
    end
    if (bg_name == "Tol Barad" or bg_name == "TB") then
        bg = battlegrounds["TB"];
    end
    
    print(bg);
    
    return bg;
end

-- Check if the location is a BG
function isBG(location)
    local result = false;
    
    for k, v in pairs(battlegrounds) do
        if location == v.title then
            result = true;
        end
    end
    
    return result;
end
