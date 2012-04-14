-- Contain the functions that create or manipulate strategies

-- Create and return a strategy
function CreateStrategy(bg)
    local playersNum    = bg.playersNum;
    local numGroups     = playersNum / 5;
    local BGStrategies  = bg.strategy;
    
    -- Debug
    print("Number of strategy disponible for this BG: " .. # BGStrategies);
    
    -- we are going to need this number to save the strategy
    local stratNum = 
            floor(math.random(100) / (100 / # BGStrategies) + 1); -- Magic Numbers!!!
    
    local strategy = BGStrategies[stratNum];
    
    -- Print the intro
    local intro = "Battle Advisor:\n<" .. bg.title ..
        "> Strategy Selected: " .. strategy.title;
    print(intro);
    
    return strategy;
end

-- Announce the Strategy
function AnnounceStrategy(bg)
    
end

-- Give every member of the BG or Raid their role.
function ConstructRoles(bg, strategy, selection)
    -- In function of the strategy selected we either have a per person or
    -- per group strategy
    
    -- We get the number of players currently in the BG
    local numPlayers = GetNumRaidMembers();
    local maxPlayers = bg.playersNum;
    
    -- Variables for the incoming role loop
    local roles = strategy.roles;
    local already_selected = {}; --  all the groups that have already been selected
                                 --  for role.
                                 
    -- For each roles in the strategy
    for i=1, # roles do
        local role; 
        
        -- We need to know if we have a 'party' role
    end
             
end

--  Perform a selection of players for each of the different roles in a strategy
function perPlayerSelection(bg, strategy, selection)
    -- We gonna go through all the players in the bg currently
    for i=1, maxPlayers do
        -- the player we are going to record
        player = {GetRaidRosterInfo(i)};
            
        table.insert();
    end
end

-- Perform a selection of groups for each of the different roles in a strategy
function perGroupSelection(selection)

end

-- Print a Multiline String to the BG chat
function battleground_message(message)
    local s = { strsplit("\n", message) };
    
    local size = # s;

    -- if we actually have a valid table
    if (size ~= nil) then
        --  for each entry in the table
        for i=1, size do
            -- we send the message to the battleground chat
            if UnitInBattleground("player") then
                SendChatMessage(s[i], "BATTLEGROUND", nil, nil);
            elseif UnitInRaid("player") then
                SendChatMessage(s[i], "RAID", nil, nil);
            else
                print(s[i]);
            end
        end
    end
    
    -- we have sent every lines of the string to /bg
end

function assignGroups(spots, selection, maxGroups)
    -- Now we need to know which group is going to go on O
    local selected = {};
    
    -- for each spot needed pick a group and add it to the selection
    for i=1, spots do
    
        local valid = false;
        
        -- We go through randomly through the groups until we have one that
        -- it a valid addition to the selection
        while valid == false do
            local group = math.random(maxGroups);
            
            if (isContained(group, selection) ) then
                -- we have already selectioned this group
            else
                -- we have not yet selected this group
                -- yay!
                -- we add it to the table
                table.insert(selection, group);
                table.insert(selected, group);
                valid = true;
            end
        end
        
    end
    
    return selected, selection;
end

function niceGroupsText(groups)
    local nicetext = "";
    local size = # groups;
    
    for i=1, size do
        -- if it is not the last element
        if i ~= size then
            nicetext = nicetext .. "[" .. groups[i] .. "]" .. ", ";
        else
            nicetext = nicetext .. "[" .. groups[i] .. "]";
        end
    end
    
    return nicetext;
end
