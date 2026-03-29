--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MM2_ID = 142823291
local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

--// DRAG FUNCTION
local function makeDraggable(obj, dragPart)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// 1. MINI BLOCKER (IF NOT MM2)
if game.PlaceId ~= MM2_ID then
    local blockGui = Instance.new("ScreenGui", game.CoreGui)
    local bMain = Instance.new("Frame", blockGui)
    bMain.Size = UDim2.new(0, 300, 0, 180)
    bMain.Position = UDim2.new(0.5, -150, 0.5, -90)
    bMain.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", bMain)

    local bTop = Instance.new("Frame", bMain)
    bTop.Size = UDim2.new(1, 0, 0, 35)
    bTop.BackgroundTransparency = 1
    
    local bTitle = Instance.new("TextLabel", bTop)
    bTitle.Size = UDim2.new(1, 0, 1, 0)
    bTitle.Text = "Keyzer Hub"
    bTitle.TextColor3 = Color3.new(1, 1, 1)
    bTitle.Font = Enum.Font.GothamBold
    bTitle.TextSize = 16
    bTitle.BackgroundTransparency = 1

    local bLost = Instance.new("TextLabel", bMain)
    bLost.Size = UDim2.new(1, 0, 0, 40)
    bLost.Position = UDim2.new(0, 0, 0.4, 0)
    bLost.Text = "Are you lost..????"
    bLost.TextColor3 = Color3.fromRGB(255, 0, 0)
    bLost.Font = Enum.Font.GothamMedium
    bLost.TextSize = 20
    bLost.BackgroundTransparency = 1

    local bFooter = Instance.new("TextLabel", bMain)
    bFooter.Size = UDim2.new(1, 0, 0, 20)
    bFooter.Position = UDim2.new(0, 0, 0.9, 0)
    bFooter.Text = "Only for MM2"
    bFooter.TextColor3 = Color3.fromRGB(100, 100, 100)
    bFooter.Font = Enum.Font.Gotham
    bFooter.TextSize = 11
    bFooter.BackgroundTransparency = 1

    local bClose = Instance.new("TextButton", bMain)
    bClose.Size = UDim2.new(0, 80, 0, 30)
    bClose.Position = UDim2.new(0.5, -40, 0.65, 0)
    bClose.Text = "CLOSE"
    bClose.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bClose.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", bClose)
    
    bClose.MouseButton1Click:Connect(function() blockGui:Destroy() end)
    makeDraggable(bMain, bTop)
    return
end

--// 2. MAIN HUB
local AccessGranted = false
local MasterToggle = false

local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 300)
main.Position = UDim2.new(0.5, -180, 0.5, -150)
main.BackgroundColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", main)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Keyzer Hub 💯"
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

local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -45)
loginPage.Position = UDim2.new(0, 0, 0, 45)
loginPage.BackgroundTransparency = 1

local farmPage = Instance.new("Frame", main)
farmPage.Size = UDim2.new(1, 0, 1, -45)
farmPage.Position = UDim2.new(0, 0, 0, 45)
farmPage.BackgroundTransparency = 1
farmPage.Visible = false

local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 300, 0, 45)
keyBox.Position = UDim2.new(0.5, -150, 0.15, 0)
keyBox.PlaceholderText = "Enter Key..."
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 200, 0, 45)
vBtn.Position = UDim2.new(0.5, -100, 0.45, 0)
vBtn.Text = "VALIDATE"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(0, 300, 0, 45)
dBtn.Position = UDim2.new(0.5, -150, 0.8, 0)
dBtn.Text = "GET KEY (DISCORD)"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", dBtn)

local mainBtn = Instance.new("TextButton", farmPage)
mainBtn.Size = UDim2.new(0, 280, 0, 60)
mainBtn.Position = UDim2.new(0.5, -140, 0.35, 0)
mainBtn.Text = "START ALL: OFF"
mainBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
mainBtn.TextColor3 = Color3.new(1, 1, 1)
mainBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", mainBtn)

--// FUNCTIONS (LOW GFX & ESP)
local function applyLowGraphics()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
end

local function applyESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("KeyzerESP") or Instance.new("Highlight", p.Character)
            hl.Name = "KeyzerESP"
            task.spawn(function()
                while hl.Parent and MasterToggle do
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                        hl.FillColor = Color3.fromRGB(255, 0, 0) -- Murder
                    elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                        hl.FillColor = Color3.fromRGB(0, 0, 255) -- Sheriff
                    else
                        hl.FillColor = Color3.fromRGB(0, 255, 0) -- Innocent
                    end
                    task.wait(1)
                end
                if not MasterToggle then hl:Destroy() end
            end)
        end
    end
end

--// LOGIC
vBtn.MouseButton1Click:Connect(function()
    if keyBox.Text:gsub("%s+", "") == "Keyzerhub_404" then
        AccessGranted = true
        loginPage.Visible = false
        farmPage.Visible = true
    end
end)

dBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    dBtn.Text = "LINK COPIED!"
    task.wait(1)
    dBtn.Text = "GET KEY (DISCORD)"
end)

mainBtn.MouseButton1Click:Connect(function()
    MasterToggle = not MasterToggle
    if MasterToggle then
        mainBtn.Text = "START ALL: ON"
        mainBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        applyLowGraphics()
        applyESP()
    else
        mainBtn.Text = "START ALL: OFF"
        mainBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

--// MAIN LOOP
task.spawn(function()
    while task.wait(0.5) do
        if not gui.Parent then break end
        if MasterToggle and AccessGranted then
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local coinContainer = workspace:FindFirstChild("CoinContainer", true)
                    if coinContainer then
                        local target = coinContainer:FindFirstChildWhichIsA("BasePart")
                        if target then
                            local distance = (hrp.Position - target.Position).Magnitude
                            if distance < 250 then
                                target.Color = Color3.new(1, 0, 0)
                                hrp.CFrame = target.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
makeDraggable(main, top)
