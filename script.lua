--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

--// CONFIGURATION DES KEYS (Variables de session)
local SessionStartTime = 0
local SessionDuration = 300 -- 5 minutes pour la key standard
local IsVIP = false
local AccessGranted = false
local AutoFarmEnabled = false

--// FONCTION DISCORD (Ouvrir le lien)
local function OpenDiscord()
    -- Tente d'ouvrir le navigateur (dépend de l'exécuteur utilisé)
    if setclipboard then setclipboard(DISCORD_LINK) end
    if request then
        request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
            Body = HttpService:JSONEncode({cmd = "INVITE_BROWSER", args = {code = "G2KKtYjxcD"}, nonce = HttpService:GenerateGUID(false)})
        })
    end
end

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 380, 0, 260)
main.Position = UDim2.new(0.5, -190, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- FULL BLACK
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

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

local farmPage = Instance.new("Frame", main)
farmPage.Size = UDim2.new(1, 0, 1, -40)
farmPage.Position = UDim2.new(0, 0, 0, 40)
farmPage.BackgroundTransparency = 1
farmPage.Visible = false

-- LOGIN UI
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 300, 0, 45)
keyBox.Position = UDim2.new(0.5, -150, 0.15, 0)
keyBox.PlaceholderText = "Insert your key..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 140, 0, 40)
vBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
vBtn.Text = "Validate"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(0, 140, 0, 40)
dBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
dBtn.Text = "Get Key (Discord)"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord Blue
dBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dBtn)

-- --- SYSTÈME DE SESSION ---
task.spawn(function()
    while task.wait(1) do
        if AccessGranted and not IsVIP then
            local elapsed = tick() - SessionStartTime
            if elapsed >= SessionDuration then
                AccessGranted = false
                AutoFarmEnabled = false
                farmPage.Visible = false
                loginPage.Visible = true
                vBtn.Text = "Session Expired"
                vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            end
        end
    end
end)

-- --- LOGIQUE BOUTONS ---
dBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    dBtn.Text = "Link Copied!"
    OpenDiscord()
    task.wait(2)
    dBtn.Text = "Get Key (Discord)"
end)

vBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text
    if input == "Keyzer_key" or input == "Keyzervip_key" then
        IsVIP = (input == "Keyzervip_key")
        AccessGranted = true
        SessionStartTime = tick()
        
        vBtn.Text = "Welcome " .. LocalPlayer.Name .. (IsVIP and " [🌟]" or "")
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        task.wait(1.5)
        loginPage.Visible = false
        farmPage.Visible = true
        
        -- Si VIP, options supplémentaires
        if IsVIP then
            local vipLabel = Instance.new("TextLabel", farmPage)
            vipLabel.Size = UDim2.new(1,0,0,20)
            vipLabel.Text = "VIP Status: Unlimited [🌟]"
            vipLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            vipLabel.BackgroundTransparency = 1
        end
    else
        vBtn.Text = "Wrong Key!"
        task.wait(1)
        vBtn.Text = "Validate"
    end
end)

-- --- AUTO FARM & ESP (Simplifié pour le code) ---
local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 200, 0, 50)
farmToggle.Position = UDim2.new(0.5, -100, 0.3, 0)
farmToggle.Text = "Toggle Auto-Farm"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", farmToggle)

farmToggle.MouseButton1Click:Connect(function()
    if not AccessGranted then return end
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    
    if AutoFarmEnabled then
        print("Auto-farm started...")
        -- Ici tu insères ta logique de TP vers les pièces avec les maps MM2
    end
end)

-- DRAG & CLOSE
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- Lancement automatique de l'invitation au moment de l'injection
OpenDiscord()
