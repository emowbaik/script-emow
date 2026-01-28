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