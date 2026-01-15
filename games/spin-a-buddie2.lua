if getgenv().MspaintInstance then
    pcall(function()
        getgenv().MspaintInstance:Unload()
    end)
    
    getgenv().MspaintInstance = nil
    task.wait(0.2) 
end

local RunService = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

getgenv().MspaintInstance = Library

Library:Notify("Script Reloaded!", 4)

local Window = Library:CreateWindow({
    Title = "EMOW",
	Footer = "develop by emow v1.0",
    icon = 6023426926,
	-- NotifySide = "Left",
	ShowCustomCursor = false,
    -- EnableSidebarResize = true,
    -- MinSidebarWidth = 200, 
    -- SidebarCompactWidth = 56,
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    UISettings = Window:AddTab("UI Settings", "settings"),
    Farm = Window:AddTab("Farm", "mouse-pointer-click"),
}

Library:OnUnload(function()
    print("Unloaded!", 3)
    getgenv().MspaintInstance = nil
    Library.Unloaded = true
end)