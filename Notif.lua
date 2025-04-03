local Notif = {
    Active = {},
    Queue = {},
    LastError = nil
}

local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local function getSettings()
    return getgenv().VortexSettings
end

local function getTheme()
    local settings = getSettings()
    return settings and settings.Theme.Presets[settings.Theme.Current]
end

local function playSound(type)
    local settings = getSettings()
    if not settings or not settings.UI.Sounds.Enabled then return end
    
    local sound = Instance.new("Sound")
    sound.SoundId = settings.UI.Sounds[type] or settings.UI.Sounds.Click
    sound.Volume = settings.UI.Sounds.Volume
    sound.Parent = CoreGui
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function createNotification(options)
    local theme = getTheme()
    if not theme then return end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "VortexNotification"
    gui.Parent = CoreGui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 300, 0, 80)
    main.Position = UDim2.new(1, 20, 1, -90 - (#Notif.Active * 90))
    main.BackgroundColor3 = theme.Background
    main.BorderSizePixel = 0
    main.Parent = gui
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = theme.Accent
    
    local accentColors = {
        error = Color3.fromRGB(255, 50, 50),
        warning = Color3.fromRGB(255, 150, 0),
        success = Color3.fromRGB(50, 255, 50)
    }
    accent.BackgroundColor3 = accentColors[options.type] or theme.Accent
    accent.BorderSizePixel = 0
    accent.Parent = main
    
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 8)
    
    local title = Instance.new("TextLabel")
    title.Text = options.title
    title.Size = UDim2.new(1, -50, 0, 25)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.TextColor3 = theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = main
    
    local message = Instance.new("TextLabel")
    message.Text = options.text
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
            playSound("Click")
            if options.callback then options.callback(true) end
            gui:Destroy()
        end)
        
        noBtn.MouseButton1Click:Connect(function()
            playSound("Click")
            if options.callback then options.callback(false) end
            gui:Destroy()
        end)
    end
    
    return gui
end

function Notif:Show(options)
    local settings = getSettings()
    if not settings or not settings.Notifications.Enabled then return end
    
    if #self.Active >= settings.Notifications.Limit then
        if #self.Queue >= 10 then return end
        table.insert(self.Queue, options)
        return
    end
    
    local gui = createNotification(options)
    if not gui then return end
    
    playSound(options.type or "Success")
    table.insert(self.Active, gui)
    
    TweenService:Create(gui.Frame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 1, -90 - ((#self.Active - 1) * 90))
    }):Play()
    
    task.delay(options.duration or settings.Notifications.Duration, function()
        local index = table.find(self.Active, gui)
        if index then
            table.remove(self.Active, index)
            
            for i = index, #self.Active do
                local activeGui = self.Active[i]
                TweenService:Create(activeGui.Frame, TweenInfo.new(0.3), {
                    Position = UDim2.new(1, -320, 1, -90 - ((i-1) * 90))
                }):Play()
            end
        end
        
        TweenService:Create(gui.Frame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, 1, gui.Frame.Position.Y.Offset)
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

function Notif:Question(title, text, callback)
    self:Show({
        title = title,
        text = text,
        type = "question",
        callback = callback,
        duration = 10
    })
end

return Notif
