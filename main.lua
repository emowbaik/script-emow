local gameScripts = {
    [136599248168660] = "https://raw.githubusercontent.com/emowbaik/script-emow/refs/heads/master/games/solo-hunters-release.lua",
    [79305036070450]  = "https://raw.githubusercontent.com/emowbaik/script-emow/refs/heads/master/games/spin-a-baddie-main.lua"
}

local scriptUrl = gameScripts[game.PlaceId]

if scriptUrl then
    print("Game ID registered! Executing script...")
    loadstring(game:HttpGet(scriptUrl))()
else
    warn("Game ID not registered: " .. game.PlaceId)
end