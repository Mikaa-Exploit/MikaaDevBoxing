-- PING MIKAA V0.1

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MikaaDev_Stats"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 80)
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -28, 1, 0)
title.BackgroundTransparency = 1
title.Text = "MikaaDev"
title.TextColor3 = Color3.fromRGB(0, 180, 255)
title.TextSize = 18 
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -24, 0.5, -10)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.3, 0)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundTransparency = 0.2
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundTransparency = 0.3
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.Parent = titleBar

local pingText = Instance.new("TextLabel")
pingText.Name = "PingDisplay"
pingText.Size = UDim2.new(1, -10, 0, 28)
pingText.Position = UDim2.new(0, 5, 0, 30)
pingText.BackgroundTransparency = 1
pingText.Text = "Ping: --ms"
pingText.TextColor3 = Color3.fromRGB(255, 255, 255)
pingText.TextSize = 18
pingText.Font = Enum.Font.GothamBold
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.TextYAlignment = Enum.TextYAlignment.Top
pingText.Parent = mainFrame

local fpsText = Instance.new("TextLabel")
fpsText.Name = "FPSDisplay"
fpsText.Size = UDim2.new(1, -10, 0, 28)
fpsText.Position = UDim2.new(0, 5, 0, 58)
fpsText.BackgroundTransparency = 1
fpsText.Text = "FPS: --"
fpsText.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsText.TextSize = 18 
fpsText.Font = Enum.Font.GothamBold
fpsText.TextXAlignment = Enum.TextXAlignment.Left
fpsText.TextYAlignment = Enum.TextYAlignment.Top
fpsText.Parent = mainFrame

mainFrame.Parent = screenGui

local dragging = false
local dragStart, frameStart

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local function GetExactRobloxPing()

    local success, ping = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    
    if success and ping then
        return math.floor(ping)
    end
    
    return 0
end

local frameTimes = {}
local MAX_FRAMES = 120

local function GetExactRobloxFPS()
    local currentTime = tick()
    table.insert(frameTimes, currentTime)
    
    while #frameTimes > MAX_FRAMES do
        table.remove(frameTimes, 1)
    end
    

    local oneSecondAgo = currentTime - 1.0
    local framesInLastSecond = 0
    
    for i = #frameTimes, 1, -1 do
        if frameTimes[i] >= oneSecondAgo then
            framesInLastSecond = framesInLastSecond + 1
        else
            break
        end
    end
    
    return framesInLastSecond
end

local currentPing = 0
local currentFPS = 0
local lastPingUpdate = 0
local lastFPS = 0

RunService.RenderStepped:Connect(function()
    
    currentFPS = GetExactRobloxFPS()
    
    if currentFPS ~= lastFPS then
        fpsText.Text = "FPS: " .. currentFPS
        
        if currentFPS >= 60 then
            fpsText.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif currentFPS >= 50 then
            fpsText.TextColor3 = Color3.fromRGB(100, 255, 100)
        elseif currentFPS >= 40 then
            fpsText.TextColor3 = Color3.fromRGB(200, 255, 100)
        elseif currentFPS >= 30 then
            fpsText.TextColor3 = Color3.fromRGB(255, 255, 0)
        elseif currentFPS >= 20 then
            fpsText.TextColor3 = Color3.fromRGB(255, 180, 0)
        else
            fpsText.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        
        lastFPS = currentFPS
    end
end)

RunService.Heartbeat:Connect(function()
    local now = tick()
    
    if now - lastPingUpdate >= 0.1 then
        local newPing = GetExactRobloxPing()
        
        if newPing > 0 or currentPing == 0 then
            currentPing = newPing
            
            pingText.Text = "Ping: " .. currentPing .. "ms"
            
            if currentPing < 30 then
                pingText.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif currentPing < 60 then
                pingText.TextColor3 = Color3.fromRGB(100, 255, 100)
            elseif currentPing < 100 then
                pingText.TextColor3 = Color3.fromRGB(200, 255, 100)
            elseif currentPing < 150 then
                pingText.TextColor3 = Color3.fromRGB(255, 255, 0)
            elseif currentPing < 250 then
                pingText.TextColor3 = Color3.fromRGB(255, 180, 0)
            else
                pingText.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
        
        lastPingUpdate = now
    end
end)

spawn(function()
    wait(2)
    
    print("MIKAA DEV STATS LOADED")
    
    while screenGui and screenGui.Parent do
        wait(5)
    
    end
end)

return {
    GetPing = function() return currentPing end,
    GetFPS = function() return currentFPS end,
    Close = function() screenGui:Destroy() end
}
