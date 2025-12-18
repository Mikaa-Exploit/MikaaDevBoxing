-- ============================================
-- [ MIKAADEV'S CHAOS BOAT SCRIPT v2.1 - FIXED ]
-- Created by: MikaaDev
-- Platform: Roblox Mobile (Android)
-- ============================================

-- Tunggu game fully load dulu
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tunggu karakter load dengan benar
local character
local humanoidRootPart

local function waitForCharacter()
    repeat 
        character = player.Character 
        task.wait(0.5)
    until character
    
    repeat 
        humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.5)
    until humanoidRootPart
    
    print("[MIKAADEV] Character loaded successfully!")
    return true
end

-- Panggil function wait
if not waitForCharacter() then
    player.CharacterAdded:Wait()
    waitForCharacter()
end

-- CONFIGURATION
local chaosEnabled = false
local currentTarget = nil
local chaosBoat = nil
local teleportBeforeRush = true

-- MIKAADEV OWNER IDENTIFICATION
local OWNER_NAME = "MikaaDev"
local OWNER_VERSION = "v2.1"
local EXECUTOR_NAME = "OBLIVION"

print("========================================")
print("OWNER: " .. OWNER_NAME .. " " .. OWNER_VERSION)
print("SYSTEM: " .. EXECUTOR_NAME .. " Execution Engine")
print("========================================")
print("[MIKAADEV] Chaos Boat System Activated!")
print("========================================")

-- ========== MIKAADEV'S BOAT CREATION ==========
local function createMikaaBoat()
    if not workspace then 
        print("[ERROR] Workspace not found!")
        return nil 
    end
    
    local boat = Instance.new("Part")
    boat.Name = "MIKAADEV_CHAOS_BOAT"
    boat.Size = Vector3.new(16, 6, 32)
    boat.Material = Enum.Material.Neon
    boat.Color = Color3.fromRGB(255, 100, 0)
    boat.Anchored = false
    boat.CanCollide = false
    boat.Transparency = 0.25
    boat.Parent = workspace

    -- Add MikaaDev tag
    local tag = Instance.new("BillboardGui")
    tag.Name = "MikaaTag"
    tag.Size = UDim2.new(0, 200, 0, 50)
    tag.AlwaysOnTop = true
    tag.Parent = boat
    
    local label = Instance.new("TextLabel")
    label.Text = "MIKAADEV CHAOS BOAT"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = tag

    -- Premium seat
    local seat = Instance.new("Seat")
    seat.Name = "MikaaSeat"
    seat.Size = Vector3.new(6, 4, 6)
    seat.CFrame = boat.CFrame * CFrame.new(0, 4, -10)
    seat.Parent = boat

    -- Engine effects
    local engine = Instance.new("Part")
    engine.Name = "MikaaEngine"
    engine.Size = Vector3.new(5, 5, 5)
    engine.Color = Color3.fromRGB(0, 200, 255)
    engine.Material = Enum.Material.Neon
    engine.Transparency = 0.3
    engine.CFrame = boat.CFrame * CFrame.new(0, 0, -18)
    engine.Parent = boat
    
    local weld = Instance.new("Weld")
    weld.Part0 = boat
    weld.Part1 = engine
    weld.Parent = engine

    -- Physics
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "MikaaVelocity"
    bodyVelocity.MaxForce = Vector3.new(60000, 60000, 60000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = boat

    local bodyForce = Instance.new("BodyForce")
    bodyForce.Name = "MikaaLift"
    bodyForce.Force = Vector3.new(0, boat:GetMass() * workspace.Gravity * 1.8, 0)
    bodyForce.Parent = boat

    -- Sound
    local sound = Instance.new("Sound")
    sound.Name = "MikaaSound"
    sound.SoundId = "rbxassetid://735030710"
    sound.Looped = true
    sound.Volume = 8
    sound.Parent = boat

    print("[MIKAADEV] Boat created successfully!")
    return boat
end

-- ========== MIKAADEV TELEPORT SYSTEM ==========
local function mikaaTeleport(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then 
        print("[MIKAADEV] Invalid target!")
        return false 
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then 
        print("[MIKAADEV] Target root not found!")
        return false 
    end
    
    if chaosBoat then
        chaosBoat.CFrame = targetRoot.CFrame * CFrame.new(0, 30, 0)
        
        -- Effect
        local effect = Instance.new("Explosion")
        effect.Position = chaosBoat.Position
        effect.BlastPressure = 0
        effect.BlastRadius = 25
        effect.Parent = workspace
        
        print("[MIKAADEV] Teleported to " .. targetPlayer.Name)
        return true
    else
        print("[MIKAADEV] No boat found! Create boat first!")
        return false
    end
end

-- ========== MIKAADEV LAUNCH SYSTEM ==========
local function mikaaLaunch(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then 
        print("[MIKAADEV] Invalid target for launch!")
        return 
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then 
        print("[MIKAADEV] Cannot find target root part!")
        return 
    end
    
    -- SUPER LAUNCH
    targetRoot.Velocity = Vector3.new(
        math.random(-40, 40),
        math.random(300, 450),
        math.random(-40, 40)
    )
    
    -- Spin madness
    targetRoot.RotVelocity = Vector3.new(
        math.random(-40, 40),
        math.random(-40, 40),
        math.random(-40, 40)
    )
    
    -- Stun effect
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = 0
        task.delay(4, function() 
            if humanoid then 
                humanoid.PlatformStand = false 
                humanoid.WalkSpeed = 16
            end 
        end)
    end
    
    -- MikaaDev explosion
    for i = 1, 3 do
        local exp = Instance.new("Explosion")
        exp.Position = targetRoot.Position + Vector3.new(math.random(-10,10), math.random(0,20), math.random(-10,10))
        exp.BlastPressure = 500
        exp.BlastRadius = 15
        exp.Parent = workspace
        task.wait(0.1)
    end
    
    print("[MIKAADEV] LAUNCHED " .. targetPlayer.Name .. " TO SPACE! 🚀")
end

-- ========== MIKAADEV CHAOS ROUTINE ==========
local function mikaaChaosRoutine()
    while chaosEnabled and currentTarget do
        task.wait(0.6)
        
        if not currentTarget or not currentTarget.Character then
            print("[MIKAADEV] Target lost, stopping chaos!")
            chaosEnabled = false
            break
        end
        
        -- Teleport dulu kalo enabled
        if teleportBeforeRush then
            mikaaTeleport(currentTarget)
            task.wait(0.3)
        end
        
        -- LAUNCH!
        mikaaLaunch(currentTarget)
        
        -- Chase setelah launch
        if chaosBoat and currentTarget.Character then
            local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and chaosBoat:FindFirstChild("MikaaVelocity") then
                local direction = (targetRoot.Position - chaosBoat.Position).Unit
                chaosBoat.MikaaVelocity.Velocity = direction * 120 + Vector3.new(0, 15, 0)
                
                -- Cool rotation
                chaosBoat.CFrame = chaosBoat.CFrame * CFrame.fromEulerAnglesXYZ(
                    math.rad(5),
                    math.rad(15),
                    math.rad(5)
                )
            end
        end
        
        task.wait(1.8)
    end
end

-- ========== CREATE GUI ==========
local function createMikaaGUI()
    -- Cek PlayerGui dulu
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        repeat 
            playerGui = player:WaitForChild("PlayerGui", 5) 
            task.wait(0.5)
        until playerGui
    end
    
    local mikaaGui = Instance.new("ScreenGui")
    mikaaGui.Name = "MIKAADEV_CONTROL_PANEL"
    mikaaGui.Parent = playerGui

    -- Main panel
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MikaaMainPanel"
    mainPanel.Size = UDim2.new(0.9, 0, 0.75, 0)
    mainPanel.Position = UDim2.new(0.05, 0, 0.12, 0)
    mainPanel.BackgroundColor3 = Color3.fromRGB(20, 10, 0)
    mainPanel.BackgroundTransparency = 0.15
    mainPanel.Parent = mikaaGui

    -- Header
    local header = Instance.new("TextLabel")
    header.Name = "MikaaHeader"
    header.Text = "🔥 MIKAADEV CHAOS CONTROL 🔥"
    header.Size = UDim2.new(1, 0, 0.15, 0)
    header.TextColor3 = Color3.fromRGB(255, 150, 0)
    header.Font = Enum.Font.GothamBlack
    header.TextScaled = true
    header.BackgroundTransparency = 1
    header.Parent = mainPanel

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "MikaaSubtitle"
    subtitle.Text = "Teleport | Launch | Destroy | Version " .. OWNER_VERSION
    subtitle.Size = UDim2.new(1, 0, 0.08, 0)
    subtitle.Position = UDim2.new(0, 0, 0.15, 0)
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 0)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextScaled = true
    subtitle.BackgroundTransparency = 1
    subtitle.Parent = mainPanel

    -- Player list
    local playerList = Instance.new("ScrollingFrame")
    playerList.Name = "MikaaPlayerList"
    playerList.Size = UDim2.new(0.9, 0, 0.4, 0)
    playerList.Position = UDim2.new(0.05, 0, 0.25, 0)
    playerList.BackgroundColor3 = Color3.fromRGB(30, 20, 10)
    playerList.Parent = mainPanel

    local function updateMikaaList()
        playerList:ClearAllChildren()
        
        local yOffset = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local playerBtn = Instance.new("TextButton")
                playerBtn.Name = "Btn_" .. plr.Name
                playerBtn.Text = "🎯 " .. plr.Name .. " [TARGET]"
                playerBtn.Size = UDim2.new(0.9, 0, 0, 45)
                playerBtn.Position = UDim2.new(0.05, 0, 0, yOffset)
                playerBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
                playerBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
                playerBtn.Font = Enum.Font.GothamBold
                playerBtn.TextScaled = true
                
                playerBtn.MouseButton1Click:Connect(function()
                    currentTarget = plr
                    print("[MIKAADEV] Target selected: " .. plr.Name)
                end)
                
                playerBtn.Parent = playerList
                yOffset = yOffset + 50
            end
        end
        playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    end

    -- Control buttons
    local buttons = {
        {name = "TELEPORT_BTN", text = "🚀 TELEPORT TO TARGET", pos = 0.67, color = Color3.fromRGB(0, 100, 255), func = function()
            if currentTarget then
                mikaaTeleport(currentTarget)
            else
                print("[MIKAADEV] Select a target first!")
            end
        end},
        
        {name = "RUSH_BTN", text = "⚡ AUTO RUSH: OFF", pos = 0.77, color = Color3.fromRGB(255, 50, 50), func = function()
            chaosEnabled = not chaosEnabled
            local btn = mainPanel:FindFirstChild("RUSH_BTN")
            if btn then
                if chaosEnabled then
                    if not currentTarget then
                        print("[MIKAADEV] Select a target first!")
                        chaosEnabled = false
                        return
                    end
                    
                    btn.Text = "🔥 AUTO RUSH: ON"
                    btn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                    
                    if not chaosBoat then
                        chaosBoat = createMikaaBoat()
                        if chaosBoat then
                            chaosBoat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, -20)
                        end
                    end
                    
                    task.spawn(mikaaChaosRoutine)
                else
                    btn.Text = "⚡ AUTO RUSH: OFF"
                    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                end
            end
        end},
        
        {name = "BOAT_BTN", text = "🚤 CREATE BOAT", pos = 0.87, color = Color3.fromRGB(150, 0, 200), func = function()
            if chaosBoat then 
                chaosBoat:Destroy() 
                print("[MIKAADEV] Old boat destroyed!")
            end
            
            chaosBoat = createMikaaBoat()
            if chaosBoat and humanoidRootPart then
                chaosBoat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, -20)
                print("[MIKAADEV] Chaos boat deployed!")
            else
                print("[MIKAADEV] Failed to create boat!")
            end
        end}
    }

    for _, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = btnData.name
        btn.Text = btnData.text
        btn.Size = UDim2.new(0.8, 0, 0.08, 0)
        btn.Position = UDim2.new(0.1, 0, btnData.pos, 0)
        btn.BackgroundColor3 = btnData.color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.Parent = mainPanel
        
        btn.MouseButton1Click:Connect(btnData.func)
    end

    -- Auto refresh
    coroutine.wrap(function()
        while mikaaGui.Parent do
            updateMikaaList()
            task.wait(4)
        end
    end)()

    print("[MIKAADEV] Control panel loaded successfully!")
    return mikaaGui
end

-- ========== MAIN EXECUTION ==========
-- Tunggu sebentar biar game stabil
task.wait(2)

-- Buat GUI
local success, errorMsg = pcall(function()
    createMikaaGUI()
end)

if not success then
    print("[ERROR] Failed to create GUI: " .. tostring(errorMsg))
    print("[MIKAADEV] Retrying in 3 seconds...")
    task.wait(3)
    pcall(createMikaaGUI)
end

print("[MIKAADEV] System ready! Select target and press buttons!")
print("[MIKAADEV] Instructions:")
print("1. Select target from list")
print("2. Press CREATE BOAT")
print("3. Press TELEPORT TO TARGET (optional)")
print("4. Press AUTO RUSH: ON")
print("========================================")
