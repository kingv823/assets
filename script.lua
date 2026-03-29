--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local ADMIN_NAME = "Nerx0ox"
local MM2_PLACE_ID = 142823291

-- ❌ CHECK MM2 PLACE ID
if game.PlaceId ~= MM2_PLACE_ID then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Keyzer 💯",
        Text = "Are you lost...?",
        Duration = 5
    })
    return
end

--// KEY SYSTEM
local usedKeys = {}
local function isValidKey(key, isVIP)
    if isVIP then
        if not key:match("^Keyzervip_") then return false end
    else
        if not key:match("^Keyzer_") then return false end
    end
    if #key ~= 18 then return false end
    local u,l,d = 0,0,0
    for c in key:gmatch(".") do
        if c:match("%u") then u+=1
        elseif c:match("%l") then l+=1
        elseif c:match("%d") then d+=1 end
    end
    return u>=3 and l>=5 and d>=2
end

--// MAIN GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5, -180, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(2, 4, 15) -- 🔵 FOND BLEU TRÈS FONCÉ
main.BorderSizePixel = 0

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- TOPBAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- BOUTON FERMER (ROUGE AVEC ❌)
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "❌"
close.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- 🔴 ROUGE
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.Gotham
Instance.new("UICorner", close)

-- ZONE DE TEXTE (INSERER KEY ICI...)
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0, 280, 0, 45)
keyBox.Position = UDim2.new(0.5, -140, 0.4, 0)
keyBox.PlaceholderText = "Insert your key here..." -- 📝 TEXTE MODIFIÉ
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.Font = Enum.Font.Gotham
Instance.new("UICorner", keyBox)

-- BOUTON VALIDER (ROUGE)
local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0, 220, 0, 45)
keyBtn.Position = UDim2.new(0.5, -110, 0.7, 0)
keyBtn.Text = "Validate"
keyBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- 🔴 ROUGE
keyBtn.TextColor3 = Color3.new(1, 1, 1)
keyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", keyBtn)

-- STATUS
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.9, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 50, 50)
status.Text = ""
status.Font = Enum.Font.Gotham

--// WELCOME SCREEN (MODIFIÉ)
local welcome = main:Clone()
welcome.Parent = gui
welcome.Visible = false
welcome:ClearAllChildren() -- Nettoyage pour refaire le design propre

Instance.new("UICorner", welcome)
local wTitle = title:Clone()
wTitle.Parent = welcome
wTitle.Text = "Access Granted"

local avatar = Instance.new("ImageLabel", welcome)
avatar.Size = UDim2.new(0, 80, 0, 80)
avatar.Position = UDim2.new(0.5, -40, 0.2, 0)
avatar.BackgroundTransparency = 1
local avCorner = Instance.new("UICorner", avatar)
avCorner.CornerRadius = UDim.new(1, 0) -- Avatar rond

local nameLabel = Instance.new("TextLabel", welcome)
nameLabel.Size = UDim2.new(1, 0, 0, 40)
nameLabel.Position = UDim2.new(0, 0, 0.6, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16

local cont = Instance.new("TextButton", welcome)
cont.Size = UDim2.new(0, 180, 0, 40)
cont.Position = UDim2.new(0.5, -90, 0.8, 0)
cont.Text = "Continue"
cont.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- 🔴 ROUGE
cont.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", cont)

--// LOGIQUE DE VALIDATION
keyBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    local vip = key:match("^Keyzervip_")

    if not isValidKey(key, vip) then
        status.Text = "Invalid key, try again."
        return
    end

    avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    nameLabel.Text = vip and ("Welcome, "..LocalPlayer.Name.." (VIP)") or ("Welcome, "..LocalPlayer.Name)
    
    main.Visible = false
    welcome.Visible = true
end)

cont.MouseButton1Click:Connect(function()
    welcome.Visible = false
    main.Visible = true -- Rappel du GUI principal pour l'interface finale
    -- Ici, tu masquerais la partie clé pour afficher tes fonctions de cheat
    keyBox.Visible = false
    keyBtn.Visible = false
    status.Text = "Cheat Activated"
    status.TextColor3 = Color3.new(0, 1, 0)
end)

--// DRAGGING SYSTEM
local dragging, dragStart, startPos
top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        welcome.Position = main.Position
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- CLOSE ACTION
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
