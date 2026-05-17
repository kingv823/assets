-- [[ MAC-STYLE AUTO FARM GUI ]] --

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
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Fenêtre Principale (Style Épuré Mac)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240) -- Gris clair Apple
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- Permet de glisser la fenêtre

UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

-- Barre de titre (Top Bar)
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

-- Boutons Mac (Rouge, Jaune, Vert)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87) -- Rouge Mac
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Text = ""
UICorner_Close.CornerRadius = UDim.new(1, 0)
UICorner_Close.Parent = CloseBtn

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(254, 188, 46) -- Jaune Mac
MinimizeBtn.Position = UDim2.new(0, 32, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 13, 0, 13)
MinimizeBtn.Text = ""
UICorner_Min.CornerRadius = UDim.new(1, 0)
UICorner_Min.Parent = MinimizeBtn

MaximizeBtn.Name = "MaximizeBtn"
MaximizeBtn.Parent = TitleBar
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 64) -- Vert Mac
MaximizeBtn.Position = UDim2.new(0, 52, 0, 8)
MaximizeBtn.Size = UDim2.new(0, 13, 0, 13)
MaximizeBtn.Text = ""
UICorner_Max.CornerRadius = UDim.new(1, 0)
UICorner_Max.Parent = MaximizeBtn

-- Titre de la fenêtre
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Font = Enum.Font.SourceSansMedium
TitleText.Text = "Auto Farm - macOS Edition"
TitleText.TextColor3 = Color3.fromRGB(70, 70, 70)
TitleText.TextSize = 14

-- Contenu de la fenêtre
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)

-- Bouton de Farm (Style bouton système Apple)
FarmButton.Name = "FarmButton"
FarmButton.Parent = ContentFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255) -- Bleu Apple
FarmButton.Position = UDim2.new(0.5, -75, 0.4, -20)
FarmButton.Size = UDim2.new(0, 150, 0, 40)
FarmButton.Font = Enum.Font.SourceSansSemibold
FarmButton.Text = "Start Auto Farm"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16

UICorner_Farm.CornerRadius = UDim.new(0, 6)
UICorner_Farm.Parent = FarmButton

-- Statut
StatusText.Name = "StatusText"
StatusText.Parent = ContentFrame
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 0, 0.7, 0)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Font = Enum.Font.SourceSans
StatusText.Text = "Status: Idle"
StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
StatusText.TextSize = 14

-- [[ LOGIQUE DU SCRIPT ]] --

local farming = false

-- Fonction d'Auto Farm (À adapter selon ton jeu)
local function doAutoFarm()
    spawn(function()
        while farming do
            -- ICI : Ajoute le code spécifique au jeu pour le farm.
            -- Exemple générique : simulation de clic ou téléportation.
            print("Farming en cours...") 
            task.wait(1) -- Pause d'une seconde entre chaque action
        end
    end)
end

-- Interaction Bouton Start/Stop
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmButton.Text = "Stop Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48) -- Rouge Apple pour le Stop
        StatusText.Text = "Status: Farming..."
        StatusText.TextColor3 = Color3.fromRGB(40, 200, 64)
        doAutoFarm()
    else
        FarmButton.Text = "Start Auto Farm"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255) -- Retour au bleu
        StatusText.Text = "Status: Idle"
        StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

-- Fermer la fenêtre (Bouton Rouge)
CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    ScreenGui:Destroy()
end)

-- Réduire la fenêtre (Bouton Jaune)
MinimizeBtn.MouseButton1Click:Connect(function()
    ContentFrame.Visible = not ContentFrame.Visible
    if not ContentFrame.Visible then
        MainFrame.Size = UDim2.new(0, 350, 0, 30) -- Garde juste la barre supérieure
    else
        MainFrame.Size = UDim2.new(0, 350, 0, 200) -- Redonne la taille normale
    end
end)

-- Optionnel : Bouton Vert (Agrandir) change juste une couleur pour le style ici
MaximizeBtn.MouseButton1Click:Connect(function()
    print("Fonctionnalité plein écran non nécessaire pour ce mini GUI.")
end)
