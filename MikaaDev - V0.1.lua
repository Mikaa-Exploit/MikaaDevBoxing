-- MikaaDev-V0.1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

-- =========================
-- ANDROID ONLY
-- =========================
if not UIS.TouchEnabled then
    warn("MikaaDev: Mobile only")
    return
end

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local char, hum, hrp
local bodyGyro, bodyVelocity
local waterPlat

-- CONFIG
local MIN_WALK = 16
local MAX_WALK = 800
local MIN_JUMP = 50
local MAX_JUMP = 250
local MAX_FLY = 300
local SMOOTH = 0.15

-- STATE
local targetWalk = MIN_WALK
local targetJump = MIN_JUMP
local targetFly = 0
local currentWalk = MIN_WALK
local currentJump = MIN_JUMP
local flySmooth = Vector3.zero

local speedOn = false
local jumpOn = false
local flyOn = false
local noclipOn = false
local waterOn = false

-- =========================
-- FORCE OFF ALL (FIX UTAMA)
-- =========================
local function forceDisableAll()
    speedOn = false
    jumpOn = false
    flyOn = false
    noclipOn = false
    waterOn = false

    targetFly = 0
    flySmooth = Vector3.zero

    if hum then
        hum.WalkSpeed = MIN_WALK
        hum.JumpPower = MIN_JUMP
    end

    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if waterPlat then waterPlat:Destroy() waterPlat = nil end
end

-- =========================
-- CHARACTER LOAD
-- =========================
local function loadChar(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")

    forceDisableAll()

    hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if hum.Sit then
            forceDisableAll()
        end
    end)

    hum.Died:Connect(function()
        forceDisableAll()
    end)
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

-- =========================
-- GUI
-- =========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,10,0.5,-20)
toggle.Image = "rbxassetid://100166477433523"
toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,380)
frame.Position = UDim2.new(0.65,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true
frame.Visible = false

toggle.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,10)
title.Text = "MikaaDev-V0.1"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- INPUT ROW
local function makeRow(name, y)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Position = UDim2.new(0,10,0,y)
    lbl.Size = UDim2.new(0.4,0,0,24)
    lbl.Text = name
    lbl.TextScaled = true
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", frame)
    input.Position = UDim2.new(0.4,0,0,y)
    input.Size = UDim2.new(0.25,0,0,24)
    input.Text = "0"
    input.TextScaled = true
    input.BackgroundColor3 = Color3.fromRGB(30,30,30)
    input.TextColor3 = Color3.new(1,1,1)

    local pct = Instance.new("TextLabel", frame)
    pct.Position = UDim2.new(0.7,0,0,y)
    pct.Size = UDim2.new(0.25,0,0,24)
    pct.Text = "0%"
    pct.TextScaled = true
    pct.BackgroundTransparency = 1
    pct.TextColor3 = Color3.fromRGB(0,255,0)

    input.FocusLost:Connect(function()
        local val = math.clamp(tonumber(input.Text) or 0, 0, 100)
        input.Text = val
        pct.Text = val .. "%"

        if name == "SPEED" then
            targetWalk = MIN_WALK + (MAX_WALK - MIN_WALK) * (val / 100)
        elseif name == "JUMP" then
            targetJump = MIN_JUMP + (MAX_JUMP - MIN_JUMP) * (val / 100)
        elseif name == "FLY SPD" then
            targetFly = MAX_FLY * (val / 100)
        end
    end)
end

makeRow("SPEED", 60)
makeRow("JUMP", 90)
makeRow("FLY SPD", 120)

-- TOGGLE BUTTON
local function makeToggle(name, y)
    local btn = Instance.new("TextButton", frame)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Text = name .. " : OFF"
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(120,40,40)

    btn.MouseButton1Click:Connect(function()
        if name == "SPEED" then speedOn = not speedOn
        elseif name == "JUMP" then jumpOn = not jumpOn
        elseif name == "FLY" then
            flyOn = not flyOn
            if flyOn and hrp then
                bodyGyro = Instance.new("BodyGyro", hrp)
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
                bodyVelocity = Instance.new("BodyVelocity", hrp)
                bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
            else
                forceDisableAll()
            end
        elseif name == "NOCLIP" then noclipOn = not noclipOn
        elseif name == "WATER" then waterOn = not waterOn
        end

        local state =
            (name=="SPEED" and speedOn) or
            (name=="JUMP" and jumpOn) or
            (name=="FLY" and flyOn) or
            (name=="NOCLIP" and noclipOn) or
            (name=="WATER" and waterOn)

        btn.Text = name.." : "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
    end)
end

makeToggle("SPEED", 160)
makeToggle("JUMP", 195)
makeToggle("FLY", 230)
makeToggle("NOCLIP", 265)
makeToggle("WATER", 300)

-- =========================
-- MAIN LOOP (FULL)
-- =========================
RunService.RenderStepped:Connect(function()
    if hum then
        if speedOn then
            currentWalk += (targetWalk - currentWalk) * SMOOTH
            hum.WalkSpeed = currentWalk
        else
            hum.WalkSpeed = MIN_WALK
        end

        if jumpOn then
            currentJump += (targetJump - currentJump) * SMOOTH
            hum.JumpPower = currentJump
        else
            hum.JumpPower = MIN_JUMP
        end
    end

    -- FLY (SMOOTH ANDROID + IOS)
if flyOn and bodyGyro and bodyVelocity and hum then
    bodyGyro.CFrame = camera.CFrame

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude > 0.05 then
        local cf = camera.CFrame

        -- arah relatif kamera (HALUS & KONSISTEN)
        local forward = moveDir:Dot(cf.LookVector)
        local right   = moveDir:Dot(cf.RightVector)

        -- smoothing tambahan (ringan)
        local flySpeed = targetFly * 0.92

        local vel =
            (cf.LookVector * forward + cf.RightVector * right) * flySpeed

        -- vertical ikut kamera tapi lembut (ANDROID & IOS SAMA)
        vel += Vector3.new(0, cf.LookVector.Y * flySpeed * 0.85, 0)

        flySmooth += (vel - flySmooth) * 0.18
        bodyVelocity.Velocity = flySmooth
    else
        -- idle hover lembut
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
        end

    -- NOCLIP
    if noclipOn and char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    -- WATER WALK (FULL BALIK)
    if waterOn and hrp then
        local ray = Workspace:Raycast(hrp.Position, Vector3.new(0,-6,0))
        if ray and ray.Material == Enum.Material.Water then
            if not waterPlat then
                waterPlat = Instance.new("Part", Workspace)
                waterPlat.Size = Vector3.new(6,1,6)
                waterPlat.Anchored = true
                waterPlat.Transparency = 1
                waterPlat.CanCollide = true
            end
            waterPlat.Position = ray.Position + Vector3.new(0,1,0)
        end
    elseif waterPlat then
        waterPlat:Destroy()
        waterPlat = nil
    end
end)

print("MikaaDev FULL FINAL FIX ✅")
