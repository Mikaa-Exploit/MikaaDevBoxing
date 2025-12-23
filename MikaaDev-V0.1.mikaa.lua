-- MikaaDev-V0.1
-- Mobile Only
-- Author: Mikaa


-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ===== MOBILE ONLY =====
if not UIS.TouchEnabled then
    warn("MikaaDev: Mobile only")
    return
end

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local char, hum, hrp
local bodyGyro, bodyVelocity

-- ===== LOADER GUI (SAFE) =====
if player:WaitForChild("PlayerGui"):FindFirstChild("MikaaDevLoader") then
    return
end

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "MikaaDevLoader"
loaderGui.IgnoreGuiInset = true
loaderGui.ResetOnSpawn = false
loaderGui.DisplayOrder = 9999
loaderGui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame", loaderGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BackgroundTransparency = 1

local text = Instance.new("TextLabel", loaderGui)
text.Size = UDim2.new(1,0,0,60)
text.Position = UDim2.new(0,0,0.5,0)
text.AnchorPoint = Vector2.new(0,0.5)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1,1,1)
text.TextScaled = true
text.Font = Enum.Font.GothamBold
text.TextStrokeTransparency = 0.6
text.TextStrokeColor3 = Color3.new(0,0,0)
text.RichText = true

local sizeLimit = Instance.new("UITextSizeConstraint", text)
sizeLimit.MaxTextSize = 44

local fullText = "MIKAADEV  -  V0.1"
local typingSpeed = 0.045

task.spawn(function()
    for i = 1, #fullText do
        text.Text =
            "<font letterSpacing='4'>" ..
            string.sub(fullText, 1, i) ..
            "</font>"
        task.wait(typingSpeed)
    end
end)

TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 0.45}):Play()
TweenService:Create(text, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

task.delay(#fullText * typingSpeed + 0.6, function()
    TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(text, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.45)
    loaderGui:Destroy()
end)

-- ===== CONFIG =====
local MIN_WALK = 16
local MAX_WALK = 150
local MIN_JUMP = 50
local MAX_JUMP = 120
local MAX_FLY  = 170
local SMOOTH   = 0.15

-- ===== STATE =====
local targetWalk, targetJump, targetFly = MIN_WALK, MIN_JUMP, 0
local currentWalk, currentJump = MIN_WALK, MIN_JUMP
local flySmooth = Vector3.zero

local speedOn, jumpOn, flyOn, noclipOn = false, false, false, false

-- ===== FORCE DISABLE =====
local function forceDisableAll()
    speedOn, jumpOn, flyOn, noclipOn = false, false, false, false
    targetFly = 0
    flySmooth = Vector3.zero

    if hum then
        hum.WalkSpeed = MIN_WALK
        hum.JumpPower = MIN_JUMP
    end

    pcall(function()
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end)

    bodyGyro, bodyVelocity = nil, nil

    if char then
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
    end
end

-- ===== CHARACTER LOAD =====
local function loadChar(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")

    forceDisableAll()

    hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if hum.Sit then forceDisableAll() end
    end)

    hum.Died:Connect(forceDisableAll)
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

-- ===== DISABLE FLY ONLY =====
local function disableFlyOnly()
    flyOn = false
    targetFly = 0
    flySmooth = Vector3.zero

    pcall(function()
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end)

    bodyGyro, bodyVelocity = nil, nil

    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Freefall)
        task.wait()
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MikaaDevGUI"
gui.ResetOnSpawn = false

local toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,10,0.5,-20)
toggle.Image = "rbxassetid://100166477433523"
toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,400)
frame.Position = UDim2.new(0.65,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Visible = false
frame.Active = true
frame.Draggable = true

toggle.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ===== INPUT ROWS =====
local baseY, spacing = 90, 30

local function makeRow(name, idx)
    local y = baseY + (idx-1)*spacing

    local box = Instance.new("TextBox", frame)
    box.Position = UDim2.new(0.45,0,0,y)
    box.Size = UDim2.new(0.3,0,0,24)
    box.Text = "0"
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.TextColor3 = Color3.new(1,1,1)

    box.FocusLost:Connect(function()
        local val = math.clamp(tonumber(box.Text) or 0, 0, 100)
        box.Text = val
        if name=="SPEED" then
            targetWalk = MIN_WALK + (MAX_WALK-MIN_WALK)*(val/100)
        elseif name=="JUMP" then
            targetJump = MIN_JUMP + (MAX_JUMP-MIN_JUMP)*(val/100)
        elseif name=="FLY" then
            targetFly = MAX_FLY*(val/100)
        end
    end)
end

makeRow("SPEED",1)
makeRow("JUMP",2)
makeRow("FLY",3)

-- ===== MAIN LOOP =====
RunService.RenderStepped:Connect(function()
    if not hum then return end

    if speedOn then
        currentWalk += (targetWalk-currentWalk)*SMOOTH
        hum.WalkSpeed = currentWalk
    else
        hum.WalkSpeed = MIN_WALK
    end

    if jumpOn then
        currentJump += (targetJump-currentJump)*SMOOTH
        hum.JumpPower = currentJump
    else
        hum.JumpPower = MIN_JUMP
    end

    if flyOn and bodyGyro and bodyVelocity then
        bodyGyro.CFrame = camera.CFrame
        local dir = hum.MoveDirection
        local cf = camera.CFrame
        local vel = (cf.LookVector*dir:Dot(cf.LookVector) + cf.RightVector*dir:Dot(cf.RightVector)) * targetFly
        flySmooth += (vel-flySmooth)*0.18
        bodyVelocity.Velocity = flySmooth
    end

    if noclipOn and char then
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

print("MikaaDev V0.1 FULL FIX LOADED ✅")
