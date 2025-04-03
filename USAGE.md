## step 1: settings
put this at the TOP of your script:
```lua
-- settings for both ui and notifications
getgenv().VortexSettings = {
    UI = {
        Theme = "Blue",          -- Blue, Red, Green, Purple, Custom
        CustomColors = {
            Background = Color3.fromRGB(25, 25, 25),
            Text = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(0, 170, 255)
        },
        Keybind = Enum.KeyCode.RightShift,  -- key to hide/show
        SaveSettings = true      -- remember settings
    },
    Notifications = {
        Enabled = true,          -- show notifications
        Position = "BottomRight",-- where they show up
        Limit = 5,              -- max at once
        Sounds = true,          -- play sounds
        Duration = 5            -- how long they stay
    }
}
```

## step 2: load scripts
put this AFTER your settings:
```lua
-- load both ui and notifications
local Vortex = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Gui.lua"))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Notif.lua"))()
```

## step 3: make your script
put this AFTER loading the scripts:
```lua
-- make your main window
local MyScript = Vortex:Window("my sigma script")

-- make pages for your hacks
local MainPage = Vortex:Page(MyScript, "main")
local PlayerPage = Vortex:Page(MyScript, "player")

-- add buttons to main page
Vortex:Button(MainPage, "kill all", function()
    Notify:Success("boom", "everyone died")
end)

-- add toggles
Vortex:Toggle(MainPage, "auto farm", function(on)
    if on then
        Notify:Success("farming", "getting rich")
    else
        Notify:Warning("stopped", "no more money")
    end
end)

-- add sliders
Vortex:Slider(PlayerPage, "speed", 16, 500, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    Notify:Success("speed", "zooming at " .. speed)
end)

-- add dropdowns
Vortex:Dropdown(PlayerPage, "teleport", {
    "spawn",
    "shop",
    "boss room"
}, function(place)
    Notify:Success("teleport", "going to " .. place)
end)

-- add color picker
Vortex:ColorPicker(PlayerPage, "esp color", Color3.fromRGB(255, 0, 0), function(color)
    Notify:Success("color", "changed esp color")
end)
```

## quick test script
copy paste this to test everything:
```lua
-- settings
getgenv().VortexSettings = {
    UI = {
        Theme = "Blue",
        SaveSettings = true
    },
    Notifications = {
        Enabled = true,
        Limit = 5
    }
}

-- load scripts
local Vortex = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Gui.lua"))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Notif.lua"))()

-- make script
local MyScript = Vortex:Window("test script")
local MainPage = Vortex:Page(MyScript, "main")

-- add test button
Vortex:Button(MainPage, "test", function()
    Notify:Success("works", "everything is working!")
end)

-- let you know it loaded
Notify:Success("loaded", "test script ready")
```

## where to put scripts
1. open your executor
2. make new file
3. paste settings at top
4. paste loadstrings next
5. paste your script last
6. press run

## tips
- settings must be at TOP
- loadstrings must be AFTER settings
- your script must be AFTER loadstrings
- notifications work with ui settings
- press RightShift to hide/show
- saves settings automatically

made by mxxer (skid it but dont sell it)
