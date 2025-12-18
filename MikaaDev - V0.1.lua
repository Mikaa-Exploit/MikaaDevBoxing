-- ============================================
-- [ MIKAADEV FISHING CHAOS v3.0 - FIXED ]
-- Created by: MikaaDev
-- Platform: Roblox Mobile (Android)
-- ============================================

-- Wait for game
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for character properly
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local chaosEnabled = false
local currentTarget = nil
local chaosBoat = nil
local uiVisible = true

-- MIKAADEV CONFIG
local OWNER_NAME = "MikaaDev"
local OWNER_VERSION = "v3.0"

print("========================================")
print("MIKAADEV FISHING CHAOS " .. OWNER_VERSION)
print("Target: Disrupt fishing players with boat")
print("========================================")

-- ========== BOAT CREATION ==========
local function createFishingBoat()
    if chaosBoat and chaosBoat.Parent then
        chaosBoat:Destroy()
    end
    
    local boat = Instance.new("Part")
    boat.Name = "MIKAADEV_FISHING_BOAT"
    boat.Size = Vector3.new(10, 3, 20) -- Smaller for fishing games
    boat.Material = Enum.Material.Neon
    boat.Color = Color3.fromRGB(255, 0, 0)
    boat.Anchored = false
    boat.CanCollide = true -- IMPORTANT: Biar bisa nabrak pemancing
    boat.Transparency = 0.2
    boat.Parent = workspace
    
    -- Boat model basic
    local seat = Instance.new("Seat")
    seat.Size = Vector3.new(4, 2, 4)
    seat.CFrame = boat.CFrame * CFrame.new(0, 2, -5)
    seat.Parent = boat
    
    -- Velocity for movement
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = boat
    
    -- Anti-sink
    local bodyForce = Instance.new("BodyForce")
    bodyForce.Force = Vector3.new(0, boat:GetMass() * workspace.Gravity * 1.5, 0)
    bodyForce.Parent = boat
    
    -- Fishing disruption field
    local disruptField = Instance.new("Part")
    disruptField.Size = Vector3.new(30, 30, 30)
    disruptField.Transparency = 1
    disruptField.CanCollide = false
    disruptField.Anchored = true
    disruptField.Parent = boat
    local weld = Instance.new("Weld")
    weld.Part0 = boat
    weld.Part1 = disruptField
    weld.Parent = disruptField
    
    print("[MIKAADEV] Fishing boat created! Get in the seat!")
    return boat
end

-- ========== GET IN BOAT ==========
local function getInBoat()
    if not chaosBoat then return false end
    
    local seat = chaosBoat:FindFirstChildWhichIsA("Seat")
    if seat and character then
        character:MoveTo(seat.Position)
        task.wait(0.5)
        -- Try to sit
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Sit = true
        end
        return true
    end
    return false
end

-- ========== TELEPORT TO FISHERMAN ==========
local function teleportToFisherman(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        print("[MIKAADEV] Target not found!")
        return false
    end
    
    if not chaosBoat then
        print("[MIKAADEV] Create boat first!")
        return false
    end
    
    -- Cek apakah target lagi mancing
    local isFishing = false
    for _, tool in pairs(targetPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fish")) then
            isFishing = true
            break
        end
    end
    
    if not isFishing then
        print("[MIKAADEV] Target is not fishing!")
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        -- Teleport boat DI ATAS target (biar jatuh ke dia)
        chaosBoat.CFrame = targetRoot.CFrame * CFrame.new(0, 10, 0)
        
        -- Small explosion effect
        local exp = Instance.new("Explosion")
        exp.Position = targetRoot.Position
        exp.BlastPressure = 0
        exp.BlastRadius = 10
        exp.Parent = workspace
        
        print("[MIKAADEV] Teleported to " .. targetPlayer.Name)
        return true
    end
    
    return false
end

-- ========== LAUNCH FISHERMAN ==========
local function launchFisherman(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    
    if targetRoot then
        -- BOAT SMASH EFFECT: Boat jatuh ke target
        if chaosBoat then
            chaosBoat.CFrame = targetRoot.CFrame * CFrame.new(0, 15, 0)
            task.wait(0.1)
            
            -- Drop boat onto fisherman
            if chaosBoat:FindFirstChild("BodyVelocity") then
                chaosBoat.BodyVelocity.Velocity = Vector3.new(0, -100, 0)
            end
        end
        
        -- LAUNCH FISHERMAN HIGH
        targetRoot.Velocity = Vector3.new(
            math.random(-20, 20),
            math.random(250, 350), -- HIGH LAUNCH
            math.random(-20, 20)
        )
        
        -- Spin effect
        targetRoot.RotVelocity = Vector3.new(
            math.random(-25, 25),
            math.random(-25, 25),
            math.random(-25, 25)
        )
        
        -- Stun fisherman
        if humanoid then
            humanoid.PlatformStand = true
            humanoid.WalkSpeed = 0
            
            task.delay(5, function()
                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid.WalkSpeed = 16
                end
            end)
        end
        
        -- Fishing rod removal (biar gagal mancing)
        for _, tool in pairs(targetPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
        
        print("[MIKAADEV] LAUNCHED " .. targetPlayer.Name .. " SKY HIGH! 🎣🚀")
        return true
    end
    
    return false
end

-- ========== FISHING CHAOS ROUTINE ==========
local function fishingChaosRoutine()
    while chaosEnabled and currentTarget do
        task.wait(0.5)
        
        if not currentTarget.Character then
            print("[MIKAADEV] Target left, stopping chaos!")
            chaosEnabled = false
            break
        end
        
        -- 1. Teleport to fisherman
        teleportToFisherman(currentTarget)
        task.wait(0.3)
        
        -- 2. Launch fisherman
        launchFisherman(currentTarget)
        task.wait(0.5)
        
        -- 3. Boat chase after launch
        if chaosBoat and currentTarget.Character then
            local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and chaosBoat:FindFirstChild("BodyVelocity") then
                -- Chase the launched fisherman
                local direction = (targetRoot.Position - chaosBoat.Position).Unit
                chaosBoat.BodyVelocity.Velocity = direction * 80
            end
        end
        
        task.wait(2) -- Delay between attacks
    end
end

-- ========== MINI GUI ==========
local miniGui = Instance.new("ScreenGui")
miniGui.Name = "MIKAADEV_MINI_UI"
miniGui.Parent = player:WaitForChild("PlayerGui")

-- Toggle button (⛔)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleUI"
toggleBtn.Text = "⛔"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 24
toggleBtn.ZIndex = 10
toggleBtn.Parent = miniGui

-- Main UI (hidden by default)
local mainUI = Instance.new("Frame")
mainUI.Name = "MainUI"
mainUI.Size = UDim2.new(0.3, 0, 0.5, 0)
mainUI.Position = UDim2.new(0, 70, 0.25, 0)
mainUI.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainUI.BackgroundTransparency = 0.2
mainUI.Visible = true
mainUI.Parent = miniGui

-- UI toggle function
toggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    mainUI.Visible = uiVisible
    toggleBtn.Text = uiVisible and "⛔" or "✅"
end)

-- Header
local header = Instance.new("TextLabel")
header.Text = "🎣 MIKAADEV 🚤"
header.Size = UDim2.new(1, 0, 0.15, 0)
header.TextColor3 = Color3.fromRGB(255, 100, 0)
header.Font = Enum.Font.GothamBlack
header.TextScaled = true
header.BackgroundTransparency = 1
header.Parent = mainUI

-- Player list (compact)
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(0.9, 0, 0.4, 0)
playerList.Position = UDim2.new(0.05, 0, 0.2, 0)
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.Parent = mainUI

local function updatePlayerList()
    playerList:ClearAllChildren()
    
    local yOffset = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Text = "🎯 " .. plr.Name
            btn.Size = UDim2.new(0.9, 0, 0, 30)
            btn.Position = UDim2.new(0.05, 0, 0, yOffset)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextScaled = true
            
            btn.MouseButton1Click:Connect(function()
                currentTarget = plr
                print("[MIKAADEV] Target: " .. plr.Name)
            end)
            
            btn.Parent = playerList
            yOffset = yOffset + 35
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Compact buttons
local buttons = {
    {text = "🚤 GET BOAT", func = function()
        chaosBoat = createFishingBoat()
        if humanoidRootPart then
            chaosBoat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, -10)
        end
        getInBoat()
    end},
    
    {text = "🎣 GET IN BOAT", func = function()
        if getInBoat() then
            print("[MIKAADEV] In boat seat!")
        else
            print("[MIKAADEV] No boat or seat!")
        end
    end},
    
    {text = "🚀 TP TO TARGET", func = function()
        if currentTarget then
            teleportToFisherman(currentTarget)
        else
            print("[MIKAADEV] Select target first!")
        end
    end},
    
    {text = "⚡ RUSH: OFF", func = function(btn)
        chaosEnabled = not chaosEnabled
        
        if chaosEnabled then
            if not currentTarget then
                print("[MIKAADEV] Select target first!")
                chaosEnabled = false
                return
            end
            
            if not chaosBoat then
                print("[MIKAADEV] Create boat first!")
                chaosEnabled = false
                return
            end
            
            btn.Text = "🔥 RUSH: ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Start chaos routine
            task.spawn(fishingChaosRoutine)
        else
            btn.Text = "⚡ RUSH: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end}
}

local yPos = 0.65
for i, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Text = btnData.text
    btn.Size = UDim2.new(0.9, 0, 0.08, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = mainUI
    
    if i == 4 then -- Rush button needs self reference
        btn.MouseButton1Click:Connect(function()
            btnData.func(btn)
        end)
    else
        btn.MouseButton1Click:Connect(btnData.func)
    end
    
    yPos = yPos + 0.1
end

-- Auto update player list
coroutine.wrap(function()
    while miniGui.Parent do
        updatePlayerList()
        task.wait(3)
    end
end)()

-- Status display
local status = Instance.new("TextLabel")
status.Text = "Ready | Target: None"
status.Size = UDim2.new(1, 0, 0.08, 0)
status.Position = UDim2.new(0, 0, 0.95, 0)
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Parent = mainUI

-- Update status
coroutine.wrap(function()
    while miniGui.Parent do
        local targetText = currentTarget and currentTarget.Name or "None"
        local boatText = chaosBoat and "Boat: ✅" or "Boat: ❌"
        status.Text = "Target: " .. targetText .. " | " .. boatText
        task.wait(1)
    end
end)()

print("[MIKAADEV] =================================")
print("[MIKAADEV] FISHING CHAOS SYSTEM LOADED!")
print("[MIKAADEV] Workflow:")
print("[MIKAADEV] 1. Select fishing target")
print("[MIKAADEV] 2. Press GET BOAT")
print("[MIKAADEV] 3. Press GET IN BOAT (optional)")
print("[MIKAADEV] 4. Press TP TO TARGET")
print("[MIKAADEV] 5. Press RUSH: ON")
print("[MIKAADEV] =================================")
print("[MIKAADEV] UI toggle: Click ⛔ button")
print("[MIKAADEV] =================================")
