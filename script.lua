--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MM2_ID = 142823291
local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

--// FUNCTION FOR DRAGGING
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
    bMain.Size = UDim2.new(0, 300, 0, 200)
    bMain.Position = UDim2.new(0.5, -150, 0.5, -100)
    bMain.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", bMain)

    local bTop = Instance.new("Frame", bMain)
    bTop.Size = UDim2.new(1, 0, 0, 40)
    bTop.BackgroundTransparency = 1
    
    local bTitle = Instance.new("TextLabel", bTop)
    bTitle.Size = UDim2.new(1, 0, 1, 0)
    bTitle.Text = "Keyzer Hub"
    bTitle.TextColor3 = Color3.new(1, 1, 1)
    bTitle.Font = Enum.Font.GothamBold
    bTitle.TextSize = 18
    bTitle.BackgroundTransparency = 1

    local bLost = Instance.new("TextLabel", bMain)
    bLost.Size = UDim2.new(1, 0, 0, 60)
    bLost.Position = UDim2.new(0, 0, 0.3, 0)
    bLost.Text = "Are you lost..????"
    bLost.TextColor3 = Color3.fromRGB(255, 0, 0)
    bLost.Font = Enum.Font.GothamMedium
    bLost.TextSize = 22
    bLost.BackgroundTransparency = 1

    local bFooter = Instance.new("TextLabel", bMain)
    bFooter.Size = UDim2.new(1, 0, 0, 30)
    bFooter.Position = UDim2.new(0, 0, 0.85, 0)
    bFooter.Text = "Only for MM2"
    bFooter.TextColor3 = Color3.fromRGB(100, 100, 100)
    bFooter.Font = Enum.Font.Gotham
    bFooter.TextSize = 12
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

--// 2. MAIN HUB (IF IN MM2)
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
dBtn.Text = "GET KEY"
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

vBtn.MouseButton1Click:Connect(function()
    if keyBox.Text:gsub("%s+", "") == "Keyzerhub_404" then
        AccessGranted = true
        loginPage.Visible = false
        farmPage.Visible = true
    end
end)

mainBtn.MouseButton1Click:Connect(function()
    MasterToggle = not MasterToggle
    mainBtn.Text = "START ALL: " .. (MasterToggle and "ON" or "OFF")
    mainBtn.BackgroundColor3 = MasterToggle and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

task.spawn(function()
    while task.wait(0.5) do
        if not gui.Parent then break end
        if MasterToggle and AccessGranted then
            pcall(function()
                local coin = workspace:FindFirstChild("CoinContainer", true)
                if coin then
                    local t = coin:FindFirstChildWhichIsA("BasePart")
                    if t then
                        t.Color = Color3.new(1, 0, 0)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = t.CFrame
                    end
                end
            end)
        end
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
makeDraggable(main, top)
