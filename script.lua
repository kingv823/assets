local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

local AccessGranted = false
local AutoFarmEnabled = false

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 300)
main.Position = UDim2.new(0.5, -180, 0.5, -150)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BorderSizePixel = 0
Instance.new("UICorner", main)

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
close.Text = "X"
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
keyBox.PlaceholderText = "ENTRE LA KEY : Keyzerhub_404"
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 200, 0, 45)
vBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
vBtn.Text = "VALIDER"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(0, 300, 0, 40)
dBtn.Position = UDim2.new(0.5, -150, 0.8, 0)
dBtn.Text = "LIEN DISCORD"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dBtn)

--// LOGIQUE DE VALIDATION
vBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == "Keyzerhub_404" then
        AccessGranted = true
        vBtn.Text = "ACCÈS AUTORISÉ"
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.wait(1)
        loginPage.Visible = false
        farmPage.Visible = true
    else
        vBtn.Text = "MAUVAISE KEY"
        task.wait(1)
        vBtn.Text = "VALIDER"
    end
end)

dBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    dBtn.Text = "COPIÉ"
    task.wait(1)
    dBtn.Text = "LIEN DISCORD"
end)

--// PAGE FARM
local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 250, 0, 50)
farmToggle.Position = UDim2.new(0.5, -125, 0.15, 0)
farmToggle.Text = "AUTO-FARM: OFF"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
farmToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", farmToggle)

farmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.Text = "AUTO-FARM: " .. (AutoFarmEnabled and "ON" or "OFF")
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

-- LOGIQUE AUTO-FARM MM2
task.spawn(function()
    while task.wait(0.7) do
        if AutoFarmEnabled and AccessGranted then
            pcall(function()
                local container = workspace:FindFirstChild("CoinContainer", true)
                if container then
                    local target = container:FindFirstChildWhichIsA("BasePart")
                    if target then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
                    end
                end
            end)
        end
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)

--// DRAG SYSTEM
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
