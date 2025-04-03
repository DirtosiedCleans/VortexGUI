listen up skids, ima teach you how to code like a sigma in 1 minute

## first: yoink these
```lua
-- put these at the TOP of your script (very important)
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Gui.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Notif.lua"))()
```

## second: make your hack menu
```lua
-- this makes your main hack menu window (like other guis)
-- put this AFTER the loadstrings
local vortex = VortexUI:Window("my sigma script")

-- this makes pages for different hacks (like tabs in chrome)
local MainHacks = VortexUI:Tab(vortex, "main hacks")    -- first page
local PlayerHacks = VortexUI:Tab(vortex, "player")      -- second page
local FunStuff = VortexUI:Tab(vortex, "fun stuff")      -- third page
```

## third: add your hacks

### buttons (click to activate)
```lua
-- buttons do something when clicked
VortexUI:Button(MainHacks, "kill all", function()
    -- this runs when button clicked
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
    -- show cool notification
    VortexUI:Notify("boom", "everyone died lol")
end)
```

### toggles (on/off switches)
```lua
-- toggles are like light switches
VortexUI:Toggle(MainHacks, "auto farm", function(on)
    -- 'on' is true when enabled, false when disabled
    if on then
        VortexUI:Notify("farming", "getting rich rn")
        -- put your farming loop here
    else
        VortexUI:Notify("stopped", "enough money for today")
        -- stop your farming loop here
    end
end)
```

### sliders (pick a number)
```lua
-- sliders let you choose numbers (like speed)
VortexUI:Slider(PlayerHacks, "walkspeed", 16, 500, function(speed)
    -- speed is the number they picked
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    VortexUI:Notify("speed", "zooming at " .. speed)
end)
```

### dropdowns (pick from list)
```lua
-- dropdowns are like choosing from a menu
VortexUI:Dropdown(FunStuff, "teleport", {
    "spawn",        -- option 1
    "shop",         -- option 2
    "secret room"   -- option 3
}, function(picked)
    -- picked is what they chose
    VortexUI:Notify("teleport", "taking you to " .. picked)
end)
```

## quick copy-paste test script
```lua
-- STEP 1: load the good stuff
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Gui.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/DirtosiedCleans/VortexUI/main/Notif.lua"))()

-- STEP 2: make your hack menu
local vortex = VortexUI:Window("sigma script v1")

-- STEP 3: make your pages
local MainHacks = VortexUI:Tab(vortex, "main")
local PlayerMods = VortexUI:Tab(vortex, "player")
local TrollStuff = VortexUI:Tab(vortex, "troll")

-- STEP 4: add hacks to main page
VortexUI:Button(MainHacks, "kill all", function()
    VortexUI:Notify("boom", "everyone died lol")
end)

VortexUI:Toggle(MainHacks, "auto farm", function(on)
    VortexUI:Notify("farming", on and "getting rich" or "stopped")
end)

-- STEP 5: add player mods
VortexUI:Slider(PlayerMods, "walkspeed", 16, 500, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)

VortexUI:Slider(PlayerMods, "jumppower", 50, 500, function(jump)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = jump
end)

-- STEP 6: add troll stuff
VortexUI:Button(TrollStuff, "free bobux", function()
    VortexUI:Notify("scammed", "you actually believed this lol")
end)

VortexUI:Dropdown(TrollStuff, "teleport", {
    "spawn",
    "shop",
    "secret room",
    "admin base"
}, function(place)
    VortexUI:Notify("teleport", "taking you to " .. place)
end)

-- STEP 7: let them know it loaded
VortexUI:Notify("loaded", "sigma script ready to hack")
```

## sigma tips
- press RightShift to hide/show your hacks
- notifications stack up on the right
- works on trash executors (but in potato mode)
- saves your settings automatically
- has cool sounds and animations

## how to be sigma
1. put loadstrings at TOP of script
2. make window FIRST
3. make tabs SECOND
4. add hacks to tabs THIRD
5. test each hack FOURTH
6. notify when stuff happens
7. save your settings
8. make it look cool
9. dont make it obvious
10. dont sell skidded scripts ( or you hate god and you are gay )

made by mxxer (skid it but dont sell it or youre beta)
