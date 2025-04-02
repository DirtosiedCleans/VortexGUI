> don't know how to code? and you want to try it? copy paste this! 🔥

```lua
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/refs/heads/main/Source.lua"))()

-- basic window
local window = gui.new({
    Title = "vortex",
    Drag = true
})

-- combat tab
local combatTab = window:Tab("combat")

-- kill aura
combatTab:Toggle("kill aura", false, function(state)
    _G.killaura = state
    while _G.killaura do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
        wait()
    end
end)

-- player tab
local playerTab = window:Tab("player")

-- god mode
playerTab:Toggle("god mode", false, function(state)
    game.Players.LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
end)

-- walkspeed
playerTab:Slider("speed", 16, 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

### settings
```lua
getgenv().vortex_settings = {
    keybind = "RightControl"  -- toggle key
}
```

### combat tab
```lua
local combatTab = window:Tab("combat")

-- instant kill
combatTab:Button("kill all", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            player.Character.Humanoid.Health = 0
        end
    end
end)

-- kill aura
combatTab:Toggle("kill aura", false, function(state)
    _G.killaura = state
    while _G.killaura do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
        wait()
    end
end)

-- reach
combatTab:Slider("reach", 1, 50, 10, function(value)
    _G.reach = value
end)
```

### player tab
```lua
local playerTab = window:Tab("player")

-- god mode
playerTab:Toggle("god mode", false, function(state)
    game.Players.LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
end)

-- walkspeed
playerTab:Slider("speed", 16, 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- jumppower
playerTab:Slider("jump", 50, 500, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

-- noclip
playerTab:Toggle("noclip", false, function(state)
    _G.noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.noclip then
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        end
    end)
end)
```

### teleport tab
```lua
local teleportTab = window:Tab("teleport")

-- locations
teleportTab:Dropdown("teleport", {"spawn", "shop", "boss"}, function(selected)
    local locations = {
        spawn = CFrame.new(0, 10, 0),
        shop = CFrame.new(100, 10, 100),
        boss = CFrame.new(0, 10, 500)
    }
    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[selected]
end)

-- player tp
teleportTab:Dropdown("tp to player", function()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end, function(selected)
    local player = game.Players:FindFirstChild(selected)
    if player then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end)
```

### full example
```lua
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/refs/heads/main/source.lua"))()

getgenv().vortex_settings = {
    keybind = "RightControl"
}

local window = gui.new({
    Title = "vortex",
    Drag = true
})

-- combat
local combatTab = window:Tab("combat")

combatTab:Button("kill all", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            player.Character.Humanoid.Health = 0
        end
    end
end)

combatTab:Toggle("kill aura", false, function(state)
    _G.killaura = state
    while _G.killaura do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
        wait()
    end
end)

combatTab:Slider("reach", 1, 50, 10, function(value)
    _G.reach = value
end)

-- player
local playerTab = window:Tab("player")

playerTab:Toggle("god mode", false, function(state)
    game.Players.LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
end)

playerTab:Slider("speed", 16, 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

playerTab:Slider("jump", 50, 500, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

playerTab:Toggle("noclip", false, function(state)
    _G.noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.noclip then
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        end
    end)
end)

-- teleport
local teleportTab = window:Tab("teleport")

teleportTab:Dropdown("teleport", {"spawn", "shop", "boss"}, function(selected)
    local locations = {
        spawn = CFrame.new(0, 10, 0),
        shop = CFrame.new(100, 10, 100),
        boss = CFrame.new(0, 10, 500)
    }
    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[selected]
end)

teleportTab:Dropdown("tp to player", function()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end, function(selected)
    local player = game.Players:FindFirstChild(selected)
    if player then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end)

-- settings
local settingsTab = window:Tab("settings")

settingsTab:Keybind("toggle gui", "RightControl", function(key)
    getgenv().vortex_settings.keybind = key
end)
```

made by mxxer
