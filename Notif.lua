local VortexSettings = {
    Theme = {
        Current = "Dark",
        Presets = {
            Purple = {
                Background = Color3.fromRGB(15, 15, 20),
                Secondary = Color3.fromRGB(25, 25, 30),
                Accent = Color3.fromRGB(170, 0, 255),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Dark = {
                Background = Color3.fromRGB(30, 30, 35),
                Secondary = Color3.fromRGB(45, 45, 50),
                Accent = Color3.fromRGB(65, 65, 70),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Light = {
                Background = Color3.fromRGB(240, 240, 245),
                Secondary = Color3.fromRGB(230, 230, 235),
                Accent = Color3.fromRGB(220, 220, 225),
                Text = Color3.fromRGB(30, 30, 35)
            },
            Ocean = {
                Background = Color3.fromRGB(20, 40, 60),
                Secondary = Color3.fromRGB(30, 50, 70),
                Accent = Color3.fromRGB(0, 150, 255),
                Text = Color3.fromRGB(255, 255, 255)
            },
            Neon = {
                Background = Color3.fromRGB(10, 10, 15),
                Secondary = Color3.fromRGB(15, 15, 20),
                Accent = Color3.fromRGB(0, 255, 140),
                Text = Color3.fromRGB(255, 255, 255)
            }
        }
    },
    Notifications = {
        Enabled = true,
        Duration = 5,
        Limit = 5,
        Position = "TopRight",
        Sound = true
    }
}

local VortexNotif = {
    Active = {},
    Queue = {},
    LastError = nil,
    Sound = {
        Success = "rbxassetid://6518811702",
        Error = "rbxassetid://6518811702",
        Warning = "rbxassetid://6518811702",
        Info = "rbxassetid://6518811702"
    },
    Emojis = {
        success = "✅",
        error = "❌",
        warning = "⚠️",
        info = "ℹ️",
        question = "❓",
        feedback = "💭"
    }
}

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local function getUIParent()
    if (syn and syn.protect_gui) or (gethui) then
        local hui = gethui or gethidden or get_hidden_gui
        if hui then
            return hui()
        end
    end
    
    return CoreGui
end

local function protect(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
end

local function getTheme()
    return VortexSettings.Theme.Presets[VortexSettings.Theme.Current] or VortexSettings.Theme.Presets.Dark
end

local function playSound(soundType)
    if not VortexSettings.Notifications.Sound then return end
    
    local sound = Instance.new("Sound")
    sound.SoundId = VortexNotif.Sound[soundType] or VortexNotif.Sound.Info
    sound.Volume = 0.5
    
    local success = pcall(function()
        local soundGui = Instance.new("ScreenGui")
        protect(soundGui)
        soundGui.Parent = getUIParent()
        sound.Parent = soundGui
        sound:Play()
        game:GetService("Debris"):AddItem(soundGui, 1)
    end)
    
    if not success then
        sound.Parent = SoundService
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1)
    end
end

local function createNotification(options)
    local theme = getTheme()
    
    local success, gui = pcall(function()
        local newGui = Instance.new("ScreenGui")
        newGui.Name = "VortexNotification"
        newGui.DisplayOrder = 999999999
        protect(newGui)
        
        local parent = getUIParent()
        newGui.Parent = parent
        
        if not newGui.Parent then
            newGui.Parent = CoreGui
        end
        
        if not newGui.Parent then
            newGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(0, 300, 0, 80)
        main.BackgroundColor3 = theme.Background
        main.BorderSizePixel = 0
        main.ClipsDescendants = true
        main.ZIndex = 999999999
        
        local blur = Instance.new("BlurEffect")
        blur.Size = 10
        blur.Parent = main
        
        local positions = {
            TopRight = {
                Start = UDim2.new(1, 20, 0, 20 + (#VortexNotif.Active * 90)),
                End = UDim2.new(1, -20, 0, 20 + (#VortexNotif.Active * 90))
            },
            BottomRight = {
                Start = UDim2.new(1, 20, 1, -90 - (#VortexNotif.Active * 90)),
                End = UDim2.new(1, -20, 1, -90 - (#VortexNotif.Active * 90))
            },
            TopLeft = {
                Start = UDim2.new(0, -320, 0, 20 + (#VortexNotif.Active * 90)),
                End = UDim2.new(0, 20, 0, 20 + (#VortexNotif.Active * 90))
            },
            BottomLeft = {
                Start = UDim2.new(0, -320, 1, -90 - (#VortexNotif.Active * 90)),
                End = UDim2.new(0, 20, 1, -90 - (#VortexNotif.Active * 90))
            }
        }
        
        main.Position = positions[VortexSettings.Notifications.Position or "TopRight"].Start
        main.Parent = newGui
        
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.BackgroundTransparency = 1
        shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        shadow.Size = UDim2.new(1, 47, 1, 47)
        shadow.ZIndex = 999999998
        shadow.Image = "rbxassetid://6015897843"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = 0.5
        shadow.Parent = main
        
        local corner = Instance.new("UICorner", main)
        corner.CornerRadius = UDim.new(0, 8)
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Background),
            ColorSequenceKeypoint.new(1, theme.Secondary)
        })
        gradient.Parent = main
        
        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 4, 1, 0)
        
        local accentColors = {
            error = Color3.fromRGB(255, 50, 50),
            warning = Color3.fromRGB(255, 150, 0),
            success = Color3.fromRGB(50, 255, 50),
            info = Color3.fromRGB(0, 170, 255),
            question = Color3.fromRGB(170, 0, 255),
            feedback = Color3.fromRGB(200, 0, 255)
        }
        accent.BackgroundColor3 = accentColors[options.type] or theme.Accent
        accent.BorderSizePixel = 0
        accent.Parent = main
        
        Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 8)
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Text = "×"
        closeBtn.Size = UDim2.new(0, 20, 0, 20)
        closeBtn.Position = UDim2.new(1, -25, 0, 5)
        closeBtn.BackgroundTransparency = 1
        closeBtn.TextColor3 = theme.Text
        closeBtn.TextSize = 20
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.ZIndex = 999999999
        closeBtn.Parent = main
        
        closeBtn.MouseEnter:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = accentColors[options.type] or theme.Accent}):Play()
        end)
        
        closeBtn.MouseLeave:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = theme.Text}):Play()
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            TweenService:Create(main, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 300, 0, 0),
                Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset + 40)
            }):Play()
            task.wait(0.2)
            newGui:Destroy()
        end)
        
        local emoji = Instance.new("TextLabel")
        emoji.Text = VortexNotif.Emojis[options.type] or ""
        emoji.Size = UDim2.new(0, 25, 0, 25)
        emoji.Position = UDim2.new(0, 15, 0, 8)
        emoji.BackgroundTransparency = 1
        emoji.TextColor3 = theme.Text
        emoji.Font = Enum.Font.GothamBold
        emoji.TextSize = 16
        emoji.ZIndex = 999999999
        emoji.Parent = main
        
        local title = Instance.new("TextLabel")
        title.Text = options.title or "Notification"
        title.Size = UDim2.new(1, -80, 0, 25)
        title.Position = UDim2.new(0, 45, 0, 8)
        title.BackgroundTransparency = 1
        title.TextColor3 = theme.Text
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.ZIndex = 999999999
        title.Parent = main
        
        local message = Instance.new("TextLabel")
        message.Text = options.text or ""
        message.Size = UDim2.new(1, -20, 0, 40)
        message.Position = UDim2.new(0, 15, 0, 35)
        message.BackgroundTransparency = 1
        message.TextColor3 = theme.Text
        message.TextXAlignment = Enum.TextXAlignment.Left
        message.TextYAlignment = Enum.TextYAlignment.Top
        message.Font = Enum.Font.Gotham
        message.TextSize = 13
        message.TextWrapped = true
        message.ZIndex = 999999999
        message.Parent = main
        
        if options.type == "question" then
            local yesBtn = Instance.new("TextButton")
            yesBtn.Text = "Yes"
            yesBtn.Size = UDim2.new(0, 60, 0, 25)
            yesBtn.Position = UDim2.new(1, -130, 1, -35)
            yesBtn.BackgroundColor3 = theme.Secondary
            yesBtn.TextColor3 = theme.Text
            yesBtn.Font = Enum.Font.GothamBold
            yesBtn.TextSize = 12
            yesBtn.ZIndex = 999999999
            yesBtn.Parent = main
            
            Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 4)
            
            local noBtn = Instance.new("TextButton")
            noBtn.Text = "No"
            noBtn.Size = UDim2.new(0, 60, 0, 25)
            noBtn.Position = UDim2.new(1, -65, 1, -35)
            noBtn.BackgroundColor3 = theme.Secondary
            noBtn.TextColor3 = theme.Text
            noBtn.Font = Enum.Font.GothamBold
            noBtn.TextSize = 12
            noBtn.ZIndex = 999999999
            noBtn.Parent = main
            
            Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 4)
            
            local function addButtonHoverEffect(button)
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = accentColors[options.type] or theme.Accent,
                        TextColor3 = theme.Background
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = theme.Secondary,
                        TextColor3 = theme.Text
                    }):Play()
                end)
            end
            
            addButtonHoverEffect(yesBtn)
            addButtonHoverEffect(noBtn)
            
            yesBtn.MouseButton1Click:Connect(function()
                if options.callback then options.callback(true) end
                newGui:Destroy()
            end)
            
            noBtn.MouseButton1Click:Connect(function()
                if options.callback then options.callback(false) end
                newGui:Destroy()
            end)
        end
        
        return newGui, main, positions[VortexSettings.Notifications.Position or "TopRight"]
    end)
    
    return success and gui or nil
end

function VortexNotif:Show(options)
    if type(options) ~= "table" then options = {} end
    
    if not VortexSettings.Notifications.Enabled then return end
    
    if #self.Active >= VortexSettings.Notifications.Limit then
        if #self.Queue >= 10 then return end
        table.insert(self.Queue, options)
        return
    end
    
    local gui, main, positions = createNotification(options)
    if not gui or not main or not positions then return end
    
    playSound(options.type or "info")
    table.insert(self.Active, gui)
    
    main.Size = UDim2.new(0, 300, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 300, 0, 80),
        Position = positions.End
    }):Play()
    
    task.delay(options.duration or VortexSettings.Notifications.Duration, function()
        local index = table.find(self.Active, gui)
        if index then
            table.remove(self.Active, index)
            
            for i = index, #self.Active do
                local activeGui = self.Active[i]
                local activeMain = activeGui:FindFirstChild("Main")
                if activeMain then
                    local newPos = positions.End
                    newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, 
                        positions.End.Y.Scale == 1 and -90 - ((i-1) * 90) or (20 + ((i-1) * 90)))
                    
                    TweenService:Create(activeMain, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Position = newPos
                    }):Play()
                end
            end
        end
        
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(positions.Start.X.Scale, positions.Start.X.Offset, positions.Start.Y.Scale, positions.Start.Y.Offset + 40)
        }):Play()
        
        task.wait(0.3)
        gui:Destroy()
        
        if #self.Queue > 0 and #self.Active < VortexSettings.Notifications.Limit then
            self:Show(table.remove(self.Queue, 1))
        end
    end)
end

function VortexNotif:Success(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "success"
    })
end

function VortexNotif:Error(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "error"
    })
end

function VortexNotif:Warning(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "warning"
    })
end

function VortexNotif:Info(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "info"
    })
end

function VortexNotif:Question(title, text, callback)
    self:Show({
        title = title,
        text = text,
        type = "question",
        callback = callback,
        duration = 10
    })
end

function VortexNotif:Feedback(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "feedback"
    })
end

return VortexNotif 
