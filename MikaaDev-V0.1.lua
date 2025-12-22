-- MikaaDev-V0.1
-- Mobile Only
-- Author: Mikaa

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

-- MOBILE ONLY
if not UIS.TouchEnabled then
warn("MikaaDev: Mobile only")
return
end

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local char, hum, hrp
local bodyGyro, bodyVelocity

-- SIMPLE CENTER TEXT LOADER (FIXED FINAL)
local TweenService = game:GetService("TweenService")

-- CEK LOADER SUDAH ADA ATAU BELUM
if player:WaitForChild("PlayerGui"):FindFirstChild("MikaaDevLoader") then
return
end

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "MikaaDevLoader"
loaderGui.IgnoreGuiInset = true
loaderGui.ResetOnSpawn = false
loaderGui.Parent = player:WaitForChild("PlayerGui")
loaderGui.DisplayOrder = 9999

-- BACKGROUND OVERLAY
local bg = Instance.new("Frame", loaderGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BackgroundTransparency = 1
bg.ZIndex = 0

-- TEXT (TYPING EFFECT)
local fullText = "MIKAADEV  -  V0.1"
local typingSpeed = 0.045

local text = Instance.new("TextLabel", loaderGui)
text.Size = UDim2.new(1,0,0,60)
text.Position = UDim2.new(0,0,0.5,0)
text.AnchorPoint = Vector2.new(0,0.5)
text.BackgroundTransparency = 1
text.Text = ""
text.TextColor3 = Color3.fromRGB(255,255,255)
text.TextScaled = true
text.TextTransparency = 0
text.Font = Enum.Font.GothamBold
text.ZIndex = 1
text.TextStrokeTransparency = 0.6
text.TextStrokeColor3 = Color3.new(0,0,0)

text.RichText = true

-- SIZE LIMIT
local sizeLimit = Instance.new("UITextSizeConstraint")
sizeLimit.MaxTextSize = 44
sizeLimit.Parent = text

task.spawn(function()
for i = 1, #fullText do
local partial = string.sub(fullText, 1, i)
text.Text =
"<font letterSpacing='4' color='rgb(255,255,255)'>" ..
partial ..
"</font>"
task.wait(typingSpeed)
end
end)

-- HITUNG WAKTU TYPING
local typingTime = #fullText * typingSpeed

-- FADE IN
TweenService:Create(
bg,
TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{BackgroundTransparency = 0.45}
):Play()

TweenService:Create(
text,
TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{TextTransparency = 0}
):Play()

-- HOLD + FADE OUT (SETELAH TYPING SELESAI)
task.delay(typingTime + 0.5, function()

TweenService:Create(
bg,
TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
{BackgroundTransparency = 1}
):Play()

TweenService:Create(
text,
TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
{TextTransparency = 1}
):Play()

task.wait(0.45)
loaderGui:Destroy()

end)

-- CONFIG

local MIN_WALK = 16
local MAX_WALK = 150
local MIN_JUMP = 50
local MAX_JUMP = 120
local MAX_FLY  = 170
local SMOOTH   = 0.15

-- STATE

local targetWalk = MIN_WALK
local targetJump = MIN_JUMP
local targetFly  = 0

local currentWalk = MIN_WALK
local currentJump = MIN_JUMP
local flySmooth   = Vector3.zero

local speedOn  = false
local jumpOn   = false
local flyOn    = false
local noclipOn = false

-- FORCE DISABLE ALL

local function forceDisableAll()
speedOn = false
jumpOn = false
flyOn = false
noclipOn = false

targetFly = 0
flySmooth = Vector3.zero

if hum then
hum.WalkSpeed = MIN_WALK
hum.JumpPower = MIN_JUMP
end

if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end

end

-- CHARACTER LOAD

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

--FLY FIX BY MIKAA
local function disableFlyOnly()
flyOn = false
targetFly = 0
flySmooth = Vector3.zero

if bodyGyro then  
    bodyGyro:Destroy()  
    bodyGyro = nil  
end  

if bodyVelocity then  
    bodyVelocity:Destroy()  
    bodyVelocity = nil  
end  

if hum and hrp then  
    hrp.AssemblyLinearVelocity = Vector3.zero  
    hrp.AssemblyAngularVelocity = Vector3.zero  

    hum:ChangeState(Enum.HumanoidStateType.Freefall)  
    task.wait()  
    hum:ChangeState(Enum.HumanoidStateType.Landed)  
    task.wait()  
    hum:ChangeState(Enum.HumanoidStateType.Running)  
end

end

-- GUI

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "MikaaDevGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.DisplayOrder = 1

local toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,10,0.5,-20)
toggle.Image = "rbxassetid://100166477433523"
toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)

local moved = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,400) -- diperbesar untuk muat semua
frame.Position = UDim2.new(0.65,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true
frame.Visible = false -- sementara debug
frame.Name = "MainFrame"

toggle.MouseButton1Click:Connect(function()
if moved then return end -- kalau habis drag, jangan toggle
frame.Visible = not frame.Visible
end)

-- DRAGGABLE MINI LOGO (TOGGLE)

do
local dragging = false
local dragStart = Vector2.zero
local startPos = toggle.Position

local function update(input)
local delta = input.Position - dragStart
if delta.Magnitude > 6 then
moved = true
end

toggle.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)

end

toggle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
dragging = true
moved = false
dragStart = input.Position
startPos = toggle.Position
end
end)

toggle.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)

UIS.InputChanged:Connect(function(input)
if dragging and input.UserInputType == Enum.UserInputType.Touch then
update(input)
end
end)

end

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,10)
title.Text = "MikaaDev-V0.1"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- LOGO DI BAWAH TITLE
local logo = Instance.new("ImageLabel", frame)
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0.5,-25,0,title.Position.Y.Offset + title.Size.Y.Offset + 5)
logo.Image = "rbxassetid://100166477433523"
logo.BackgroundTransparency = 1
logo.ScaleType = Enum.ScaleType.Fit

-- INPUT ROW (MULAI DARI BAWAH LOGO)
local baseY = logo.Position.Y.Offset + logo.Size.Y.Offset + 10
local rowSpacing = 30

local function makeRow(name, index)
local y = baseY + (index-1) * rowSpacing
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
pct.Text = val.."%"

if name == "SPEED" then
targetWalk = MIN_WALK + (MAX_WALK - MIN_WALK) * (val/100)
elseif name == "JUMP" then
targetJump = MIN_JUMP + (MAX_JUMP - MIN_JUMP) * (val/100)
elseif name == "FLY SPD" then
targetFly = MAX_FLY * (val/100)
end

end)

end

makeRow("SPEED",1)
makeRow("JUMP",2)
makeRow("FLY SPD",3)

-- TOGGLE BUTTONS
local function makeToggle(name,index)
local y = baseY + 3*rowSpacing + (index-1)*35
local btn = Instance.new("TextButton", frame)
btn.Position = UDim2.new(0,10,0,y)
btn.Size = UDim2.new(1,-20,0,30)
btn.Text = name.." : OFF"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(120,40,40)

btn.MouseButton1Click:Connect(function()
if name == "SPEED" then speedOn = not speedOn
elseif name == "JUMP" then jumpOn = not jumpOn
elseif name == "FLY" then
flyOn = not flyOn

if flyOn and hrp and hum then
hum:ChangeState(Enum.HumanoidStateType.Physics)

bodyGyro = Instance.new("BodyGyro")    
bodyGyro.P = 9e4    
bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)    
bodyGyro.CFrame = camera.CFrame    
bodyGyro.Parent = hrp    

bodyVelocity = Instance.new("BodyVelocity")    
bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)    
bodyVelocity.Velocity = Vector3.zero    
bodyVelocity.Parent = hrp

else
disableFlyOnly()
end

elseif name == "NOCLIP" then noclipOn = not noclipOn
end

local state = (name=="SPEED" and speedOn) or
(name=="JUMP" and jumpOn) or
(name=="FLY" and flyOn) or
(name=="NOCLIP" and noclipOn)

btn.Text = name.." : "..(state and "ON" or "OFF")
btn.BackgroundColor3 = state and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)

end)

end

makeToggle("SPEED",1)
makeToggle("JUMP",2)
makeToggle("FLY",3)
makeToggle("NOCLIP",4)

-- MAIN LOOP

RunService.RenderStepped:Connect(function()
if hum then
-- WALK SPEED (SMOOTH FIX)
if speedOn then
currentWalk = currentWalk + (targetWalk - currentWalk) * SMOOTH
hum.WalkSpeed = currentWalk
else
currentWalk = MIN_WALK
hum.WalkSpeed = MIN_WALK
end

-- JUMP POWER (SMOOTH FIX)
if jumpOn then
currentJump = currentJump + (targetJump - currentJump) * SMOOTH
hum.JumpPower = currentJump
else
currentJump = MIN_JUMP
hum.JumpPower = MIN_JUMP
end

-- FLY
if flyOn and bodyGyro and bodyVelocity then
bodyGyro.CFrame = camera.CFrame

local moveDir = hum.MoveDirection
local cf = camera.CFrame
local vel = Vector3.zero

if moveDir.Magnitude > 0.05 then
vel =
(cf.LookVector * moveDir:Dot(cf.LookVector) +
cf.RightVector * moveDir:Dot(cf.RightVector)) * (targetFly * 0.9)

vel += Vector3.new(0, cf.LookVector.Y * targetFly * 0.8, 0)

end

flySmooth += (vel - flySmooth) * 0.18
bodyVelocity.Velocity = flySmooth

end
-- NOCLIP
if noclipOn and char then
for _,p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then
p.CanCollide = false
end
end
end

end

end)

print("MikaaDev FULL FIX LOADED ✅")
