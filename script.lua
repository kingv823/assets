--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

--// ETAT DU SCRIPT
local IsVIP = false
local AccessGranted = false
local SessionStartTime = 0
local AutoFarmEnabled = false
local FarmSpeed = 0.6

--// FONCTION DE VERIFICATION ULTRA PRECISE
local function validateKey(input)
    local separator = input:find("_")
    if not separator then return false, "Missing '_' separator" end
    
    local prefix = input:sub(1, separator - 1)
    local keyBody = input:sub(separator + 1)
    
    -- 1. Verif Longueur (50 pile après le _)
    if #keyBody ~= 50 then 
        return false, "Key body must be 50 chars (Current: "..#keyBody..")" 
    end

    -- 2. Verif Majuscules (Minimum 3)
    local uppers = 0
    for i = 1, #keyBody do
        if keyBody:sub(i,i):match("%u") then uppers = uppers + 1 end
    end
    
    if uppers < 3 then 
        return false, "Need 3+ Uppercases in key" 
    end

    return true, prefix
end

--// GUI CONSTRUCTION
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.5, -160)
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

-- CONTENEURS
local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -45)
loginPage.Position = UDim2.new(0, 0, 0, 45)
loginPage.BackgroundTransparency = 1

local farmPage = loginPage:Clone()
farmPage.Parent = main
farmPage.Visible = false

-- LOGIN UI
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 340, 0, 50)
keyBox.Position = UDim2.new(0.5, -170, 0.1, 0)
keyBox.PlaceholderText = "Paste your 50-char key here..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.ClearTextOnFocus = false
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 220, 0, 45)
vBtn.Position = UDim2.new(0.5, -110, 0.4, 0)
vBtn.Text = "Validate Access"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
vBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(0, 340, 0, 45)
dBtn.Position = UDim2.new(0.5, -170, 0.8, 0)
dBtn.Text = "Get Key on Discord"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dBtn)

-- --- LOGIQUE BOUTONS ---
dBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_LINK)
    dBtn.Text = "Link Copied!"
    task.wait(2)
    dBtn.Text = "Get Key on Discord"
end)

vBtn.MouseButton1Click:Connect(function()
    local success, result = validateKey(keyBox.Text)
    if success then
        IsVIP = (result == "Keyzervip")
        AccessGranted = true
        SessionStartTime = tick()
        
        vBtn.Text = "Welcome " .. LocalPlayer.Name .. (IsVIP and " [🌟]" or "")
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        task.wait(1.5)
        loginPage.Visible = false
        farmPage.Visible = true
    else
        vBtn.Text = result
        vBtn.TextSize = 12
        task.wait(2)
        vBtn.Text = "Validate Access"
        vBtn.TextSize = 18
    end
end)

-- --- ESP & FARM (DANS LE PANEL) ---
local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 250, 0, 50)
farmToggle.Position = UDim2.new(0.5, -125, 0.1, 0)
farmToggle.Text = "Auto-Farm: OFF"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
farmToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", farmToggle)

farmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.Text = "Auto-Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    
    -- ESP ACTIF DES QU'ON LANCE L'AUTOFARM
    if AutoFarmEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillTransparency = 0.5
                task.spawn(function()
                    while h.Parent do
                        if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                            h.FillColor = Color3.new(1, 0, 0) -- RED
                        elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                            h.FillColor = Color3.new(0, 0, 1) -- BLUE
                        else
                            h.FillColor = Color3.new(0, 1, 0) -- GREEN
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    end
end)

-- AUTO-FARM LOOP
task.spawn(function()
    while true do
        task.wait(FarmSpeed)
        if AutoFarmEnabled and AccessGranted then
            local container = workspace:FindFirstChild("CoinContainer", true)
            if container then
                local coin = container:GetChildren()[11] or container:FindFirstChildWhichIsA("BasePart")
                if coin then
                    LocalPlayer.Character:SetPrimaryPartCFrame(coin.CFrame)
                end
            end
        end
    end
end)

-- TIMER SESSION (STANDARD)
task.spawn(function()
    while task.wait(1) do
        if AccessGranted and not IsVIP then
            if tick() - SessionStartTime >= 300 then
                gui:Destroy()
            end
        end
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
-- DRAG SYSTEM
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
