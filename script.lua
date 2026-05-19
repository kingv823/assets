-- [[ KEYZER AUTO FARM - MOBILE & EMULATOR SAFE EDITION V6 ]] --

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Nettoyage anti-doublon pour éviter la superposition des menus
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

local TitleText = Instance.new("TextLabel")
local FarmButton = Instance.new("TextButton")
local UICorner_Farm = Instance.new("UICorner")
local StatusText = Instance.new("TextLabel")

-- Configuration globale
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

-- Barre supérieure Mac
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

-- Bouton Rouge (Fermer)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Text = "" -- Forcé à vide pour éviter "Label"
UICorner_Close.CornerRadius = UDim.new(1, 0)
UICorner_Close.Parent = CloseBtn

-- Bouton Jaune (Réduire)
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(254, 188, 46)
MinimizeBtn.Position = UDim2.new(0, 32, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 13, 0, 13)
MinimizeBtn.Text = "" -- Forcé à vide pour éviter "Label"
UICorner_Min.CornerRadius = UDim.new(1, 0)
UICorner_Min.Parent = MinimizeBtn

-- Bouton Vert (Agrandir)
MaximizeBtn.Name = "MaximizeBtn"
MaximizeBtn.Parent = TitleBar
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 64)
MaximizeBtn.Position = UDim2.new(0, 52, 0, 8)
MaximizeBtn.Size = UDim2.new(0, 13, 0, 13)
MaximizeBtn.Text = "" -- Forcé à vide pour éviter "Label"
UICorner_Max.CornerRadius = UDim.new(1, 0)
UICorner_Max.Parent = MaximizeBtn

-- Titre de la fenêtre
TitleText.Name = "TitleText"
TitleText.Parent = MainFrame
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.Size = UDim2.new(1, 0, 0, 30)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "Keyzer Auto Farm" -- Configuration immédiate du texte
TitleText.TextColor3 = Color3.fromRGB(60, 60, 60)
TitleText.TextSize = 15
TitleText.ZIndex = 10

-- Bouton d'action principal
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
FarmButton.Position = UDim2.new(0.5, -85, 0, 70)
FarmButton.Size = UDim2.new(0, 170, 0, 45)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.Text = "Start Auto Farm" -- Configuration immédiate du texte
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16
FarmButton.ZIndex = 10

UICorner_Farm.CornerRadius = UDim.new(0, 8)
UICorner_Farm.Parent = FarmButton

-- Texte indicateur de statut
StatusText.Name = "StatusText"
StatusText.Parent = MainFrame
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 0, 0, 140)
StatusText.Size = UDim2.new(1, 0, 0, 25)
StatusText.Font = Enum.Font.SourceSansMedium
StatusText.Text = "Status: Idle (Ready)" -- Configuration immédiate du texte
StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusText.TextSize = 14
StatusText.ZIndex = 10


-- [[ COMPOSANT AUTO FARM ANTI-CHEAT ]] --

local mapNames = {
    "Bank", "Bank 2", "Bio Lab", "Factory", "Hospital 3", "Hotel 2", "House 2", "Mansion 2", "Mil Base", "Office 3", "Police Station", "Research Facility", "Workplace",
    "Beach Resort", "Yacht", "Manor", "Farmhouse", "Mineshaft", "Barn (Infection)", "Vampire’s Castle", "Spaceship", "Workshop", "Log Cabin", "Train Station", "Ice Castle", "Ski Lodge", "Christmas In Italy", "Ski Village",
    "Hospital", "Hospital 2", "Hotel", "House", "Lab 2", "Mansion", "Mil-Base (Original)", "nStudio", "Office 2", "Pond", "Beach House", "Cargo", "Casino", "Castle Cove", "Coliseum", "DodgeballArena", "Mall", "Night Club", "Zoo", "Dungeon",
    "Abandoned Mine", "Bloxburg", "Chaos Canyon", "Crossroads", "Glass Houses", "Haunted House", "Hospital (MM1)", "Hotel (MM1)", "Italy", "Neighborhood", "Office", "Ship", "Terraria", "The Lab"
}

local farming = false
local safeSpeed = 22 -- Vitesse optimisée supérieure à la normale mais indétectable

local function getCurrentMap()
    for _, name in pairs(mapNames) do
        local map = Workspace:FindFirstChild(name)
        if map then return map end
    end
    return Workspace:FindFirstChild("Map") 
end

local function walkToPart(targetPart)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and hrp and targetPart and targetPart:IsA("BasePart") then
        humanoid.WalkSpeed = safeSpeed
        humanoid:MoveTo(targetPart.Position)
        
        -- Interruption si la pièce met plus de 3 secondes à être atteinte (blocage contre un mur)
        local startTime = os.time()
        while farming and targetPart.Parent and (hrp.Position - targetPart.Position).Magnitude > 3 do
            if (os.time() - startTime) > 3 then 
                break 
            end
            task.wait(0.1)
        end
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
                        local targetCoin = coins[1]
                        if targetCoin and targetCoin:IsA("BasePart") then
                            StatusText.Text = "Status: Defending coins (Safe Mode)..."
                            walkToPart(targetCoin)
                        else
                            StatusText.Text = "Status: Searching validation..."
                        end
                    else
                        StatusText.Text = "Status: Waiting for next round coins..."
                    end
                else
                    StatusText.Text = "Status: Target area missing."
                end
            else
                StatusText.Text = "Status: Map layout missing."
            end
            task.wait(0.2)
        end
    end)
end


-- [[ GESTION DE L'INTERFACE DES BOUTONS MAC ]] --

local isMinimized = false
local isMaximized = false

-- Action bouton rouge : fermeture complète
CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    task.wait(0.05)
    local character = LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
    ScreenGui:Destroy()
end)

-- Action bouton jaune : réduire la fenêtre
MinimizeBtn.MouseButton1Click:Connect(function()
    if isMaximized then return end
    isMinimized = not isMinimized
    
    FarmButton.Visible = not isMinimized
    StatusText.Visible = not isMinimized
    
    local targetSize = isMinimized and minimizedSize or normalSize
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

-- Action bouton vert : mode agrandi
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

-- Gestion de l'état ON/OFF du bouton principal
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmButton.Text = "Stop Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
        StatusText.Text = "Status: Auto Farm Active (Safe)"
        StatusText.TextColor3 = Color3.fromRGB(40, 200, 64)
        doAutoFarm()
    else
        FarmButton.Text = "Start Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        StatusText.Text = "Status: Idle"
        StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)
