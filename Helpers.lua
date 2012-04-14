



-- Create the frame that will be showed when in a BG.
function createBGFrame()

end

-- Battle Advisor Functions

-- BattleAdvisor_CommunicationEvent().
-- @param arg1 message  the message received by the addon.
-- @param arg2 author   the sender of the message.
-- Battle Advisor Battleground Whisper Handler. This function handle when a
-- message is sent and/or receive by the addon. This handle all communications processes of
-- addon.
function BattleAdvisor_CommunicationEvent(arg1, arg2)
    -- do stuffs
end

-- BattleAdvisor_BGEvent().
-- @param arg1 message the message containing the event details.
function BattleAdvisor_BGEvent(arg1)
    -- do stuffs
end

-- A function to register events to the frame.
function registerBAEvents(Frame)
    -- Register the events at the main frame of the application
    
    local events = {};
    
    -- Whenever we change zone, for example enter a battleground
    function events:ZONE_CHANGED_NEW_AREA(...)
        print("Zone Changed!!");
        
        -- Get the location we just entered
        local location = GetRealZoneText();
        
        -- Check if we are actually in a Battleground
        if isBG(location) then
            -- We show the addon
            BA_MainFrame:Show();
        else
            BA_MainFrame:Hide();
        end
    end
    
    -- Whenever an event in the battlegrounds happens
    function events:CHAT_MSG_BATTLEGROUND(...)
        -- The addon should check everytime someone post a message in the battleground
        -- chat.
        BattleAdvisor_BGEvent(arg1);
    end
    
    -- Whenever an event on Horde side happens
    function events:CHAT_MSG_BG_SYSTEM_HORDE(...)
        BattleAdvisor_BGEvent(arg1);
    end
    
    -- Whenever an event on Alliance side happens
    function events:CHAT_MSG_BG_SYSTEM_ALLIANCE(...)
        BattleAdvisor_BGEvent(arg1);
    end
    
    -- Whenever the addon is loaded and its variables available
    function events:ADDON_LOADED(...)
        playerName, playerRealm = UnitName("player", true);
        
        -- Tell the rest of the program that the variables are
        -- ready
        enabled = true;
        
        print("Variables Available!!");
    end
    
    -- Whenever we have a new battlefield result
    function events:UPDATE_BATTLEFIELD_STATUS(...)
        BattleAdvisor_BGEvent();
    end
    
    -- Set the Main frame to receive handle the events
    BA_MainFrame:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...); -- call one of the functions above
            end
    );
    
    -- Register the events to the frame
    for k, v in pairs(events) do
         -- Register all events for which handlers have been defined
        BA_MainFrame:RegisterEvent(k);
    end
    
    print("Events Registered!");
end


