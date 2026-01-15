-- [AUTO CLEANUP]
if getgenv().MspaintInstance then
    pcall(function() getgenv().MspaintInstance:Unload() end)
    getgenv().MspaintInstance = nil
    if getgenv().FloatingWidgetInstance then getgenv().FloatingWidgetInstance:Destroy() end
    task.wait(0.2) 
end

------------------------------------------------------------------
-- 1. HELPER FUNCTIONS & INIT
------------------------------------------------------------------
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options

getgenv().MspaintInstance = Library

-- [FORMATTERS]
local function formatNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function abbreviateNumber(n)
    n = tonumber(n)
    if not n then return "0" end
    if n < 1000 then return tostring(n) end
    local suffixes = {"k", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "N", "Dc"}
    local index = math.floor(math.log10(n) / 3)
    local suffix = suffixes[index]
    if suffix then
        local divisor = 10 ^ (index * 3)
        local formatted = n / divisor
        return string.format("%.2f%s", formatted, suffix)
    else
        return string.format("%.2e", n)
    end
end

-- [IMAGE LOADER SYSTEM]
local function GetCustomIcon(url, fileName)
    if not writefile or not isfile or not getcustomasset then
        return "rbxassetid://7734068321" -- Fallback
    end
    if not isfile(fileName) then
        local success, content = pcall(function() return game:HttpGet(url) end)
        if success then writefile(fileName, content) else return "rbxassetid://7734068321" end
    end
    return getcustomasset(fileName)
end

-- Load Logo
local logoUrl = "https://raw.githubusercontent.com/emowbaik/script-emow/refs/heads/master/asset/Logo_emow_transparent.png"
local logoFile = "EmowWidgetLogo.png"
local AssetID = GetCustomIcon(logoUrl, logoFile)

-- Library Setup (Obsidian uses ImageManager specifically)
local ImageManager = Library.ImageManager
ImageManager.AddAsset("emow_logo", 95811237006870, logoUrl)
local WindowIcon = ImageManager.GetAsset("emow_logo")

-- Loading Notification
local Notification = Library:Notify({ Title = "EMOW Script", Description = "Loading...", Steps = 1 })
for i = 1, 5 do Notification:ChangeStep(i) task.wait(0.05) end
Notification:Destroy()
Library:Notify({ Title = "EMOW Script", Description = "Loaded successfully!✅", Time = 2 })

------------------------------------------------------------------
-- 2. UI CREATION
------------------------------------------------------------------
local Window = Library:CreateWindow({
    Title = "Emow",
    Icon = WindowIcon,
    Footer = "Spin a Baddie Script - version: 1.0",
    GlobalSearch = true,
    NotifySide = "Right",
    ShowCustomCursor = false,
    EnableSidebarResize = true,
})

local Tabs = {
    MainTab = Window:AddTab("Main", "user"),
    FarmTab = Window:AddTab("Farm", "mouse-pointer-click"),
    ShopTab = Window:AddTab("Shop", "shopping-cart"),
    ["UISettings"] = Window:AddTab("Settings", "settings"),
}

-- =================================================================
-- MAIN TAB
-- =================================================================
local Information = Tabs.MainTab:AddLeftGroupbox("Information", "info")
local StatisticPlayer = Tabs.MainTab:AddLeftGroupbox("Player Stats", "bar-chart-2")
local PlayerBox = Tabs.MainTab:AddRightGroupbox("Player Controls", "user")

Information:AddLabel("Welcome to EMOW Spin a Baddie Script\n\nEnjoy your time!", true)

-- Profile Picture Injection
if StatisticPlayer.Container then
    local ImageFrame = Instance.new("Frame")
    ImageFrame.Name = "ProfilePictureFrame"
    ImageFrame.BackgroundTransparency = 1
    ImageFrame.Size = UDim2.new(1, 0, 0, 110)
    ImageFrame.Parent = StatisticPlayer.Container
    ImageFrame.LayoutOrder = -1 
    local ProfileImage = Instance.new("ImageLabel")
    ProfileImage.Size = UDim2.new(0, 100, 0, 100)
    ProfileImage.Position = UDim2.new(0.5, -50, 0, 5)
    ProfileImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ProfileImage.BackgroundTransparency = 0
    ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    ProfileImage.Parent = ImageFrame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ProfileImage
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.8
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = ProfileImage
end

StatisticPlayer:AddLabel("User: " .. LocalPlayer.DisplayName)
StatisticPlayer:AddLabel("ID: " .. LocalPlayer.UserId)
StatisticPlayer:AddDivider()

local RollsLabel = StatisticPlayer:AddLabel("Rolls: Loading...")
local CoinsLabel = StatisticPlayer:AddLabel("Coins: Loading...")
local RebirthsLabel = StatisticPlayer:AddLabel("Rebirths: Loading...")

task.spawn(function()
    while true do
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local rolls = leaderstats:FindFirstChild("Rolls")
            local coins = leaderstats:FindFirstChild("Coins")
            local rebirths = leaderstats:FindFirstChild("Rebirths")
            RollsLabel:SetText("🎲 Rolls: " .. (rolls and formatNumber(rolls.Value) or "N/A"))
            CoinsLabel:SetText("💰 Coins: " .. (coins and abbreviateNumber(coins.Value) or "N/A"))
            RebirthsLabel:SetText("✨ Rebirths: " .. (rebirths and formatNumber(rebirths.Value) or "N/A"))
        else
            RollsLabel:SetText("Stats: Leaderstats not found")
        end
        task.wait(0.5)
    end
end)

-- Player Controls
PlayerBox:AddToggle('InfJumpToggle', {
    Text = 'Infinite Jump',
    Default = false,
    Callback = function(Value) _G.infinjump = Value end
})

_G.WalkSpeedValue = 16 
local SpeedSlider = PlayerBox:AddSlider('WalkSpeedSlider', {
    Text = 'WalkSpeed', Default = 16, Min = 1, Max = 350, Rounding = 0, Compact = false,
    Callback = function(Value)
        _G.WalkSpeedValue = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerBox:AddInput("WalkspeedInput", {
    Text = "Set Speed (Manual)", Numeric = true, Finished = true, Placeholder = "Input number...",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then SpeedSlider:SetValue(num) end
    end,
})

PlayerBox:AddDivider()

-- Hide Notifications
if not _G.NotifConnections then _G.NotifConnections = {} end
PlayerBox:AddToggle('HideNotificationsToggle', {
    Text = 'Hide Notifications', Default = false,
    Callback = function(Value)
        _G.HideNotifications = Value
        local function suppressObject(child)
            if child:IsA("GuiObject") then
                child.Visible = false 
                local conn = child:GetPropertyChangedSignal("Visible"):Connect(function()
                    if _G.HideNotifications and child.Visible then child.Visible = false end
                end)
                table.insert(_G.NotifConnections, conn)
            end
        end
        if Value then
            local plr = game:GetService("Players").LocalPlayer
            local pGui = plr:WaitForChild("PlayerGui")
            local success, botNot = pcall(function() return pGui:WaitForChild("bot_not", 5) end)
            if success and botNot and botNot:FindFirstChild("Frame") then
                local frame = botNot.Frame
                for _, child in pairs(frame:GetChildren()) do suppressObject(child) end
                local addedConn = frame.ChildAdded:Connect(function(child) suppressObject(child) end)
                table.insert(_G.NotifConnections, addedConn)
                Library:Notify({Title="System", Description="Notifications Hidden", Time=1})
            end
        else
            for _, conn in pairs(_G.NotifConnections) do if conn then conn:Disconnect() end end
            _G.NotifConnections = {}
            pcall(function()
                local frame = game:GetService("Players").LocalPlayer.PlayerGui.bot_not.Frame
                for _, child in pairs(frame:GetChildren()) do if child:IsA("GuiObject") then child.Visible = true end end
            end)
            Library:Notify({Title="System", Description="Notifications Restored", Time=1})
        end
    end
})

-- Anti AFK
PlayerBox:AddToggle('AntiAfkToggle', {
    Text = 'Anti-AFK Mode', Default = false,
    Callback = function(Value)
        if Value then
            if _G.AntiAfkConnection then pcall(function() _G.AntiAfkConnection:Disconnect() end) _G.AntiAfkConnection = nil end
            _G.AntiAfkConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            Library:Notify({Title ="System", Description="Anti-AFK Enabled", Time=1})
        else
            if _G.AntiAfkConnection then pcall(function() _G.AntiAfkConnection:Disconnect() end) _G.AntiAfkConnection = nil end
            Library:Notify({Title ="System", Description="Anti-AFK Disabled", Time=1})
        end
    end
})

-- Loops
task.spawn(function()
    while true do
        task.wait(1)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= _G.WalkSpeedValue then
                LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.infinjump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =================================================================
-- FARM TAB
-- =================================================================
local AutoFarmCoins = Tabs.FarmTab:AddLeftGroupbox("Auto Farm Collect Coins", "mouse-pointer-click")
local AutoFarmDices = Tabs.FarmTab:AddRightGroupbox("Auto Farm Rolling Dices", "mouse-pointer-click")

_G.AutoCollectCoinsLoop = false
_G.AutoCollectDelay = 2
AutoFarmCoins:AddToggle('AutoCollectCoinsToggle', {
    Text = 'Auto Collect Coins', Default = false,
    Callback = function(Value)
        _G.AutoCollectCoinsLoop = Value
        if Value then
            task.spawn(function()
                while _G.AutoCollectCoinsLoop do
                    pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlaceBestBaddies"):InvokeServer() end)
                    task.wait(_G.AutoCollectDelay)
                end
            end)
        end
    end
})
AutoFarmCoins:AddSlider('AutoCollectDelaySlider', { Text = 'Collect Delay (s)', Default = 2, Min = 0.5, Max = 10, Rounding = 1, Compact = false, Callback = function(Value) _G.AutoCollectDelay = Value end })

_G.AutoRollDiceLoop = false
_G.AutoRollDiceDelay = 0.5
AutoFarmDices:AddToggle('AutoRollDiceToggle', {
    Text = 'Auto Roll Dices', Default = false,
    Callback = function(Value)
        _G.AutoRollDiceLoop = Value
        if Value then
            task.spawn(function()
                while _G.AutoRollDiceLoop do
                    pcall(function() game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Dice"):WaitForChild("RollState"):InvokeServer() end)
                    task.wait(_G.AutoRollDiceDelay)
                end
            end)
        end
    end
})
AutoFarmDices:AddSlider('AutoRollDiceDelaySlider', { Text = 'Roll Delay (s)', Default = 0.5, Min = 0.1, Max = 5, Rounding = 1, Compact = false, Callback = function(Value) _G.AutoRollDiceDelay = Value end })

-- =================================================================
-- SHOP TAB
-- =================================================================
local AutoBuyDices = Tabs.ShopTab:AddLeftGroupbox("Auto Buy Dices", "shopping-cart")
local AutoBuyPotions = Tabs.ShopTab:AddLeftGroupbox("Auto Buy Potions", "shopping-cart")
local AutoBuyPets = Tabs.ShopTab:AddRightGroupbox("Auto Buy Eggs", "egg")
local InformationShop = Tabs.ShopTab:AddRightGroupbox("Information", "info")

InformationShop:AddLabel("Select items to auto-buy.\nEnable 'Auto Buy' to snipe items when restock timer hits 0.", true)

------------------------------------------------------------------
-- SECTION A: DICE SHOP LOGIC
------------------------------------------------------------------
local DiceState = {
    SelectedDice = {},
    IsSniperActive = false,
    MaxQuantity = 999,
    Remote = nil,
    ShopContainer = nil,
    TimerLabel = nil,
    HasBoughtThisCycle = false
}

local function GetDynamicDiceList()
    local list = {}
    local success, container = pcall(function() return LocalPlayer.PlayerGui.Main.Restock.ScrollingFrame end)
    if success and container then
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Frame") and string.find(child.Name, "Dice") then table.insert(list, child.Name) end
        end
        table.sort(list)
    else
        table.insert(list, "Please Refresh List")
    end
    return list
end
local currentDiceList = GetDynamicDiceList()

local function InitDicePaths()
    local pGui = LocalPlayer:WaitForChild("PlayerGui")
    if not DiceState.Remote then
        pcall(function() DiceState.Remote = game:GetService("ReplicatedStorage").Events.buy end)
    end
    if not DiceState.ShopContainer then
        pcall(function() DiceState.ShopContainer = pGui.Main.Restock.ScrollingFrame end)
    end
    if not DiceState.TimerLabel then
        pcall(function() DiceState.TimerLabel = pGui.Main.Restock.Header.restock_dur end)
    end
end

local function GetDiceSeconds()
    if not DiceState.TimerLabel then return 9999 end
    local text = DiceState.TimerLabel.Text
    if string.find(string.lower(text), "stock") or text == "00:00" then return 0 end
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then return (tonumber(min) * 60) + tonumber(sec) end
    return 9999
end

local function ExecuteDiceBuy()
    if not DiceState.IsSniperActive then return end
    if #DiceState.SelectedDice > 0 and DiceState.Remote then
        for _, diceName in pairs(DiceState.SelectedDice) do
            task.spawn(function()
                if diceName ~= "None" and diceName ~= "Please Refresh List" then
                    -- Simplified Stock check: Assume max if checking fails to improve speed
                    local currentStock = 999 
                    if DiceState.ShopContainer and DiceState.ShopContainer:FindFirstChild(diceName) then
                         -- Add stock checking logic here if strictly needed
                    end
                    
                    local finalQty = math.min(DiceState.MaxQuantity, currentStock)
                    pcall(function() DiceState.Remote:InvokeServer(diceName, finalQty, "dice") end)
                end
            end)
        end
    end
end

local function StartDiceLoop()
    task.spawn(function()
        while DiceState.IsSniperActive do
            if not DiceState.TimerLabel then InitDicePaths() end
            local seconds = GetDiceSeconds()
            
            if seconds <= 1 and not DiceState.HasBoughtThisCycle then
                task.wait(1.5) -- Wait for restock
                if not DiceState.IsSniperActive then break end
                ExecuteDiceBuy()
                task.wait(0.5)
                if not DiceState.IsSniperActive then break end
                ExecuteDiceBuy()
                DiceState.HasBoughtThisCycle = true
            elseif seconds > 10 then
                DiceState.HasBoughtThisCycle = false
            end
            task.wait(0.5)
        end
    end)
end

-- Dice UI
AutoBuyDices:AddButton({
    Text = '🔄 Refresh Dice List',
    Func = function()
        local newList = GetDynamicDiceList()
        Options.DiceSelector:SetValues(newList)
        Options.DiceSelector:SetValue({})
        Library:Notify({ Title = "Updated", Description = "Dice list refreshed.", Time = 2 })
    end
})
AutoBuyDices:AddDropdown('DiceSelector', { Values = currentDiceList, Default = 1, Multi = true, Searchable = true, Text = 'Select Dices', 
    Callback = function(Value)
        DiceState.SelectedDice = {}
        for name, isSelected in pairs(Value) do if isSelected then table.insert(DiceState.SelectedDice, name) end end
    end
})
AutoBuyDices:AddSlider('DiceMaxQty', { Text = 'Max Quantity', Default = 999, Min = 1, Max = 999, Rounding = 0, Compact = false, Callback = function(Value) DiceState.MaxQuantity = Value end })
AutoBuyDices:AddToggle('AutoBuyDice', { Text = 'Auto Buy Selected Dices', Default = false, 
    Callback = function(Value)
        DiceState.IsSniperActive = Value
        if Value then StartDiceLoop() end
    end
})

------------------------------------------------------------------
-- SECTION B: POTION SHOP LOGIC
------------------------------------------------------------------
local PotionState = {
    SelectedPotion = {},
    IsSniperActive = false,
    MaxQuantity = 999,
    Remote = nil,
    ShopContainer = nil,
    TimerLabel = nil,
    HasBoughtThisCycle = false
}

local function GetDynamicPotionList()
    local list = {}
    local success, container = pcall(function() return LocalPlayer.PlayerGui.Main.Potions.ScrollingFrame end)
    if success and container then
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Frame") and string.find(child.Name, "Potion") then table.insert(list, child.Name) end
        end
        table.sort(list)
    else
        table.insert(list, "Please Refresh List")
    end
    return list
end
local currentPotionList = GetDynamicPotionList()

local function InitPotionPaths()
    local pGui = LocalPlayer:WaitForChild("PlayerGui")
    if not PotionState.Remote then pcall(function() PotionState.Remote = game:GetService("ReplicatedStorage").Events.buy end) end
    if not PotionState.ShopContainer then pcall(function() PotionState.ShopContainer = pGui.Main.Potions.ScrollingFrame end) end
    if not PotionState.TimerLabel then pcall(function() PotionState.TimerLabel = pGui.Main.Potions.Header.restock_dur end) end
end

local function GetPotionSeconds()
    if not PotionState.TimerLabel then return 9999 end
    local text = PotionState.TimerLabel.Text
    if string.find(string.lower(text), "stock") or text == "00:00" then return 0 end
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then return (tonumber(min) * 60) + tonumber(sec) end
    return 9999
end

local function ExecutePotionBuy()
    if not PotionState.IsSniperActive then return end
    if #PotionState.SelectedPotion > 0 and PotionState.Remote then
        for _, name in pairs(PotionState.SelectedPotion) do
            task.spawn(function()
                if name ~= "None" and name ~= "Please Refresh List" then
                    pcall(function() PotionState.Remote:InvokeServer(name, PotionState.MaxQuantity, "potion") end)
                end
            end)
        end
    end
end

local function StartPotionLoop()
    task.spawn(function()
        while PotionState.IsSniperActive do
            if not PotionState.TimerLabel then InitPotionPaths() end
            local seconds = GetPotionSeconds()
            if seconds <= 1 and not PotionState.HasBoughtThisCycle then
                task.wait(1.5)
                if not PotionState.IsSniperActive then break end
                ExecutePotionBuy()
                task.wait(0.5)
                if not PotionState.IsSniperActive then break end
                ExecutePotionBuy()
                PotionState.HasBoughtThisCycle = true
            elseif seconds > 10 then
                PotionState.HasBoughtThisCycle = false
            end
            task.wait(0.5)
        end
    end)
end

-- Potion UI
AutoBuyPotions:AddButton({
    Text = '🔄 Refresh Potion List',
    Func = function()
        local newList = GetDynamicPotionList()
        Options.PotionSelector:SetValues(newList)
        Options.PotionSelector:SetValue({})
        Library:Notify({ Title = "Updated", Description = "Potion list refreshed.", Time = 2 })
    end
})
AutoBuyPotions:AddDropdown('PotionSelector', { Values = currentPotionList, Default = 1, Multi = true, Searchable = true, Text = 'Select Potions', 
    Callback = function(Value)
        PotionState.SelectedPotion = {}
        for name, isSelected in pairs(Value) do if isSelected then table.insert(PotionState.SelectedPotion, name) end end
    end
})
AutoBuyPotions:AddSlider('PotionMaxQty', { Text = 'Max Quantity', Default = 999, Min = 1, Max = 999, Rounding = 0, Compact = false, Callback = function(Value) PotionState.MaxQuantity = Value end })
AutoBuyPotions:AddToggle('AutoBuyPotion', { Text = 'Auto Buy Selected Potions', Default = false, 
    Callback = function(Value)
        PotionState.IsSniperActive = Value
        if Value then StartPotionLoop() end
    end
})

------------------------------------------------------------------
-- SECTION C: EGG SHOP LOGIC
------------------------------------------------------------------
local EggState = {
    SelectedEggs = {},
    IsAutoBuying = false,
    Delay = 1.1, 
    Quantity = 1, 
    Remote = nil 
}

local function GetDynamicEggList()
    local list = {}
    local success, eggsFolder = pcall(function() return workspace:WaitForChild("Eggs", 5) end)
    if success and eggsFolder then
        for _, child in pairs(eggsFolder:GetChildren()) do
            if child:IsA("Model") and string.find(child.Name, "Egg") then table.insert(list, child.Name) end
        end
        table.sort(list)
    else
        table.insert(list, "Please Refresh List")
    end
    return list
end
local currentEggList = GetDynamicEggList()

local function InitEggRemote()
    if not EggState.Remote then
        pcall(function() EggState.Remote = game:GetService("ReplicatedStorage").Events.RegularPet end)
    end
end
task.spawn(InitEggRemote)

local function StartEggBuying()
    task.spawn(function()
        while EggState.IsAutoBuying do
            if not EggState.Remote then InitEggRemote() end
            if EggState.Remote then
                for _, eggName in pairs(EggState.SelectedEggs) do
                    if not EggState.IsAutoBuying then break end
                    if eggName ~= "None" and eggName ~= "Please Refresh List" then
                        pcall(function() EggState.Remote:InvokeServer(eggName, EggState.Quantity) end)
                        task.wait(0.1)
                    end
                end
            end
            task.wait(EggState.Delay)
        end
    end)
end

-- Egg UI
AutoBuyPets:AddButton({
    Text = '🔄 Refresh Egg List',
    Func = function()
        local newList = GetDynamicEggList()
        Options.EggSelector:SetValues(newList)
        Options.EggSelector:SetValue({})
        Library:Notify({ Title = "Updated", Description = "Egg list refreshed.", Time = 2 })
    end
})
AutoBuyPets:AddDropdown('EggSelector', { Values = currentEggList, Default = 1, Multi = true, Text = 'Select Eggs', 
    Callback = function(Value)
        EggState.SelectedEggs = {}
        for name, isSelected in pairs(Value) do if isSelected then table.insert(EggState.SelectedEggs, name) end end
    end
})
AutoBuyPets:AddSlider('EggQty', { Text = 'Buy Quantity', Default = 1, Min = 1, Max = 10, Rounding = 0, Compact = false, Callback = function(Value) EggState.Quantity = Value end })
AutoBuyPets:AddSlider('EggDelay', { Text = 'Delay (s)', Default = 1.1, Min = 0.1, Max = 5, Rounding = 1, Compact = false, Callback = function(Value) EggState.Delay = Value end })
AutoBuyPets:AddToggle('AutoBuyEgg', { Text = 'Enable Auto Hatch', Default = false, 
    Callback = function(Value)
        EggState.IsAutoBuying = Value
        if Value then StartEggBuying() end
    end
})

-- =================================================================
-- FLOATING WIDGET
-- =================================================================
local function CreateFloatingWidget(config)
    if getgenv().FloatingWidgetInstance then getgenv().FloatingWidgetInstance:Destroy() end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ObsidianFloatingWidget"
    ScreenGui.DisplayOrder = 10000
    ScreenGui.Parent = game:GetService("CoreGui")
    getgenv().FloatingWidgetInstance = ScreenGui 

    local MainFrame = Instance.new("TextButton") 
    MainFrame.Size = config.Size
    MainFrame.Position = config.Position
    MainFrame.BackgroundColor3 = config.Color
    MainFrame.BackgroundTransparency = 0
    MainFrame.Text = "" 
    MainFrame.AutoButtonColor = false
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", MainFrame); UICorner.CornerRadius = UDim.new(1, 0)
    local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Color = config.StrokeColor; UIStroke.Thickness = 2; UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local Icon = Instance.new("ImageLabel", MainFrame)
    Icon.Size = UDim2.new(0.7, 0, 0.7, 0); Icon.Position = UDim2.new(0.15, 0, 0.15, 0)
    Icon.BackgroundTransparency = 1; Icon.Image = config.Content; Icon.ScaleType = Enum.ScaleType.Fit; Icon.ZIndex = 2

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

    local isDragging = false
    MainFrame.InputBegan:Connect(function() isDragging = false end)
    MainFrame.InputChanged:Connect(function() isDragging = true end)
    MainFrame.MouseButton1Click:Connect(function()
        if isDragging then return end
        if Library.Toggle then Library:Toggle() elseif Library.MainFrame then Library.MainFrame.Visible = not Library.MainFrame.Visible end
    end)
end

CreateFloatingWidget({
    Type = "Icon",
    Content = AssetID,
    Size = UDim2.new(0, 55, 0, 55),
    Color = Color3.fromRGB(15, 15, 15),
    StrokeColor = Color3.fromRGB(255, 255, 255),
    Position = UDim2.new(0.1, 0, 0.1, 0)
})

------------------------------------------------------------------
-- SETTINGS & UNLOAD
------------------------------------------------------------------
local Keybind = Tabs["UISettings"]:AddLeftGroupbox("Keybind", "keyboard")

Library:OnUnload(function()
    print("Unloaded!", 3)
    getgenv().MspaintInstance = nil
    if getgenv().FloatingWidgetInstance then getgenv().FloatingWidgetInstance:Destroy() end
    Library.Unloaded = true
end)

Keybind:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightControl", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("Emow/SpinaBaddie")
SaveManager:BuildConfigSection(Tabs["UISettings"]) 
ThemeManager:ApplyToTab(Tabs["UISettings"])
SaveManager:LoadAutoloadConfig()