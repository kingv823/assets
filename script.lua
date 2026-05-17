-- [[ MAC-STYLE AUTO FARM GUI V2 ]] --

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

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
local TitleText = Instance.new("TextLabel")
local ContentFrame = Instance.new("Frame")
local FarmButton = Instance.new("TextButton")
local UICorner_Farm = Instance.new("UICorner")
local StatusText = Instance.new("TextLabel")

-- Configuration du ScreenGui
ScreenGui.Name = "MacOsFarmGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Fenêtre Principale (Taille de base)
local normalSize = UDim2.new(0, 350, 0, 200)
local minimizedSize = UDim2.new(0, 350, 0, 30)
local maximizedSize = UDim2.new(0, 600, 0, 400)

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.Size = normalSize
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

-- Barre de titre (Top Bar Mac)
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

-- --- LES BOUTONS MAC SYSTEME ---

-- Rouge : Fermer
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = ""
CloseBtn.TextColor3 = Color3.fromRGB(70, 0, 0)
CloseBtn.TextSize = 11
UICorner_Close.CornerRadius = UDim.new(1, 0)
UICorner_Close.Parent = CloseBtn

-- Jaune : Réduire
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(254, 188, 46)
MinimizeBtn.Position = UDim2.new(0, 32, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 13, 0, 13)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = ""
MinimizeBtn.TextColor3 = Color3.fromRGB(100, 60, 0)
MinimizeBtn.TextSize = 11
UICorner_Min.CornerRadius = UDim.new(1, 0)
UICorner_Min.Parent = MinimizeBtn

-- Vert : Agrandir (Plein écran)
MaximizeBtn.Name = "MaximizeBtn"
MaximizeBtn.Parent = TitleBar
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 64)
MaximizeBtn.Position = UDim2.new(0, 52, 0, 8)
MaximizeBtn.Size = UDim2.new(0, 13, 0, 13)
MaximizeBtn.Font = Enum.Font.SourceSansBold
MaximizeBtn.Text = ""
MaximizeBtn.TextColor3 = Color3.fromRGB(0, 70, 0)
MaximizeBtn.TextSize = 9
UICorner_Max.CornerRadius = UDim.new(1, 0)
UICorner_Max.Parent = MaximizeBtn

-- Effet de survol (Hover) style Mac : affiche les symboles quand la souris approche
TitleBar.MouseEnter:Connect(function()
    CloseBtn.Text = "✕"
    MinimizeBtn.Text = "─"
    MaximizeBtn.Text = "⤢"
end)

TitleBar.MouseLeave:Connect(function()
    CloseBtn.Text = ""
    MinimizeBtn.Text = ""
    MaximizeBtn.Text = ""
end)

-- Titre text
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Font = Enum.Font.SourceSansMedium
TitleText.Text = "MM2 Auto Farm - macOS"
TitleText.TextColor3 = Color3.fromRGB(70, 70, 70)
TitleText.TextSize = 14

-- Contenu intérieur
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)

-- Bouton d'activation Farm
FarmButton.Name = "FarmButton"
FarmButton.Parent = ContentFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
FarmButton.Position = UDim2.new(0.5, -75, 0.4, -20)
FarmButton.Size = UDim2.new(0, 150, 0, 40)
FarmButton.Font = Enum.Font.SourceSansSemibold
FarmButton.Text = "Start Auto Farm"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16
UICorner_Farm.CornerRadius = UDim.new(0, 6)
UICorner_Farm.Parent = FarmButton

-- Statut text
StatusText.Name = "StatusText"
StatusText.Parent = ContentFrame
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 0, 0.7, 0)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Font = Enum.Font.SourceSans
StatusText.Text = "Status: Idle"
StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
StatusText.TextSize = 14


-- [[ LOGIQUE DES BOUTONS SYSTEME APPLE ]] --

local isMinimized = false
local isMaximized = false

-- BOUTON ROUGE : Fermer proprement
CloseBtn.MouseButton1Click:Connect(function()
    farming = false -- Coupe le farm si actif
    ScreenGui:Destroy() -- Supprime le menu de l'écran
end)

-- BOUTON JAUNE : Réduire / Restaurer
MinimizeBtn.MouseButton1Click:Connect(function()
    if isMaximized then return end -- Désactivé si on est déjà en plein écran
    
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    
    local targetSize = isMinimized and minimizedSize or normalSize
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

-- BOUTON VERT : Plein écran / Taille normale
MaximizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end -- Désactivé si la fenêtre est réduite
    
    isMaximized = not isMaximized
    local targetSize = isMaximized and maximizedSize or normalSize
    local targetPos = isMaximized and UDim2.new(0.5, -300, 0.5, -200) or UDim2.new(0.5, -175, 0.5, -100)
    
    -- Animation fluide d'agrandissement
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
    
    -- Centre le bouton de farm par rapport à la nouvelle taille
    if isMaximized then
        FarmButton.Position = UDim2.new(0.5, -100, 0.4, -25)
        FarmButton.Size = UDim2.new(0, 200, 0, 50)
    else
        FarmButton.Position = UDim2.new(0.5, -75, 0.4, -20)
        FarmButton.Size = UDim2.new(0, 150, 0, 40)
    end
end)


-- [[ SCRIPT AUTOMATIQUE DE FARM ]] --

local mapNames = {
    "Bank", "Bank 2", "Bio Lab", "Factory", "Hospital 3", "Hotel 2", "House 2", "Mansion 2", "Mil Base", "Office 3", "Police Station", "Research Facility", "Workplace",
    "Beach Resort", "Yacht", "Manor", "Farmhouse", "Mineshaft", "Barn (Infection)", "Vampire’s Castle", "Spaceship", "Workshop", "Log Cabin", "Train Station", "Ice Castle", "Ski Lodge", "Christmas In Italy", "Ski Village",
    "Hospital", "Hospital 2", "Hotel", "House", "Lab 2", "Mansion", "Mil-Base (Original)", "nStudio", "Office 2", "Pond", "Beach House", "Cargo", "Casino", "Castle Cove", "Coliseum", "DodgeballArena", "Mall", "Night Club", "Zoo", "Dungeon",
    "Abandoned Mine", "Bloxburg", "Chaos Canyon", "Crossroads", "Glass Houses", "Haunted House", "Hospital (MM1)", "Hotel (MM1)", "Italy", "Neighborhood", "Office", "Ship", "Terraria", "The Lab"
}

farming = false
local speed = 25 

local function getCurrentMap()
    for _, name in pairs(mapNames) do
        local map = Workspace:FindFirstChild(name)
        if map then return map end
    end
    return Workspace:FindFirstChild("Map") 
end

local function slideTo(targetPart)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local distance = (hrp.Position - targetPart.Position).Magnitude
        local duration = distance / speed
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetPart.CFrame})
        
        tween:Play()
        tween.Completed:Wait()
    end
end

local function doAutoFarm()
    task.spawn(function()
        while farming do
            local currentMap = getCurrentMap()
            if currentMap then
                local coinContainer = currentMap:FindFirstChild("CoinContainer")
                if coinContainer then
                    local coins = coinContainer:GetChildren()
                    if #coins > 0 then
                        local targetCoin = coins[19] or coins[1]
                        if targetCoin and targetCoin:IsA("BasePart") then
                            StatusText.Text = "Status: Sliding to coin..."
                            slideTo(targetCoin)
                            task.wait(0.2)
                        else
                            StatusText.Text = "Status: Waiting for coin..."
                        end
                    else
                        StatusText.Text = "Status: No coins found."
                    end
                else
                    StatusText.Text = "Status: CoinContainer not found."
                end
            else
                StatusText.Text = "Status: Map not detected."
            end
            task.wait(0.5)
        end
    end)
end

-- Bouton de farm ON/OFF
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmButton.Text = "Stop Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48) -- Rouge Apple
        StatusText.Text = "Status: Auto Farm Active"
        StatusText.TextColor3 = Color3.fromRGB(40, 200, 64)
        doAutoFarm()
    else
        FarmButton.Text = "Start Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255) -- Bleu Apple
        StatusText.Text = "Status: Idle"
        StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end)
