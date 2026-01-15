local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Spin a Baddie by Emow",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Spin a Baddie",
   LoadingSubtitle = "by emow",
   ShowText = "Emow", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "emow-spin-a-buddie" -- Create a custom file name for your hub/game
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- Data
local diceOptions = {
    "Basic Dice",
    "Silver Dice",
    "Golden Dice",
    "Aureline Dice",
    "Crystallum Dice",
    "Diamond Dice",
    "Nebulite Dice",
    "Galaxion Dice",
    "Quantum Dice",
    "Devil Dice",
    "Heaven Dice",
    "Nebula Dice",
    "Singularity Dice",
    "Aqua Dice",
    "Lucky Dice",
    "Void Dice",
    "Ethereal Dice",
    "Celestial Dice",
    "Solar Dice",
    "Abyssal Dice",
    "Hell Dice",
    "Infinity Dice",
    "Blackhole Dice",
    "Death Dice",
    "Paradoxical Dice",
    "Soul Dice",
    "Joker Dice",
    "Reality Dice",
    "Kraken Dice",
    "Seraphic Dice",
    "Galactic Dice"
}

local potionOptions = {
    "Luck Potion 1",
    "Money Potion 1",
    "Luck Potion 2",
    "Money Potion 2",
    "Mutation Chance Potion 1",
    "Luck Potion 3",
    "Money Potion 3"
}

local petOptions = {
    "CatEgg",
    "DogEgg",
    "CubeEgg",
    "SlimeEgg",
    "NullEgg",
    "AquaEgg",
    "MartianEgg",
    "BackroomsEgg"
}

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Welcome to Spin a Baddie script by Emow!",
   Duration = 5,
   Image = 13047715178
})

local MainTab = Window:CreateTab("Main", nil) -- Title, Image
local FarmTab = Window:CreateTab("Farm", nil) -- Title, Image
local ShopTab = Window:CreateTab("Shop", nil) -- Title, Image
local OtherTab = Window:CreateTab("Other", nil) -- Title, Image

local Button = MainTab:CreateButton({
   Name = "Infinite Jump Toggle",
   Callback = function()
       --Toggles the infinite jump between on or off on every script run
_G.infinjump = not _G.infinjump

if _G.infinJumpStarted == nil then
	--Ensures this only runs once to save resources
	_G.infinJumpStarted = true
	
	--Notifies readiness
	game.StarterGui:SetCore("SendNotification", {Title="Youtube Hub"; Text="Infinite Jump Activated!"; Duration=5;})

	--The actual infinite jump
	local plr = game:GetService('Players').LocalPlayer
	local m = plr:GetMouse()
	m.KeyDown:connect(function(k)
		if _G.infinjump then
			if k:byte() == 32 then
			humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
			humanoid:ChangeState('Jumping')
			wait()
			humanoid:ChangeState('Seated')
			end
		end
	end)
end
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed Slider",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderws", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "JumpPower Slider",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderjp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Value)
   end,
})

local Input = MainTab:CreateInput({
   Name = "Walkspeed",
   PlaceholderText = "1-500",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Text)
   end,
})

local FarmSection = FarmTab:CreateSection("Coin Farm")

_G.AutoCollectCoinsLoop = false
_G.AutoCollectDelay = 2

local Toggle = FarmTab:CreateToggle({
   Name = "Auto Collect Coins",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        _G.AutoCollectCoinsLoop = Value
        if Value then
            spawn(function()
                while _G.AutoCollectCoinsLoop do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlaceBestBaddies"):InvokeServer()
                    wait(_G.AutoCollectDelay)
                end
            end)
        end
   end,
})

local DelayInput = FarmTab:CreateInput({
   Name = "Auto Collect Coins Delay (Seconds)",
   PlaceholderText = "text here",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
        local delayValue = tonumber(Text)
        if delayValue and delayValue > 0 then
            _G.AutoCollectDelay = delayValue
        else
            Rayfield:Notify({
                Title = "Input Error",
                Content = "Masukkan angka positif untuk delay!",
                Duration = 3,
                Image = 4483362458
            })
        end
   end,
})

local FarmSection = FarmTab:CreateSection("Dice Farm")

_G.AutoRollDiceLoop = false
_G.AutoRollDiceDelay = 0

local Toggle = FarmTab:CreateToggle({
   Name = "Auto Roll Dice",
   CurrentValue = false,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        _G.AutoRollDiceLoop = Value
        if Value then
            spawn(function()
                while _G.AutoRollDiceLoop do
                    game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Dice"):WaitForChild("RollState"):InvokeServer()
                    wait(_G.AutoRollDiceDelay)
                end
            end)
        end
   end,
})

local DelayInput = FarmTab:CreateInput({
   Name = "Auto Roll Dice Delay (Seconds)",
   PlaceholderText = "text here",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
        local delayValue = tonumber(Text)
        if delayValue and delayValue > 0 then
            _G.AutoRollDiceDelay = delayValue
        else
            Rayfield:Notify({
                Title = "Input Error",
                Content = "Masukkan angka positif untuk delay!",
                Duration = 3,
                Image = 4483362458
            })
        end
   end,
})

local ShopSection = ShopTab:CreateSection("Dice Shop")

-- [DATA & STATE]
local ShopState = {
    SelectedDice = {},
    MasterList = diceOptions, 
    IsSniperActive = false, -- Toggle Utama
    MaxQuantity = 999, 
    Remote = nil,
    ShopContainer = nil,
    TimerLabel = nil, -- Akan diisi otomatis
    
    -- State Internal untuk mencegah spam saat timer 0
    HasBoughtThisCycle = false 
}

-- [1. INIT PATHS]
local function InitPaths()
    local plr = game:GetService("Players").LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")
    
    -- Init Remote
    if not ShopState.Remote then
        local s, r = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy")
        end)
        if s then ShopState.Remote = r end
    end

    -- Init Shop Container (Untuk baca stock - Opsional tapi bagus)
    if not ShopState.ShopContainer then
        local s, r = pcall(function()
            return pGui:WaitForChild("Main"):WaitForChild("Restock"):WaitForChild("ScrollingFrame")
        end)
        if s then ShopState.ShopContainer = r end
    end

    -- Init Timer Label (CRUCIAL)
    if not ShopState.TimerLabel then
        local s, r = pcall(function()
            return pGui:WaitForChild("Main"):WaitForChild("Restock"):WaitForChild("Header"):WaitForChild("restock_dur")
        end)
        if s then 
            ShopState.TimerLabel = r 
            print("✅ Timer Shop Dice Found: " .. r:GetFullName())
        else
            warn("⚠️ Gagal menemukan Timer")
        end
    end
end
task.spawn(InitPaths)

-- [2. HELPER: PARSE TIMER]
-- Mengubah "01:30" menjadi detik (90)
local function GetSecondsLeft()
    if not ShopState.TimerLabel then return 9999 end
    
    local text = ShopState.TimerLabel.Text
    
    -- Jika teksnya "Restocking..." atau "00:00", return 0
    if string.find(string.lower(text), "stock") or text == "00:00" then
        return 0
    end

    -- Pattern Matching MM:SS
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then
        return (tonumber(min) * 60) + tonumber(sec)
    end
    
    return 9999 -- Return angka besar jika format tidak dikenal
end

-- [3. HELPER: GET STOCK (Dari script sebelumnya)]
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

-- [4. CORE ACTION: SINGLE BATCH BUY]
-- Fungsi ini akan dipanggil 2x saat trigger aktif
local function ExecuteBatchBuy()
    -- [FIX 1] Safety Check Terakhir: Jangan beli jika toggle sudah mati
    if not ShopState.IsSniperActive then 
        warn("⚠️ Buy Cancelled: Sniper was turned off!")
        return 
    end

    if #ShopState.SelectedDice > 0 and ShopState.Remote then
        for _, diceName in pairs(ShopState.SelectedDice) do
            task.spawn(function()
                if diceName ~= "None" then
                    local currentStock = GetCurrentStock(diceName)
                    local finalQty = math.min(ShopState.MaxQuantity, currentStock)
                    
                    if finalQty > 0 then
                        pcall(function()
                            local args = {
                                [1] = diceName,
                                [2] = finalQty, 
                                [3] = "dice"
                            }
                            ShopState.Remote:InvokeServer(unpack(args))
                        end)
                    end
                end
            end)
        end
    else
        Rayfield:Notify({Title="Warning", Content="Pilih Dadu Dulu!", Duration=2})
    end
end

-- [5. MAIN SNIPER LOOP]
local function StartSniperLoop()
    task.spawn(function()
        while ShopState.IsSniperActive do
            -- Pastikan Path Ready
            if not ShopState.TimerLabel then InitPaths() end
            
            local seconds = GetSecondsLeft()
            
            -- [LOGIKA UTAMA]
            if seconds <= 1 and not ShopState.HasBoughtThisCycle then
                
                Rayfield:Notify({Title="Timer Shop Dice", Content="Timer 0! Waiting 1.5s...", Duration=2})
                
                -- Script tidur disini menunggu server update stock...
                task.wait(1.5) 
                
                -- [FIX 2 - CRUCIAL]
                -- Bangun dari tidur, CEK LAGI apakah toggle masih nyala?
                -- Jika user mematikan toggle saat menunggu 1.5s tadi, kita batalkan semua.
                if not ShopState.IsSniperActive then 
                    print("🛑 Sniper Cancelled during wait time.")
                    break 
                end
                
                -- EKSEKUSI 1
                print(">>> EXECUTING BUY 1 <<<")
                ExecuteBatchBuy()
                
                task.wait(0.5) 
                
                -- [FIX 3] Cek lagi sebelum serangan kedua
                if not ShopState.IsSniperActive then break end

                -- EKSEKUSI 2
                print(">>> EXECUTING BUY 2 <<<")
                ExecuteBatchBuy()
                
                ShopState.HasBoughtThisCycle = true
                Rayfield:Notify({Title="Timer Shop Dice", Content="Execution Done. Waiting reset...", Duration=2})
            
            elseif seconds > 10 then
                ShopState.HasBoughtThisCycle = false
            end
            
            task.wait(0.5)
        end
    end)
end

-- [UI COMPONENTS]

local StatusLabel = ShopTab:CreateLabel("Timer Shop Dice: OFF")

local DiceDropdown = ShopTab:CreateDropdown({
   Name = "Select Dice Target",
   Options = ShopState.MasterList,
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "dropdownDiceOpt",
   Callback = function(Option)
       ShopState.SelectedDice = Option
   end,
})

local QtySlider = ShopTab:CreateSlider({
   Name = "Max Quantity per Buy",
   Range = {1, 999},
   Increment = 1,
   Suffix = "Items",
   CurrentValue = 999,
   Flag = "sliderQty",
   Callback = function(Value)
       ShopState.MaxQuantity = Value
   end,
})

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Dice",
   CurrentValue = false,
   Flag = "ToggleBuyDice", 
   Callback = function(Value)
       ShopState.IsSniperActive = Value
       
       if Value then
           InitPaths()
           Rayfield:Notify({Title="Timer Shop Dice", Content="Waiting for Restock Timer...", Duration=3})
           StatusLabel:Set("Timer Shop Dice Status: WATCHING TIMER...")
           StartSniperLoop()
       else
           StatusLabel:Set("Timer Shop Dice Status: OFF")
           Rayfield:Notify({Title="Timer Shop Dice", Content="Deactivated", Duration=2})
       end
   end,
})

-- Monitor UI Realtime (Visual Feedback)
task.spawn(function()
    while true do
        if ShopState.IsSniperActive and ShopState.TimerLabel then
             local txt = ShopState.TimerLabel.Text
             if ShopState.HasBoughtThisCycle then
                 StatusLabel:Set("Status: BOUGHT! Waiting next cycle... ("..txt..")")
             else
                 StatusLabel:Set("Status: Waiting... ("..txt..")")
             end
        end
        task.wait(1)
    end
end)

local ShopSection = ShopTab:CreateSection("Potion Shop")

-- [DATA & STATE]
local ShopState = {
    SelectedPotion = {},
    MasterList = potionOptions, 
    IsSniperActive = false, -- Toggle Utama
    MaxQuantity = 999, 
    Remote = nil,
    ShopContainer = nil,
    TimerLabel = nil, -- Akan diisi otomatis
    
    -- State Internal untuk mencegah spam saat timer 0
    HasBoughtThisCycle = false 
}

-- [1. INIT PATHS]
local function InitPaths()
    local plr = game:GetService("Players").LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")
    
    -- Init Remote
    if not ShopState.Remote then
        local s, r = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy")
        end)
        if s then ShopState.Remote = r end
    end

    -- Init Shop Container (Untuk baca stock - Opsional tapi bagus)
    if not ShopState.ShopContainer then
        local s, r = pcall(function()
            return pGui:WaitForChild("Main"):WaitForChild("Potions"):WaitForChild("ScrollingFrame")
        end)
        if s then ShopState.ShopContainer = r end
    end

    -- Init Timer Label (CRUCIAL)
    if not ShopState.TimerLabel then
        local s, r = pcall(function()
            return pGui:WaitForChild("Main"):WaitForChild("Potions"):WaitForChild("Header"):WaitForChild("restock_dur")
        end)
        if s then 
            ShopState.TimerLabel = r 
            print("✅ Timer Shop Potion Found: " .. r:GetFullName())
        else
            warn("⚠️ Gagal menemukan Timer")
        end
    end
end
task.spawn(InitPaths)

-- [2. HELPER: PARSE TIMER]
-- Mengubah "01:30" menjadi detik (90)
local function GetSecondsLeft()
    if not ShopState.TimerLabel then return 9999 end
    
    local text = ShopState.TimerLabel.Text
    
    -- Jika teksnya "Restocking..." atau "00:00", return 0
    if string.find(string.lower(text), "stock") or text == "00:00" then
        return 0
    end

    -- Pattern Matching MM:SS
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then
        return (tonumber(min) * 60) + tonumber(sec)
    end
    
    return 9999 -- Return angka besar jika format tidak dikenal
end

-- [3. HELPER: GET STOCK (Dari script sebelumnya)]
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

-- [4. CORE ACTION: SINGLE BATCH BUY]
-- Fungsi ini akan dipanggil 2x saat trigger aktif
local function ExecuteBatchBuy()
    -- [FIX 1] Safety Check Terakhir: Jangan beli jika toggle sudah mati
    if not ShopState.IsSniperActive then 
        warn("⚠️ Buy Cancelled: Sniper was turned off!")
        return 
    end

    if #ShopState.SelectedPotion > 0 and ShopState.Remote then
        for _, potionName in pairs(ShopState.SelectedPotion) do
            task.spawn(function()
                if potionName ~= "None" then
                    local currentStock = GetCurrentStock(potionName)
                    local finalQty = math.min(ShopState.MaxQuantity, currentStock)
                    
                    if finalQty > 0 then
                        pcall(function()
                            local args = {
                                [1] = potionName,
                                [2] = finalQty, 
                                [3] = "potion"
                            }
                            ShopState.Remote:InvokeServer(unpack(args))
                        end)
                    end
                end
            end)
        end
    else
        Rayfield:Notify({Title="Warning", Content="Pilih Potion Dulu!", Duration=2})
    end
end

-- [5. MAIN SNIPER LOOP]
local function StartSniperLoop()
    task.spawn(function()
        while ShopState.IsSniperActive do
            -- Pastikan Path Ready
            if not ShopState.TimerLabel then InitPaths() end
            
            local seconds = GetSecondsLeft()
            
            -- [LOGIKA UTAMA]
            if seconds <= 1 and not ShopState.HasBoughtThisCycle then
                
                Rayfield:Notify({Title="Timer Shop Potion", Content="Timer 0! Waiting 1.5s...", Duration=2})
                
                -- Script tidur disini menunggu server update stock...
                task.wait(1.5) 
                
                -- [FIX 2 - CRUCIAL]
                -- Bangun dari tidur, CEK LAGI apakah toggle masih nyala?
                -- Jika user mematikan toggle saat menunggu 1.5s tadi, kita batalkan semua.
                if not ShopState.IsSniperActive then 
                    print("🛑 Sniper Cancelled during wait time.")
                    break 
                end
                
                -- EKSEKUSI 1
                print(">>> EXECUTING BUY 1 <<<")
                ExecuteBatchBuy()
                
                task.wait(0.5) 
                
                -- [FIX 3] Cek lagi sebelum serangan kedua
                if not ShopState.IsSniperActive then break end

                -- EKSEKUSI 2
                print(">>> EXECUTING BUY 2 <<<")
                ExecuteBatchBuy()
                
                ShopState.HasBoughtThisCycle = true
                Rayfield:Notify({Title="Timer Shop Potion", Content="Execution Done. Waiting reset...", Duration=2})
            
            elseif seconds > 10 then
                ShopState.HasBoughtThisCycle = false
            end
            
            task.wait(0.5)
        end
    end)
end

-- [UI COMPONENTS]

local StatusLabel = ShopTab:CreateLabel("Timer Shop Potion: OFF")

local PotionDropdown = ShopTab:CreateDropdown({
   Name = "Select Potion Target",
   Options = ShopState.MasterList,
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "dropdownPotionOpt",
   Callback = function(Option)
       ShopState.SelectedPotion = Option
   end,
})

local QtySlider = ShopTab:CreateSlider({
   Name = "Max Quantity per Buy",
   Range = {1, 999},
   Increment = 1,
   Suffix = "Items",
   CurrentValue = 999,
   Flag = "sliderQty",
   Callback = function(Value)
       ShopState.MaxQuantity = Value
   end,
})

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Potion",
   CurrentValue = false,
   Flag = "ToggleBuyPotion", 
   Callback = function(Value)
       ShopState.IsSniperActive = Value
       
       if Value then
           InitPaths()
           Rayfield:Notify({Title="Timer Shop Potion", Content="Waiting for Restock Timer...", Duration=3})
           StatusLabel:Set("Timer Shop Potion Status: WATCHING TIMER...")
           StartSniperLoop()
       else
           StatusLabel:Set("Timer Shop Potion Status: OFF")
           Rayfield:Notify({Title="Timer Shop Potion", Content="Deactivated", Duration=2})
       end
   end,
})

-- Monitor UI Realtime (Visual Feedback)
task.spawn(function()
    while true do
        if ShopState.IsSniperActive and ShopState.TimerLabel then
             local txt = ShopState.TimerLabel.Text
             if ShopState.HasBoughtThisCycle then
                 StatusLabel:Set("Status: BOUGHT! Waiting next cycle... ("..txt..")")
             else
                 StatusLabel:Set("Status: Waiting... ("..txt..")")
             end
        end
        task.wait(1)
    end
end)

local ShopSection = ShopTab:CreateSection("Pet Shop")

-- [STATE MANAGEMENT]
local PetShopState = {
    SelectedPets = {},
    IsAutoBuying = false,
    Delay = 1.1, 
    Quantity = 1, -- Default jumlah beli
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
        end
    end
end
task.spawn(InitPetRemote)

-- [CORE LOGIC]
local function StartPetBuying()
    task.spawn(function()
        while PetShopState.IsAutoBuying do
            if PetShopState.Remote then
                
                for _, petName in pairs(PetShopState.SelectedPets) do
                    if not PetShopState.IsAutoBuying then break end
                    
                    if petName ~= "None" then
                        pcall(function()
                            -- [MODIFIKASI PAYLOAD]
                            local args = {
                                [1] = petName, 
                                [2] = PetShopState.Quantity -- Menggunakan nilai dari Slider
                            }
                            
                            PetShopState.Remote:InvokeServer(unpack(args))
                            print("🥚 Buying: " .. petName .. " | Amount: " .. PetShopState.Quantity)
                        end)
                        
                        task.wait(0.1)
                    end
                end
            end
            task.wait(PetShopState.Delay)
        end
    end)
end

-- [UI COMPONENTS]

local PetDropdown = ShopTab:CreateDropdown({
   Name = "Select Egg/Pet",
   Options = petOptions,
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "dropdownPet",
   Callback = function(Option)
       PetShopState.SelectedPets = Option
   end,
})

-- [SLIDER KUANTITAS BARU]
local QtySlider = ShopTab:CreateSlider({
   Name = "Buy Quantity (Amount)",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Pets",
   CurrentValue = 1,
   Flag = "sliderPetQty",
   Callback = function(Value)
       PetShopState.Quantity = Value
   end,
})

local DelaySlider = ShopTab:CreateSlider({
   Name = "Buying Delay",
   Range = {0.5, 5.0},
   Increment = 0.1,
   Suffix = "Seconds",
   CurrentValue = 1.1,
   Flag = "sliderPetDelay",
   Callback = function(Value)
       PetShopState.Delay = Value
   end,
})

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Pets",
   CurrentValue = false,
   Flag = "ToggleAutoBuyPets",
   Callback = function(Value)
       PetShopState.IsAutoBuying = Value
       
       if Value then
           -- Validasi
           if #PetShopState.SelectedPets == 0 or (#PetShopState.SelectedPets == 1 and PetShopState.SelectedPets[1] == "None") then
               Rayfield:Notify({
                   Title = "Warning",
                   Content = "Pilih Egg dulu di menu dropdown!",
                   Duration = 3,
                   Image = 4483362458
               })
               PetShopState.IsAutoBuying = false
               return 
           end

           if not PetShopState.Remote then InitPetRemote() end
           
           Rayfield:Notify({Title="System", Content="Auto Buy Started (Qty: "..PetShopState.Quantity..")", Duration=2})
           StartPetBuying()
       else
           Rayfield:Notify({Title="System", Content="Stopped", Duration=2})
       end
   end,
})

local OtherSection = OtherTab:CreateSection("Notification")

-- Kita butuh tempat untuk menyimpan koneksi event agar bisa dimatikan nanti (Memory Management)
_G.NotifConnections = {}

local toggleHideNotification = OtherTab:CreateToggle({
   Name = "Hide Notifications (No Flicker/Instant)",
   CurrentValue = false,
   Flag = "ToggleHideNotifications",
   Callback = function(Value)
       _G.HideNotifications = Value

       -- Fungsi pembantu untuk mematikan satu objek
       local function suppressObject(child)
           if child:IsA("GuiObject") then
               -- 1. Matikan saat itu juga
               child.Visible = false 
               
               -- 2. Pasang 'Satpam' (Event Listener) di objek ini
               -- Jika game mencoba mengubah Visible jadi true, kita paksa balik ke false INSTAN
               local conn = child:GetPropertyChangedSignal("Visible"):Connect(function()
                   if _G.HideNotifications and child.Visible then
                       child.Visible = false
                   end
               end)
               table.insert(_G.NotifConnections, conn)
           end
       end

       if Value then
           -- === AKTIFKAN ===
           local plr = game:GetService("Players").LocalPlayer
           local pGui = plr:WaitForChild("PlayerGui")
           local botNot = pGui:WaitForChild("bot_not", 5) -- Tunggu max 5 detik
           
           if botNot and botNot:FindFirstChild("Frame") then
               local frame = botNot.Frame

               -- A. Sapu bersih notifikasi yang SUDAH ada
               for _, child in pairs(frame:GetChildren()) do
                   suppressObject(child)
               end

               -- B. Pasang radar untuk notifikasi yang BARU AKAN muncul (Future Proof)
               local addedConn = frame.ChildAdded:Connect(function(child)
                   suppressObject(child)
               end)
               table.insert(_G.NotifConnections, addedConn)
           end
           
           Rayfield:Notify({Title="System", Content="Anti-Flicker Mode ON", Duration=2})

       else
           -- === NONAKTIFKAN ===
           -- 1. Putuskan semua kabel listener (Disconnect) agar tidak memakan memori/CPU
           for _, conn in pairs(_G.NotifConnections) do
               if conn then conn:Disconnect() end
           end
           _G.NotifConnections = {} -- Kosongkan tabel

           -- 2. Munculkan kembali UI secara manual
           pcall(function()
               local frame = game:GetService("Players").LocalPlayer.PlayerGui.bot_not.Frame
               for _, child in pairs(frame:GetChildren()) do
                   if child:IsA("GuiObject") then
                       child.Visible = true
                   end
               end
           end)
           
           Rayfield:Notify({Title="System", Content="Notifications Restored", Duration=2})
       end
   end,
})

-- Variabel global untuk menyimpan "kabel" koneksi agar bisa dicabut nanti
_G.AntiAfkConnection = nil

local Toggle = OtherTab:CreateToggle({
   Name = "Anti-AFK Mode",
   CurrentValue = false,
   Flag = "ToggleAntiAFK",
   Callback = function(Value)
       local virtualUser = game:GetService("VirtualUser")
       local player = game:GetService("Players").LocalPlayer

       if Value then
           -- === ENABLE ===
           -- Pastikan tidak ada koneksi ganda sebelum membuat yang baru
           if _G.AntiAfkConnection then
               _G.AntiAfkConnection:Disconnect()
           end

           -- Kita simpan "objek koneksi"-nya ke dalam variabel
           _G.AntiAfkConnection = player.Idled:Connect(function()
               virtualUser:CaptureController()
               virtualUser:ClickButton2(Vector2.new())
               print("[Anti-AFK] System detected idle. Simulated input sent.")
           end)

           Rayfield:Notify({
               Title = "System",
               Content = "Anti-AFK Enabled (Protected)",
               Duration = 3,
               Image = 4483362458
           })
       else
           -- === DISABLE ===
           -- Jika koneksi ada, kita putuskan (cabut kabelnya)
           if _G.AntiAfkConnection then
               _G.AntiAfkConnection:Disconnect()
               _G.AntiAfkConnection = nil -- Kosongkan variabel
           end

           Rayfield:Notify({
               Title = "System",
               Content = "Anti-AFK Disabled",
               Duration = 3,
               Image = 4483362458
           })
       end
   end,
})

-- Custom Path Explorer
local customPathDebug = ""

local DebugPathInput = OtherTab:CreateInput({
   Name = "🔍 Custom Path Explorer",
   PlaceholderText = "input",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
        customPathDebug = Text
   end,
})

local function exploreCustomPath(pathString)
    if pathString == "" then
        print("[ERROR] Path tidak boleh kosong!")
        return
    end
    
    local success, result = pcall(function()
        return loadstring("return " .. pathString)()
    end)
    
    if not success or result == nil then
        print("\n[❌ ERROR] Path tidak valid: " .. pathString)
        print("[💡 TIP] Pastikan path Lua yang benar\n")
        return
    end
    
    -- Path valid - tampilkan info lengkap
    local console = "\n" .. string.rep("═", 75)
    console = console .. "\n✓ CUSTOM PATH EXPLORER - PATH VALID"
    console = console .. "\n" .. string.rep("═", 75)
    console = console .. "\n\n📍 INPUT PATH:\n   " .. pathString
    
    local obj = result
    local objType = type(obj)
    
    -- Info dasar
    console = console .. "\n\n📊 OBJECT INFO:"
    console = console .. "\n   • Type: " .. objType
    if typeof then
        console = console .. "\n   • Class: " .. typeof(obj)
    end
    console = console .. "\n   • Reference: " .. tostring(obj)
    
    -- Properties untuk Instance
    if typeof and typeof(obj) == "Instance" then
        console = console .. "\n\n🏷️ PROPERTIES:"
        local props = {"Name", "Parent", "ClassName", "Enabled"}
        for _, prop in ipairs(props) do
            local pSuccess, pValue = pcall(function() return obj[prop] end)
            if pSuccess then
                local pType = type(pValue)
                if pType == "userdata" or (typeof and typeof(pValue) == "Instance") then
                    console = console .. "\n   • " .. prop .. " (" .. pType .. "): " .. (typeof and typeof(pValue) or type(pValue))
                else
                    console = console .. "\n   • " .. prop .. " (" .. pType .. "): " .. tostring(pValue)
                end
            end
        end
    end
    
    -- Children
    if (typeof and typeof(obj) == "Instance") or (objType == "table" and obj.GetChildren) then
        local children = obj:GetChildren()
        console = console .. "\n\n👶 CHILDREN: " .. #children
        
        if #children == 0 then
            console = console .. "\n   [Tidak ada children]"
        else
            console = console .. "\n   " .. string.rep("─", 70)
            for i, child in ipairs(children) do
                local childType = typeof(child) or type(child)
                console = console .. "\n   [" .. i .. "] " .. child.Name .. " (" .. childType .. ")"
            end
        end
    end
    
    -- Table content (untuk table yang bukan Instance)
    if objType == "table" and not (typeof and typeof(obj) == "Instance") then
        console = console .. "\n\n📦 TABLE CONTENTS:"
        console = console .. "\n   " .. string.rep("─", 70)
        
        local keyCount = 0
        for k, v in pairs(obj) do
            keyCount = keyCount + 1
            local vType = type(v)
            if vType == "table" then
                console = console .. "\n   • " .. tostring(k) .. " (table) → {...}"
            elseif vType == "function" then
                console = console .. "\n   • " .. tostring(k) .. " (function)"
            else
                console = console .. "\n   • " .. tostring(k) .. " (" .. vType .. "): " .. tostring(v)
            end
        end
        console = console .. "\n   Total keys: " .. keyCount
    end
    
    console = console .. "\n\n" .. string.rep("═", 75) .. "\n"
    print(console)
end

local ExplorePathButton = OtherTab:CreateButton({
   Name = "▶️ Explore Path",
   Callback = function()
        if customPathDebug == "" then
            Rayfield:Notify({
                Title = "Input Error",
                Content = "Masukkan path dulu!",
                Duration = 2,
                Image = 4483362458
            })
            return
        end
        
        exploreCustomPath(customPathDebug)
        
        Rayfield:Notify({
            Title = "Explorer",
            Content = "✓ Check F9 console untuk hasil!",
            Duration = 2,
            Image = 13047715178
        })
   end,
})

Rayfield:LoadConfiguration() -- Load the configuration file