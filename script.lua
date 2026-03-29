--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

--// VARIABLES DE SESSION
local IsVIP = false
local AccessGranted = false
local SessionStartTime = 0
local AutoFarmEnabled = false

--// VALIDATEUR DE CLÉ (ALGORITHMIQUE)
local function validateStructure(input)
    local separator = input:find("_")
    if not separator then return false, "Format: Prefix_Key" end
    
    local prefix = input:sub(1, separator - 1)
    local keyBody = input:sub(separator + 1)
    
    -- Verif Prefixe
    if prefix ~= "Keyzerfree" and prefix ~= "Keyzervip" then
        return false, "Invalid Prefix"
    end
    
    -- Verif Longueur (On autorise une petite marge au cas où)
    if #keyBody < 35 then 
        return false, "Key too short (Need 35)" 
    end

    -- Comptage Majuscules et Chiffres
    local uppers, digits = 0, 0
    for i = 1, #keyBody do
        local char = keyBody:sub(i,i)
        if char:match("%u") then uppers = uppers + 1 end
        if char:match("%d") then digits = digits + 1 end
    end
    
    if uppers < 4 then return false, "Need 4+ Uppercases" end
    if digits < 16 then return false, "Need 16+ Digits" end

    return true, prefix
end

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 300)
main.Position = UDim2.new(0.5, -180, 0.5, -150)
main.BackgroundColor3 = Color3.new(0, 0, 0) -- FULL BLACK
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- TOPBAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -38, 0, 7)
close.Text = "✖️"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

-- PAGES
local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -45)
loginPage.Position = UDim2.new(0, 0, 0, 45)
loginPage.BackgroundTransparency = 1

local farmPage = Instance.new("Frame", main)
farmPage.Size = UDim2.new(1, 0, 1, -45)
farmPage.Position = UDim2.new(0, 0, 0, 45)
farmPage.BackgroundTransparency = 1
farmPage.Visible = false

-- UI LOGIN
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 300, 0, 45)
keyBox.Position = UDim2.new(0.5, -150, 0.1, 0)
keyBox.PlaceholderText = "Insert your key..."
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
dBtn.Size = UDim2.new(1, 0, 0, 40)
dBtn.Position = UDim2.new(0, 0, 0.85, 0)
dBtn.Text = "Discord (Get Key)"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dBtn)

-- --- FONCTION ESP ---
local function EnableESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            RunService.RenderStepped:Connect(function()
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                    h.FillColor = Color3.new(1, 0, 0) -- Murd
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                    h.FillColor = Color3.new(0, 0, 1) -- Sherif
                else
                    h.FillColor = Color3.new(0, 1, 0) -- Inno
                end
            end)
        end
    end
end

-- --- LOGIQUE VALIDATION ---
vBtn.MouseButton1Click:Connect(function()
    local success, prefix = validateStructure(keyBox.Text)
    if success then
        IsVIP = (prefix == "Keyzervip")
        AccessGranted = true
        SessionStartTime = tick()
        vBtn.Text = "Welcome " .. LocalPlayer.Name .. (IsVIP and " [🌟]" or "")
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        task.wait(1.5)
        loginPage.Visible = false
        farmPage.Visible = true
        EnableESP()
    else
        vBtn.Text = prefix
        task.wait(2)
        vBtn.Text = "Validate"
    end
end)

dBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    dBtn.Text = "Link Copied!"
    task.wait(1)
    dBtn.Text = "Discord (Get Key)"
end)

-- --- PAGE FARM (AUTO FARM & LOW GRAPHICS) ---
local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 250, 0, 50)
farmToggle.Position = UDim2.new(0.5, -125, 0.15, 0)
farmToggle.Text = "Auto-Farm: OFF"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
farmToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", farmToggle)

local lowG = Instance.new("TextButton", farmPage)
lowG.Size = UDim2.new(0, 250, 0, 50)
lowG.Position = UDim2.new(0.5, -125, 0.5, 0)
lowG.Text = "Low Graphics"
lowG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
lowG.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", lowG)

farmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.Text = "Auto-Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

-- LOGIQUE AUTO-FARM (SCAN DES MAPS MM2)
task.spawn(function()
    while task.wait(0.8) do
        if AutoFarmEnabled and AccessGranted then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Cherche le container des pièces
                    local container = workspace:FindFirstChild("CoinContainer", true)
                    if container then
                        local coin = container:FindFirstChildWhichIsA("BasePart")
                        if coin then
                            coin.Color = Color3.fromRGB(255, 0, 0) -- Pièce devient rouge
                            char.HumanoidRootPart.CFrame = coin.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

lowG.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
    end
    lowG.Text = "Graphics: LOW ✅"
end)

-- SESSION TIMER (5 MIN POUR FREE)
task.spawn(function()
    while task.wait(1) do
        if AccessGranted and not IsVIP then
            if tick() - SessionStartTime >= 300 then gui:Destroy() end
        end
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- DRAG SYSTEM
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
