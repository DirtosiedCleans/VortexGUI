# vortex ui & notif guide aka VortexNU guide

yo skids, here's how to make this thing work (even on your trash executor)

## loading this beast
```lua
-- grab both of these bad boys
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Gui.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Notif.lua"))()
```

## making stuff work
```lua
-- this stores your window (like a box that holds your hacks)
local window = VortexUI:Window("vortex on top")

-- tabs are like pages in your hack menu
local MainTab = VortexUI:Tab(window, "hacks")
local FunTab = VortexUI:Tab(window, "fun stuff")

-- buttons do stuff when clicked (big brain)
VortexUI:Button(MainTab, "kill everyone", function()
    -- this shows a cool notification when you click
    VortexUI:Notify("boom", "everyone died lol")
end)

-- toggles are like on/off switches
VortexUI:Toggle(MainTab, "auto farm", function(on)
    if on then
        -- notification when you turn something on
        VortexUI:Notify("farming", "getting rich rn")
    else
        -- notification when you turn it off
        VortexUI:Notify("stopped", "no more money sad")
    end
end)

-- sliders let you pick numbers (like speed hacks)
VortexUI:Slider(MainTab, "walkspeed", 16, 500, function(speed)
    -- makes you go zoom
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    VortexUI:Notify("speed", "zooming at " .. speed)
end)

-- dropdowns let you pick from a list
VortexUI:Dropdown(MainTab, "teleport", {"spawn", "shop", "boss"}, function(where)
    VortexUI:Notify("teleport", "going to " .. where)
end)
```

## quick test script (copy paste this)
```lua
-- load the good stuff
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Gui.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Notif.lua"))()

-- make your hack menu
local window = VortexUI:Window("vortex test")

-- make some pages for your hacks
local MainTab = VortexUI:Tab(window, "hacks")
local FunTab = VortexUI:Tab(window, "fun")

-- add kill button
VortexUI:Button(MainTab, "kill all", function()
    VortexUI:Notify("boom", "everyone died")
end)

-- add auto farm toggle
VortexUI:Toggle(MainTab, "auto farm", function(on)
    VortexUI:Notify("farming", on and "getting rich" or "stopped")
end)

-- add speed hack
VortexUI:Slider(MainTab, "speed", 16, 500, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)

-- add bobux button (totally real)
VortexUI:Button(FunTab, "free bobux", function()
    VortexUI:Question("bobux", "want free bobux?", function(answer)
        if answer then
            VortexUI:Notify("nice", "enjoy being rich")
        else
            VortexUI:Notify("bruh", "your loss")
        end
    end)
end)

-- let everyone know you loaded
VortexUI:Notify("loaded", "vortex ready to hack")
```

## cool stuff to know
- press RightShift to hide/show your hacks
- notifications stack up nicely
- works on any executor (even the free ones)
- saves your settings automatically
- has cool sounds and animations

## supported executors
these work best:
- Velocity (the fast one)
- Swift (the smooth one)
- AWP (the pro one)
- Atomic (the boom one)

if your executor is trash tier, it'll still work but in potato mode

made by mxxer (skid it if you want but don't sell it you nerd)
