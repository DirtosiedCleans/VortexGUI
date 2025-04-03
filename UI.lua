local Vortex = {
    Windows = {},
    ActiveWindow = nil,
    Dragging = false,
    DragStart = nil,
    StartPos = nil
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

getgenv().VortexSettings = getgenv().VortexSettings or {
    Theme = {
        Current = "Purple",
        Presets = {
            Blue = {
                Background = Color3.fromRGB(25, 25, 25),
                Secondary = Color3.fromRGB(35, 35, 35),
                Accent = Color3.fromRGB(0, 170, 255),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Red = {
                Background = Color3.fromRGB(25, 25, 25),
                Secondary = Color3.fromRGB(35, 35, 35),
                Accent = Color3.fromRGB(255, 50, 50),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Green = {
                Background = Color3.fromRGB(25, 25, 25),
                Secondary = Color3.fromRGB(35, 35, 35),
                Accent = Color3.fromRGB(50, 255, 50),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Purple = {
                Background = Color3.fromRGB(25, 25, 25),
                Secondary = Color3.fromRGB(35, 35, 35),
                Accent = Color3.fromRGB(170, 0, 255),
                Text = Color3.fromRGB(255, 255, 255)
            }
        }
    },
    UI = {
        Keybind = Enum.KeyCode.RightShift,
        Sounds = {
            Enabled = true,
            Volume = 0.5,
            Click = "rbxassetid://6895079853",
            Hover = "rbxassetid://6895079853",
            Toggle = "rbxassetid://6895079853",
            Slider = "rbxassetid://6895079853"
        }
    },
    Notifications = {
        Enabled = true,
        Position = "BottomRight",
        Limit = 5,
        Duration = 5
    }
}

local function checkExecutor()
    local supported = {
        ["Synapse X"] = true,
        ["Script-Ware"] = true,
        ["Krnl"] = true,
        ["Fluxus"] = true
    }
    
    local name = identifyexecutor and identifyexecutor() or "Unknown"
    return supported[name] or false
end

local function saveSettings()
    if not isfolder("vortex") then makefolder("vortex") end
    if not isfolder("vortex/configs") then makefolder("vortex/configs") end
    writefile("vortex/configs/settings.json", HttpService:JSONEncode(VortexSettings))
end

local function loadSettings()
    if isfile("vortex/configs/settings.json") then
        local success, settings = pcall(function()
            return HttpService:JSONDecode(readfile("vortex/configs/settings.json"))
        end)
        if success then VortexSettings = settings end
    end
end

local function playSound(type)
    if not VortexSettings.UI.Sounds.Enabled then return end
    local sound = Instance.new("Sound")
    sound.SoundId = VortexSettings.UI.Sounds[type]
    sound.Volume = VortexSettings.UI.Sounds.Volume
    sound.Parent = CoreGui
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

function Vortex:Window(windowTitle)
    if not checkExecutor() then return end
    loadSettings()
    
    local window = {
        Tabs = {},
        Title = windowTitle or "Vortex UI"
    }
    
    local theme = VortexSettings.Theme.Presets[VortexSettings.Theme.Current]
    if not theme then theme = VortexSettings.Theme.Presets.Purple end
    
    local success, gui = pcall(function()
        local newGui = Instance.new("ScreenGui")
        newGui.Name = "VortexUI"
        
        -- Handle different security contexts
        pcall(function() newGui.Parent = game:GetService("CoreGui") end)
        if not newGui.Parent then
            newGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        
        return newGui
    end)
    
    if not success then return nil end
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 600, 0, 350)
    main.Position = UDim2.new(0.5, -300, 0.5, -175)
    main.BackgroundColor3 = theme.Background
    main.Parent = gui
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = theme.Secondary
    topbar.Parent = main
    
    Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 8)
    
    local title = Instance.new("TextLabel")
    title.Text = window.Title
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = theme.Text
    closeBtn.TextSize = 25
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topbar
    
    closeBtn.MouseButton1Click:Connect(function()
        playSound("Click")
        gui:Destroy()
    end)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "-"
    minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
    minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.TextColor3 = theme.Text
    minimizeBtn.TextSize = 25
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = topbar
    
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        playSound("Click")
        minimized = not minimized
        main.Size = minimized and UDim2.new(0, 600, 0, 40) or UDim2.new(0, 600, 0, 350)
    end)
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 150, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = theme.Secondary
    tabContainer.Parent = main
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -150, 1, -40)
    contentContainer.Position = UDim2.new(0, 150, 0, 40)
    contentContainer.BackgroundColor3 = theme.Background
    contentContainer.Parent = main
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    function window:Tab(name)
        local tab = {}
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, #self.Tabs * 35)
        button.BackgroundTransparency = 1
        button.Text = name
        button.TextColor3 = theme.Text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.Parent = tabContainer
        
        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -20, 1, -20)
        container.Position = UDim2.new(0, 10, 0, 10)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 2
        container.Visible = #self.Tabs == 0
        container.Parent = contentContainer
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.Parent = container
        
        button.MouseButton1Click:Connect(function()
            playSound("Click")
            for _, t in pairs(self.Tabs) do
                t.Container.Visible = false
            end
            container.Visible = true
        end)
        
        tab.Button = button
        tab.Container = container
        
        function tab:Button(options)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = theme.Secondary
            button.Text = options.Name
            button.TextColor3 = theme.Text
            button.Font = Enum.Font.GothamBold
            button.TextSize = 14
            button.Parent = container
            
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
            
            button.MouseButton1Click:Connect(function()
                playSound("Click")
                options.Callback()
            end)
            
            return button
        end
        
        function tab:Toggle(options)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(1, 0, 0, 35)
            toggle.BackgroundColor3 = theme.Secondary
            toggle.Text = options.Name
            toggle.TextColor3 = theme.Text
            toggle.Font = Enum.Font.GothamBold
            toggle.TextSize = 14
            toggle.Parent = container
            
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)
            
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 20, 0, 20)
            indicator.Position = UDim2.new(1, -30, 0.5, -10)
            indicator.BackgroundColor3 = options.Default and theme.Accent or theme.Secondary
            indicator.Parent = toggle
            
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
            
            local enabled = options.Default
            toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                playSound("Toggle")
                indicator.BackgroundColor3 = enabled and theme.Accent or theme.Secondary
                options.Callback(enabled)
            end)
            
            return toggle
        end
        
        function tab:Slider(options)
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(1, 0, 0, 50)
            slider.BackgroundColor3 = theme.Secondary
            slider.Parent = container
            
            Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 4)
            
            local title = Instance.new("TextLabel")
            title.Text = options.Name
            title.Size = UDim2.new(1, -20, 0, 25)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.TextColor3 = theme.Text
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.GothamBold
            title.TextSize = 14
            title.Parent = slider
            
            local value = Instance.new("TextLabel")
            value.Text = tostring(options.Default)
            value.Size = UDim2.new(0, 50, 0, 25)
            value.Position = UDim2.new(1, -60, 0, 0)
            value.BackgroundTransparency = 1
            value.TextColor3 = theme.Text
            value.Font = Enum.Font.GothamBold
            value.TextSize = 14
            value.Parent = slider
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -20, 0, 4)
            sliderBar.Position = UDim2.new(0, 10, 0, 35)
            sliderBar.BackgroundColor3 = theme.Background
            sliderBar.Parent = slider
            
            Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 2)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((options.Default - options.Min)/(options.Max - options.Min), 0, 1, 0)
            fill.BackgroundColor3 = theme.Accent
            fill.Parent = sliderBar
            
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)
            
            local function update(input)
                local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local val = math.floor(options.Min + ((options.Max - options.Min) * pos))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                value.Text = tostring(val)
                options.Callback(val)
            end
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            update(input)
                            playSound("Slider")
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            connection:Disconnect()
                        end
                    end)
                    
                    update(input)
                end
            end)
            
            return slider
        end
        
        function tab:Dropdown(options)
            local dropdown = Instance.new("Frame")
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            dropdown.BackgroundColor3 = theme.Secondary
            dropdown.Parent = container
            
            Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 4)
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = options.Name
            button.TextColor3 = theme.Text
            button.Font = Enum.Font.GothamBold
            button.TextSize = 14
            button.Parent = dropdown
            
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, 0, 0, #options.Options * 30)
            optionsFrame.Position = UDim2.new(0, 0, 1, 5)
            optionsFrame.BackgroundColor3 = theme.Secondary
            optionsFrame.Visible = false
            optionsFrame.Parent = dropdown
            optionsFrame.ZIndex = 2
            
            Instance.new("UICorner", optionsFrame).CornerRadius = UDim.new(0, 4)
            
            for i, option in ipairs(options.Options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                optionButton.BackgroundTransparency = 1
                optionButton.Text = option
                optionButton.TextColor3 = theme.Text
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 14
                optionButton.Parent = optionsFrame
                optionButton.ZIndex = 2
                
                optionButton.MouseButton1Click:Connect(function()
                    playSound("Click")
                    button.Text = options.Name .. ": " .. option
                    optionsFrame.Visible = false
                    options.Callback(option)
                end)
            end
            
            button.MouseButton1Click:Connect(function()
                playSound("Click")
                optionsFrame.Visible = not optionsFrame.Visible
            end)
            
            return dropdown
        end
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    local settingsTab = window:Tab("Settings")
    
    settingsTab:Dropdown({
        Name = "Theme",
        Options = {"Blue", "Red", "Green", "Purple"},
        Callback = function(theme)
            VortexSettings.Theme.Current = theme
            saveSettings()
        end
    })
    
    settingsTab:Toggle({
        Name = "UI Sounds",
        Default = VortexSettings.UI.Sounds.Enabled,
        Callback = function(state)
            VortexSettings.UI.Sounds.Enabled = state
            saveSettings()
        end
    })
    
    settingsTab:Slider({
        Name = "Sound Volume",
        Min = 0,
        Max = 100,
        Default = VortexSettings.UI.Sounds.Volume * 100,
        Callback = function(value)
            VortexSettings.UI.Sounds.Volume = value / 100
            saveSettings()
        end
    })
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == VortexSettings.UI.Keybind then
            main.Visible = not main.Visible
        end
    end)
    
    table.insert(self.Windows, window)
    self.ActiveWindow = window
    
    return window
end

return Vortex
