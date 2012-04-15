SLASH_BATTLEADVISOR1, SLASH_BATTLEADVISOR2 = '/ba', '/battleadvisor'
debug = true

-- STARTING MAIN CODE --

local BattleAdvisorAddon = LibStub("AceAddon-3.0"):NewAddon("BattleAdvisor", "AceConsole-3.0", "AceComm-3.0")
-- Embed An AceGUI instance to help with the creation of frames
AceGUI = LibStub("AceGUI-3.0")

-- When the addon is initialized and loaded.
function BattleAdvisorAddon:OnInitialize()
    print "-- BattleAdvisor Started!"
    -- Create the slash commands
    BattleAdvisorAddon:RegisterChatCommand("ba", "BattleAdvisor_SlashProcessor")
    BattleAdvisorAddon:RegisterChatCommand("battleadvisor", "BattleAdvisor_SlashProcessor")

    loadBattlegrounds()

end

-- When the addon is enabled.
function BattleAdvisorAddon:OnEnable()
    -- Create the frames
    StartFrames()
end

-- When the addon is disabled.
function BattleAdvisorAddon:OnDisable()

end

-- END OF STARTING CODE --


-- The function activated when the addon command is typed by the
-- user or called by another program.
function BattleAdvisor_SlashProcessor(msg)
    if msg == 'show' then
        print("show")
    elseif msg == 'hide' then
        print("hide")
    else
        print("Syntax: /ba or /battleadvisor.\n" ..
                "Available options:\n" .. "-show\n-hide");
    end
end

function StartFrames()
    BA_MainFrame = AceGUI:Create("Frame")
    BA_MainFrame:SetTitle("Battle Advisor Main Frame")
    BA_MainFrame:SetWidth("250")
    BA_MainFrame:SetHeight("140")
    BA_MainFrame:SetStatusText("AceGUI-3.0 Example Container Frame")
    -- When the frame is closed
    BA_MainFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    BA_MainFrame:SetLayout("Flow")
    print "-- Battle Advisor Main Frame Created!"

    MakeBG_Button(AB)
    MakeBG_Button(AV)
    MakeBG_Button(WSG)
    MakeBG_Button(IoC)
    MakeBG_Button(EotS)
end

function MakeBG_Button(bg)
    local button = AceGUI:Create("Button")
    button:SetWidth(50)
    button:SetHeight(35)
    button:SetText(bg.nick)
    button:SetCallback("OnClick", BG_ButtonClick)
    button.BG = bg
    BA_MainFrame:AddChild(button)
end

function BG_ButtonClick(widget)
    -- Get the BG we are talking about
    local bg = widget.BG

    local playersNum    = bg.playersNum
    local numGroups     = playersNum / 5
    local BGStrategies  = bg.strategy

    print("The number of IoC Strategy disponible: " .. # BGStrategies);

    total_role_report = ""
    strategy = GetAStrategy(BGStrategies)

    -- Print an intro to the strategy.
    PrintIntro(bg, strategy)

    -- Role assignment
    RoleAssignment(bg, strategy)

    print("" .. bg.title .. " Button Clicked!" )
end

function RoleAssignment(bg, strategy)
    local roles = strategy.roles
    -- An object/hash that will contain the groups that have already been selected for a role.
    local already_selected = {}

    for i=1, # roles do
        RoleSelection(i, bg, roles, already_selected)
    end
end

-- Select a role
function RoleSelection(i, bg, roles, already_selected)
    local groupNum  = bg.playersNum / 5
    -- Get the role to be parsed
    local role      = roles[i]     -- The role current overview
    
    -- Gets its infos
    local spots     = role[1]      -- The numbers of spots in the role
    local roleTitle = role[2]      -- The title of the role, like "Defenders"
    local roleDescription = role[3] -- The responsabilities of this role
    local selected = {}            -- the ones selected for the role

    selected, already_selected = AssignGroups(spots, already_selected, groupNum)

    -- tell the global strategy about the selection
    strategy.roles[i].selection = selected

    -- Send the message for this role
    PrintRole(selected, roleTitle, roleDescription)
end

function PrintRole(selected, roleTitle, roleDescription)
    local role_report = "Groups " .. niceGroupsText(selected) .. " randomly tasked with " .. roleTitle .. 
    " duty!\n--" .. roleDescription;
    
    total_role_report = total_role_report .. "\n" .. role_report .. "\n";

    BG_Message(role_report)
end

function AssignGroups(spots, selection, maxGroups)
    local selected = {}

    -- for each spot needed pick a group and add it to the selection
    for i=1, spots do
        local valid = false

        while valid == false do 
            -- Choose a group randomly
            local group = math.random(maxGroups)

            -- Check if the group has already been selected or not
            if (CheckIfGroupIsContained(group, selection)) then
                -- We have already selectioned this group, we continue the loop
            else
                -- we have not yet selected this group, we add it to the table
                table.insert(selection, group)
                table.insert(selected, group)
                -- Ensure the loop is stopped
                valid = true
            end
        end
    end

    return selected, selection
end

function CheckIfGroupIsContained(group, selectedGroups)
    for i=1, # selectedGroups do
        -- If the group number is in the "already selected" array
        if group == selectedGroups[i] then
            return true
        end
    end
    -- We haven't found it
    return false
end

function GetAStrategy(strategies)
    -- we are going to need this number to save the strategy
    local stratNum = floor(math.random(100) / (100 / # strategies) + 1) -- Magic Numbers!!!
    
    strategy = strategies[stratNum]
    return strategy
end

function Herald(bg, strategy)
    -- The numbers of groups in the BGs
    local groupNum = bg.playersNum / 5
    
end

function PrintIntro(bg, strategy)
    -- Print the intro
    local intro = "Battle Advisor:\n<" .. bg.title ..
        "> Strategy Selected: " .. strategy.title;
    BG_Message(intro)
end

-- Responsible for printing messages.
function BG_Message(text)
    local s = { strsplit("\n", text) };
    
    local size = # s;

    -- if we actually have a valid table
    if (size ~= nil) then
        --  for each entry in the table
        for i=1, size do
            if debug then
                -- Only print it
                print(s[i])
            else
                -- Ready for production
                SendChatMessage(s[i], "BATTLEGROUND", nil, nil)
            end
        end
    end
end

-- ========================================================
-- LEGACY CODE
-- ========================================================

-- Executed when we load the AddOn.
function BattleAdvisor_OnLoad()
   
    -- Load the BGs
    loadBattlegrounds(); 
    -- Register the necessary events
    
    --
    BA_MainFrame:RegisterEvent("CHAT_MSG_BATTLEGROUND");
    -- Whenever we change zone, for example enter a battleground
    BA_MainFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
    -- Whenever an event on Horde side happens
    BA_MainFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE");
    -- Whenever an event on Alliance side happens
    BA_MainFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE");
    -- Whenever the addon is loaded and its variables available
    BA_MainFrame:RegisterEvent("ADDON_LOADED");
    -- Whenever we have a new battlefield result
    BA_MainFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
    
    
    -- Tell the user the AddOn is loaded
    print("Battle Advisor loaded!");
end



-- Executed when an event has occured
function BattleAdvisor_OnEvent()

    -- When a player whisper us, need to find a way to distribute the workload among people
    if event == "CHAT_MSG_BATTLEGROUND" then
        
    end

    -- If it is a BG Horde message
    if event == "CHAT_MSG_BG_SYSTEM_HORDE" or 
            event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" or 
            event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" then
        BattleAdvisor_BGEvent(arg1);
    end
    
    -- Everytime we have an event on the BG
    if event == "UPDATE_BATTLEFIELD_STATUS" then
        
    end
    
    -- If it is a change of zone, possibly entering a BG
    if (event == "ZONE_CHANGED_NEW_AREA") then
        print("Zone Changed!!");
        
        -- Unlock the BG buttons so that they can be used
        -- // Should automatize this
        unlockMode();
        
        -- Get the location we just entered
        local location = GetRealZoneText();
        
        -- Check if we are actually in a Battleground
        if isBG(location) then
            -- We must reset the addon
            BA_MainFrame:Show();
        else
            BA_MainFrame:Hide();
        end
        
    end
    
    -- If it is the loading of the AddOn
    if event == "ADDON_LOADED" and arg1 == "BattleAdvisor" then
    
        -- Load the variables for the different battlegrounds
        loadBattlegrounds();
        
        isAvailable = "true";
        standing = 1; -- Default standing
        playerName, playerRealm = UnitName("player", true);
    
        -- Create a general Frame
        -- BA_GeneralFrame =
        --     CreateFrame("Frame", "BA_GeneralFrame", UIParent, "BA_TemplateMainFrame");
    
        -- createMainFrame();
        createPanelFrame();
        
        -- Tell the rest of the program that the variables are
        -- ready
        enabled = true;
        
        print("Variables Available!!");
    end
    
    -- The handling of the role asking distribution
    if event == "CHAT_MSG_ADDON" then
        
        if arg1 == "BA" then
            handleMSG(arg2);
        end
    end
    
end

-- This function role is to handle when we receive a addon message and redistribute
-- the request to the appropriate function.
function handleMSG(msgText)
    print("Received as MSG Addon!");

    local isRequest     = string.sub(msgText, string.find(msgText, "^request"));
    local isStanding    = string.sub(msgText, string.find(msgText, "^standing"));

    -- If we have a request
    if isRequest ~= nil then
        -- We need to check if we are available
        if isAvailable == 1 then 
            -- we can handle the request
            -- we are going to get a number randomly, in the future this number should
            -- be the standing in the "ladder" of the person using the addon
            standing = math.random(1000);
            
            -- Send a message telling what number you got, depending on that you will be
            -- asked or not to send the reply
            SendAddonMessage("BA", "^standing " .. playerName .. " " .. playerRealm .. " " 
                .. rand, "BATTLEGROUND");
        end
    end
    
    -- Someone send a standing!
    if isStanding ~= nil then
        if isAvailable == 1 then
            -- we need to check if we have a greater number
            
        end
    end
    
end



function createMainFrame()
    -- Create a background Battle Advisor text
    setBA_Background(BA_MainFrame);
    
    -- Creation of the MainFrame -------------------
    
    createButtonFromBG(IoCButton, IoC, BA_MainFrame);
    createButtonFromBG(ABButton, AB,BA_MainFrame);
    createButtonFromBG(AVButton, AV, BA_MainFrame);
    createButtonFromBG(WSGButton, WSG, BA_MainFrame);
    createButtonFromBG(WGButton, WG, BA_MainFrame);
    createButtonFromBG(EotSButton, EotS, BA_MainFrame);
    
    IoCButton:SetPoint("TOPLEFT", 10, -15);
    AVButton:SetPoint("TOPLEFT", 120, 0);
    WSGButton:SetPoint("TOPLEFT", 0, -40);
    ABButton:SetPoint("TOPLEFT", 120, -40);
    EotSButton:SetPoint("TOPLEFT", 0, -80);
    WGButton:SetPoint("TOPLEFT", 120, -80);
end

function createPanelFrame()

    -- Create the BG Frame
    BA_PanelFrame   = 
        CreateFrame("Frame", "BA_PanelFrame", BA_GeneralFrame, 
        "BA_TemplateMainFrame");
    BA_PanelFrame:Hide();
    -- Create a background Battle Advisor text
    setBA_Background(BA_PanelFrame);
    
    CopyButton = CreateFrame("Button", "CopyButton", 
        BA_PanelFrame, "BA_TemplateButton");
    CopyButton:SetScript("OnClick", CopyButton_OnClick);
    CopyButton:SetFrameStrata("MEDIUM");
    CopyButton:SetText("Copy");
    CopyButton:SetPoint("TOPLEFT", 10, -15);
    
    AdviceButton = CreateFrame("Button", "AdviceButton",
        BA_PanelFrame, "BA_TemplateButton");
    AdviceButton:SetScript("OnClick", AdviceButton_OnClick);
    AdviceButton:SetFrameStrata("MEDIUM");
    AdviceButton:SetText("Advice");
    AdviceButton:SetPoint("TOPLEFT", 120, -15);
    
    BG_GroupInfo    = BA_PanelFrame:CreateFontString("BG_GroupInfo", "OVERLAY");
    BG_GroupInfo:SetPoint("LEFT", -20, -40);
    BG_GroupInfo:SetHeight(250);
        
end

-- Give to a frame a background text
function setBA_Background(frame)
    -- Set the background text
    BGText = frame:CreateFontString("$parentText", "BACKGROUND", nil);
    BGText:SetAllPoints(frame);
    BGText:SetPoint("CENTER", 0, 0);
    BGText:SetFont("Fonts\\MORPHEUS.ttf", 14, "OUTLINE, MONOCHROME");
    BGText:SetTextColor(1.0, 0.0, 0.0, 0.9);
    
    BGText:SetText("Battle Advisor");
end

-- This is a local function to abstract the process of creating a button
-- and set the script.
function createButtonFromBG(button, bg, frame)
    button = CreateFrame("Button", bg.nick .. "Button", BA_MainFrame, 
        "BA_TemplateButton");
    button:SetText(bg.nick .. "Button");
    button:SetScript("OnClick", BgButton_OnClick);
    button:SetFrameStrata("MEDIUM");
end

function isContained(group, selectedGroups)
    -- the size of the array of already selected groups
    local size = # selectedGroups;
    
    for i=1,size do
        -- If the group number is in the already selected array
        if (group == selectedGroups[i]) then
            return true;
        end
    end
    
    -- we haven't found it
    return false;
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
            SendChatMessage(s[i], "BATTLEGROUND", nil, nil);
        end
    end
    
    -- we have sent every lines of the string to /bg
    
end

function fake_assignGroups(spots, selection, maxGroups)
    -- Now we need to know which group is going to go on O
    local selected = {};
    
    -- for each spot needed pick a group and add it to the selection
    for i=1, spots do
    
        local valid = false;
        
        while valid == false do
            local group = math.random(maxGroups); --Magic Numbers
            
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

-- Herald the strategy to everyone!!
function fake_herald(bg, strategy)

    -- The numbers of groups in the BGs
    local groupNum = bg.playersNum / 5;

    -- Print the intro
    local intro = "Battle Advisor:\n<" .. bg.title ..
        "> Strategy Selected: " .. strategy.title;
    local total_role_report = "";
        
    battleground_message(intro);
    
    -- Print the role assignment
    
    -- Variables for the incoming role loop
    local roles = strategy.roles;
    local already_selected = {}; --  all the groups that have already been selected
                                 --  for role.
                                 
    -- For each roles in the strategy
    for i=1, # roles do
        -- Complete the selection
        
        -- Get the role to be parsed
        local role      = roles[i];     -- The role current overview
        
        -- Gets its infos
        local spots     = role[1];      -- The numbers of spots in the role
        local roleTitle = role[2];      -- The title of the role, like "Defenders"
        local roleDescription = role[3];-- The responsabilities of this role
        local selected = {};            -- the ones selected for the role
        
        -- Assign groups or players for each roles
        selected, already_selected = assignGroups(spots, already_selected, groupNum);
        
        -- We have the groups selected for the roles and those not selected accross
        -- all roles.
        
        -- tell the global strategy about the selection
        strategy.roles[i].selection = selected;
        
        -- Send the message for this role
        local role_report = "Groups " .. niceGroupsText(selected) ..
            " randomly tasked with " .. roleTitle .. " duty!\n--" ..
            roleDescription;
        
        -- Construct the total role report that will be saved in case
        -- we need to herald it again to the masses
        total_role_report = total_role_report .. "\n" .. role_report .. "\n";
        
        -- Report to our dear players!
        battleground_message(role_report);
    end
    
    battleground_message(
        "Send 'advice' in /bg if don't know your group or your role!");
    
    -- The total role report is used here so we have a save of it
    local announce = intro .. "\n" .. total_role_report ..
        "Send 'advice' in /bg if don't know your group or your role!";
    
    return announce;
end

function BgButton_OnClick(bg)

    if enabled then
        print("Button Clicked!");
        
        local playersNum      = bg.playersNum;
        local numGroups       = playersNum / 5;
        local BGStrategies    = bg.strategy;
        
        -- Debug
        print("The number of IoC Strategy disponible: " .. # BGStrategies);
        
        -- we are going to need this number to save the strategy
        local stratNum = 
                floor(math.random(100) / (100 / # BGStrategies) + 1); -- Magic Numbers!!!
        
        strategy = BGStrategies[stratNum];
        
        -- Herald the strategy to all players in the BG
        local announce = herald(bg, strategy);
        
        -- lock the frame and set the announce
        lockMode(announce);
        -- set the frame to display infos
        set();
    end
end

-- Handle the logic of the Copy function
function CopyButton_OnClick()
    -- If we actually have an announce ready
    if BGAnnounce ~= nil then
        battleground_message(BGAnnounce);
    end
end

--
function AdviceButton_OnClick()
    
    battleground_message("Send 'advice' in /bg if don't know your group or your role!");
end

function updateRecord(HordeVictory)
    
    -- If the strategy is victorious
    if HordeVictory then
        
    end
    
    -- Signal that we have already recorded the match
    recorded = true;
end

-- Battle Advisor Battleground Whisper Handler
function BattleAdvisor_CommunicationEvent(arg1, arg2)
    local message   = arg1;
    local author    = arg2;
    local nums      = GetNumRaidMembers();
    local tempPlayer;
    local found     = false;
    
    local i = 1;
    while found == false do
        tempPlayer = {GetRaidRosterInfo(i)};
        
        -- we find the target
        if tempPlayer[1] == author then
            local roleTitle;
            local roleDescription;
            
            -- We found the player
            found = true;
            
            -- we get his role in the strategy
            roleTitle, roleDescription = GetRoleInfo(tempPlayer[3], true);
            
            SendChatMessage("Strategy: " .. strategy.title, 
                "WHISPER", nil, tempPlayer[1]);
            SendChatMessage("Group: " .. tempPlayer[3],
                "WHISPER", nil, tempPlayer[1]);
            SendChatMessage(roleTitle,
                "WHISPER", nil, tempPlayer[1]);
            SendChatMessage("-- " .. roleDescription,
                "WHISPER", nil, tempPlayer[1]);
        end
        
        i = i + 1;
    end
    
    if found == false then
        SendChatMessage("Sorry couldn't find your role!",
                    "WHISPER", nil, author);
    end
end

-- Battle Advisor Battleground Event
function BattleAdvisor_BGEvent(arg1)
    
    -- If we have a strat to record something on
    if strategy ~= nil then
        if GetBattlefieldWinner() == 0 and recorded == false then
            -- The Horde Wins
            
            updateRecord(true);
            
            SendChatMessage(strategy.title .. " Win Recorded! Praised be the Advisor!", "BATTLEGROUND", nil, nil);
            SendChatMessage("For The Horde!", "BATTLEGROUND", nil, nil);
            
        elseif GetBattlefieldWinner() == 1 and recorded == false then
            -- The Alliance Wins!
            
            updateRecord(false);
            
            SendChatMessage(strategy.title .. " Loss Recorded! May the Advisor come to your aid!", "BATTLEGROUND", nil, nil);
            SendChatMessage("For The Horde!", "BATTLEGROUND", nil, nil);
            
        end
    end
end

-- we logic to get to the BA Panel Frame for the BG
function lockMode(announce)
    -- Set it ready to be repeated
    BGAnnounce = announce;
end

-- The logic to switch back from the BA Panel Frame
function unlockMode(announce)
    BA_MainFrame:Show();
    BA_PanelFrame:Hide();
    -- we reset everything
    
    -- We clear the addon panel frame
    BG_GroupInfo = nil;
    
    -- Reset recorded
    recorded = false;
    
    -- Placeholder for strategy
    strategy = nil;
    
    -- Set it ready to be repeated
    BGAnnounce = nil;
end

--[[ Give back the information about the role of the passed group or playerid
]]--
function GetRoleInfo(id, isGroup)
    
    local roles = strategy.roles;
    
    -- If we have a groupid
    if isGroup == true then
        -- For each role in the strategy search if the group is included inside
        for i=1, # roles do
            local role = roles[i];
            local selection = role.selection;
            
            -- For each entry in the selection, check 
            -- if we have have the targeted group
            for j=1, # selection do
                
                if id == selection[j] then
                    -- we have found our group, get the infos
                    return role[2], role[3];
                end
            end
        end
    end
end

-- We set the Addon after the lock to display some information
function set()
    local BA_RaidIndex = (UnitInBattleground("player"));
    local player = nil;
    
    -- Show the Panel Frame, and hide the Main Frame
    BA_MainFrame:Hide();
    BA_PanelFrame:Show();
    
    if BA_RaidIndex ~= nil then
        player = {GetRaidRosterInfo(BA_RaidIndex)};
    
        -- Get the info from the raid
        local subgroup = player[3];
        
        -- The role information
        local roleTitle;
        local roleDescription;
        
        roleTitle, roleDescription = GetRoleInfo(subgroup, true);
        
        -- Create the text
        
        -- BG_GroupInfo:SetPoint("CENTER", "BA_PanelFrame", "CENTER", 0, 0);
        -- BG_GroupInfo:SetWidth(BA_PanelFrame:GetRight() - BA_PanelFrame:GetLeft());
        -- BG_GroupInfo:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME");
        
        -- Tried to save the panel, probably useless
        -- BA_PanelFrame.infos = BG_GroupInfo;
        
        -- Signal a loading!
        BG_GroupInfo:SetText("LOADING!");
        
        -- Set the text!
        BG_GroupInfo:SetText("Strategy: " .. strategy.title .. "\n" ..
        "Group: " .. subgroup .. "\n" .. roleTitle .. "\n" .. roleDescription);
        
        print("Strategy: " .. strategy.title .. "\n" ..
            "Group: " .. subgroup .. "\n" .. roleTitle .. "\n" .. roleDescription);
        
        -- Show the elements
        -- CopyButton:Show();
        -- BA_PanelFrame.infos:Show();
        
   end
end


