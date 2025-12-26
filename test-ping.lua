-- FIXED ULTRA REAL-TIME PING & FPS
-- 100% SAME AS SHIFT+F3 AND SHIFT+F5

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")

-- Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RealTimeStats"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 80)
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = mainFrame

-- Title Bar with Close Button
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Title with Credit
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "@MikaaDev"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button (X kecil)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0.5, -10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.3, 0)
closeCorner.Parent = closeButton

-- Hover effect
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundTransparency = 0.1
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundTransparency = 0.3
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.Parent = titleBar

-- Ping Display (Bold)
local pingText = Instance.new("TextLabel")
pingText.Size = UDim2.new(1, -10, 0, 25)
pingText.Position = UDim2.new(0, 5, 0, 30)
pingText.BackgroundTransparency = 1
pingText.Text = "Ping: 0ms"
pingText.TextColor3 = Color3.fromRGB(255, 255, 255)
pingText.TextSize = 14
pingText.Font = Enum.Font.GothamBold
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.Parent = mainFrame

-- FPS Display (Bold)
local fpsText = Instance.new("TextLabel")
fpsText.Size = UDim2.new(1, -10, 0, 25)
fpsText.Position = UDim2.new(0, 5, 0, 55)
fpsText.BackgroundTransparency = 1
fpsText.Text = "FPS: 0"
fpsText.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsText.TextSize = 14
fpsText.Font = Enum.Font.GothamBold
fpsText.TextXAlignment = Enum.TextXAlignment.Left
fpsText.Parent = mainFrame

mainFrame.Parent = screenGui

-- Drag function
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

-- ===== FIXED PING GETTER - 100% SAME AS SHIFT+F3 =====
local function GetRobloxPing()
    -- COBA SEMUA METODE SAMPAH DAPAT YANG BENER
    local methods = {
        function() -- Method 1: Exact Roblox internal
            local network = StatsService:WaitForChild("Network", 1)
            if network then
                local statItem = network:WaitForChild("ServerStatsItem", 1)
                if statItem then
                    return statItem:GetValue()
                end
            end
            return nil
        end,
        
        function() -- Method 2: Direct path
            return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end,
        
        function() -- Method 3: Alternative path
            return StatsService:FindFirstChild("Network"):FindFirstChild("ServerStatsItem"):GetValue()
        end,
        
        function() -- Method 4: Try catch all
            local success, value = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if success then return value end
            return nil
        end,
        
        function() -- Method 5: Last resort
            for _, child in pairs(StatsService:GetChildren()) do
                if child.Name == "Network" then
                    for _, stat in pairs(child:GetChildren()) do
                        if stat.Name == "ServerStatsItem" then
                            return stat:GetValue()
                        end
                    end
                end
            end
            return nil
        end
    }
    
    -- Coba semua metode
    for _, method in ipairs(methods) do
        local success, result = pcall(method)
        if success and result and result > 0 then
            return math.floor(result)
        end
        wait() -- Kasih jeda
    end
    
    return 0
end

-- ===== EXACT FPS CALCULATION =====
local frameTimes = {}

local function GetRobloxFPS()
    local currentTime = tick()
    table.insert(frameTimes, currentTime)
    
    -- Keep only last 1 second
    while #frameTimes > 0 and currentTime - frameTimes[1] > 1.0 do
        table.remove(frameTimes, 1)
    end
    
    if #frameTimes < 2 then return 0 end
    
    local timeSpan = currentTime - frameTimes[1]
    if timeSpan <= 0 then return 0 end
    
    local fps = (#frameTimes - 1) / timeSpan
    return math.floor(fps + 0.5) -- Round like Roblox
end

-- ===== REAL-TIME UPDATE =====
local currentPing = 0
local currentFPS = 0
local lastPingUpdate = 0

-- Update FPS EVERY FRAME
RunService.RenderStepped:Connect(function()
    -- Update FPS
    currentFPS = GetRobloxFPS()
    fpsText.Text = "FPS: " .. currentFPS
    
    -- Color based on FPS
    if currentFPS >= 60 then
        fpsText.TextColor3 = Color3.fromRGB(0, 255, 0)
    elseif currentFPS >= 45 then
        fpsText.TextColor3 = Color3.fromRGB(150, 255, 150)
    elseif currentFPS >= 30 then
        fpsText.TextColor3 = Color3.fromRGB(255, 255, 0)
    elseif currentFPS >= 20 then
        fpsText.TextColor3 = Color3.fromRGB(255, 150, 0)
    else
        fpsText.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Update Ping MORE OFTEN
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastPingUpdate >= 0.1 then -- 10x per second
        local newPing = GetRobloxPing()
        
        -- ONLY update if valid ping
        if newPing > 0 or currentPing == 0 then
            currentPing = newPing
            
            -- Update display
            pingText.Text = "Ping: " .. currentPing .. "ms"
            
            -- Color based on ping
            if currentPing < 50 then
                pingText.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif currentPing < 100 then
                pingText.TextColor3 = Color3.fromRGB(150, 255, 150)
            elseif currentPing < 200 then
                pingText.TextColor3 = Color3.fromRGB(255, 255, 0)
            elseif currentPing < 350 then
                pingText.TextColor3 = Color3.fromRGB(255, 150, 0)
            else
                pingText.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
        
        lastPingUpdate = now
    end
end)

-- DEBUG: Print actual Roblox ping for comparison
spawn(function()
    wait(2) -- Wait for game to load
    
    while screenGui and screenGui.Parent do
        -- Get ping from Roblox's actual method
        local robloxPing = 0
        local success = pcall(function()
            robloxPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        
        if success then
            print("[DEBUG] Roblox Actual Ping: " .. math.floor(robloxPing) .. "ms")
            print("[DEBUG] Our Display Ping: " .. currentPing .. "ms")
            
            -- Force update if different
            if math.abs(robloxPing - currentPing) > 20 then
                currentPing = math.floor(robloxPing)
                pingText.Text = "Ping: " .. currentPing .. "ms"
            end
        end
        
        wait(3) -- Check every 3 seconds
    end
end)

print("======================================")
print("FIXED ROBLOX STATS LOADED")
print("Created by @MikaaDev")
print("Debug mode: Will print actual ping every 3s")
print("If ping shows 0ms, check console for debug info")
print("======================================")

return {
    GetPing = function() return currentPing end,
    GetFPS = function() return currentFPS end,
    Close = function() screenGui:Destroy() end
}
