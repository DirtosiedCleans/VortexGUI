local Services = {
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    HttpService = game:GetService("HttpService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting")
}

local GuiParent = Services.RunService:IsStudio() and Services.Players.LocalPlayer.PlayerGui or Services.CoreGui
local ConfigKey = "vortex_cfg"

local DefaultConfig = {
    Keybind = "RightControl"
}

local Colors = {
    Background = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(150, 150, 150),
    Highlight = Color3.fromRGB(45, 45, 45)
}

local Animations = {
    TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BlurTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
}

local function Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Corner(parent, radius)
    return Create("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius)
    })
end

local function Shadow(parent)
    local shadow = Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(.5, 0, .5, 0),
        AnchorPoint = Vector2.new(.5, .5),
        BackgroundColor3 = Color3.new(),
        BackgroundTransparency = .8,
        BorderSizePixel = 0,
        ZIndex = -1
    })
    Corner(shadow, 8)
    return shadow
end

local function LoadConfig()
    local success, result = pcall(function()
        return Services.HttpService:JSONDecode(getgenv()[ConfigKey] or "")
    end)
    return success and result or DefaultConfig
end

local function SaveConfig(config)
    getgenv()[ConfigKey] = Services.HttpService:JSONEncode(config)
end

local Library = {}
Library.__index = Library

function Library.new(options)
    local self = setmetatable({}, Library)
    self.Config = LoadConfig()
    
    -- Create blur effect
    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = Services.Lighting
    
    self.ScreenGui = Create("ScreenGui", {
        Parent = GuiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999999999,
        ResetOnSpawn = false
    })
    
    self.Main = Create("Frame", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(.5, -300, .5, -200),
        BackgroundColor3 = Colors.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0
    })
    
    -- Add animations
    local function animateGui(visible)
        local transparency = visible and 0 or 1
        local blurSize = visible and 15 or 0
        local position = visible and UDim2.new(.5, -300, .5, -200) or UDim2.new(.5, -300, .5, -400)
        
        Services.TweenService:Create(self.Main, Animations.TweenInfo, {
            BackgroundTransparency = transparency,
            Position = position
        }):Play()
        
        Services.TweenService:Create(self.Blur, Animations.BlurTweenInfo, {
            Size = blurSize
        }):Play()
        
        for _, v in pairs(self.Main:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextButton") then
                Services.TweenService:Create(v, Animations.TweenInfo, {
                    BackgroundTransparency = transparency
                }):Play()
                
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    Services.TweenService:Create(v, Animations.TweenInfo, {
                        TextTransparency = transparency
                    }):Play()
                end
            end
        end
    end
    
    Corner(self.Main, 8)
    Shadow(self.Main)
    
    self.Header = Create("Frame", {
        Parent = self.Main,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0
    })
    
    self.Title = Create("TextLabel", {
        Parent = self.Header,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = options.Title or "vortex",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Close = Create("TextButton", {
        Parent = self.Header,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 2),
        BackgroundColor3 = Colors.Highlight,
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })
    
    Corner(self.Close, 6)
    
    self.Tabs = Create("Frame", {
        Parent = self.Main,
        Size = UDim2.new(0, 150, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0
    })
    
    self.Content = Create("Frame", {
        Parent = self.Main,
        Size = UDim2.new(1, -170, 1, -45),
        Position = UDim2.new(0, 160, 0, 35),
        BackgroundTransparency = 1
    })
    
    Create("UIListLayout", {
        Parent = self.Tabs,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    self.ActiveTab = nil
    self.Visible = true
    
    if options.Drag then
        local Dragging, DragStart, StartPos
        
        self.Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = input.Position
                StartPos = self.Main.Position
            end
        end)
        
        Services.UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
                local Delta = input.Position - DragStart
                self.Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            end
        end)
        
        Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
    end
    
    Services.UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode[self.Config.Keybind] then
            self:Toggle()
        end
    end)
    
    self.Close.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    return self
end

function Library:Toggle()
    self.Visible = not self.Visible
    self.ScreenGui.Enabled = true
    animateGui(self.Visible)
    
    if not self.Visible then
        task.wait(0.3)
        self.ScreenGui.Enabled = false
    end
end

function Library:Tab(name)
    local tab = {}
    
    tab.Button = Create("TextButton", {
        Parent = self.Tabs,
        Size = UDim2.new(1, -10, 0, 35),
        BackgroundColor3 = Colors.Highlight,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })
    
    Corner(tab.Button, 6)
    
    tab.Container = Create("ScrollingFrame", {
        Parent = self.Content,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    Create("UIListLayout", {
        Parent = tab.Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    tab.Button.MouseButton1Click:Connect(function()
        if self.ActiveTab then
            self.ActiveTab.Container.Visible = false
            Services.TweenService:Create(self.ActiveTab.Button, Animations.TweenInfo, {
                BackgroundColor3 = Colors.Highlight
            }):Play()
        end
        
        tab.Container.Visible = true
        Services.TweenService:Create(tab.Button, Animations.TweenInfo, {
            BackgroundColor3 = Colors.Accent
        }):Play()
        self.ActiveTab = tab
    end)
    
    if not self.ActiveTab then
        task.spawn(function()
            tab.Button.MouseButton1Click:Connect(function() end):Fire()
        end)
    end
    
    function tab:Button(text, callback)
        local button = Create("TextButton", {
            Parent = self.Container,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Colors.Accent,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            AutoButtonColor = false
        })
        
        Corner(button, 6)
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    function tab:Toggle(text, default, callback)
        local toggle = Create("Frame", {
            Parent = self.Container,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Colors.Accent
        })
        
        Corner(toggle, 6)
        
        local label = Create("TextLabel", {
            Parent = toggle,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local switch = Create("TextButton", {
            Parent = toggle,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -45, .5, -10),
            BackgroundColor3 = default and Colors.Highlight or Colors.Muted,
            AutoButtonColor = false
        })
        
        Corner(switch, 10)
        
        local enabled = default
        
        switch.MouseButton1Click:Connect(function()
            enabled = not enabled
            switch.BackgroundColor3 = enabled and Colors.Highlight or Colors.Muted
            callback(enabled)
        end)
        
        return toggle
    end
    
    function tab:Slider(text, min, max, default, callback)
        local slider = Create("Frame", {
            Parent = self.Container,
            Size = UDim2.new(1, -10, 0, 50),
            BackgroundColor3 = Colors.Accent
        })
        
        Corner(slider, 6)
        
        local label = Create("TextLabel", {
            Parent = slider,
            Size = UDim2.new(1, -70, 0, 25),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local value = Create("TextLabel", {
            Parent = slider,
            Size = UDim2.new(0, 50, 0, 25),
            Position = UDim2.new(1, -60, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(default),
            TextColor3 = Colors.Muted,
            TextSize = 14,
            Font = Enum.Font.Gotham
        })
        
        local bar = Create("Frame", {
            Parent = slider,
            Size = UDim2.new(1, -20, 0, 4),
            Position = UDim2.new(0, 10, 0, 35),
            BackgroundColor3 = Colors.Highlight
        })
        
        Corner(bar, 2)
        
        local knob = Create("TextButton", {
            Parent = bar,
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new((default - min) / (max - min), -6, .5, -6),
            BackgroundColor3 = Colors.Text,
            AutoButtonColor = false
        })
        
        Corner(knob, 6)
        
        local dragging = false
        
        knob.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        Services.UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                
                knob.Position = UDim2.new(pos, -6, .5, -6)
                value.Text = tostring(val)
                callback(val)
            end
        end)
        
        return slider
    end
    
    function tab:Dropdown(text, options, callback)
        if type(options) == "function" then
            local getOptions = options
            options = getOptions()
            callback = callback or function() end
        end
        
        local dropdown = Create("Frame", {
            Parent = self.Container,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Colors.Accent,
            ClipsDescendants = true
        })
        
        Corner(dropdown, 6)
        
        local label = Create("TextLabel", {
            Parent = dropdown,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local arrow = Create("TextButton", {
            Parent = dropdown,
            Size = UDim2.new(0, 35, 0, 35),
            Position = UDim2.new(1, -35, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = Colors.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham
        })
        
        local container = Create("Frame", {
            Parent = dropdown,
            Size = UDim2.new(1, 0, 0, #options * 30),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1
        })
        
        Create("UIListLayout", {
            Parent = container,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local open = false
        
        arrow.MouseButton1Click:Connect(function()
            open = not open
            arrow.Rotation = open and 180 or 0
            dropdown.Size = UDim2.new(1, -10, 0, open and 35 + #options * 30 or 35)
        end)
        
        for _, option in ipairs(options) do
            local button = Create("TextButton", {
                Parent = container,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Colors.Highlight,
                Text = option,
                TextColor3 = Colors.Muted,
                TextSize = 14,
                Font = Enum.Font.Gotham
            })
            
            button.MouseButton1Click:Connect(function()
                label.Text = text .. ": " .. option
                arrow.MouseButton1Click:Fire()
                callback(option)
            end)
        end
        
        return dropdown
    end
    
    function tab:Keybind(text, default, callback)
        local keybind = Create("Frame", {
            Parent = self.Container,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Colors.Accent
        })
        
        Corner(keybind, 6)
        
        local label = Create("TextLabel", {
            Parent = keybind,
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local button = Create("TextButton", {
            Parent = keybind,
            Size = UDim2.new(0, 80, 0, 25),
            Position = UDim2.new(1, -90, .5, -12),
            BackgroundColor3 = Colors.Highlight,
            Text = default,
            TextColor3 = Colors.Muted,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            AutoButtonColor = false
        })
        
        Corner(button, 4)
        
        local binding = false
        
        button.MouseButton1Click:Connect(function()
            if binding then return end
            
            binding = true
            button.Text = "..."
            
            local connection
            connection = Services.UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    button.Text = key
                    callback(key)
                    binding = false
                    connection:Disconnect()
                end
            end)
        end)
        
        return keybind
    end
    
    return tab
end

return Library
