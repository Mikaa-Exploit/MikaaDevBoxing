-- ============================================
-- LIGHT SERVER 
-- By Mikaa | Ambil Code? Silahkan :)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Cleanup
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "LightDamageUI" then
        gui:Destroy()
    end
end

-- ============================================
-- SIMPLE TOGGLE UI (Logo Kecil)
-- ============================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "LightDamageUI"
MainUI.Parent = CoreGui

-- Logo Toggle Kecil (Pojok Kiri Atas)
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0, 10, 0, 10)
LogoBtn.Text = "🔴"
LogoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
LogoBtn.Font = Enum.Font.GothamBold
LogoBtn.TextSize = 24
LogoBtn.ZIndex = 100
LogoBtn.Parent = MainUI

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoBtn

-- Main Panel (Sembunyi Awal)
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 220, 0, 160)
MainPanel.Position = UDim2.new(0, 10, 0, 70)
MainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainPanel.BackgroundTransparency = 0.05
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = MainUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = MainPanel

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "LIGHT DAMAGE HACK"
Title.TextColor3 = Color3.fromRGB(255, 150, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainPanel

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 20)
OwnerLabel.Position = UDim2.new(0, 0, 0, 25)
OwnerLabel.Text = "By: Mikaa"
OwnerLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.TextSize = 12
OwnerLabel.Parent = MainPanel

-- Damage Toggle
local DamageBtn = Instance.new("TextButton")
DamageBtn.Size = UDim2.new(0.85, 0, 0, 50)
DamageBtn.Position = UDim2.new(0.075, 0, 0, 60)
DamageBtn.Text = "⚡ DAMAGE: OFF"
DamageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DamageBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
DamageBtn.Font = Enum.Font.GothamBold
DamageBtn.TextSize = 16
DamageBtn.Parent = MainPanel

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = DamageBtn

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 120)
StatusLabel.Text = "🟢 READY"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = MainPanel

-- ============================================
-- LIGHT DAMAGE SETTINGS
-- ============================================
local DamageActive = false
local ActiveConnections = {}

-- Damage Ringan Tapi Terasa
local BASE_DAMAGE = 80        -- Damage dasar
local DAMAGE_MULTIPLIER = 8   -- 8x multiplier (ringan)
local PACKET_DELAY = 0.3      -- Delay antar packet (cegah spam)

-- ============================================
-- LIGHT PENETRATION METHOD (No FPS Drop)
-- ============================================
local function LightPacketModification()
    -- Method 1: Simple Remote Hook
    local hookedRemotes = {}
    
    -- Cari remote damage yang ada
    local damageRemotes = {}
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("attack") then
                table.insert(damageRemotes, remote)
            end
        end
    end
    
    -- Jika tidak ada, gunakan remote umum
    if #damageRemotes == 0 then
        for _, remote in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if remote:IsA("RemoteEvent") then
                table.insert(damageRemotes, remote)
            end
        end
    end
    
    -- Hook remotes dengan cara ringan
    for _, remote in pairs(damageRemotes) do
        if not hookedRemotes[remote] then
            local originalFire = remote.FireServer
            hookedRemotes[remote] = originalFire
            
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- Modifikasi damage dengan ringan
                for i, arg in pairs(args) do
                    if type(arg) == "number" then
                        if arg > 0 and arg < 500 then
                            args[i] = arg * DAMAGE_MULTIPLIER
                        end
                    end
                end
                
                return originalFire(self, unpack(args))
            end
        end
    end
    
    -- Return cleanup function
    return function()
        for remote, original in pairs(hookedRemotes) do
            remote.FireServer = original
        end
    end
end

local function EnableLightDamage()
    if DamageActive then return end
    
    DamageActive = true
    DamageBtn.Text = "⚡ DAMAGE: ON"
    DamageBtn.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
    StatusLabel.Text = "🟢 ACTIVE"
    StatusLabel.TextColor3 = Color3.fromRGB(60, 220, 60)
    LogoBtn.Text = "🟢"
    LogoBtn.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
    
    print("[LIGHT DAMAGE] Activating...")
    print("Damage: " .. BASE_DAMAGE .. " × " .. DAMAGE_MULTIPLIER .. "x")
    
    -- 1. Aktifkan packet modification
    local cleanupRemotes = LightPacketModification()
    
    -- 2. Light damage loop (tanpa FPS drop)
    ActiveConnections.DamageLoop = RunService.Heartbeat:Connect(function()
        if not DamageActive then return end
        
        -- Delay untuk cegah FPS drop
        wait(PACKET_DELAY)
        
        pcall(function()
            -- Kirim damage ke musuh terdekat saja (lebih efisien)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        -- Damage ringan tapi konsisten
                        local damageAmount = BASE_DAMAGE * DAMAGE_MULTIPLIER
                        
                        -- Kirim melalui remote yang ada
                        for _, remote in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                            if remote:IsA("RemoteEvent") then
                                pcall(function()
                                    remote:FireServer(player.Character, damageAmount)
                                end)
                                break -- Hanya 1 remote per frame
                            end
                        end
                        
                        break -- Hanya 1 musuh per frame
                    end
                end
            end
        end)
    end)
    
    -- 3. Simpan cleanup function
    ActiveConnections.CleanupRemotes = cleanupRemotes
    
    print("[LIGHT DAMAGE] ✅ Activated successfully")
    
    -- Notifikasi ringan
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DAMAGE ON",
        Text = "Light damage activated",
        Duration = 2
    })
end

local function DisableLightDamage()
    if not DamageActive then return end
    
    DamageActive = false
    DamageBtn.Text = "⚡ DAMAGE: OFF"
    DamageBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    StatusLabel.Text = "🟢 READY"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    LogoBtn.Text = "🔴"
    LogoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    
    print("[LIGHT DAMAGE] Disabling...")
    
    -- Matikan semua connections
    for _, connection in pairs(ActiveConnections) do
        if type(connection) == "function" then
            connection() -- Jalankan cleanup function
        elseif typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    ActiveConnections = {}
    
    print("[LIGHT DAMAGE] ✅ Disabled")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DAMAGE OFF",
        Text = "Light damage disabled",
        Duration = 2
    })
end

-- ============================================
-- UI CONTROLS
-- ============================================
local UIVisible = false

-- Toggle UI dengan logo
LogoBtn.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainPanel.Visible = UIVisible
    
    if UIVisible then
        LogoBtn.Text = "▼"
    else
        LogoBtn.Text = DamageActive and "🟢" or "🔴"
    end
    
    -- Animasi kecil
    LogoBtn.Size = UDim2.new(0, 45, 0, 45)
    wait(0.05)
    LogoBtn.Size = UDim2.new(0, 50, 0, 50)
end)

-- Toggle Damage
DamageBtn.MouseButton1Click:Connect(function()
    if DamageActive then
        DisableLightDamage()
    else
        EnableLightDamage()
    end
    
    -- Animasi tombol
    DamageBtn.Size = UDim2.new(0.82, 0, 0, 48)
    wait(0.06)
    DamageBtn.Size = UDim2.new(0.85, 0, 0, 50)
end)

-- Close UI jika klik di luar
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if UIVisible and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local panelPos = MainPanel.AbsolutePosition
        local panelSize = MainPanel.AbsoluteSize
        
        -- Cek jika klik di luar panel
        if mousePos.X < panelPos.X or mousePos.X > panelPos.X + panelSize.X or
           mousePos.Y < panelPos.Y or mousePos.Y > panelPos.Y + panelSize.Y then
            UIVisible = false
            MainPanel.Visible = false
            LogoBtn.Text = DamageActive and "🟢" or "🔴"
        end
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================
print("========================================")
print("LIGHT DAMAGE HACK LOADED")
print("By: Mikaa")
print("========================================")
print("Damage Settings:")
print("  Base Damage: " .. BASE_DAMAGE)
print("  Multiplier: " .. DAMAGE_MULTIPLIER .. "x")
print("  Total Damage: " .. (BASE_DAMAGE * DAMAGE_MULTIPLIER))
print("  Packet Delay: " .. PACKET_DELAY .. "s")
print("========================================")
print("Click 🔴 logo to open menu")
print("Light & efficient - No FPS drop")
print("========================================")

-- Notifikasi awal
wait(1)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "READY",
    Text = "Light Damage Hack Loaded",
    Duration = 2
})
