

-- The command name that give access to Battle Advisor functionalities through
-- the use of parameters.
SLASH_BATTLEADVISOR1, SLASH_BATTLEADVISOR2 = '/ba', '/battleadvisor';

-------------------
-- Global variables
-------------------

-- Will contain the message to be repeated to the user.
BGAnnounce = nil;
-- Placeholder for the selected strategy.
strategy = nil;
-- Will contain the selection according to the current strategy
selection = nil;
-- Tell if the addon is ready, will probably be used in the communication protocol
-- of the addon.
enabled = false;
-- Tell if we have recorded results
recorded = false;

    ------------------------
    ---- Graphical variables
    ------------------------
-- The primary frame of the addon.
-- BA_MainFrame = "Hello";


-- This function is needed to handle a command that target this addon
function SlashCmdList.BATTLEADVISOR(msg, editbox)
    if msg == 'show' then
        print("Showing the Main Frame!");
        BA_MainFrame:Show();
    elseif msg == 'hide' then
        print("Hiding the Main Frame!");
        BA_MainFrame:Hide();
    else
        print("Syntax: /ba or /battleadvisor.\n" ..
                "Available options:\n" .. "-show\n-hide");
    end
end

-- BattleAdvisor_OnLoad()
-- This function is executed when the addon is loaded, here we want to set up the data
-- that will be used by the application.
function BattleAdvisor_OnLoad()
    -- Load all battlegrounds data.
    loadBattlegrounds();
    
    -- Create the frames
    -- BA_MainFrame = createBAFrames();
    
    -- Register the events
    registerBAEvents(BA_MainFrame);
    
    -- Tell the user the AddOn is loaded
    print("Battle Advisor loaded!");
end




