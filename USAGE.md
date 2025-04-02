> don't know how to code? and you want to try it? copy paste this! 🔥

```lua
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/refs/heads/main/source.lua"))()

local window = gui.new({
    Title = "vortex",
    Drag = true
})

local mainTab = window:Tab("main")

mainTab:Button("click me", function()
    print("thanks for using vortex!")
end)
```

### basic settings
```lua
getgenv().vortex_settings = {
    keybind = "RightControl"  -- key to toggle gui
}
```

### button
```lua
mainTab:Button("destroy", function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)
```

### toggle
```lua
local enabled = false
mainTab:Toggle("god mode", false, function(state)
    enabled = state
    game.Players.LocalPlayer.Character.Humanoid.Health = enabled and math.huge or 100
end)
```

### slider
```lua
mainTab:Slider("walkspeed", 16, 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

### dropdown
```lua
mainTab:Dropdown("teleport", {"spawn", "shop", "boss"}, function(selected)
    if selected == "spawn" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end
end)
```

### keybind
```lua
mainTab:Keybind("toggle gui", "RightControl", function(key)
    getgenv().vortex_settings.keybind = key
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

local mainTab = window:Tab("main")
local playerTab = window:Tab("player")
local teleportTab = window:Tab("teleport")

mainTab:Button("kill all", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            player.Character.Humanoid.Health = 0
        end
    end
end)

mainTab:Toggle("kill aura", false, function(state)
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

playerTab:Toggle("god mode", false, function(state)
    game.Players.LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
end)

playerTab:Slider("walkspeed", 16, 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

playerTab:Slider("jumppower", 50, 500, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

teleportTab:Dropdown("locations", {"spawn", "shop", "boss"}, function(selected)
    local locations = {
        spawn = CFrame.new(0, 10, 0),
        shop = CFrame.new(100, 10, 100),
        boss = CFrame.new(0, 10, 500)
    }
    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[selected]
end)

mainTab:Keybind("toggle gui", "RightControl", function(key)
    getgenv().vortex_settings.keybind = key
end)
```

made by dirtosied
