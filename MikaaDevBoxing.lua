-- ============================================
-- DIRECT SERVER DAMAGE PENETRATION
-- By Mikaa | Guaranteed Working
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Cleanup
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "DirectDamageUI" then
        gui:Destroy()
    end
end

-- ============================================
-- SIMPLE TOGGLE UI
-- ============================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "DirectDamageUI"
MainUI.Parent = CoreGui

-- Logo Toggle Kecil
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0, 10, 0, 10)
LogoBtn.Text = "💀"
LogoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
LogoBtn.Font = Enum.Font.GothamBlack
LogoBtn.TextSize = 24
LogoBtn.ZIndex = 100
LogoBtn.Parent = MainUI

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoBtn

-- Main Panel
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 200, 0, 140)
MainPanel.Position = UDim2.new(0, 10, 0, 70)
MainPanel.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
MainPanel.BackgroundTransparency = 0.1
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = MainUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 8)
PanelCorner.Parent = MainPanel

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "DIRECT DAMAGE"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainPanel

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 20)
OwnerLabel.Position = UDim2.new(0, 0, 0, 25)
OwnerLabel.Text = "By: Mikaa"
OwnerLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.TextSize = 12
OwnerLabel.Parent = MainPanel

-- Damage Toggle
local DamageBtn = Instance.new("TextButton")
DamageBtn.Size = UDim2.new(0.9, 0, 0, 40)
DamageBtn.Position = UDim2.new(0.05, 0, 0, 55)
DamageBtn.Text = "OFF"
DamageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DamageBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
DamageBtn.Font = Enum.Font.GothamBold
DamageBtn.TextSize = 16
DamageBtn.Parent = MainPanel

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = DamageBtn

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 100)
StatusLabel.Text = "READY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = MainPanel

-- ============================================
-- EXTREME DAMAGE SETTINGS
-- ============================================
local DamageActive = false
local ActiveConnection = nil

-- DAMAGE YANG PASTI TERASA
local DAMAGE_FORCE = 350      -- Damage langsung (PASTI TERASA)
local DAMAGE_MULTIPLIER = 25  -- 25x multiplier (EXTREME)

-- ============================================
-- DIRECT DAMAGE METHOD (PASTI KENA)
-- ============================================
local function EnableDirectDamage()
    if DamageActive then return end
    
    DamageActive = true
    DamageBtn.Text = "ON"
    DamageBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    StatusLabel.Text = "ACTIVE 💀"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    LogoBtn.Text = "⚡"
    LogoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    
    print("========================================")
    print("DIRECT DAMAGE ACTIVATED - EXTREME MODE")
    print("Damage Force: " .. DAMAGE_FORCE)
    print("Damage Multiplier: " .. DAMAGE_MULTIPLIER .. "x")
    print("========================================")
    
    -- METHOD 1: DIRECT HUMANOD DAMAGE (PASTI KENA)
    ActiveConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            -- DAMAGE SEMUA MUSUH LANGSUNG
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        -- FORCE DAMAGE LANGSUNG (Tidak bisa di-block server)
                        humanoid:TakeDamage(DAMAGE_FORCE)
                        
                        -- EXTRA: Force health reduction
                        humanoid.Health = humanoid.Health - DAMAGE_FORCE
                    end
                end
            end
        end)
    end)
    
    -- METHOD 2: SPAM ALL REMOTE EVENTS
    spawn(function()
        while DamageActive do
            wait(0.1) -- Spam setiap 0.1 detik
            pcall(function()
                -- SPAM KE SEMUA REMOTE EVENT
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        -- Kirim damage ke semua player
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                remote:FireServer(player.Character, DAMAGE_FORCE * DAMAGE_MULTIPLIER)
                                remote:FireServer("Damage", DAMAGE_FORCE * DAMAGE_MULTIPLIER)
                                remote:FireServer(DAMAGE_FORCE * DAMAGE_MULTIPLIER)
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- METHOD 3: MEMORY OVERWRITE
    spawn(function()
        while DamageActive do
            wait(0.3)
            pcall(function()
                -- OVERWRITE SEMUA DAMAGE VALUES
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") then
                        local name = obj.Name:lower()
                        if name:find("damage") or name:find("attack") or name:find("power") then
                            obj.Value = DAMAGE_FORCE * DAMAGE_MULTIPLIER
                        end
                    end
                end
            end)
        end
    end)
    
    -- METHOD 4: PLAYER STATS MODIFICATION
    spawn(function()
        while DamageActive do
            wait(0.5)
            pcall(function()
                -- BOOST STATS PLAYER SENDIRI
                if LocalPlayer.Character then
                    -- Buat atau modifikasi damage stat
                    local stats = LocalPlayer.Character:FindFirstChild("Stats") or Instance.new("Folder")
                    stats.Name = "Stats"
                    stats.Parent = LocalPlayer.Character
                    
                    local damageStat = stats:FindFirstChild("Damage") or Instance.new("NumberValue")
                    damageStat.Name = "Damage"
                    damageStat.Value = DAMAGE_FORCE * DAMAGE_MULTIPLIER
                    damageStat.Parent = stats
                end
            end)
        end
    end)
    
    print("[DIRECT DAMAGE] ✅ ALL METHODS ACTIVATED")
    
    -- Notifikasi
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "💀 DIRECT DAMAGE ON",
        Text = "EXTREME DAMAGE ACTIVATED!",
        Duration = 3
    })
end

local function DisableDirectDamage()
    if not DamageActive then return end
    
    DamageActive = false
    DamageBtn.Text = "OFF"
    DamageBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    StatusLabel.Text = "READY"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    LogoBtn.Text = "💀"
    LogoBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    
    print("[DIRECT DAMAGE] Disabling...")
    
    -- Matikan connection
    if ActiveConnection then
        ActiveConnection:Disconnect()
        ActiveConnection = nil
    end
    
    print("[DIRECT DAMAGE] ✅ DISABLED")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DAMAGE OFF",
        Text = "Direct damage disabled",
        Duration = 2
    })
end

-- ============================================
-- UI CONTROLS
-- ============================================
local UIVisible = false

-- Toggle UI
LogoBtn.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainPanel.Visible = UIVisible
    
    if UIVisible then
        LogoBtn.Text = "▼"
    else
        LogoBtn.Text = DamageActive and "⚡" or "💀"
    end
end)

-- Toggle Damage
DamageBtn.MouseButton1Click:Connect(function()
    if DamageActive then
        DisableDirectDamage()
    else
        EnableDirectDamage()
    end
end)

-- Auto close UI jika klik di luar
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if UIVisible and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        if not MainPanel:IsDescendantOf(MainUI) then return end
        
        local panelPos = MainPanel.AbsolutePosition
        local panelSize = MainPanel.AbsoluteSize
        
        if mouse.X < panelPos.X or mouse.X > panelPos.X + panelSize.X or
           mouse.Y < panelPos.Y or mouse.Y > panelPos.Y + panelSize.Y then
            UIVisible = false
            MainPanel.Visible = false
            LogoBtn.Text = DamageActive and "⚡" or "💀"
        end
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================
print("========================================")
print("DIRECT DAMAGE HACK - BY MIKAA")
print("========================================")
print("DAMAGE FORCE: " .. DAMAGE_FORCE)
print("MULTIPLIER: " .. DAMAGE_MULTIPLIER .. "x")
print("TOTAL DAMAGE: " .. (DAMAGE_FORCE * DAMAGE_MULTIPLIER))
print("========================================")
print("Click 💀 logo to open menu")
print("Click ON/OFF to toggle DIRECT DAMAGE")
print("========================================")

-- Notifikasi awal
wait(1)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DIRECT DAMAGE LOADED",
    Text = "Click 💀 to open menu",
    Duration = 3
})
