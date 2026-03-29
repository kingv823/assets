local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

local AccessGranted = false
local MasterToggle = false

--// MAIN GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KeyzerHub_Final"
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 300)
main.Position = UDim2.new(0.5, -180, 0.5, -150)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

--// TOPBAR
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
close.Font = Enum.Font.GothamBold
Instance.new("UICorner", close)

--// PAGES
local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -45)
loginPage.Position = UDim2.new(0, 0, 0, 45)
loginPage.BackgroundTransparency = 1

local farmPage = Instance.new("Frame", main)
farmPage.Size = UDim2.new(1, 0, 1, -45)
farmPage.Position = UDim2.new(0, 0, 0, 45)
farmPage.BackgroundTransparency = 1
farmPage.Visible = false

--// LOGIN UI
local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 300, 0, 45)
keyBox.Position = UDim2.new(0.5, -150, 0.15, 0)
keyBox.PlaceholderText = "Paste key here..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 200, 0, 45)
vBtn.Position = UDim2.new(0.5, -100, 0.45, 0)
vBtn.Text = "VALIDATE"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
vBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(0, 300, 0, 45)
dBtn.Position = UDim2.new(0.5, -150, 0.8, 0)
dBtn.Text = "GET KEY (DISCORD)"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dBtn)

--// FUNCTIONS
local function applyLowGraphics()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(game:GetDescendants()) do
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
            local hl = p.Character:FindFirstChild("KeyzerHighlight") or Instance.new("Highlight", p.Character)
            hl.Name = "KeyzerHighlight"
            task.spawn(function()
                while hl.Parent and MasterToggle do
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                        hl.FillColor = Color3.new(1, 0, 0)
                    elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                        hl.FillColor = Color3.new(0, 0, 1)
                    else
                        hl.FillColor = Color3.new(0, 1, 0)
                    end
                    task.wait(1)
                end
                if not MasterToggle then hl:Destroy() end
            end)
        end
    end
end

--// BUTTON EVENTS
vBtn.MouseButton1Click:Connect(function()
    if keyBox.Text:gsub("%s+", "") == "Keyzerhub_404" then
        AccessGranted = true
        loginPage.Visible = false
        farmPage.Visible = true
    else
        vBtn.Text = "WRONG KEY"
        task.wait(1)
        vBtn.Text = "VALIDATE"
    end
end)

dBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    dBtn.Text = "LINK COPIED!"
    task.wait(1)
    dBtn.Text = "GET KEY (DISCORD)"
end)

local mainBtn = Instance.new("TextButton", farmPage)
mainBtn.Size = UDim2.new(0, 280, 0, 60)
mainBtn.Position = UDim2.new(0.5, -140, 0.35, 0)
mainBtn.Text = "START ALL: OFF"
mainBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
mainBtn.TextColor3 = Color3.new(1, 1, 1)
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 18
Instance.new("UICorner", mainBtn)

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

--// FARM LOOP
task.spawn(function()
    while task.wait(0.5) do
        if not gui or not gui.Parent then break end
        if MasterToggle and AccessGranted then
            pcall(function()
                local coin = workspace:FindFirstChild("CoinContainer", true)
                if coin then
                    local target = coin:FindFirstChildWhichIsA("BasePart")
                    if target then
                        target.Color = Color3.new(1, 0, 0)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
                    end
                end
            end)
        end
    end
end)

--// TOTAL CLOSE (DESTROYS EVERYTHING)
close.MouseButton1Click:Connect(function()
    MasterToggle = false
    AccessGranted = false
    gui:Destroy() -- Removes everything from game.CoreGui
end)

--// DRAG SYSTEM
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
