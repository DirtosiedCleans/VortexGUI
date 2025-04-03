# Vortex UI Library

## Loading
```lua
local Vortex = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexGUI/main/Gui.lua"))()
local VortexNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexGUI/main/Notif.lua"))()

getgenv().VortexSettings = {
    Theme = {
        Current = "Purple",
    },
    UI = {
        Keybind = Enum.KeyCode.RightShift,
        Sounds = {
            Enabled = true,
            Volume = 0.5
        }
    },
    Notifications = {
        Enabled = true,
        Position = "BottomRight",
        Limit = 5,
        Duration = 5
    },
    AutoReport = {
        Enabled = true,
        Webhook = "your_webhook_here"
    }
}

local Window = Vortex:Window("Vortex")
```

## Creating Tabs
```lua
local MainTab = Window:Tab("Main")
local SettingsTab = Window:Tab("Settings")
```

## UI Elements

### Button
```lua
MainTab:Button({
    Name = "Kill All",
    Callback = function()
        VortexNotif:Success("Action", "Button Clicked")
    end
})
```

### Toggle
```lua
MainTab:Toggle({
    Name = "God Mode",
    Default = false,
    Callback = function(State)
        VortexNotif:Success("Toggle", State and "On" or "Off")
    end
})
```

### Slider
```lua
MainTab:Slider({
    Name = "Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
```

### Dropdown
```lua
MainTab:Dropdown({
    Name = "Teleport",
    Options = {"Spawn", "Shop", "Boss"},
    Callback = function(Option)
        VortexNotif:Success("Selected", Option)
    end
})
```

## Notifications

### Success
```lua
VortexNotif:Success("Title", "Message", 5)
```

### Error
```lua
VortexNotif:Error("Error", "Something went wrong", 5)
```

### Warning
```lua
VortexNotif:Warning("Warning", "Be careful", 5)
```

### Question
```lua
VortexNotif:Question("Confirm", "Are you sure?", function(Confirmed)
    if Confirmed then
        VortexNotif:Success("Yes", "Action confirmed")
    else
        VortexNotif:Error("No", "Action cancelled")
    end
end)
```

## Complete Example
```lua
local Vortex = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexGUI/main/Gui.lua"))()
local VortexNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexGUI/main/Notif.lua"))()

local Window = Vortex:Window("Vortex Hub")
local MainTab = Window:Tab("Main")
local SettingsTab = Window:Tab("Settings")

MainTab:Button({
    Name = "Kill All",
    Callback = function()
        VortexNotif:Success("Kill All", "Players eliminated")
    end
})

MainTab:Toggle({
    Name = "ESP",
    Default = false,
    Callback = function(State)
        VortexNotif:Success("ESP", State and "Enabled" or "Disabled")
    end
})

MainTab:Slider({
    Name = "Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

SettingsTab:Dropdown({
    Name = "Theme",
    Options = {"Blue", "Red", "Green", "Purple"},
    Callback = function(Theme)
        VortexSettings.Theme.Current = Theme
    end
})

SettingsTab:Toggle({
    Name = "UI Sounds",
    Default = true,
    Callback = function(State)
        VortexSettings.UI.Sounds.Enabled = State
    end
})

SettingsTab:Slider({
    Name = "Notification Duration",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(Value)
        VortexSettings.Notifications.Duration = Value
    end
})

VortexNotif:Success("Loaded", "Vortex Hub is ready!")
```

## Contact
Discord: @Mxxer - mxxeralt2s
