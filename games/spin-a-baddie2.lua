if getgenv().MspaintInstance then
    pcall(function()
        getgenv().MspaintInstance:Unload()
    end)
    
    getgenv().MspaintInstance = nil
    task.wait(0.2) 
end

------------------------------------------------------------------
-- LIBRARY LOADING
------------------------------------------------------------------
local RunService = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

getgenv().MspaintInstance = Library

-- Loading Notification
local Notification = Library:Notify({
    Title = "EMOW Script",
    Description = "Loading...",
    Steps = 1,
})
 
for i = 1, 20 do
    -- Update the notification with the current step
    Notification:ChangeStep(i)
    task.wait(0.1)
end
 
Notification:Destroy()

Library:Notify("Loaded successfully!✅", 2)


------------------------------------------------------------------
-- UI CODE
------------------------------------------------------------------
local Window = Library:CreateWindow({
    Title = "EMOW",
	Footer = "develop by emow v1.0",
    -- Icon = 6023426926,
    GlobalSearch = true,
	NotifySide = "Right",
	ShowCustomCursor = false,
    EnableSidebarResize = true,
})

local Tabs = {
    MainTab = Window:AddTab("Main", "user"),
    FarmTab = Window:AddTab("Farm", "mouse-pointer-click"),
    ShopTab = Window:AddTab("Shop", "shopping-cart"),
     = Window:AddTab("Misc", "settings-2"),
    ["UISettings"] = Window:AddTab("Settings", "settings"),
}

-- Main Tab
local LeftGroupBox1 = Tabs.MainTab:AddLeftGroupbox("Player1", "user")
local LeftGroupBox2 = Tabs.MainTab:AddLeftGroupbox("Player2", "user")

LeftGroupBox1:AddLabel("LeftGroupBox1")
LeftGroupBox2:AddLabel("LeftGroupBox2")




Library:OnUnload(function()
    print("Unloaded!", 3)
    getgenv().MspaintInstance = nil
    Library.Unloaded = true
end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

SaveManager:SetFolder("Emow/SpinaBaddie")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
 
SaveManager:LoadAutoloadConfig()
