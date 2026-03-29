--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--// CONFIG & KEY SYSTEM
local usedKeys = {}
local function isValidKey(key, isVIP)
    if isVIP then
        if not key:match("^Keyzervip_") then return false end
    else
        if not key:match("^Keyzer_") then return false end
    end
    -- Vérification de la longueur et complexité (18 caractères)
    if #key ~= 18 then return false end
    local u,l,d = 0,0,0
    for c in key:gmatch(".") do
        if c:match("%u") then u+=1
        elseif c:match("%l") then l+=1
        elseif c:match("%d") then d+=1 end
    end
    return u>=3 and l>=5 and d>=2
end

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KeyzerSystem"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5, -180, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(0, 80, 200) -- 🔵 BLEU ROYAL
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- TOPBAR
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

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.Text = "❌"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 ROUGE
closeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBtn)

-- CONTENEURS DE PAGES
local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -45)
loginPage.Position = UDim2.new(0, 0, 0, 45)
loginPage.BackgroundTransparency = 1

local welcomePage = loginPage:Clone()
welcomePage.Parent = main
welcomePage.Visible = false

local farmPage = loginPage:Clone()
farmPage.Parent = main
farmPage.Visible = false

-- --- ÉLÉMENTS PAGE LOGIN ---
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 280, 0, 50)
keyBox.Position = UDim2.new(0.5, -140, 0.2, 0)
keyBox.PlaceholderText = "Insert your key here..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(0, 60, 160)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.Font = Enum.Font.GothamMedium
Instance.new("UICorner", keyBox)

local validateBtn = Instance.new("TextButton", loginPage)
validateBtn.Size = UDim2.new(0, 220, 0, 45)
validateBtn.Position = UDim2.new(0.5, -110, 0.6, 0)
validateBtn.Text = "Validate"
validateBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 ROUGE
validateBtn.TextColor3 = Color3.new(1, 1, 1)
validateBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", validateBtn)

-- --- ÉLÉMENTS PAGE WELCOME ---
local avatarImg = Instance.new("ImageLabel", welcomePage)
avatarImg.Size = UDim2.new(0, 70, 0, 70)
avatarImg.Position = UDim2.new(0.5, -35, 0.1, 0)
avatarImg.BackgroundTransparency = 1
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

local userLabel = Instance.new("TextLabel", welcomePage)
userLabel.Size = UDim2.new(1, 0, 0, 30)
userLabel.Position = UDim2.new(0, 0, 0.5, 0)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.new(1, 1, 1)
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 16

local continueBtn = Instance.new("TextButton", welcomePage)
continueBtn.Size = UDim2.new(0, 180, 0, 40)
continueBtn.Position = UDim2.new(0.5, -90, 0.75, 0)
continueBtn.Text = "Continue"
continueBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 ROUGE
continueBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", continueBtn)

-- --- ÉLÉMENTS PAGE FARM ---
local startFarmBtn = Instance.new("TextButton", farmPage)
startFarmBtn.Size = UDim2.new(0, 250, 0, 60)
startFarmBtn.Position = UDim2.new(0.5, -125, 0.3, 0)
startFarmBtn.Text = "Start Auto Farm"
startFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 ROUGE
startFarmBtn.TextColor3 = Color3.new(1, 1, 1)
startFarmBtn.Font = Enum.Font.GothamBold
startFarmBtn.TextSize = 22
Instance.new("UICorner", startFarmBtn)

--// LOGIQUE DE VALIDATION
validateBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    local isVIP = key:match("^Keyzervip_")

    if isValidKey(key, isVIP) then
        -- Setup Welcome Screen
        avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        
        if isVIP then
            userLabel.Text = "Welcome, " .. LocalPlayer.Name .. " [VIP]"
            userLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Doré pour VIP
        else
            userLabel.Text = "Welcome, " .. LocalPlayer.Name
            userLabel.TextColor3 = Color3.new(1, 1, 1)
        end
        
        loginPage.Visible = false
        welcomePage.Visible = true
    else
        validateBtn.Text = "Invalid Key !"
        wait(1)
        validateBtn.Text = "Validate"
    end
end)

continueBtn.MouseButton1Click:Connect(function()
    welcomePage.Visible = false
    farmPage.Visible = true
end)

startFarmBtn.MouseButton1Click:Connect(function()
    startFarmBtn.Text = "Farm Running..."
    startFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Vert quand actif
end)

--// DRAG & CLOSE
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = i.Position startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
