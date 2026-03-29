--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui")
gui.Name = "KeyzerSystem"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- CADRE PRINCIPAL (BLEU ROYAL)
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Parent = gui
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5, -180, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(0, 80, 200) -- 🔵 VRAI BLEU
main.BorderSizePixel = 0
main.ClipsDescendants = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 15)

-- BARRE DE TITRE
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- BOUTON FERMER (ROUGE)
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.Text = "❌"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 ROUGE VIF
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn)

-- ZONE DE SAISIE (INSERT YOUR KEY HERE)
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0, 280, 0, 50)
keyBox.Position = UDim2.new(0.5, -140, 0.4, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(0, 50, 130) -- Bleu plus foncé pour le contraste
keyBox.BorderSizePixel = 0
keyBox.Text = "" -- Vide par défaut
keyBox.PlaceholderText = "Insert your key here..." -- Texte en anglais
keyBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.Font = Enum.Font.GothamMedium
keyBox.TextSize = 16
Instance.new("UICorner", keyBox)

-- BOUTON VALIDER (ROUGE)
local validateBtn = Instance.new("TextButton", main)
validateBtn.Size = UDim2.new(0, 220, 0, 45)
validateBtn.Position = UDim2.new(0.5, -110, 0.72, 0)
validateBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 ROUGE VIF
validateBtn.Text = "Validate"
validateBtn.TextColor3 = Color3.new(1, 1, 1)
validateBtn.Font = Enum.Font.GothamBold
validateBtn.TextSize = 18
Instance.new("UICorner", validateBtn)

--// LOGIQUE DE FERMETURE
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--// LOGIQUE DE DRAG (Pour bouger le menu)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

--// ANIMATION SUR LE BOUTON VALIDER
validateBtn.MouseEnter:Connect(function()
    TweenService:Create(validateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
end)

validateBtn.MouseLeave:Connect(function()
    TweenService:Create(validateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
end)

--// MESSAGE DE TEST LORS DU CLIC
validateBtn.MouseButton1Click:Connect(function()
    if #keyBox.Text > 5 then
        validateBtn.Text = "Checking..."
        wait(1)
        validateBtn.Text = "Success !"
        validateBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        validateBtn.Text = "Invalid Key"
        wait(1)
        validateBtn.Text = "Validate"
    end
end)
