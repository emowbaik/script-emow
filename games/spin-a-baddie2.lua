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

-- [HELPER 1] Format Standar (Koma: 1,000,000)
local function formatNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

-- [HELPER 2] Format Singkatan (Compact: 1M, 1.5T, 10Qd)
local function abbreviateNumber(n)
    n = tonumber(n)
    if not n then return "0" end
    
    -- Jika angka kurang dari 1000, kembalikan angka asli
    if n < 1000 then return tostring(n) end

    -- Daftar singkatan (Bisa ditambah: Sx, Sp, Oc, N, Dc)
    local suffixes = {"k", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "N", "Dc"}
    
    -- Hitung jumlah nol (Logaritma basis 10)
    local index = math.floor(math.log10(n) / 3)
    
    -- Ambil suffix yang sesuai
    local suffix = suffixes[index]
    
    if suffix then
        -- Bagi angka dengan pembaginya (contoh: 1,500,000 / 1,000,000 = 1.5)
        local divisor = 10 ^ (index * 3)
        local formatted = n / divisor
        
        -- %.2f artinya ambil 2 angka di belakang koma (1.25M)
        -- Kalau mau 1 angka saja ganti jadi %.1f (1.2M)
        return string.format("%.2f%s", formatted, suffix)
    else
        -- Jika angka terlalu besar dan tidak ada di list suffix, pakai format scientific
        return string.format("%.2e", n)
    end
end

-- Loading Notification (Tanpa Gambar, hanya text)
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

------------------------------------------------------------------
-- UI CODE
------------------------------------------------------------------
local Window = Library:CreateWindow({
    Title = "EmowHub",
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
    -- MiscTab = Window:AddTab("Misc", "settings-2"),
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
    -- 1. Buat Container Foto (Agar rapi di tengah)
    local ImageFrame = Instance.new("Frame")
    ImageFrame.Name = "ProfilePictureFrame"
    ImageFrame.BackgroundTransparency = 1
    ImageFrame.Size = UDim2.new(1, 0, 0, 110) -- Tinggi area foto
    ImageFrame.Parent = StatisticPlayer.Container
    
    -- Urutkan paling atas (LayoutOrder)
    ImageFrame.LayoutOrder = -1 

    -- 2. Buat Foto Player
    local ProfileImage = Instance.new("ImageLabel")
    ProfileImage.Name = "Avatar"
    ProfileImage.Size = UDim2.new(0, 100, 0, 100)
    ProfileImage.Position = UDim2.new(0.5, -50, 0, 5) -- Tengah horizontal
    ProfileImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ProfileImage.BackgroundTransparency = 0 -- Sedikit background biar kontras
    ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    ProfileImage.Parent = ImageFrame

    -- 3. Bikin Bulat (Estetik)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0) -- 100% bulat
    UICorner.Parent = ProfileImage
    
    -- 4. Tambah Stroke (Garis Tepi Halus)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.8
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = ProfileImage
end

-- [STATISTIC LABELS]
StatisticPlayer:AddLabel("User: " .. LocalPlayer.DisplayName)
StatisticPlayer:AddLabel("Nickname: @" .. LocalPlayer.Name)
StatisticPlayer:AddLabel("User ID: " .. LocalPlayer.UserId)
StatisticPlayer:AddDivider()

local RollsLabel = StatisticPlayer:AddLabel("Rolls: Loading...")
local CoinsLabel = StatisticPlayer:AddLabel("Coins: Loading...")
local RebirthsLabel = StatisticPlayer:AddLabel("Rebirths: Loading...")

-- Logic Update Statistik
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
            CoinsLabel:SetText("")
            RebirthsLabel:SetText("")
        end
        task.wait(0.5)
    end
end)


-- [PLAYER CONTROLS]
-- Infinite Jump Toggle
PlayerBox:AddToggle('InfJumpToggle', {
    Text = 'Infinite Jump',
    Default = false,
    Callback = function(Value)
        _G.infinjump = Value

        if Value then
            Library:Notify({Title="System", Description="Infinite Jump Enabled", Time=1})
        else
            Library:Notify({Title="System", Description="Infinite Jump Disabled", Time=1})
        end
    end
})

-- WalkSpeed Slider
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

-- Manual WalkSpeed Input
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

-- Hide Notifications Toggle
if not _G.NotifConnections then _G.NotifConnections = {} end
PlayerBox:AddToggle('HideNotificationsToggle', {
    Text = 'Hide Notifications',
    Default = false,
    Callback = function(Value)
        _G.HideNotifications = Value

        -- [HELPER FUNCTION] Didefinisikan di dalam atau di luar tidak masalah, 
        -- tapi harus dipanggil di dalam sini.
        local function suppressObject(child)
            if child:IsA("GuiObject") then
                child.Visible = false 
                
                local conn = child:GetPropertyChangedSignal("Visible"):Connect(function()
                    if _G.HideNotifications and child.Visible then
                        child.Visible = false
                    end
                end)
                table.insert(_G.NotifConnections, conn)
            end
        end

        -- [LOGIKA UTAMA]
        if Value then
            -- === AKTIFKAN ===
            local plr = game:GetService("Players").LocalPlayer
            local pGui = plr:WaitForChild("PlayerGui")
            -- Gunakan pcall untuk keamanan jika UI belum ada
            local success, botNot = pcall(function() 
                return pGui:WaitForChild("bot_not", 5) 
            end)
            
            if success and botNot and botNot:FindFirstChild("Frame") then
                local frame = botNot.Frame

                for _, child in pairs(frame:GetChildren()) do
                    suppressObject(child)
                end

                local addedConn = frame.ChildAdded:Connect(function(child)
                    suppressObject(child)
                end)
                table.insert(_G.NotifConnections, addedConn)

                Library:Notify({Title="System", Description="Hide Notifications Enabled", Time=1})
            else
                Library:Notify({Title="Error", Description="UI 'bot_not' not found!", Time=1})
                -- Opsional: Matikan toggle balik jika gagal
            end

        else
            -- === NONAKTIFKAN (RESTORE) ===
            for _, conn in pairs(_G.NotifConnections) do
                if conn then conn:Disconnect() end
            end
            _G.NotifConnections = {} -- Kosongkan tabel

            pcall(function()
                local plr = game:GetService("Players").LocalPlayer
                local frame = plr.PlayerGui.bot_not.Frame
                for _, child in pairs(frame:GetChildren()) do
                    if child:IsA("GuiObject") then
                        child.Visible = true
                    end
                end
            end)

            Library:Notify({Title="System", Description="Hide Notifications Disabled", Time=1})
        end
    end
})

-- Anti-AFK Toggle
PlayerBox:AddToggle('AntiAfkToggle', {
    Text = 'Anti-AFK Mode',
    Default = false,
    Callback = function(Value)
        local player = game:GetService("Players").LocalPlayer
        local virtualUser = game:GetService("VirtualUser")

        if Value then
            -- === ENABLE ===
            if _G.AntiAfkConnection then
                pcall(function() 
                    _G.AntiAfkConnection:Disconnect() 
                end)
                _G.AntiAfkConnection = nil
            end

            _G.AntiAfkConnection = player.Idled:Connect(function()
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new())
            end)

            Library:Notify({Title ="System", Description="Anti-AFK Enabled", Time=1})
        else
            -- === DISABLE ===
            if _G.AntiAfkConnection then
                pcall(function() 
                    _G.AntiAfkConnection:Disconnect() 
                end)
                _G.AntiAfkConnection = nil
            end
            
            Library:Notify({Title ="System", Description="Anti-AFK Disabled", Time=1})
        end
    end
})

-- Loop Anti-Reset WalkSpeed
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

-- Logic Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.infinjump then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- =================================================================
-- FARM TAB CONTENT
-- =================================================================
local AutoFarmCoins = Tabs.FarmTab:AddLeftGroupbox("Auto Farm Collect Coins", "mouse-pointer-click")
local AutoFarmDices = Tabs.FarmTab:AddRightGroupbox("Auto Farm Rolling Dices", "mouse-pointer-click")


-- Auto Collect Coins
_G.AutoCollectCoinsLoop = false
_G.AutoCollectDelay = 2
AutoFarmCoins:AddToggle('AutoCollectCoinsToggle', {
    Text = 'Auto Collect Coins',
    Default = false,
    Callback = function(Value)
        _G.AutoCollectCoinsLoop = Value

        if Value then
            Library:Notify({Title="System", Description="Auto Collect Coins Enabled", Time=1})
            task.spawn(function()
                while _G.AutoCollectCoinsLoop do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlaceBestBaddies"):InvokeServer()
                    task.wait(_G.AutoCollectDelay)
                end
            end)
        else
            Library:Notify({Title="System", Description="Auto Collect Coins Disabled", Time=1})
        end
    end
})

AutoFarmCoins:AddSlider('AutoCollectDelaySlider', {
    Text = 'Collect Delay (seconds)',
    Default = 2,
    Min = 0.5,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.AutoCollectDelay = Value
    end
})

-- Auto Roll Dices
_G.AutoRollDiceLoop = false
_G.AutoRollDiceDelay = 0
AutoFarmDices:AddToggle('AutoRollDiceToggle', {
    Text = 'Auto Roll Dices',
    Default = false,
    Callback = function(Value)
        _G.AutoRollDiceLoop = Value

        if Value then
            Library:Notify({Title="System", Description="Auto Roll Dices Enabled", Time=1})
            task.spawn(function()
                while _G.AutoRollDiceLoop do
                    game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Dice"):WaitForChild("RollState"):InvokeServer()
                    task.wait(_G.AutoRollDiceDelay)
                end
            end)
        else
            Library:Notify({Title="System", Description="Auto Roll Dices Disabled", Time=1})
        end
    end
})

AutoFarmDices:AddSlider('AutoRollDiceDelaySlider', {
    Text = 'Roll Delay (seconds)',
    Default = 0.5,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.AutoRollDiceDelay = Value
    end
})

------------------------------------------------------------------
-- SHOP TAB CONTENT
------------------------------------------------------------------



------------------------------------------------------------------
-- SETTINGS & UNLOAD
------------------------------------------------------------------
Library:OnUnload(function()
    print("Unloaded!", 3)
    getgenv().MspaintInstance = nil
    Library.Unloaded = true
end)

Library.ToggleKeybind = Options.MenuKeybind 

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("Emow/SpinaBaddie")
SaveManager:BuildConfigSection(Tabs["UISettings"]) 
ThemeManager:ApplyToTab(Tabs["UISettings"])
SaveManager:LoadAutoloadConfig()