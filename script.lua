-- [[ KEYZER AUTO FARM - THE REAL FIX V9 ]] --

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Nettoyage des anciennes interfaces
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyzerFarmGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -100)
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

-- Barre supérieure
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local UICorner_Title = Instance.new("UICorner")
UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

-- Boutons Mac Système
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Text = ""

local UICorner_Close = Instance.new("UICorner")
UICorner_Close.CornerRadius = UDim.new(1, 0)
UICorner_Close.Parent = CloseBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(254, 188, 46)
MinimizeBtn.Position = UDim2.new(0, 32, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 13, 0, 13)
MinimizeBtn.Text = ""

local UICorner_Min = Instance.new("UICorner")
UICorner_Min.CornerRadius = UDim.new(1, 0)
UICorner_Min.Parent = MinimizeBtn

local MaximizeBtn = Instance.new("TextButton")
MaximizeBtn.Name = "MaximizeBtn"
MaximizeBtn.Parent = TitleBar
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 64)
MaximizeBtn.Position = UDim2.new(0, 52, 0, 8)
MaximizeBtn.Size = UDim2.new(0, 13, 0, 13)
MaximizeBtn.Text = ""

local UICorner_Max = Instance.new("UICorner")
UICorner_Max.CornerRadius = UDim.new(1, 0)
UICorner_Max.Parent = MaximizeBtn

-- Application des Textes AVEC Parent défini en premier (Bloque le bug du "Label")
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = MainFrame
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.Size = UDim2.new(1, 0, 0, 30)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextColor3 = Color3.fromRGB(60, 60, 60)
TitleText.TextSize = 15
TitleText.ZIndex = 10
TitleText.Text = "Keyzer Auto Farm"

local FarmButton = Instance.new("TextButton")
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
FarmButton.Position = UDim2.new(0.5, -85, 0, 70)
FarmButton.Size = UDim2.new(0, 170, 0, 45)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16
FarmButton.ZIndex = 10
FarmButton.Text = "Start Auto Farm"

local UICorner_Farm = Instance.new("UICorner")
UICorner_Farm.CornerRadius = UDim.new(0, 8)
UICorner_Farm.Parent = FarmButton

local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Parent = MainFrame
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 0, 0, 140)
StatusText.Size = UDim2.new(1, 0, 0, 25)
StatusText.Font = Enum.Font.SourceSansMedium
StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusText.TextSize = 14
StatusText.ZIndex = 10
StatusText.Text = "Status: Idle (Ready)"


-- [[ SCRIPT DE GLISSADE REVISITÉ ]] --

local farming = false
local speed = 30

local function getCoinContainer()
    for _, desc in pairs(Workspace:GetDescendants()) do
        if desc.Name == "CoinContainer" then
            return desc
        end
    end
    return nil
end

-- Glissade par CFrame linéaire (Plus stable sur Android/Émulateur)
local function teleportToCoin(target)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp and target and target:IsA("BasePart") then
        while farming and target.Parent and (hrp.Position - target.Position).Magnitude > 2 do
            local dir = (target.Position - hrp.Position).Unit
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Stop la gravité pour éviter les kicks physiques
            hrp.CFrame = hrp.CFrame + (dir * (speed * task.wait()))
        end
    end
end

local function farmLoop()
    task.spawn(function()
        while farming do
            local container = getCoinContainer()
            if container then
                local coins = container:GetChildren()
                if #coins > 0 then
                    StatusText.Text = "Status: Collecting coins..."
                    -- Prend la première pièce dispo
                    local target = coins[1]
                    if target and target:IsA("BasePart") then
                        teleportToCoin(target)
                    end
                else
                    StatusText.Text = "Status: No coins found (Lobby?)"
                end
            else
                StatusText.Text = "Status: In Lobby - Waiting for Round"
            end
            task.wait(0.2)
        end
    end)
end


-- [[ LOGIQUE DES BOUTONS ]] --

local isMinimized = false
local isMaximized = false

CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    task.wait(0.05)
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if isMaximized then return end
    isMinimized = not isMinimized
    FarmButton.Visible = not isMinimized
    StatusText.Visible = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 350, 0, 30) or UDim2.new(0, 350, 0, 200)
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    isMaximized = not isMaximized
    local targetSize = isMaximized and UDim2.new(0, 550, 0, 350) or UDim2.new(0, 350, 0, 200)
    local targetPos = isMaximized and UDim2.new(0.5, -275, 0.4, -175) or UDim2.new(0.5, -175, 0.4, -100)
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = targetSize, Position = targetPos}):Play()
    
    if isMaximized then
        FarmButton.Position = UDim2.new(0.5, -90, 0, 130)
        StatusText.Position = UDim2.new(0, 0, 0, 260)
    else
        FarmButton.Position = UDim2.new(0.5, -85, 0, 70)
        StatusText.Position = UDim2.new(0, 0, 0, 140)
    end
end)

FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmButton.Text = "Stop Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
        StatusText.Text = "Status: Farm Active"
        StatusText.TextColor3 = Color3.fromRGB(40, 200, 64)
        farmLoop()
    else
        FarmButton.Text = "Start Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        StatusText.Text = "Status: Idle"
        StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)
