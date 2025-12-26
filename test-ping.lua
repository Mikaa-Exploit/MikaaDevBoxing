-- ULTRA REAL-TIME PING & FPS FOR MOBILE
-- Super Accurate with Bold Text & Credits

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")

-- Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraRealTimeStats"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 100) -- Sedikit lebih besar
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = mainFrame

-- Shadow Effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Title Bar with Close Button
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Title with Credits
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "@MikaaDev"
title.TextColor3 = Color3.fromRGB(0, 180, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold -- Font tebal
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button (X kecil)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(1, -27, 0.5, -11)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
closeButton.BackgroundTransparency = 0.2
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.3, 0)
closeCorner.Parent = closeButton

-- Close function
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.Parent = titleBar

-- ULTRA REAL-TIME PING DISPLAY (Text tebal)
local pingText = Instance.new("TextLabel")
pingText.Name = "PingDisplay"
pingText.Size = UDim2.new(1, -10, 0, 30)
pingText.Position = UDim2.new(0, 5, 0, 30)
pingText.BackgroundTransparency = 1
pingText.Text = "Ping: --ms"
pingText.TextColor3 = Color3.fromRGB(255, 255, 255)
pingText.TextSize = 16 -- Sedikit lebih besar
pingText.Font = Enum.Font.GothamBold -- TEBAK!
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.Parent = mainFrame

-- ULTRA REAL-TIME FPS DISPLAY (Text tebal)
local fpsText = Instance.new("TextLabel")
fpsText.Name = "FPSDisplay"
fpsText.Size = UDim2.new(1, -10, 0, 30)
fpsText.Position = UDim2.new(0, 5, 0, 60)
fpsText.BackgroundTransparency = 1
fpsText.Text = "FPS: --"
fpsText.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsText.TextSize = 16 -- Sedikit lebih besar
fpsText.Font = Enum.Font.GothamBold -- TEBAK!
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

-- ===== ULTRA ACCURATE PING GETTER =====
local pingHistory = {}
local MAX_PING_HISTORY = 10

local function GetUltraAccuratePing()
    local pings = {}
    
    -- Method 1: Primary (paling akurat)
    local success1, ping1 = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    
    if success1 and ping1 > 0 then
        table.insert(pings, ping1)
    end
    
    -- Method 2: Alternative
    local success2, ping2 = pcall(function()
        return game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("ServerStatsItem"):GetValue()
    end)
    
    if success2 and ping2 > 0 then
        table.insert(pings, ping2)
    end
    
    -- Method 3: Backup
    local success3, ping3 = pcall(function()
        return game:GetService("Stats"):WaitForChild("Network"):WaitForChild("ServerStatsItem"):GetValue()
    end)
    
    if success3 and ping3 > 0 then
        table.insert(pings, ping3)
    end
    
    -- Kalau semua gagal, coba dari cache
    if #pings == 0 and #pingHistory > 0 then
        return pingHistory[#pingHistory]
    end
    
    -- Ambil rata-rata dari pings yang valid
    if #pings > 0 then
        local total = 0
        for _, p in ipairs(pings) do
            total = total + p
        end
        local avgPing = total / #pings
        
        -- Simpan ke history untuk smoothing
        table.insert(pingHistory, avgPing)
        if #pingHistory > MAX_PING_HISTORY then
            table.remove(pingHistory, 1)
        end
        
        -- Ambil median dari history untuk lebih smooth
        if #pingHistory >= 3 then
            table.sort(pingHistory)
            return pingHistory[math.floor(#pingHistory / 2) + 1]
        end
        
        return avgPing
    end
    
    return 0
end

-- ===== ULTRA ACCURATE FPS CALCULATOR =====
local frameTimes = {}
local MAX_FRAME_SAMPLES = 60 -- Sample 1 detik penuh

local function CalculateUltraAccurateFPS()
    local currentTime = tick()
    table.insert(frameTimes, currentTime)
    
    -- Hapus frame times yang lebih dari 1 detik
    while #frameTimes > 0 and currentTime - frameTimes[1] > 1.0 do
        table.remove(frameTimes, 1)
    end
    
    if #frameTimes < 2 then
        return 0
    end
    
    local timeSpan = frameTimes[#frameTimes] - frameTimes[1]
    if timeSpan <= 0 then
        return 0
    end
    
    return math.floor((#frameTimes - 1) / timeSpan)
end

-- ===== MICRO-OPTIMIZED UPDATE LOOP =====
local lastPingUpdate = 0
local lastFPSUpdate = 0
local currentPing = 0
local currentFPS = 0

-- Gunakan RenderStepped untuk FPS paling akurat
RunService.RenderStepped:Connect(function()
    -- Update FPS setiap frame (paling real-time)
    currentFPS = CalculateUltraAccurateFPS()
    
    -- Update FPS display dengan warna
    fpsText.Text = "FPS: " .. currentFPS
    if currentFPS >= 60 then
        fpsText.TextColor3 = Color3.fromRGB(0, 255, 0)    -- Hijau terang (sangat baik)
    elseif currentFPS >= 45 then
        fpsText.TextColor3 = Color3.fromRGB(100, 255, 100) -- Hijau muda (baik)
    elseif currentFPS >= 30 then
        fpsText.TextColor3 = Color3.fromRGB(255, 255, 0)   -- Kuning (sedang)
    elseif currentFPS >= 20 then
        fpsText.TextColor3 = Color3.fromRGB(255, 150, 0)   -- Oranye (buruk)
    else
        fpsText.TextColor3 = Color3.fromRGB(255, 50, 50)   -- Merah (sangat buruk)
    end
    
    -- Update Ping setiap 0.3 detik (lebih cepat dari sebelumnya)
    local now = tick()
    if now - lastPingUpdate >= 0.3 then
        currentPing = GetUltraAccuratePing()
        lastPingUpdate = now
        
        -- Update Ping display dengan warna
        pingText.Text = "Ping: " .. math.floor(currentPing) .. "ms"
        if currentPing < 50 then
            pingText.TextColor3 = Color3.fromRGB(0, 255, 0)    -- Hijau (sangat baik)
        elseif currentPing < 100 then
            pingText.TextColor3 = Color3.fromRGB(100, 255, 100) -- Hijau muda (baik)
        elseif currentPing < 200 then
            pingText.TextColor3 = Color3.fromRGB(255, 255, 0)   -- Kuning (sedang)
        elseif currentPing < 350 then
            pingText.TextColor3 = Color3.fromRGB(255, 150, 0)   -- Oranye (buruk)
        else
            pingText.TextColor3 = Color3.fromRGB(255, 50, 50)   -- Merah (sangat buruk)
        end
    end
end)

-- ===== ADDITIONAL ACCURACY: HEARTBEAT PING =====
-- Extra ping check untuk memastikan akurasi
spawn(function()
    while screenGui and screenGui.Parent do
        wait(2) -- Cek ping tambahan setiap 2 detik
        pcall(function()
            local extraPing = GetUltraAccuratePing()
            if extraPing > 0 and math.abs(extraPing - currentPing) > 50 then
                -- Jika ada perbedaan signifikan, update
                currentPing = extraPing
            end
        end)
    end
end)

-- ===== PERFORMANCE MONITOR =====
local function GetPerformanceGrade()
    if currentFPS >= 60 and currentPing < 80 then
        return "S+"
    elseif currentFPS >= 45 and currentPing < 120 then
        return "A"
    elseif currentFPS >= 30 and currentPing < 200 then
        return "B"
    elseif currentFPS >= 20 and currentPing < 300 then
        return "C"
    else
        return "D"
    end
end

-- Update title dengan performance grade
spawn(function()
    while screenGui and screenGui.Parent do
        wait(1)
        local grade = GetPerformanceGrade()
        title.Text = "@MikaaDev [" .. grade .. "]"
    end
end)

print("======================================")
print("ULTRA REAL-TIME PING & FPS LOADED")
print("Created by @MikaaDev")
print("Features:")
print("- Ultra accurate ping calculation")
print("- Frame-perfect FPS counter")
print("- Smooth ping history averaging")
print("- Performance grade system")
print("- Bold text display")
print("======================================")

-- Return stats untuk debugging
return {
    GetCurrentPing = function() return math.floor(currentPing) end,
    GetCurrentFPS = function() return currentFPS end,
    GetPerformanceGrade = GetPerformanceGrade,
    Destroy = function() screenGui:Destroy() end
}
