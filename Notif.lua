local Notif = {
    Active = {},
    Queue = {},
    LastError = nil,
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
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local function getSettings()
    if not getgenv or not getgenv().VortexSettings then
        return {
            Theme = {
                Current = "Purple",
                Presets = {
                    Purple = {
                        Background = Color3.fromRGB(15, 15, 20),
                        Secondary = Color3.fromRGB(25, 25, 30),
                        Accent = Color3.fromRGB(170, 0, 255),
                        Text = Color3.fromRGB(255, 255, 255)
                    }
                }
            },
            Notifications = {
                Enabled = true,
                Duration = 5,
                Limit = 5,
                Position = "BottomRight"
            }
        }
    end
    return getgenv().VortexSettings
end

local function getTheme()
    local settings = getSettings()
    return settings.Theme.Presets[settings.Theme.Current] or settings.Theme.Presets.Purple
end

local function playSound(type)
    local settings = getSettings()
    if not settings.UI.Sounds.Enabled then return end
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = settings.UI.Sounds[type] or settings.UI.Sounds.Click
        sound.Volume = settings.UI.Sounds.Volume
        sound.Parent = CoreGui
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1)
    end)
end

local function createNotification(options)
    local theme = getTheme()
    local settings = getSettings()
    
    local success, gui = pcall(function()
        local newGui = Instance.new("ScreenGui")
        newGui.Name = "VortexNotification"
        
        pcall(function() newGui.Parent = CoreGui end)
        if not newGui.Parent then
            newGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(0, 300, 0, 80)
        
        local positions = {
            TopRight = {
                Start = UDim2.new(1, 20, 0, 20 + (#Notif.Active * 90)),
                End = UDim2.new(1, -320, 0, 20 + (#Notif.Active * 90))
            },
            BottomRight = {
                Start = UDim2.new(1, 20, 1, -90 - (#Notif.Active * 90)),
                End = UDim2.new(1, -320, 1, -90 - (#Notif.Active * 90))
            },
            TopLeft = {
                Start = UDim2.new(0, -320, 0, 20 + (#Notif.Active * 90)),
                End = UDim2.new(0, 20, 0, 20 + (#Notif.Active * 90))
            },
            BottomLeft = {
                Start = UDim2.new(0, -320, 1, -90 - (#Notif.Active * 90)),
                End = UDim2.new(0, 20, 1, -90 - (#Notif.Active * 90))
            }
        }
        
        main.Position = positions[settings.Notifications.Position or "BottomRight"].Start
        main.BackgroundColor3 = theme.Background
        main.BorderSizePixel = 0
        main.Parent = newGui
        
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
        
        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 4, 1, 0)
        accent.BackgroundColor3 = theme.Accent
        
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
        
        local emoji = Instance.new("TextLabel")
        emoji.Text = Notif.Emojis[options.type] or ""
        emoji.Size = UDim2.new(0, 25, 0, 25)
        emoji.Position = UDim2.new(0, 15, 0, 8)
        emoji.BackgroundTransparency = 1
        emoji.TextColor3 = theme.Text
        emoji.Font = Enum.Font.GothamBold
        emoji.TextSize = 16
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
            noBtn.Parent = main
            
            Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 4)
            
            yesBtn.MouseButton1Click:Connect(function()
                if options.callback then options.callback(true) end
                newGui:Destroy()
            end)
            
            noBtn.MouseButton1Click:Connect(function()
                if options.callback then options.callback(false) end
                newGui:Destroy()
            end)
        end
        
        return newGui, main, positions[settings.Notifications.Position or "BottomRight"]
    end)
    
    return success and gui or nil
end

function Notif:Show(options)
    if type(options) ~= "table" then options = {} end
    
    local settings = getSettings()
    if not settings.Notifications.Enabled then return end
    
    if #self.Active >= settings.Notifications.Limit then
        if #self.Queue >= 10 then return end
        table.insert(self.Queue, options)
        return
    end
    
    local gui, main, positions = createNotification(options)
    if not gui or not main or not positions then return end
    
    table.insert(self.Active, gui)
    
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = positions.End
    }):Play()
    
    task.delay(options.duration or settings.Notifications.Duration, function()
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
        
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = positions.Start
        }):Play()
        
        task.wait(0.3)
        gui:Destroy()
        
        if #self.Queue > 0 and #self.Active < settings.Notifications.Limit then
            self:Show(table.remove(self.Queue, 1))
        end
    end)
end

function Notif:Success(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "success"
    })
end

function Notif:Error(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "error"
    })
end

function Notif:Warning(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "warning"
    })
end

function Notif:Info(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "info"
    })
end

function Notif:Question(title, text, callback)
    self:Show({
        title = title,
        text = text,
        type = "question",
        callback = callback,
        duration = 10
    })
end

function Notif:Feedback(title, text, duration)
    self:Show({
        title = title,
        text = text,
        duration = duration,
        type = "feedback"
    })
end

return Notif
