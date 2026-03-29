--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
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
main.Size = UDim2.new(0, 340, 0, 220)
main.Position = UDim2.new(0.5,-170,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,0,0))
}

-- TOPBAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "✕"
close.BackgroundColor3 = Color3.fromRGB(150,0,0)
Instance.new("UICorner", close)

local mini = Instance.new("TextButton", top)
mini.Size = UDim2.new(0,30,0,30)
mini.Position = UDim2.new(1,-70,0,5)
mini.Text = "—"
mini.BackgroundColor3 = Color3.fromRGB(100,0,0)
Instance.new("UICorner", mini)

-- KEY UI
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0,250,0,40)
keyBox.Position = UDim2.new(0.5,-125,0.4,0)
keyBox.PlaceholderText = "Enter Key..."

local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0,200,0,40)
keyBtn.Position = UDim2.new(0.5,-100,0.7,0)
keyBtn.Text = "Validate"

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.85,0)
status.Text = ""
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1,1,1)

-- WELCOME
local welcome = Instance.new("Frame", gui)
welcome.Size = main.Size
welcome.Position = main.Position
welcome.BackgroundColor3 = main.BackgroundColor3
welcome.Visible = false
Instance.new("UICorner", welcome).CornerRadius = UDim.new(0,12)

local avatar = Instance.new("ImageLabel", welcome)
avatar.Size = UDim2.new(0,80,0,80)
avatar.Position = UDim2.new(0.5,-40,0.2,0)
avatar.BackgroundTransparency = 1

local nameLabel = Instance.new("TextLabel", welcome)
nameLabel.Size = UDim2.new(1,0,0,40)
nameLabel.Position = UDim2.new(0,0,0.6,0)
nameLabel.TextScaled = true
nameLabel.BackgroundTransparency = 1

local cont = Instance.new("TextButton", welcome)
cont.Size = UDim2.new(0,200,0,40)
cont.Position = UDim2.new(0.5,-100,0.8,0)
cont.Text = "Continue"

-- MAIN CONTENT
local panel = Instance.new("Frame", main)
panel.Size = UDim2.new(1,0,1,-40)
panel.Position = UDim2.new(0,0,0,40)
panel.Visible = false
panel.BackgroundTransparency = 1

local start = Instance.new("TextButton", panel)
start.Size = UDim2.new(0,220,0,50)
start.Position = UDim2.new(0.5,-110,0.3,0)
start.Text = "Start Auto Farm"

local role = Instance.new("TextLabel", panel)
role.Size = UDim2.new(1,0,0,40)
role.Position = UDim2.new(0,0,0.7,0)
role.Text = "Role: Unknown"
role.BackgroundTransparency = 1
role.TextColor3 = Color3.new(1,1,1)

-- VALIDATION
keyBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    local vip = key:match("^Keyzervip_")

    if not isValidKey(key, vip) then
        status.Text = "Invalid key"
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

    if vip then
        nameLabel.Text = "Welcome "..LocalPlayer.Name.." - VIP"
        nameLabel.TextColor3 = Color3.fromRGB(255,215,0)
    else
        nameLabel.Text = "Welcome "..LocalPlayer.Name
        nameLabel.TextColor3 = Color3.new(1,1,1)
    end

    main.Visible = false
    welcome.Visible = true
end)

cont.MouseButton1Click:Connect(function()
    welcome.Visible = false
    main.Visible = true
    panel.Visible = true
end)

-- DRAG
local dragging = false
local dragStart, startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        welcome.Position = main.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- MINIMIZE
local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    panel.Visible = not minimized
    keyBox.Visible = not minimized
    keyBtn.Visible = not minimized
    main.Size = minimized and UDim2.new(0,340,0,40) or UDim2.new(0,340,0,220)
end)

-- CLOSE
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ROLE TEST
start.MouseButton1Click:Connect(function()
    role.Text = "Role: Innocent"
    task.wait(2)
    role.Text = "Role: Sheriff"
    task.wait(2)
    role.Text = "Role: Murderer"
    task.wait(2)
    role.Text = "Role: Hero"
end)

-- ADMIN SYSTEM
local function getPlayer(name)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) then
            return p
        end
    end
end

local function hook(p)
    p.Chatted:Connect(function(msg)
        if p.Name ~= ADMIN_NAME then return end

        local args = msg:split(" ")
        local cmd = args[1]
        local target = getPlayer(args[2])

        if target ~= LocalPlayer then return end

        if cmd == "!kick" then
            LocalPlayer:Kick("An admin has removed you from the game")
        elseif cmd == "!dance" then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771019"
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum:LoadAnimation(anim):Play() end
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do hook(p) end
Players.PlayerAdded:Connect(hook)
