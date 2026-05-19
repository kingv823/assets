-- [[ KEYZER AUTO FARM - FINAL MOBILE FIX V8 ]] --

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Nettoyage de l'ancienne interface pour éviter les superpositions
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local TitleBar = Instance.new("Frame")
local UICorner_Title = Instance.new("UICorner")

local CloseBtn = Instance.new("TextButton")
local UICorner_Close = Instance.new("UICorner")
local MinimizeBtn = Instance.new("TextButton")
local UICorner_Min = Instance.new("UICorner")
local MaximizeBtn = Instance.new("TextButton")
local UICorner_Max = Instance.new("UICorner")

-- FIX LABEL : On applique le texte directement à la création de l'objet
local TitleText = Instance.new("TextLabel")
TitleText.Text = "Keyzer Auto Farm"

local FarmButton = Instance.new("TextButton")
FarmButton.Text = "Start Auto Farm"

local UICorner_Farm = Instance.new("UICorner")

local StatusText = Instance.new("TextLabel")
StatusText.Text = "Status: Waiting for game..." -- Plus de mot "Label" par défaut !

-- Configuration du ScreenGui
ScreenGui.Name = "KeyzerFarmGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local normalSize = UDim2.new(0, 350, 0, 200)
local minimizedSize = UDim2.new(0, 350, 0, 30)
local maximizedSize = UDim2.new(0, 550, 0, 350)

-- Fenêtre principale
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -100)
MainFrame.Size = normalSize
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false 

UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

-- Barre supérieure style Mac
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

-- Boutons Mac (Système d'origine)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Text = "" 
UICorner_Close.CornerRadius = UDim.new(1, 0)
UICorner_Close.Parent = CloseBtn

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(254, 188, 46)
MinimizeBtn.Position = UDim2.new(0, 32, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 13, 0, 13)
MinimizeBtn.Text = "" 
UICorner_Min.CornerRadius = UDim.new(1, 0)
UICorner_Min.Parent = MinimizeBtn

MaximizeBtn.Name = "MaximizeBtn"
MaximizeBtn.Parent = TitleBar
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 64)
MaximizeBtn.Position = UDim2.new(0, 52, 0, 8)
MaximizeBtn.Size = UDim2.new(0, 13, 0, 13)
MaximizeBtn.Text = "" 
UICorner_Max.CornerRadius = UDim.new(1, 0)
UICorner_Max.Parent = MaximizeBtn

-- Configuration du titre
TitleText.Name = "TitleText"
TitleText.Parent = MainFrame
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.Size = UDim2.new(1, 0, 0, 30)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextColor3 = Color3.fromRGB(60, 60, 60)
TitleText.TextSize = 15
TitleText.ZIndex = 10

-- Configuration du bouton principal
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
FarmButton.Position = UDim2.new(0.5, -85, 0, 70)
FarmButton.Size = UDim2.new(0, 170, 0, 45)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16
FarmButton.ZIndex = 10

UICorner_Farm.CornerRadius = UDim.new(0, 8)
UICorner_Farm.Parent = FarmButton

-- Configuration du texte de statut
StatusText.Name = "StatusText"
StatusText.Parent = MainFrame
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 0, 0, 140)
StatusText.Size = UDim2.new(1, 0, 0, 25)
StatusText.Font = Enum.Font.SourceSansMedium
StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusText.TextSize = 14
StatusText.ZIndex = 10


-- [[ CONTRÔLEUR DE L'AUTO FARM ]] --

local farming = false
local farmSpeed = 22 -- Vitesse parfaite pour bypass les vérifications d'anti-cheat

local function findCoinContainer()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "CoinContainer" then
            return obj
        end
    end
    return nil
end

local function slideToTarget(targetPart)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp and targetPart and targetPart:IsA("BasePart") then
        local distance = (hrp.Position - targetPart.Position).Magnitude
        local duration = distance / farmSpeed
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetPart.CFrame})
        
        tween:Play()
        
        local interrupted = false
        local connection
        connection = targetPart.AncestryChanged:Connect(function()
            if not targetPart:IsDescendantOf(Workspace) then
                interrupted = true
            end
        end)
        
        while farming and not interrupted and tween.PlaybackState == Enum.PlaybackState.Playing do
            task.wait(0.05)
        end
        
        tween:Cancel()
        if connection then connection:Disconnect() end
    end
end

local function startLoop()
    task.spawn(function()
        while farming do
            local container = findCoinContainer()
            if container then
                local coins = container:GetChildren()
                if #coins > 0 then
                    local character = LocalPlayer.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    
                    local closestCoin = nil
                    local shortDistance = math.huge
                    
                    if hrp then
                        for _, coin in pairs(coins) do
                            if coin:IsA("BasePart") then
                                local dist = (hrp.Position - coin.Position).Magnitude
                                if dist < shortDistance then
                                    shortDistance = dist
                                    closestCoin = coin
                                end
                            end
                        end
                    end
                    
                    local target = closestCoin or coins[1]
                    if target and target:IsA("BasePart") then
                        StatusText.Text = "Status: Collecting coins..."
                        slideToTarget(target)
                    end
                else
                    StatusText.Text = "Status: No coins found (Round end?)"
                end
            else
                StatusText.Text = "Status: In Lobby - Waiting for Map..."
            end
            task.wait(0.3)
        end
    end)
end


-- [[ ENCHENCHEMENT DES BOUTONS DE L'INTERFACE ]] --

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
    local targetSize = isMinimized and minimizedSize or normalSize
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    isMaximized = not isMaximized
    local targetSize = isMaximized and maximizedSize or normalSize
    local targetPos = isMaximized and UDim2.new(0.5, -275, 0.4, -175) or UDim2.new(0.5, -175, 0.4, -100)
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
    
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
        StatusText.Text = "Status: Active"
        StatusText.TextColor3 = Color3.fromRGB(40, 200, 64)
        startLoop()
    else
        FarmButton.Text = "Start Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        StatusText.Text = "Status: Idle"
        StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)
