-- OBLIVION BOAT CHAOS MOBILE ULTIMATE
-- Owner: MikaaDev V0.2 | Auto Teleport + Auto Launch

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Config
local chaosEnabled = false
local currentTarget = nil
local chaosBoat = nil
local teleportBeforeRush = true -- Auto teleport sebelum rush

-- Enkripsi owner info (biar aman di GitHub)
local enc = function(str)
    local result = ""
    for i = 1, #str do
        result = result .. string.char(string.byte(str, i) + 3)
    end
    return result
end

local dec = function(encStr)
    local result = ""
    for i = 1, #encStr do
        result = result .. string.char(string.byte(encStr, i) - 3)
    end
    return result
end

-- Print owner info (decrypted saat di-execute)
local ownerEncrypted = "Plnnd#Hqzd#Yhuv#71" -- "MikaaDev V0.2" encrypted
print("[OBLIVION] " .. dec(ownerEncrypted))
print("[MODE] Android Ultimate | Teleport + Launch")

-- ========== BUAT BOAT MEMATIKAN ==========
local function createUltimateBoat()
    local boat = Instance.new("Part")
    boat.Name = "OBLIVION_DEATH_BOAT"
    boat.Size = Vector3.new(15, 5, 30)
    boat.Material = Enum.Material.Neon
    boat.Color = Color3.fromRGB(255, 0, 100)
    boat.Anchored = false
    boat.CanCollide = false
    boat.Transparency = 0.3
    boat.Parent = workspace

    -- Seat
    local seat = Instance.new("Seat")
    seat.Size = Vector3.new(5, 3, 5)
    seat.CFrame = boat.CFrame * CFrame.new(0, 3, -8)
    seat.Parent = boat

    -- Engine glow
    local engine = Instance.new("Part")
    engine.Size = Vector3.new(4, 4, 4)
    engine.Color = Color3.fromRGB(0, 255, 255)
    engine.Material = Enum.Material.Neon
    engine.Transparency = 0.4
    engine.CFrame = boat.CFrame * CFrame.new(0, 0, -15)
    engine.Parent = boat
    Instance.new("Weld", engine).Part0 = boat; Instance.new("Weld", engine).Part1 = engine

    -- Velocity & force
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(50000, 50000, 50000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = boat

    local bodyForce = Instance.new("BodyForce")
    bodyForce.Force = Vector3.new(0, boat:GetMass() * workspace.Gravity * 1.5, 0)
    bodyForce.Parent = boat

    -- Annoying sound
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9126423981"
    sound.Looped = true
    sound.Volume = 7
    sound.Parent = boat

    return boat, bodyVelocity, sound
end

-- ========== TELEPORT KE TARGET ==========
local function teleportToTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    
    if chaosBoat then
        -- Teleport boat di atas target (siap launch)
        chaosBoat.CFrame = targetRoot.CFrame * CFrame.new(0, 25, 0) -- Tinggi biar kelihatan
        return true
    end
    
    return false
end

-- ========== LAUNCH PLAYER KE LANGIT ==========
local function launchPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    
    if targetRoot then
        -- FORCE LAUNCH TINGGI
        targetRoot.Velocity = Vector3.new(
            math.random(-30, 30),  -- Sedikit horizontal
            math.random(200, 350), -- VERTICAL TINGGI BANGET
            math.random(-30, 30)
        )
        
        -- Puterin biar pusing
        targetRoot.RotVelocity = Vector3.new(
            math.random(-30, 30),
            math.random(-30, 30),
            math.random(-30, 30)
        )
        
        -- Stun humanoid
        if humanoid then
            humanoid.PlatformStand = true
            task.delay(3, function() 
                if humanoid then 
                    humanoid.PlatformStand = false 
                end 
            end)
        end
        
        -- Explosion effect
        local exp = Instance.new("Explosion")
        exp.Position = targetRoot.Position
        exp.BlastPressure = 1000
        exp.BlastRadius = 20
        exp.Parent = workspace
        
        print("[LAUNCH] " .. targetPlayer.Name .. " DILAUNCH KE LANGIT!")
    end
end

-- ========== RUSH ROUTINE ==========
local function chaosRoutine()
    while chaosEnabled and currentTarget do
        task.wait(0.5) -- Delay biar nggak terlalu spam
        
        -- TELEPORT DULU sebelum rush (optional)
        if teleportBeforeRush then
            teleportToTarget(currentTarget)
            task.wait(0.2)
        end
        
        -- LAUNCH PLAYER
        launchPlayer(currentTarget)
        
        -- Boat chase effect
        if chaosBoat and currentTarget.Character then
            local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                -- Chase player setelah dia jatuh
                local direction = (targetRoot.Position - chaosBoat.Position).Unit
                chaosBoat.BodyVelocity.Velocity = direction * 100 + Vector3.new(0, 10, 0)
                
                -- Boat rotation effect
                chaosBoat.CFrame = chaosBoat.CFrame * CFrame.fromEulerAnglesXYZ(
                    0,
                    math.rad(10),
                    0
                )
            end
        end
        
        task.wait(1.5) -- Delay antar rush
    end
end

-- ========== MOBILE GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OBLIVION_CONTROL"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.85, 0, 0.7, 0)
mainFrame.Position = UDim2.new(0.075, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Text = "💀 OBLIVION BOAT CHAOS 💀"
title.Size = UDim2.new(1, 0, 0.12, 0)
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = mainFrame

-- Player list
local playerFrame = Instance.new("ScrollingFrame")
playerFrame.Size = UDim2.new(0.9, 0, 0.45, 0)
playerFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
playerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerFrame.Parent = mainFrame

local function updatePlayerList()
    playerFrame:ClearAllChildren()
    
    local yPos = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Text = "🎯 " .. plr.Name
            btn.Size = UDim2.new(0.9, 0, 0, 40)
            btn.Position = UDim2.new(0.05, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextScaled = true
            
            btn.MouseButton1Click:Connect(function()
                currentTarget = plr
                -- Auto teleport ke target
                teleportToTarget(plr)
            end)
            
            btn.Parent = playerFrame
            yPos = yPos + 45
        end
    end
    playerFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Teleport button
local teleportBtn = Instance.new("TextButton")
teleportBtn.Text = "🚀 TELEPORT TO TARGET"
teleportBtn.Size = UDim2.new(0.8, 0, 0.09, 0)
teleportBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextScaled = true
teleportBtn.Parent = mainFrame

teleportBtn.MouseButton1Click:Connect(function()
    if currentTarget then
        if teleportToTarget(currentTarget) then
            teleportBtn.Text = "✅ TELEPORTED!"
            task.wait(1)
            teleportBtn.Text = "🚀 TELEPORT TO TARGET"
        end
    end
end)

-- Rush toggle
local rushBtn = Instance.new("TextButton")
rushBtn.Text = "⚡ RUSH: OFF"
rushBtn.Size = UDim2.new(0.8, 0, 0.09, 0)
rushBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
rushBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
rushBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rushBtn.Font = Enum.Font.GothamBold
rushBtn.TextScaled = true
rushBtn.Parent = mainFrame

rushBtn.MouseButton1Click:Connect(function()
    chaosEnabled = not chaosEnabled
    
    if chaosEnabled then
        rushBtn.Text = "🔥 RUSH: ON"
        rushBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Pastikan boat ada
        if not chaosBoat then
            chaosBoat = createUltimateBoat()
            chaosBoat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, -15)
        end
        
        -- Start chaos
        task.spawn(chaosRoutine)
    else
        rushBtn.Text = "⚡ RUSH: OFF"
        rushBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Spawn boat button
local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "🚤 SPAWN BOAT"
spawnBtn.Size = UDim2.new(0.8, 0, 0.09, 0)
spawnBtn.Position = UDim2.new(0.1, 0, 0.82, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextScaled = true
spawnBtn.Parent = mainFrame

spawnBtn.MouseButton1Click:Connect(function()
    if chaosBoat then chaosBoat:Destroy() end
    chaosBoat = createUltimateBoat()
    chaosBoat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, -15)
    spawnBtn.Text = "✅ BOAT SPAWNED!"
    task.wait(1)
    spawnBtn.Text = "🚤 SPAWN BOAT"
end)

-- Auto update list
coroutine.wrap(function()
    while true do
        updatePlayerList()
        task.wait(3)
    end
end)()

print("[OBLIVION] System Ready! Target, Teleport, then RUSH!")
