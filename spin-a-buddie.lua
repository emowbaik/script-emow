local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Spin a Baddie",
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

local ShopSection = ShopTab:CreateSection("Dice Shop")

local selectDiceOptions = {}

local Dropdown = ShopTab:CreateDropdown({
   Name = "Select Dice",
   Options = diceOptions,
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
        selectDiceOptions = Option
   end,
})

_G.AutoBuyDiceLoop = false
_G.AutoBuyDiceDelay = 1.1 -- Saya set sedikit di atas 1 detik karena InvokeServer butuh waktu respon

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Dice",
   CurrentValue = false,
   Flag = "ToggleAutoBuyDice", 
   Callback = function(Value)
       _G.AutoBuyDiceLoop = Value
       if Value then
           task.spawn(function()
               while _G.AutoBuyDiceLoop do
                   -- Cek apakah user sudah memilih dadu di dropdown
                   if #selectDiceOptions > 0 then
                       for _, diceName in pairs(selectDiceOptions) do
                           if not _G.AutoBuyDiceLoop then break end 
                           
                           pcall(function()
                               -- MENYUSUN ARGUMEN (Payload)
                               local args = {
                                   [1] = diceName,  -- Arg 1: Nama dice (Dinamis dari loop)
                                   [2] = 1,         -- Arg 2: Jumlah (Statik, sesuai spy)
                                   [3] = "dice"     -- Arg 3: Tipe (Statik, sesuai spy)
                               }
                               
                               -- EKSEKUSI REMOTE
                               -- Menggunakan InvokeServer sesuai data RemoteSpy Anda
                               game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy"):InvokeServer(unpack(args))
                               
                           end)
                           
                           task.wait(0.1) -- Jeda mikro agar tidak crash jika beli banyak tipe sekaligus
                       end
                   else
                       -- Feedback visual jika lupa pilih item
                       Rayfield:Notify({
                           Title = "System",
                           Content = "Pilih dadu dulu di menu dropdown!",
                           Duration = 3,
                           Image = 4483362458
                       })
                       _G.AutoBuyDiceLoop = false 
                   end
                   
                   task.wait(_G.AutoBuyDiceDelay)
               end
           end)
       end
   end,
})

local ShopSection = ShopTab:CreateSection("Potion Shop")

local selectPetOptions = {}

local Dropdown = ShopTab:CreateDropdown({
   Name = "Select Potion",
   Options = potionOptions,
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "dropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
        selectPetOptions = Option
   end,
})

_G.AutoBuyPetLoop = false
_G.AutoBuyPotionDelay = 1.1 -- Saya set sedikit di atas 1 detik karena InvokeServer butuh waktu respon

local Toggle = ShopTab:CreateToggle({
   Name = "Auto Buy Selected Potions",
   CurrentValue = false,
   Flag = "ToggleAutoBuyPotions",
   Callback = function(Value)
       _G.AutoBuyPetLoop = Value
       if Value then
           task.spawn(function()
               while _G.AutoBuyPetLoop do
                   -- Cek apakah user sudah memilih dadu di dropdown
                   if #selectPetOptions > 0 then
                       for _, potionName in pairs(selectPetOptions) do
                           if not _G.AutoBuyPetLoop then break end 
                           
                           pcall(function()
                               -- MENYUSUN ARGUMEN (Payload)
                               local args = {
                                   [1] = potionName,  -- Arg 1: Nama dice (Dinamis dari loop)
                                   [2] = 1,         -- Arg 2: Jumlah (Statik, sesuai spy)
                                   [3] = "potion"     -- Arg 3: Tipe (Statik, sesuai spy)
                               }
                               
                               -- EKSEKUSI REMOTE
                               -- Menggunakan InvokeServer sesuai data RemoteSpy Anda
                               game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("buy"):InvokeServer(unpack(args))
                               
                           end)
                           
                           task.wait(0.1) -- Jeda mikro agar tidak crash jika beli banyak tipe sekaligus
                       end
                   else
                       -- Feedback visual jika lupa pilih item
                       Rayfield:Notify({
                           Title = "System",
                           Content = "Pilih potion dulu di menu dropdown!",
                           Duration = 3,
                           Image = 4483362458
                       })
                       _G.AutoBuyPetLoop = false 
                   end
                   
                   task.wait(_G.AutoBuyPotionDelay)
               end
           end)
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
                                   [3] = "potion"     -- Arg 3: Tipe (Statik, sesuai spy)
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

local toggleHideNotification = OtherTab:CreateToggle({
   Name = "Hide Notifications",
   CurrentValue = false,
   Flag = "ToggleHideNotifications",
   Callback = function(Value)
       _G.HideNotifications = Value

       if Value then
           -- Loop aktif untuk 'memaksa' ActiveNotification tetap sembunyi
           task.spawn(function()
               while _G.HideNotifications do
                   pcall(function()
                       local plr = game:GetService("Players").LocalPlayer
                       if plr and plr:FindFirstChild("PlayerGui") then
                           -- Navigasi aman step-by-step sesuai path Anda
                           local gui = plr.PlayerGui:FindFirstChild("bot_not")
                           if gui then
                               local frame = gui:FindFirstChild("Frame")
                               if frame then
                                   local target = frame:FindFirstChild("ActiveNotification")
                                   
                                   -- HANYA matikan ActiveNotification
                                   if target then
                                       target.Visible = false
                                       
                                       -- Opsional: Matikan transparansi background jika masih terlihat kotak kosong
                                       -- target.BackgroundTransparency = 1 
                                   end
                               end
                           end
                       end
                   end)
                   task.wait(0.1) -- Cek sangat cepat (10x per detik) agar tidak sempat berkedip
               end
           end)
           
           Rayfield:Notify({
               Title = "System",
               Content = "ActiveNotification Hidden",
               Duration = 2,
               Image = 4483362458
           })
       else
           -- Restore: Kembalikan visibilitas saat toggle dimatikan
           pcall(function()
               local target = game:GetService("Players").LocalPlayer.PlayerGui.bot_not.Frame.ActiveNotification
               if target then
                   target.Visible = true
               end
           end)
           
           Rayfield:Notify({
               Title = "System",
               Content = "ActiveNotification Restored",
               Duration = 2,
               Image = 4483362458
           })
       end
   end,
})

