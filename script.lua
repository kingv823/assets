-- 🔴 GUI PRINCIPAL
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 200)
main.Position = UDim2.new(0.5, -160, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
main.BorderSizePixel = 0

-- coins arrondis
local uiCorner = Instance.new("UICorner", main)
uiCorner.CornerRadius = UDim.new(0, 10)

-- 🔝 TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 35)
top.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
top.BorderSizePixel = 0

local topCorner = Instance.new("UICorner", top)
topCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- ❌ CLOSE
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 2)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170, 0, 0)

-- ➖ MINIMIZE
local mini = Instance.new("TextButton", top)
mini.Size = UDim2.new(0, 30, 0, 30)
mini.Position = UDim2.new(1, -70, 0, 2)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(140, 0, 0)

-- 📦 CONTENU
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1

-- 🎮 BOUTON
local startBtn = Instance.new("TextButton", content)
startBtn.Size = UDim2.new(0, 220, 0, 50)
startBtn.Position = UDim2.new(0.5, -110, 0.3, 0)
startBtn.Text = "Start Auto Farm"
startBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local btnCorner = Instance.new("UICorner", startBtn)
btnCorner.CornerRadius = UDim.new(0, 8)

-- 🏷️ ROLE
local roleLabel = Instance.new("TextLabel", content)
roleLabel.Size = UDim2.new(1, 0, 0, 40)
roleLabel.Position = UDim2.new(0, 0, 0.7, 0)
roleLabel.Text = "Role: Unknown"
roleLabel.TextColor3 = Color3.new(1,1,1)
roleLabel.BackgroundTransparency = 1

-- 🖱️ DRAG SYSTEM
local dragging, dragInput, dragStart, startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ➖ MINIMIZE ACTION
local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.new(0,320,0,35) or UDim2.new(0,320,0,200)
end)

-- ❌ CLOSE ACTION
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 🎭 ROLE TEST
startBtn.MouseButton1Click:Connect(function()
    roleLabel.Text = "Role: Innocent"
    wait(2)
    roleLabel.Text = "Role: Sheriff"
    wait(2)
    roleLabel.Text = "Role: Murderer"
    wait(2)
    roleLabel.Text = "Role: Hero"
end)
