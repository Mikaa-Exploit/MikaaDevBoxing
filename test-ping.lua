-- PING & FPS REALTIME 100% (MikaaDev)
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MikaaDev_Stats"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 70)
mainFrame.Position = UDim2.new(0.02,0,0.02,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,20)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-25,1,0)
title.BackgroundTransparency = 1
title.Text = "MikaaDev"
title.TextColor3 = Color3.fromRGB(0,180,255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,20,0,20)
closeButton.Position = UDim2.new(1,-20,0,0)
closeButton.BackgroundColor3 = Color3.fromRGB(220,40,40)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,4)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function() closeButton.BackgroundTransparency=0.2 end)
closeButton.MouseLeave:Connect(function() closeButton.BackgroundTransparency=0.3 end)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1,-10,0,20)
pingLabel.Position = UDim2.new(0,5,0,22)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(255,255,255)
pingLabel.TextSize = 14
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "Ping: --ms"
pingLabel.Parent = mainFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1,-10,0,20)
fpsLabel.Position = UDim2.new(0,5,0,44)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"
fpsLabel.Parent = mainFrame

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1,-10,0,10)
credit.Position = UDim2.new(0,5,0,64)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.TextSize = 10
credit.Font = Enum.Font.Gotham
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Text = "By MikaaDev"
credit.Parent = mainFrame

-- Dragging
local dragging=false
local dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=mainFrame.Position
	end
end)
mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=false
	end
end)
mainFrame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
	end
end)

-- Realtime ping & FPS
local currentPing=0
local frameTimes={}

RunService.Heartbeat:Connect(function()
	local success,ping = pcall(function()
		local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if item then return item:GetValue() end
	end)
	if success and ping then currentPing=math.floor(ping) end
	pingLabel.Text="Ping: "..currentPing.."ms"
	if currentPing<30 then
		pingLabel.TextColor3=Color3.fromRGB(0,255,0)
	elseif currentPing<60 then
		pingLabel.TextColor3=Color3.fromRGB(100,255,100)
	elseif currentPing<100 then
		pingLabel.TextColor3=Color3.fromRGB(200,255,100)
	elseif currentPing<150 then
		pingLabel.TextColor3=Color3.fromRGB(255,255,0)
	elseif currentPing<250 then
		pingLabel.TextColor3=Color3.fromRGB(255,180,0)
	else
		pingLabel.TextColor3=Color3.fromRGB(255,50,50)
	end
end)

RunService.RenderStepped:Connect(function()
	local now = tick()
	table.insert(frameTimes, now)
	while #frameTimes>120 do table.remove(frameTimes,1) end
	local fps=0
	local oneSecAgo = now-1
	for i=#frameTimes,1,-1 do
		if frameTimes[i]>=oneSecAgo then fps=fps+1 else break end
	end
	fpsLabel.Text="FPS: "..fps
	if fps>=60 then fpsLabel.TextColor3=Color3.fromRGB(0,255,0)
	elseif fps>=40 then fpsLabel.TextColor3=Color3.fromRGB(255,255,0)
	else fpsLabel.TextColor3=Color3.fromRGB(255,180,0) end
end)

print("[MIKAA DEV] Ping & FPS 100% Realtime UI Loaded")
