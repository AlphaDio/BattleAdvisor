-- This file will host the graphical helper functions


-- Create the different frames used by the addon. Important function.
function createBAFrames()
    
    localMainFrame = createMainFrame();
    
    -- Set the Backdrop -- Seems useless
    --localMainFrame:SetBackdrop(
    --    {
    --        bgFile="Interface\DialogFrame\UI-Tooltip-Background",
    --        edgeFile = "Interface\Tooltips\UI-Tooltip-Border",
    --        tile = true, tileSize = 16, edgeSize = 16,
    --        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    --    }
    --);
    
    print("Creating Frames");
    
    return localMainFrame;
end

-- This function create the main frame of the application.
-- This frame shows the button for the different BGs.
function createMainFrame()
    -- Create a frame that will be attached to the UI parent.
    local mainFrame = CreateFrame("Frame", BA_MainFrame, UIParent);
    mainFrame:SetFrameStrata("LOW");
    mainFrame:SetPoint("CENTER");
    mainFrame:SetWidth(250);
    mainFrame:SetHeight(140);
    
    -- To make the frame movable
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)

    -- For some reason we need a texture for it to appear
    local tex = mainFrame:CreateTexture("LOW");
    tex:SetAllPoints();
    tex:SetTexture(0.0, 0.0, 0.0);
    tex:SetAlpha(0.5);
    mainFrame.texture = tex;
    
    createBGButton("AV");
    createBGButton("AB");
    createBGButton("WSG");
    createBGButton("IoC");
    createBGButton("TP");
    createBGButton("BoG");
    createBGButton("TB");
    createBGButton("WG");
    
    return mainFrame;
end

-- This function create a BG button using the name of a BG, and
-- a function.
function createBGButton(bg_name)
    -- We first get the Bg object from the bg name
    local bg = getBattlegroundFromString(bg_name);
    
    -- Now we create the button
    local bgButton = CreateFrame("Button", "bgButton", BA_MainFrame, "UIPanelButtonTemplate");
    bgButton:SetWidth(35);
    bgButton:SetHeight(35);
    
    -- The text of the button
    bgButton:SetText(bg.title);
    -- Set the script for the bg button
    bgButton:SetScript("OnClick", BgButton_OnClick);
    bgButton:SetPoint("CENTER");
    return bgButton;
end

-- This function detail what happen when you press a bg button
function BgButton_OnClick(bg)
    
    -- We will call the function that will create the strategy
    strategy = CreateStrategy(bg);
    
    -- We announce the strategy depending on wether 
    
    -- Debug
    print("Button Clicked! " .. bg.title);
end


