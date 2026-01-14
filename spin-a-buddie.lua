local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Spin a Baddie by Emow",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Spin a Baddie",
   LoadingSubtitle = "by emow",
   ShowText = "Emow", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

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
   Title = "Execute",
   Content = "Successfully✅",
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

local ShopSection = ShopTab:CreateSection("Dice Shop (RESTOCK TARGET)")

-- [DATA & STATE]
local ShopState = {
    SelectedDice = {},
    MasterList = diceOptions, 
    IsAutoBuying = false,
    Delay = 0.6, 
    MaxQuantity = 999, 
    Remote = nil,
    ShopContainer = nil 
}

-- [INIT PATH: TARGET RESTOCK]
-- Sesuai temuan Anda: PlayerGui.Main.Restock.ScrollingFrame
local function InitShopPath()
    local plr = game:GetService("Players").LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")
    
    local success, result = pcall(function()
        return pGui:WaitForChild("Main"):WaitForChild("Restock"):WaitForChild("ScrollingFrame")
    end)
    
    if success and result then
        ShopState.ShopContainer = result
        print("✅ [SYSTEM] Target Shop Ditemukan: " .. result:GetFullName())
    else
        warn("⚠️ [SYSTEM] Gagal menemukan 'Restock.ScrollingFrame'. Buka menu Shop dulu!")
    end
end
task.spawn(InitShopPath)

-- [INIT REMOTE]
local function InitRemote()
    if not ShopState.Remote then
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy")
        end)
        if success then ShopState.Remote = result end
    end
end
InitRemote()

-- [THE EYES: SCANNER STOCK CERDAS]
local function GetCurrentStock(diceName)
    if not ShopState.ShopContainer then InitShopPath() end
    if not ShopState.ShopContainer then return 9999 end

    -- Cari folder item (Misal: "Silver Dice")
    local itemFrame = ShopState.ShopContainer:FindFirstChild(diceName)
    
    if itemFrame then
        -- METODE SCAN: Cari text apapun yang punya angka di dalam folder item ini
        for _, obj in pairs(itemFrame:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local text = obj.Text
                
                -- Filter: Abaikan nama dadu itu sendiri, cari angka
                -- Logika: Jika text mengandung angka DAN (bukan nama dadu atau mengandung kata kunci)
                local hasNumber = string.match(text, "%d+")
                
                if hasNumber then
                    -- Bersihkan text, ambil angkanya saja
                    -- Contoh: "Stock: 67" -> 67
                    local stockNum = tonumber(string.match(text, "%d+"))
                    
                    -- Validasi tambahan: Stock biasanya tidak mungkin sama persis dengan nama dadu
                    if stockNum and text ~= diceName then
                        return stockNum
                    end
                end
            end
        end
        
        -- JIKA GAGAL DI FOLDER ITEM, CEK OPSI 'OPTIONS.BUYMAX' (EXPERIMENTAL)
        -- Ini hanya bekerja jika item tersebut SEDANG DIPILIH di game
        -- Risiko: Bisa salah baca jika UI menampilkan dadu yang berbeda
        local optionsFrame = ShopState.ShopContainer:FindFirstChild("OPTIONS")
        if optionsFrame then
             local buyMaxBtn = optionsFrame:FindFirstChild("BUYMAX") or optionsFrame:FindFirstChild("BUY MAX")
             if buyMaxBtn and buyMaxBtn:IsA("TextButton") then
                 local text = buyMaxBtn.Text -- Misal: "Buy Max (67)"
                 local stockNum = tonumber(string.match(text, "%d+"))
                 if stockNum then return stockNum end
             end
        end
    end
    
    -- Fallback: Jika script buta (tidak nemu angka), asumsikan stock banyak
    -- Agar script tetap jalan mencoba membeli
    return 9999 
end

-- [CORE ENGINE]
local function ProcessPurchase()
    task.spawn(function()
        while ShopState.IsAutoBuying do
            if ShopState.Remote and #ShopState.SelectedDice > 0 then
                
                for _, diceName in pairs(ShopState.SelectedDice) do
                    task.spawn(function()
                        if diceName ~= "None" and diceName ~= "No Dice Found" then
                            
                            -- 1. Baca Stock
                            local currentStock = GetCurrentStock(diceName)
                            
                            -- 2. Hitung Safety Limit
                            -- Jika currentStock 9999 (gagal baca), dia akan ikut MaxQuantity user
                            local finalQty = math.min(ShopState.MaxQuantity, currentStock)
                            
                            if finalQty > 0 then
                                pcall(function()
                                    local args = {
                                        [1] = diceName,
                                        [2] = finalQty, 
                                        [3] = "dice"
                                    }
                                    ShopState.Remote:InvokeServer(unpack(args))
                                    print("🛒 Buy: " .. diceName .. " | Qty: " .. finalQty .. " (Detected Stock: " .. currentStock .. ")")
                                end)
                            end
                        end
                    end)
                end
                task.wait(ShopState.Delay)
            else
                if ShopState.IsAutoBuying and #ShopState.SelectedDice == 0 then
                   Rayfield:Notify({Title="Warning", Content="Pilih Dadu Dulu!", Duration=3})
                   ShopState.IsAutoBuying = false
                   break
                end
                task.wait(1)
            end
        end
    end)
end

-- [UI COMPONENTS]

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
   Name = "Max Buy Quantity (Target)",
   Range = {1, 999},
   Increment = 1,
   Suffix = "Items",
   CurrentValue = 999,
   Flag = "sliderQty",
   Callback = function(Value)
       ShopState.MaxQuantity = Value
   end,
})

local DelaySlider = ShopTab:CreateSlider({
   Name = "Server Cooldown (Delay)",
   Range = {0.1, 2.0},
   Increment = 0.1,
   Suffix = "Seconds",
   CurrentValue = 0.6,
   Flag = "sliderDelayBuy",
   Callback = function(Value)
       ShopState.Delay = Value
   end,
})

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Dice",
   CurrentValue = false,
   Flag = "ToggleAutoBuyDice", 
   Callback = function(Value)
       ShopState.IsAutoBuying = Value
       if Value then
           InitShopPath() -- Refresh path saat start
           if not ShopState.Remote then InitRemote() end
           Rayfield:Notify({Title="System", Content="Smart Buy Started", Duration=2})
           ProcessPurchase()
       else
           Rayfield:Notify({Title="System", Content="Stopped", Duration=2})
       end
   end,
})

local ShopSection = ShopTab:CreateSection("Potion Shop (RESTOCK TARGET)")

-- [DATA & STATE]
local ShopState = {
    SelectedPotion = {},
    MasterList = potionOptions, 
    IsAutoBuying = false,
    Delay = 0.6, 
    MaxQuantity = 999, 
    Remote = nil,
    ShopContainer = nil 
}

-- [INIT PATH: TARGET RESTOCK]
-- Sesuai temuan Anda: PlayerGui.Main.Restock.ScrollingFrame
local function InitShopPath()
    local plr = game:GetService("Players").LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")
    
    local success, result = pcall(function()
        return pGui:WaitForChild("Main"):WaitForChild("Potions"):WaitForChild("ScrollingFrame")
    end)
    
    if success and result then
        ShopState.ShopContainer = result
        print("✅ [SYSTEM] Target Shop Ditemukan: " .. result:GetFullName())
    else
        warn("⚠️ [SYSTEM] Gagal menemukan 'Restock.ScrollingFrame'. Buka menu Shop dulu!")
    end
end
task.spawn(InitShopPath)

-- [INIT REMOTE]
local function InitRemote()
    if not ShopState.Remote then
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy")
        end)
        if success then ShopState.Remote = result end
    end
end
InitRemote()

-- [THE EYES: SCANNER STOCK CERDAS]
local function GetCurrentStock(potionName)
    if not ShopState.ShopContainer then InitShopPath() end
    if not ShopState.ShopContainer then return 9999 end

    local itemFrame = ShopState.ShopContainer:FindFirstChild(potionName)
    
    if itemFrame then
        -- METODE SCAN: Cari text apapun yang punya angka di dalam folder item ini
        for _, obj in pairs(itemFrame:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local text = obj.Text
                
                local hasNumber = string.match(text, "%d+")
                
                if hasNumber then
                    local stockNum = tonumber(string.match(text, "%d+"))
                    
                    if stockNum and text ~= potionName then
                        return stockNum
                    end
                end
            end
        end
        
        local optionsFrame = ShopState.ShopContainer:FindFirstChild("OPTIONS")
        if optionsFrame then
             local buyMaxBtn = optionsFrame:FindFirstChild("BUYMAX") or optionsFrame:FindFirstChild("BUY MAX")
             if buyMaxBtn and buyMaxBtn:IsA("TextButton") then
                 local text = buyMaxBtn.Text
                 local stockNum = tonumber(string.match(text, "%d+"))
                 if stockNum then return stockNum end
             end
        end
    end
    
    return 9999 
end

-- [CORE ENGINE]
local function ProcessPurchase()
    task.spawn(function()
        while ShopState.IsAutoBuying do
            if ShopState.Remote and #ShopState.SelectedPotion > 0 then
                
                for _, potionName in pairs(ShopState.SelectedPotion) do
                    task.spawn(function()
                        if potionName ~= "None" and potionName ~= "No Potion Found" then
                            
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
                                    print("🛒 Buy: " .. potionName .. " | Qty: " .. finalQty .. " (Detected Stock: " .. currentStock .. ")")
                                end)
                            end
                        end
                    end)
                end
                task.wait(ShopState.Delay)
            else
                if ShopState.IsAutoBuying and #ShopState.SelectedPotion == 0 then
                   Rayfield:Notify({Title="Warning", Content="Pilih Dadu Dulu!", Duration=3})
                   ShopState.IsAutoBuying = false
                   break
                end
                task.wait(1)
            end
        end
    end)
end

-- [UI COMPONENTS]

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
   Name = "Max Buy Quantity (Target)",
   Range = {1, 999},
   Increment = 1,
   Suffix = "Items",
   CurrentValue = 999,
   Flag = "sliderQty",
   Callback = function(Value)
       ShopState.MaxQuantity = Value
   end,
})

local DelaySlider = ShopTab:CreateSlider({
   Name = "Server Cooldown (Delay)",
   Range = {0.1, 2.0},
   Increment = 0.1,
   Suffix = "Seconds",
   CurrentValue = 0.6,
   Flag = "sliderDelayBuy",
   Callback = function(Value)
       ShopState.Delay = Value
   end,
})

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Potions",
   CurrentValue = false,
   Flag = "ToggleAutoBuyPotions", 
   Callback = function(Value)
       ShopState.IsAutoBuying = Value
       if Value then
           InitShopPath() -- Refresh path saat start
           if not ShopState.Remote then InitRemote() end
           Rayfield:Notify({Title="System", Content="Smart Buy Started", Duration=2})
           ProcessPurchase()
       else
           Rayfield:Notify({Title="System", Content="Stopped", Duration=2})
       end
   end,
})

local ShopSection = ShopTab:CreateSection("Pet Shop")

local selectPetOptions = {}

local Dropdown = ShopTab:CreateDropdown({
   Name = "Select Pet",
   Options = petOptions,
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "dropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
        selectPetOptions = Option
   end,
})

_G.AutoBuyPetLoop = false
_G.AutoBuyPetDelay = 1.1 -- Saya set sedikit di atas 1 detik karena InvokeServer butuh waktu respon

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Pets",
   CurrentValue = false,
   Flag = "ToggleAutoBuyPets",
   Callback = function(Value)
       _G.AutoBuyPetLoop = Value
       if Value then
           task.spawn(function()
               while _G.AutoBuyPetLoop do
                   -- Cek apakah user sudah memilih dadu di dropdown
                   if #selectPetOptions > 0 then
                       for _, petName in pairs(selectPetOptions) do
                           if not _G.AutoBuyPetLoop then break end 
                           
                           pcall(function()
                               -- MENYUSUN ARGUMEN (Payload)
                               local args = {
                                   [1] = petName,  -- Arg 1: Nama dice (Dinamis dari loop)
                                   [2] = 1,         -- Arg 2: Jumlah (Statik, sesuai spy)
                               }
                               
                               -- EKSEKUSI REMOTE
                               -- Menggunakan InvokeServer sesuai data RemoteSpy Anda
                               game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RegularPet"):InvokeServer(unpack(args))
                               
                           end)
                           
                           task.wait(0.1) -- Jeda mikro agar tidak crash jika beli banyak tipe sekaligus
                       end
                   else
                       -- Feedback visual jika lupa pilih item
                       Rayfield:Notify({
                           Title = "System",
                           Content = "Pilih egg dulu di menu dropdown!",
                           Duration = 3,
                           Image = 4483362458
                       })
                       _G.AutoBuyPetLoop = false 
                   end
                   
                   task.wait(_G.AutoBuyPetDelay)
               end
           end)
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