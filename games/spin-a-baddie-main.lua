-- [AUTO CLEANUP]
if getgenv().MspaintInstance then
    pcall(function() getgenv().MspaintInstance:Unload() end)
    getgenv().MspaintInstance = nil
    task.wait(0.2) 
end

------------------------------------------------------------------
-- LIBRARY LOADING
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

-- [HELPER] Formatter
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

-- Loading Notification
local Notification = Library:Notify({
    Title = "EMOW Script",
    Description = "Loading...",
    Steps = 1,
})
 
for i = 1, 10 do
    Notification:ChangeStep(i)
    task.wait(0.05)
end
Notification:Destroy()

Library:Notify({
    Title = "EMOW Script",
    Description = "Loaded successfully!✅",
    Time = 2,
})

-- =================================================================
-- FUNGSI LOADER GAMBAR (Auto Download)
-- =================================================================
local function GetCustomIcon(url, fileName)
    -- Cek apakah executor mendukung penyimpanan file
    if not writefile or not isfile or not getcustomasset then
        warn("⚠️ Executor Anda tidak support custom images. Menggunakan icon default.")
        return "rbxassetid://7734068321" -- Fallback Icon (Setting)
    end

    -- Jika file belum ada, download dari GitHub
    if not isfile(fileName) then
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            writefile(fileName, content)
            print("✅ Logo berhasil didownload: " .. fileName)
        else
            warn("❌ Gagal download logo!")
            return "rbxassetid://7734068321"
        end
    end

    -- Kembalikan alamat file lokal
    return getcustomasset(fileName)
end

local ImageManager = Library.ImageManager
ImageManager.AddAsset("emow_logo", 95811237006870, "https://raw.githubusercontent.com/emowbaik/script-emow/refs/heads/master/asset/Logo_emow_transparent.png")
local AssetID = ImageManager.GetAsset("emow_logo")
ImageManager.DownloadAsset("emow_logo")

------------------------------------------------------------------
-- UI CODE
------------------------------------------------------------------
local Window = Library:CreateWindow({
    Title = "Emow",
    Icon = AssetID,
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
-- MAIN TAB CONTENT
-- =================================================================
local Information = Tabs.MainTab:AddLeftGroupbox("Information", "info")
local StatisticPlayer = Tabs.MainTab:AddLeftGroupbox("Player Stats", "bar-chart-2")
local PlayerBox = Tabs.MainTab:AddRightGroupbox("Player Controls", "user")

Information:AddLabel("Welcome to EMOW Spin a Baddie Script\n\nEnjoy your time!", true)

if StatisticPlayer.Container then
    local ImageFrame = Instance.new("Frame")
    ImageFrame.Name = "ProfilePictureFrame"
    ImageFrame.BackgroundTransparency = 1
    ImageFrame.Size = UDim2.new(1, 0, 0, 110)
    ImageFrame.Parent = StatisticPlayer.Container
    ImageFrame.LayoutOrder = -1 

    local ProfileImage = Instance.new("ImageLabel")
    ProfileImage.Name = "Avatar"
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
StatisticPlayer:AddLabel("Nickname: @" .. LocalPlayer.Name)
StatisticPlayer:AddLabel("User ID: " .. LocalPlayer.UserId)
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
    Callback = function(Value)
        _G.infinjump = Value
    end
})

_G.WalkSpeedValue = 16 
local SpeedSlider = PlayerBox:AddSlider('WalkSpeedSlider', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 1,
    Max = 350,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        _G.WalkSpeedValue = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerBox:AddInput("WalkspeedInput", {
    Text = "Set Speed (Manual)",
    Numeric = true,
    Finished = true,
    Placeholder = "Input number...",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then SpeedSlider:SetValue(num) end
    end,
})

PlayerBox:AddDivider()

if not _G.NotifConnections then _G.NotifConnections = {} end
PlayerBox:AddToggle('HideNotificationsToggle', {
    Text = 'Hide Notifications',
    Default = false,
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
                Library:Notify({Title="System", Description="Hide Notifications Enabled", Time=1})
            end
        else
            for _, conn in pairs(_G.NotifConnections) do if conn then conn:Disconnect() end end
            _G.NotifConnections = {}
            pcall(function()
                local frame = game:GetService("Players").LocalPlayer.PlayerGui.bot_not.Frame
                for _, child in pairs(frame:GetChildren()) do
                    if child:IsA("GuiObject") then child.Visible = true end
                end
            end)
            Library:Notify({Title="System", Description="Notifications Restored", Time=1})
        end
    end
})

-- ANTI-AFK
PlayerBox:AddToggle('AntiAfkToggle', {
    Text = 'Anti-AFK (Proactive)',
    Default = false,
    Callback = function(Value)
        _G.AntiAfkActive = Value

        if Value then
            -- === ENABLE ===
            Library:Notify({Title ="System", Description="Anti-AFK Enabled", Time=1})
            
            -- LOOP PROAKTIF: Jalan setiap 60 detik, tidak peduli status Idle atau tidak
            task.spawn(function()
                while _G.AntiAfkActive do
                    local virtualUser = game:GetService("VirtualUser")
                    
                    -- Metode 1: Klik Mouse Virtual
                    pcall(function()
                        virtualUser:CaptureController()
                        virtualUser:ClickButton2(Vector2.new())
                    end)
                    
                    -- Metode 2: Simulasi Input Keyboard (Cadangan jika mouse gagal)
                    -- Ini tidak akan mengganggu gameplay karena sangat cepat
                    pcall(function()
                        local Unfocus = game:GetService("GuiService").MenuIsOpen
                        -- Hanya tekan tombol jika menu roblox tidak sedang terbuka (biar gak kepencet leave)
                        if not Unfocus then 
                            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                            task.wait(0.1)
                            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end)
                    
                    -- print("[Anti-AFK] Refreshing Activity...")
                    task.wait(60) -- Ulangi setiap 1 menit (Timer Roblox AFK itu 20 menit, jadi ini sangat aman)
                end
            end)
            
            -- BACKUP: Tetap pasang koneksi Idled standar sebagai pertahanan lapis kedua
            if _G.AntiAfkConnection then pcall(function() _G.AntiAfkConnection:Disconnect() end) end
            _G.AntiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                print("[Anti-AFK] Idled event detected & reset!")
                -- Library:Notify({Title ="Anti-AFK", Description="Idled detected & Reset!", Time=2})
            end)

        else
            -- === DISABLE ===
            _G.AntiAfkActive = false -- Mematikan Loop Proaktif
            
            -- Mematikan Listener Idled
            if _G.AntiAfkConnection then 
                pcall(function() _G.AntiAfkConnection:Disconnect() end) 
                _G.AntiAfkConnection = nil 
            end

            Library:Notify({Title ="System", Description="Anti-AFK Disabled", Time=1})
        end
    end
})

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
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- =================================================================
-- FARM TAB CONTENT
-- =================================================================
local AutoFarmCoins = Tabs.FarmTab:AddLeftGroupbox("Auto Farm Collect Coins", "mouse-pointer-click")
local AutoFarmDices = Tabs.FarmTab:AddRightGroupbox("Auto Farm Rolling Dices", "mouse-pointer-click")

_G.AutoCollectCoinsLoop = false
_G.AutoCollectDelay = 2
AutoFarmCoins:AddToggle('AutoCollectCoinsToggle', {
    Text = 'Auto Collect Coins',
    Default = false,
    Callback = function(Value)
        _G.AutoCollectCoinsLoop = Value
        if Value then
            task.spawn(function()
                while _G.AutoCollectCoinsLoop do
                    pcall(function()
                         game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlaceBestBaddies"):InvokeServer()
                    end)
                    task.wait(_G.AutoCollectDelay)
                end
            end)
        end
    end
})

AutoFarmCoins:AddSlider('AutoCollectDelaySlider', {
    Text = 'Collect Delay (s)',
    Default = 2,
    Min = 0.5,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value) _G.AutoCollectDelay = Value end
})

_G.AutoRollDiceLoop = false
_G.AutoRollDiceDelay = 0.5
AutoFarmDices:AddToggle('AutoRollDiceToggle', {
    Text = 'Auto Roll Dices',
    Default = false,
    Callback = function(Value)
        _G.AutoRollDiceLoop = Value
        if Value then
            task.spawn(function()
                while _G.AutoRollDiceLoop do
                    pcall(function()
                        game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Dice"):WaitForChild("RollState"):InvokeServer()
                    end)
                    task.wait(_G.AutoRollDiceDelay)
                end
            end)
        end
    end
})

AutoFarmDices:AddSlider('AutoRollDiceDelaySlider', {
    Text = 'Roll Delay (s)',
    Default = 0.5,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value) _G.AutoRollDiceDelay = Value end
})

-- =================================================================
-- SHOP TAB CONTENT
-- =================================================================
local AutoBuyDices = Tabs.ShopTab:AddLeftGroupbox("Auto Buy Dices", "shopping-cart")
local AutoBuyPotions = Tabs.ShopTab:AddLeftGroupbox("Auto Buy Potions", "shopping-cart")
local Information = Tabs.ShopTab:AddRightGroupbox("Information", "info")
local AutoBuyPets = Tabs.ShopTab:AddRightGroupbox("Auto Buy Pets", "shopping-cart")

-- Auto Buy Dices
-- [1. DYNAMIC DATA FETCHER]
local function GetDynamicDiceList()
    local plr = game:GetService("Players").LocalPlayer
    local list = {}
    
    -- Coba cari container Shop
    local success, container = pcall(function()
        return plr.PlayerGui.Main.Restock.ScrollingFrame
    end)
    
    if success and container then
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Frame") and string.find(child.Name, "Dice") then
                table.insert(list, child.Name)
            end
        end
        table.sort(list) -- Urutkan abjad
    else
        warn("⚠️ Shop UI belum terload.")
        table.insert(list, "Please Refresh List")
    end
    
    return list
end

-- Inisialisasi awal list
local currentDiceList = GetDynamicDiceList()

-- [DATA & STATE]
local ShopState = {
    SelectedDice = {},
    IsSniperActive = false,
    MaxQuantity = 999, 
    Remote = nil,
    ShopContainer = nil,
    TimerLabel = nil,
    HasBoughtThisCycle = false 
}

-- [LOGIC FUNCTIONS]
local function InitPaths()
    local plr = game:GetService("Players").LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")
    
    if not ShopState.Remote then
        local s, r = pcall(function() return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy") end)
        if s then ShopState.Remote = r end
    end
    if not ShopState.ShopContainer then
        local s, r = pcall(function() return pGui:WaitForChild("Main"):WaitForChild("Restock"):WaitForChild("ScrollingFrame") end)
        if s then ShopState.ShopContainer = r end
    end
    if not ShopState.TimerLabel then
        local s, r = pcall(function() return pGui:WaitForChild("Main"):WaitForChild("Restock"):WaitForChild("Header"):WaitForChild("restock_dur") end)
        if s then ShopState.TimerLabel = r end
    end
end
task.spawn(InitPaths)

local function GetSecondsLeft()
    if not ShopState.TimerLabel then return 9999 end
    local text = ShopState.TimerLabel.Text
    if string.find(string.lower(text), "stock") or text == "00:00" then return 0 end
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then return (tonumber(min) * 60) + tonumber(sec) end
    return 9999
end

local function GetCurrentStock(diceName)
    if not ShopState.ShopContainer then return 9999 end
    local itemFrame = ShopState.ShopContainer:FindFirstChild(diceName)
    if itemFrame then
        for _, obj in pairs(itemFrame:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and string.match(obj.Text, "%d+") then
                local stockNum = tonumber(string.match(obj.Text, "%d+"))
                if stockNum and obj.Text ~= diceName then return stockNum end
            end
        end
    end
    return 9999 
end

local function ExecuteBatchBuy()
    if not ShopState.IsSniperActive then return end
    if #ShopState.SelectedDice > 0 and ShopState.Remote then
        for _, diceName in pairs(ShopState.SelectedDice) do
            task.spawn(function()
                if diceName ~= "None" and diceName ~= "Please Refresh List" then
                    local currentStock = GetCurrentStock(diceName)
                    local finalQty = math.min(ShopState.MaxQuantity, currentStock)
                    if finalQty > 0 then
                        pcall(function()
                            ShopState.Remote:InvokeServer(diceName, finalQty, "dice")
                        end)
                    end
                end
            end)
        end
    end
end

local function StartSniperLoop()
    task.spawn(function()
        while ShopState.IsSniperActive do
            if not ShopState.TimerLabel then InitPaths() end
            local seconds = GetSecondsLeft()
            
            if seconds <= 1 and not ShopState.HasBoughtThisCycle then
                -- Library:Notify({Title="Sniper", Description="Timer 0! Waiting stock update...", Time=1.5})
                task.wait(1.5) 
                
                if not ShopState.IsSniperActive then break end
                
                -- print(">>> SNIPING 1 <<<")
                ExecuteBatchBuy()
                task.wait(0.5) 
                
                if not ShopState.IsSniperActive then break end

                -- print(">>> SNIPING 2 <<<")
                ExecuteBatchBuy()
                
                ShopState.HasBoughtThisCycle = true
                -- Library:Notify({Title="System", Description="Attempted Buy! Waiting reset...", Time=2})
            
            elseif seconds > 10 then
                ShopState.HasBoughtThisCycle = false
            end
            
            task.wait(0.5)
        end
    end)
end

-- [UI COMPONENTS WITH AUTO UPDATE]

-- Tombol Refresh Manual (Sangat Penting)
AutoBuyDices:AddButton({
    Text = '🔄 Refresh Dice List',
    Func = function()
        local newList = GetDynamicDiceList()
        -- Update Dropdown secara realtime
        Options.DiceSelector:SetValues(newList)
        Options.DiceSelector:SetValue({}) -- Reset pilihan biar gak error
        
        Library:Notify({
            Title = "Database Updated",
            Description = "Found " .. #newList .. " Dices available.",
            Time = 2
        })
    end,
    DoubleClick = false,
    Tooltip = 'Click this if new dices are added to the shop'
})

AutoBuyDices:AddDropdown('DiceSelector', {
    Values = currentDiceList, -- Menggunakan list dinamis
    Default = 1,
    Multi = true,
    Searchable = true,
    Text = 'Select Dices',
    Tooltip = 'Select multiple dice to buy automatically',
    Callback = function(Value)
        ShopState.SelectedDice = {}
        for name, isSelected in pairs(Value) do
            if isSelected then
                table.insert(ShopState.SelectedDice, name)
            end
        end
    end
})

AutoBuyDices:AddSlider('MaxQtySlider', {
    Text = 'Max Quantity Buy',
    Default = 999,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        ShopState.MaxQuantity = Value
    end
})

AutoBuyDices:AddToggle('AutoBuyAllDicesToggle', {
    Text = 'Auto Buy All Dices',
    Default = false,
    Tooltip = 'Automatically selects all dices for buying',
    Callback = function(Value)
        if Value then
            local allDices = {}
            for _, diceName in pairs(GetDynamicDiceList()) do
                if diceName ~= "Please Refresh List" then
                    table.insert(allDices, diceName)
                end
            end
            Options.DiceSelector:SetValue(allDices)
            ShopState.SelectedDice = allDices
            Library:Notify({Title="System", Description="All Dices Selected", Time=1})
        else
            Options.DiceSelector:SetValue({})
            ShopState.SelectedDice = {}
            Library:Notify({Title="System", Description="All Dices Deselected", Time=1})
        end
    end
})

AutoBuyDices:AddToggle('AutoBuySelectedDicesToggle', {
    Text = 'Auto Buy Selected Dices',
    Default = false,
    Tooltip = 'Waits for timer 00:00 then buys instantly',
    Callback = function(Value)
        ShopState.IsSniperActive = Value
        if Value then
            if #ShopState.SelectedDice == 0 then
                Library:Notify({Title="Warning", Description="Please select at least 1 Dice!", Time=1})
            else
                Library:Notify({Title="System", Description="Auto Buy Dice Enabled", Time=1})
                StartSniperLoop()
            end
        else
            Library:Notify({Title="System", Description="Auto Buy Dice Disabled", Time=1})
        end
    end
})

-- [AUTO LISTENER]
-- Ini adalah 'Mata-Mata' yang mendeteksi jika ada dadu baru ditambahkan game secara realtime
task.spawn(function()
    local plr = game:GetService("Players").LocalPlayer
    -- Tunggu container ada
    local container = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Restock"):WaitForChild("ScrollingFrame", 10)
    
    if container then
        container.ChildAdded:Connect(function(child)
            if child:IsA("Frame") then
                -- Jika ada anak baru (Dadu baru), update list otomatis
                local newList = GetDynamicDiceList()
                if Options.DiceSelector then
                    Options.DiceSelector:SetValues(newList)
                    -- Opsional: Print di console
                    -- print("New Dice Detected: " .. child.Name)
                end
            end
        end)
    end
end)


-- Auto Buy Potions
-- [1. DYNAMIC DATA FETCHER]
local function GetDynamicPotionList()
    local plr = game:GetService("Players").LocalPlayer
    local list = {}
    
    -- Coba cari container Shop
    local success, container = pcall(function()
        return plr.PlayerGui.Main.Potions.ScrollingFrame
    end)
    
    if success and container then
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Frame") and string.find(child.Name, "Potion") then
                table.insert(list, child.Name)
            end
        end
        table.sort(list) -- Urutkan abjad
    else
        warn("⚠️ Shop UI belum terload.")
        table.insert(list, "Please Refresh List")
    end
    
    return list
end

-- Inisialisasi awal list
local currentPotionList = GetDynamicPotionList()

-- [DATA & STATE]
local ShopState = {
    SelectedPotion = {},
    IsSniperActive = false,
    MaxQuantity = 999, 
    Remote = nil,
    ShopContainer = nil,
    TimerLabel = nil,
    HasBoughtThisCycle = false 
}

-- [LOGIC FUNCTIONS]
local function InitPaths()
    local plr = game:GetService("Players").LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")
    
    if not ShopState.Remote then
        local s, r = pcall(function() return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy") end)
        if s then ShopState.Remote = r end
    end
    if not ShopState.ShopContainer then
        local s, r = pcall(function() return pGui:WaitForChild("Main"):WaitForChild("Potions"):WaitForChild("ScrollingFrame") end)
        if s then ShopState.ShopContainer = r end
    end
    if not ShopState.TimerLabel then
        local s, r = pcall(function() return pGui:WaitForChild("Main"):WaitForChild("Potions"):WaitForChild("Header"):WaitForChild("restock_dur") end)
        if s then ShopState.TimerLabel = r end
    end
end
task.spawn(InitPaths)

local function GetSecondsLeft()
    if not ShopState.TimerLabel then return 9999 end
    local text = ShopState.TimerLabel.Text
    if string.find(string.lower(text), "stock") or text == "00:00" then return 0 end
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then return (tonumber(min) * 60) + tonumber(sec) end
    return 9999
end

local function GetCurrentStock(potionName)
    if not ShopState.ShopContainer then return 9999 end
    local itemFrame = ShopState.ShopContainer:FindFirstChild(potionName)
    if itemFrame then
        for _, obj in pairs(itemFrame:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and string.match(obj.Text, "%d+") then
                local stockNum = tonumber(string.match(obj.Text, "%d+"))
                if stockNum and obj.Text ~= potionName then return stockNum end
            end
        end
    end
    return 9999 
end

local function ExecuteBatchBuy()
    if not ShopState.IsSniperActive then return end
    if #ShopState.SelectedPotion > 0 and ShopState.Remote then
        for _, potionName in pairs(ShopState.SelectedPotion) do
            task.spawn(function()
                if potionName ~= "None" and potionName ~= "Please Refresh List" then
                    local currentStock = GetCurrentStock(potionName)
                    local finalQty = math.min(ShopState.MaxQuantity, currentStock)
                    if finalQty > 0 then
                        pcall(function()
                            ShopState.Remote:InvokeServer(potionName, finalQty, "potion")
                        end)
                    end
                end
            end)
        end
    end
end

local function StartSniperLoop()
    task.spawn(function()
        while ShopState.IsSniperActive do
            if not ShopState.TimerLabel then InitPaths() end
            local seconds = GetSecondsLeft()
            
            if seconds <= 1 and not ShopState.HasBoughtThisCycle then
                -- Library:Notify({Title="Sniper", Description="Timer 0! Waiting stock update...", Time=1.5})
                task.wait(1.5) 
                
                if not ShopState.IsSniperActive then break end
                
                -- print(">>> SNIPING 1 <<<")
                ExecuteBatchBuy()
                task.wait(0.5) 
                
                if not ShopState.IsSniperActive then break end

                -- print(">>> SNIPING 2 <<<")
                ExecuteBatchBuy()
                
                ShopState.HasBoughtThisCycle = true
                -- Library:Notify({Title="System", Description="Attempted Buy! Waiting reset...", Time=2})
            
            elseif seconds > 10 then
                ShopState.HasBoughtThisCycle = false
            end
            
            task.wait(0.5)
        end
    end)
end

-- [UI COMPONENTS WITH AUTO UPDATE]

-- Tombol Refresh Manual (Sangat Penting)
AutoBuyPotions:AddButton({
    Text = '🔄 Refresh Potion List',
    Func = function()
        local newList = GetDynamicPotionList()
        -- Update Dropdown secara realtime
        Options.PotionSelector:SetValues(newList)
        Options.DiceSelector:SetValue({}) -- Reset pilihan biar gak error
        
        Library:Notify({
            Title = "Database Updated",
            Description = "Found " .. #newList .. " Potions available.",
            Time = 2
        })
    end,
    DoubleClick = false,
    Tooltip = 'Click this if new potions are added to the shop'
})

AutoBuyPotions:AddDropdown('PotionSelector', {
    Values = currentPotionList, -- Menggunakan list dinamis
    Default = 1,
    Multi = true,
    Searchable = true,
    Text = 'Select Potions',
    Tooltip = 'Select multiple potions to buy automatically',
    Callback = function(Value)
        ShopState.SelectedPotion = {}
        for name, isSelected in pairs(Value) do
            if isSelected then
                table.insert(ShopState.SelectedPotion, name)
            end
        end
    end
})

AutoBuyPotions:AddSlider('MaxQtySlider', {
    Text = 'Max Quantity Buy',
    Default = 999,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        ShopState.MaxQuantity = Value
    end
})

AutoBuyPotions:AddToggle('AutoBuyAllPotionsToggle', {
    Text = 'Auto Buy All Potions',
    Default = false,
    Tooltip = 'Automatically selects all potions for buying',
    Callback = function(Value)
        if Value then
            local allPotions = {}
            for _, potionName in pairs(GetDynamicPotionList()) do
                if potionName ~= "Please Refresh List" then
                    table.insert(allPotions, potionName)
                end
            end
            Options.PotionSelector:SetValue(allPotions)
            ShopState.SelectedPotion = allPotions
            Library:Notify({Title="System", Description="All Potions Selected", Time=1})
        else
            Options.PotionSelector:SetValue({})
            ShopState.SelectedPotion = {}
            Library:Notify({Title="System", Description="All Potions Deselected", Time=1})
        end
    end
})

AutoBuyPotions:AddToggle('AutoBuySelectedPotionsToggle', {
    Text = 'Auto Buy Selected Potions',
    Default = false,
    Tooltip = 'Waits for timer 00:00 then buys instantly',
    Callback = function(Value)
        ShopState.IsSniperActive = Value
        if Value then
            if #ShopState.SelectedDice == 0 then
                Library:Notify({Title="Warning", Description="Please select at least 1 Potion!", Time=1})
            else
                Library:Notify({Title="System", Description="Auto Buy Potion Enabled", Time=1})
                StartSniperLoop()
            end
        else
            Library:Notify({Title="System", Description="Auto Buy Potion Disabled", Time=1})
        end
    end
})

-- [AUTO LISTENER]
-- Ini adalah 'Mata-Mata' yang mendeteksi jika ada dadu baru ditambahkan game secara realtime
task.spawn(function()
    local plr = game:GetService("Players").LocalPlayer
    -- Tunggu container ada
    local container = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Potions"):WaitForChild("ScrollingFrame", 10)
    
    if container then
        container.ChildAdded:Connect(function(child)
            if child:IsA("Frame") then
                -- Jika ada anak baru (Potion baru), update list otomatis
                local newList = GetDynamicPotionList()
                if Options.PotionSelector then
                    Options.PotionSelector:SetValues(newList)
                    -- Opsional: Print di console
                    -- print("New Potion Detected: " .. child.Name)
                end
            end
        end)
    end
end)

-- Information Box
Information:AddLabel("Auto Buy Dices and Potions Script\n\n- Select the items you want to auto-buy.\n- Set the maximum quantity to purchase each time.\n- Enable 'Auto Buy' to start.\n- The script will wait for the shop to restock and buy the selected items automatically.", true)

-- Auto Buy Pets
-- [1. DYNAMIC DATA FETCHER: EGGS]
local function GetDynamicEggList()
    local list = {}
    
    -- Mencari Model Egg di Workspace
    local success, eggsFolder = pcall(function()
        return workspace:WaitForChild("Eggs", 5) -- Timeout 5 detik
    end)
    
    if success and eggsFolder then
        for _, child in pairs(eggsFolder:GetChildren()) do
            -- Biasanya Egg berbentuk Model dan ada tulisan "Egg"
            if child:IsA("Model") and string.find(child.Name, "Egg") then
                table.insert(list, child.Name)
            end
        end
        table.sort(list) -- Urutkan abjad
    else
        warn("⚠️ Folder 'Eggs' tidak ditemukan di Workspace.")
        table.insert(list, "Please Refresh List")
    end
    
    return list
end

-- Inisialisasi awal list
local currentEggList = GetDynamicEggList()

-- [STATE MANAGEMENT]
local PetShopState = {
    SelectedEggs = {},
    IsAutoBuying = false,
    Delay = 1.1, 
    Quantity = 1, 
    Remote = nil 
}

-- [INIT REMOTE]
local function InitPetRemote()
    if not PetShopState.Remote then
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RegularPet")
        end)
        if success then 
            PetShopState.Remote = result 
        else
            warn("⚠️ Gagal menemukan Remote 'RegularPet'")
            -- Coba cari alternatif jika nama remote beda
        end
    end
end
task.spawn(InitPetRemote)

-- [CORE LOGIC]
local function StartPetBuying()
    task.spawn(function()
        while PetShopState.IsAutoBuying do
            if not PetShopState.Remote then InitPetRemote() end
            
            if PetShopState.Remote then
                for _, eggName in pairs(PetShopState.SelectedEggs) do
                    if not PetShopState.IsAutoBuying then break end
                    
                    if eggName ~= "None" and eggName ~= "Please Refresh List" then
                        pcall(function()
                            -- [ARGS] Sesuaikan dengan script asli Anda
                            local args = {
                                [1] = eggName, 
                                [2] = PetShopState.Quantity
                            }
                            PetShopState.Remote:InvokeServer(unpack(args))
                            -- print("🥚 Buying: " .. eggName)
                        end)
                        
                        -- Jeda mikro antar pembelian dalam satu batch (biar ga crash)
                        task.wait(0.1)
                    end
                end
            end
            
            -- Jeda antar batch pembelian
            task.wait(PetShopState.Delay)
        end
    end)
end

-- [UI COMPONENTS]

-- 1. Refresh Button
AutoBuyPets:AddButton({
    Text = '🔄 Refresh Egg List',
    Func = function()
        local newList = GetDynamicEggList()
        Options.EggSelector:SetValues(newList)
        Options.EggSelector:SetValue({}) 
        
        Library:Notify({
            Title = "Egg Database Updated",
            Description = "Found " .. #newList .. " Eggs available.",
            Time = 2
        })
    end,
    DoubleClick = false,
    Tooltip = 'Click if new eggs are not showing up'
})

-- 2. Dropdown Selector
AutoBuyPets:AddDropdown('EggSelector', {
    Values = currentEggList,
    Default = 1,
    Multi = true,
    Text = 'Select Eggs',
    Tooltip = 'Select which eggs to hatch automatically',
    Callback = function(Value)
        PetShopState.SelectedEggs = {}
        -- Konversi dari table Obsidian {[Name]=true} ke Array {"Name"}
        for name, isSelected in pairs(Value) do
            if isSelected then
                table.insert(PetShopState.SelectedEggs, name)
            end
        end
    end
})

-- 3. Quantity Slider
AutoBuyPets:AddSlider('EggQtySlider', {
    Text = 'Buy Quantity',
    Default = 1,
    Min = 1,
    Max = 100, -- Sesuaikan max jika game membolehkan beli banyak sekaligus
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        PetShopState.Quantity = Value
    end
})

-- 4. Delay Slider
AutoBuyPets:AddSlider('EggDelaySlider', {
    Text = 'Buying Delay (s)',
    Default = 1.1,
    Min = 0.1,
    Max = 5.0,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        PetShopState.Delay = Value
    end
})

-- 5. Toggle Auto Buy
AutoBuyPets:AddToggle('AutoBuyPetsToggle', {
    Text = 'Enable Auto Buy Eggs',
    Default = false,
    Tooltip = 'Starts buying selected eggs repeatedly',
    Callback = function(Value)
        PetShopState.IsAutoBuying = Value
        
        if Value then
            if #PetShopState.SelectedEggs == 0 then
                Library:Notify({Title="Warning", Description="Please select at least 1 Egg!", Time=1})
            else
                Library:Notify({Title="System", Description="Auto Buy Eggs Enabled", Time=1})
                StartPetBuying()
            end
        else
            Library:Notify({Title="System", Description="Auto Buy Eggs Disabled", Time=1})
        end
    end
})

-- =================================================================
-- FLOATING WIDGET SYSTEM
-- =================================================================
local function CreateFloatingWidget(config)
    local Settings = {
        Type = config.Type or "Icon", 
        Content = config.Content, -- Nanti diisi otomatis
        Size = config.Size or UDim2.new(0, 50, 0, 50),
        Color = config.Color or Color3.fromRGB(0, 0, 0), 
        StrokeColor = config.StrokeColor or Color3.fromRGB(255, 255, 255), 
        Position = config.Position or UDim2.new(0.1, 0, 0.1, 0) 
    }

    if getgenv().FloatingWidgetInstance then
        getgenv().FloatingWidgetInstance:Destroy()
    end

    local CoreGui = game:GetService("CoreGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ObsidianFloatingWidget"
    ScreenGui.DisplayOrder = 10000 
    ScreenGui.Parent = CoreGui
    getgenv().FloatingWidgetInstance = ScreenGui 

    local MainFrame = Instance.new("TextButton") 
    MainFrame.Name = "WidgetFrame"
    MainFrame.Size = Settings.Size
    MainFrame.Position = Settings.Position
    MainFrame.BackgroundColor3 = Settings.Color
    MainFrame.BackgroundTransparency = 0
    MainFrame.Text = "" 
    MainFrame.AutoButtonColor = false
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Settings.StrokeColor
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = MainFrame
    
    -- Icon Image
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "IconContent"
    Icon.Size = UDim2.new(0.7, 0, 0.7, 0) -- Ukuran Logo agak besar dikit
    Icon.Position = UDim2.new(0.15, 0, 0.15, 0) -- Tengah
    Icon.BackgroundTransparency = 1
    Icon.Image = Settings.Content
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.ZIndex = 2
    Icon.Parent = MainFrame

    -- Logic Draggable & Toggle
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    local isDragging = false
    MainFrame.InputBegan:Connect(function() isDragging = false end)
    MainFrame.InputChanged:Connect(function() isDragging = true end)
    
    MainFrame.MouseButton1Click:Connect(function()
        if isDragging then return end
        if Library and Library.Toggle then Library:Toggle() 
        elseif Library and Library.MainFrame then Library.MainFrame.Visible = not Library.MainFrame.Visible end
    end)
end

-- =================================================================
-- EKSEKUSI (DENGAN LOGO ANDA)
-- =================================================================

-- 1. Siapkan Link & Nama File
local myLogoUrl = "https://raw.githubusercontent.com/emowbaik/script-emow/refs/heads/master/asset/Logo_emow_transparent.png"
local myLogoFile = "EmowWidgetLogo.png" -- Nama file saat disimpan di HP/PC

-- 2. Download & Load
local logoAsset = GetCustomIcon(myLogoUrl, myLogoFile)

-- 3. Buat Widget
CreateFloatingWidget({
    Type = "Icon",
    Content = logoAsset, -- Masukkan hasil load tadi
    Size = UDim2.new(0, 55, 0, 55), -- Ukuran Tombol
    Color = Color3.fromRGB(15, 15, 15), -- Background Hitam
    StrokeColor = Color3.fromRGB(255, 255, 255) -- Pinggiran Putih
})


------------------------------------------------------------------
-- SETTINGS & UNLOAD
------------------------------------------------------------------
local Keybind = Tabs["UISettings"]:AddLeftGroupbox("Keybind", "keyboard")

Library:OnUnload(function()
    print("Unloaded!", 3)
    getgenv().MspaintInstance = nil
    Library.Unloaded = true
end)

Keybind:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "k", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("Emow/SpinaBaddie")
SaveManager:BuildConfigSection(Tabs["UISettings"]) 
ThemeManager:ApplyToTab(Tabs["UISettings"])
SaveManager:LoadAutoloadConfig()


