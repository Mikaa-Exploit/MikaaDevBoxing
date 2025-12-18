-- MikaaDev Delta Executor v3
-- TestingDevByMikaa
-- Each feature has individual ON/OFF button

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ========== MIKAADEV UI ==========
local MikaaDevUI = {}
MikaaDevUI.ToggleKey = Enum.KeyCode.RightShift

function MikaaDevUI:Create()
    local CoreGui = game:GetService("CoreGui")
    
    -- Hapus UI lama
    if CoreGui:FindFirstChild("MikaaDevUI") then
        CoreGui:FindFirstChild("MikaaDevUI"):Destroy()
    end
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MikaaDevUI"
    ScreenGui.Parent = CoreGui
    
    -- Main Window
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 300, 0, 350)
    Main.Position = UDim2.new(0.5, -150, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Main.BorderColor3 = Color3.fromRGB(0, 100, 255)
    Main.BorderSizePixel = 2
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
    Header.Parent = Main
    
    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Position = UDim2.new(0, 5, 0, 5)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://100166477433523"
    Logo.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = "MikaaDev Delta"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 40, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Text = "TestingDevByMikaa"
    Subtitle.Size = UDim2.new(1, 0, 0, 15)
    Subtitle.Position = UDim2.new(0, 0, 0, 40)
    Subtitle.BackgroundTransparency = 1
    Subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    Subtitle.Font = Enum.Font.Code
    Subtitle.TextSize = 10
    Subtitle.Parent = Main
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -30, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseBtn.TextColor3 = Color3.white
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    CloseBtn.Parent = Header
    
    -- Features Container
    local Features = Instance.new("ScrollingFrame")
    Features.Size = UDim2.new(1, -10, 1, -70)
    Features.Position = UDim2.new(0, 5, 0, 60)
    Features.BackgroundTransparency = 1
    Features.ScrollBarThickness = 4
    Features.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
    Features.CanvasSize = UDim2.new(0, 0, 0, 400)
    Features.Parent = Main
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = Features
    
    MikaaDevUI.Main = Features
    MikaaDevUI.ScreenGui = ScreenGui
    
    return Features
end

function MikaaDevUI:AddFeature(name, buttonText, callback)
    local FeatureFrame = Instance.new("Frame")
    FeatureFrame.Size = UDim2.new(1, 0, 0, 50)
    FeatureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    FeatureFrame.BorderSizePixel = 0
    
    -- Feature Name
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = name
    NameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    NameLabel.Position = UDim2.new(0, 5, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = Color3.fromRGB(200, 230, 255)
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = FeatureFrame
    
    -- ON/OFF Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Text = buttonText or "OFF"
    ToggleBtn.Size = UDim2.new(0.35, -10, 0, 30)
    ToggleBtn.Position = UDim2.new(0.65, 0, 0.5, -15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- RED = OFF
    ToggleBtn.TextColor3 = Color3.white
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    
    local isActive = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        
        if isActive then
            ToggleBtn.Text = "ON"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- GREEN = ON
        else
            ToggleBtn.Text = "OFF"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- RED = OFF
        end
        
        -- Execute callback
        if callback then
            callback(isActive)
        end
    end)
    
    ToggleBtn.Parent = FeatureFrame
    FeatureFrame.Parent = MikaaDevUI.Main
    
    return FeatureFrame
end

-- ========== HACK FUNCTIONS ==========
local Hacks = {
    Coin = {Active = false, Value = 9999},
    Damage = {Active = false, Multiplier = 10},
    Health = {Active = false, Bonus = 500}
}

-- COIN HACK FUNCTION
local function CoinHack(enable)
    Hacks.Coin.Active = enable
    
    if enable then
        spawn(function()
            while Hacks.Coin.Active do
                -- Method 1: Direct value modification
                local playerData = LocalPlayer:FindFirstChild("leaderstats") or 
                                  LocalPlayer:FindFirstChild("Data") or
                                  LocalPlayer:FindFirstChild("Stats")
                
                if playerData then
                    local coins = playerData:FindFirstChild("Coins") or 
                                 playerData:FindFirstChild("Money") or
                                 playerData:FindFirstChild("Coin")
                    
                    if coins and coins:IsA("IntValue") or coins:IsA("NumberValue") then
                        coins.Value = Hacks.Coin.Value
                    end
                end
                
                -- Method 2: Try to find coins in workspace
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name:lower():find("coin") or 
                        obj.Name:lower():find("uang") or 
                        obj.Name:lower():find("money")) and 
                       obj:IsA("Part") then
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
                
                wait(0.3)
            end
        end)
    end
end

-- DAMAGE HACK FUNCTION
local function DamageHack(enable)
    Hacks.Damage.Active = enable
    
    if enable then
        -- Hook untuk meningkatkan damage
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Tangkap fungsi damage
            if method == "FireServer" or method == "InvokeServer" then
                if tostring(self):find("Damage") or 
                   tostring(self):find("Hit") or 
                   tostring(self):find("Attack") then
                    
                    -- Multiply damage value
                    for i, arg in pairs(args) do
                        if typeof(arg) == "number" and arg > 0 and arg < 1000 then
                            args[i] = arg * Hacks.Damage.Multiplier
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
        
        -- Juga modifikasi tool damage
        if LocalPlayer.Character then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local script = tool:FindFirstChildOfClass("Script")
                    if script then
                        -- Backup original source
                        if not script:FindFirstChild("OriginalSource") then
                            local backup = Instance.new("StringValue")
                            backup.Name = "OriginalSource"
                            backup.Value = script.Source
                            backup.Parent = script
                        end
                        
                        -- Modify damage values
                        local source = script.Source
                        source = source:gsub("damage%s*=%s*%d+", "damage = " .. tostring(50 * Hacks.Damage.Multiplier))
                        source = source:gsub("Damage%s*=%s*%d+", "Damage = " .. tostring(50 * Hacks.Damage.Multiplier))
                        script.Source = source
                    end
                end
            end
        end
    end
end

-- HEALTH HACK FUNCTION
local function HealthHack(enable)
    Hacks.Health.Active = enable
    
    if enable then
        local function ApplyHealthBoost()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Increase max health
                    humanoid.MaxHealth = humanoid.MaxHealth + Hacks.Health.Bonus
                    humanoid.Health = humanoid.MaxHealth
                    
                    -- Auto-regen
                    humanoid.HealthChanged:Connect(function()
                        if Hacks.Health.Active and humanoid.Health < humanoid.MaxHealth then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end)
                end
            end
        end
        
        ApplyHealthBoost()
        
        -- Re-apply when character respawns
        LocalPlayer.CharacterAdded:Connect(ApplyHealthBoost)
    end
end

-- ========== INITIALIZE ==========
local FeaturesFrame = MikaaDevUI:Create()

-- ADD FEATURES WITH SEPARATE BUTTONS
MikaaDevUI:AddFeature("COIN", "OFF", function(state)
    CoinHack(state)
end)

MikaaDevUI:AddFeature("DAMAGE", "OFF", function(state)
    DamageHack(state)
end)

MikaaDevUI:AddFeature("HEALTH", "OFF", function(state)
    HealthHack(state)
end)

MikaaDevUI:AddFeature("SPEED", "OFF", function(state)
    if state then
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 32
            end
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

MikaaDevUI:AddFeature("NO COOLDOWN", "OFF", function(state)
    if state then
        spawn(function()
            while Hacks.CooldownActive do
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") and (obj.Name:find("Cooldown") or obj.Name:find("CD")) then
                        obj.Value = 0
                    end
                end
                wait(0.5)
            end
        end)
    end
    Hacks.CooldownActive = state
end)

-- HOTKEY TOGGLE
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == MikaaDevUI.ToggleKey then
        MikaaDevUI.ScreenGui.Enabled = not MikaaDevUI.ScreenGui.Enabled
    end
end)

-- NOTIFICATION
print("===========================================")
print("MikaaDev Delta Executor v3 Loaded!")
print("TestingDevByMikaa")
print("Features: COIN | DAMAGE | HEALTH | SPEED | NO CD")
print("Press RightShift to toggle UI")
print("===========================================")

-- Welcome message
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "MikaaDev Delta",
    Text = "Executor Loaded! Press RightShift",
    Duration = 5
})
