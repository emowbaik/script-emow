local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Spin a Baddie 1.3",
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
      FileName = "emow"
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

Rayfield:Notify({
   Title = "Execute",
   Content = "Successfully✅",
   Duration = 5,
   Image = 13047715178
})

local MainTab = Window:CreateTab("Main", nil) -- Title, Image
local FarmTab = Window:CreateTab("Farm", nil) -- Title, Image
-- local MainSection = MainTab:CreateSection("Main")
-- local OtherSection = MainTab:CreateSection("Other")

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

local Dropdown = MainTab:CreateDropdown({
   Name = "Select Area",
   Options = {"Starter World","Pirate Island","Pineapple Paradise"},
   CurrentOption = {"Starter World"},
   MultipleOptions = false,
   Flag = "dropdownarea", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
        print(Option)
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
_G.AutoRollDiceDelay = 2

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

_G.AvailableDice = {}

local function GetPlayerDice()
    local diceList = {}
    local player = game:GetService("Players").LocalPlayer
    
    -- Coba ambil dari ReplicatedStorage
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Coba berbagai path untuk mencari data dice
    local possiblePaths = {
        replicatedStorage:FindFirstChild("PlayerData"),
        replicatedStorage:FindFirstChild("Dice"),
        replicatedStorage:FindFirstChild("updateRollingDice"),
        player:FindFirstChild("PlayerData"),
        player:FindFirstChild("Dice"),
        player:FindFirstChild("updateRollingDice")

    }
    
    for _, path in ipairs(possiblePaths) do
        if path then
            for _, item in ipairs(path:GetChildren()) do
                table.insert(diceList, item.Name)
            end
            if #diceList > 0 then
                break
            end
        end
    end
    
    -- Jika tidak ada data, gunakan default
    if #diceList == 0 then
        diceList = {"none"}
    end
    
    _G.AvailableDice = diceList
    return diceList
end

local diceOptions = GetPlayerDice()

local Dropdown = FarmTab:CreateDropdown({
   Name = "Select Dice",
   Options = diceOptions,
   CurrentOption = {diceOptions[1] or "none"},
   MultipleOptions = false,
   Flag = "dropdownarea1",
   Callback = function(Option)
        getgenv().SelectedDice = Option
   end,
})

local RefreshButton = FarmTab:CreateButton({
   Name = "Refresh Dice List",
   Callback = function()
        local updatedDice = GetPlayerDice()
        Dropdown:Refresh(updatedDice, true)
        Rayfield:Notify({
            Title = "Success",
            Content = "Dice list updated! Found " .. #updatedDice .. " dice.",
            Duration = 3,
            Image = 4483362458
        })
   end,
})