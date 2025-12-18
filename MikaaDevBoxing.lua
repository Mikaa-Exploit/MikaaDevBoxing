-- ============================================
-- BY MIKAA 
-- CEK CODE? SILAHKAN :)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Hapus UI lama
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name:find("Hack") or gui.Name:find("Damage") then
        gui:Destroy()
    end
end

-- ============================================
-- UI SETUP
-- ============================================
local DamageUI = Instance.new("ScreenGui")
DamageUI.Name = "SimpleDamageHack"
DamageUI.Parent = CoreGui

-- Logo Toggle Kecil
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Size = UDim2.new(0, 60, 0, 60)
ToggleLogo.Position = UDim2.new(0, 20, 0, 20)
ToggleLogo.Text = "💀"
ToggleLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleLogo.Font = Enum.Font.GothamBlack
ToggleLogo.TextSize = 30
ToggleLogo.ZIndex = 100
ToggleLogo.Parent = DamageUI

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

-- Main Panel
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 220, 0, 150)
MainPanel.Position = UDim2.new(0, 20, 0, 90)
MainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = DamageUI

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = MainPanel

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "DAMAGE HACK BETA @byMikaa"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainPanel

-- Tombol ON/OFF
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0, 50)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.Parent = MainPanel

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 110)
StatusLabel.Text = "READY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = MainPanel

-- ============================================
-- VARIABEL YANG BISA DIUBAH (EDIT DISINI)
-- ============================================
-- ============ EDIT NILAI DI BAWAH INI ============
local DAMAGE_MULTIPLIER = 200     -- Ubah angka ini untuk perkalian damage (contoh: 1000 = 1000x damage)
local DAMAGE_VALUE = 100          -- Ubah angka ini untuk damage tetap (contoh: 9999 = langsung kill)
local AUTO_ATTACK = false          -- true/false untuk auto attack musuh
-- =============================================

-- ============================================
-- DAMAGE HACK SYSTEM
-- ============================================
local DamageActive = false
local DamageConnection = nil
local HookedRemotes = {}

local function ShowNotif(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DAMAGE HACK",
        Text = message,
        Duration = 2
    })
end

local function EnableDamageHack()
    if DamageActive then return end
    
    DamageActive = true
    ToggleBtn.Text = "ON"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
    StatusLabel.Text = "ACTIVE ⚡"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    ShowNotif("Damage " .. DAMAGE_VALUE .. " Activated!")
    print("[DAMAGE] Activating hack with multiplier: " .. DAMAGE_MULTIPLIER .. "x")
    
    -- METHOD 1: HOOK REMOTE EVENTS
    print("[DAMAGE] Finding damage remotes...")
    
    local foundRemotes = {}
    
    -- Cari di ReplicatedStorage
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("attack") or 
               name:find("punch") or name:find("strike") then
                table.insert(foundRemotes, remote)
                print("[DAMAGE] Found: " .. remote.Name)
            end
        end
    end
    
    -- Cari di Workspace juga
    for _, remote in pairs(workspace:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("damage") or name:find("hit") then
                table.insert(foundRemotes, remote)
                print("[DAMAGE] Found: " .. remote.Name)
            end
        end
    end
    
    -- Hook remotes yang ditemukan
    for _, remote in pairs(foundRemotes) do
        if not HookedRemotes[remote] then
            local oldFire = remote.FireServer
            HookedRemotes[remote] = oldFire
            
            remote.FireServer = function(self, ...)
                local args = {...}
                local modified = false
                
                -- Ubah semua angka yang mungkin damage
                for i, arg in pairs(args) do
                    if type(arg) == "number" then
                        if arg > 0 and arg < 10000 then
                            -- APPLY DAMAGE MULTIPLIER DISINI
                            args[i] = arg * DAMAGE_MULTIPLIER
                            modified = true
                            print("[HOOK] Changed damage: " .. arg .. " -> " .. args[i])
                        end
                    elseif type(arg) == "table" then
                        -- Cari angka dalam table
                        for k, v in pairs(arg) do
                            if type(v) == "number" and v > 0 and v < 10000 then
                                arg[k] = v * DAMAGE_MULTIPLIER
                                modified = true
                            end
                        end
                    end
                end
                
                -- Jika tidak ada angka, tambahkan damage value
                if not modified then
                    table.insert(args, DAMAGE_VALUE)
                    print("[HOOK] Added damage: " .. DAMAGE_VALUE)
                end
                
                return oldFire(self, unpack(args))
            end
            
            print("[DAMAGE] Successfully hooked: " .. remote.Name)
        end
    end
    
    -- METHOD 2: DIRECT DAMAGE LOOP
    DamageConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            -- Kirim damage ke semua musuh
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        
                        -- Auto attack jika dienable
                        if AUTO_ATTACK then
                            humanoid:TakeDamage(DAMAGE_VALUE)
                        end
                        
                        -- Kirim damage melalui remotes
                        for remote, _ in pairs(HookedRemotes) do
                            pcall(function()
                                remote:FireServer(player.Character, DAMAGE_VALUE)
                                remote:FireServer("Damage", DAMAGE_VALUE)
                                remote:FireServer(player.Character, "Head", DAMAGE_VALUE)
                            end)
                        end
                    end
                end
            end
        end)
    end)
    
    print("[DAMAGE] ✅ Hack activated successfully!")
end

local function DisableDamageHack()
    if not DamageActive then return end
    
    DamageActive = false
    ToggleBtn.Text = "OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StatusLabel.Text = "READY"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    
    ShowNotif("Damage hack disabled")
    print("[DAMAGE] Disabling hack...")
    
    -- Stop connection
    if DamageConnection then
        DamageConnection:Disconnect()
        DamageConnection = nil
    end
    
    -- Restore original remote functions
    for remote, oldFire in pairs(HookedRemotes) do
        remote.FireServer = oldFire
    end
    HookedRemotes = {}
    
    print("[DAMAGE] ❌ Hack disabled")
end

-- ============================================
-- UI CONTROLS
-- ============================================
local UIVisible = false

-- Toggle UI dengan logo
ToggleLogo.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainPanel.Visible = UIVisible
    
    if UIVisible then
        ToggleLogo.Text = "▲"
        ToggleLogo.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
    else
        ToggleLogo.Text = "💀"
        ToggleLogo.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end)

-- Toggle Damage Hack
ToggleBtn.MouseButton1Click:Connect(function()
    if DamageActive then
        DisableDamageHack()
    else
        EnableDamageHack()
    end
    
    -- Animasi tombol
    ToggleBtn.Size = UDim2.new(0.75, 0, 0, 45)
    wait(0.08)
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
end)

-- ============================================
-- INISIALISASI
-- ============================================
print("========================================")
print("SIMPLE DAMAGE HACK LOADED")
print("========================================")
print("Damage Multiplier: " .. DAMAGE_MULTIPLIER .. "x")
print("Damage Value: " .. DAMAGE_VALUE)
print("Auto Attack: " .. tostring(AUTO_ATTACK))
print("========================================")
print("Click 💀 logo to open menu")
print("Click ON/OFF button to toggle")
print("Check console (F9) for logs")
print("========================================")

ShowNotif("Damage Hack Ready!")
