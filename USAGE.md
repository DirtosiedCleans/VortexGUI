> don't know how to code? and you want to try it? copy paste this! 🔥

```lua
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/refs/heads/main/source.lua"))()

-- create window
local window = gui.new({
    Title = "my first gui",
    Drag = true
})

-- create tab
local mainTab = window:Tab("main")

-- add button
mainTab:Button("click me!", function()
    print("thanks for using vortexui!")
end)

-- add toggle
mainTab:Toggle("enable", false, function(state)
    if state then
        print("enabled!")
    else
        print("disabled!")
    end
end)
```

### basic settings
```lua
getgenv().vortex_settings = {
    keybind = "RightControl",  -- key to toggle gui
    animations = true,         -- smooth animations
    stealth = false           -- stealth mode
}
```

### simple button
```lua
mainTab:Button("click me", function()
    print("clicked!")
end)
```

### toggle switch
```lua
mainTab:Toggle("enable", false, function(state)
    if state then
        print("on")
    else
        print("off")
    end
end)
```

### slider
```lua
mainTab:Slider("speed", 0, 100, 50, function(value)
    print("speed:", value)
end)
```

### dropdown menu
```lua
mainTab:Dropdown("select", {"option 1", "option 2", "option 3"}, function(selected)
    print("selected:", selected)
end)
```

### keybind
```lua
mainTab:Keybind("toggle gui", "RightControl", function(key)
    print("new key:", key)
end)
```

### multiple tabs
```lua
-- main tab
local mainTab = window:Tab("main")
mainTab:Button("hello", function()
    print("main tab")
end)

-- settings tab
local settingsTab = window:Tab("settings")
settingsTab:Button("settings", function()
    print("settings tab")
end)
```

### full example
```lua
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/refs/heads/main/source.lua"))()

-- settings
getgenv().vortex_settings = {
    keybind = "RightControl",
    animations = true,
    stealth = false
}

-- create window
local window = gui.new({
    Title = "vortex example",
    Drag = true
})

-- main tab
local mainTab = window:Tab("main")

mainTab:Button("click me", function()
    print("button clicked!")
end)

mainTab:Toggle("enable", false, function(state)
    print("toggle:", state)
end)

mainTab:Slider("speed", 0, 100, 50, function(value)
    print("speed:", value)
end)

mainTab:Dropdown("select", {"option 1", "option 2", "option 3"}, function(selected)
    print("selected:", selected)
end)

-- settings tab
local settingsTab = window:Tab("settings")

settingsTab:Keybind("toggle gui", "RightControl", function(key)
    print("new keybind:", key)
end)

settingsTab:Toggle("animations", true, function(state)
    getgenv().vortex_settings.animations = state
end)

settingsTab:Toggle("stealth mode", false, function(state)
    getgenv().vortex_settings.stealth = state
end)
```

made by mxxer
