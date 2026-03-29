--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// CONFIG
local MM2_ID = 142823291
local FarmSpeed = 0.5 -- Par défaut (Moyen)
local AutoFarmEnabled = false
local IsVIP = false

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- FULL BLACK
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

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
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- ROUGE
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

-- LOGIN UI
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 320, 0, 40)
keyBox.Position = UDim2.new(0.5, -160, 0.2, 0)
keyBox.PlaceholderText = "Insert 50-char key here..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 200, 0, 40)
vBtn.Position = UDim2.new(0.5, -100, 0.6, 0)
vBtn.Text = "Validate"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", vBtn)

-- --- FONCTION ESP ---
local function CreateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local box = Instance.new("Highlight", p.Character)
            box.Name = "KeyzerESP"
            box.OutlineTransparency = 0
            box.FillTransparency = 0.5
            
            RunService.RenderStepped:Connect(function()
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                    box.FillColor = Color3.fromRGB(255, 0, 0) -- MURDER
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                    box.FillColor = Color3.fromRGB(0, 0, 255) -- SHERIFF
                else
                    box.FillColor = Color3.fromRGB(0, 255, 0) -- INNO
                end
            end)
        end
    end
end

-- --- AUTO FARM INTELLIGENT ---
local function StartAutoFarm()
    while AutoFarmEnabled do
        task.wait(FarmSpeed)
        local currentMap = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map")
        if currentMap then
            local container = currentMap:FindFirstChild("CoinContainer", true)
            if container then
                local coins = container:GetChildren()
                if #coins > 0 then
                    local coin = coins[1]
                    if coin:IsA("BasePart") then
                        -- Change couleur pièce en rouge
                        coin.Color = Color3.fromRGB(255, 0, 0)
                        -- TP safe (pas trop loin)
                        if (Character.PrimaryPart.Position - coin.Position).Magnitude < 150 then
                            Character:SetPrimaryPartCFrame(coin.CFrame)
                        end
                    end
                end
            end
        end
    end
end

-- --- VIP OPTIONS ---
local function SetupVIP()
    local swapBtn = Instance.new("TextButton", farmPage)
    swapBtn.Size = UDim2.new(0, 180, 0, 35)
    swapBtn.Position = UDim2.new(0, 10, 0.7, 0)
    swapBtn.Text = "Swap Skin (VIP Only)"
    swapBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    Instance.new("UICorner", swapBtn)
    
    swapBtn.MouseButton1Click:Connect(function()
        print("VIP Swap Skin Active - Visual Only")
        -- Logique simplifiée de swap visuel ici
    end)
end

-- --- VALIDATION LOGIC ---
vBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    if #key >= 50 then
        IsVIP = key:match("^Keyzervip_")
        vBtn.Text = "Welcome " .. LocalPlayer.Name .. (IsVIP and " [🌟]" or "")
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        task.wait(1.5) -- Passe tout seul
        loginPage.Visible = false
        farmPage.Visible = true
        if IsVIP then SetupVIP() end
    else
        vBtn.Text = "Key too short (Need 50)"
        task.wait(1)
        vBtn.Text = "Validate"
    end
end)

-- FARM PAGE BUTTONS
local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 180, 0, 40)
farmToggle.Position = UDim2.new(0.5, -90, 0.1, 0)
farmToggle.Text = "Auto Farm: OFF"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", farmToggle)

farmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.Text = "Auto Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    if AutoFarmEnabled then 
        CreateESP()
        spawn(StartAutoFarm) 
    end
end)

-- SPEED SELECTOR
local speedBtn = Instance.new("TextButton", farmPage)
speedBtn.Size = UDim2.new(0, 180, 0, 35)
speedBtn.Position = UDim2.new(0.5, -90, 0.35, 0)
speedBtn.Text = "Speed: Medium"
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
    if FarmSpeed == 0.5 then FarmSpeed = 1.5 speedBtn.Text = "Speed: Slow"
    elseif FarmSpeed == 1.5 then FarmSpeed = 0.1 speedBtn.Text = "Speed: Fast"
    else FarmSpeed = 0.5 speedBtn.Text = "Speed: Medium" end
end)

-- LOW GRAPHICS
local lowG = Instance.new("TextButton", farmPage)
lowG.Size = UDim2.new(0, 180, 0, 35)
lowG.Position = UDim2.new(0.5, -90, 0.55, 0)
lowG.Text = "Low Graphics"
lowG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", lowG)

lowG.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
    end
end)

-- DRAG
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
