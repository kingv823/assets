--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

--// VARIABLES DE SESSION
local SessionStartTime = 0
local SessionDuration = 300 -- 5 minutes pour Standard
local IsVIP = false
local AccessGranted = false
local AutoFarmEnabled = false
local FarmSpeed = 0.5

--// FONCTION DE VÉRIFICATION DE KEY (STRICTE)
local function checkKey(input)
    local prefix, keyBody = input:match("^(Keyzer[vip]*)_(.*)$")
    
    if not keyBody or #keyBody ~= 50 then 
        return false, "Key must be 50 chars after _" 
    end

    local upperCount = 0
    for i = 1, #keyBody do
        if keyBody:sub(i,i):match("%u") then upperCount = upperCount + 1 end
    end

    if upperCount < 3 then 
        return false, "Need at least 3 Uppercase" 
    end

    return true, prefix
end

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- FULL BLACK
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- BARRE DE TITRE
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

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "✖️"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

-- PAGES
local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -40)
loginPage.Position = UDim2.new(0, 0, 0, 40)
loginPage.BackgroundTransparency = 1

local farmPage = loginPage:Clone()
farmPage.Parent = main
farmPage.Visible = false

-- UI LOGIN
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 340, 0, 45)
keyBox.Position = UDim2.new(0.5, -170, 0.1, 0)
keyBox.PlaceholderText = "Insert your 50-char key here..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 200, 0, 45)
vBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
vBtn.Text = "Validate"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(0, 340, 0, 40)
dBtn.Position = UDim2.new(0.5, -170, 0.8, 0) -- BOUTON DISCORD EN BAS
dBtn.Text = "Get Key (Discord)"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dBtn)

-- --- LOGIQUE ESP ---
local function CreateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = Instance.new("Highlight", p.Character)
            RunService.RenderStepped:Connect(function()
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Murd = Rouge
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Sherif = Bleu
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Inno = Vert
                end
            end)
        end
    end
end

-- --- AUTO FARM ---
local function StartAutoFarm()
    while AutoFarmEnabled do
        task.wait(FarmSpeed)
        local map = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map")
        if map then
            local container = map:FindFirstChild("CoinContainer", true)
            if container then
                local coin = container:GetChildren()[11] or container:FindFirstChildWhichIsA("BasePart")
                if coin and (LocalPlayer.Character.PrimaryPart.Position - coin.Position).Magnitude < 200 then
                    coin.Color = Color3.fromRGB(255, 0, 0) -- Pièce devient rouge
                    LocalPlayer.Character:SetPrimaryPartCFrame(coin.CFrame)
                end
            end
        end
    end
end

-- --- VALIDATION ---
vBtn.MouseButton1Click:Connect(function()
    local success, result = checkKey(keyBox.Text)
    if success then
        IsVIP = (result == "Keyzervip")
        AccessGranted = true
        SessionStartTime = tick()
        
        vBtn.Text = "Welcome " .. LocalPlayer.Name .. (IsVIP and " [🌟]" or "")
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        task.wait(2) -- Transition automatique
        loginPage.Visible = false
        farmPage.Visible = true
        CreateESP()
    else
        vBtn.Text = result
        task.wait(1.5)
        vBtn.Text = "Validate"
    end
end)

dBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_LINK)
    dBtn.Text = "Link Copied!"
    task.wait(2)
    dBtn.Text = "Get Key (Discord)"
end)

-- --- FARM PAGE CONTENT ---
local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 200, 0, 50)
farmToggle.Position = UDim2.new(0.5, -100, 0.1, 0)
farmToggle.Text = "Auto-Farm: OFF"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", farmToggle)

farmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.Text = "Auto-Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    if AutoFarmEnabled then task.spawn(StartAutoFarm) end
end)

-- SPEED SLIDER (Simplified)
local speedBtn = Instance.new("TextButton", farmPage)
speedBtn.Size = UDim2.new(0, 150, 0, 35)
speedBtn.Position = UDim2.new(0.5, -75, 0.35, 0)
speedBtn.Text = "Speed: Medium"
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
    if FarmSpeed == 0.5 then FarmSpeed = 1.2 speedBtn.Text = "Speed: Slow"
    elseif FarmSpeed == 1.2 then FarmSpeed = 0.05 speedBtn.Text = "Speed: Fast"
    else FarmSpeed = 0.5 speedBtn.Text = "Speed: Medium" end
end)

-- LOW GRAPHICS
local lowG = Instance.new("TextButton", farmPage)
lowG.Size = UDim2.new(0, 150, 0, 35)
lowG.Position = UDim2.new(0.5, -75, 0.55, 0)
lowG.Text = "Low Graphics"
lowG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", lowG)

lowG.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
    end
end)

-- DRAG & CLOSE
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- Session Timer (Standard only)
task.spawn(function()
    while task.wait(1) do
        if AccessGranted and not IsVIP then
            if tick() - SessionStartTime >= SessionDuration then
                gui:Destroy() -- Kick du script après 5 min
            end
        end
    end
end)
