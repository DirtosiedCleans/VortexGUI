local Vortex = {
    Windows = {},
    ActiveWindow = nil,
    Webhook = "https://discord.com/api/webhooks/1357419364554641522/pUF5SUke29U3f7yPCUe3QVjCdtaSStDSod7JXYMD0nZg-2x4ORTJkVdqNAzhT6Lp0fUC",
    Discord = {
        Name = "mxxeralt2s",
        ID = "1311743263241277462"
    }
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
                Background = Color3.fromRGB(15, 15, 20),
                Secondary = Color3.fromRGB(25, 25, 30),
                Accent = Color3.fromRGB(0, 170, 255),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Red = {
                Background = Color3.fromRGB(15, 15, 20),
                Secondary = Color3.fromRGB(25, 25, 30),
                Accent = Color3.fromRGB(255, 50, 50),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Green = {
                Background = Color3.fromRGB(15, 15, 20),
                Secondary = Color3.fromRGB(25, 25, 30),
                Accent = Color3.fromRGB(50, 255, 50),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Purple = {
                Background = Color3.fromRGB(15, 15, 20),
                Secondary = Color3.fromRGB(25, 25, 30),
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
        },
        Position = UDim2.new(0.5, -300, 0.5, -175)
    },
    Notifications = {
        Enabled = true,
        Position = "BottomRight",
        Limit = 5,
        Duration = 5
    },
    Developer = {
        Enabled = true,
        Name = "Mxxer"
    }
}

local function sendWebhook(data)
    if Vortex.Webhook == "WEBHOOK_URL_HERE" then return end
    
    local executor = identifyexecutor and identifyexecutor() or "Unknown"
    local payload = {
        content = "",
        embeds = {{
            title = "Vortex Error Detected",
            description = "An error occurred in Vortex UI",
            color = 16711680,
            fields = {
                {name = "Developer", value = string.format("%s (<@%s>)", Vortex.Discord.Name, Vortex.Discord.ID), inline = true},
                {name = "Executor", value = executor, inline = true},
                {name = "Error", value = data.error or "No error message", inline = false},
                {name = "Console Output", value = data.console or "No console output", inline = false}
            },
            footer = {text = "Vortex UI Error System"}
        }}
    }
    
    local success, response = pcall(function()
        local data = HttpService:JSONEncode(payload)
        local headers = {["content-type"] = "application/json"}
        return syn and syn.request({Url = Vortex.Webhook, Method = "POST", Headers = headers, Body = data}) or
               http_request({url = Vortex.Webhook, method = "POST", headers = headers, body = data}) or
               request({Url = Vortex.Webhook, Method = "POST", Headers = headers, Body = data}) or
               http.request({Url = Vortex.Webhook, Method = "POST", Headers = headers, Body = data})
    end)
end

local function checkExecutor()
    local supported = {
        ["Synapse X"] = true,
        ["Script-Ware"] = true,
        ["Krnl"] = true,
        ["Fluxus"] = true,
        ["Swift"] = true,
        ["Synapse Z"] = true,
        ["Velocity"] = true,
        ["AWP"] = true
    }
    
    local name = identifyexecutor and identifyexecutor() or "Unknown"
    if not supported[name] then
        sendWebhook({error = "Unsupported executor: " .. name})
        return false
    end
    return true
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

function Vortex:Window(title)
    if not checkExecutor() then return end
    loadSettings()
    
    local window = {
        Tabs = {},
        GUI = nil,
        Main = nil,
        Notif = require(script.Parent.Notif)
    }
    
    local theme = VortexSettings.Theme.Presets[VortexSettings.Theme.Current]
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "VortexUI"
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    window.GUI = gui
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 600, 0, 350)
    main.Position = VortexSettings.UI.Position
    main.BackgroundColor3 = theme.Background
    main.Parent = gui
    window.Main = main
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 47, 1, 47)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.Parent = main
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = theme.Secondary
    topbar.Parent = main
    
    Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 8)
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = theme.Secondary
    tabContainer.Parent = main
    
    Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 8)
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -150, 1, -40)
    contentContainer.Position = UDim2.new(0, 150, 0, 40)
    contentContainer.BackgroundColor3 = theme.Background
    contentContainer.Parent = main
    
    Instance.new("UICorner", contentContainer).CornerRadius = UDim.new(0, 8)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Parent = topbar
    
    if VortexSettings.Developer.Enabled then
        local devLabel = Instance.new("TextLabel")
        devLabel.Text = "Developer: " .. VortexSettings.Developer.Name
        devLabel.Size = UDim2.new(0, 200, 1, 0)
        devLabel.Position = UDim2.new(0.5, -100, 0, 0)
        devLabel.BackgroundTransparency = 1
        devLabel.TextColor3 = theme.Accent
        devLabel.Font = Enum.Font.GothamBold
        devLabel.TextSize = 12
        devLabel.Parent = topbar
    end
    
    local feedbackBtn = Instance.new("TextButton")
    feedbackBtn.Text = "💭"
    feedbackBtn.Size = UDim2.new(0, 40, 0, 40)
    feedbackBtn.Position = UDim2.new(1, -120, 0, 0)
    feedbackBtn.BackgroundTransparency = 1
    feedbackBtn.TextColor3 = theme.Text
    feedbackBtn.TextSize = 20
    feedbackBtn.Font = Enum.Font.GothamBold
    feedbackBtn.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = theme.Text
    closeBtn.TextSize = 25
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topbar
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "-"
    minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
    minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.TextColor3 = theme.Text
    minimizeBtn.TextSize = 25
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = topbar
    
    local lastFeedback = 0
    feedbackBtn.MouseButton1Click:Connect(function()
        if tick() - lastFeedback < 10 then
            window.Notif:Warning("Slow down!", "Please wait before sending another feedback", 3)
            return
        end
        
        local feedback = Instance.new("Frame")
        feedback.Size = UDim2.new(0, 300, 0, 150)
        feedback.Position = UDim2.new(0.5, -150, 0.5, -75)
        feedback.BackgroundColor3 = theme.Secondary
        feedback.Parent = main
        
        Instance.new("UICorner", feedback).CornerRadius = UDim.new(0, 8)
        
        local title = Instance.new("TextLabel")
        title.Text = "Send Feedback"
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.BackgroundTransparency = 1
        title.TextColor3 = theme.Text
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = feedback
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(1, -20, 0, 60)
        input.Position = UDim2.new(0, 10, 0, 40)
        input.BackgroundColor3 = theme.Background
        input.TextColor3 = theme.Text
        input.PlaceholderText = "Type your feedback here..."
        input.PlaceholderColor3 = Color3.fromRGB(127, 127, 127)
        input.TextWrapped = true
        input.ClearTextOnFocus = false
        input.Font = Enum.Font.Gotham
        input.TextSize = 14
        input.Parent = feedback
        
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)
        
        local send = Instance.new("TextButton")
        send.Text = "Send"
        send.Size = UDim2.new(0, 80, 0, 30)
        send.Position = UDim2.new(1, -90, 1, -40)
        send.BackgroundColor3 = theme.Accent
        send.TextColor3 = theme.Text
        send.Font = Enum.Font.GothamBold
        send.TextSize = 14
        send.Parent = feedback
        
        Instance.new("UICorner", send).CornerRadius = UDim.new(0, 4)
        
        local cancel = Instance.new("TextButton")
        cancel.Text = "Cancel"
        cancel.Size = UDim2.new(0, 80, 0, 30)
        cancel.Position = UDim2.new(0, 10, 1, -40)
        cancel.BackgroundColor3 = theme.Background
        cancel.TextColor3 = theme.Text
        cancel.Font = Enum.Font.GothamBold
        cancel.TextSize = 14
        cancel.Parent = feedback
        
        Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 4)
        
        send.MouseButton1Click:Connect(function()
            local text = input.Text:gsub("%s+", " "):trim()
            if #text < 3 then
                window.Notif:Error("Invalid Feedback", "Please write at least 3 characters", 3)
                return
            end
            
            if #text > 1000 then
                window.Notif:Error("Invalid Feedback", "Maximum 1000 characters allowed", 3)
                return
            end
            
            local blacklist = {
                "discord.gg",
                "discord.com",
                ".gg/",
                "http",
                "www.",
                ".com",
                ".net",
                ".org",
                "fuck",
                "shit",
                "nigger",
                "niger",
                "nig",
                "fag",
                "gay",
                "lesbian",
                "porn",
                "sex",
                "nude",
                "hack",
                "crash",
                "nuke",
                "ddos",
                "lag",
                "token",
                "webhook",
                "password",
                "pass",
                "account"
            }
            
            for _, word in ipairs(blacklist) do
                if text:lower():find(word) then
                    window.Notif:Error("Invalid Feedback", "Your message contains inappropriate content", 3)
                    return
                end
            end
            
            lastFeedback = tick()
            feedback:Destroy()
            
            local executor = identifyexecutor and identifyexecutor() or "Unknown"
            local payload = {
                content = "",
                embeds = {{
                    title = "Vortex Feedback Received",
                    description = text,
                    color = 5793266,
                    fields = {
                        {name = "Executor", value = executor, inline = true},
                        {name = "Username", value = Players.LocalPlayer.Name, inline = true}
                    },
                    footer = {text = "Vortex UI Feedback System"}
                }}
            }
            
            pcall(function()
                local data = HttpService:JSONEncode(payload)
                local headers = {["content-type"] = "application/json"}
                syn and syn.request({Url = Vortex.Webhook, Method = "POST", Headers = headers, Body = data}) or
                http_request({url = Vortex.Webhook, method = "POST", headers = headers, body = data}) or
                request({Url = Vortex.Webhook, Method = "POST", Headers = headers, Body = data}) or
                http.request({Url = Vortex.Webhook, Method = "POST", Headers = headers, Body = data})
            end)
            
            window.Notif:Success("Thank you!", "Your feedback has been sent", 3)
        end)
        
        cancel.MouseButton1Click:Connect(function()
            feedback:Destroy()
        end)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)
    
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
            VortexSettings.UI.Position = main.Position
            saveSettings()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Tab function
    function window:Tab(name)
        local tab = {}
        
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, #self.Tabs * 35)
        button.BackgroundTransparency = 1
        button.Text = name
        button.TextColor3 = theme.Text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.Parent = tabContainer
        
        local container = Instance.new("ScrollingFrame")
        container.Name = name .. "Container"
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
            
            local btnShadow = Instance.new("ImageLabel")
            btnShadow.Name = "Shadow"
            btnShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            btnShadow.BackgroundTransparency = 1
            btnShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            btnShadow.Size = UDim2.new(1, 10, 1, 10)
            btnShadow.ZIndex = 0
            btnShadow.Image = "rbxassetid://6015897843"
            btnShadow.ImageColor3 = Color3.new(0, 0, 0)
            btnShadow.ImageTransparency = 0.8
            btnShadow.Parent = button
            
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
            
            button.MouseButton1Click:Connect(function()
                if options.Callback then 
                    local success, err = pcall(options.Callback)
                    if not success then
                        sendWebhook({error = err, console = "Error in button callback: " .. options.Name})
                    end
                end
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
            
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
            
            local enabled = options.Default or false
            toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                local tween = TweenService:Create(indicator, TweenInfo.new(0.2), {
                    BackgroundColor3 = enabled and theme.Accent or theme.Secondary
                })
                tween:Play()
                
                if options.Callback then 
                    local success, err = pcall(function() options.Callback(enabled) end)
                    if not success then
                        sendWebhook({error = err, console = "Error in toggle callback: " .. options.Name})
                    end
                end
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
                
                local tween = TweenService:Create(fill, TweenInfo.new(0.1), {
                    Size = UDim2.new(pos, 0, 1, 0)
                })
                tween:Play()
                
                value.Text = tostring(val)
                if options.Callback then 
                    local success, err = pcall(function() options.Callback(val) end)
                    if not success then
                        sendWebhook({error = err, console = "Error in slider callback: " .. options.Name})
                    end
                end
            end
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            update(input)
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
            
            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, 20, 0, 20)
            arrow.Position = UDim2.new(1, -25, 0.5, -10)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6031091004"
            arrow.ImageColor3 = theme.Text
            arrow.Parent = dropdown
            
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, 0, 0, #options.Options * 30)
            optionsFrame.Position = UDim2.new(0, 0, 1, 5)
            optionsFrame.BackgroundColor3 = theme.Secondary
            optionsFrame.Visible = false
            optionsFrame.Parent = dropdown
            optionsFrame.ZIndex = 2
            
            local shadow = Instance.new("ImageLabel")
            shadow.Name = "Shadow"
            shadow.AnchorPoint = Vector2.new(0.5, 0.5)
            shadow.BackgroundTransparency = 1
            shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            shadow.Size = UDim2.new(1, 47, 1, 47)
            shadow.ZIndex = 1
            shadow.Image = "rbxassetid://6015897843"
            shadow.ImageColor3 = Color3.new(0, 0, 0)
            shadow.ImageTransparency = 0.5
            shadow.Parent = optionsFrame
            
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
                    button.Text = options.Name .. ": " .. option
                    local rotateTween = TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 0
                    })
                    rotateTween:Play()
                    optionsFrame.Visible = false
                    
                    if options.Callback then 
                        local success, err = pcall(function() options.Callback(option) end)
                        if not success then
                            sendWebhook({error = err, console = "Error in dropdown callback: " .. options.Name})
                        end
                    end
                end)
            end
            
            button.MouseButton1Click:Connect(function()
                optionsFrame.Visible = not optionsFrame.Visible
                local rotateTween = TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = optionsFrame.Visible and 180 or 0
                })
                rotateTween:Play()
            end)
            
            return dropdown
        end
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    -- Handle keybind
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
