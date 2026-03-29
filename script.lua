--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
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

local function isValidKey(key)
    if not (key:match("^Keyzer_key") or key:match("^Keyzervip_key")) then
        return false
    end

    if #key ~= 18 then return false end

    local u,l,d = 0,0,0
    for c in key:gmatch(".") do
        if c:match("%u") then u+=1
        elseif c:match("%l") then l+=1
        elseif c:match("%d") then d+=1 end
    end

    return u>=3 and l>=3 and d>=2
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5,-180,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(15,25,45)
Instance.new("UICorner", main)

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,120,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,60,180))
}

-- TOPBAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Keyzer 💯"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- DRAG
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
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- KEY BOX
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0,260,0,45)
keyBox.Position = UDim2.new(0.5,-130,0.4,0)
keyBox.PlaceholderText = "Enter your key here..."
keyBox.BackgroundColor3 = Color3.fromRGB(20,40,80)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBox)

local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0,220,0,45)
keyBtn.Position = UDim2.new(0.5,-110,0.7,0)
keyBtn.Text = "Validate"
keyBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.85,0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1,1,1)

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
start.BackgroundColor3 = Color3.fromRGB(0,150,255)
start.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", start)

-- VALIDATION
keyBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text

    if not isValidKey(key) then
        status.Text = "Invalid key"
        return
    end

    if usedKeys[key] then
        status.Text = "Key already used"
        return
    end

    usedKeys[key] = true
    panel.Visible = true
    keyBox.Visible = false
    keyBtn.Visible = false
    status.Text = "Welcome "..LocalPlayer.Name
end)

--// ESP ROLES
local espEnabled = false

local function createESP(player)
    if player == LocalPlayer then return end

    player.CharacterAdded:Connect(function(char)
        if not espEnabled then return end

        local head = char:WaitForChild("Head")

        local bill = Instance.new("BillboardGui", head)
        bill.Size = UDim2.new(0,200,0,50)
        bill.AlwaysOnTop = true

        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.TextScaled = true

        -- ROLE FAKE (à remplacer par vrai système plus tard)
        local roles = {"Murderer","Sheriff","Innocent","Hero"}
        local role = roles[math.random(1,#roles)]

        txt.Text = role

        if role == "Murderer" then
            txt.TextColor3 = Color3.fromRGB(255,0,0)
        elseif role == "Sheriff" then
            txt.TextColor3 = Color3.fromRGB(0,150,255)
        elseif role == "Hero" then
            txt.TextColor3 = Color3.fromRGB(255,255,0)
        else
            txt.TextColor3 = Color3.fromRGB(200,200,200)
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)

-- START BUTTON
start.MouseButton1Click:Connect(function()
    espEnabled = true

    for _,p in pairs(Players:GetPlayers()) do
        if p.Character then
            createESP(p)
        end
    end
end)
